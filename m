Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Jun 2008 07:15:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m56EF0cU004339
	for <xfs@oss.sgi.com>; Fri, 6 Jun 2008 07:15:00 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1F96C38D5A
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2008 07:15:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 8p5BrqQpSJFIIQZE for <xfs@oss.sgi.com>; Fri, 06 Jun 2008 07:15:54 -0700 (PDT)
Message-ID: <48494698.9080704@sandeen.net>
Date: Fri, 06 Jun 2008 09:15:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <47E1D3C3.1050000@sandeen.net>
In-Reply-To: <47E1D3C3.1050000@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: Barry Naujok <bnaujok@sgi.com>

Eric Sandeen wrote:
> Here's the userspace side.
> 

Just a reminder after Dave's reminder.  :)

-Eric

> -Eric
> 
> 
> Index: xfs-cmds/xfsprogs/include/platform_defs.h.in
> ===================================================================
> --- xfs-cmds.orig/xfsprogs/include/platform_defs.h.in
> +++ xfs-cmds/xfsprogs/include/platform_defs.h.in
> @@ -147,4 +147,11 @@ typedef unsigned long long __psunsigned_
>  					| (minor&IRIX_DEV_MAXMIN)))
>  #define IRIX_DEV_TO_KDEVT(dev)	makedev(IRIX_DEV_MAJOR(dev),IRIX_DEV_MINOR(dev))
>  
> +/* ARM old ABI has some weird alignment/padding */
> +#if defined(__arm__) && !defined(__ARM_EABI__)
> +#define __arch_pack __attribute__((packed))
> +#else
> +#define __arch_pack
> +#endif
> +
>  #endif	/* __XFS_PLATFORM_DEFS_H__ */
> Index: xfs-cmds/xfsprogs/include/xfs_dir2_sf.h
> ===================================================================
> --- xfs-cmds.orig/xfsprogs/include/xfs_dir2_sf.h
> +++ xfs-cmds/xfsprogs/include/xfs_dir2_sf.h
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
> 
> 
> 
> 
> 
