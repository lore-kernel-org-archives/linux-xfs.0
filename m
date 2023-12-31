Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21851C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQLsV4zy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEC3C433C8;
	Sun, 31 Dec 2023 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066939;
	bh=LehgrD89rLo5nOgRGAyLdvLghdAIdQtRTLlETjgvvzQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SQLsV4zye3Rd5HmoZdyCkXb5hXq0ZPD4ph5qxVcw8+nHT3aywSbABsaBdizGXJs4p
	 7zypXi9tQc8tfO+r1KXK+IiHY9ziiKWjevQd9AZ3amVAhIZtah4buAqHsKoutNUL7R
	 LXuBJmqqa7hf+zn+95UPeeoyDOWSBvJKs8NazbKmDcHV2lBWcuMH+SMIgTetHgjpSm
	 bnV8/MqYVnIbXN0mIwJr78wz3iLBhYlalqqOvKpG3Uys6JemA90Y+5jRdOMr31ScUc
	 P/jqxPEb0PiDkCdr1I+/l6j2mqDwKyMpVuad3jikSh8YZgOBi95rhrtlqQBdoozNiX
	 nSslFbC73Vp4w==
Date: Sun, 31 Dec 2023 15:55:39 -0800
Subject: [PATCH 31/52] xfs_db: support changing the label and uuid of rt
 superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012580.1811243.8865135660885731705.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update the label and uuid commands to change the rt superblocks along
with the filesystem superblocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c |  119 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 108 insertions(+), 11 deletions(-)


diff --git a/db/sb.c b/db/sb.c
index d315bb1dd28..ce04f489adf 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -27,6 +27,7 @@ static int	label_f(int argc, char **argv);
 static void     label_help(void);
 static int	version_f(int argc, char **argv);
 static void     version_help(void);
+static size_t check_label(char *label, bool can_warn);
 
 static const cmdinfo_t	sb_cmd =
 	{ "sb", NULL, sb_f, 0, 1, 1, N_("[agno]"),
@@ -356,6 +357,77 @@ uuid_help(void)
 ));
 }
 
+static bool
+check_rtgroup_update_problems(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	if (!xfs_has_rtgroups(mp) || mp->m_sb.sb_rgcount == 0)
+		return false;
+
+	push_cur();
+	error = set_rt_cur(&typtab[TYP_RTSB], XFS_RTSB_DADDR,
+			XFS_FSB_TO_BB(mp, 1), DB_RING_ADD, NULL);
+	if (error == ENODEV) {
+		/* no rt dev means we should just bail out */
+		pop_cur();
+		return true;
+	}
+
+	pop_cur();
+	return false;
+}
+
+static int
+update_rt_supers(
+	struct xfs_mount	*mp,
+	uuid_t			*uuid,
+	char			*label)
+{
+	uuid_t			old_uuid;
+	xfs_rgnumber_t		rgno;
+	int			error;
+
+	if (uuid)
+		memcpy(&old_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
+
+	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
+		struct xfs_rtsb	*rsb;
+		xfs_rtblock_t	rtbno;
+
+		push_cur();
+		rtbno = xfs_rgbno_to_rtb(mp, rgno, 0);
+		error = set_rt_cur(&typtab[TYP_RTSB],
+				xfs_rtb_to_daddr(mp, rtbno),
+				XFS_FSB_TO_BB(mp, 1), DB_RING_ADD, NULL);
+		if (error == ENODEV) {
+			/* no rt dev means we should just bail out */
+			exitcode = 1;
+			pop_cur();
+			return 1;
+		}
+
+		rsb = iocur_top->data;
+		if (label) {
+			size_t	len = check_label(label, false);
+
+			memset(&rsb->rsb_fname, 0, XFSLABEL_MAX);
+			memcpy(&rsb->rsb_fname, label, len);
+		}
+		if (uuid) {
+			memcpy(&mp->m_sb.sb_uuid, uuid, sizeof(uuid_t));
+			memcpy(&rsb->rsb_uuid, uuid, sizeof(rsb->rsb_uuid));
+		}
+		write_cur();
+		if (uuid)
+			memcpy(&mp->m_sb.sb_uuid, &old_uuid, sizeof(uuid_t));
+		pop_cur();
+	}
+
+	return 0;
+}
+
 static uuid_t *
 do_uuid(xfs_agnumber_t agno, uuid_t *uuid)
 {
@@ -462,11 +534,18 @@ uuid_f(
 			}
 		}
 
+		if (check_rtgroup_update_problems(mp)) {
+			exitcode = 1;
+			return 0;
+		}
+
 		/* clear the log (setting uuid) if it's not dirty */
 		if (!sb_logzero(&uu))
 			return 0;
 
 		dbprintf(_("writing all SBs\n"));
+		if (update_rt_supers(mp, &uu, NULL))
+			return 1;
 		for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
 			if (!do_uuid(agno, &uu)) {
 				dbprintf(_("failed to set UUID in AG %d\n"), agno);
@@ -535,6 +614,27 @@ label_help(void)
 ));
 }
 
+static size_t
+check_label(
+	char	*label,
+	bool	can_warn)
+{
+	size_t	len = strlen(label);
+
+	if (len > XFSLABEL_MAX) {
+		if (can_warn)
+			dbprintf(_("%s: truncating label length from %d to %d\n"),
+				progname, (int)len, XFSLABEL_MAX);
+		len = XFSLABEL_MAX;
+	}
+	if ( len == 2 &&
+	     (strcmp(label, "\"\"") == 0 ||
+	      strcmp(label, "''")   == 0 ||
+	      strcmp(label, "--")   == 0) )
+		label[0] = label[1] = '\0';
+	return len;
+}
+
 static char *
 do_label(xfs_agnumber_t agno, char *label)
 {
@@ -553,17 +653,7 @@ do_label(xfs_agnumber_t agno, char *label)
 		return &lbl[0];
 	}
 	/* set label */
-	if ((len = strlen(label)) > sizeof(tsb.sb_fname)) {
-		if (agno == 0)
-			dbprintf(_("%s: truncating label length from %d to %d\n"),
-				progname, (int)len, (int)sizeof(tsb.sb_fname));
-		len = sizeof(tsb.sb_fname);
-	}
-	if ( len == 2 &&
-	     (strcmp(label, "\"\"") == 0 ||
-	      strcmp(label, "''")   == 0 ||
-	      strcmp(label, "--")   == 0) )
-		label[0] = label[1] = '\0';
+	len = check_label(label, agno == 0);
 	memset(&tsb.sb_fname, 0, sizeof(tsb.sb_fname));
 	memcpy(&tsb.sb_fname, label, len);
 	memcpy(&lbl[0], &tsb.sb_fname, sizeof(tsb.sb_fname));
@@ -600,7 +690,14 @@ label_f(
 			return 0;
 		}
 
+		if (check_rtgroup_update_problems(mp)) {
+			exitcode = 1;
+			return 0;
+		}
+
 		dbprintf(_("writing all SBs\n"));
+		if (update_rt_supers(mp, NULL, argv[1]))
+			return 1;
 		for (ag = 0; ag < mp->m_sb.sb_agcount; ag++)
 			if ((p = do_label(ag, argv[1])) == NULL) {
 				dbprintf(_("failed to set label in AG %d\n"), ag);

