Return-Path: <SRS0=6Z+e=CI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7085FC433E2
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 06:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BFC6204EA
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 06:15:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lq3S+4lH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgH3GPb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 02:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgH3GPa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Aug 2020 02:15:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FB9C061573
        for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2020 23:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=yBpBflAjZzhFLJ/zoAnTf8pfL12X1RMVeAizGqVBG/k=; b=lq3S+4lHuqrrxWCulyqR7m17Cd
        l1SZi2nUO9Jgrozx4GlEftw3o1VN1h5UZ/M+zFrmQj4DdjN7wnin1IpXaJZO/tvJD8MZozhFAiZM1
        rKIXYBOSTecDh3pTrQ8bASnaT0AhKNwkkNKUpV6TM03b5/8ZfsAa4VBibWO8m7Eof2vdyS5s9PozV
        3csm5fqpgbbvCYF/izA1qCtDS62q3Wf62Q1PBqYjuQfcVkiHeBBidNnlHGRwSFos6F42+dmnN5bsM
        0qb1nxp59wfizb4u/4blRUemRwNX9u3MFpU7McJZFtEjo7RGtpLVz1GYyjQv2TuKmiNHoflGYy1Wi
        pVj6L18g==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGci-0001zg-Pq
        for linux-xfs@vger.kernel.org; Sun, 30 Aug 2020 06:15:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/13] xfs: reuse _xfs_buf_read for re-reading the superblock
Date:   Sun, 30 Aug 2020 08:15:12 +0200
Message-Id: <20200830061512.1148591-14-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200830061512.1148591-1-hch@lst.de>
References: <20200830061512.1148591-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Instead of poking deeply into buffer cache internals when re-reading the
superblock during log recovery just generalize _xfs_buf_read and use it
there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c         | 24 +++++++++++++++++-------
 fs/xfs/xfs_buf.h         | 10 ++--------
 fs/xfs/xfs_log_recover.c | 11 +++--------
 3 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 7f8abcbe98a447..0de6b110391202 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -52,6 +52,15 @@ static kmem_zone_t *xfs_buf_zone;
  *	  b_lock (trylock due to inversion)
  */
 
+static int __xfs_buf_submit(struct xfs_buf *bp, bool wait);
+
+static inline int
+xfs_buf_submit(
+	struct xfs_buf		*bp)
+{
+	return __xfs_buf_submit(bp, !(bp->b_flags & XBF_ASYNC));
+}
+
 static inline int
 xfs_buf_is_vmapped(
 	struct xfs_buf	*bp)
@@ -751,16 +760,18 @@ xfs_buf_get_map(
 	return 0;
 }
 
-STATIC int
+int
 _xfs_buf_read(
-	xfs_buf_t		*bp,
-	xfs_buf_flags_t		flags)
+	struct xfs_buf		*bp,
+	xfs_buf_flags_t		flags,
+	const struct xfs_buf_ops *ops)
 {
 	ASSERT(!(flags & XBF_WRITE));
 	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
 
-	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
+	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
 	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
+	bp->b_ops = ops;
 
 	return xfs_buf_submit(bp);
 }
@@ -825,8 +836,7 @@ xfs_buf_read_map(
 	if (!(bp->b_flags & XBF_DONE)) {
 		/* Initiate the buffer read and wait. */
 		XFS_STATS_INC(target->bt_mount, xb_get_read);
-		bp->b_ops = ops;
-		error = _xfs_buf_read(bp, flags);
+		error = _xfs_buf_read(bp, flags, ops);
 
 		/* Readahead iodone already dropped the buffer, so exit. */
 		if (flags & XBF_ASYNC)
@@ -1639,7 +1649,7 @@ xfs_buf_iowait(
  * safe to reference the buffer after a call to this function unless the caller
  * holds an additional reference itself.
  */
-int
+static int
 __xfs_buf_submit(
 	struct xfs_buf	*bp,
 	bool		wait)
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 9eb4044597c985..db172599d32dc1 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -249,6 +249,8 @@ int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks, int flags,
 int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
 			  size_t numblks, int flags, struct xfs_buf **bpp,
 			  const struct xfs_buf_ops *ops);
+int _xfs_buf_read(struct xfs_buf *bp, xfs_buf_flags_t flags,
+		const struct xfs_buf_ops *ops);
 void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
@@ -275,14 +277,6 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
 extern void xfs_buf_ioerror_alert(struct xfs_buf *bp, xfs_failaddr_t fa);
 void xfs_buf_ioend_fail(struct xfs_buf *);
-
-extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
-static inline int xfs_buf_submit(struct xfs_buf *bp)
-{
-	bool wait = bp->b_flags & XBF_ASYNC ? false : true;
-	return __xfs_buf_submit(bp, wait);
-}
-
 void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize);
 void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5449cba657352c..1771bc3646f4b1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3305,16 +3305,11 @@ xlog_do_recover(
 	xlog_assign_tail_lsn(mp);
 
 	/*
-	 * Now that we've finished replaying all buffer and inode
-	 * updates, re-read in the superblock and reverify it.
+	 * Now that we've finished replaying all buffer and inode updates,
+	 * re-read in the superblock and reverify it.
 	 */
 	bp = xfs_getsb(mp);
-	bp->b_flags &= ~(XBF_DONE | XBF_ASYNC);
-	ASSERT(!(bp->b_flags & XBF_WRITE));
-	bp->b_flags |= XBF_READ;
-	bp->b_ops = &xfs_sb_buf_ops;
-
-	error = xfs_buf_submit(bp);
+	error = _xfs_buf_read(bp, XBF_READ, &xfs_sb_buf_ops);
 	if (error) {
 		if (!XFS_FORCED_SHUTDOWN(mp)) {
 			xfs_buf_ioerror_alert(bp, __this_address);
-- 
2.28.0

