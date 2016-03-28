Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 726317CA0
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 05:47:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DCFA9AC004
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 03:46:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oJSOpFjXIJ2kCePD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2016 03:46:58 -0700 (PDT)
Date: Mon, 28 Mar 2016 06:46:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: improve kmem_realloc
Message-ID: <20160328104655.GB27040@bfoster.bfoster>
References: <1458740836-31211-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458740836-31211-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Mar 23, 2016 at 02:47:16PM +0100, Christoph Hellwig wrote:
> Use krealloc to implement our realloc function.  This helps to avoid
> new allocations if we are still in the slab bucket.  At least for the
> bmap btree root that's actually the common case.
> 
> This also allows removing the now unused oldsize argument.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/kmem.c                  | 26 +++++++++++++++-----------
>  fs/xfs/kmem.h                  |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c | 10 +++-------
>  fs/xfs/xfs_log_recover.c       |  2 +-
>  fs/xfs/xfs_mount.c             |  1 -
>  5 files changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index 686ba6f..339c696 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -93,19 +93,23 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
>  }
>  
>  void *
> -kmem_realloc(const void *ptr, size_t newsize, size_t oldsize,
> -	     xfs_km_flags_t flags)
> +kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
>  {
> -	void	*new;
> +	int	retries = 0;
> +	gfp_t	lflags = kmem_flags_convert(flags);
> +	void	*ptr;
>  
> -	new = kmem_alloc(newsize, flags);
> -	if (ptr) {
> -		if (new)
> -			memcpy(new, ptr,
> -				((oldsize < newsize) ? oldsize : newsize));
> -		kmem_free(ptr);
> -	}
> -	return new;
> +	do {
> +		ptr = krealloc(old, newsize, lflags);
> +		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> +			return ptr;
> +		if (!(++retries % 100))
> +			xfs_err(NULL,
> +	"%s(%u) possible memory allocation deadlock size %zu in %s (mode:0x%x)",
> +				current->comm, current->pid,
> +				newsize, __func__, lflags);
> +		congestion_wait(BLK_RW_ASYNC, HZ/50);
> +	} while (1);
>  }
>  
>  void *
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index d1c66e4..689f746 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -62,7 +62,7 @@ kmem_flags_convert(xfs_km_flags_t flags)
>  
>  extern void *kmem_alloc(size_t, xfs_km_flags_t);
>  extern void *kmem_zalloc_large(size_t size, xfs_km_flags_t);
> -extern void *kmem_realloc(const void *, size_t, size_t, xfs_km_flags_t);
> +extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
>  static inline void  kmem_free(const void *ptr)
>  {
>  	kvfree(ptr);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 4fbe226..d3d1477 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -542,7 +542,6 @@ xfs_iroot_realloc(
>  		new_max = cur_max + rec_diff;
>  		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
>  		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
> -				XFS_BMAP_BROOT_SPACE_CALC(mp, cur_max),
>  				KM_SLEEP | KM_NOFS);
>  		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
>  						     ifp->if_broot_bytes);
> @@ -686,7 +685,6 @@ xfs_idata_realloc(
>  				ifp->if_u1.if_data =
>  					kmem_realloc(ifp->if_u1.if_data,
>  							real_size,
> -							ifp->if_real_bytes,
>  							KM_SLEEP | KM_NOFS);
>  			}
>  		} else {
> @@ -1402,8 +1400,7 @@ xfs_iext_realloc_direct(
>  		if (rnew_size != ifp->if_real_bytes) {
>  			ifp->if_u1.if_extents =
>  				kmem_realloc(ifp->if_u1.if_extents,
> -						rnew_size,
> -						ifp->if_real_bytes, KM_NOFS);
> +						rnew_size, KM_NOFS);
>  		}
>  		if (rnew_size > ifp->if_real_bytes) {
>  			memset(&ifp->if_u1.if_extents[ifp->if_bytes /
> @@ -1487,9 +1484,8 @@ xfs_iext_realloc_indirect(
>  	if (new_size == 0) {
>  		xfs_iext_destroy(ifp);
>  	} else {
> -		ifp->if_u1.if_ext_irec = (xfs_ext_irec_t *)
> -			kmem_realloc(ifp->if_u1.if_ext_irec,
> -				new_size, size, KM_NOFS);
> +		ifp->if_u1.if_ext_irec =
> +			kmem_realloc(ifp->if_u1.if_ext_irec, new_size, KM_NOFS);
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 396565f..bf6e807 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3843,7 +3843,7 @@ xlog_recover_add_to_cont_trans(
>  	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
>  	old_len = item->ri_buf[item->ri_cnt-1].i_len;
>  
> -	ptr = kmem_realloc(old_ptr, len+old_len, old_len, KM_SLEEP);
> +	ptr = kmem_realloc(old_ptr, len + old_len, KM_SLEEP);
>  	memcpy(&ptr[old_len], dp, len);
>  	item->ri_buf[item->ri_cnt-1].i_len += len;
>  	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 536a0ee..654799f 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -89,7 +89,6 @@ xfs_uuid_mount(
>  	if (hole < 0) {
>  		xfs_uuid_table = kmem_realloc(xfs_uuid_table,
>  			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
> -			xfs_uuid_table_size  * sizeof(*xfs_uuid_table),
>  			KM_SLEEP);
>  		hole = xfs_uuid_table_size++;
>  	}
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
