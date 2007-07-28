Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 28 Jul 2007 10:54:23 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6SHsIbm019611
	for <xfs@oss.sgi.com>; Sat, 28 Jul 2007 10:54:19 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6SHsLA5006437
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 28 Jul 2007 19:54:21 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6SHsL9P006435
	for xfs@oss.sgi.com; Sat, 28 Jul 2007 19:54:21 +0200
Date: Sat, 28 Jul 2007 19:54:21 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] add missing xfs_filestreams_trace_buf export
Message-ID: <20070728175421.GA6365@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

add an export of xfs_filestreams_trace_buf for debug builds because
xfsidbg wants to access it.

This prevent sucessfully building an xfs module when debug was enabled
because modpost has gotten quite picky.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-07-28 18:45:16.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-07-28 18:48:50.000000000 +0200
@@ -63,6 +63,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_utils.h"
 #include "xfs_iomap.h"
+#include "xfs_filestream.h"
 #include "support/ktrace.h"
 
 
@@ -106,6 +107,9 @@ EXPORT_SYMBOL(xfs_attr_trace_buf);
 #ifdef XFS_DIR2_TRACE
 EXPORT_SYMBOL(xfs_dir2_trace_buf);
 #endif
+#ifdef XFS_FILESTREAMS_TRACE
+EXPORT_SYMBOL(xfs_filestreams_trace_buf);
+#endif
 
 #ifdef XFS_BUF_TRACE
 extern ktrace_t *xfs_buf_trace_buf;
