Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Nov 2007 01:38:38 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAU9cV0K017691
	for <xfs@oss.sgi.com>; Fri, 30 Nov 2007 01:38:34 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id lAU9caF3002996
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 30 Nov 2007 10:38:37 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id lAU9caaJ002994
	for xfs@oss.sgi.com; Fri, 30 Nov 2007 10:38:36 +0100
Date: Fri, 30 Nov 2007 10:38:36 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: kill last 2.4 ifdef leftover
Message-ID: <20071130093836.GA2949@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs.h	2007-09-29 11:48:48.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs.h	2007-09-29 11:49:03.000000000 +0200
@@ -41,11 +41,6 @@
 #define XFS_FILESTREAMS_TRACE 1
 #endif
 
-#include <linux/version.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 #include <linux-2.6/xfs_linux.h>
-#else
-#include <linux-2.4/xfs_linux.h>
-#endif
 
 #endif	/* __XFS_H__ */
