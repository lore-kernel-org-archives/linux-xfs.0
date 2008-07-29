Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Jul 2008 21:18:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6T4ISu3016741
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 21:18:29 -0700
Date: Tue, 29 Jul 2008 00:19:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW] Update kernel headers to compile in userspace (libxfs)
Message-ID: <20080729041939.GA7232@infradead.org>
References: <op.ue07o7wt3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ue07o7wt3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jul 29, 2008 at 12:25:45PM +1000, Barry Naujok wrote:
> +#ifdef __KERNEL__
>  	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
>
>  	int		pag_ici_init;	/* incore inode cache initialised */
>  	rwlock_t	pag_ici_lock;	/* incore inode lock */
>  	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
> +#endif

I gues this does indeed not make much sense in userspace.

> +#ifdef __KERNEL__
>  extern int xfs_dir2_block_getdents(struct xfs_inode *dp, void *dirent,
>  				   xfs_off_t *offset, filldir_t filldir);
> +#endif

Instead of all these ifdefs in the dir code wouldn't it be better
to just provide a filldir_t in userspace?  getdents into a user
formatted buffers sounds at least like a theoretically useful
functionality for libxfs.

> Index: 2.6.x-xfs/fs/xfs/xfs_inode_item.h
> ===================================================================
> --- 2.6.x-xfs.orig/fs/xfs/xfs_inode_item.h
> +++ 2.6.x-xfs/fs/xfs/xfs_inode_item.h
> @@ -168,6 +168,8 @@ static inline int xfs_ilog_fext(int w)
>  	return (w == XFS_DATA_FORK ? XFS_ILOG_DEXT : XFS_ILOG_AEXT);
>  }
>
> +#ifdef __KERNEL__
> +
>  static inline int xfs_inode_clean(xfs_inode_t *ip)
>  {
>  	return (!ip->i_itemp ||
> @@ -175,9 +177,6 @@ static inline int xfs_inode_clean(xfs_in
>  	       !ip->i_update_core;
>  }
>
> -
> -#ifdef __KERNEL__
> -
>  extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
>  extern void xfs_inode_item_destroy(struct xfs_inode *);
>  extern void xfs_iflush_done(struct xfs_buf *, xfs_inode_log_item_t *);

Makes sense, too.
