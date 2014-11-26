Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88EB17F58
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 13:14:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 520DC304071
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 11:14:44 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id D9SwFokaY6sJgFVo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2014 11:14:42 -0800 (PST)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xti2y-0002pG-MD
	for xfs@oss.sgi.com; Wed, 26 Nov 2014 19:14:41 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] xfs: merge xfs_inum.h into xfs_format.h
Date: Wed, 26 Nov 2014 20:14:27 +0100
Message-Id: <1417029267-20149-5-git-send-email-hch@lst.de>
In-Reply-To: <1417029267-20149-1-git-send-email-hch@lst.de>
References: <1417029267-20149-1-git-send-email-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c       |  1 -
 fs/xfs/libxfs/xfs_dir2.c       |  1 -
 fs/xfs/libxfs/xfs_format.h     | 35 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c     |  1 -
 fs/xfs/libxfs/xfs_inode_fork.c |  1 -
 fs/xfs/libxfs/xfs_inum.h       | 60 ------------------------------------------
 fs/xfs/xfs_filestream.c        |  1 -
 fs/xfs/xfs_icache.c            |  1 -
 fs/xfs/xfs_inode.c             |  1 -
 fs/xfs/xfs_itable.c            |  1 -
 fs/xfs/xfs_log_recover.c       |  1 -
 fs/xfs/xfs_mount.c             |  1 -
 fs/xfs/xfs_super.c             |  1 -
 13 files changed, 35 insertions(+), 71 deletions(-)
 delete mode 100644 fs/xfs/libxfs/xfs_inum.h

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 68d9133..c2a36c3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_inum.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 5d89291..d399f17 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -20,7 +20,6 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_inum.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 70ca740..fbd6da2 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1068,6 +1068,41 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 	 XFS_DIFLAG_PROJINHERIT | XFS_DIFLAG_NOSYMLINKS | XFS_DIFLAG_EXTSIZE | \
 	 XFS_DIFLAG_EXTSZINHERIT | XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM)
 
+/*
+ * Inode number format:
+ * low inopblog bits - offset in block
+ * next agblklog bits - block number in ag
+ * next agno_log bits - ag number
+ * high agno_log-agblklog-inopblog bits - 0
+ */
+#define	XFS_INO_MASK(k)			(__uint32_t)((1ULL << (k)) - 1)
+#define	XFS_INO_OFFSET_BITS(mp)		(mp)->m_sb.sb_inopblog
+#define	XFS_INO_AGBNO_BITS(mp)		(mp)->m_sb.sb_agblklog
+#define	XFS_INO_AGINO_BITS(mp)		(mp)->m_agino_log
+#define	XFS_INO_AGNO_BITS(mp)		(mp)->m_agno_log
+#define	XFS_INO_BITS(mp)		\
+	XFS_INO_AGNO_BITS(mp) + XFS_INO_AGINO_BITS(mp)
+#define	XFS_INO_TO_AGNO(mp,i)		\
+	((xfs_agnumber_t)((i) >> XFS_INO_AGINO_BITS(mp)))
+#define	XFS_INO_TO_AGINO(mp,i)		\
+	((xfs_agino_t)(i) & XFS_INO_MASK(XFS_INO_AGINO_BITS(mp)))
+#define	XFS_INO_TO_AGBNO(mp,i)		\
+	(((xfs_agblock_t)(i) >> XFS_INO_OFFSET_BITS(mp)) & \
+		XFS_INO_MASK(XFS_INO_AGBNO_BITS(mp)))
+#define	XFS_INO_TO_OFFSET(mp,i)		\
+	((int)(i) & XFS_INO_MASK(XFS_INO_OFFSET_BITS(mp)))
+#define	XFS_INO_TO_FSB(mp,i)		\
+	XFS_AGB_TO_FSB(mp, XFS_INO_TO_AGNO(mp,i), XFS_INO_TO_AGBNO(mp,i))
+#define	XFS_AGINO_TO_INO(mp,a,i)	\
+	(((xfs_ino_t)(a) << XFS_INO_AGINO_BITS(mp)) | (i))
+#define	XFS_AGINO_TO_AGBNO(mp,i)	((i) >> XFS_INO_OFFSET_BITS(mp))
+#define	XFS_AGINO_TO_OFFSET(mp,i)	\
+	((i) & XFS_INO_MASK(XFS_INO_OFFSET_BITS(mp)))
+#define	XFS_OFFBNO_TO_AGINO(mp,b,o)	\
+	((xfs_agino_t)(((b) << XFS_INO_OFFSET_BITS(mp)) | (o)))
+
+#define	XFS_MAXINUMBER		((xfs_ino_t)((1ULL << 56) - 1ULL))
+#define	XFS_MAXINUMBER_32	((xfs_ino_t)((1ULL << 32) - 1ULL))
 
 /*
  * RealTime Device format definitions
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 1dae7da..92d2617 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_inum.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 8912d28..0defbd0 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -22,7 +22,6 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_inum.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/libxfs/xfs_inum.h b/fs/xfs/libxfs/xfs_inum.h
deleted file mode 100644
index 4ff2278..0000000
--- a/fs/xfs/libxfs/xfs_inum.h
+++ /dev/null
@@ -1,60 +0,0 @@
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
-#ifndef __XFS_INUM_H__
-#define	__XFS_INUM_H__
-
-/*
- * Inode number format:
- * low inopblog bits - offset in block
- * next agblklog bits - block number in ag
- * next agno_log bits - ag number
- * high agno_log-agblklog-inopblog bits - 0
- */
-
-struct xfs_mount;
-
-#define	XFS_INO_MASK(k)			(__uint32_t)((1ULL << (k)) - 1)
-#define	XFS_INO_OFFSET_BITS(mp)		(mp)->m_sb.sb_inopblog
-#define	XFS_INO_AGBNO_BITS(mp)		(mp)->m_sb.sb_agblklog
-#define	XFS_INO_AGINO_BITS(mp)		(mp)->m_agino_log
-#define	XFS_INO_AGNO_BITS(mp)		(mp)->m_agno_log
-#define	XFS_INO_BITS(mp)		\
-	XFS_INO_AGNO_BITS(mp) + XFS_INO_AGINO_BITS(mp)
-#define	XFS_INO_TO_AGNO(mp,i)		\
-	((xfs_agnumber_t)((i) >> XFS_INO_AGINO_BITS(mp)))
-#define	XFS_INO_TO_AGINO(mp,i)		\
-	((xfs_agino_t)(i) & XFS_INO_MASK(XFS_INO_AGINO_BITS(mp)))
-#define	XFS_INO_TO_AGBNO(mp,i)		\
-	(((xfs_agblock_t)(i) >> XFS_INO_OFFSET_BITS(mp)) & \
-		XFS_INO_MASK(XFS_INO_AGBNO_BITS(mp)))
-#define	XFS_INO_TO_OFFSET(mp,i)		\
-	((int)(i) & XFS_INO_MASK(XFS_INO_OFFSET_BITS(mp)))
-#define	XFS_INO_TO_FSB(mp,i)		\
-	XFS_AGB_TO_FSB(mp, XFS_INO_TO_AGNO(mp,i), XFS_INO_TO_AGBNO(mp,i))
-#define	XFS_AGINO_TO_INO(mp,a,i)	\
-	(((xfs_ino_t)(a) << XFS_INO_AGINO_BITS(mp)) | (i))
-#define	XFS_AGINO_TO_AGBNO(mp,i)	((i) >> XFS_INO_OFFSET_BITS(mp))
-#define	XFS_AGINO_TO_OFFSET(mp,i)	\
-	((i) & XFS_INO_MASK(XFS_INO_OFFSET_BITS(mp)))
-#define	XFS_OFFBNO_TO_AGINO(mp,b,o)	\
-	((xfs_agino_t)(((b) << XFS_INO_OFFSET_BITS(mp)) | (o)))
-
-#define	XFS_MAXINUMBER		((xfs_ino_t)((1ULL << 56) - 1ULL))
-#define	XFS_MAXINUMBER_32	((xfs_ino_t)((1ULL << 32) - 1ULL))
-
-#endif	/* __XFS_INUM_H__ */
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index c5b06a9..a2e86e8 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -22,7 +22,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
-#include "xfs_inum.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e364723..92ca910 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -20,7 +20,6 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_inum.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 229dfde..7054bae 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -23,7 +23,6 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_inum.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 77aba24..5930d66 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -21,7 +21,6 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_inum.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 697073a..75705dd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_inum.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e627336..92faae5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -22,7 +22,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_inum.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index af4f63e..f14affc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -21,7 +21,6 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_inum.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
