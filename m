Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C655C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15A1C206EB
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t9Ddv/4/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731732AbgIAPut (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 11:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730164AbgIAPuo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:50:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB09C06124F
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 08:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=MkfgV0MflOrcNJeKGawUb+9UrlZNLFW2tK65y4tU8+c=; b=t9Ddv/4/Mzq64n/bV1l9ctztOR
        eX0Vj4PZS/ghhM8MsFA8lFR+bzUMq+uqGa0exCrNZq7C0coc8YlZCljqiv4n3FCmYfbg2fOdS7OvL
        Ijwc4pO3/qYuUQfqM++h4ACq2Ggq4q1wJpmB29USlBRLF3hVaEmSm3aA+il0eDmtTT6NpUkJHzS49
        nnWznETI03TZrP+HNXf5Gxr+l7uYyH/Jo2Qfu+1Sjjb0mrDmfLkOo6vdjZIGrsCDzp/fNWpBz1XG2
        PwmnTZL3LsmVTDV/oyqyYPtchg3VrmGAOhb7ZTfteGIXdupLtUx1YdtXPDehJvwdVGJt75BgLZ1x8
        F+CyM6ag==;
Received: from [2001:4bb8:18c:45ba:2f95:e5:ca6b:9b4a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8YU-0003n9-02
        for linux-xfs@vger.kernel.org; Tue, 01 Sep 2020 15:50:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/15] xfs: reuse _xfs_buf_read for re-reading the superblock
Date:   Tue,  1 Sep 2020 17:50:18 +0200
Message-Id: <20200901155018.2524-16-hch@lst.de>
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

Instead of poking deeply into buffer cache internals when re-reading the
superblock during log recovery just generalize _xfs_buf_read and use it
there.  Note that we don't have to explicitly set up the ops as they
must be set from the initial read.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c         | 15 ++++++++++++---
 fs/xfs/xfs_buf.h         |  9 +--------
 fs/xfs/xfs_log_recover.c |  8 +-------
 3 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 7f8abcbe98a447..4e4cf91f4f9fe7 100644
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
@@ -751,7 +760,7 @@ xfs_buf_get_map(
 	return 0;
 }
 
-STATIC int
+int
 _xfs_buf_read(
 	xfs_buf_t		*bp,
 	xfs_buf_flags_t		flags)
@@ -759,7 +768,7 @@ _xfs_buf_read(
 	ASSERT(!(flags & XBF_WRITE));
 	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
 
-	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
+	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
 	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
 
 	return xfs_buf_submit(bp);
@@ -1639,7 +1648,7 @@ xfs_buf_iowait(
  * safe to reference the buffer after a call to this function unless the caller
  * holds an additional reference itself.
  */
-int
+static int
 __xfs_buf_submit(
 	struct xfs_buf	*bp,
 	bool		wait)
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 9eb4044597c985..bfd2907e7bc454 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -249,6 +249,7 @@ int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks, int flags,
 int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
 			  size_t numblks, int flags, struct xfs_buf **bpp,
 			  const struct xfs_buf_ops *ops);
+int _xfs_buf_read(struct xfs_buf *bp, xfs_buf_flags_t flags);
 void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
@@ -275,14 +276,6 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
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
index 4f5569aab89a08..64cddef61b991a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3309,13 +3309,7 @@ xlog_do_recover(
 	 */
 	xfs_buf_lock(bp);
 	xfs_buf_hold(bp);
-	ASSERT(bp->b_flags & XBF_DONE);
-	bp->b_flags &= ~(XBF_DONE | XBF_ASYNC);
-	ASSERT(!(bp->b_flags & XBF_WRITE));
-	bp->b_flags |= XBF_READ;
-	bp->b_ops = &xfs_sb_buf_ops;
-
-	error = xfs_buf_submit(bp);
+	error = _xfs_buf_read(bp, XBF_READ);
 	if (error) {
 		if (!XFS_FORCED_SHUTDOWN(mp)) {
 			xfs_buf_ioerror_alert(bp, __this_address);
-- 
2.28.0

