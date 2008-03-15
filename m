Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Mar 2008 21:17:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2F4H7Rx019187
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:17:12 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80126FA593A
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:17:38 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id C8Txwlb5I8sYpUAw for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:17:38 -0700 (PDT)
Date: Sat, 15 Mar 2008 00:17:22 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
Message-ID: <20080315041722.GA25621@josefsipek.net>
References: <47DB4181.7040603@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DB4181.7040603@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>, patches@arm.linux.org.uk

On Fri, Mar 14, 2008 at 10:24:49PM -0500, Eric Sandeen wrote:
> This should fix the longstanding issues with xfs and old ABI
> arm boxes, which lead to various asserts and xfs shutdowns,
> and for which an (incorrect) patch has been floating around
> for years.  (Said patch made ARM internally consistent, but
> altered the normal xfs on-disk format such that it looked
> corrupted on other architectures):
> http://lists.arm.linux.org.uk/lurker/message/20040311.002034.5ecf21a2.html
...
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> ---
> 
> Index: linux-2.6.24/fs/xfs/linux-2.6/xfs_linux.h
> ===================================================================
> --- linux-2.6.24.orig/fs/xfs/linux-2.6/xfs_linux.h
> +++ linux-2.6.24/fs/xfs/linux-2.6/xfs_linux.h
> @@ -300,4 +300,11 @@ static inline __uint64_t howmany_64(__ui
>  	return x;
>  }
>  
> +/* ARM old ABI has some weird alignment/padding */
> +#if defined(__arm__) && !defined(__ARM_EABI__)
> +#define __arch_pack __attribute__((packed))
> +#else
> +#define __arch_pack
> +#endif

Shouldn't this be unconditional? Just because it ends up being ok on x86
doesn't mean that it won't break some time later on...(do we want another
bad_features2 incident?)

> +
>  #endif /* __XFS_LINUX__ */
> Index: linux-2.6.24/fs/xfs/xfs_dir2_sf.h
> ===================================================================
> --- linux-2.6.24.orig/fs/xfs/xfs_dir2_sf.h
> +++ linux-2.6.24/fs/xfs/xfs_dir2_sf.h
> @@ -62,7 +62,7 @@ typedef union {
>   * Normalized offset (in a data block) of the entry, really xfs_dir2_data_off_t.
>   * Only need 16 bits, this is the byte offset into the single block form.
>   */
> -typedef struct { __uint8_t i[2]; } xfs_dir2_sf_off_t;
> +typedef struct { __uint8_t i[2]; } __arch_pack xfs_dir2_sf_off_t;
>  
>  /*
>   * The parent directory has a dedicated field, and the self-pointer must
> @@ -76,14 +76,14 @@ typedef struct xfs_dir2_sf_hdr {
>  	__uint8_t		count;		/* count of entries */
>  	__uint8_t		i8count;	/* count of 8-byte inode #s */
>  	xfs_dir2_inou_t		parent;		/* parent dir inode number */
> -} xfs_dir2_sf_hdr_t;
> +} __arch_pack xfs_dir2_sf_hdr_t;
>  
>  typedef struct xfs_dir2_sf_entry {
>  	__uint8_t		namelen;	/* actual name length */
>  	xfs_dir2_sf_off_t	offset;		/* saved offset */
>  	__uint8_t		name[1];	/* name, variable size */
>  	xfs_dir2_inou_t		inumber;	/* inode number, var. offset */
> -} xfs_dir2_sf_entry_t;
> +} __arch_pack xfs_dir2_sf_entry_t; 
>  
>  typedef struct xfs_dir2_sf {
>  	xfs_dir2_sf_hdr_t	hdr;		/* shortform header */

A very simple patch! I like it (minus the condition vs. unconditional
packing - see above).

Josef 'Jeff' Sipek.

-- 
Penguin : Linux version 2.6.23.1 on an i386 machine (6135.23 BogoMips).
