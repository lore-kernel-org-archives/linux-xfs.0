Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667EF433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992344; cv=none; b=ZzyRlMOAfkd0fe1lPCmMDu4ic01rFHSnYtncyJu2MMDGzbr5zUwJLpF/GqrL3rrMu+lrr6CU8ZyMHsb8gJTlGYYXcnMpWTEp2SuoBdC2XqV4s5x9/nt0Is2OHbIw5yu/AHUFcgmW5kgtivI2v/+bHJIGMkyvmXmZNbbhf1FlDPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992344; c=relaxed/simple;
	bh=szUAwoQpH33ZyfTbGjooTag/k8w/1m+f3udSAmURlVw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rLfOEKsGY8b417ufH2JosR5FbXVf2KpRNW1l5LFwci4/3GVcKOP4UBWdIUy3mx62OBH3if7Ii1f6IvwCV8YR8tXiCF/pzUdLNYQYBzwmQgptJIEZReN7ZWwNBs7uMGpQp2/eYYrrCQXq2oFEVCTTaS+748oPKf/tENvG6Se7VEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AqMFUdoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AqMFUdoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACD6C4CED7;
	Mon, 23 Dec 2024 22:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992344;
	bh=szUAwoQpH33ZyfTbGjooTag/k8w/1m+f3udSAmURlVw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AqMFUdoQvNYVXvCs4jjPu7qdr6QihO0RCHigd24E3RM2WOgaiQYD4CQzzDwfindH0
	 hoewNScn9ntwCPiv5dDHr/GuO2nrWXD+VQJP73chTJCFRbPazgj9Fc5Cd+J93W0UlX
	 sb1HEZZBgmecgMSZDKbyAyfLNcgxl4yVG38QY91hGnlBlI/vWYJgnIQZk2IxFGzYjr
	 RWO6h5md5sZ6JZkcVG9R6G/O1zfa/S0w/7s86IVFJOtdGUy9YzoKJofga/RjG0vCfP
	 DbSsOPvMLzsDKJ0hH6K5E5uYarIDUsqixE/K/wzx9E/cHah9pyVYqTNs7D+gT94AZo
	 QDWEANFpHD3tw==
Date: Mon, 23 Dec 2024 14:19:03 -0800
Subject: [PATCH 28/51] xfs_db: support changing the label and uuid of rt
 superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944232.2297565.2615155124288355078.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/sb.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 98 insertions(+), 11 deletions(-)


diff --git a/db/sb.c b/db/sb.c
index de248c10cb27f5..aa8fce6712e571 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -27,6 +27,7 @@ static int	label_f(int argc, char **argv);
 static void     label_help(void);
 static int	version_f(int argc, char **argv);
 static void     version_help(void);
+static size_t check_label(char *label, bool can_warn);
 
 static const cmdinfo_t	sb_cmd =
 	{ "sb", NULL, sb_f, 0, 1, 1, N_("[agno]"),
@@ -332,6 +333,65 @@ uuid_help(void)
 ));
 }
 
+static bool
+check_rtsb(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	if (!xfs_has_realtime(mp) || !xfs_has_rtsb(mp))
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
+update_rtsb(
+	struct xfs_mount	*mp,
+	uuid_t			*uuid,
+	char			*label)
+{
+	struct xfs_rtsb		*rsb;
+	int			error;
+
+	if (!xfs_has_rtsb(mp) || !xfs_has_realtime(mp))
+		return false;
+
+	push_cur();
+	error = set_rt_cur(&typtab[TYP_RTSB], XFS_RTSB_DADDR,
+			XFS_FSB_TO_BB(mp, 1), DB_RING_ADD, NULL);
+	if (error == ENODEV) {
+		/* no rt dev means we should just bail out */
+		exitcode = 1;
+		pop_cur();
+		return 1;
+	}
+
+	rsb = iocur_top->data;
+	if (label) {
+		size_t	len = check_label(label, false);
+
+		memset(&rsb->rsb_fname, 0, XFSLABEL_MAX);
+		memcpy(&rsb->rsb_fname, label, len);
+	}
+	if (uuid)
+		memcpy(&rsb->rsb_uuid, uuid, sizeof(rsb->rsb_uuid));
+	write_cur();
+	pop_cur();
+
+	return 0;
+}
+
 static uuid_t *
 do_uuid(xfs_agnumber_t agno, uuid_t *uuid)
 {
@@ -376,6 +436,7 @@ do_uuid(xfs_agnumber_t agno, uuid_t *uuid)
 	memcpy(&tsb.sb_uuid, uuid, sizeof(uuid_t));
 	libxfs_sb_to_disk(iocur_top->data, &tsb);
 	write_cur();
+	memcpy(&mp->m_sb.sb_uuid, uuid, sizeof(uuid_t));
 	return uuid;
 }
 
@@ -438,11 +499,18 @@ uuid_f(
 			}
 		}
 
+		if (check_rtsb(mp)) {
+			exitcode = 1;
+			return 0;
+		}
+
 		/* clear the log (setting uuid) if it's not dirty */
 		if (!sb_logzero(&uu))
 			return 0;
 
 		dbprintf(_("writing all SBs\n"));
+		if (update_rtsb(mp, &uu, NULL))
+			return 1;
 		for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
 			if (!do_uuid(agno, &uu)) {
 				dbprintf(_("failed to set UUID in AG %d\n"), agno);
@@ -511,6 +579,27 @@ label_help(void)
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
@@ -529,22 +618,13 @@ do_label(xfs_agnumber_t agno, char *label)
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
 	libxfs_sb_to_disk(iocur_top->data, &tsb);
 	write_cur();
+	memcpy(&mp->m_sb.sb_fname, &tsb.sb_fname, XFSLABEL_MAX);
 	return &lbl[0];
 }
 
@@ -576,7 +656,14 @@ label_f(
 			return 0;
 		}
 
+		if (check_rtsb(mp)) {
+			exitcode = 1;
+			return 0;
+		}
+
 		dbprintf(_("writing all SBs\n"));
+		if (update_rtsb(mp, NULL, argv[1]))
+			return 1;
 		for (ag = 0; ag < mp->m_sb.sb_agcount; ag++)
 			if ((p = do_label(ag, argv[1])) == NULL) {
 				dbprintf(_("failed to set label in AG %d\n"), ag);

