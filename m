Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3G5EOKv171374 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 00:14:24 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Dzen9WBmU7YvfQmD for <xfs@oss.sgi.com>;
	Sun, 15 Apr 2012 22:14:22 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SJeGU-0000mC-8M
	for xfs@oss.sgi.com; Mon, 16 Apr 2012 15:14:14 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SJeGU-0005NC-5a
	for xfs@oss.sgi.com; Mon, 16 Apr 2012 15:14:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/7] xfs: move xfs_get_extsz_hint() and kill xfs_rw.h
Date: Mon, 16 Apr 2012 15:14:09 +1000
Message-Id: <1334553251-20571-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1334553251-20571-1-git-send-email-david@fromorbit.com>
References: <1334553251-20571-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The only thing left in xfs_rw.h is a function prototype for an inode
function.  Move that to xfs_inode.h, and kill xfs_rw.h.

Also move the function implementing the prototype from xfs_rw.c to
xfs_inode.c so we only have one function left in xfs_rw.c

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c        |    1 -
 fs/xfs/xfs_attr.c        |    1 -
 fs/xfs/xfs_bmap.c        |    1 -
 fs/xfs/xfs_fsops.c       |    1 -
 fs/xfs/xfs_inode.c       |   14 ++++++++++++++
 fs/xfs/xfs_inode.h       |    2 ++
 fs/xfs/xfs_iomap.c       |    1 -
 fs/xfs/xfs_iops.c        |    1 -
 fs/xfs/xfs_log.c         |    1 -
 fs/xfs/xfs_log_recover.c |    1 -
 fs/xfs/xfs_mount.c       |    1 -
 fs/xfs/xfs_rtalloc.c     |    1 -
 fs/xfs/xfs_rw.c          |   15 ---------------
 fs/xfs/xfs_rw.h          |   30 ------------------------------
 fs/xfs/xfs_trans_buf.c   |    1 -
 15 files changed, 16 insertions(+), 56 deletions(-)
 delete mode 100644 fs/xfs/xfs_rw.h

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1194bdc..5584c5c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -28,7 +28,6 @@
 #include "xfs_inode_item.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
-#include "xfs_rw.h"
 #include "xfs_iomap.h"
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 561fd60..a17ff01 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -38,7 +38,6 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
-#include "xfs_rw.h"
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 1e58bc3..26ab256 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -41,7 +41,6 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_attr_leaf.h"
-#include "xfs_rw.h"
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_buf_item.h"
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 2635e17..f6c7698 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -38,7 +38,6 @@
 #include "xfs_itable.h"
 #include "xfs_trans_space.h"
 #include "xfs_rtalloc.h"
-#include "xfs_rw.h"
 #include "xfs_filestream.h"
 #include "xfs_trace.h"
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f64b482..c6fb5f0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -61,6 +61,20 @@ STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
 STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
 STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
 
+/*
+ * helper function to extract extent size hint from inode
+ */
+xfs_extlen_t
+xfs_get_extsz_hint(
+	struct xfs_inode	*ip)
+{
+	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
+		return ip->i_d.di_extsize;
+	if (XFS_IS_REALTIME_INODE(ip))
+		return ip->i_mount->m_sb.sb_rextsize;
+	return 0;
+}
+
 #ifdef DEBUG
 /*
  * Make sure that the extents in the given memory buffer
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index f0e252f..1efff36 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -533,6 +533,8 @@ int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
 void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
 
+xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
+
 #define IHOLD(ip) \
 do { \
 	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0a6b7ff..845cea0 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -36,7 +36,6 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_itable.h"
-#include "xfs_rw.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_space.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e6d6a32..e7a6660 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -33,7 +33,6 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_itable.h"
-#include "xfs_rw.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index dec1458..97e489b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -34,7 +34,6 @@
 #include "xfs_trans_priv.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_rw.h"
 #include "xfs_trace.h"
 
 kmem_zone_t	*xfs_log_ticket_zone;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b700ced..574e2e9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -40,7 +40,6 @@
 #include "xfs_extfree_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_quota.h"
-#include "xfs_rw.h"
 #include "xfs_utils.h"
 #include "xfs_trace.h"
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 89be5ff..f511d22 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -38,7 +38,6 @@
 #include "xfs_rtalloc.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
-#include "xfs_rw.h"
 #include "xfs_quota.h"
 #include "xfs_fsops.h"
 #include "xfs_utils.h"
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b6ef74d..92d4331 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -33,7 +33,6 @@
 #include "xfs_rtalloc.h"
 #include "xfs_fsops.h"
 #include "xfs_error.h"
-#include "xfs_rw.h"
 #include "xfs_inode_item.h"
 #include "xfs_trans_space.h"
 #include "xfs_utils.h"
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index 7e3644f..c406cb6 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -28,7 +28,6 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_error.h"
-#include "xfs_rw.h"
 
 /*
  * Force a shutdown of the filesystem instantly while keeping
@@ -89,17 +88,3 @@ xfs_do_force_shutdown(
 	"Please umount the filesystem and rectify the problem(s)");
 	}
 }
-
-/*
- * helper function to extract extent size hint from inode
- */
-xfs_extlen_t
-xfs_get_extsz_hint(
-	struct xfs_inode	*ip)
-{
-	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
-		return ip->i_d.di_extsize;
-	if (XFS_IS_REALTIME_INODE(ip))
-		return ip->i_mount->m_sb.sb_rextsize;
-	return 0;
-}
diff --git a/fs/xfs/xfs_rw.h b/fs/xfs/xfs_rw.h
deleted file mode 100644
index 13f6317..0000000
--- a/fs/xfs/xfs_rw.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
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
-#ifndef	__XFS_RW_H__
-#define	__XFS_RW_H__
-
-struct xfs_buf;
-struct xfs_inode;
-struct xfs_mount;
-
-/*
- * Prototypes for functions in xfs_rw.c.
- */
-extern xfs_extlen_t xfs_get_extsz_hint(struct xfs_inode *ip);
-
-#endif /* __XFS_RW_H__ */
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 7d69213..743d7a5 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -32,7 +32,6 @@
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
-#include "xfs_rw.h"
 #include "xfs_trace.h"
 
 /*
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
