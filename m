Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 07:39:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3BEdJW2004969
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 07:39:21 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E301780A24
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 07:39:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id fY7J9GR2IGg2vuvo for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 07:39:57 -0700 (PDT)
Message-ID: <47FF781D.2020006@sandeen.net>
Date: Fri, 11 Apr 2008 09:39:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] remove CONFIG_XFS_SECURITY
References: <47819E47.4030906@sandeen.net> <47BB7774.5080401@sandeen.net> <47F985BA.7060100@sgi.com>
In-Reply-To: <47F985BA.7060100@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Timothy Shimmin wrote:

> Eric Sandeen wrote:
>   
>> Eric Sandeen wrote:
>>     
>>> Is there any point to this option?  Sure, it disables the ability
>>> to set security attributes at runtime, but it doesn't slim down 
>>> any code.
>>>
>>> Any reason to not remove it, and always allow security attributes
>>> to be set?
>>>       
>> Ack? Nak?  Comments?
>>
>>     
> Fine by me. I'm not sure of the point either.
> However, don't need to modify the attr_secure_capable function,
> might as well delete it and
> just use fs_noerr for the capable hook field.
>   
Oh, I see, it's normally cast... ok.

-----------------------------

There is no point to the CONFIG_XFS_SECURITY option; it
disables the ability to set security attributes at runtime,
but it does not actually slim down or remove any code for
runtime.  Just remove it and always allow security attributes
to be set.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6-xfs/fs/xfs/Kconfig
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/Kconfig
+++ linux-2.6-xfs/fs/xfs/Kconfig
@@ -48,18 +48,6 @@ config XFS_DMAPI
 
 	  If unsure, say N.
 
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
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.h
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h
@@ -28,13 +28,7 @@
 # define set_posix_acl_flag(sb)	do { } while (0)
 #endif
 
-#ifdef CONFIG_XFS_SECURITY
-# define XFS_SECURITY_STRING	"security attributes, "
-# define ENOSECURITY		0
-#else
-# define XFS_SECURITY_STRING
-# define ENOSECURITY		EOPNOTSUPP
-#endif
+#define XFS_SECURITY_STRING	"security attributes, "
 
 #ifdef CONFIG_XFS_RT
 # define XFS_REALTIME_STRING	"realtime, "
Index: linux-2.6-xfs/fs/xfs/xfs_attr.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr.c
+++ linux-2.6-xfs/fs/xfs/xfs_attr.c
@@ -2647,14 +2647,6 @@ attr_trusted_capable(
 }
 
 STATIC int
-attr_secure_capable(
-	bhv_vnode_t	*vp,
-	cred_t		*cred)
-{
-	return -ENOSECURITY;
-}
-
-STATIC int
 attr_system_set(
 	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
 {
@@ -2724,7 +2716,7 @@ struct attrnames attr_secure = {
 	.attr_get	= attr_generic_get,
 	.attr_set	= attr_generic_set,
 	.attr_remove	= attr_generic_remove,
-	.attr_capable	= attr_secure_capable,
+	.attr_capable	= (attrcapable_t)fs_noerr,
 };
 
 struct attrnames attr_user = {
