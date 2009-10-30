Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9U8tEaV172455 for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 03:55:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49FD5C8B450
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 01:55:25 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PcUVnIG6JCeSA2Ox for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2009 01:55:25 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1N3nGX-0000tT-1b
	for xfs@oss.sgi.com; Fri, 30 Oct 2009 08:55:25 +0000
Date: Fri, 30 Oct 2009 04:55:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix mmap_sem vs iolock lock order inversion in
	xfs_free_eofblocks
Message-ID: <20091030085524.GB30825@infradead.org>
References: <20091019040346.GB21115@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091019040346.GB21115@infradead.org>
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
To: xfs@oss.sgi.com

ping?

On Mon, Oct 19, 2009 at 12:03:46AM -0400, Christoph Hellwig wrote:
> When xfs_free_eofblocks is called from ->release the VM might already
> hold the mmap_sem, but in the write path we take the iolock before
> taking the mmap_sem in the generic write code.
> 
> Switch xfs_free_eofblocks to only trylock the iolock if called from ->release
> and skip trimming the prellocated blocks in that case.  We'll still free
> them later on the final iput.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_rw.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_rw.h	2009-10-14 17:30:02.396028076 +0200
> +++ xfs/fs/xfs/xfs_rw.h	2009-10-14 17:30:20.472287472 +0200
> @@ -37,13 +37,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_
>  }
>  
>  /*
> - * Flags for xfs_free_eofblocks
> - */
> -#define XFS_FREE_EOF_LOCK	(1<<0)
> -#define XFS_FREE_EOF_NOLOCK	(1<<1)
> -
> -
> -/*
>   * helper function to extract extent size hint from inode
>   */
>  STATIC_INLINE xfs_extlen_t
> Index: xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-10-14 17:30:13.363024201 +0200
> +++ xfs/fs/xfs/xfs_vnodeops.c	2009-10-14 17:35:39.314256388 +0200
> @@ -709,6 +709,11 @@ xfs_fsync(
>  }
>  
>  /*
> + * Flags for xfs_free_eofblocks
> + */
> +#define XFS_FREE_EOF_TRYLOCK	(1<<0)
> +
> +/*
>   * This is called by xfs_inactive to free any blocks beyond eof
>   * when the link count isn't zero and by xfs_dm_punch_hole() when
>   * punching a hole to EOF.
> @@ -726,7 +731,6 @@ xfs_free_eofblocks(
>  	xfs_filblks_t	map_len;
>  	int		nimaps;
>  	xfs_bmbt_irec_t	imap;
> -	int		use_iolock = (flags & XFS_FREE_EOF_LOCK);
>  
>  	/*
>  	 * Figure out if there are any blocks beyond the end
> @@ -768,14 +772,19 @@ xfs_free_eofblocks(
>  		 * cache and we can't
>  		 * do that within a transaction.
>  		 */
> -		if (use_iolock)
> +		if (flags & XFS_FREE_EOF_TRYLOCK) {
> +			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> +				xfs_trans_cancel(tp, 0);
> +				return 0;
> +			}
> +		} else {
>  			xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +		}
>  		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
>  				    ip->i_size);
>  		if (error) {
>  			xfs_trans_cancel(tp, 0);
> -			if (use_iolock)
> -				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  			return error;
>  		}
>  
> @@ -812,8 +821,7 @@ xfs_free_eofblocks(
>  			error = xfs_trans_commit(tp,
>  						XFS_TRANS_RELEASE_LOG_RES);
>  		}
> -		xfs_iunlock(ip, (use_iolock ? (XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL)
> -					    : XFS_ILOCK_EXCL));
> +		xfs_iunlock(ip, XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL);
>  	}
>  	return error;
>  }
> @@ -1113,7 +1121,17 @@ xfs_release(
>  		     (ip->i_df.if_flags & XFS_IFEXTENTS))  &&
>  		    (!(ip->i_d.di_flags &
>  				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
> -			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
> +
> +			/*
> +			 * If we can't get the iolock just skip truncating
> +			 * the blocks past EOF because we could deadlock
> +			 * with the mmap_sem otherwise.  We'll get another
> +			 * chance to drop them once the last reference to
> +			 * the inode is dropped, so we'll never leak blocks
> +			 * permanently.
> +			 */
> +			error = xfs_free_eofblocks(mp, ip,
> +						   XFS_FREE_EOF_TRYLOCK);
>  			if (error)
>  				return error;
>  		}
> @@ -1184,7 +1202,7 @@ xfs_inactive(
>  		     (!(ip->i_d.di_flags &
>  				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) ||
>  		      (ip->i_delayed_blks != 0)))) {
> -			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
> +			error = xfs_free_eofblocks(mp, ip, 0);
>  			if (error)
>  				return VN_INACTIVE_CACHE;
>  		}
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
