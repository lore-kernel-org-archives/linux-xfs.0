Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p74EE6Be071769 for <xfs@oss.sgi.com>; Thu, 4 Aug 2011 09:14:06 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 262AE1BAF484
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2011 07:14:04 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id p4C0ptN0s9U0MWym for <xfs@oss.sgi.com>;
	Thu, 04 Aug 2011 07:14:04 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] xfs: Remove xfs_flush_pages() helper
Date: Thu,  4 Aug 2011 16:13:56 +0200
Message-Id: <1312467236-31341-3-git-send-email-jack@suse.cz>
In-Reply-To: <1312467236-31341-1-git-send-email-jack@suse.cz>
References: <1312467236-31341-1-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

The helper is not that much useful since it is equivalent of
filemap_write_and_wait{_range}() plus clearing of XFS_ITRUNCATED bit. So just
make the call explicit and remove the helper. Also remove the now unused
xfs_wait_on_pages() helper.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/linux-2.6/xfs_aops.c    |    3 ++-
 fs/xfs/linux-2.6/xfs_file.c    |    3 ++-
 fs/xfs/linux-2.6/xfs_fs_subr.c |   36 ------------------------------------
 fs/xfs/linux-2.6/xfs_sync.c    |    2 +-
 fs/xfs/xfs_bmap.c              |    3 ++-
 fs/xfs/xfs_vnodeops.h          |    3 ---
 6 files changed, 7 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 63e971e..4a185d7 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1459,7 +1459,8 @@ xfs_vm_bmap(
 
 	trace_xfs_vm_bmap(XFS_I(inode));
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	xfs_flush_pages(ip, (xfs_off_t)0, -1, 0, FI_REMAPF);
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
+	filemap_write_and_wait(mapping);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 	return generic_block_bmap(mapping, block, xfs_get_blocks);
 }
diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 7f7b424..ba059b1 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -827,7 +827,8 @@ write_retry:
 	 * page locks and retry *once*
 	 */
 	if (ret == -ENOSPC && !enospc) {
-		ret = -xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
+		xfs_iflags_clear(ip, XFS_ITRUNCATED);
+		ret = filemap_write_and_wait(mapping);
 		if (ret)
 			return ret;
 		enospc = 1;
diff --git a/fs/xfs/linux-2.6/xfs_fs_subr.c b/fs/xfs/linux-2.6/xfs_fs_subr.c
index 4888b78..f763fb4 100644
--- a/fs/xfs/linux-2.6/xfs_fs_subr.c
+++ b/fs/xfs/linux-2.6/xfs_fs_subr.c
@@ -56,39 +56,3 @@ xfs_flushinval_pages(
 		truncate_inode_pages_range(mapping, first, last);
 	return -ret;
 }
-
-int
-xfs_flush_pages(
-	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last,
-	uint64_t	flags,
-	int		fiopt)
-{
-	struct address_space *mapping = VFS_I(ip)->i_mapping;
-	int		ret = 0;
-	int		ret2;
-
-	xfs_iflags_clear(ip, XFS_ITRUNCATED);
-	ret = -filemap_fdatawrite_range(mapping, first,
-				last == -1 ? LLONG_MAX : last);
-	ret2 = xfs_wait_on_pages(ip, first, last);
-	if (!ret)
-		ret = ret2;
-	return ret;
-}
-
-int
-xfs_wait_on_pages(
-	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last)
-{
-	struct address_space *mapping = VFS_I(ip)->i_mapping;
-
-	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
-		return -filemap_fdatawait_range(mapping, first,
-					last == -1 ? ip->i_size - 1 : last);
-	}
-	return 0;
-}
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index cce4d58..7374d00 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -237,7 +237,7 @@ xfs_sync_inode_data(
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 	if (flags & SYNC_WAIT)
-		error = xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
+		error = -filemap_write_and_wait(mapping);
 	else
 		error = -filemap_flush(mapping);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index ab3e5c6..54d0b48 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5459,7 +5459,8 @@ xfs_getbmap(
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
 		if (ip->i_delayed_blks || ip->i_size > ip->i_d.di_size) {
-			error = xfs_flush_pages(ip, 0, -1, 0, FI_REMAPF);
+			xfs_iflags_clear(ip, XFS_ITRUNCATED);
+			error = -filemap_write_and_wait(VFS_I(ip)->i_mapping);
 			if (error)
 				goto out_unlock_iolock;
 		}
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index 35d3d51..38bb4da 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -55,9 +55,6 @@ void xfs_tosspages(struct xfs_inode *inode, xfs_off_t first,
 		xfs_off_t last, int fiopt);
 int xfs_flushinval_pages(struct xfs_inode *ip, xfs_off_t first,
 		xfs_off_t last, int fiopt);
-int xfs_flush_pages(struct xfs_inode *ip, xfs_off_t first,
-		xfs_off_t last, uint64_t flags, int fiopt);
-int xfs_wait_on_pages(struct xfs_inode *ip, xfs_off_t first, xfs_off_t last);
 
 int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
