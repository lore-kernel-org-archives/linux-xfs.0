Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF63C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34796610F9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237777AbhINCpM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:45:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236953AbhINCpM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:45:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84648606A5;
        Tue, 14 Sep 2021 02:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587435;
        bh=0ytJwPl/d8MP7d7DBcGmB7eMBgXWXz1J+j0jei3hwU8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=f3iFFOzD/zjZJ1gTTdzGXts9pHGb+dhbkbGdlmjOfQtEiKFqhaTMTayM9elesEUo4
         teRtIf8ikx5WK5fFoPEMOsq/HGToLIdxr7A+5GeKAGenzKbC21p727J5jGE5ujJ70J
         KPA81eCOI1FdnyrnSHhKygl8xlOXI1Bquf7SPzqjuXgIDruEfccME9YnbzUoyW0Hbm
         hLN8piRHofb0N7x1Or2Ly+jjvAQNXuqeuBVOoSrH0gfTXLjCs2mT24PjkO3lN5jS92
         GQ+wxYLbd4CCunym+1ubdBjTTvPv/QVSnd+h38/i+YcFd91InqlvfQzmcAKswJkzl2
         55Lf7Q6zPWCow==
Subject: [PATCH 43/43] libxfs: rename buffer cache index variable b_bn
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:43:55 -0700
Message-ID: <163158743528.1604118.7773426223391954589.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

To stop external users from using b_bn as the disk address of the
buffer, rename it to b_rhash_key to indicate that it is the buffer
cache index, not the block number of the buffer. Code that needs the
disk address should use xfs_buf_daddr() to obtain it.

Do the rename and clean up any of the remaining internal b_bn users.
Also clean up any remaining b_bn cruft that is now unused.

Inspired-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_io.h |    8 ++++----
 libxfs/rdwr.c      |   16 ++++++++--------
 2 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 1f2ac25b..e378f22b 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -79,7 +79,7 @@ struct xfs_buf_ops {
 struct xfs_buf {
 	struct cache_node	b_node;
 	unsigned int		b_flags;
-	xfs_daddr_t		b_bn;
+	xfs_daddr_t		b_cache_key;	/* buffer cache index */
 	unsigned int		b_length;
 	struct xfs_buftarg	*b_target;
 	pthread_mutex_t		b_lock;
@@ -118,8 +118,8 @@ typedef unsigned int xfs_buf_flags_t;
 static inline xfs_daddr_t xfs_buf_daddr(struct xfs_buf *bp)
 {
 	/* XXX remove me */
-	if (bp->b_bn != bp->b_maps[0].bm_bn && bp->b_bn != -1ULL) {
-		fprintf(stderr, "FARTS buf %p bn %lx bmbn %lx intmap? %d\n", bp, bp->b_bn, bp->b_maps[0].bm_bn, bp->b_maps == &bp->__b_map);
+	if (bp->b_cache_key != bp->b_maps[0].bm_bn && bp->b_cache_key != -1ULL) {
+		fprintf(stderr, "FARTS buf %p bn %lx bmbn %lx intmap? %d\n", bp, bp->b_cache_key, bp->b_maps[0].bm_bn, bp->b_maps == &bp->__b_map);
 		abort();
 	}
 	return bp->b_maps[0].bm_bn;
@@ -127,7 +127,7 @@ static inline xfs_daddr_t xfs_buf_daddr(struct xfs_buf *bp)
 
 static inline void xfs_buf_set_daddr(struct xfs_buf *bp, xfs_daddr_t blkno)
 {
-	assert(bp->b_bn == XFS_BUF_DADDR_NULL);
+	assert(bp->b_cache_key == XFS_BUF_DADDR_NULL);
 	bp->b_maps[0].bm_bn = blkno;
 }
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 03dc2917..96f95ae3 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -205,7 +205,7 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
 	struct xfs_bufkey	*bkey = (struct xfs_bufkey *)key;
 
 	if (bp->b_target->bt_bdev == bkey->buftarg->bt_bdev &&
-	    bp->b_bn == bkey->blkno) {
+	    bp->b_cache_key == bkey->blkno) {
 		if (bp->b_length == bkey->bblen)
 			return CACHE_HIT;
 #ifdef IO_BCOMPARE_CHECK
@@ -214,7 +214,7 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
 	"%lx: Badness in key lookup (length)\n"
 	"bp=(bno 0x%llx, len %u bytes) key=(bno 0x%llx, len %u bytes)\n",
 				pthread_self(),
-				(unsigned long long)bp->b_bn, 
+				(unsigned long long)xfs_buf_daddr(bp),
 				BBTOB(bp->b_length),
 				(unsigned long long)bkey->blkno,
 				BBTOB(bkey->bblen));
@@ -230,7 +230,7 @@ __initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 		unsigned int bytes)
 {
 	bp->b_flags = 0;
-	bp->b_bn = bno;
+	bp->b_cache_key = bno;
 	bp->b_length = BTOBB(bytes);
 	bp->b_target = btp;
 	bp->b_mount = btp->bt_mount;
@@ -256,7 +256,7 @@ __initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 
 	if (bp->b_maps == &bp->__b_map) {
 		bp->b_nmaps = 1;
-		bp->b_maps[0].bm_bn = bp->b_bn;
+		bp->b_maps[0].bm_bn = bno;
 		bp->b_maps[0].bm_len = bp->b_length;
 	}
 }
@@ -591,7 +591,7 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, struct xfs_buf *bp,
 	error = __read_buf(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno), flags);
 	if (!error &&
 	    bp->b_target->bt_bdev == btp->bt_bdev &&
-	    bp->b_bn == blkno &&
+	    bp->b_cache_key == blkno &&
 	    bp->b_length == len)
 		bp->b_flags |= LIBXFS_B_UPTODATE;
 	bp->b_error = error;
@@ -833,14 +833,14 @@ libxfs_bwrite(
 			fprintf(stderr,
 	_("%s: write verifier failed on %s bno 0x%llx/0x%x\n"),
 				__func__, bp->b_ops->name,
-				(long long)bp->b_bn, bp->b_length);
+				(long long)xfs_buf_daddr(bp), bp->b_length);
 			return bp->b_error;
 		}
 	}
 
 	if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
 		bp->b_error = __write_buf(fd, bp->b_addr, BBTOB(bp->b_length),
-				    LIBXFS_BBTOOFF64(bp->b_bn), bp->b_flags);
+				    LIBXFS_BBTOOFF64(xfs_buf_daddr(bp)), bp->b_flags);
 	} else {
 		int	i;
 		void	*buf = bp->b_addr;
@@ -861,7 +861,7 @@ libxfs_bwrite(
 		fprintf(stderr,
 	_("%s: write failed on %s bno 0x%llx/0x%x, err=%d\n"),
 			__func__, bp->b_ops ? bp->b_ops->name : "(unknown)",
-			(long long)bp->b_bn, bp->b_length, -bp->b_error);
+			(long long)xfs_buf_daddr(bp), bp->b_length, -bp->b_error);
 	} else {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
 		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);

