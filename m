Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p74EE6oS071765 for <xfs@oss.sgi.com>; Thu, 4 Aug 2011 09:14:06 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A9D31BAF481
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2011 07:14:04 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id pbsuWiCOXdzVmGkE for <xfs@oss.sgi.com>;
	Thu, 04 Aug 2011 07:14:04 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] xfs: Replace async callers of xfs_flush_pages()
Date: Thu,  4 Aug 2011 16:13:55 +0200
Message-Id: <1312467236-31341-2-git-send-email-jack@suse.cz>
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

There are three places calling xfs_flush_pages() with XBF_ASYNC flag.  Two of
them - xfs_release() and xfs_sync_inode_data() - want just to start writeback
of all inode pages thus change them to use filemap_flush() so that they don't
unnecessarily use WB_SYNC_ALL writeback. The third place in xfs_setattr_size()
is starting a synchronous writeback in fact so keep using
filemap_fdatawrite_range() there.  This way we can also get rid of abusing
XBF_ASYNC flag.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/linux-2.6/xfs_fs_subr.c |    2 --
 fs/xfs/linux-2.6/xfs_iops.c    |    4 ++--
 fs/xfs/linux-2.6/xfs_sync.c    |    7 +++++--
 fs/xfs/xfs_vnodeops.c          |    2 +-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_fs_subr.c b/fs/xfs/linux-2.6/xfs_fs_subr.c
index ed88ed1..4888b78 100644
--- a/fs/xfs/linux-2.6/xfs_fs_subr.c
+++ b/fs/xfs/linux-2.6/xfs_fs_subr.c
@@ -72,8 +72,6 @@ xfs_flush_pages(
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 	ret = -filemap_fdatawrite_range(mapping, first,
 				last == -1 ? LLONG_MAX : last);
-	if (flags & XBF_ASYNC)
-		return ret;
 	ret2 = xfs_wait_on_pages(ip, first, last);
 	if (!ret)
 		ret = ret2;
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index b9c172b..ea935fc 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -825,8 +825,8 @@ xfs_setattr_size(
 	 * care about here.
 	 */
 	if (ip->i_size != ip->i_d.di_size && iattr->ia_size > ip->i_d.di_size) {
-		error = xfs_flush_pages(ip, ip->i_d.di_size, iattr->ia_size,
-					XBF_ASYNC, FI_NONE);
+		error = -filemap_fdatawrite_range(inode->i_mapping,
+					ip->i_d.di_size, iattr->ia_size);
 		if (error)
 			goto out_unlock;
 	}
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index e4c938a..cce4d58 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -235,8 +235,11 @@ xfs_sync_inode_data(
 		xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	}
 
-	error = xfs_flush_pages(ip, 0, -1, (flags & SYNC_WAIT) ?
-				0 : XBF_ASYNC, FI_NONE);
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
+	if (flags & SYNC_WAIT)
+		error = xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
+	else
+		error = -filemap_flush(mapping);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
  out_wait:
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 9322e13..71d066c 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -522,7 +522,7 @@ xfs_release(
 		if (truncated) {
 			xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
 			if (VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0)
-				xfs_flush_pages(ip, 0, -1, XBF_ASYNC, FI_NONE);
+				filemap_flush(VFS_I(ip)->i_mapping);
 		}
 	}
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
