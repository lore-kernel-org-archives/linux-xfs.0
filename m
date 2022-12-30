Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 896AEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbiLaCUs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236213AbiLaCUq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:20:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D9B2F0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:20:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13A3CB81E02
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CF6C433EF;
        Sat, 31 Dec 2022 02:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453242;
        bh=yYlo9jDJxiBDAW+oUAIT+bi4zREINNpAah17LX+bHxM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bN6T/Ay29DjSZnI/fU69rSABw1BNpLafBkVyEyUwPbw5PA0Yuhev1XgTSi6t+kqTN
         y0kgXIv606Fu4Vy5MRMzEisdF4lGnQdbOMA6LK13DtR/DvbYwW3jTrp31uhgc+SFWa
         TBP/gUt4/gqJa8FtfiBqzIhHqxw5/hyMrnzy4PfqgP73Icxf2146CrbQ8VMTxIeeC7
         TH3O1bOtEqnTfEdcDz+0828/pRaoEmHm9KFQlJBL4WJxDodRlyc9+59zs+Z+iWGh8A
         2Gqnp6f5i6bV6ZqhvmZV6brCRxtnF8s9WgitoVnVtQaYJWqOM552D5W7RY1SX5hHjs
         Hqh1HKomc4MwQ==
Subject: [PATCH 42/46] xfs_repair: drop all the metadata directory files
 during pass 4
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:24 -0800
Message-ID: <167243876481.725900.17199528046234003115.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Drop the entire metadata directory tree during pass 4 so that we can
reinitialize the entire tree in phase 6.  The existing metadata files
(rtbitmap, rtsummary, quotas) will be reattached to the newly rebuilt
directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |    9 +++++++++
 repair/dinode.c      |   14 +++++++++++++-
 repair/phase6.c      |   21 +++++++++++----------
 repair/scan.c        |    2 +-
 4 files changed, 34 insertions(+), 12 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index fb2bca66a47..382196cc170 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -952,6 +952,15 @@ process_inode_chunk(
 			clear_inode_isadir(ino_rec, irec_offset);
 		}
 
+		/*
+		 * We always reinitialize the rt bitmap and summary inodes if
+		 * the metadata directory feature is enabled.
+		 */
+		if (xfs_has_metadir(mp) && !no_modify) {
+			need_rbmino = -1;
+			need_rsumino = -1;
+		}
+
 		if (status)  {
 			if (mp->m_sb.sb_rootino == ino) {
 				need_root_inode = 1;
diff --git a/repair/dinode.c b/repair/dinode.c
index 4efc7fe6b8b..5c1f07d5bc1 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -653,7 +653,7 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 				break;
 			}
 		}
-		if (collect_rmaps) /* && !check_dups */
+		if (collect_rmaps && !zap_metadata) /* && !check_dups */
 			rmap_add_rec(mp, ino, whichfork, &irec);
 		*tot += irec.br_blockcount;
 	}
@@ -3077,6 +3077,18 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	 */
 	*dirty += process_check_inode_nlink_version(dino, lino);
 
+	/*
+	 * The entire metadata directory tree will be rebuilt during phase 6.
+	 * Therefore, if we're at the end of phase 4 and this is a metadata
+	 * file, zero the ondisk inode and the incore state.
+	 */
+	if (check_dups && zap_metadata && !no_modify) {
+		clear_dinode(mp, dino, lino);
+		*dirty += 1;
+		*used = is_free;
+		*isa_dir = 0;
+	}
+
 	return retval;
 
 clear_bad_out:
diff --git a/repair/phase6.c b/repair/phase6.c
index c440c2293d1..964342c31d6 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3638,20 +3638,20 @@ phase6(xfs_mount_t *mp)
 		}
 	}
 
-	if (need_metadir_inode) {
-		if (!no_modify)  {
+	if (!no_modify && xfs_has_metadir(mp))  {
+		if (need_metadir_inode)
 			do_warn(_("reinitializing metadata root directory\n"));
-			mk_metadir(mp);
-			need_metadir_inode = false;
-			need_metadir_dotdot = 0;
-		} else  {
-			do_warn(_("would reinitialize metadata root directory\n"));
-		}
+		mk_metadir(mp);
+		need_metadir_inode = false;
+		need_metadir_dotdot = 0;
+	} else if (need_metadir_inode) {
+		do_warn(_("would reinitialize metadata root directory\n"));
 	}
 
 	if (need_rbmino)  {
 		if (!no_modify)  {
-			do_warn(_("reinitializing realtime bitmap inode\n"));
+			if (need_rbmino > 0)
+				do_warn(_("reinitializing realtime bitmap inode\n"));
 			mk_rbmino(mp);
 			need_rbmino = 0;
 		} else  {
@@ -3661,7 +3661,8 @@ phase6(xfs_mount_t *mp)
 
 	if (need_rsumino)  {
 		if (!no_modify)  {
-			do_warn(_("reinitializing realtime summary inode\n"));
+			if (need_rsumino > 0)
+				do_warn(_("reinitializing realtime summary inode\n"));
 			mk_rsumino(mp);
 			need_rsumino = 0;
 		} else  {
diff --git a/repair/scan.c b/repair/scan.c
index ef78b4cce50..1f5db1c11ca 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -427,7 +427,7 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 	numrecs = be16_to_cpu(block->bb_numrecs);
 
 	/* Record BMBT blocks in the reverse-mapping data. */
-	if (check_dups && collect_rmaps) {
+	if (check_dups && collect_rmaps && !zap_metadata) {
 		agno = XFS_FSB_TO_AGNO(mp, bno);
 		pthread_mutex_lock(&ag_locks[agno].lock);
 		rmap_add_bmbt_rec(mp, ino, whichfork, bno);

