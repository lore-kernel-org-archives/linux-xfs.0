Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Feb 2008 22:19:22 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1N6J8jj028662
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 22:19:13 -0800
Date: Sat, 23 Feb 2008 17:19:24 +1100
From: David Chinner <dgc@sgi.com>
Subject: [patch] fix inode leak in xfs_iget_core()
Message-ID: <20080223061924.GI155259@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

If the radix_tree_preload() fails, we need to destroy the
inode we just read in before trying again. This could leak
xfs_vnode structures when there is memory pressure. Noticed
by Christoph Hellwig.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_iget.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2008-02-15 19:27:02.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2008-02-23 16:51:31.602711856 +1100
@@ -232,6 +232,7 @@ finish_inode:
 	 * write spinlock.
 	 */
 	if (radix_tree_preload(GFP_KERNEL)) {
+		xfs_idestroy(ip);
 		delay(1);
 		goto again;
 	}
