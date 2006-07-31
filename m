Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Jul 2006 21:03:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6V43VDW002458
	for <xfs@oss.sgi.com>; Sun, 30 Jul 2006 21:03:32 -0700
Message-ID: <44CD80FD.5060101@sandeen.net>
Date: Sun, 30 Jul 2006 23:03:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] kill no-op buf macros
References: <44CC2A55.6030207@sandeen.net> <20060731090815.B2280998@wobbly.melbourne.sgi.com>
In-Reply-To: <20060731090815.B2280998@wobbly.melbourne.sgi.com>
Content-Type: multipart/mixed;
 boundary="------------010804020903080006020305"
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: dgc@sgi.com, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------010804020903080006020305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Nathan Scott wrote:

>> #define XFS_BUF_ISUNINITIAL(bp)	(0)
> 
> This can go, unwritten extents don't use this interface on Linux.
> 
>> #define XFS_BUF_BP_ISMAPPED(bp)	(1)
> 
> *nod* - looks like it should go.
> 
> (could you regen the patch with just these two for now?  they are
> pretty much self-contained changes, and nice 'n small)

Ok, here it is, not so interesting :)

-Eric

--------------010804020903080006020305
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="kill-BUF_ISUNINITIAL_and_ISMAPPED"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kill-BUF_ISUNINITIAL_and_ISMAPPED"

Remove a couple of unused BUF macros

Signed-Off-By: Eric Sandeen <sandeen@sandeen.net>

Index: xfs-linux/linux-2.4/xfs_buf.h
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_buf.h
+++ xfs-linux/linux-2.4/xfs_buf.h
@@ -380,10 +380,6 @@ BUFFER_FNS(Delay, delay)
 #define XFS_BUF_WRITE(bp)	((bp)->b_flags |= XBF_WRITE)
 #define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
 
-#define XFS_BUF_ISUNINITIAL(bp)	(0)
-
-#define XFS_BUF_BP_ISMAPPED(bp)	(1)
-
 #define XFS_BUF_DATAIO(bp)	((bp)->b_flags |= XBF_FS_DATAIOD)
 #define XFS_BUF_UNDATAIO(bp)	((bp)->b_flags &= ~XBF_FS_DATAIOD)
 
Index: xfs-linux/linux-2.6/xfs_buf.h
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_buf.h
+++ xfs-linux/linux-2.6/xfs_buf.h
@@ -296,10 +296,6 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 #define XFS_BUF_WRITE(bp)	((bp)->b_flags |= XBF_WRITE)
 #define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
 
-#define XFS_BUF_ISUNINITIAL(bp)	(0)
-
-#define XFS_BUF_BP_ISMAPPED(bp)	(1)
-
 #define XFS_BUF_IODONE_FUNC(bp)			((bp)->b_iodone)
 #define XFS_BUF_SET_IODONE_FUNC(bp, func)	((bp)->b_iodone = (func))
 #define XFS_BUF_CLR_IODONE_FUNC(bp)		((bp)->b_iodone = NULL)
Index: xfs-linux/xfs_buf_item.c
===================================================================
--- xfs-linux.orig/xfs_buf_item.c
+++ xfs-linux/xfs_buf_item.c
@@ -234,7 +234,6 @@ xfs_buf_item_format(
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
 	bp = bip->bli_buf;
-	ASSERT(XFS_BUF_BP_ISMAPPED(bp));
 	vecp = log_vector;
 
 	/*
@@ -901,7 +900,6 @@ xfs_buf_item_relse(
 	XFS_BUF_SET_FSPRIVATE(bp, bip->bli_item.li_bio_list);
 	if ((XFS_BUF_FSPRIVATE(bp, void *) == NULL) &&
 	    (XFS_BUF_IODONE_FUNC(bp) != NULL)) {
-		ASSERT((XFS_BUF_ISUNINITIAL(bp)) == 0);
 		XFS_BUF_CLR_IODONE_FUNC(bp);
 	}
 

--------------010804020903080006020305--
