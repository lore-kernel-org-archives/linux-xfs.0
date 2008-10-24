Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 21:52:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9O4q42f007296
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 21:52:04 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D3E3538372
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 21:52:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id eUPYpkXHBKmxRPud for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 21:52:02 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id A6F44AC359B
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 23:01:11 -0500 (CDT)
Message-ID: <49014887.6050309@sandeen.net>
Date: Thu, 23 Oct 2008 23:01:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/2] delalloc support for xfs fiemap
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Ok, got the kinks worked out of the delalloc portion of the
fiemap hookup I think.

This introduces a new input flag (BMV_IF_DELALLOC) and output
flag (BMV_OF_DELALLOC) to request & show the delayed allocation
segments.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6.27.x86_64/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6.27.x86_64.orig/fs/xfs/linux-2.6/xfs_iops.c
+++ linux-2.6.27.x86_64/fs/xfs/linux-2.6/xfs_iops.c
@@ -685,6 +685,10 @@ STATIC int xfs_fiemap_format(
 
 	if (bmv->bmv_oflags & BMV_OF_PREALLOC)
 		fiemap_flags |= FIEMAP_EXTENT_UNWRITTEN;
+	else if (bmv->bmv_oflags & BMV_OF_DELALLOC) {
+		fiemap_flags |= FIEMAP_EXTENT_DELALLOC;
+		physical = 0;   /* no block yet */
+	}
 	if (bmv->bmv_oflags & BMV_OF_LAST)
 		fiemap_flags |= FIEMAP_EXTENT_LAST;
 
@@ -722,6 +726,8 @@ xfs_vn_fiemap(
 	bm.bmv_iflags = BMV_IF_PREALLOC;
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR)
 		bm.bmv_iflags |= BMV_IF_ATTRFORK;
+	if (!(fieinfo->fi_flags & FIEMAP_FLAG_SYNC))
+		bm.bmv_iflags |= BMV_IF_DELALLOC;
 
 	error = xfs_getbmap(ip, &bm, xfs_fiemap_format, fieinfo);
 	if (error)
Index: linux-2.6.27.x86_64/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6.27.x86_64.orig/fs/xfs/xfs_bmap.c
+++ linux-2.6.27.x86_64/fs/xfs/xfs_bmap.c
@@ -5827,6 +5827,7 @@ xfs_getbmap(
 						 * preallocated data space */
 	int			sh_unwritten;	/* true, if unwritten */
 						/* extents listed separately */
+	int			sh_delalloc;	/* show delayed extents */
 	int			iflags;		/* interface flags */
 	int			bmapi_flags;	/* flags for xfs_bmapi */
 
@@ -5835,6 +5836,7 @@ xfs_getbmap(
 
 	whichfork = iflags & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
 	sh_unwritten = (iflags & BMV_IF_PREALLOC) != 0;
+	sh_delalloc = (iflags & BMV_IF_DELALLOC) != 0;
 
 	/*	If the BMV_IF_NO_DMAPI_READ interface bit specified, do not
 	 *	generate a DMAPI read event.  Otherwise, if the DM_EVENT_READ
@@ -5905,7 +5907,7 @@ xfs_getbmap(
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
-	if (whichfork == XFS_DATA_FORK &&
+	if (!sh_delalloc && (whichfork == XFS_DATA_FORK) &&
 		(ip->i_delayed_blks || ip->i_size > ip->i_d.di_size)) {
 		/* xfs_fsize_t last_byte = xfs_file_last_byte(ip); */
 		error = xfs_flush_pages(ip, (xfs_off_t)0,
@@ -5938,9 +5940,11 @@ xfs_getbmap(
 
 	bmv->bmv_entries = 0;
 
-	if (XFS_IFORK_NEXTENTS(ip, whichfork) == 0) {
-		error = 0;
-		goto unlock_and_return;
+	if ((XFS_IFORK_NEXTENTS(ip, whichfork) == 0)) {
+		if (!sh_delalloc || whichfork == XFS_ATTR_FORK) {
+			error = 0;
+			goto unlock_and_return;
+		}
 	}
 
 	nexleft = nex;
@@ -5956,12 +5960,16 @@ xfs_getbmap(
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
+			ASSERT(sh_delalloc ||
+			      (map[i].br_startblock != DELAYSTARTBLOCK));
                         if (map[i].br_startblock == HOLESTARTBLOCK &&
 			    whichfork == XFS_ATTR_FORK) {
 				/* came to the end of attribute fork */
Index: linux-2.6.27.x86_64/fs/xfs/xfs_fs.h
===================================================================
--- linux-2.6.27.x86_64.orig/fs/xfs/xfs_fs.h
+++ linux-2.6.27.x86_64/fs/xfs/xfs_fs.h
@@ -113,10 +113,13 @@ struct getbmapx {
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
 #define BMV_OF_LAST		0x4	/* segment is the last in the file */
 
 /*
