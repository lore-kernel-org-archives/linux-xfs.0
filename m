Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Jan 2007 20:04:16 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l08447qw032484
	for <xfs@oss.sgi.com>; Sun, 7 Jan 2007 20:04:09 -0800
Date: Mon, 8 Jan 2007 15:03:09 +1100
From: David Chinner <dgc@sgi.com>
Subject: Review: fix mapping invalidation callouts
Message-ID: <20070108040309.GX33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

With the recent cancel_dirty_page() changes, a warning was
added if we cancel a dirty page that is still mapped into
the page tables.
This happens in XFS from fs_tosspages() and fs_flushinval_pages()
because they call truncate_inode_pages().

truncate_inode_pages() does not invalidate existing page mappings;
it is expected taht this is called only when truncating the file
or destroying the inode and on both these cases there can be
no mapped ptes. However, we call this when doing direct I/O writes
to remove pages from the page cache. As a result, we can rip
a page from the page cache that still has mappings attached.

The correct fix is to use invalidate_inode_pages2_range() instead
of truncate_inode_pages(). They essentially do the same thing, but
the former also removes any pte mappings before removing the page
from the page cache.

Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/linux-2.6/xfs_fs_subr.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_fs_subr.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_fs_subr.c	2006-12-12 12:05:17.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_fs_subr.c	2007-01-08 09:30:22.056571711 +1100
@@ -21,6 +21,8 @@ int  fs_noerr(void) { return 0; }
 int  fs_nosys(void) { return ENOSYS; }
 void fs_noval(void) { return; }
 
+#define XFS_OFF_TO_PCSIZE(off)	\
+	(((off) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT)
 void
 fs_tosspages(
 	bhv_desc_t	*bdp,
@@ -32,7 +34,9 @@ fs_tosspages(
 	struct inode	*ip = vn_to_inode(vp);
 
 	if (VN_CACHED(vp))
-		truncate_inode_pages(ip->i_mapping, first);
+		invalidate_inode_pages2_range(ip->i_mapping,
+					XFS_OFF_TO_PCSIZE(first),
+					XFS_OFF_TO_PCSIZE(last));
 }
 
 void
@@ -49,7 +53,9 @@ fs_flushinval_pages(
 		if (VN_TRUNC(vp))
 			VUNTRUNCATE(vp);
 		filemap_write_and_wait(ip->i_mapping);
-		truncate_inode_pages(ip->i_mapping, first);
+		invalidate_inode_pages2_range(ip->i_mapping,
+					XFS_OFF_TO_PCSIZE(first),
+					XFS_OFF_TO_PCSIZE(last));
 	}
 }
 
