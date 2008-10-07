Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:23:47 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97LNgXP028345
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:23:42 -0700
Message-ID: <48EBE1B1.3090605@sgi.com>
Date: Wed, 08 Oct 2008 08:24:49 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] kill xfs_ialloc_log_di
References: <20081007202157.GB16485@lst.de>
In-Reply-To: <20081007202157.GB16485@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com


Can we verify dirty log replay immediately after a kernel update works?
(has there been any log fmt revision or is this just pure cleanup?)

Cheers

Christoph Hellwig wrote:
> xfs_ialloc_log_di alwasy logs the full inode core + di_next_unlinked, so
> there's really no need for all the offset magic and we can just call
> xfs_trans_log_buf directly from it's only user.  Also add a comment
> describing what we should do here instead.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-10-07 19:50:47.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-10-07 19:57:41.000000000 +0200
> @@ -41,68 +41,6 @@
>  #include "xfs_error.h"
>  #include "xfs_bmap.h"
>  
> -/*
> - * Log specified fields for the inode given by bp and off.
> - */
> -STATIC void
> -xfs_ialloc_log_di(
> -	xfs_trans_t	*tp,		/* transaction pointer */
> -	xfs_buf_t	*bp,		/* inode buffer */
> -	int		off,		/* index of inode in buffer */
> -	int		fields)		/* bitmask of fields to log */
> -{
> -	int			first;		/* first byte number */
> -	int			ioffset;	/* off in bytes */
> -	int			last;		/* last byte number */
> -	xfs_mount_t		*mp;		/* mount point structure */
> -	static const short	offsets[] = {	/* field offsets */
> -						/* keep in sync with bits */
> -		offsetof(xfs_dinode_core_t, di_magic),
> -		offsetof(xfs_dinode_core_t, di_mode),
> -		offsetof(xfs_dinode_core_t, di_version),
> -		offsetof(xfs_dinode_core_t, di_format),
> -		offsetof(xfs_dinode_core_t, di_onlink),
> -		offsetof(xfs_dinode_core_t, di_uid),
> -		offsetof(xfs_dinode_core_t, di_gid),
> -		offsetof(xfs_dinode_core_t, di_nlink),
> -		offsetof(xfs_dinode_core_t, di_projid),
> -		offsetof(xfs_dinode_core_t, di_pad),
> -		offsetof(xfs_dinode_core_t, di_atime),
> -		offsetof(xfs_dinode_core_t, di_mtime),
> -		offsetof(xfs_dinode_core_t, di_ctime),
> -		offsetof(xfs_dinode_core_t, di_size),
> -		offsetof(xfs_dinode_core_t, di_nblocks),
> -		offsetof(xfs_dinode_core_t, di_extsize),
> -		offsetof(xfs_dinode_core_t, di_nextents),
> -		offsetof(xfs_dinode_core_t, di_anextents),
> -		offsetof(xfs_dinode_core_t, di_forkoff),
> -		offsetof(xfs_dinode_core_t, di_aformat),
> -		offsetof(xfs_dinode_core_t, di_dmevmask),
> -		offsetof(xfs_dinode_core_t, di_dmstate),
> -		offsetof(xfs_dinode_core_t, di_flags),
> -		offsetof(xfs_dinode_core_t, di_gen),
> -		offsetof(xfs_dinode_t, di_next_unlinked),
> -		offsetof(xfs_dinode_t, di_u),
> -		offsetof(xfs_dinode_t, di_a),
> -		sizeof(xfs_dinode_t)
> -	};
> -
> -
> -	ASSERT(offsetof(xfs_dinode_t, di_core) == 0);
> -	ASSERT((fields & (XFS_DI_U|XFS_DI_A)) == 0);
> -	mp = tp->t_mountp;
> -	/*
> -	 * Get the inode-relative first and last bytes for these fields
> -	 */
> -	xfs_btree_offsets(fields, offsets, XFS_DI_NUM_BITS, &first, &last);
> -	/*
> -	 * Convert to buffer offsets and log it.
> -	 */
> -	ioffset = off << mp->m_sb.sb_inodelog;
> -	first += ioffset;
> -	last += ioffset;
> -	xfs_trans_log_buf(tp, bp, first, last);
> -}
>  
>  /*
>   * Allocation group level functions.
> @@ -406,18 +344,25 @@ xfs_ialloc_ag_alloc(
>  					 XFS_BUF_LOCK);
>  		ASSERT(fbuf);
>  		ASSERT(!XFS_BUF_GETERROR(fbuf));
> +
>  		/*
> -		 * Set initial values for the inodes in this buffer.
> +		 * Initialize all inodes in this buffer and then log them.
> +		 *
> +		 * XXX: It would be much better if we had just one transaction to
> +		 *      log a whole cluster of inodes instead of all the indivdual
> +		 *      transactions causing a lot of log traffic.
>  		 */
>  		xfs_biozero(fbuf, 0, ninodes << args.mp->m_sb.sb_inodelog);
>  		for (i = 0; i < ninodes; i++) {
> +			int	ioffset = i << args.mp->m_sb.sb_inodelog;
> +			uint	isize = sizeof(xfs_dinode_t) + sizeof(__be32);
> +
>  			free = XFS_MAKE_IPTR(args.mp, fbuf, i);
>  			free->di_core.di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
>  			free->di_core.di_version = version;
>  			free->di_core.di_gen = cpu_to_be32(gen);
>  			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
> -			xfs_ialloc_log_di(tp, fbuf, i,
> -				XFS_DI_CORE_BITS | XFS_DI_NEXT_UNLINKED);
> +			xfs_trans_log_buf(tp, fbuf, ioffset, ioffset + isize - 1);
>  		}
>  		xfs_trans_inode_alloc_buf(tp, fbuf);
>  	}
> Index: linux-2.6-xfs/fs/xfs/xfs_dinode.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_dinode.h	2008-10-07 19:51:22.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_dinode.h	2008-10-07 19:56:16.000000000 +0200
> @@ -102,40 +102,6 @@ typedef struct xfs_dinode
>  #define	XFS_MAXLINK_1		65535U
>  
>  /*
> - * Bit names for logging disk inodes only
> - */
> -#define	XFS_DI_MAGIC		0x0000001
> -#define	XFS_DI_MODE		0x0000002
> -#define	XFS_DI_VERSION		0x0000004
> -#define	XFS_DI_FORMAT		0x0000008
> -#define	XFS_DI_ONLINK		0x0000010
> -#define	XFS_DI_UID		0x0000020
> -#define	XFS_DI_GID		0x0000040
> -#define	XFS_DI_NLINK		0x0000080
> -#define	XFS_DI_PROJID		0x0000100
> -#define	XFS_DI_PAD		0x0000200
> -#define	XFS_DI_ATIME		0x0000400
> -#define	XFS_DI_MTIME		0x0000800
> -#define	XFS_DI_CTIME		0x0001000
> -#define	XFS_DI_SIZE		0x0002000
> -#define	XFS_DI_NBLOCKS		0x0004000
> -#define	XFS_DI_EXTSIZE		0x0008000
> -#define	XFS_DI_NEXTENTS		0x0010000
> -#define	XFS_DI_NAEXTENTS	0x0020000
> -#define	XFS_DI_FORKOFF		0x0040000
> -#define	XFS_DI_AFORMAT		0x0080000
> -#define	XFS_DI_DMEVMASK		0x0100000
> -#define	XFS_DI_DMSTATE		0x0200000
> -#define	XFS_DI_FLAGS		0x0400000
> -#define	XFS_DI_GEN		0x0800000
> -#define	XFS_DI_NEXT_UNLINKED	0x1000000
> -#define	XFS_DI_U		0x2000000
> -#define	XFS_DI_A		0x4000000
> -#define	XFS_DI_NUM_BITS		27
> -#define	XFS_DI_ALL_BITS		((1 << XFS_DI_NUM_BITS) - 1)
> -#define	XFS_DI_CORE_BITS	(XFS_DI_ALL_BITS & ~(XFS_DI_U|XFS_DI_A))
> -
> -/*
>   * Values for di_format
>   */
>  typedef enum xfs_dinode_fmt
> 
> 

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
