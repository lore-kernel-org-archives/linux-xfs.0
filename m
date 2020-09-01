Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA951C433E7
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6BD82064B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UurK8bxm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgIAPuv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 11:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgIAPum (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:50:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C8EC061249
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 08:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=rxRDjXUzSxj49EiZUi67qwT4S+Wz0f1F26HaVfoi5NY=; b=UurK8bxmUeV/WwKtl8c3fnXZSv
        g6s267hW4a9qk86YhtUVkuXC8ZfXJs6F5OTHetNPHIeBeI4qtDHiWr55urz+fUR6a5U0mHa5TSIij
        pesQomInOb6dODGR/PtyuYFb+m6xkCoYtgYeLSCuyj8vkxqVgtVJ4TYIN1q67chIerNvkahLyzbCA
        /rSbPqkwgzEpbbQ9emvcdKWj7bYLW2/W19fi1odONHLAs992ejsxlSWyVlwJ09cD1j3G6nbmS/Dvf
        kSOS3+HR2n7yEKjeuZB7zNZLaDWOZlQ42ostCr7x9gw1MH7HkkqLpTNcz+yVYDcofhbYGcfhcE1Fg
        ZEuioDJQ==;
Received: from [2001:4bb8:18c:45ba:2f95:e5:ca6b:9b4a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8YS-0003n5-Lq
        for linux-xfs@vger.kernel.org; Tue, 01 Sep 2020 15:50:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/15] xfs: remove xfs_getsb
Date:   Tue,  1 Sep 2020 17:50:17 +0200
Message-Id: <20200901155018.2524-15-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901155018.2524-1-hch@lst.de>
References: <20200901155018.2524-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Merge xfs_getsb into its only caller, and clean that one up a little bit
as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 26 +++++++++++++-------------
 fs/xfs/xfs_mount.c       | 17 -----------------
 fs/xfs/xfs_mount.h       |  1 -
 3 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5449cba657352c..4f5569aab89a08 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3268,14 +3268,14 @@ xlog_do_log_recovery(
  */
 STATIC int
 xlog_do_recover(
-	struct xlog	*log,
-	xfs_daddr_t	head_blk,
-	xfs_daddr_t	tail_blk)
+	struct xlog		*log,
+	xfs_daddr_t		head_blk,
+	xfs_daddr_t		tail_blk)
 {
-	struct xfs_mount *mp = log->l_mp;
-	int		error;
-	xfs_buf_t	*bp;
-	xfs_sb_t	*sbp;
+	struct xfs_mount	*mp = log->l_mp;
+	struct xfs_buf		*bp = mp->m_sb_bp;
+	struct xfs_sb		*sbp = &mp->m_sb;
+	int			error;
 
 	trace_xfs_log_recover(log, head_blk, tail_blk);
 
@@ -3289,9 +3289,8 @@ xlog_do_recover(
 	/*
 	 * If IO errors happened during recovery, bail out.
 	 */
-	if (XFS_FORCED_SHUTDOWN(mp)) {
+	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
-	}
 
 	/*
 	 * We now update the tail_lsn since much of the recovery has completed
@@ -3305,10 +3304,12 @@ xlog_do_recover(
 	xlog_assign_tail_lsn(mp);
 
 	/*
-	 * Now that we've finished replaying all buffer and inode
-	 * updates, re-read in the superblock and reverify it.
+	 * Now that we've finished replaying all buffer and inode updates,
+	 * re-read the superblock and reverify it.
 	 */
-	bp = xfs_getsb(mp);
+	xfs_buf_lock(bp);
+	xfs_buf_hold(bp);
+	ASSERT(bp->b_flags & XBF_DONE);
 	bp->b_flags &= ~(XBF_DONE | XBF_ASYNC);
 	ASSERT(!(bp->b_flags & XBF_WRITE));
 	bp->b_flags |= XBF_READ;
@@ -3325,7 +3326,6 @@ xlog_do_recover(
 	}
 
 	/* Convert superblock from on-disk format */
-	sbp = &mp->m_sb;
 	xfs_sb_from_disk(sbp, bp->b_addr);
 	xfs_buf_relse(bp);
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index c8ae49a1e99c35..09cc7ca91cd398 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1288,23 +1288,6 @@ xfs_mod_frextents(
 	return ret;
 }
 
-/*
- * xfs_getsb() is called to obtain the buffer for the superblock.
- * The buffer is returned locked and read in from disk.
- * The buffer should be released with a call to xfs_brelse().
- */
-struct xfs_buf *
-xfs_getsb(
-	struct xfs_mount	*mp)
-{
-	struct xfs_buf		*bp = mp->m_sb_bp;
-
-	xfs_buf_lock(bp);
-	xfs_buf_hold(bp);
-	ASSERT(bp->b_flags & XBF_DONE);
-	return bp;
-}
-
 /*
  * Used to free the superblock along various error paths.
  */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a72cfcaa4ad12e..dfa429b77ee285 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -410,7 +410,6 @@ extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
 
-extern struct xfs_buf *xfs_getsb(xfs_mount_t *);
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
 extern bool	xfs_fs_writable(struct xfs_mount *mp, int level);
-- 
2.28.0

