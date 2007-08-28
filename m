Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Aug 2007 13:21:10 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7SKL24p019431
	for <xfs@oss.sgi.com>; Tue, 28 Aug 2007 13:21:07 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7SKL2A5017367
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 28 Aug 2007 22:21:02 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7SKL2pn017365
	for xfs@oss.sgi.com; Tue, 28 Aug 2007 22:21:02 +0200
Date: Tue, 28 Aug 2007 22:21:02 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs_dmapi: add MODULE_ tags
Message-ID: <20070828202102.GB17289@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Without these I get a warning about an unspecified license everytime
I try to load xfs_dmapi.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-08-25 00:05:33.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-08-25 00:05:53.000000000 +0200
@@ -3372,5 +3372,9 @@ xfs_dm_exit(void)
 	dmapi_unregister(&xfs_fs_type);
 }
 
+MODULE_AUTHOR("Silicon Graphics, Inc.");
+MODULE_DESCRIPTION("SGI XFS dmapi subsystem");
+MODULE_LICENSE("GPL");
+
 module_init(xfs_dm_init);
 module_exit(xfs_dm_exit);
