Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 16:42:45 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1K0gber028569
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 16:42:42 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 626A45F575D
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 16:43:02 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id e7s5JDBZ1buoB2c9 for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 16:43:02 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 6BEC918005BE1
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 18:42:29 -0600 (CST)
Message-ID: <47BB7774.5080401@sandeen.net>
Date: Tue, 19 Feb 2008 18:42:28 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] remove CONFIG_XFS_SECURITY
References: <47819E47.4030906@sandeen.net>
In-Reply-To: <47819E47.4030906@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Is there any point to this option?  Sure, it disables the ability
> to set security attributes at runtime, but it doesn't slim down 
> any code.
> 
> Any reason to not remove it, and always allow security attributes
> to be set?

Ack? Nak?  Comments?

-Eric

> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> ---
> 
> Index: linux-2.6.24-rc3/fs/xfs/Kconfig
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/xfs/Kconfig
> +++ linux-2.6.24-rc3/fs/xfs/Kconfig
> @@ -35,18 +35,6 @@ config XFS_QUOTA
>  	  with or without the generic quota support enabled (CONFIG_QUOTA) -
>  	  they are completely independent subsystems.
>  
> -config XFS_SECURITY
> -	bool "XFS Security Label support"
> -	depends on XFS_FS
> -	help
> -	  Security labels support alternative access control models
> -	  implemented by security modules like SELinux.  This option
> -	  enables an extended attribute namespace for inode security
> -	  labels in the XFS filesystem.
> -
> -	  If you are not using a security module that requires using
> -	  extended attributes for inode security labels, say N.
> -
>  config XFS_POSIX_ACL
>  	bool "XFS POSIX ACL support"
>  	depends on XFS_FS
> Index: linux-2.6.24-rc3/fs/xfs/linux-2.6/xfs_super.h
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/xfs/linux-2.6/xfs_super.h
> +++ linux-2.6.24-rc3/fs/xfs/linux-2.6/xfs_super.h
> @@ -50,13 +50,8 @@ extern void xfs_qm_exit(void);
>  # define set_posix_acl_flag(sb)	do { } while (0)
>  #endif
>  
> -#ifdef CONFIG_XFS_SECURITY
> -# define XFS_SECURITY_STRING	"security attributes, "
> -# define ENOSECURITY		0
> -#else
> -# define XFS_SECURITY_STRING
> -# define ENOSECURITY		EOPNOTSUPP
> -#endif
> +/* Used to be "configurable" so keep it around. */
> +#define XFS_SECURITY_STRING	"security attributes, "
>  
>  #ifdef CONFIG_XFS_RT
>  # define XFS_REALTIME_STRING	"realtime, "
> Index: linux-2.6.24-rc3/fs/xfs/xfs_attr.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/xfs/xfs_attr.c
> +++ linux-2.6.24-rc3/fs/xfs/xfs_attr.c
> @@ -2651,7 +2651,7 @@ attr_secure_capable(
>  	bhv_vnode_t	*vp,
>  	cred_t		*cred)
>  {
> -	return -ENOSECURITY;
> +	return 0;
>  }
>  
>  STATIC int
> 
> 
