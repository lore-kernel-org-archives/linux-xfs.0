Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Oct 2008 14:31:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9QLV3pd003888
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 14:31:03 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D19AF12AC0DE
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 14:31:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id ntunrd1c2MlwfNd0 for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 14:31:03 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id E6B24AC6275
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 16:31:02 -0500 (CDT)
Message-ID: <4904E196.8070206@sandeen.net>
Date: Sun, 26 Oct 2008 16:31:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/3 v3]  Add new flags to getbmapx interface
References: <4904E0DE.3040902@sandeen.net>
In-Reply-To: <4904E0DE.3040902@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Add new getbmap flags.

This adds a new output flag, BMV_OF_LAST to indicate if we've hit
the last extent in the inode.  This potentially saves an extra call
from userspace to see when the whole mapping is done.

It also adds BMV_IF_DELALLOC and BMV_OF_DELALLOC to request, and
indicate, delayed-allocation extents.  In this case bmv_block
is set to -2 (-1 was already taken for HOLESTARTBLOCK; unfortunately
these are the reverse of the in-kernel constants.)

These new flags facilitate addition of the new fiemap interface.

Rather than adding sh_delalloc, remove sh_unwritten & just test
the flags directly.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c
@@ -5813,6 +5813,9 @@ xfs_getbmapx_fix_eof_hole(
 {
 	__int64_t		fixlen;
 	xfs_mount_t		*mp;		/* file system mount point */
+	xfs_ifork_t		*ifp;		/* inode fork pointer */
+	xfs_extnum_t		lastx;		/* last extent pointer */
+	xfs_fileoff_t		fileblock;
 
 	if (startblock == HOLESTARTBLOCK) {
 		mp = ip->i_mount;
@@ -5826,7 +5829,15 @@ xfs_getbmapx_fix_eof_hole(
 			out->bmv_length = fixlen;
 		}
 	} else {
-		out->bmv_block = XFS_FSB_TO_DB(ip, startblock);
+		if (startblock == DELAYSTARTBLOCK)
+			out->bmv_block = -2;
+		else
+			out->bmv_block = XFS_FSB_TO_DB(ip, startblock);
+		fileblock = XFS_BB_TO_FSB(ip->i_mount, out->bmv_offset);
+		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+		if (xfs_iext_bno_to_ext(ifp, fileblock, &lastx) &&
+		   (lastx == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))-1))
+			out->bmv_oflags |= BMV_OF_LAST;
 	}
 
 	return 1;
@@ -5857,8 +5868,6 @@ xfs_getbmap(
 	int			whichfork;	/* data or attr fork */
 	int			prealloced;	/* this is a file with
 						 * preallocated data space */
-	int			sh_unwritten;	/* true, if unwritten */
-						/* extents listed separately */
 	int			iflags;		/* interface flags */
 	int			bmapi_flags;	/* flags for xfs_bmapi */
 
@@ -5866,7 +5875,6 @@ xfs_getbmap(
 	iflags = bmv->bmv_iflags;
 
 	whichfork = iflags & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
-	sh_unwritten = (iflags & BMV_IF_PREALLOC) != 0;
 
 	/*	If the BMV_IF_NO_DMAPI_READ interface bit specified, do not
 	 *	generate a DMAPI read event.  Otherwise, if the DM_EVENT_READ
@@ -5937,8 +5945,9 @@ xfs_getbmap(
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
-	if (whichfork == XFS_DATA_FORK &&
-		(ip->i_delayed_blks || ip->i_size > ip->i_d.di_size)) {
+	if (((iflags & BMV_IF_DELALLOC) == 0) &&
+	    (whichfork == XFS_DATA_FORK) &&
+	    (ip->i_delayed_blks || ip->i_size > ip->i_d.di_size)) {
 		/* xfs_fsize_t last_byte = xfs_file_last_byte(ip); */
 		error = xfs_flush_pages(ip, (xfs_off_t)0,
 					       -1, 0, FI_REMAPF);
@@ -5948,7 +5957,8 @@ xfs_getbmap(
 		}
 	}
 
-	ASSERT(whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0);
+	ASSERT(whichfork == XFS_ATTR_FORK || (iflags & BMV_IF_DELALLOC) ||
+	       ip->i_delayed_blks == 0);
 
 	lock = xfs_ilock_map_shared(ip);
 
@@ -5960,7 +5970,7 @@ xfs_getbmap(
 		nex = XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1;
 
 	bmapi_flags = XFS_BMAPI_AFLAG(whichfork) |
-			((sh_unwritten) ? 0 : XFS_BMAPI_IGSTATE);
+			((iflags & BMV_IF_PREALLOC) ? 0 : XFS_BMAPI_IGSTATE);
 
 	/*
 	 * Allocate enough space to handle "subnex" maps at a time.
@@ -5970,9 +5980,12 @@ xfs_getbmap(
 
 	bmv->bmv_entries = 0;
 
-	if (XFS_IFORK_NEXTENTS(ip, whichfork) == 0) {
-		error = 0;
-		goto unlock_and_return;
+	if ((XFS_IFORK_NEXTENTS(ip, whichfork) == 0)) {
+		if (((iflags & BMV_IF_DELALLOC) == 0) ||
+		    whichfork == XFS_ATTR_FORK) {
+			error = 0;
+			goto unlock_and_return;
+		}
 	}
 
 	nexleft = nex;
@@ -5988,15 +6001,20 @@ xfs_getbmap(
 		ASSERT(nmap <= subnex);
 
 		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
-			out.bmv_oflags = (map[i].br_state == XFS_EXT_UNWRITTEN) ?
-					BMV_OF_PREALLOC : 0;
+			out.bmv_oflags = 0;
+			if (map[i].br_state == XFS_EXT_UNWRITTEN)
+				out.bmv_oflags |= BMV_OF_PREALLOC;
+			else if (map[i].br_startblock == DELAYSTARTBLOCK)
+				out.bmv_oflags |= BMV_OF_DELALLOC;
 			out.bmv_offset = XFS_FSB_TO_BB(mp, map[i].br_startoff);
 			out.bmv_length = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			out.bmv_unused1 = out.bmv_unused2 = 0;
-			ASSERT(map[i].br_startblock != DELAYSTARTBLOCK);
+			ASSERT(((iflags & BMV_IF_DELALLOC) != 0) ||
+			      (map[i].br_startblock != DELAYSTARTBLOCK));
                         if (map[i].br_startblock == HOLESTARTBLOCK &&
 			    whichfork == XFS_ATTR_FORK) {
 				/* came to the end of attribute fork */
+				out.bmv_oflags |= BMV_OF_LAST;
 				goto unlock_and_return;
 			} else {
 				int filled;	/* nr extents filled */
Index: linux-2.6-xfs/fs/xfs/xfs_fs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fs.h
+++ linux-2.6-xfs/fs/xfs/xfs_fs.h
@@ -113,10 +113,14 @@ struct getbmapx {
 #define BMV_IF_ATTRFORK		0x1	/* return attr fork rather than data */
 #define BMV_IF_NO_DMAPI_READ	0x2	/* Do not generate DMAPI read event  */
 #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
-#define BMV_IF_VALID	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC)
+#define BMV_IF_DELALLOC		0x8	/* rtn status BMV_OF_DELALLOC if req */
+#define BMV_IF_VALID	\
+	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|BMV_IF_DELALLOC)
 
 /*	bmv_oflags values - returned for for each non-header segment */
 #define BMV_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
+#define BMV_OF_DELALLOC		0x2	/* segment = delayed allocation */
+#define BMV_OF_LAST		0x4	/* segment is the last in the file */
 
 /*
  * Structure for XFS_IOC_FSSETDM.
