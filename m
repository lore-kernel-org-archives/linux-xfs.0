Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Sep 2008 11:38:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m84Ic9ie007059
	for <xfs@oss.sgi.com>; Thu, 4 Sep 2008 11:38:10 -0700
Date: Thu, 4 Sep 2008 14:39:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: Improve caching in libxfs
Message-ID: <20080904183935.GA25890@infradead.org>
References: <op.ugv7ekj83jf8g2@pc-bnaujok.melbourne.sgi.com> <20080903234758.GA18368@infradead.org> <op.ugxz4lb63jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ugxz4lb63jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Looks much better, thanks.

On Thu, Sep 04, 2008 at 03:56:35PM +1000, Barry Naujok wrote:
> Index: xfs-cmds/xfsprogs/include/cache.h
> ===================================================================
> --- xfs-cmds.orig/xfsprogs/include/cache.h
> +++ xfs-cmds/xfsprogs/include/cache.h
> @@ -20,6 +20,17 @@
>
>  #define	HASH_CACHE_RATIO	8
>
> +/*
> + * Cache priorities range from BASE to MAX.
> + *
> + * For prefetch support, the top half of the range starts at
> + * CACHE_PREFETCH_PRIORITY and everytime the buffer is fetched
> + * and is at or above this priority level, it is reduced to
> + * below this level (refer to libxfs_getbuf).
> + */
> +
> +#define CACHE_BASE_PRIORITY	0
> +#define CACHE_PREFETCH_PRIORITY	8
>  #define CACHE_MAX_PRIORITY	15
>
>  /*
> Index: xfs-cmds/xfsprogs/libxfs/rdwr.c
> ===================================================================
> --- xfs-cmds.orig/xfsprogs/libxfs/rdwr.c
> +++ xfs-cmds/xfsprogs/libxfs/rdwr.c
> @@ -393,7 +393,8 @@ libxfs_getbuf(dev_t device, xfs_daddr_t
>  		if (use_xfs_buf_lock)
>  			pthread_mutex_lock(&bp->b_lock);
>  		cache_node_set_priority(libxfs_bcache, (struct cache_node *)bp,
> -			cache_node_get_priority((struct cache_node *)bp) - 4);
> +			cache_node_get_priority((struct cache_node *)bp) -
> +						CACHE_PREFETCH_PRIORITY);
>  #ifdef XFS_BUF_TRACING
>  		pthread_mutex_lock(&libxfs_bcache->c_mutex);
>  		lock_buf_count++;
> Index: xfs-cmds/xfsprogs/repair/prefetch.c
> ===================================================================
> --- xfs-cmds.orig/xfsprogs/repair/prefetch.c
> +++ xfs-cmds/xfsprogs/repair/prefetch.c
> @@ -35,19 +35,36 @@ static int		pf_batch_fsbs;
>
>  static void		pf_read_inode_dirs(prefetch_args_t *, xfs_buf_t *);
>
> -/* buffer priorities for the libxfs cache */
> +/*
> + * Buffer priorities for the libxfs cache
> + *
> + * Directory metadata is ranked higher than other metadata as it's used
> + * in phases 3, 4 and 6, while other metadata is only used in 3 & 4.
> + */
>
> -#define B_DIR_BMAP	15
> -#define B_DIR_META_2	13	/* metadata in secondary queue */
> -#define B_DIR_META_H	11	/* metadata fetched for PF_META_ONLY */
> -#define B_DIR_META_S	9	/* single block of metadata */
> -#define B_DIR_META	7
> -#define B_DIR_INODE	6
> -#define B_BMAP		5
> -#define B_INODE		4
> +/* intermediate directory btree nodes - can't be queued */
> +#define B_DIR_BMAP	CACHE_PREFETCH_PRIORITY + 7
> +/* directory metadata in secondary queue */
> +#define B_DIR_META_2	CACHE_PREFETCH_PRIORITY + 6
> +/* dir metadata that had to fetched from the primary queue to avoid  
> stalling */
> +#define B_DIR_META_H	CACHE_PREFETCH_PRIORITY + 5
> +/* single block of directory metadata (can't batch read) */
> +#define B_DIR_META_S	CACHE_PREFETCH_PRIORITY + 4
> +/* dir metadata with more than one block fetched in a single I/O */
> +#define B_DIR_META	CACHE_PREFETCH_PRIORITY + 3
> +/* inode clusters with directory inodes */
> +#define B_DIR_INODE	CACHE_PREFETCH_PRIORITY + 2
> +/* intermediate extent btree nodes */
> +#define B_BMAP		CACHE_PREFETCH_PRIORITY + 1
> +/* inode clusters without any directory entries */
> +#define B_INODE		CACHE_PREFETCH_PRIORITY
>
> -#define B_IS_INODE(b)	(((b) & 1) == 0)
> -#define B_IS_META(b)	(((b) & 1) != 0)
> +/*
> + * Test if bit 0 or 2 is set in the "priority tag" of the buffer to see if
> + * the buffer is for an inode or other metadata.
> + */
> +#define B_IS_INODE(f)	(((f) & 5) == 0)
> +#define B_IS_META(f)	(((f) & 5) != 0)
>
>  #define DEF_BATCH_BYTES	0x10000
>
---end quoted text---
