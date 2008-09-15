Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 18:01:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8F11qVg026818
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:01:52 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FBCD129B01F
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:03:22 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Lb7fyxt5Vn2cS616 for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 18:03:22 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8F13MIF013206
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 03:03:23 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8F13MqR013204
	for xfs@oss.sgi.com; Mon, 15 Sep 2008 03:03:22 +0200
Date: Mon, 15 Sep 2008 03:03:22 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] Add a mount feature bit for CRC enabled filesystems
Message-ID: <20080915010322.GD13062@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-crc-bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Signed-off-by: Dave Chinner <dgc@sgi.com>

Index: linux-2.6-xfs/fs/xfs/Kconfig
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/Kconfig	2008-09-11 18:26:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/Kconfig	2008-09-11 18:33:07.000000000 +0200
@@ -1,6 +1,6 @@
 config XFS_FS
 	tristate "XFS filesystem support"
-	depends on BLOCK
+	depends on BLOCK && LIBCRC32C
 	help
 	  XFS is a high performance journaling filesystem which originated
 	  on the SGI IRIX platform.  It is completely multi-threaded, can
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2008-09-11 18:26:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h	2008-09-11 18:33:07.000000000 +0200
@@ -77,6 +77,7 @@
 #include <linux/spinlock.h>
 #include <linux/random.h>
 #include <linux/ctype.h>
+#include <linux/crc32c.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
Index: linux-2.6-xfs/fs/xfs/xfs_sb.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_sb.h	2008-09-11 18:33:06.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_sb.h	2008-09-14 17:33:27.000000000 +0200
@@ -79,10 +79,12 @@ struct xfs_mount;
 #define XFS_SB_VERSION2_LAZYSBCOUNTBIT	0x00000002	/* Superblk counters */
 #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
+#define XFS_SB_VERSION2_CRCBIT		0x00000020	/* metadata has CRCs */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
-	 XFS_SB_VERSION2_ATTR2BIT)
+	 XFS_SB_VERSION2_ATTR2BIT | \
+	 XFS_SB_VERSION2_CRCBIT)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
 #define XFS_SB_VERSION2_OKREALBITS	\
@@ -494,6 +496,12 @@ static inline void xfs_sb_version_remove
 		sbp->sb_versionnum &= ~XFS_SB_VERSION_MOREBITSBIT;
 }
 
+static inline int xfs_sb_version_hascrc(xfs_sb_t *sbp)
+{
+	return (xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_CRCBIT));
+}
+
 /*
  * end of superblock version macros
  */

-- 
