Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43482 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfFUT5b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 15:57:31 -0400
Subject: [PATCH 4/6] libxfs: fix buffer refcounting in delwri_queue
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 21 Jun 2019 12:57:24 -0700
Message-ID: <156114704472.1643538.14565976860288969023.stgit@magnolia>
In-Reply-To: <156114701371.1643538.316410894576032261.stgit@magnolia>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In the kernel, xfs_buf_delwri_queue increments the buffer reference
count before putting the buffer on the buffer list, and the refcount is
decremented after the io completes for a net refcount change of zero.

In userspace, delwri_queue calls libxfs_writebuf, which puts the buffer.
delwri_queue is a no-op, for a net refcount change of -1.  This creates
problems for any callers that expect a net change of zero, so increment
the buffer refcount before calling writebuf.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h   |    7 +++++++
 libxfs/libxfs_priv.h |    1 -
 2 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index b6f8756a..c47a435d 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -243,4 +243,11 @@ xfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags)
 	return bp;
 }
 
+static inline void
+xfs_buf_delwri_queue(struct xfs_buf *bp, struct list_head *buffer_list)
+{
+	bp->b_node.cn_count++;
+	libxfs_writebuf(bp, 0);
+}
+
 #endif	/* __LIBXFS_IO_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index eb92942a..fd420f4f 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -381,7 +381,6 @@ roundup_64(uint64_t x, uint32_t y)
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
-#define xfs_buf_delwri_queue(bp, bl)	libxfs_writebuf((bp), 0)
 #define xfs_buf_delwri_submit(bl)	(0)
 #define xfs_buf_oneshot(bp)		((void) 0)
 
