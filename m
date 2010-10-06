Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96IeNVW110173 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 13:40:23 -0500
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 602BC1C01E0E
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 11:41:26 -0700 (PDT)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id QSBYF5MvLRNY39KJ for
	<xfs@oss.sgi.com>; Wed, 06 Oct 2010 11:41:26 -0700 (PDT)
Received: from hch by canuck.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P3Yve-00019D-1z
	for xfs@oss.sgi.com; Wed, 06 Oct 2010 18:41:26 +0000
Message-Id: <20101006184125.895296316@localhost.localdomain>
Date: Wed, 06 Oct 2010 14:41:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/7] xfs: remove xfs_refcache.h
References: <20101006184111.634126439@localhost.localdomain>
Content-Disposition: inline; filename=xfs-kill-xfs_refcache.h
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
To: xfs@oss.sgi.com

This header has been completely unused for a couple of years.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_refcache.h
===================================================================
--- xfs.orig/fs/xfs/xfs_refcache.h	2010-09-06 10:18:29.074253757 -0300
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,52 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_REFCACHE_H__
-#define __XFS_REFCACHE_H__
-
-#ifdef HAVE_REFCACHE
-/*
- * Maximum size (in inodes) for the NFS reference cache
- */
-#define XFS_REFCACHE_SIZE_MAX	512
-
-struct xfs_inode;
-struct xfs_mount;
-
-extern void xfs_refcache_insert(struct xfs_inode *);
-extern void xfs_refcache_purge_ip(struct xfs_inode *);
-extern void xfs_refcache_purge_mp(struct xfs_mount *);
-extern void xfs_refcache_purge_some(struct xfs_mount *);
-extern void xfs_refcache_resize(int);
-extern void xfs_refcache_destroy(void);
-
-extern void xfs_refcache_iunlock(struct xfs_inode *, uint);
-
-#else
-
-#define xfs_refcache_insert(ip)		do { } while (0)
-#define xfs_refcache_purge_ip(ip)	do { } while (0)
-#define xfs_refcache_purge_mp(mp)	do { } while (0)
-#define xfs_refcache_purge_some(mp)	do { } while (0)
-#define xfs_refcache_resize(size)	do { } while (0)
-#define xfs_refcache_destroy()		do { } while (0)
-
-#define xfs_refcache_iunlock(ip, flags)	xfs_iunlock(ip, flags)
-
-#endif
-
-#endif	/* __XFS_REFCACHE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
