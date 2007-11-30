Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Nov 2007 01:39:10 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAU9d2NH017791
	for <xfs@oss.sgi.com>; Fri, 30 Nov 2007 01:39:05 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id lAU9d9F3003050
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 30 Nov 2007 10:39:09 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id lAU9d9XZ003048
	for xfs@oss.sgi.com; Fri, 30 Nov 2007 10:39:09 +0100
Date: Fri, 30 Nov 2007 10:39:09 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] dmapi: kill last 2.4 compat leftovers
Message-ID: <20071130093909.GB2949@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/dmapi/dmapi_register.c
===================================================================
--- linux-2.6-xfs.orig/fs/dmapi/dmapi_register.c	2007-09-29 11:49:22.000000000 +0200
+++ linux-2.6-xfs/fs/dmapi/dmapi_register.c	2007-09-29 11:49:39.000000000 +0200
@@ -34,10 +34,8 @@
 #include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/module.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 #include <linux/mount.h>
 #include <linux/namei.h>
-#endif
 #include <asm/uaccess.h>
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -1520,33 +1518,6 @@ dm_getall_disp(
 	return(error);
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-#define d_alloc_anon	dmapi_alloc_anon
-static struct dentry *
-d_alloc_anon(struct inode *inode)
-{
-	struct dentry *dentry;
-
-	spin_lock(&dcache_lock);
-	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
-		if (!(dentry->d_flags & DCACHE_NFSD_DISCONNECTED))
-			goto found;
-	}
-	spin_unlock(&dcache_lock);
-
-	dentry = d_alloc_root(inode);
-	if (likely(dentry != NULL))
-		dentry->d_flags |= DCACHE_NFSD_DISCONNECTED;
-	return dentry;
- found:
-	dget_locked(dentry);
-	dentry->d_vfs_flags |= DCACHE_REFERENCED;
-	spin_unlock(&dcache_lock);
-	iput(inode);
-	return dentry;
-}
-#endif
-
 int
 dm_open_by_handle_rvp(
 	unsigned int	fd,
Index: linux-2.6-xfs/fs/dmapi/dmapi_sysent.c
===================================================================
--- linux-2.6-xfs.orig/fs/dmapi/dmapi_sysent.c	2007-09-29 11:49:42.000000000 +0200
+++ linux-2.6-xfs/fs/dmapi/dmapi_sysent.c	2007-09-29 11:49:57.000000000 +0200
@@ -706,14 +706,6 @@ dmapi_init_procfs(int dmapi_minor)
 	entry = create_proc_read_entry( DMAPI_DBG_PROCFS "/summary",
 			0, NULL, dmapi_summary, NULL);
 	entry->owner = THIS_MODULE;
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-	entry = proc_mknod( DMAPI_PROCFS, S_IFCHR | S_IRUSR | S_IWUSR,
-			   NULL, mk_kdev(MISC_MAJOR,dmapi_minor));
-	if( entry == NULL )
-		return;
-	entry->owner = THIS_MODULE;
-#endif
 #endif
 }
 
@@ -722,9 +714,6 @@ static void __exit
 dmapi_cleanup_procfs(void)
 {
 #ifdef CONFIG_PROC_FS
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-	remove_proc_entry( DMAPI_PROCFS, NULL);
-#endif
 	remove_proc_entry( DMAPI_DBG_PROCFS "/summary", NULL);
 	remove_proc_entry( DMAPI_DBG_PROCFS "/fsreg", NULL);
 	remove_proc_entry( DMAPI_DBG_PROCFS "/sessions", NULL);
