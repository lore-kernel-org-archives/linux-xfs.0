Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 May 2007 00:07:03 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.186])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4V76xWt012221
	for <xfs@oss.sgi.com>; Thu, 31 May 2007 00:07:00 -0700
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch 3/3] Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in compat mode
Date: Thu, 31 May 2007 09:06:49 +0200
References: <20070530125954.706423971@suse.cz> <20070530143044.060544510@suse.cz>
In-Reply-To: <20070530143044.060544510@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705310906.50434.arnd@arndb.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michal Marek <mmarek@suse.cz>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Wednesday 30 May 2007, Michal Marek wrote:
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
> @@ -109,35 +109,249 @@ STATIC unsigned long xfs_ioctl32_geom_v1
>  	return (unsigned long)p;
>  }
>  
> -#else
> +typedef struct xfs_inogrp32 {
> +	__u64		xi_startino;	/* starting inode number	*/
> +	__s32		xi_alloccount;	/* # bits set in allocmask	*/
> +	__u64		xi_allocmask;	/* mask of allocated inodes	*/
> +} __attribute__((packed)) xfs_inogrp32_t;

__attribute__((packed)) isn't entirely correct here. You don't really
want to have the whole structure to have byte alignment, you only
want to reduce the alignment o fthe 64 bit members to 32 bit.

It would be more appropriate to define a separate type

#if defined(__x86_64__) || defined(__ia64__)
typedef unsigned long long __compat_u64 __attribute__((aligned(4)));
#else
typedef unsigned long long __compat_u64;
#endif

and use that in the data structures.

> +STATIC int xfs_inogrp_store_compat(
> +	xfs_inogrp32_t __user  *p32,
> +	xfs_inogrp_t __user *p)
> +{
> +#define copy(memb) copy_in_user(&p32->memb, &p->memb, sizeof(p32->memb))
> +	if (copy(xi_startino) ||
> +	    copy(xi_alloccount) ||
> +	    copy(xi_allocmask))
> +		return -EFAULT;
> +	return 0;
> +#undef copy
> +}

Your copy() operation looks really dangerous, it will break as soon as someone
tries to use it on a member that is actually variable length, like a pointer.
A better way would be

#define move_user(p32, p64, memb) ({ \
	typeof(p32->memb) data; \
	get_user(data, &p64->memb) || \
	put_user(data, &p32->memb); \
})

Actually, even better would be not to use the compat_alloc_userspace trick
at all, but to just interpret the 32 bit data structure directly in the
implementation instead of converting it to the 64 bit structure, whereever
that's possible.

	Arnd <><
