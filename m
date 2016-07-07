Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1CA9E7D09
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 06:02:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F183C8F80F9
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 04:02:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aZxB0MLBKjFcU3UJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Jul 2016 04:02:35 -0700 (PDT)
From: Benjamin Coddington <bcodding@redhat.com>
Subject: [PATCH 2/2] xfs: abstract block export operations from nfsd layouts
Date: Thu,  7 Jul 2016 07:02:32 -0400
Message-Id: <073be10a55e5e952adbfd320abcce075fb3958ae.1467889001.git.bcodding@redhat.com>
In-Reply-To: <5ff05b585226b689866f4604adddffc94910f63f.1467889001.git.bcodding@redhat.com>
References: <5ff05b585226b689866f4604adddffc94910f63f.1467889001.git.bcodding@redhat.com>
In-Reply-To: <5ff05b585226b689866f4604adddffc94910f63f.1467889001.git.bcodding@redhat.com>
References: <5ff05b585226b689866f4604adddffc94910f63f.1467889001.git.bcodding@redhat.com>
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

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
---
 fs/Kconfig          | 3 +++
 fs/nfsd/Kconfig     | 2 ++
 fs/xfs/Makefile     | 3 +--
 fs/xfs/xfs_export.c | 2 +-
 fs/xfs/xfs_pnfs.h   | 4 ++--
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 6725f59c18e6..6e57b4237d72 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -66,6 +66,9 @@ config FS_POSIX_ACL
 config EXPORTFS
 	tristate
 
+config BLOCK_EXPORT_OPS
+	bool
+
 config FILE_LOCKING
 	bool "Enable POSIX file locking API" if EXPERT
 	default y
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index c9f583d7bac8..fb63f93cd5f1 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -90,6 +90,7 @@ config NFSD_BLOCKLAYOUT
 	bool "NFSv4.1 server support for pNFS block layouts"
 	depends on NFSD_V4 && BLOCK
 	select NFSD_PNFS
+	select BLOCK_EXPORT_OPS
 	help
 	  This option enables support for the exporting pNFS block layouts
 	  in the kernel's NFS server. The pNFS block layout enables NFS
@@ -102,6 +103,7 @@ config NFSD_SCSILAYOUT
 	bool "NFSv4.1 server support for pNFS SCSI layouts"
 	depends on NFSD_V4 && BLOCK
 	select NFSD_PNFS
+	select BLOCK_EXPORT_OPS
 	help
 	  This option enables support for the exporting pNFS SCSI layouts
 	  in the kernel's NFS server. The pNFS SCSI layout enables NFS
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 3542d94fddce..9c9f039e2f05 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -121,5 +121,4 @@ xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
 xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
-xfs-$(CONFIG_NFSD_BLOCKLAYOUT)	+= xfs_pnfs.o
-xfs-$(CONFIG_NFSD_SCSILAYOUT)	+= xfs_pnfs.o
+xfs-$(CONFIG_BLOCK_EXPORT_OPS)	+= xfs_pnfs.o
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index b08a5541f292..7b1896ef9112 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -246,7 +246,7 @@ const struct export_operations xfs_export_operations = {
 	.fh_to_parent		= xfs_fs_fh_to_parent,
 	.get_parent		= xfs_fs_get_parent,
 	.commit_metadata	= xfs_fs_nfs_commit_metadata,
-#if defined(CONFIG_NFSD_BLOCKLAYOUT) || defined(CONFIG_NFSD_SCSILAYOUT)
+#ifdef CONFIG_BLOCK_EXPORT_OPS
 	.get_uuid		= xfs_fs_get_uuid,
 	.map_blocks		= xfs_fs_map_blocks,
 	.commit_blocks		= xfs_fs_commit_blocks,
diff --git a/fs/xfs/xfs_pnfs.h b/fs/xfs/xfs_pnfs.h
index 93f74853961b..1073f08cd668 100644
--- a/fs/xfs/xfs_pnfs.h
+++ b/fs/xfs/xfs_pnfs.h
@@ -1,7 +1,7 @@
 #ifndef _XFS_PNFS_H
 #define _XFS_PNFS_H 1
 
-#if defined(CONFIG_NFSD_BLOCKLAYOUT) || defined(CONFIG_NFSD_SCSILAYOUT)
+#ifdef CONFIG_BLOCK_EXPORT_OPS
 int xfs_fs_get_uuid(struct super_block *sb, u8 *buf, u32 *len, u64 *offset);
 int xfs_fs_map_blocks(struct inode *inode, loff_t offset, u64 length,
 		struct iomap *iomap, bool write, u32 *device_generation);
@@ -15,5 +15,5 @@ xfs_break_layouts(struct inode *inode, uint *iolock, bool with_imutex)
 {
 	return 0;
 }
-#endif /* CONFIG_NFSD_PNFS */
+#endif /* CONFIG_BLOCK_EXPORT_OPS */
 #endif /* _XFS_PNFS_H */
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
