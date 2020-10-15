Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D248C04EBE
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1D222224E
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgJOHWL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:11 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34910 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728865AbgJOHWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:10 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6450058C554
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hvr-Tu
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qM7-MK
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 16/27] libxfs: add a synchronous IO engine to the buftarg
Date:   Thu, 15 Oct 2020 18:21:44 +1100
Message-Id: <20201015072155.1631135-17-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=11wfEeCrDQ8h5XY37qkA:9
        a=9-DF_-VqcPqRofET:21 a=xXGA2mDVu9L0VrCX:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Replace the use of the rdwr.c uncached IO routines with a new
buftarg based IO engine. This will currently be synchronous so as to
match the existing functionality it replaces, but will be easily
modified to run AIO in future.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/buftarg.c     | 197 ++++++++++++++++++++++++++++++++++++++++---
 libxfs/libxfs_io.h   |   2 +
 libxfs/xfs_buftarg.h |   4 +-
 3 files changed, 192 insertions(+), 11 deletions(-)

diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
index 2a0aad2e0f8c..d98952940ee8 100644
--- a/libxfs/buftarg.c
+++ b/libxfs/buftarg.c
@@ -98,6 +98,182 @@ xfs_buftarg_free(
 	free(btp);
 }
 
+/*
+ * Low level IO routines
+ */
+static void
+xfs_buf_ioend(
+	struct xfs_buf	*bp)
+{
+	bool		read = bp->b_flags & XBF_READ;
+
+//	printf("endio bn %ld l %d/%d, io err %d err %d f 0x%x\n", bp->b_maps[0].bm_bn,
+//			bp->b_maps[0].bm_len, BBTOB(bp->b_length),
+//			bp->b_io_error, bp->b_error, bp->b_flags);
+
+	bp->b_flags &= ~(XBF_READ | XBF_WRITE);
+
+	/*
+	 * Pull in IO completion errors now. We are guaranteed to be running
+	 * single threaded, so we don't need the lock to read b_io_error.
+	 */
+	if (!bp->b_error && bp->b_io_error)
+		xfs_buf_ioerror(bp, bp->b_io_error);
+
+	/* Only validate buffers that were read without errors */
+	if (read && !bp->b_error && bp->b_ops) {
+		ASSERT(!bp->b_iodone);
+		bp->b_ops->verify_read(bp);
+	}
+}
+
+static void
+xfs_buf_complete_io(
+	struct xfs_buf	*bp,
+	int		status)
+{
+
+	/*
+	 * don't overwrite existing errors - otherwise we can lose errors on
+	 * buffers that require multiple bios to complete.
+	 */
+	if (status)
+		cmpxchg(&bp->b_io_error, 0, status);
+
+	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
+		xfs_buf_ioend(bp);
+}
+
+/*
+ * XXX: this will be replaced by an AIO submission engine in future. In the mean
+ * time, just complete the IO synchronously so all the machinery still works.
+ */
+static int
+submit_io(
+	struct xfs_buf *bp,
+	int		fd,
+	void		*buf,
+	xfs_daddr_t	blkno,
+	int		size,
+	bool		write)
+{
+	int		ret;
+
+	if (!write)
+		ret = pread(fd, buf, size, BBTOB(blkno));
+	else
+		ret = pwrite(fd, buf, size, BBTOB(blkno));
+	if (ret < 0)
+		ret = -errno;
+	else if (ret != size)
+		ret = -EIO;
+	else
+		ret = 0;
+	xfs_buf_complete_io(bp, ret);
+	return ret;
+}
+
+static void
+xfs_buftarg_submit_io_map(
+	struct xfs_buf	*bp,
+	int		map,
+	int		*buf_offset,
+	int		*count)
+{
+	int		size;
+	int		offset;
+	bool		rw = (bp->b_flags & XBF_WRITE);
+	int		error;
+
+	offset = *buf_offset;
+
+	/*
+	 * Limit the IO size to the length of the current vector, and update the
+	 * remaining IO count for the next time around.
+	 */
+	size = min_t(int, BBTOB(bp->b_maps[map].bm_len), *count);
+	*count -= size;
+	*buf_offset += size;
+
+	atomic_inc(&bp->b_io_remaining);
+
+	error = submit_io(bp, bp->b_target->bt_fd, bp->b_addr + offset,
+			  bp->b_maps[map].bm_bn, size, rw);
+	if (error) {
+		/*
+		 * This is guaranteed not to be the last io reference count
+		 * because the caller (xfs_buf_submit) holds a count itself.
+		 */
+		atomic_dec(&bp->b_io_remaining);
+		xfs_buf_ioerror(bp, error);
+	}
+}
+
+void
+xfs_buftarg_submit_io(
+	struct xfs_buf	*bp)
+{
+	int		offset;
+	int		size;
+	int		i;
+
+	/*
+	 * Make sure we capture only current IO errors rather than stale errors
+	 * left over from previous use of the buffer (e.g. failed readahead).
+	 */
+	bp->b_error = 0;
+
+	if (bp->b_flags & XBF_WRITE) {
+		/*
+		 * Run the write verifier callback function if it exists. If
+		 * this function fails it will mark the buffer with an error and
+		 * the IO should not be dispatched.
+		 */
+		if (bp->b_ops) {
+			bp->b_ops->verify_write(bp);
+			if (bp->b_error) {
+				xfs_force_shutdown(bp->b_target->bt_mount,
+						   SHUTDOWN_CORRUPT_INCORE);
+				return;
+			}
+		} else if (bp->b_bn != XFS_BUF_DADDR_NULL) {
+			struct xfs_mount *mp = bp->b_target->bt_mount;
+
+			/*
+			 * non-crc filesystems don't attach verifiers during
+			 * log recovery, so don't warn for such filesystems.
+			 */
+			if (xfs_sb_version_hascrc(&mp->m_sb)) {
+				xfs_warn(mp,
+					"%s: no buf ops on daddr 0x%llx len %d",
+					__func__, bp->b_bn, bp->b_length);
+				xfs_hex_dump(bp->b_addr,
+						XFS_CORRUPTION_DUMP_LEN);
+			}
+		}
+	}
+
+	atomic_set(&bp->b_io_remaining, 1);
+
+	/*
+	 * Walk all the vectors issuing IO on them. Set up the initial offset
+	 * into the buffer and the desired IO size before we start -
+	 * xfs_buf_ioapply_map() will modify them appropriately for each
+	 * subsequent call.
+	 */
+	offset = 0;
+	size = BBTOB(bp->b_length);
+	for (i = 0; i < bp->b_map_count; i++) {
+		xfs_buftarg_submit_io_map(bp, i, &offset, &size);
+		if (bp->b_error)
+			break;
+		if (size <= 0)
+			break;	/* all done */
+	}
+
+	xfs_buf_complete_io(bp, bp->b_error);
+}
+
 /*
  * Allocate an uncached buffer that points at daddr.  The refcount will be 1,
  * and the cache node hash list will be empty to indicate that it's uncached.
@@ -140,20 +316,21 @@ xfs_buf_read_uncached(
 	if (error)
 		return error;
 
-	error = libxfs_readbufr(target, daddr, bp, bblen, flags);
-	if (error)
-		goto release_buf;
+	/* set up the buffer for a read IO */
+	ASSERT(bp->b_map_count == 1);
+	bp->b_maps[0].bm_bn = daddr;
+	bp->b_flags |= XBF_READ;
+	bp->b_ops = ops;
 
-	error = libxfs_readbuf_verify(bp, ops);
-	if (error)
-		goto release_buf;
+	xfs_buftarg_submit_io(bp);
+	if (bp->b_error) {
+		error = bp->b_error;
+		xfs_buf_relse(bp);
+		return error;
+	}
 
 	*bpp = bp;
 	return 0;
-
-release_buf:
-	libxfs_buf_relse(bp);
-	return error;
 }
 
 /*
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 7f8fd88f7de8..8408f436e5a5 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -62,6 +62,8 @@ struct xfs_buf {
 	struct xfs_buf_map	*b_maps;
 	struct xfs_buf_map	__b_map;
 	int			b_map_count;
+	int			b_io_remaining;
+	int			b_io_error;
 	struct list_head	b_list;
 };
 
diff --git a/libxfs/xfs_buftarg.h b/libxfs/xfs_buftarg.h
index 5429c96c0547..b6e365c4f5be 100644
--- a/libxfs/xfs_buftarg.h
+++ b/libxfs/xfs_buftarg.h
@@ -60,7 +60,6 @@ int xfs_buftarg_setsize(struct xfs_buftarg *target, unsigned int size);
  * This includes the uncached buffer IO API, as the memory management associated
  * with uncached buffers is tightly tied to the kernel buffer implementation.
  */
-
 void xfs_buf_set_empty(struct xfs_buf *bp, size_t numblks);
 int xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t length);
 
@@ -80,6 +79,9 @@ int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
 			  size_t bblen, int flags, struct xfs_buf **bpp,
 			  const struct xfs_buf_ops *ops);
 
+#define XBF_READ	(1 << 0)
+#define XBF_WRITE	(1 << 1)
+
 /*
  * Raw buffer access functions. These exist as temporary bridges for uncached IO
  * that uses direct access to the buffers to submit IO. These will go away with
-- 
2.28.0

