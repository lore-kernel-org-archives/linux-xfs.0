Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E0BB7CBB
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 09:45:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62398304066
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 07:45:31 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id UvzZWNHhICrPzRaM (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 07:45:29 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/14] xfs: handle 64-bit length in xfs_iozero
Date: Wed,  1 Jun 2016 16:44:54 +0200
Message-Id: <1464792297-13185-12-git-send-email-hch@lst.de>
In-Reply-To: <1464792297-13185-1-git-send-email-hch@lst.de>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org

We'll want to use this code for large offsets now that we're skipping holes
and unwritten extents efficiently.  Also rename it to xfs_zero_range to be
a bit more descriptive, and tell the caller if we actually did any zeroing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  | 11 ++++++-----
 fs/xfs/xfs_inode.h |  3 ++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 090a90f..294e5f4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -85,10 +85,11 @@ xfs_rw_ilock_demote(
  * Holes and unwritten extents will be left as-is as they already are zeroed.
  */
 int
-xfs_iozero(
+xfs_zero_range(
 	struct xfs_inode	*ip,
-	loff_t			pos,
-	size_t			count)
+	xfs_off_t		pos,
+	xfs_off_t		count,
+	bool			*did_zero)
 {
 	return iomap_zero_range(VFS_I(ip), pos, count, NULL, &xfs_iomap_ops);
 }
@@ -419,7 +420,7 @@ xfs_zero_last_block(
 	if (isize + zero_len > offset)
 		zero_len = offset - isize;
 	*did_zeroing = true;
-	return xfs_iozero(ip, isize, zero_len);
+	return xfs_zero_range(ip, isize, zero_len, NULL);
 }
 
 /*
@@ -518,7 +519,7 @@ xfs_zero_eof(
 		if ((zero_off + zero_len) > offset)
 			zero_len = offset - zero_off;
 
-		error = xfs_iozero(ip, zero_off, zero_len);
+		error = xfs_zero_range(ip, zero_off, zero_len, NULL);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e52d7c7..dbb0bcf 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -434,7 +434,8 @@ int	xfs_update_prealloc_flags(struct xfs_inode *ip,
 				  enum xfs_prealloc_flags flags);
 int	xfs_zero_eof(struct xfs_inode *ip, xfs_off_t offset,
 		     xfs_fsize_t isize, bool *did_zeroing);
-int	xfs_iozero(struct xfs_inode *ip, loff_t pos, size_t count);
+int	xfs_zero_range(struct xfs_inode *ip, xfs_off_t pos, xfs_off_t count,
+		bool *did_zero);
 loff_t	__xfs_seek_hole_data(struct inode *inode, loff_t start,
 			     loff_t eof, int whence);
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
