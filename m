Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Sep 2007 03:22:43 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8MAMaQ3013977
	for <xfs@oss.sgi.com>; Sat, 22 Sep 2007 03:22:39 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8MAMcA5015755
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 22 Sep 2007 12:22:38 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8MAMcrK015753
	for xfs@oss.sgi.com; Sat, 22 Sep 2007 12:22:38 +0200
Date: Sat, 22 Sep 2007 12:22:38 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] cleanup XFS_IFORK_*/XFS_DFORK* macros
Message-ID: <20070922102238.GA15732@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

(try number three, maybe it manages to get through the list this time)

Currently XFS_IFORK_* and XFS_DFORK* are implemented by means of
XFS_CFORK* macros.  But given that XFS_IFORK_* operates on an
xfs_inode that embedds and xfs_icdinode_core and XFS_DFORK_* operates
on an xfs_dinode that embedds a xfs_dinode_core one will have to do
endian swapping while the other doesn't.  Instead of having the current
mess with the CFORK macros that have byteswapping and non-byteswapping
version (which are inconsistantly named while we're at it) just define
each family of the macros to stand by itself and simplify the whole
matter.

A few direct references to the CFORK variants were cleaned up to
use IFORK or DFORK to make this possible.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_dinode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dinode.h	2007-08-23 18:52:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dinode.h	2007-09-19 15:16:30.000000000 +0200
@@ -171,69 +171,35 @@ typedef enum xfs_dinode_fmt
 /*
  * Inode data & attribute fork sizes, per inode.
  */
-#define XFS_CFORK_Q(dcp)                    ((dcp)->di_forkoff != 0)
-#define	XFS_CFORK_Q_DISK(dcp)		    ((dcp)->di_forkoff != 0)
-
-#define XFS_CFORK_BOFF(dcp)                 ((int)((dcp)->di_forkoff << 3))
-#define	XFS_CFORK_BOFF_DISK(dcp)	    ((int)((dcp)->di_forkoff << 3))
-
-#define	XFS_CFORK_DSIZE_DISK(dcp,mp) \
-	(XFS_CFORK_Q_DISK(dcp) ? XFS_CFORK_BOFF_DISK(dcp) : XFS_LITINO(mp))
-#define XFS_CFORK_DSIZE(dcp,mp) \
-	(XFS_CFORK_Q(dcp) ? XFS_CFORK_BOFF(dcp) : XFS_LITINO(mp))
-
-#define	XFS_CFORK_ASIZE_DISK(dcp,mp) \
-	(XFS_CFORK_Q_DISK(dcp) ? XFS_LITINO(mp) - XFS_CFORK_BOFF_DISK(dcp) : 0)
-#define XFS_CFORK_ASIZE(dcp,mp) \
-	(XFS_CFORK_Q(dcp) ? XFS_LITINO(mp) - XFS_CFORK_BOFF(dcp) : 0)
-
-#define	XFS_CFORK_SIZE_DISK(dcp,mp,w) \
-	((w) == XFS_DATA_FORK ? \
-		XFS_CFORK_DSIZE_DISK(dcp, mp) : \
-	 	XFS_CFORK_ASIZE_DISK(dcp, mp))
-#define XFS_CFORK_SIZE(dcp,mp,w) \
-	((w) == XFS_DATA_FORK ? \
-		XFS_CFORK_DSIZE(dcp, mp) : XFS_CFORK_ASIZE(dcp, mp))
+#define XFS_DFORK_Q(dip)		((dip)->di_core.di_forkoff != 0)
+#define XFS_DFORK_BOFF(dip)		((int)((dip)->di_core.di_forkoff << 3))
 
 #define XFS_DFORK_DSIZE(dip,mp) \
-	XFS_CFORK_DSIZE_DISK(&(dip)->di_core, mp)
-#define XFS_DFORK_DSIZE_HOST(dip,mp) \
-	XFS_CFORK_DSIZE(&(dip)->di_core, mp)
+	(XFS_DFORK_Q(dip) ? \
+		XFS_DFORK_BOFF(dip) : \
+		XFS_LITINO(mp))
 #define XFS_DFORK_ASIZE(dip,mp) \
-	XFS_CFORK_ASIZE_DISK(&(dip)->di_core, mp)
-#define XFS_DFORK_ASIZE_HOST(dip,mp) \
-	XFS_CFORK_ASIZE(&(dip)->di_core, mp)
-#define	XFS_DFORK_SIZE(dip,mp,w) \
-	XFS_CFORK_SIZE_DISK(&(dip)->di_core, mp, w)
-#define	XFS_DFORK_SIZE_HOST(dip,mp,w) \
-	XFS_CFORK_SIZE(&(dip)->di_core, mp, w)
-
-#define	XFS_DFORK_Q(dip)                    XFS_CFORK_Q_DISK(&(dip)->di_core)
-#define	XFS_DFORK_BOFF(dip)		    XFS_CFORK_BOFF_DISK(&(dip)->di_core)
-#define	XFS_DFORK_DPTR(dip)		    ((dip)->di_u.di_c)
-#define	XFS_DFORK_APTR(dip)	\
-	((dip)->di_u.di_c + XFS_DFORK_BOFF(dip))
-#define	XFS_DFORK_PTR(dip,w)	\
-	((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : XFS_DFORK_APTR(dip))
-#define	XFS_CFORK_FORMAT(dcp,w)	\
-	((w) == XFS_DATA_FORK ? (dcp)->di_format : (dcp)->di_aformat)
-#define	XFS_CFORK_FMT_SET(dcp,w,n) \
+	(XFS_DFORK_Q(dip) ? \
+		XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : \
+		0)
+#define XFS_DFORK_SIZE(dip,mp,w) \
 	((w) == XFS_DATA_FORK ? \
-		((dcp)->di_format = (n)) : ((dcp)->di_aformat = (n)))
-#define	XFS_DFORK_FORMAT(dip,w) XFS_CFORK_FORMAT(&(dip)->di_core, w)
+		XFS_DFORK_DSIZE(dip, mp) : \
+		XFS_DFORK_ASIZE(dip, mp))
 
-#define	XFS_CFORK_NEXTENTS_DISK(dcp,w) \
+#define XFS_DFORK_DPTR(dip)		    ((dip)->di_u.di_c)
+#define XFS_DFORK_APTR(dip)	\
+	((dip)->di_u.di_c + XFS_DFORK_BOFF(dip))
+#define XFS_DFORK_PTR(dip,w)	\
+	((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : XFS_DFORK_APTR(dip))
+#define XFS_DFORK_FORMAT(dip,w) \
 	((w) == XFS_DATA_FORK ? \
-	 	be32_to_cpu((dcp)->di_nextents) : \
-	 	be16_to_cpu((dcp)->di_anextents))
-#define XFS_CFORK_NEXTENTS(dcp,w) \
-	((w) == XFS_DATA_FORK ? (dcp)->di_nextents : (dcp)->di_anextents)
-#define	XFS_DFORK_NEXTENTS(dip,w) XFS_CFORK_NEXTENTS_DISK(&(dip)->di_core, w)
-#define	XFS_DFORK_NEXTENTS_HOST(dip,w) XFS_CFORK_NEXTENTS(&(dip)->di_core, w)
-
-#define	XFS_CFORK_NEXT_SET(dcp,w,n) \
+		(dip)->di_core.di_format : \
+		(dip)->di_core.di_aformat)
+#define XFS_DFORK_NEXTENTS(dip,w) \
 	((w) == XFS_DATA_FORK ? \
-		((dcp)->di_nextents = (n)) : ((dcp)->di_anextents = (n)))
+	 	be32_to_cpu((dip)->di_core.di_nextents) : \
+	 	be16_to_cpu((dip)->di_core.di_anextents))
 
 #define	XFS_BUF_TO_DINODE(bp)	((xfs_dinode_t *)XFS_BUF_PTR(bp))
 
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2007-09-19 15:09:31.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2007-09-19 15:16:30.000000000 +0200
@@ -341,17 +341,42 @@ xfs_iflags_test_and_clear(xfs_inode_t *i
 /*
  * Fork handling.
  */
-#define	XFS_IFORK_PTR(ip,w)		\
-	((w) == XFS_DATA_FORK ? &(ip)->i_df : (ip)->i_afp)
-#define	XFS_IFORK_Q(ip)			XFS_CFORK_Q(&(ip)->i_d)
-#define	XFS_IFORK_DSIZE(ip)		XFS_CFORK_DSIZE(&ip->i_d, ip->i_mount)
-#define	XFS_IFORK_ASIZE(ip)		XFS_CFORK_ASIZE(&ip->i_d, ip->i_mount)
-#define	XFS_IFORK_SIZE(ip,w)		XFS_CFORK_SIZE(&ip->i_d, ip->i_mount, w)
-#define	XFS_IFORK_FORMAT(ip,w)		XFS_CFORK_FORMAT(&ip->i_d, w)
-#define	XFS_IFORK_FMT_SET(ip,w,n)	XFS_CFORK_FMT_SET(&ip->i_d, w, n)
-#define	XFS_IFORK_NEXTENTS(ip,w)	XFS_CFORK_NEXTENTS(&ip->i_d, w)
-#define	XFS_IFORK_NEXT_SET(ip,w,n)	XFS_CFORK_NEXT_SET(&ip->i_d, w, n)
 
+#define XFS_IFORK_Q(ip)			((ip)->i_d.di_forkoff != 0)
+#define XFS_IFORK_BOFF(ip)		((int)((ip)->i_d.di_forkoff << 3))
+
+#define XFS_IFORK_PTR(ip,w)		\
+	((w) == XFS_DATA_FORK ? \
+		&(ip)->i_df : \
+		(ip)->i_afp)
+#define XFS_IFORK_DSIZE(ip) \
+	(XFS_IFORK_Q(ip) ? \
+		XFS_IFORK_BOFF(ip) : \
+		XFS_LITINO((ip)->i_mount))
+#define XFS_IFORK_ASIZE(ip) \
+	(XFS_IFORK_Q(ip) ? \
+		XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : \
+		0)
+#define XFS_IFORK_SIZE(ip,w) \
+	((w) == XFS_DATA_FORK ? \
+		XFS_IFORK_DSIZE(ip) : \
+		XFS_IFORK_ASIZE(ip))
+#define XFS_IFORK_FORMAT(ip,w) \
+	((w) == XFS_DATA_FORK ? \
+		(ip)->i_d.di_format : \
+		(ip)->i_d.di_aformat)
+#define XFS_IFORK_FMT_SET(ip,w,n) \
+	((w) == XFS_DATA_FORK ? \
+		((ip)->i_d.di_format = (n)) : \
+		((ip)->i_d.di_aformat = (n)))
+#define XFS_IFORK_NEXTENTS(ip,w) \
+	((w) == XFS_DATA_FORK ? \
+		(ip)->i_d.di_nextents : \
+		(ip)->i_d.di_anextents)
+#define XFS_IFORK_NEXT_SET(ip,w,n) \
+	((w) == XFS_DATA_FORK ? \
+		((ip)->i_d.di_nextents = (n)) : \
+		((ip)->i_d.di_anextents = (n)))
 
 #ifdef __KERNEL__
 
@@ -504,7 +529,7 @@ void		xfs_dinode_to_disk(struct xfs_dino
 				   struct xfs_icdinode *);
 
 uint		xfs_ip2xflags(struct xfs_inode *);
-uint		xfs_dic2xflags(struct xfs_dinode_core *);
+uint		xfs_dic2xflags(struct xfs_dinode *);
 int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
 			   struct xfs_bmap_free *);
 int		xfs_itruncate_start(xfs_inode_t *, uint, xfs_fsize_t);
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2007-09-19 15:09:31.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2007-09-19 15:16:30.000000000 +0200
@@ -826,15 +826,17 @@ xfs_ip2xflags(
 	xfs_icdinode_t		*dic = &ip->i_d;
 
 	return _xfs_dic2xflags(dic->di_flags) |
-				(XFS_CFORK_Q(dic) ? XFS_XFLAG_HASATTR : 0);
+				(XFS_IFORK_Q(ip) ? XFS_XFLAG_HASATTR : 0);
 }
 
 uint
 xfs_dic2xflags(
-	xfs_dinode_core_t	*dic)
+	xfs_dinode_t		*dip)
 {
+	xfs_dinode_core_t	*dic = &dip->di_core;
+
 	return _xfs_dic2xflags(be16_to_cpu(dic->di_flags)) |
-				(XFS_CFORK_Q_DISK(dic) ? XFS_XFLAG_HASATTR : 0);
+				(XFS_DFORK_Q(dip) ? XFS_XFLAG_HASATTR : 0);
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c	2007-09-12 13:56:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_itable.c	2007-09-19 15:16:30.000000000 +0200
@@ -170,7 +170,7 @@ xfs_bulkstat_one_dinode(
 	buf->bs_mtime.tv_nsec = be32_to_cpu(dic->di_mtime.t_nsec);
 	buf->bs_ctime.tv_sec = be32_to_cpu(dic->di_ctime.t_sec);
 	buf->bs_ctime.tv_nsec = be32_to_cpu(dic->di_ctime.t_nsec);
-	buf->bs_xflags = xfs_dic2xflags(dic);
+	buf->bs_xflags = xfs_dic2xflags(dip);
 	buf->bs_extsize = be32_to_cpu(dic->di_extsize) << mp->m_sb.sb_blocklog;
 	buf->bs_extents = be32_to_cpu(dic->di_nextents);
 	buf->bs_gen = be32_to_cpu(dic->di_gen);
@@ -299,7 +299,7 @@ xfs_bulkstat_use_dinode(
 	}
 	/* BULKSTAT_FG_INLINE: if attr fork is local, or not there, use it */
 	aformat = dip->di_core.di_aformat;
-	if ((XFS_CFORK_Q(&dip->di_core) == 0) ||
+	if ((XFS_DFORK_Q(dip) == 0) ||
 	    (aformat == XFS_DINODE_FMT_LOCAL) ||
 	    (aformat == XFS_DINODE_FMT_EXTENTS && !dip->di_core.di_anextents)) {
 		*dipp = dip;
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-09-19 18:50:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-09-19 18:51:01.000000000 +0200
@@ -355,7 +355,7 @@ xfs_ip2dmflags(
 	xfs_inode_t	*ip)
 {
 	return _xfs_dic2dmflags(ip->i_d.di_flags) |
-			(XFS_CFORK_Q(&ip->i_d) ? DM_XFLAG_HASATTR : 0);
+			(XFS_IFORK_Q(ip) ? DM_XFLAG_HASATTR : 0);
 }
 
 STATIC uint
@@ -363,8 +363,7 @@ xfs_dic2dmflags(
 	xfs_dinode_t	*dip)
 {
 	return _xfs_dic2dmflags(be16_to_cpu(dip->di_core.di_flags)) |
-			(XFS_CFORK_Q_DISK(&dip->di_core) ?
-			 DM_XFLAG_HASATTR : 0);
+			(XFS_DFORK_Q(dip) ? DM_XFLAG_HASATTR : 0);
 }
 
 /*
