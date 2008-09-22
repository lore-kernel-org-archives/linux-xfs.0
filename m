Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 04:04:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8MB4rCb017984
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 04:04:53 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BADCF46B088
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 04:06:26 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id c0pqVOvSy3nme4nv for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 04:06:26 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8MB6QIF026042
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 13:06:26 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8MB6Q4q026040
	for xfs@oss.sgi.com; Mon, 22 Sep 2008 13:06:26 +0200
Date: Mon, 22 Sep 2008 13:06:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] fix up btree headers for userspace
Message-ID: <20080922110626.GB26007@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-header-fixes
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Remove two __KERNEL__ sections in xfs_bmap_btree.h and xfs_btree.h that
prevent using the new generic btree code in xfsprogs.


Signed-off-by: Christoph Hellwig <hch@lst.de>

--- linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-08-31 23:17:27.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-08-31 23:17:57.000000000 -0300
@@ -231,8 +231,6 @@ typedef struct xfs_btree_lblock xfs_bmbt
 	 be16_to_cpu((bb)->bb_numrecs) <= (mp)->m_bmap_dmxr[(level) != 0])
 
 
-#ifdef __KERNEL__
-
 /*
  * Prototypes for xfs_bmap.c to call.
  */
@@ -264,6 +262,5 @@ extern void xfs_bmbt_to_bmdr(xfs_bmbt_bl
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
 
-#endif	/* __KERNEL__ */
 
 #endif	/* __XFS_BMAP_BTREE_H__ */
--- linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-31 23:12:32.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-31 23:12:46.000000000 -0300
@@ -327,8 +327,6 @@ typedef struct xfs_btree_cur
 #define	XFS_BUF_TO_SBLOCK(bp)	((xfs_btree_sblock_t *)XFS_BUF_PTR(bp))
 
 
-#ifdef __KERNEL__
-
 /*
  * Check that long form block header is ok.
  */
@@ -515,8 +513,6 @@ static inline int xfs_btree_get_level(st
 	return be16_to_cpu(block->bb_level);
 }
 
-#endif	/* __KERNEL__ */
-
 
 /*
  * Min and max functions for extlen, agblock, fileoff, and filblks types.

-- 
