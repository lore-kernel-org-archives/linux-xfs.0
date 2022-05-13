Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837BEC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 13 May 2022 20:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381023AbiEMUeW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 May 2022 16:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379707AbiEMUeU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 May 2022 16:34:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B81A2BF4
        for <linux-xfs@vger.kernel.org>; Fri, 13 May 2022 13:34:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E97D3B831C4
        for <linux-xfs@vger.kernel.org>; Fri, 13 May 2022 20:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A50C34100;
        Fri, 13 May 2022 20:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652474056;
        bh=ctdSr9icuBO3BZX/jysi5SQMn+u1zmg+iC2cfkOiBRM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=h9AuQ9AF/iRZ8qkliaK5S7a1hvULwvr51lkbtsXzI77d0zjOLjGMI5QP8vGFV8cIF
         orA+cWKvHR1j3A7wTvLFgjfDsRsBZboIO4Ico4OJvsVlsGF8oEbR7XnR5xB6yL3FIv
         VUdXhjakTSKT1vdUyMNioGDRfRJ33DP02ZJaxQSbqE8rLwWA1Vx25UvUm0yAhgarqI
         5THPpMRJhC8ExkG1Q9kNW7CbERABOZzGX43cTB2dOC+CPdhoSmy4GRCzKOPmy1Mdu3
         j8ExZzaseEhRpE8cvC6PkauDhv2QFJ8D9sZPE99ewZpeDPIGCvF4UxsyxdHTw7xUSI
         EOh4E6xcz7GBg==
Subject: [PATCH 4/4] xfs_repair: check the rt summary against observations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Fri, 13 May 2022 13:34:16 -0700
Message-ID: <165247405608.275439.17901954488914628121.stgit@magnolia>
In-Reply-To: <165247403337.275439.13973873324817048674.stgit@magnolia>
References: <165247403337.275439.13973873324817048674.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase5.c |    1 +
 repair/rt.c     |   71 +++++--------------------------------------------------
 repair/rt.h     |   11 +--------
 3 files changed, 8 insertions(+), 75 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index d1ddd224..b04912d8 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -609,6 +609,7 @@ check_rtmetadata(
 	rtinit(mp);
 	generate_rtinfo(mp, btmcompute, sumcompute);
 	check_rtbitmap(mp);
+	check_rtsummary(mp);
 }
 
 void
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

