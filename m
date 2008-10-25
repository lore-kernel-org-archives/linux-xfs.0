Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 06:33:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PDXDrO024557
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 06:33:14 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FE9E12A8503
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 06:33:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id sHPC5DjX1fVNrxHP for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 06:33:12 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 52503A9ABD3
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 08:33:12 -0500 (CDT)
Message-ID: <49032017.6070408@sandeen.net>
Date: Sat, 25 Oct 2008 08:33:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2 v2] convert xfs_getbmap to take formatter functions
References: <49031E81.7040807@sandeen.net>
In-Reply-To: <49031E81.7040807@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Preliminary work to hook up fiemap, this allows us to pass in an
arbitrary formatter to copy extent data back to userspace.

The formatter takes info for 1 extent, a pointer to the user "thing*"
and a pointer to a "filled" variable to indicate whether a userspace
buffer did get filled in (for fiemap, hole "extents" are skipped).

I'm just using the getbmapx struct as a "common denominator" because
as far as I can see, it holds all info that any formatters will care
about.

("*thing" because fiemap doesn't pass the user pointer around, but rather
has a pointer to a fiemap info structure, and helpers associated with it)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c
@@ -5805,9 +5805,9 @@ error0:
 STATIC int
 xfs_getbmapx_fix_eof_hole(
 	xfs_inode_t		*ip,		/* xfs incore inode pointer */
-	struct getbmap		*out,		/* output structure */
+	struct getbmapx		*out,		/* output structure */
 	int			prealloced,	/* this is a file with
-						* preallocated data space */
+						 * preallocated data space */
 	__int64_t		end,		/* last block requested */
 	xfs_fsblock_t		startblock)
 {
@@ -5832,15 +5832,38 @@ xfs_getbmapx_fix_eof_hole(
 	return 1;
 }
 
+int xfs_getbmapx_format(void __user **ap, struct getbmapx *bmv, int *filled)
+{
+	*filled = 0;
+	if (copy_to_user(*ap, bmv, sizeof(struct getbmapx)))
+		return XFS_ERROR(EFAULT);
+
+	*ap += sizeof(struct getbmapx);
+	*filled = 1;
+	return 0;
+}
+
+int xfs_getbmap_format(void __user **ap, struct getbmapx *bmv, int *filled)
+{
+	*filled = 0;
+	/* copy only getbmap portion (not getbmapx) */
+	if (copy_to_user(*ap, bmv, sizeof(struct getbmap)))
+		return XFS_ERROR(EFAULT);
+
+	*ap += sizeof(struct getbmap);
+	*filled = 1;
+	return 0;
+}
+
 /*
- * Fcntl interface to xfs_bmapi.
+ * Get inode's extents as described in bmv, and format for output.
  */
 int						/* error code */
 xfs_getbmap(
 	xfs_inode_t		*ip,
-	struct getbmap		*bmv,		/* user bmap structure */
-	void			__user *ap,	/* pointer to user's array */
-	int			interface)	/* interface flags */
+	struct getbmapx		*bmv,		/* user bmap structure */
+	xfs_bmap_format_t	formatter,	/* format to user */
+	void			*arg)		/* formatter arg */
 {
 	__int64_t		bmvend;		/* last block requested */
 	int			error;		/* return value */
@@ -5853,19 +5876,20 @@ xfs_getbmap(
 	int			nexleft;	/* # of user extents left */
 	int			subnex;		/* # of bmapi's can do */
 	int			nmap;		/* number of map entries */
-	struct getbmap		out;		/* output structure */
+	struct getbmapx		out;		/* output structure */
 	int			whichfork;	/* data or attr fork */
 	int			prealloced;	/* this is a file with
 						 * preallocated data space */
 	int			sh_unwritten;	/* true, if unwritten */
 						/* extents listed separately */
+	int			iflags;		/* interface flags */
 	int			bmapi_flags;	/* flags for xfs_bmapi */
-	__int32_t		oflags;		/* getbmapx bmv_oflags field */
 
 	mp = ip->i_mount;
+	iflags = bmv->bmv_iflags;
 
-	whichfork = interface & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
-	sh_unwritten = (interface & BMV_IF_PREALLOC) != 0;
+	whichfork = iflags & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
+	sh_unwritten = (iflags & BMV_IF_PREALLOC) != 0;
 
 	/*	If the BMV_IF_NO_DMAPI_READ interface bit specified, do not
 	 *	generate a DMAPI read event.  Otherwise, if the DM_EVENT_READ
@@ -5880,7 +5904,7 @@ xfs_getbmap(
 	 *	could misinterpret holes in a DMAPI file as true holes,
 	 *	when in fact they may represent offline user data.
 	 */
-	if ((interface & BMV_IF_NO_DMAPI_READ) == 0 &&
+	if ((iflags & BMV_IF_NO_DMAPI_READ) == 0 &&
 	    DM_EVENT_ENABLED(ip, DM_EVENT_READ) &&
 	    whichfork == XFS_DATA_FORK) {
 		error = XFS_SEND_DATA(mp, DM_EVENT_READ, ip, 0, 0, 0, NULL);
@@ -5987,52 +6011,35 @@ xfs_getbmap(
 		ASSERT(nmap <= subnex);
 
 		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
-			nexleft--;
-			oflags = (map[i].br_state == XFS_EXT_UNWRITTEN) ?
+			out.bmv_oflags = (map[i].br_state == XFS_EXT_UNWRITTEN) ?
 					BMV_OF_PREALLOC : 0;
 			out.bmv_offset = XFS_FSB_TO_BB(mp, map[i].br_startoff);
 			out.bmv_length = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
+			out.bmv_unused1 = out.bmv_unused2 = 0;
 			ASSERT(map[i].br_startblock != DELAYSTARTBLOCK);
                         if (map[i].br_startblock == HOLESTARTBLOCK &&
 			    whichfork == XFS_ATTR_FORK) {
 				/* came to the end of attribute fork */
 				goto unlock_and_return;
 			} else {
+				int filled;	/* nr extents filled */
+
 				if (!xfs_getbmapx_fix_eof_hole(ip, &out,
 							prealloced, bmvend,
 							map[i].br_startblock)) {
 					goto unlock_and_return;
 				}
 
-				/* return either getbmap/getbmapx structure. */
-				if (interface & BMV_IF_EXTENDED) {
-					struct	getbmapx	outx;
-
-					GETBMAP_CONVERT(out,outx);
-					outx.bmv_oflags = oflags;
-					outx.bmv_unused1 = outx.bmv_unused2 = 0;
-					if (copy_to_user(ap, &outx,
-							sizeof(outx))) {
-						error = XFS_ERROR(EFAULT);
-						goto unlock_and_return;
-					}
-				} else {
-					if (copy_to_user(ap, &out,
-							sizeof(out))) {
-						error = XFS_ERROR(EFAULT);
-						goto unlock_and_return;
-					}
-				}
+				/* format results & advance arg */
+				error = formatter(&arg, &out, &filled);
+				if (error)
+					goto unlock_and_return;
+				nexleft -= filled;
 				bmv->bmv_offset =
 					out.bmv_offset + out.bmv_length;
 				bmv->bmv_length = MAX((__int64_t)0,
 					(__int64_t)(bmvend - bmv->bmv_offset));
 				bmv->bmv_entries++;
-				ap = (interface & BMV_IF_EXTENDED) ?
-						(void __user *)
-					((struct getbmapx __user *)ap + 1) :
-						(void __user *)
-					((struct getbmap __user *)ap + 1);
 			}
 		}
 	} while (nmap && nexleft && bmv->bmv_length);
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.h
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.h
@@ -356,15 +356,20 @@ xfs_bmap_finish(
 	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
 	int			*committed);	/* xact committed or not */
 
+/* bmap to userspace formatters - copy to user & advance pointer */
+typedef int (*xfs_bmap_format_t)(void __user **, struct getbmapx *, int *);
+int xfs_getbmapx_format(void __user **ap, struct getbmapx *bmv, int *filled);
+int xfs_getbmap_format(void __user **ap, struct getbmapx *bmv, int *filled);
+
 /*
- * Fcntl interface to xfs_bmapi.
+ * Get inode's extents as described in bmv, and format for output.
  */
 int						/* error code */
 xfs_getbmap(
 	xfs_inode_t		*ip,
-	struct getbmap		*bmv,		/* user bmap structure */
-	void			__user *ap,	/* pointer to user's array */
-	int			iflags);	/* interface flags */
+	struct getbmapx		*bmv,		/* user bmap structure */
+	xfs_bmap_format_t	formatter,	/* format to user */
+	void			*arg);		/* formatter arg */
 
 /*
  * Check if the endoff is outside the last extent. If so the caller will grow
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1262,25 +1262,26 @@ xfs_ioc_getbmap(
 	unsigned int		cmd,
 	void			__user *arg)
 {
-	struct getbmap		bm;
-	int			iflags;
+	struct getbmapx		bmx;
 	int			error;
 
-	if (copy_from_user(&bm, arg, sizeof(bm)))
+	if (copy_from_user(&bmx, arg, sizeof(struct getbmapx)))
 		return -XFS_ERROR(EFAULT);
 
-	if (bm.bmv_count < 2)
+	if (bmx.bmv_count < 2)
 		return -XFS_ERROR(EINVAL);
 
-	iflags = (cmd == XFS_IOC_GETBMAPA ? BMV_IF_ATTRFORK : 0);
+	bmx.bmv_iflags = (cmd == XFS_IOC_GETBMAPA ? BMV_IF_ATTRFORK : 0);
 	if (ioflags & IO_INVIS)
-		iflags |= BMV_IF_NO_DMAPI_READ;
+		bmx.bmv_iflags |= BMV_IF_NO_DMAPI_READ;
 
-	error = xfs_getbmap(ip, &bm, (struct getbmap __user *)arg+1, iflags);
+	error = xfs_getbmap(ip, &bmx, xfs_getbmap_format,
+			    (struct getbmap __user *)arg+1);
 	if (error)
 		return -error;
 
-	if (copy_to_user(arg, &bm, sizeof(bm)))
+	/* copy back header - only size of getbmap */
+	if (copy_to_user(arg, &bmx, sizeof(struct getbmap)))
 		return -XFS_ERROR(EFAULT);
 	return 0;
 }
@@ -1291,8 +1292,6 @@ xfs_ioc_getbmapx(
 	void			__user *arg)
 {
 	struct getbmapx		bmx;
-	struct getbmap		bm;
-	int			iflags;
 	int			error;
 
 	if (copy_from_user(&bmx, arg, sizeof(bmx)))
@@ -1301,26 +1300,16 @@ xfs_ioc_getbmapx(
 	if (bmx.bmv_count < 2)
 		return -XFS_ERROR(EINVAL);
 
-	/*
-	 * Map input getbmapx structure to a getbmap
-	 * structure for xfs_getbmap.
-	 */
-	GETBMAP_CONVERT(bmx, bm);
-
-	iflags = bmx.bmv_iflags;
-
-	if (iflags & (~BMV_IF_VALID))
+	if (bmx.bmv_iflags & (~BMV_IF_VALID))
 		return -XFS_ERROR(EINVAL);
 
-	iflags |= BMV_IF_EXTENDED;
-
-	error = xfs_getbmap(ip, &bm, (struct getbmapx __user *)arg+1, iflags);
+	error = xfs_getbmap(ip, &bmx, xfs_getbmapx_format,
+			    (struct getbmapx __user *)arg+1);
 	if (error)
 		return -error;
 
-	GETBMAP_CONVERT(bm, bmx);
-
-	if (copy_to_user(arg, &bmx, sizeof(bmx)))
+	/* copy back header */
+	if (copy_to_user(arg, &bmx, sizeof(struct getbmapx)))
 		return -XFS_ERROR(EFAULT);
 
 	return 0;
Index: linux-2.6-xfs/fs/xfs/xfs_fs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fs.h
+++ linux-2.6-xfs/fs/xfs/xfs_fs.h
@@ -114,22 +114,10 @@ struct getbmapx {
 #define BMV_IF_NO_DMAPI_READ	0x2	/* Do not generate DMAPI read event  */
 #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
 #define BMV_IF_VALID	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC)
-#ifdef __KERNEL__
-#define BMV_IF_EXTENDED 0x40000000	/* getpmapx if set */
-#endif
 
 /*	bmv_oflags values - returned for for each non-header segment */
 #define BMV_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
 
-/*	Convert getbmap <-> getbmapx - move fields from p1 to p2. */
-#define GETBMAP_CONVERT(p1,p2) {	\
-	p2.bmv_offset = p1.bmv_offset;	\
-	p2.bmv_block = p1.bmv_block;	\
-	p2.bmv_length = p1.bmv_length;	\
-	p2.bmv_count = p1.bmv_count;	\
-	p2.bmv_entries = p1.bmv_entries;  }
-
-
 /*
  * Structure for XFS_IOC_FSSETDM.
  * For use by backup and restore programs to set the XFS on-disk inode
