Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E00E57F7B
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CF3978F8049
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:51 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	PtNOZHtf8GzxRX8r for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phW-0004Xd-Rf
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phW-000615-QY
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 08/50] xfs: introduce
	xfs_rtalloc_defs.h
Date: Mon, 12 Aug 2013 20:49:29 +1000
Message-Id: <1376304611-22994-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_format.h  | 41 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.c |  2 +-
 fs/xfs/xfs_rtalloc.h | 53 ++--------------------------------------------------
 fs/xfs/xfs_types.h   | 10 ++++++++++
 4 files changed, 54 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_format.h b/fs/xfs/xfs_format.h
index 2b4f166..6205374 100644
--- a/fs/xfs/xfs_format.h
+++ b/fs/xfs/xfs_format.h
@@ -28,6 +28,47 @@
  */
 
 /*
+ * RealTime Device format definitions
+ */
+
+/* Min and max rt extent sizes, specified in bytes */
+#define	XFS_MAX_RTEXTSIZE	(1024 * 1024 * 1024)	/* 1GB */
+#define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
+#define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
+
+#define	XFS_BLOCKSIZE(mp)	((mp)->m_sb.sb_blocksize)
+#define	XFS_BLOCKMASK(mp)	((mp)->m_blockmask)
+#define	XFS_BLOCKWSIZE(mp)	((mp)->m_blockwsize)
+#define	XFS_BLOCKWMASK(mp)	((mp)->m_blockwmask)
+
+/*
+ * RT Summary and bit manipulation macros.
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
+/*
  * Dquot and dquot block format definitions
  */
 #define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 98dc670..5d900ec 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -17,7 +17,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
-#include "xfs_types.h"
+#include "xfs_format.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index f7f3a35..b2a1a24 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -18,58 +18,11 @@
 #ifndef __XFS_RTALLOC_H__
 #define	__XFS_RTALLOC_H__
 
+/* kernel only definitions and functions */
+
 struct xfs_mount;
 struct xfs_trans;
 
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
 #ifdef CONFIG_XFS_RT
 /*
  * Function prototypes for exported functions.
@@ -161,6 +114,4 @@ xfs_rtmount_init(
 # define xfs_rtunmount_inodes(m)
 #endif	/* CONFIG_XFS_RT */
 
-#endif	/* __KERNEL__ */
-
 #endif	/* __XFS_RTALLOC_H__ */
diff --git a/fs/xfs/xfs_types.h b/fs/xfs/xfs_types.h
index 69074ac..781772c 100644
--- a/fs/xfs/xfs_types.h
+++ b/fs/xfs/xfs_types.h
@@ -183,4 +183,14 @@ struct xfs_name {
  */
 typedef __uint32_t	xfs_dqid_t;
 
+/*
+ * Constants for bit manipulations.
+ */
+#define	XFS_NBBYLOG	3		/* log2(NBBY) */
+#define	XFS_WORDLOG	2		/* log2(sizeof(xfs_rtword_t)) */
+#define	XFS_NBWORDLOG	(XFS_NBBYLOG + XFS_WORDLOG)
+#define	XFS_NBWORD	(1 << XFS_NBWORDLOG)
+#define	XFS_WORDMASK	((1 << XFS_WORDLOG) - 1)
+
+
 #endif	/* __XFS_TYPES_H__ */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
