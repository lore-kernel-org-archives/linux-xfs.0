Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD48A29E12
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:52:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 79558AC002
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:52:57 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	evQBzEEo3Mltyg8k for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:52:55 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpAO1-000311-UO
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:49 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpANr-00007f-N2
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 52/60] xfs: introduce xfs_rtalloc_defs.h
Date: Wed, 19 Jun 2013 14:51:00 +1000
Message-Id: <1371617468-32559-53-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

There are quite a few realtime device definitions shared with
userspace. Move them from xfs_rtalloc.h to xfs_rt_alloc_defs.h
so we don't need to share xfs_rtalloc.h with userspace anymore.

This removes the final __KERNEL__ region from the XFS kernel
codebase. Yay!

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_rtalloc.h      |   55 +++--------------------------------
 fs/xfs/xfs_rtalloc_defs.h |   70 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+), 51 deletions(-)
 create mode 100644 fs/xfs/xfs_rtalloc_defs.h

diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index f7f3a35..f9d569a 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -18,57 +18,12 @@
 #ifndef __XFS_RTALLOC_H__
 #define	__XFS_RTALLOC_H__
 
-struct xfs_mount;
-struct xfs_trans;
-
-/* Min and max rt extent sizes, specified in bytes */
-#define	XFS_MAX_RTEXTSIZE	(1024 * 1024 * 1024)	/* 1GB */
-#define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
-#define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
-
-/*
- * Constants for bit manipulations.
- */
-#define	XFS_NBBYLOG	3		/* log2(NBBY) */
-#define	XFS_WORDLOG	2		/* log2(sizeof(xfs_rtword_t)) */
-#define	XFS_NBWORDLOG	(XFS_NBBYLOG + XFS_WORDLOG)
-#define	XFS_NBWORD	(1 << XFS_NBWORDLOG)
-#define	XFS_WORDMASK	((1 << XFS_WORDLOG) - 1)
-
-#define	XFS_BLOCKSIZE(mp)	((mp)->m_sb.sb_blocksize)
-#define	XFS_BLOCKMASK(mp)	((mp)->m_blockmask)
-#define	XFS_BLOCKWSIZE(mp)	((mp)->m_blockwsize)
-#define	XFS_BLOCKWMASK(mp)	((mp)->m_blockwmask)
-
-/*
- * Summary and bit manipulation macros.
- */
-#define	XFS_SUMOFFS(mp,ls,bb)	((int)((ls) * (mp)->m_sb.sb_rbmblocks + (bb)))
-#define	XFS_SUMOFFSTOBLOCK(mp,s)	\
-	(((s) * (uint)sizeof(xfs_suminfo_t)) >> (mp)->m_sb.sb_blocklog)
-#define	XFS_SUMPTR(mp,bp,so)	\
-	((xfs_suminfo_t *)((bp)->b_addr + \
-		(((so) * (uint)sizeof(xfs_suminfo_t)) & XFS_BLOCKMASK(mp))))
-
-#define	XFS_BITTOBLOCK(mp,bi)	((bi) >> (mp)->m_blkbit_log)
-#define	XFS_BLOCKTOBIT(mp,bb)	((bb) << (mp)->m_blkbit_log)
-#define	XFS_BITTOWORD(mp,bi)	\
-	((int)(((bi) >> XFS_NBWORDLOG) & XFS_BLOCKWMASK(mp)))
-
-#define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
-#define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
+#include "xfs_rtalloc_defs.h"
 
-#define	XFS_RTLOBIT(w)	xfs_lowbit32(w)
-#define	XFS_RTHIBIT(w)	xfs_highbit32(w)
-
-#if XFS_BIG_BLKNOS
-#define	XFS_RTBLOCKLOG(b)	xfs_highbit64(b)
-#else
-#define	XFS_RTBLOCKLOG(b)	xfs_highbit32(b)
-#endif
+/* kernel only definitions and functions */
 
-
-#ifdef __KERNEL__
+struct xfs_mount;
+struct xfs_trans;
 
 #ifdef CONFIG_XFS_RT
 /*
@@ -161,6 +116,4 @@ xfs_rtmount_init(
 # define xfs_rtunmount_inodes(m)
 #endif	/* CONFIG_XFS_RT */
 
-#endif	/* __KERNEL__ */
-
 #endif	/* __XFS_RTALLOC_H__ */
diff --git a/fs/xfs/xfs_rtalloc_defs.h b/fs/xfs/xfs_rtalloc_defs.h
new file mode 100644
index 0000000..42afb1b
--- /dev/null
+++ b/fs/xfs/xfs_rtalloc_defs.h
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_RTALLOC_DEFS_H__
+#define	__XFS_RTALLOC_DEFS_H__
+
+/* definitions shared with userspace */
+
+/* Min and max rt extent sizes, specified in bytes */
+#define	XFS_MAX_RTEXTSIZE	(1024 * 1024 * 1024)	/* 1GB */
+#define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
+#define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
+
+/*
+ * Constants for bit manipulations.
+ */
+#define	XFS_NBBYLOG	3		/* log2(NBBY) */
+#define	XFS_WORDLOG	2		/* log2(sizeof(xfs_rtword_t)) */
+#define	XFS_NBWORDLOG	(XFS_NBBYLOG + XFS_WORDLOG)
+#define	XFS_NBWORD	(1 << XFS_NBWORDLOG)
+#define	XFS_WORDMASK	((1 << XFS_WORDLOG) - 1)
+
+#define	XFS_BLOCKSIZE(mp)	((mp)->m_sb.sb_blocksize)
+#define	XFS_BLOCKMASK(mp)	((mp)->m_blockmask)
+#define	XFS_BLOCKWSIZE(mp)	((mp)->m_blockwsize)
+#define	XFS_BLOCKWMASK(mp)	((mp)->m_blockwmask)
+
+/*
+ * Summary and bit manipulation macros.
+ */
+#define	XFS_SUMOFFS(mp,ls,bb)	((int)((ls) * (mp)->m_sb.sb_rbmblocks + (bb)))
+#define	XFS_SUMOFFSTOBLOCK(mp,s)	\
+	(((s) * (uint)sizeof(xfs_suminfo_t)) >> (mp)->m_sb.sb_blocklog)
+#define	XFS_SUMPTR(mp,bp,so)	\
+	((xfs_suminfo_t *)((bp)->b_addr + \
+		(((so) * (uint)sizeof(xfs_suminfo_t)) & XFS_BLOCKMASK(mp))))
+
+#define	XFS_BITTOBLOCK(mp,bi)	((bi) >> (mp)->m_blkbit_log)
+#define	XFS_BLOCKTOBIT(mp,bb)	((bb) << (mp)->m_blkbit_log)
+#define	XFS_BITTOWORD(mp,bi)	\
+	((int)(((bi) >> XFS_NBWORDLOG) & XFS_BLOCKWMASK(mp)))
+
+#define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
+#define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
+
+#define	XFS_RTLOBIT(w)	xfs_lowbit32(w)
+#define	XFS_RTHIBIT(w)	xfs_highbit32(w)
+
+#if XFS_BIG_BLKNOS
+#define	XFS_RTBLOCKLOG(b)	xfs_highbit64(b)
+#else
+#define	XFS_RTBLOCKLOG(b)	xfs_highbit32(b)
+#endif
+
+
+#endif	/* __XFS_RTALLOC_DEFS_H__ */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
