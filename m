Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 12:29:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6TJSxhu031191
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:28:59 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36E48ECE214
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:10 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id BC6eN14C856bunCq for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:10 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6TJUCIF019165
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:30:12 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6TJUCen019163
	for xfs@oss.sgi.com; Tue, 29 Jul 2008 21:30:12 +0200
Date: Tue, 29 Jul 2008 21:30:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/21] add generic btree types
Message-ID: <20080729193012.GC19104@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-add-generic-types
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Add generic union types for btree pointers, keys and records.  The generic
btree pointer contains a 32 and 64bit big endian type for short and long
form btrees, and the key and record contain the relevant type for each
possible btree.

Split out from a bigger patch from Dave Chinner and simplified a little
further.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-14 17:26:11.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-14 17:27:59.000000000 +0200
@@ -70,6 +70,12 @@ typedef struct xfs_btree_hdr
 	__be16		bb_numrecs;	/* current # of data records */
 } xfs_btree_hdr_t;
 
+/*
+ * Generic block, key, ptr and record wrapper structures
+ * These are disk format structures, and are converted where
+ * necessary be the btree specific code that needs to interpret
+ * them.
+ */
 typedef struct xfs_btree_block {
 	xfs_btree_hdr_t	bb_h;		/* header */
 	union {
@@ -84,6 +90,25 @@ typedef struct xfs_btree_block {
 	} bb_u;				/* rest */
 } xfs_btree_block_t;
 
+union xfs_btree_ptr {
+	__be32			s;	/* short form ptr */
+	__be64			l;	/* long form ptr */
+};
+
+union xfs_btree_key {
+	xfs_bmbt_key_t		bmbt;
+	xfs_bmdr_key_t		bmbr;	/* bmbt root block */
+	xfs_alloc_key_t		alloc;
+	xfs_inobt_key_t		inobt;
+};
+
+union xfs_btree_rec {
+	xfs_bmbt_rec_t		bmbt;
+	xfs_bmdr_rec_t		bmbr;	/* bmbt root block */
+	xfs_alloc_rec_t		alloc;
+	xfs_inobt_rec_t		inobt;
+};
+
 /*
  * For logging record fields.
  */

-- 
