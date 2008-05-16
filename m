Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 18:28:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4G1RgN7030732
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 18:27:45 -0700
Message-ID: <482CE39F.9050404@sgi.com>
Date: Fri, 16 May 2008 11:30:07 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] xfs_dm_rdwr() needs to pass a vfsmount to dentry_open()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

There's a new check added to dentry_open():

    if (!mnt) {
        printk(KERN_WARNING "%s called with NULL vfsmount\n", __func__);
        dump_stack();
        return ERR_PTR(-EINVAL);
    }

We need to pass a mountpoint in the call to dentry_open() in xfs_dm_rdwr()
to avoid this code.

--- fs/xfs/dmapi/xfs_dm.c_1.72	2008-05-15 13:23:41.000000000 +1000
+++ fs/xfs/dmapi/xfs_dm.c	2008-05-15 17:51:41.000000000 +1000
@@ -52,6 +52,8 @@
 #include <dmapi_kern.h>
 #include "xfs_dm.h"
 
+#include <linux/mount.h>
+
 #define MAXNAMLEN MAXNAMELEN
 
 #define MIN_DIO_SIZE(mp)		((mp)->m_sb.sb_sectsize)
@@ -1121,7 +1123,7 @@ xfs_dm_rdwr(
 		return ENOMEM;
 	}
 
-	file = dentry_open(dentry, NULL, oflags);
+	file = dentry_open(dentry, mntget(ip->i_mount->m_vfsmount), oflags);
 	if (IS_ERR(file)) {
 		return -PTR_ERR(file);
 	}
--- fs/xfs/linux-2.6/xfs_super.c_1.416	2008-05-15 13:23:43.000000000 +1000
+++ fs/xfs/linux-2.6/xfs_super.c	2008-05-15 13:29:49.000000000 +1000
@@ -1397,8 +1397,14 @@ xfs_fs_get_sb(
 	void			*data,
 	struct vfsmount		*mnt)
 {
-	return get_sb_bdev(fs_type, flags, dev_name, data, xfs_fs_fill_super,
+	int	error;
+
+	error = get_sb_bdev(fs_type, flags, dev_name, data, xfs_fs_fill_super,
 			   mnt);
+	if (!error)
+		((struct xfs_mount *)mnt->mnt_sb->s_fs_info)->m_vfsmount = mnt;
+
+	return error;
 }
 
 static struct super_operations xfs_super_operations = {
--- fs/xfs/xfs_mount.h_1.265	2008-05-15 13:23:49.000000000 +1000
+++ fs/xfs/xfs_mount.h	2008-05-15 13:21:50.000000000 +1000
@@ -337,6 +337,7 @@ typedef struct xfs_mount {
 	spinlock_t		m_sync_lock;	/* work item list lock */
 	int			m_sync_seq;	/* sync thread generation no. */
 	wait_queue_head_t	m_wait_single_sync_task;
+	struct vfsmount		*m_vfsmount;
 } xfs_mount_t;
 
 /*
