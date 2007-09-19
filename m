Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 09:12:09 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JGC3uw009019
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 09:12:05 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8JGC4A5018188
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 18:12:04 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8JGC3Cn018184
	for xfs@oss.sgi.com; Wed, 19 Sep 2007 18:12:03 +0200
Date: Wed, 19 Sep 2007 18:12:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill XFS_INOBT_IS_FREE_DISK
Message-ID: <20070919161202.GA18130@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This macro is unused an all other acros in this family operate on native
types, so we most likely won't grow a user either.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6.23-rc6/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- linux-2.6.23-rc6.orig/fs/xfs/xfs_ialloc_btree.h	2007-09-18 16:27:08.000000000 +0200
+++ linux-2.6.23-rc6/fs/xfs/xfs_ialloc_btree.h	2007-09-18 16:27:18.000000000 +0200
@@ -81,8 +81,6 @@ typedef	struct xfs_btree_sblock xfs_inob
 #define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
 #define	XFS_INOBT_IS_FREE(rp,i)		\
 		(((rp)->ir_free & XFS_INOBT_MASK(i)) != 0)
-#define	XFS_INOBT_IS_FREE_DISK(rp,i)	\
-		((be64_to_cpu((rp)->ir_free) & XFS_INOBT_MASK(i)) != 0)
 #define	XFS_INOBT_SET_FREE(rp,i)	((rp)->ir_free |= XFS_INOBT_MASK(i))
 #define	XFS_INOBT_CLR_FREE(rp,i)	((rp)->ir_free &= ~XFS_INOBT_MASK(i))
 
