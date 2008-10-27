Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:30:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDUG9D019755
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:30:16 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31047549CC6
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:30:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id Q1d0KiFJcilMoyTR for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:30:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSAh-0007y5-LB
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:30:15 +0000
Date: Mon, 27 Oct 2008 09:30:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] allow inode64 mount option on 32 bit systems
Message-ID: <20081027133015.GC30607@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-allow-inode64-on-32bit
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

(First sent on October 18th)


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

-- 
