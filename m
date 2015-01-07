Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6DF607F95
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 15:43:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04C0FAC001
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 13:43:13 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BcDQBc1moBqr65qM for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 13:43:11 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Y8yNe-0005HT-0X
	for xfs@oss.sgi.com; Thu, 08 Jan 2015 08:43:06 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Y8yNd-0001uB-W2
	for xfs@oss.sgi.com; Thu, 08 Jan 2015 08:43:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] xfs: move xfs_types.h to libxfs
Date: Thu,  8 Jan 2015 08:43:01 +1100
Message-Id: <1420666983-7275-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1420666983-7275-1-git-send-email-david@fromorbit.com>
References: <1420666983-7275-1-git-send-email-david@fromorbit.com>
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

The types used by the core XFS code are common between kernel and
userspace. xfs_types.h is duplicated in both kernel and userspace,
so move it to libxfs along with all the other shared code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_types.h | 137 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_types.h        | 137 ----------------------------------------------
 2 files changed, 137 insertions(+), 137 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_types.h
 delete mode 100644 fs/xfs/xfs_types.h

diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
new file mode 100644
index 0000000..b79dc66
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -0,0 +1,137 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
+#ifndef __XFS_TYPES_H__
+#define	__XFS_TYPES_H__
+
+typedef __uint32_t	prid_t;		/* project ID */
+
+typedef __uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
+typedef	__uint32_t	xfs_agino_t;	/* inode # within allocation grp */
+typedef	__uint32_t	xfs_extlen_t;	/* extent length in blocks */
+typedef	__uint32_t	xfs_agnumber_t;	/* allocation group number */
+typedef __int32_t	xfs_extnum_t;	/* # of extents in a file */
+typedef __int16_t	xfs_aextnum_t;	/* # extents in an attribute fork */
+typedef	__int64_t	xfs_fsize_t;	/* bytes in a file */
+typedef __uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
+
+typedef	__int32_t	xfs_suminfo_t;	/* type of bitmap summary info */
+typedef	__int32_t	xfs_rtword_t;	/* word type for bitmap manipulations */
+
+typedef	__int64_t	xfs_lsn_t;	/* log sequence number */
+typedef	__int32_t	xfs_tid_t;	/* transaction identifier */
+
+typedef	__uint32_t	xfs_dablk_t;	/* dir/attr block number (in file) */
+typedef	__uint32_t	xfs_dahash_t;	/* dir/attr hash value */
+
+typedef	__uint64_t	xfs_fsblock_t;	/* blockno in filesystem (agno|agbno) */
+typedef __uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
+typedef __uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
+typedef __uint64_t	xfs_fileoff_t;	/* block number in a file */
+typedef __uint64_t	xfs_filblks_t;	/* number of blocks in a file */
+
+typedef	__int64_t	xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
+typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
+
+/*
+ * Null values for the types.
+ */
+#define	NULLFSBLOCK	((xfs_fsblock_t)-1)
+#define	NULLRFSBLOCK	((xfs_rfsblock_t)-1)
+#define	NULLRTBLOCK	((xfs_rtblock_t)-1)
+#define	NULLFILEOFF	((xfs_fileoff_t)-1)
+
+#define	NULLAGBLOCK	((xfs_agblock_t)-1)
+#define	NULLAGNUMBER	((xfs_agnumber_t)-1)
+#define	NULLEXTNUM	((xfs_extnum_t)-1)
+
+#define NULLCOMMITLSN	((xfs_lsn_t)-1)
+
+#define	NULLFSINO	((xfs_ino_t)-1)
+#define	NULLAGINO	((xfs_agino_t)-1)
+
+/*
+ * Max values for extlen, extnum, aextnum.
+ */
+#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
+#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
+#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+
+/*
+ * Minimum and maximum blocksize and sectorsize.
+ * The blocksize upper limit is pretty much arbitrary.
+ * The sectorsize upper limit is due to sizeof(sb_sectsize).
+ */
+#define XFS_MIN_BLOCKSIZE_LOG	9	/* i.e. 512 bytes */
+#define XFS_MAX_BLOCKSIZE_LOG	16	/* i.e. 65536 bytes */
+#define XFS_MIN_BLOCKSIZE	(1 << XFS_MIN_BLOCKSIZE_LOG)
+#define XFS_MAX_BLOCKSIZE	(1 << XFS_MAX_BLOCKSIZE_LOG)
+#define XFS_MIN_SECTORSIZE_LOG	9	/* i.e. 512 bytes */
+#define XFS_MAX_SECTORSIZE_LOG	15	/* i.e. 32768 bytes */
+#define XFS_MIN_SECTORSIZE	(1 << XFS_MIN_SECTORSIZE_LOG)
+#define XFS_MAX_SECTORSIZE	(1 << XFS_MAX_SECTORSIZE_LOG)
+
+/*
+ * Inode fork identifiers.
+ */
+#define	XFS_DATA_FORK	0
+#define	XFS_ATTR_FORK	1
+
+/*
+ * Min numbers of data/attr fork btree root pointers.
+ */
+#define MINDBTPTRS	3
+#define MINABTPTRS	2
+
+/*
+ * MAXNAMELEN is the length (including the terminating null) of
+ * the longest permissible file (component) name.
+ */
+#define MAXNAMELEN	256
+
+typedef enum {
+	XFS_LOOKUP_EQi, XFS_LOOKUP_LEi, XFS_LOOKUP_GEi
+} xfs_lookup_t;
+
+typedef enum {
+	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_BMAPi, XFS_BTNUM_INOi,
+	XFS_BTNUM_FINOi, XFS_BTNUM_MAX
+} xfs_btnum_t;
+
+struct xfs_name {
+	const unsigned char	*name;
+	int			len;
+	int			type;
+};
+
+/*
+ * uid_t and gid_t are hard-coded to 32 bits in the inode.
+ * Hence, an 'id' in a dquot is 32 bits..
+ */
+typedef __uint32_t	xfs_dqid_t;
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
+
+#endif	/* __XFS_TYPES_H__ */
diff --git a/fs/xfs/xfs_types.h b/fs/xfs/xfs_types.h
deleted file mode 100644
index b79dc66..0000000
--- a/fs/xfs/xfs_types.h
+++ /dev/null
@@ -1,137 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_TYPES_H__
-#define	__XFS_TYPES_H__
-
-typedef __uint32_t	prid_t;		/* project ID */
-
-typedef __uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
-typedef	__uint32_t	xfs_agino_t;	/* inode # within allocation grp */
-typedef	__uint32_t	xfs_extlen_t;	/* extent length in blocks */
-typedef	__uint32_t	xfs_agnumber_t;	/* allocation group number */
-typedef __int32_t	xfs_extnum_t;	/* # of extents in a file */
-typedef __int16_t	xfs_aextnum_t;	/* # extents in an attribute fork */
-typedef	__int64_t	xfs_fsize_t;	/* bytes in a file */
-typedef __uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
-
-typedef	__int32_t	xfs_suminfo_t;	/* type of bitmap summary info */
-typedef	__int32_t	xfs_rtword_t;	/* word type for bitmap manipulations */
-
-typedef	__int64_t	xfs_lsn_t;	/* log sequence number */
-typedef	__int32_t	xfs_tid_t;	/* transaction identifier */
-
-typedef	__uint32_t	xfs_dablk_t;	/* dir/attr block number (in file) */
-typedef	__uint32_t	xfs_dahash_t;	/* dir/attr hash value */
-
-typedef	__uint64_t	xfs_fsblock_t;	/* blockno in filesystem (agno|agbno) */
-typedef __uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
-typedef __uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
-typedef __uint64_t	xfs_fileoff_t;	/* block number in a file */
-typedef __uint64_t	xfs_filblks_t;	/* number of blocks in a file */
-
-typedef	__int64_t	xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
-typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
-
-/*
- * Null values for the types.
- */
-#define	NULLFSBLOCK	((xfs_fsblock_t)-1)
-#define	NULLRFSBLOCK	((xfs_rfsblock_t)-1)
-#define	NULLRTBLOCK	((xfs_rtblock_t)-1)
-#define	NULLFILEOFF	((xfs_fileoff_t)-1)
-
-#define	NULLAGBLOCK	((xfs_agblock_t)-1)
-#define	NULLAGNUMBER	((xfs_agnumber_t)-1)
-#define	NULLEXTNUM	((xfs_extnum_t)-1)
-
-#define NULLCOMMITLSN	((xfs_lsn_t)-1)
-
-#define	NULLFSINO	((xfs_ino_t)-1)
-#define	NULLAGINO	((xfs_agino_t)-1)
-
-/*
- * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
-
-/*
- * Minimum and maximum blocksize and sectorsize.
- * The blocksize upper limit is pretty much arbitrary.
- * The sectorsize upper limit is due to sizeof(sb_sectsize).
- */
-#define XFS_MIN_BLOCKSIZE_LOG	9	/* i.e. 512 bytes */
-#define XFS_MAX_BLOCKSIZE_LOG	16	/* i.e. 65536 bytes */
-#define XFS_MIN_BLOCKSIZE	(1 << XFS_MIN_BLOCKSIZE_LOG)
-#define XFS_MAX_BLOCKSIZE	(1 << XFS_MAX_BLOCKSIZE_LOG)
-#define XFS_MIN_SECTORSIZE_LOG	9	/* i.e. 512 bytes */
-#define XFS_MAX_SECTORSIZE_LOG	15	/* i.e. 32768 bytes */
-#define XFS_MIN_SECTORSIZE	(1 << XFS_MIN_SECTORSIZE_LOG)
-#define XFS_MAX_SECTORSIZE	(1 << XFS_MAX_SECTORSIZE_LOG)
-
-/*
- * Inode fork identifiers.
- */
-#define	XFS_DATA_FORK	0
-#define	XFS_ATTR_FORK	1
-
-/*
- * Min numbers of data/attr fork btree root pointers.
- */
-#define MINDBTPTRS	3
-#define MINABTPTRS	2
-
-/*
- * MAXNAMELEN is the length (including the terminating null) of
- * the longest permissible file (component) name.
- */
-#define MAXNAMELEN	256
-
-typedef enum {
-	XFS_LOOKUP_EQi, XFS_LOOKUP_LEi, XFS_LOOKUP_GEi
-} xfs_lookup_t;
-
-typedef enum {
-	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_BMAPi, XFS_BTNUM_INOi,
-	XFS_BTNUM_FINOi, XFS_BTNUM_MAX
-} xfs_btnum_t;
-
-struct xfs_name {
-	const unsigned char	*name;
-	int			len;
-	int			type;
-};
-
-/*
- * uid_t and gid_t are hard-coded to 32 bits in the inode.
- * Hence, an 'id' in a dquot is 32 bits..
- */
-typedef __uint32_t	xfs_dqid_t;
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
-
-#endif	/* __XFS_TYPES_H__ */
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
