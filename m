Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A0187FE7
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:37:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 17C7B304039
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:37:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	o6TOwGxXKsAFVGkz for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:37:16 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4y-0003DE-Us
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:12 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4o-0000Gu-Rj
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 44/50] xfs: introduce xfs_rtalloc_defs.h
Date: Wed, 19 Jun 2013 15:36:07 +1000
Message-Id: <1371620173-712-45-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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
 include/Makefile           |    3 +-
 include/libxfs.h           |    2 +-
 include/xfs_rtalloc.h      |  166 --------------------------------------------
 include/xfs_rtalloc_defs.h |   70 +++++++++++++++++++
 4 files changed, 73 insertions(+), 168 deletions(-)
 delete mode 100644 include/xfs_rtalloc.h
 create mode 100644 include/xfs_rtalloc_defs.h

diff --git a/include/Makefile b/include/Makefile
index 006506b..98ffffb 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -40,7 +40,8 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_metadump.h \
 	xfs_quota_defs.h \
 	xfs_dquot_format.h \
-	xfs_rtalloc.h xfs_sb.h \
+	xfs_rtalloc_defs.h \
+	xfs_sb.h \
 	xfs_symlink_remote.h \
 	xfs_trace.h \
 	xfs_trans_format.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index b1ba154..e4805c1 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -667,7 +667,7 @@ extern int		libxfs_nproc(void);
 extern unsigned long	libxfs_physmem(void);	/* in kilobytes */
 
 #include <xfs/xfs_ialloc.h>
-#include <xfs/xfs_rtalloc.h>
+#include <xfs/xfs_rtalloc_defs.h>
 
 #include <xfs/xfs_attr_leaf.h>
 #include <xfs/xfs_attr_remote.h>
diff --git a/include/xfs_rtalloc.h b/include/xfs_rtalloc.h
deleted file mode 100644
index f7f3a35..0000000
--- a/include/xfs_rtalloc.h
+++ /dev/null
@@ -1,166 +0,0 @@
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
-#ifndef __XFS_RTALLOC_H__
-#define	__XFS_RTALLOC_H__
-
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
-
-#define	XFS_RTLOBIT(w)	xfs_lowbit32(w)
-#define	XFS_RTHIBIT(w)	xfs_highbit32(w)
-
-#if XFS_BIG_BLKNOS
-#define	XFS_RTBLOCKLOG(b)	xfs_highbit64(b)
-#else
-#define	XFS_RTBLOCKLOG(b)	xfs_highbit32(b)
-#endif
-
-
-#ifdef __KERNEL__
-
-#ifdef CONFIG_XFS_RT
-/*
- * Function prototypes for exported functions.
- */
-
-/*
- * Allocate an extent in the realtime subvolume, with the usual allocation
- * parameters.  The length units are all in realtime extents, as is the
- * result block number.
- */
-int					/* error */
-xfs_rtallocate_extent(
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_rtblock_t		bno,	/* starting block number to allocate */
-	xfs_extlen_t		minlen,	/* minimum length to allocate */
-	xfs_extlen_t		maxlen,	/* maximum length to allocate */
-	xfs_extlen_t		*len,	/* out: actual length allocated */
-	xfs_alloctype_t		type,	/* allocation type XFS_ALLOCTYPE... */
-	int			wasdel,	/* was a delayed allocation extent */
-	xfs_extlen_t		prod,	/* extent product factor */
-	xfs_rtblock_t		*rtblock); /* out: start block allocated */
-
-/*
- * Free an extent in the realtime subvolume.  Length is expressed in
- * realtime extents, as is the block number.
- */
-int					/* error */
-xfs_rtfree_extent(
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_rtblock_t		bno,	/* starting block number to free */
-	xfs_extlen_t		len);	/* length of extent freed */
-
-/*
- * Initialize realtime fields in the mount structure.
- */
-int					/* error */
-xfs_rtmount_init(
-	struct xfs_mount	*mp);	/* file system mount structure */
-void
-xfs_rtunmount_inodes(
-	struct xfs_mount	*mp);
-
-/*
- * Get the bitmap and summary inodes into the mount structure
- * at mount time.
- */
-int					/* error */
-xfs_rtmount_inodes(
-	struct xfs_mount	*mp);	/* file system mount structure */
-
-/*
- * Pick an extent for allocation at the start of a new realtime file.
- * Use the sequence number stored in the atime field of the bitmap inode.
- * Translate this to a fraction of the rtextents, and return the product
- * of rtextents and the fraction.
- * The fraction sequence is 0, 1/2, 1/4, 3/4, 1/8, ..., 7/8, 1/16, ...
- */
-int					/* error */
-xfs_rtpick_extent(
-	struct xfs_mount	*mp,	/* file system mount point */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_extlen_t		len,	/* allocation length (rtextents) */
-	xfs_rtblock_t		*pick);	/* result rt extent */
-
-/*
- * Grow the realtime area of the filesystem.
- */
-int
-xfs_growfs_rt(
-	struct xfs_mount	*mp,	/* file system mount structure */
-	xfs_growfs_rt_t		*in);	/* user supplied growfs struct */
-
-#else
-# define xfs_rtallocate_extent(t,b,min,max,l,a,f,p,rb)  (ENOSYS)
-# define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
-# define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
-# define xfs_growfs_rt(mp,in)                           (ENOSYS)
-static inline int		/* error */
-xfs_rtmount_init(
-	xfs_mount_t	*mp)	/* file system mount structure */
-{
-	if (mp->m_sb.sb_rblocks == 0)
-		return 0;
-
-	xfs_warn(mp, "Not built with CONFIG_XFS_RT");
-	return ENOSYS;
-}
-# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
-# define xfs_rtunmount_inodes(m)
-#endif	/* CONFIG_XFS_RT */
-
-#endif	/* __KERNEL__ */
-
-#endif	/* __XFS_RTALLOC_H__ */
diff --git a/include/xfs_rtalloc_defs.h b/include/xfs_rtalloc_defs.h
new file mode 100644
index 0000000..42afb1b
--- /dev/null
+++ b/include/xfs_rtalloc_defs.h
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
