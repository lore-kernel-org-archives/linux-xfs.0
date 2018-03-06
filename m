Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58368 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753805AbeCFVyJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 16:54:09 -0500
Subject: [PATCH 1/5] libxfs: Replace XFS_BUF_SET_PTR with
 xfs_buf_associate_memory
References: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bc3750b9-7aec-aad3-f7f8-e5a1ef39e6b8@sandeen.net>
Date: Tue, 6 Mar 2018 15:54:08 -0600
MIME-Version: 1.0
In-Reply-To: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

We test the return value of this macro, but it returns
a side-effect which looks like failure.  Write a
userspace-libxfs-specific version of xfs_buf_associate_memory
to make this code a tad more like the kernel, with a proper
return value to boot.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/libxfs_io.h        | 12 ++++++++----
 libxlog/xfs_log_recover.c |  4 ++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 6308a74..78b6780 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -103,10 +103,6 @@ enum xfs_buf_flags_t {	/* b_flags bits */
 #define XFS_BUF_SIZE(bp)		((bp)->b_bcount)
 #define XFS_BUF_COUNT(bp)		((bp)->b_bcount)
 #define XFS_BUF_TARGET(bp)		((bp)->b_dev)
-#define XFS_BUF_SET_PTR(bp,p,cnt)	({	\
-	(bp)->b_addr = (char *)(p);		\
-	XFS_BUF_SET_COUNT(bp,cnt);		\
-})
 
 #define XFS_BUF_SET_ADDR(bp,blk)	((bp)->b_bn = (blk))
 #define XFS_BUF_SET_COUNT(bp,cnt)	((bp)->b_bcount = (cnt))
@@ -230,4 +226,12 @@ xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
 			 cksum_offset);
 }
 
+static inline int
+xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t len)
+{
+	bp->b_addr = mem;
+	bp->b_bcount = len;
+	return 0;
+}
+
 #endif	/* __LIBXFS_IO_H__ */
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 6bd000c..58d9182 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -171,14 +171,14 @@ xlog_bread_offset(
 	int		orig_len = bp->b_bcount;
 	int		error, error2;
 
-	error = XFS_BUF_SET_PTR(bp, offset, BBTOB(nbblks));
+	error = xfs_buf_associate_memory(bp, offset, BBTOB(nbblks));
 	if (error)
 		return error;
 
 	error = xlog_bread_noalign(log, blk_no, nbblks, bp);
 
 	/* must reset buffer pointer even on error */
-	error2 = XFS_BUF_SET_PTR(bp, orig_offset, orig_len);
+	error2 = xfs_buf_associate_memory(bp, orig_offset, orig_len);
 	if (error)
 		return error;
 	return error2;
-- 
1.8.3.1


