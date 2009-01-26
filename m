Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7WiQg203713 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:32:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D6E1185E90B
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1hODGIW35YVBPs8H for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLww-000330-2C
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:02 +0000
Message-Id: <20090126073201.963253000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/17] xfs: remove uchar_t/ushort_t/uint_t/ulong_t types
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-ufoo_t-types
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

Just another set of types obsfucating the code, remove them.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-01-24 17:58:57.163785983 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-01-25 06:19:23.173491868 +0100
@@ -180,7 +180,7 @@ xfs_parseargs(
 	int			dswidth = 0;
 	int			iosize = 0;
 	int			dmapi_implies_ikeep = 1;
-	uchar_t			iosizelog = 0;
+	__uint8_t		iosizelog = 0;
 
 	/*
 	 * Copy binary VFS mount flags we are interested in.
Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2009-01-21 21:03:27.838294778 +0100
+++ xfs/fs/xfs/xfs_ag.h	2009-01-24 18:40:10.116428891 +0100
@@ -223,8 +223,8 @@ typedef struct xfs_perag
 		be32_to_cpu((a)->agf_levels[XFS_BTNUM_CNTi]), mp))
 #define	XFS_MIN_FREELIST_PAG(pag,mp)	\
 	(XFS_MIN_FREELIST_RAW(		\
-		(uint_t)(pag)->pagf_levels[XFS_BTNUM_BNOi], \
-		(uint_t)(pag)->pagf_levels[XFS_BTNUM_CNTi], mp))
+		(unsigned int)(pag)->pagf_levels[XFS_BTNUM_BNOi], \
+		(unsigned int)(pag)->pagf_levels[XFS_BTNUM_CNTi], mp))
 
 #define XFS_AGB_TO_FSB(mp,agno,agbno)	\
 	(((xfs_fsblock_t)(agno) << (mp)->m_sb.sb_agblklog) | (agbno))
Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2009-01-24 18:13:02.655903952 +0100
+++ xfs/fs/xfs/xfs_da_btree.c	2009-01-24 18:40:10.117429298 +0100
@@ -1503,7 +1503,7 @@ xfs_da_path_shift(xfs_da_state_t *state,
  * This is implemented with some source-level loop unrolling.
  */
 xfs_dahash_t
-xfs_da_hashname(const uchar_t *name, int namelen)
+xfs_da_hashname(const __uint8_t *name, int namelen)
 {
 	xfs_dahash_t hash;
 
Index: xfs/fs/xfs/xfs_da_btree.h
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.h	2009-01-21 21:03:27.847295087 +0100
+++ xfs/fs/xfs/xfs_da_btree.h	2009-01-24 18:40:10.118428797 +0100
@@ -91,9 +91,9 @@ enum xfs_dacmp {
  * Structure to ease passing around component names.
  */
 typedef struct xfs_da_args {
-	const uchar_t	*name;		/* string (maybe not NULL terminated) */
+	const __uint8_t	*name;		/* string (maybe not NULL terminated) */
 	int		namelen;	/* length of string (maybe no NULL) */
-	uchar_t		*value;		/* set of bytes (maybe contain NULLs) */
+	__uint8_t	*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
 	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
 	xfs_dahash_t	hashval;	/* hash value of name */
@@ -251,7 +251,7 @@ xfs_daddr_t	xfs_da_reada_buf(struct xfs_
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 					  xfs_dabuf_t *dead_buf);
 
-uint xfs_da_hashname(const uchar_t *name_string, int name_length);
+uint xfs_da_hashname(const __uint8_t *name_string, int name_length);
 enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,
 				const char *name, int len);
 
Index: xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log_priv.h	2009-01-21 21:03:27.863295380 +0100
+++ xfs/fs/xfs/xfs_log_priv.h	2009-01-24 18:40:10.118428797 +0100
@@ -359,7 +359,7 @@ typedef struct xlog_in_core {
 	int			ic_size;
 	int			ic_offset;
 	int			ic_bwritecnt;
-	ushort_t		ic_state;
+	unsigned short		ic_state;
 	char			*ic_datap;	/* pointer to iclog data */
 #ifdef XFS_LOG_TRACE
 	struct ktrace		*ic_trace;
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-01-21 21:03:27.864295019 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2009-01-25 06:19:48.044397387 +0100
@@ -192,11 +192,11 @@ xlog_header_check_dump(
 
 	cmn_err(CE_DEBUG, "%s:  SB : uuid = ", __func__);
 	for (b = 0; b < 16; b++)
-		cmn_err(CE_DEBUG, "%02x", ((uchar_t *)&mp->m_sb.sb_uuid)[b]);
+		cmn_err(CE_DEBUG, "%02x", ((__uint8_t *)&mp->m_sb.sb_uuid)[b]);
 	cmn_err(CE_DEBUG, ", fmt = %d\n", XLOG_FMT);
 	cmn_err(CE_DEBUG, "    log : uuid = ");
 	for (b = 0; b < 16; b++)
-		cmn_err(CE_DEBUG, "%02x",((uchar_t *)&head->h_fs_uuid)[b]);
+		cmn_err(CE_DEBUG, "%02x", ((__uint8_t *)&head->h_fs_uuid)[b]);
 	cmn_err(CE_DEBUG, ", fmt = %d\n", be32_to_cpu(head->h_fmt));
 }
 #else
Index: xfs/fs/xfs/xfs_types.h
===================================================================
--- xfs.orig/fs/xfs/xfs_types.h	2009-01-22 00:54:49.351809660 +0100
+++ xfs/fs/xfs/xfs_types.h	2009-01-24 18:40:10.120456918 +0100
@@ -21,14 +21,6 @@
 #ifdef __KERNEL__
 
 /*
- * POSIX Extensions
- */
-typedef unsigned char		uchar_t;
-typedef unsigned short		ushort_t;
-typedef unsigned int		uint_t;
-typedef unsigned long		ulong_t;
-
-/*
  * Additional type declarations for XFS
  */
 typedef signed char		__int8_t;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
