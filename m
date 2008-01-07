Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jan 2008 19:37:02 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m073avsO012555
	for <xfs@oss.sgi.com>; Sun, 6 Jan 2008 19:36:58 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95A414ED9AE
	for <xfs@oss.sgi.com>; Sun,  6 Jan 2008 19:37:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Y0dnVMm7uQpxSBTH for <xfs@oss.sgi.com>; Sun, 06 Jan 2008 19:37:13 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 58F3E18003F13
	for <xfs@oss.sgi.com>; Sun,  6 Jan 2008 21:36:40 -0600 (CST)
Message-ID: <47819E47.4030906@sandeen.net>
Date: Sun, 06 Jan 2008 21:36:39 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove CONFIG_XFS_SECURITY
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Is there any point to this option?  Sure, it disables the ability
to set security attributes at runtime, but it doesn't slim down 
any code.

Any reason to not remove it, and always allow security attributes
to be set?

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

---

Index: linux-2.6.24-rc3/fs/xfs/Kconfig
===================================================================
--- linux-2.6.24-rc3.orig/fs/xfs/Kconfig
+++ linux-2.6.24-rc3/fs/xfs/Kconfig
@@ -35,18 +35,6 @@ config XFS_QUOTA
 	  with or without the generic quota support enabled (CONFIG_QUOTA) -
 	  they are completely independent subsystems.
 
-config XFS_SECURITY
-	bool "XFS Security Label support"
-	depends on XFS_FS
-	help
-	  Security labels support alternative access control models
-	  implemented by security modules like SELinux.  This option
-	  enables an extended attribute namespace for inode security
-	  labels in the XFS filesystem.
-
-	  If you are not using a security module that requires using
-	  extended attributes for inode security labels, say N.
-
 config XFS_POSIX_ACL
 	bool "XFS POSIX ACL support"
 	depends on XFS_FS
Index: linux-2.6.24-rc3/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- linux-2.6.24-rc3.orig/fs/xfs/linux-2.6/xfs_super.h
+++ linux-2.6.24-rc3/fs/xfs/linux-2.6/xfs_super.h
@@ -50,13 +50,8 @@ extern void xfs_qm_exit(void);
 # define set_posix_acl_flag(sb)	do { } while (0)
 #endif
 
-#ifdef CONFIG_XFS_SECURITY
-# define XFS_SECURITY_STRING	"security attributes, "
-# define ENOSECURITY		0
-#else
-# define XFS_SECURITY_STRING
-# define ENOSECURITY		EOPNOTSUPP
-#endif
+/* Used to be "configurable" so keep it around. */
+#define XFS_SECURITY_STRING	"security attributes, "
 
 #ifdef CONFIG_XFS_RT
 # define XFS_REALTIME_STRING	"realtime, "
Index: linux-2.6.24-rc3/fs/xfs/xfs_attr.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/xfs/xfs_attr.c
+++ linux-2.6.24-rc3/fs/xfs/xfs_attr.c
@@ -2651,7 +2651,7 @@ attr_secure_capable(
 	bhv_vnode_t	*vp,
 	cred_t		*cred)
 {
-	return -ENOSECURITY;
+	return 0;
 }
 
 STATIC int
