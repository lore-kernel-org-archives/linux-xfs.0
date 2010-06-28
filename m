Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM277D044166 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:02:08 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006282204.o5SM4qbU018132@stout.americas.sgi.com>
Date: Mon, 28 Jun 2010 17:04:52 -0500
Subject: [PATCH 03/15] xfs: move DMAPI definitions out of "xfs_mount.h"
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

XFS defines a bunch of DMAPI cruft in xfs_mount.h.  There is no need
for it to be there; move it instead into the xfs_dmapi.h file.  A
side-effect of this is that "xfs_dmapi.h" now depends on and needs
to be #included after "xfs_mount.h" and "xfs_inode.h" (the latter of
which itself depends on a "xfs_bmap_btree.h").

On the other hand, "xfs_dmapi.h" is #included by a LOT more files
than it needs to be, so eliminate those cases.

Finally, "xfs_inode.h" defines a type dm_attrs_t that is never
referenced anywhere else, so kill it off.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/linux-2.6/xfs_aops.c     |    3 -
 fs/xfs/linux-2.6/xfs_buf.c      |    3 -
 fs/xfs/linux-2.6/xfs_export.c   |    3 -
 fs/xfs/linux-2.6/xfs_file.c     |    2 -
 fs/xfs/linux-2.6/xfs_ioctl.c    |    4 +-
 fs/xfs/linux-2.6/xfs_ioctl32.c  |    3 -
 fs/xfs/linux-2.6/xfs_quotaops.c |    2 -
 fs/xfs/linux-2.6/xfs_super.c    |    4 +-
 fs/xfs/linux-2.6/xfs_sync.c     |    3 -
 fs/xfs/quota/xfs_dquot.c        |    3 -
 fs/xfs/quota/xfs_dquot_item.c   |    3 -
 fs/xfs/quota/xfs_qm.c           |    3 -
 fs/xfs/quota/xfs_qm_bhv.c       |    3 -
 fs/xfs/quota/xfs_qm_stats.c     |    3 -
 fs/xfs/quota/xfs_qm_syscalls.c  |    3 -
 fs/xfs/quota/xfs_trans_dquot.c  |    3 -
 fs/xfs/support/debug.c          |    3 -
 fs/xfs/xfs_alloc.c              |    3 -
 fs/xfs/xfs_alloc_btree.c        |    3 -
 fs/xfs/xfs_attr.c               |    3 -
 fs/xfs/xfs_attr_leaf.c          |    3 -
 fs/xfs/xfs_bmap.c               |    4 +-
 fs/xfs/xfs_bmap_btree.c         |    3 -
 fs/xfs/xfs_btree.c              |    3 -
 fs/xfs/xfs_buf_item.c           |    3 -
 fs/xfs/xfs_da_btree.c           |    3 -
 fs/xfs/xfs_dfrag.c              |    3 -
 fs/xfs/xfs_dir2.c               |    3 -
 fs/xfs/xfs_dir2_block.c         |    3 -
 fs/xfs/xfs_dir2_data.c          |    3 -
 fs/xfs/xfs_dir2_leaf.c          |    3 -
 fs/xfs/xfs_dir2_node.c          |    3 -
 fs/xfs/xfs_dir2_sf.c            |    3 -
 fs/xfs/xfs_dmapi.h              |   61 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dmops.c              |    6 ++-
 fs/xfs/xfs_error.c              |    3 -
 fs/xfs/xfs_extfree_item.c       |    3 -
 fs/xfs/xfs_filestream.c         |    3 -
 fs/xfs/xfs_fsops.c              |    3 -
 fs/xfs/xfs_ialloc.c             |    3 -
 fs/xfs/xfs_ialloc_btree.c       |    3 -
 fs/xfs/xfs_iget.c               |    3 -
 fs/xfs/xfs_inode.c              |    3 -
 fs/xfs/xfs_inode.h              |    8 ----
 fs/xfs/xfs_inode_item.c         |    3 -
 fs/xfs/xfs_iomap.c              |    3 -
 fs/xfs/xfs_itable.c             |    3 -
 fs/xfs/xfs_log.c                |    3 -
 fs/xfs/xfs_log_recover.c        |    3 -
 fs/xfs/xfs_mount.c              |    3 -
 fs/xfs/xfs_mount.h              |   66 ----------------------------------------
 fs/xfs/xfs_rename.c             |    4 +-
 fs/xfs/xfs_rtalloc.c            |    3 -
 fs/xfs/xfs_rw.c                 |    3 -
 fs/xfs/xfs_trans.c              |    3 -
 fs/xfs/xfs_trans_ail.c          |    3 -
 fs/xfs/xfs_trans_buf.c          |    3 -
 fs/xfs/xfs_trans_extfree.c      |    3 -
 fs/xfs/xfs_trans_inode.c        |    3 -
 fs/xfs/xfs_trans_item.c         |    3 -
 fs/xfs/xfs_utils.c              |    3 -
 fs/xfs/xfs_vnodeops.c           |    2 -
 62 files changed, 129 insertions(+), 187 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -23,7 +23,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_trans.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2006, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -39,7 +39,6 @@
 #include "xfs_inum.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trace.h"
 
Index: b/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2004-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2004-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -23,7 +23,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_export.h"
 #include "xfs_vnodeops.h"
Index: b/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -24,7 +24,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_trans.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
@@ -36,6 +35,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
+#include "xfs_dmapi.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
 #include "xfs_rw.h"
Index: b/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
@@ -34,6 +33,7 @@
 #include "xfs_dir2_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_dmapi.h"
 #include "xfs_ioctl.h"
 #include "xfs_btree.h"
 #include "xfs_ialloc.h"
Index: b/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2004-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2004-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -29,7 +29,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_attr_sf.h"
Index: b/fs/xfs/linux-2.6/xfs_quotaops.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_quotaops.c
+++ b/fs/xfs/linux-2.6/xfs_quotaops.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2008, Christoph Hellwig
+ * Copyright (c) 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -16,7 +17,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
-#include "xfs_dmapi.h"
 #include "xfs_sb.h"
 #include "xfs_inum.h"
 #include "xfs_log.h"
Index: b/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2006, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
@@ -35,6 +34,7 @@
 #include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_dmapi.h"
 #include "xfs_btree.h"
 #include "xfs_btree_trace.h"
 #include "xfs_ialloc.h"
Index: b/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/quota/xfs_dquot.c
===================================================================
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2003 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2003, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- a/fs/xfs/quota/xfs_dquot_item.c
+++ b/fs/xfs/quota/xfs_dquot_item.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2003 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2003, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/quota/xfs_qm.c
===================================================================
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/quota/xfs_qm_bhv.c
===================================================================
--- a/fs/xfs/quota/xfs_qm_bhv.c
+++ b/fs/xfs/quota/xfs_qm_bhv.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2006, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/quota/xfs_qm_stats.c
===================================================================
--- a/fs/xfs/quota/xfs_qm_stats.c
+++ b/fs/xfs/quota/xfs_qm_stats.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2003 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2003, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -28,7 +28,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- a/fs/xfs/quota/xfs_trans_dquot.c
+++ b/fs/xfs/quota/xfs_trans_dquot.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2002 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2002, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/support/debug.c
===================================================================
--- a/fs/xfs/support/debug.c
+++ b/fs/xfs/support/debug.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2003, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -22,7 +22,6 @@
 #include "xfs_sb.h"
 #include "xfs_inum.h"
 #include "xfs_ag.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 
Index: b/fs/xfs/xfs_alloc.c
===================================================================
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2002, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_alloc_btree.c
===================================================================
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2001, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_attr.c
===================================================================
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -26,7 +26,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/xfs_attr_leaf.c
===================================================================
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2006, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -34,8 +34,8 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
+#include "xfs_dmapi.h"
 #include "xfs_ialloc.h"
 #include "xfs_itable.h"
 #include "xfs_dir2_data.h"
Index: b/fs/xfs/xfs_bmap_btree.c
===================================================================
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2003, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_btree.c
===================================================================
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2002, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_buf_item.c
===================================================================
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -24,7 +24,6 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
Index: b/fs/xfs/xfs_da_btree.c
===================================================================
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/xfs_dfrag.c
===================================================================
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2006, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_dir2.c
===================================================================
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2001, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/xfs_dir2_block.c
===================================================================
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2003, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -24,7 +24,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/xfs_dir2_data.c
===================================================================
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2002, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -24,7 +24,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2003, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/xfs_dir2_node.c
===================================================================
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -24,7 +24,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/xfs_dir2_sf.c
===================================================================
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2003, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -24,7 +24,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/xfs_dmapi.h
===================================================================
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -167,4 +167,65 @@ typedef enum {
 			DM_FLAGS_NDELAY : 0)
 #define AT_DELAY_FLAG(f) ((f & XFS_ATTR_NONBLOCK) ? DM_FLAGS_NDELAY : 0)
 
+/*
+ * Prototypes and functions for the Data Migration subsystem.
+ */
+
+extern int	xfs_dmops_get(struct xfs_mount *);
+extern void	xfs_dmops_put(struct xfs_mount *);
+
+extern struct xfs_dmops xfs_dmcore_xfs;
+
+typedef int	(*xfs_send_data_t)(int, struct xfs_inode *,
+			xfs_off_t, size_t, int, int *);
+typedef int	(*xfs_send_mmap_t)(struct vm_area_struct *, uint);
+typedef int	(*xfs_send_destroy_t)(struct xfs_inode *, dm_right_t);
+typedef int	(*xfs_send_namesp_t)(dm_eventtype_t, struct xfs_mount *,
+			struct xfs_inode *, dm_right_t,
+			struct xfs_inode *, dm_right_t,
+			const char *, const char *, mode_t, int, int);
+typedef int	(*xfs_send_mount_t)(struct xfs_mount *, dm_right_t,
+			char *, char *);
+typedef void	(*xfs_send_unmount_t)(struct xfs_mount *, struct xfs_inode *,
+			dm_right_t, mode_t, int, int);
+
+typedef struct xfs_dmops {
+	xfs_send_data_t		xfs_send_data;
+	xfs_send_mmap_t		xfs_send_mmap;
+	xfs_send_destroy_t	xfs_send_destroy;
+	xfs_send_namesp_t	xfs_send_namesp;
+	xfs_send_mount_t	xfs_send_mount;
+	xfs_send_unmount_t	xfs_send_unmount;
+} xfs_dmops_t;
+
+#define XFS_DMAPI_UNMOUNT_FLAGS(mp) \
+	(((mp)->m_dmevmask & (1 << DM_EVENT_UNMOUNT)) ? 0 : DM_FLAGS_UNWANTED)
+
+#define XFS_SEND_DATA(mp, ev,ip,off,len,fl,lock) \
+	(*(mp)->m_dm_ops->xfs_send_data)(ev,ip,off,len,fl,lock)
+#define XFS_SEND_MMAP(mp, vma,fl) \
+	(*(mp)->m_dm_ops->xfs_send_mmap)(vma,fl)
+#define XFS_SEND_DESTROY(mp, ip,right) \
+	(*(mp)->m_dm_ops->xfs_send_destroy)(ip,right)
+#define XFS_SEND_NAMESP(mp, ev,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
+	(*(mp)->m_dm_ops->xfs_send_namesp)(ev,NULL,b1,r1,b2,r2,n1,n2,mode,rval,fl)
+#define XFS_SEND_MOUNT(mp,right,path,name) \
+	(*(mp)->m_dm_ops->xfs_send_mount)(mp,right,path,name)
+#define XFS_SEND_PREUNMOUNT(mp) \
+do { \
+	if (mp->m_flags & XFS_MOUNT_DMAPI) { \
+		(*(mp)->m_dm_ops->xfs_send_namesp)(DM_EVENT_PREUNMOUNT, mp, \
+			(mp)->m_rootip, DM_RIGHT_NULL, \
+			(mp)->m_rootip, DM_RIGHT_NULL, \
+			NULL, NULL, 0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp)); \
+	} \
+} while (0)
+#define XFS_SEND_UNMOUNT(mp) \
+do { \
+	if (mp->m_flags & XFS_MOUNT_DMAPI) { \
+		(*(mp)->m_dm_ops->xfs_send_unmount)(mp, (mp)->m_rootip, \
+			DM_RIGHT_NULL, 0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp)); \
+	} \
+} while (0)
+
 #endif  /* __XFS_DMAPI_H__ */
Index: b/fs/xfs/xfs_dmops.c
===================================================================
--- a/fs/xfs/xfs_dmops.c
+++ b/fs/xfs/xfs_dmops.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2003, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -21,10 +21,12 @@
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
-#include "xfs_dmapi.h"
 #include "xfs_inum.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_dmapi.h"
 
 
 static struct xfs_dmops xfs_dmcore_stub = {
Index: b/fs/xfs/xfs_error.c
===================================================================
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2001, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -24,7 +24,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_dir2_sf.h"
Index: b/fs/xfs/xfs_extfree_item.c
===================================================================
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2001, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -24,7 +24,6 @@
 #include "xfs_buf_item.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
 #include "xfs_extfree_item.h"
Index: b/fs/xfs/xfs_filestream.c
===================================================================
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006-2007 Silicon Graphics, Inc.
+ * Copyright (c) 2006-2007, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -24,7 +24,6 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_ag.h"
-#include "xfs_dmapi.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
Index: b/fs/xfs/xfs_fsops.c
===================================================================
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_ialloc.c
===================================================================
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2002, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2001, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_iget.c
===================================================================
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -26,7 +26,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_inode.c
===================================================================
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2006, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -28,7 +28,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_inode.h
===================================================================
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2003, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -221,12 +221,6 @@ struct xfs_mount;
 struct xfs_trans;
 struct xfs_dquot;
 
-typedef struct dm_attrs_s {
-	__uint32_t	da_dmevmask;	/* DMIG event mask */
-	__uint16_t	da_dmstate;	/* DMIG state info */
-	__uint16_t	da_pad;		/* DMIG extra padding */
-} dm_attrs_t;
-
 typedef struct xfs_inode {
 	/* Inode linking and identification information. */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
Index: b/fs/xfs/xfs_inode_item.c
===================================================================
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2002, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -26,7 +26,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/xfs_iomap.c
===================================================================
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2006, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_alloc.h"
-#include "xfs_dmapi.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/xfs_itable.c
===================================================================
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2002, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2006, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_bmap_btree.h"
Index: b/fs/xfs/xfs_mount.c
===================================================================
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_mount.h
===================================================================
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -66,65 +66,6 @@ struct xfs_nameops;
 struct xfs_ail;
 struct xfs_quotainfo;
 
-
-/*
- * Prototypes and functions for the Data Migration subsystem.
- */
-
-typedef int	(*xfs_send_data_t)(int, struct xfs_inode *,
-			xfs_off_t, size_t, int, int *);
-typedef int	(*xfs_send_mmap_t)(struct vm_area_struct *, uint);
-typedef int	(*xfs_send_destroy_t)(struct xfs_inode *, dm_right_t);
-typedef int	(*xfs_send_namesp_t)(dm_eventtype_t, struct xfs_mount *,
-			struct xfs_inode *, dm_right_t,
-			struct xfs_inode *, dm_right_t,
-			const unsigned char *, const unsigned char *,
-			mode_t, int, int);
-typedef int	(*xfs_send_mount_t)(struct xfs_mount *, dm_right_t,
-			char *, char *);
-typedef void	(*xfs_send_unmount_t)(struct xfs_mount *, struct xfs_inode *,
-			dm_right_t, mode_t, int, int);
-
-typedef struct xfs_dmops {
-	xfs_send_data_t		xfs_send_data;
-	xfs_send_mmap_t		xfs_send_mmap;
-	xfs_send_destroy_t	xfs_send_destroy;
-	xfs_send_namesp_t	xfs_send_namesp;
-	xfs_send_mount_t	xfs_send_mount;
-	xfs_send_unmount_t	xfs_send_unmount;
-} xfs_dmops_t;
-
-#define XFS_DMAPI_UNMOUNT_FLAGS(mp) \
-	(((mp)->m_dmevmask & (1 << DM_EVENT_UNMOUNT)) ? 0 : DM_FLAGS_UNWANTED)
-
-#define XFS_SEND_DATA(mp, ev,ip,off,len,fl,lock) \
-	(*(mp)->m_dm_ops->xfs_send_data)(ev,ip,off,len,fl,lock)
-#define XFS_SEND_MMAP(mp, vma,fl) \
-	(*(mp)->m_dm_ops->xfs_send_mmap)(vma,fl)
-#define XFS_SEND_DESTROY(mp, ip,right) \
-	(*(mp)->m_dm_ops->xfs_send_destroy)(ip,right)
-#define XFS_SEND_NAMESP(mp, ev,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
-	(*(mp)->m_dm_ops->xfs_send_namesp)(ev,NULL,b1,r1,b2,r2,n1,n2,mode,rval,fl)
-#define XFS_SEND_MOUNT(mp,right,path,name) \
-	(*(mp)->m_dm_ops->xfs_send_mount)(mp,right,path,name)
-#define XFS_SEND_PREUNMOUNT(mp) \
-do { \
-	if (mp->m_flags & XFS_MOUNT_DMAPI) { \
-		(*(mp)->m_dm_ops->xfs_send_namesp)(DM_EVENT_PREUNMOUNT, mp, \
-			(mp)->m_rootip, DM_RIGHT_NULL, \
-			(mp)->m_rootip, DM_RIGHT_NULL, \
-			NULL, NULL, 0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp)); \
-	} \
-} while (0)
-#define XFS_SEND_UNMOUNT(mp) \
-do { \
-	if (mp->m_flags & XFS_MOUNT_DMAPI) { \
-		(*(mp)->m_dm_ops->xfs_send_unmount)(mp, (mp)->m_rootip, \
-			DM_RIGHT_NULL, 0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp)); \
-	} \
-} while (0)
-
-
 #ifdef HAVE_PERCPU_SB
 
 /*
@@ -440,11 +381,6 @@ extern int	xfs_sb_validate_fsb_count(str
 
 extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
 
-extern int	xfs_dmops_get(struct xfs_mount *);
-extern void	xfs_dmops_put(struct xfs_mount *);
-
-extern struct xfs_dmops xfs_dmcore_xfs;
-
 #endif	/* __KERNEL__ */
 
 extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
Index: b/fs/xfs/xfs_rename.c
===================================================================
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2003, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -24,7 +24,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
@@ -32,6 +31,7 @@
 #include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_dmapi.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
Index: b/fs/xfs/xfs_rtalloc.c
===================================================================
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_rw.c
===================================================================
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2006, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_trans.c
===================================================================
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2003, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_da_btree.h"
Index: b/fs/xfs/xfs_trans_ail.c
===================================================================
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2002, 2005, 2010 SGI
  * Copyright (c) 2008 Dave Chinner
  * All Rights Reserved.
  *
@@ -24,7 +24,6 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
Index: b/fs/xfs/xfs_trans_buf.c
===================================================================
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2002, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_trans_extfree.c
===================================================================
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -23,7 +23,6 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
 #include "xfs_extfree_item.h"
Index: b/fs/xfs/xfs_trans_inode.c
===================================================================
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
Index: b/fs/xfs/xfs_trans_item.c
===================================================================
--- a/fs/xfs/xfs_trans_item.c
+++ b/fs/xfs/xfs_trans_item.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2002, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -28,7 +28,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 
 STATIC int	xfs_trans_unlock_chunk(xfs_log_item_chunk_t *,
Index: b/fs/xfs/xfs_utils.c
===================================================================
--- a/fs/xfs/xfs_utils.c
+++ b/fs/xfs/xfs_utils.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2002, 2005, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -25,7 +25,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_dir2_sf.h"
Index: b/fs/xfs/xfs_vnodeops.c
===================================================================
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -26,7 +26,6 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
-#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
@@ -36,6 +35,7 @@
 #include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_dmapi.h"
 #include "xfs_inode_item.h"
 #include "xfs_itable.h"
 #include "xfs_btree.h"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
