Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D92B27CBC
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 08:53:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8BDEF30404E
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 06:53:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9T9jLOjN2bGQZ3qU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jul 2016 06:53:23 -0700 (PDT)
From: Benjamin Coddington <bcodding@redhat.com>
Subject: [PATCH v2] xfs: abstract block export operations from nfsd layouts
Date: Fri,  8 Jul 2016 09:53:20 -0400
Message-Id: <6c1549ee874431c8293cad72c5f7382095277822.1467985684.git.bcodding@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org
Cc: bfields@fieldses.org, Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>

Instead of creeping pnfs layout configuration into filesystems, move the
definition of block-based export operations under a more abstract
configuration.

Changes from v1:
	- dropped the first patch in the first posting
	- renamed the config to EXPORTFS_BLOCK_OPS from BLOCK_EXPORT_OPS
	- add an explicit default to no for EXPORTFS_BLOCK_OPS
	- add some help and menu text

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
---
 fs/Kconfig          | 7 +++++++
 fs/nfsd/Kconfig     | 2 ++
 fs/xfs/Makefile     | 3 +--
 fs/xfs/xfs_export.c | 2 +-
 fs/xfs/xfs_pnfs.h   | 4 ++--
 5 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 6725f59c18e6..ac6d3b36600c 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -66,6 +66,13 @@ config FS_POSIX_ACL
 config EXPORTFS
 	tristate
 
+config EXPORTFS_BLOCK_OPS
+	bool "Enable filesystem export operations for block IO"
+	default n
+	help
+	  This option enables the export operations for a filesystem to support
+	  external block IO.
+
 config FILE_LOCKING
 	bool "Enable POSIX file locking API" if EXPERT
 	default y
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index c9f583d7bac8..00b9c5eaecec 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -90,6 +90,7 @@ config NFSD_BLOCKLAYOUT
 	bool "NFSv4.1 server support for pNFS block layouts"
 	depends on NFSD_V4 && BLOCK
 	select NFSD_PNFS
+	select EXPORTFS_BLOCK_OPS
 	help
 	  This option enables support for the exporting pNFS block layouts
 	  in the kernel's NFS server. The pNFS block layout enables NFS
@@ -102,6 +103,7 @@ config NFSD_SCSILAYOUT
 	bool "NFSv4.1 server support for pNFS SCSI layouts"
 	depends on NFSD_V4 && BLOCK
 	select NFSD_PNFS
+	select EXPORTFS_BLOCK_OPS
 	help
 	  This option enables support for the exporting pNFS SCSI layouts
 	  in the kernel's NFS server. The pNFS SCSI layout enables NFS
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 3542d94fddce..52c288514be1 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -121,5 +121,4 @@ xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
 xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
-xfs-$(CONFIG_NFSD_BLOCKLAYOUT)	+= xfs_pnfs.o
-xfs-$(CONFIG_NFSD_SCSILAYOUT)	+= xfs_pnfs.o
+xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index a1b2dd828b9d..fe1bfee35898 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -246,7 +246,7 @@ const struct export_operations xfs_export_operations = {
 	.fh_to_parent		= xfs_fs_fh_to_parent,
 	.get_parent		= xfs_fs_get_parent,
 	.commit_metadata	= xfs_fs_nfs_commit_metadata,
-#ifdef CONFIG_NFSD_BLOCKLAYOUT
+#ifdef CONFIG_EXPORTFS_BLOCK_OPS
 	.get_uuid		= xfs_fs_get_uuid,
 	.map_blocks		= xfs_fs_map_blocks,
 	.commit_blocks		= xfs_fs_commit_blocks,
diff --git a/fs/xfs/xfs_pnfs.h b/fs/xfs/xfs_pnfs.h
index 93f74853961b..e8339f74966b 100644
--- a/fs/xfs/xfs_pnfs.h
+++ b/fs/xfs/xfs_pnfs.h
@@ -1,7 +1,7 @@
 #ifndef _XFS_PNFS_H
 #define _XFS_PNFS_H 1
 
-#if defined(CONFIG_NFSD_BLOCKLAYOUT) || defined(CONFIG_NFSD_SCSILAYOUT)
+#ifdef CONFIG_EXPORTFS_BLOCK_OPS
 int xfs_fs_get_uuid(struct super_block *sb, u8 *buf, u32 *len, u64 *offset);
 int xfs_fs_map_blocks(struct inode *inode, loff_t offset, u64 length,
 		struct iomap *iomap, bool write, u32 *device_generation);
@@ -15,5 +15,5 @@ xfs_break_layouts(struct inode *inode, uint *iolock, bool with_imutex)
 {
 	return 0;
 }
-#endif /* CONFIG_NFSD_PNFS */
+#endif /* CONFIG_EXPORTFS_BLOCK_OPS */
 #endif /* _XFS_PNFS_H */
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
