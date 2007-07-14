Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jul 2007 09:09:13 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6EG98bm017621
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 09:09:10 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6EG9BNK008700
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 18:09:11 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6EG9Bbh008698
	for xfs@oss.sgi.com; Sat, 14 Jul 2007 18:09:11 +0200
Date: Sat, 14 Jul 2007 18:09:11 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix constness warning in dmapi
Message-ID: <20070714160910.GE7768@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

File operations are const now so make sure the dmapi code propagates
this properly.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/dmapi/dmapi_kern.h
===================================================================
--- linux-2.6-xfs.orig/fs/dmapi/dmapi_kern.h	2007-07-14 16:08:31.000000000 +0200
+++ linux-2.6-xfs/fs/dmapi/dmapi_kern.h	2007-07-14 16:08:41.000000000 +0200
@@ -79,7 +79,7 @@ struct filesystem_dmapi_operations {
 	int (*get_fsys_vector)(struct super_block *sb, void *addr);
 	int (*fh_to_inode)(struct super_block *sb, struct inode **ip,
 			   dm_fid_t *fid);
-	struct file_operations * (*get_invis_ops)(struct inode *ip);
+	const struct file_operations * (*get_invis_ops)(struct inode *ip);
 	int (*inode_to_fh)(struct inode *ip, dm_fid_t *fid,
 			   dm_fsid_t *fsid );
 	void (*get_fsid)(struct super_block *sb, dm_fsid_t *fsid);
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm_fsops.c	2007-07-14 16:07:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c	2007-07-14 16:07:55.000000000 +0200
@@ -49,7 +49,7 @@
 #include "xfs_dm.h"
 
 
-STATIC struct file_operations *
+STATIC const struct file_operations *
 xfs_dm_get_invis_ops(
 	struct inode *ip)
 {
