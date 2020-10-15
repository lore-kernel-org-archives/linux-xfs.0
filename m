Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAFA0C2D0AE
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 783572224E
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgJOHWN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:13 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34910 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729217AbgJOHWM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:12 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 73DAA58C069
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaH-000hvx-0c
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:57 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qMD-Oq
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 18/27] libxfs: convert libxfs_bwrite to buftarg IO
Date:   Thu, 15 Oct 2020 18:21:46 +1100
Message-Id: <20201015072155.1631135-19-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=4I4TwTBc7MKnQ9EKQlEA:9
        a=9Tm6h48IePQ0ZHO5:21 a=eUty33ZQclMoXjXg:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Buffers can now be written by the buftarg IO engine, so redirect the
API to the new implementation and ensure it twiddles flag state
correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/buftarg.c     | 30 +++++++++++++++-
 libxfs/libxfs_io.h   |  1 -
 libxfs/libxfs_priv.h |  2 +-
 libxfs/rdwr.c        | 85 --------------------------------------------
 libxfs/xfs_buftarg.h |  5 ++-
 5 files changed, 34 insertions(+), 89 deletions(-)

diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
index 62c2bea87b5c..1f6a89d14ec6 100644
--- a/libxfs/buftarg.c
+++ b/libxfs/buftarg.c
@@ -126,8 +126,16 @@ xfs_buf_ioend(
 		bp->b_ops->verify_read(bp);
 	}
 
-	if (!bp->b_error)
+	if (!bp->b_error) {
 		bp->b_flags |= XBF_DONE;
+		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
+	} else {
+		fprintf(stderr,
+			_("%s: IO failed on %s bno 0x%llx/0x%x, err=%d\n"),
+			__func__, bp->b_ops ? bp->b_ops->name : "(unknown)",
+			(long long)bp->b_maps[0].bm_bn, bp->b_length,
+			-bp->b_error);
+	}
 }
 
 static void
@@ -227,6 +235,19 @@ xfs_buftarg_submit_io(
 	bp->b_error = 0;
 
 	if (bp->b_flags & XBF_WRITE) {
+
+		/*
+		 * we never write buffers that are marked stale. This indicates
+		 * they contain data that has been invalidated, and even if the
+		 * buffer is dirty it must *never* be written. Verifiers are
+		 * wonderful for finding bugs like this. Make sure the error is
+		 * obvious as to the cause.
+		 */
+		if (bp->b_flags & XBF_STALE) {
+			bp->b_error = -ESTALE;
+			return;
+		}
+
 		/*
 		 * Run the write verifier callback function if it exists. If
 		 * this function fails it will mark the buffer with an error and
@@ -366,6 +387,13 @@ xfs_buf_read_uncached(
 	return 0;
 }
 
+int
+xfs_bwrite(struct xfs_buf *bp)
+{
+	return xfs_buf_uncached_submit(bp->b_target, bp, bp->b_length,
+					XBF_WRITE);
+}
+
 /*
  * Return a buffer associated to external memory via xfs_buf_associate_memory()
  * back to it's empty state.
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index c59d42e02040..c17cdc33bf2a 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -145,7 +145,6 @@ extern void	libxfs_bcache_flush(void);
 extern int	libxfs_bcache_overflowed(void);
 
 /* Buffer (Raw) Interfaces */
-int		libxfs_bwrite(struct xfs_buf *bp);
 extern int	libxfs_device_zero(struct xfs_buftarg *, xfs_daddr_t, uint);
 
 extern int libxfs_bhash_size;
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index dce77024b5de..151c030b5876 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -408,7 +408,7 @@ howmany_64(uint64_t x, uint32_t y)
 /* buffer management */
 #define XBF_TRYLOCK			0
 #define XBF_UNMAPPED			0
-#define xfs_buf_stale(bp)		((bp)->b_flags |= LIBXFS_B_STALE)
+#define xfs_buf_stale(bp)		((bp)->b_flags |= XBF_STALE)
 #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
 
 /* buffer type flags for write callbacks */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index af70dbe339e4..371a6d221bb2 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -710,91 +710,6 @@ err:
 	return error;
 }
 
-static int
-__write_buf(int fd, void *buf, int len, off64_t offset, int flags)
-{
-	int	sts;
-
-	sts = pwrite(fd, buf, len, offset);
-	if (sts < 0) {
-		int error = errno;
-		fprintf(stderr, _("%s: pwrite failed: %s\n"),
-			progname, strerror(error));
-		return -error;
-	} else if (sts != len) {
-		fprintf(stderr, _("%s: error - pwrite only %d of %d bytes\n"),
-			progname, sts, len);
-		return -EIO;
-	}
-	return 0;
-}
-
-int
-libxfs_bwrite(
-	struct xfs_buf	*bp)
-{
-	int		fd = libxfs_device_to_fd(bp->b_target->bt_bdev);
-
-	/*
-	 * we never write buffers that are marked stale. This indicates they
-	 * contain data that has been invalidated, and even if the buffer is
-	 * dirty it must *never* be written. Verifiers are wonderful for finding
-	 * bugs like this. Make sure the error is obvious as to the cause.
-	 */
-	if (bp->b_flags & LIBXFS_B_STALE) {
-		bp->b_error = -ESTALE;
-		return bp->b_error;
-	}
-
-	/*
-	 * clear any pre-existing error status on the buffer. This can occur if
-	 * the buffer is corrupt on disk and the repair process doesn't clear
-	 * the error before fixing and writing it back.
-	 */
-	bp->b_error = 0;
-	if (bp->b_ops) {
-		bp->b_ops->verify_write(bp);
-		if (bp->b_error) {
-			fprintf(stderr,
-	_("%s: write verifier failed on %s bno 0x%llx/0x%x\n"),
-				__func__, bp->b_ops->name,
-				(long long)bp->b_bn, bp->b_length);
-			return bp->b_error;
-		}
-	}
-
-	if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
-		bp->b_error = __write_buf(fd, bp->b_addr, BBTOB(bp->b_length),
-				    LIBXFS_BBTOOFF64(bp->b_maps[0].bm_bn),
-				    bp->b_flags);
-	} else {
-		int	i;
-		void	*buf = bp->b_addr;
-
-		for (i = 0; i < bp->b_map_count; i++) {
-			off64_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
-			int len = BBTOB(bp->b_maps[i].bm_len);
-
-			bp->b_error = __write_buf(fd, buf, len, offset,
-						  bp->b_flags);
-			if (bp->b_error)
-				break;
-			buf += len;
-		}
-	}
-
-	if (bp->b_error) {
-		fprintf(stderr,
-	_("%s: write failed on %s bno 0x%llx/0x%x, err=%d\n"),
-			__func__, bp->b_ops ? bp->b_ops->name : "(unknown)",
-			(long long)bp->b_bn, bp->b_length, -bp->b_error);
-	} else {
-		bp->b_flags |= LIBXFS_B_UPTODATE;
-		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
-	}
-	return bp->b_error;
-}
-
 /*
  * Mark a buffer dirty.  The dirty data will be written out when the cache
  * is flushed (or at release time if the buffer is uncached).
diff --git a/libxfs/xfs_buftarg.h b/libxfs/xfs_buftarg.h
index 71054317ee9d..7d2a7ab29c0f 100644
--- a/libxfs/xfs_buftarg.h
+++ b/libxfs/xfs_buftarg.h
@@ -81,6 +81,8 @@ int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
 
 int xfs_bread(struct xfs_buf *bp, size_t bblen);
 
+int xfs_bwrite(struct xfs_buf *bp);
+
 /*
  * Temporary: these need to be the same as the LIBXFS_B_* flags until we change
  * over to the kernel structures. For those that aren't the same or don't yet
@@ -88,7 +90,8 @@ int xfs_bread(struct xfs_buf *bp, size_t bblen);
  */
 #define XBF_READ	(1 << 31)
 #define XBF_WRITE	(1 << 30)
-#define XBF_DONE	(1 << 3)	// LIBXFS_B_UPTODATE 0x0008
+#define XBF_DONE	(1 << 3)	// LIBXFS_B_UPTODATE	0x0008
+#define XBF_STALE	(1 << 2)	// LIBXFS_B_STALE	0x0004
 
 /*
  * Raw buffer access functions. These exist as temporary bridges for uncached IO
-- 
2.28.0

