Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB9A28F4
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610220; cv=none; b=DAMCk2GNXeCPIWeN8MXNwxCF2/RMBIHXqHacDSlfhIUAMGJTqESUuNt/2WFqe/uJWqKCrK2+GNR1H3jsdz+BqeN75ikM/FBo8Wb/n6O+Igh8vYaAbPWM5AUWlQMBg1tGtJuJiVon9OQc+OO6UI1pwamNFgNVIHntIev+L0UwrwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610220; c=relaxed/simple;
	bh=f/okaaXRwJC/2CN00ySMx9pvwQDWQlkTE7OPvfaaDhw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dqZVI++Ws6ApUm3Om280u6Abfj6oBdoSILmABbRztxnbydaaiwyqFafg39fN7bCaZc0U+5FGYh0wKx724h+t6bwkFutNBBNR5nkdDBU3p8+Iib5Q5lfeABPJbJxnUckcia6+73I5Xz/BO5Sx0tp4mnM7s4uQnTl9m7t4b4svPac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TKSk5PqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKSk5PqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7696CC4CEC5;
	Fri, 11 Oct 2024 01:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610218;
	bh=f/okaaXRwJC/2CN00ySMx9pvwQDWQlkTE7OPvfaaDhw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TKSk5PqFmP93umtHy8lppo6EKpZOQApvEFokJASxDreTyHOONhkk5pf0JotQOQGJY
	 m+Aoo/bTEx+sdThBJjmcRhPd7Dd7S7UztTavg7ogbs8rwpiwqMrZl/O3kn5DlQRpZC
	 O9zBlW6MQYvOQIifeckCshS+O6NXBDZ9+xGMPntbUPA1nH5jYui7o0h6o/g7DShMHE
	 ScX7M+GVIbZgcslYyW1MHxPcRitKr3T6DzmU4Ny4bY53xW/WPork3D/vRP8sS+XFXX
	 4EeL8JFFmaW0HbRXbfdN8YLD60A8G48estg1T40YFe3TUcZQne25unjGReYjYJdnvd
	 lAp+dlyk2yllw==
Date: Thu, 10 Oct 2024 18:30:18 -0700
Subject: [PATCH 22/43] xfs_db: support changing the label and uuid of rt
 superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655704.4184637.5829079060500848403.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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
 db/sb.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 98 insertions(+), 11 deletions(-)


diff --git a/db/sb.c b/db/sb.c
index 9f9be6c4e149a9..e0c1c5847ac552 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -27,6 +27,7 @@ static int	label_f(int argc, char **argv);
 static void     label_help(void);
 static int	version_f(int argc, char **argv);
 static void     version_help(void);
+static size_t check_label(char *label, bool can_warn);
 
 static const cmdinfo_t	sb_cmd =
 	{ "sb", NULL, sb_f, 0, 1, 1, N_("[agno]"),
@@ -346,6 +347,65 @@ uuid_help(void)
 ));
 }
 
+static bool
+check_rtsb(
+	struct xfs_mount	*mp)
+{
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
@@ -390,6 +450,7 @@ do_uuid(xfs_agnumber_t agno, uuid_t *uuid)
 	memcpy(&tsb.sb_uuid, uuid, sizeof(uuid_t));
 	libxfs_sb_to_disk(iocur_top->data, &tsb);
 	write_cur();
+	memcpy(&mp->m_sb.sb_uuid, uuid, sizeof(uuid_t));
 	return uuid;
 }
 
@@ -452,11 +513,18 @@ uuid_f(
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
@@ -525,6 +593,27 @@ label_help(void)
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
@@ -543,22 +632,13 @@ do_label(xfs_agnumber_t agno, char *label)
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
 
@@ -590,7 +670,14 @@ label_f(
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

