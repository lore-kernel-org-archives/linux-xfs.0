Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 14:40:09 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0NMe1qw027012
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 14:40:02 -0800
Date: Wed, 24 Jan 2007 09:39:00 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 2/2]: Fix BUG in cancel_dirty_pages on XFS
Message-ID: <20070123223900.GG33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com, akpm@osdl.org

Make XFS use the new truncate_unmap_inode_pages_range()
function.

Signed-off-by: Dave Chinner <dgc@sgi.com>

---
 fs/xfs/linux-2.6/xfs_fs_subr.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_fs_subr.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_fs_subr.c	2007-01-23 18:42:46.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_fs_subr.c	2007-01-23 18:44:53.955160806 +1100
@@ -32,7 +32,8 @@ fs_tosspages(
 	struct inode	*ip = vn_to_inode(vp);
 
 	if (VN_CACHED(vp))
-		truncate_inode_pages(ip->i_mapping, first);
+		truncate_unmap_inode_pages_range(ip->i_mapping,
+						first, last, 1);
 }
 
 void
@@ -49,7 +50,8 @@ fs_flushinval_pages(
 		if (VN_TRUNC(vp))
 			VUNTRUNCATE(vp);
 		filemap_write_and_wait(ip->i_mapping);
-		truncate_inode_pages(ip->i_mapping, first);
+		truncate_unmap_inode_pages_range(ip->i_mapping,
+						first, last, 1);
 	}
 }
 
