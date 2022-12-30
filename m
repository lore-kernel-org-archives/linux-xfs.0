Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE670C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbiLaCh2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbiLaChG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:37:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5167DBC95
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:37:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11831B81E03
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE757C433D2;
        Sat, 31 Dec 2022 02:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454222;
        bh=wPzUtNnMXSCj6UJqZuRoTvl3tzISHURyMgd05QQ5vMc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DAUc8mYxeYkS7OMtev9GcVDAa5yGBE/Cf1wnkY1lT3GkeN2ta/BDbUNtErNcJsMPP
         RyynX3dNd+tqdYWLRsJTRhke6HDZSxrxpndeLr6utkmLVGM7XTKtfeSvk+xY230Uc8
         yPDx65G+8UBCp84vww8AhQDxae5cAs4vJ1rW6z40xBhSVnCYhiPffKkNnW0dF+RG4k
         8Xy52AKhQFsdsXFIfcAyoQQctOK283DfHgP/OhevL0UQfi7wA0ZBCOm4c7uE8uMSO8
         QTyPg+LY3J43x8XlPW+ncyng2uXyffUpC+W3a8MyLa4wxNuJqanWGV+spZWKt8qji5
         UEoqNPuLE5qBA==
Subject: [PATCH 27/45] xfs_db: support changing the label and uuid of rt
 superblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:47 -0800
Message-ID: <167243878716.731133.8733171457425734764.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the label and uuid commands to change the rt superblocks along
with the filesystem superblocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c |  119 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 108 insertions(+), 11 deletions(-)


diff --git a/db/sb.c b/db/sb.c
index fa0706d3676..36d4c317dba 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -27,6 +27,7 @@ static int	label_f(int argc, char **argv);
 static void     label_help(void);
 static int	version_f(int argc, char **argv);
 static void     version_help(void);
+static size_t check_label(char *label, bool can_warn);
 
 static const cmdinfo_t	sb_cmd =
 	{ "sb", NULL, sb_f, 0, 1, 1, N_("[agno]"),
@@ -357,6 +358,77 @@ uuid_help(void)
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
@@ -463,11 +535,18 @@ uuid_f(
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
@@ -536,6 +615,27 @@ label_help(void)
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
@@ -554,17 +654,7 @@ do_label(xfs_agnumber_t agno, char *label)
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
@@ -601,7 +691,14 @@ label_f(
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

