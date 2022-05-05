Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2060BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359063AbiEEQJn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381654AbiEEQIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:08:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F105F5712C
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:05:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E79961D76
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA07EC385A4;
        Thu,  5 May 2022 16:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766706;
        bh=exgbV/bjRDmaGLGVqg5cAo8NVhi4AKkQxID6chVFNwY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mjtFHnH5JNJk0EF3KDiWIuAPKAKGTdDdcMKXzgMqeqBhzGAxqjSQGgGgyc68AexFb
         jQLt1cpKiOHTwHD/SIvrt+yhcF9VTJWiJLFCQYJKAY/Q1d0Z1bx3+dlrH9xJ6njIjK
         RjKMspYBzWaXvoWWfCdhKwVLOejV5mRrvI4A1rSTZ8uzLSgjMmMyh5OiA+E4E8teCc
         CnsvM/hunQ/s78VDf3IUw9CfJRF87AijsDBLijmb2NC8nhgkZJ21lQMq95Y1NJSATS
         t2O/oGaX9bxseI0i0PTiF5nbyU1uPAJq0sIHZVtZ1wsc1WSeKUO9YV6bA9GT1ZPFoJ
         A0hox+YchdMxA==
Subject: [PATCH 4/4] xfs_repair: check the rt summary against observations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:05:05 -0700
Message-ID: <165176670555.247207.10826098571443771712.stgit@magnolia>
In-Reply-To: <165176668306.247207.13169734586973190904.stgit@magnolia>
References: <165176668306.247207.13169734586973190904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach xfs_repair to check the ondisk realtime summary file against its
own observations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase5.c |    2 ++
 repair/rt.c     |   71 +++++--------------------------------------------------
 repair/rt.h     |   11 +--------
 3 files changed, 9 insertions(+), 75 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index ae444efb..42b0f117 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -617,6 +617,7 @@ phase5(xfs_mount_t *mp)
 			rtinit(mp);
 			generate_rtinfo(mp, btmcompute, sumcompute);
 			check_rtbitmap(mp);
+			check_rtsummary(mp);
 		}
 
 		return;
@@ -686,6 +687,7 @@ phase5(xfs_mount_t *mp)
 		rtinit(mp);
 		generate_rtinfo(mp, btmcompute, sumcompute);
 		check_rtbitmap(mp);
+		check_rtsummary(mp);
 	}
 
 	do_log(_("        - reset superblock...\n"));
diff --git a/repair/rt.c b/repair/rt.c
index b964d168..a4cca7aa 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -198,72 +198,13 @@ check_rtbitmap(
 			mp->m_sb.sb_rbmblocks);
 }
 
-#if 0
-/*
- * returns 1 if bad, 0 if good
- */
-int
-check_summary(xfs_mount_t *mp)
-{
-	xfs_rfsblock_t	bno;
-	xfs_suminfo_t	*csp;
-	xfs_suminfo_t	*fsp;
-	int		log;
-	int		error = 0;
-
-	error = 0;
-	csp = sumcompute;
-	fsp = sumfile;
-	for (log = 0; log < mp->m_rsumlevels; log++) {
-		for (bno = 0;
-		     bno < mp->m_sb.sb_rbmblocks;
-		     bno++, csp++, fsp++) {
-			if (*csp != *fsp) {
-				do_warn(
-	_("rt summary mismatch, size %d block %llu, file: %d, computed: %d\n"),
-						log, bno, *fsp, *csp);
-				error = 1;
-			}
-		}
-	}
-
-	return(error);
-}
-
-/*
- * copy the real-time summary file data into memory
- */
 void
-process_rtsummary(
-	xfs_mount_t		*mp,
-	struct xfs_dinode	*dino,
-	blkmap_t		*blkmap)
+check_rtsummary(
+	struct xfs_mount	*mp)
 {
-	xfs_fsblock_t		bno;
-	struct xfs_buf		*bp;
-	char			*bytes;
-	int			sumbno;
+	if (need_rsumino)
+		return;
 
-	for (sumbno = 0; sumbno < blkmap->count; sumbno++) {
-		bno = blkmap_get(blkmap, sumbno);
-		if (bno == NULLFSBLOCK) {
-			do_warn(_("block %d for rtsummary inode is missing\n"),
-					sumbno);
-			error++;
-			continue;
-		}
-		error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
-				XFS_FSB_TO_BB(mp, 1), 0, NULL, &bp);
-		if (error) {
-			do_warn(_("can't read block %d for rtsummary inode\n"),
-					sumbno);
-			error++;
-			continue;
-		}
-		bytes = bp->b_un.b_addr;
-		memmove((char *)sumfile + sumbno * mp->m_sb.sb_blocksize, bytes,
-			mp->m_sb.sb_blocksize);
-		libxfs_buf_relse(bp);
-	}
+	check_rtfile_contents(mp, "rtsummary", mp->m_sb.sb_rsumino, sumcompute,
+			XFS_B_TO_FSB(mp, mp->m_rsumsize));
 }
-#endif
diff --git a/repair/rt.h b/repair/rt.h
index 2023153f..be24e91c 100644
--- a/repair/rt.h
+++ b/repair/rt.h
@@ -17,15 +17,6 @@ generate_rtinfo(xfs_mount_t	*mp,
 		xfs_suminfo_t	*sumcompute);
 
 void check_rtbitmap(struct xfs_mount *mp);
-
-#if 0
-
-int
-check_summary(xfs_mount_t	*mp);
-
-void
-process_rtsummary(xfs_mount_t	*mp,
-		struct blkmap	*blkmap);
-#endif
+void check_rtsummary(struct xfs_mount *mp);
 
 #endif /* _XFS_REPAIR_RT_H_ */

