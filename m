Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Apr 2008 19:23:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m372NQ7O019989
	for <xfs@oss.sgi.com>; Sun, 6 Apr 2008 19:23:29 -0700
Message-ID: <47F985BA.7060100@sgi.com>
Date: Mon, 07 Apr 2008 12:23:54 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] remove CONFIG_XFS_SECURITY
References: <47819E47.4030906@sandeen.net> <47BB7774.5080401@sandeen.net>
In-Reply-To: <47BB7774.5080401@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Eric Sandeen wrote:
>> Is there any point to this option?  Sure, it disables the ability
>> to set security attributes at runtime, but it doesn't slim down 
>> any code.
>>
>> Any reason to not remove it, and always allow security attributes
>> to be set?
> 
> Ack? Nak?  Comments?
> 
Fine by me. I'm not sure of the point either.
However, don't need to modify the attr_secure_capable function,
might as well delete it and
just use fs_noerr for the capable hook field.

--Tim

(BTW, will check in attr2 fixes soon - need to write a qa test ;-)


> -Eric
> 
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>>
>> ---
>>
>> Index: linux-2.6.24-rc3/fs/xfs/Kconfig
>> ===================================================================
>> --- linux-2.6.24-rc3.orig/fs/xfs/Kconfig
>> +++ linux-2.6.24-rc3/fs/xfs/Kconfig
>> @@ -35,18 +35,6 @@ config XFS_QUOTA
>>  	  with or without the generic quota support enabled (CONFIG_QUOTA) -
>>  	  they are completely independent subsystems.
>>  
>> -config XFS_SECURITY
>> -	bool "XFS Security Label support"
>> -	depends on XFS_FS
>> -	help
>> -	  Security labels support alternative access control models
>> -	  implemented by security modules like SELinux.  This option
>> -	  enables an extended attribute namespace for inode security
>> -	  labels in the XFS filesystem.
>> -
>> -	  If you are not using a security module that requires using
>> -	  extended attributes for inode security labels, say N.
>> -
>>  config XFS_POSIX_ACL
>>  	bool "XFS POSIX ACL support"
>>  	depends on XFS_FS
>> Index: linux-2.6.24-rc3/fs/xfs/linux-2.6/xfs_super.h
>> ===================================================================
>> --- linux-2.6.24-rc3.orig/fs/xfs/linux-2.6/xfs_super.h
>> +++ linux-2.6.24-rc3/fs/xfs/linux-2.6/xfs_super.h
>> @@ -50,13 +50,8 @@ extern void xfs_qm_exit(void);
>>  # define set_posix_acl_flag(sb)	do { } while (0)
>>  #endif
>>  
>> -#ifdef CONFIG_XFS_SECURITY
>> -# define XFS_SECURITY_STRING	"security attributes, "
>> -# define ENOSECURITY		0
>> -#else
>> -# define XFS_SECURITY_STRING
>> -# define ENOSECURITY		EOPNOTSUPP
>> -#endif
>> +/* Used to be "configurable" so keep it around. */
>> +#define XFS_SECURITY_STRING	"security attributes, "
>>  
>>  #ifdef CONFIG_XFS_RT
>>  # define XFS_REALTIME_STRING	"realtime, "
>> Index: linux-2.6.24-rc3/fs/xfs/xfs_attr.c
>> ===================================================================
>> --- linux-2.6.24-rc3.orig/fs/xfs/xfs_attr.c
>> +++ linux-2.6.24-rc3/fs/xfs/xfs_attr.c
>> @@ -2651,7 +2651,7 @@ attr_secure_capable(
>>  	bhv_vnode_t	*vp,
>>  	cred_t		*cred)
>>  {
>> -	return -ENOSECURITY;
>> +	return 0;
>>  }
>>  
>>  STATIC int
>>
>>
> 
