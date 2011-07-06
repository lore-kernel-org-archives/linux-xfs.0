Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p663iRhk064052 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 22:44:27 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4EBA1BF6C30
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 20:44:24 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iA5e0wwhCl84z1kr for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 20:44:24 -0700 (PDT)
Date: Wed, 6 Jul 2011 13:44:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 22/27] xfs: use generic get_unaligned_beXX helpers
Message-ID: <20110706034421.GQ1026@dastard>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094606.763430916@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701094606.763430916@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Jul 01, 2011 at 05:43:43AM -0400, Christoph Hellwig wrote:
> Switch the shortform directory code over to use the generic
> get_unaligned_beXX helpers instead of reinventing them.  As a result
> kill off xfs_arch.h and move the setting of XFS_NATIVE_HOST into
> xfs_linux.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> -/*
> - * In directories inode numbers are stored as unaligned arrays of unsigned
> - * 8bit integers on disk.
> - *
> - * For v1 directories or v2 directories that contain inode numbers that
> - * do not fit into 32bit the array has eight members, but the first member
> - * is always zero:
> - *
> - *  |unused|48-55|40-47|32-39|24-31|16-23| 8-15| 0- 7|

Well, I learnt something today.

So we only support 56 bit inode numbers in shortform directories?
AFAIK, Nothing else in the code enforces this limitation. I
just found XFS_MAXINUMBER to define the maximum inode
number to be 56 bits in size, but, well, it's not used anywhere
relevant (like when initialising AGs)......

Hmmmm. I wonder if it is a hold-over from the days of 4GB AGs?
That would have meant inode numbers used 6 bits for the chunk index,
2^22 - 2^6 for the agbno and 2^32 for the agno, which gives 54 bits
maximum inode number and so XFS_MAXINUMBER @ 56 bits makes sense, as
does the zero high byte in the dir2 inode number.

Now we have 2^30 bits for the agbno+chunk index, and 32 bits for the
agno, so inode numbers can reach 62 bits, which is outside the range
of the 56-bit MAXINUMBER limit.

So my questions are now this:
	- is there any other reason for a 56 bit inode number limit?
	- why isn't it enforced for the rest of the directory code?
	- did we lose that checking when we converted the rest of
	  the directory code to use the generic byte swapping
	  functions?
	- do we need to increase XFS_MAXINUMBER to reflect the
	  current reality of 1TB AGs and simply ignore the zero high
	  byte restriction?

As it is, we need to update AG initialisation to disallow inode
allocation in AGs above the XFS_MAXINUMBER if we don't allow them in
the directory structure....


> +++ xfs/fs/xfs/xfs_dir2_sf.c	2011-06-30 20:46:45.366236141 +0200
> @@ -59,11 +59,12 @@ static void xfs_dir2_sf_toino4(xfs_da_ar
>  static void xfs_dir2_sf_toino8(xfs_da_args_t *args);
>  #endif /* XFS_BIG_INUMS */
>  
> -
>  /*
>   * Inode numbers in short-form directories can come in two versions,
>   * either 4 bytes or 8 bytes wide.  These helpers deal with the
>   * two forms transparently by looking at the headers i8count field.
> + *
> + * For 64-bit inode number the most significant byte must be zero.

This comment is what lead me one that path....

>   */
>  static xfs_ino_t
>  xfs_dir2_sf_get_ino(
> @@ -71,9 +72,9 @@ xfs_dir2_sf_get_ino(
>  	xfs_dir2_inou_t		*from)
>  {
>  	if (hdr->i8count)
> -		return XFS_GET_DIR_INO8(from->i8);
> +		return get_unaligned_be64(&from->i8.i) & 0x00ffffffffffffffULL;
>  	else
> -		return XFS_GET_DIR_INO4(from->i4);
> +		return get_unaligned_be32(&from->i4.i);
>  }
>  
>  static void
> @@ -82,10 +83,12 @@ xfs_dir2_sf_put_ino(
>  	xfs_dir2_inou_t		*to,
>  	xfs_ino_t		ino)
>  {
> +	ASSERT((ino & 0xff00000000000000ULL) == 0);
> +
>  	if (hdr->i8count)
> -		XFS_PUT_DIR_INO8(ino, to->i8);
> +		put_unaligned_be64(ino, &to->i8.i);
>  	else
> -		XFS_PUT_DIR_INO4(ino, to->i4);
> +		put_unaligned_be32(ino, &to->i4.i);
>  }
>  
>  xfs_ino_t
> Index: xfs/fs/xfs/xfs_dir2_sf.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dir2_sf.h	2011-06-30 20:24:08.732919663 +0200
> +++ xfs/fs/xfs/xfs_dir2_sf.h	2011-06-30 20:38:37.019575543 +0200
> @@ -95,13 +95,13 @@ static inline int xfs_dir2_sf_hdr_size(i
>  static inline xfs_dir2_data_aoff_t
>  xfs_dir2_sf_get_offset(xfs_dir2_sf_entry_t *sfep)
>  {
> -	return INT_GET_UNALIGNED_16_BE(&(sfep)->offset.i);
> +	return get_unaligned_be16(&sfep->offset.i);
>  }
>  
>  static inline void
>  xfs_dir2_sf_put_offset(xfs_dir2_sf_entry_t *sfep, xfs_dir2_data_aoff_t off)
>  {
> -	INT_SET_UNALIGNED_16_BE(&(sfep)->offset.i, off);
> +	put_unaligned_be16(off, &sfep->offset.i);
>  }
>  
>  static inline int

As a straight translation this patch is fine, but I think I'd like
to resolve some of the questions it raises first before anything
else....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
