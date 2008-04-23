Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Apr 2008 17:58:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3N0vpAq000462
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 17:57:52 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A3BDA9A746
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 17:58:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id XKkZkvpDDaUR3LlL for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 17:58:31 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 9830618003F13
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 19:58:30 -0500 (CDT)
Message-ID: <480E89B5.8070006@sandeen.net>
Date: Tue, 22 Apr 2008 19:58:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net>
In-Reply-To: <47DB4181.7040603@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> This should fix the longstanding issues with xfs and old ABI
> arm boxes, which lead to various asserts and xfs shutdowns,
> and for which an (incorrect) patch has been floating around
> for years.  (Said patch made ARM internally consistent, but
> altered the normal xfs on-disk format such that it looked
> corrupted on other architectures):
> http://lists.arm.linux.org.uk/lurker/message/20040311.002034.5ecf21a2.html

ping again...

There is still the cache flushing issue, I guess, but I think the
on-disk alignment is still worth fixing.

Oh, I'm sorry Jeff - I meant "fixing."  :)

Thanks,
-Eric

> Old ABI ARM has interesting packing & padding; for example
> on ARM old abi:
> 
> struct xfs_dir2_sf_entry {
> 	__uint8_t                  namelen;      /*     0     1 */
> 
> 	/* XXX 3 bytes hole, try to pack */
> 
> 	xfs_dir2_sf_off_t          offset;       /*     4     4 */
> 	__uint8_t                  name[1];      /*     8     1 */
> 
> 	/* XXX 3 bytes hole, try to pack */
> 
> 	xfs_dir2_inou_t            inumber;      /*    12     8 */
> 
> 	/* size: 20, cachelines: 1 */
> 	/* sum members: 14, holes: 2, sum holes: 6 */
> 	/* last cacheline: 20 bytes */
> };
> 
> but on x86:
> 
> struct xfs_dir2_sf_entry {
> 	__uint8_t                  namelen;      /*     0     1 */
> 	xfs_dir2_sf_off_t          offset;       /*     1     2 */
> 	__uint8_t                  name[1];      /*     3     1 */
> 	xfs_dir2_inou_t            inumber;      /*     4     8 */
> 
> 	/* size: 12, cachelines: 1 */
> 	/* last cacheline: 12 bytes */
> };
> 
> ... this sort of discrepancy leads to problems.
> 
> I've verified this patch by comparing the on-disk structure 
> layouts using pahole from the dwarves package, as well as 
> running through a bit of xfsqa under qemu-arm, modified so 
> that the check/repair phase after each test actually executes 
> check/repair from the x86 host, on the filesystem populated 
> by the arm emulator.  Thus far it all looks good.
> 
> There are 2 other structures with extra padding at the end, 
> but they don't seem to cause trouble.  I suppose they could 
> be packed as well: xfs_dir2_data_unused_t and xfs_dir2_sf_t.
> 
> Note that userspace needs a similar treatment, and any
> filesystems which were running with the previous rogue
> "fix" will now see corruption (either in the kernel, or
> during xfs_repair) with this fix properly in place; it 
> may be worth teaching xfs_repair to identify and fix that 
> specific issue.
> 
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
> 
> 
> 
