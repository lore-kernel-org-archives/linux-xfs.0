Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Oct 2008 05:25:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9ICPcOl013974
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 05:25:39 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 136C9AC0F3A
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 05:27:22 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id vFpX1GL3cFwJSFOp for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 05:27:22 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m9ICRKIF025079
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 14:27:20 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m9ICRKAN025077
	for xfs@oss.sgi.com; Sat, 18 Oct 2008 14:27:20 +0200
Date: Sat, 18 Oct 2008 14:27:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] allow 64 bit inode numbers on 32 bit systems
Message-ID: <20081018122720.GA24949@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Now that we've stopped using the Linux inode cache when can trivally
support the inode64 mount option on 32bit architectures.  As far as the
kernel and most userspace is concerned this works perfectly, but
applications still using really old stat and readdir interfaces will get
an EOVERFLOW error when hitting an inode number not fitting into 32
bits (that problem of course also exists when using these applications
on a 64bit kernel).

Note that because inode64 is simply a mount option we can currently
mount a filesystem having > 32 bit inode numbers and cause a variety of
problems, all this is solved but this patch which enables XFS_BIG_INUMS,
even when inode64 is not used.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-2.6/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- xfs-2.6.orig/fs/xfs/linux-2.6/xfs_linux.h	2008-10-18 12:17:40.000000000 +0200
+++ xfs-2.6/fs/xfs/linux-2.6/xfs_linux.h	2008-10-18 12:19:30.000000000 +0200
@@ -21,18 +21,12 @@
 #include <linux/types.h>
 
 /*
- * Some types are conditional depending on the target system.
  * XFS_BIG_BLKNOS needs block layer disk addresses to be 64 bits.
- * XFS_BIG_INUMS needs the VFS inode number to be 64 bits, as well
- * as requiring XFS_BIG_BLKNOS to be set.
+ * XFS_BIG_INUMS requires XFS_BIG_BLKNOS to be set.
  */
 #if defined(CONFIG_LBD) || (BITS_PER_LONG == 64)
 # define XFS_BIG_BLKNOS	1
-# if BITS_PER_LONG == 64
-#  define XFS_BIG_INUMS	1
-# else
-#  define XFS_BIG_INUMS	0
-# endif
+# define XFS_BIG_INUMS	1
 #else
 # define XFS_BIG_BLKNOS	0
 # define XFS_BIG_INUMS	0
