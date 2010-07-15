Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6FIdGls217971 for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 13:39:16 -0500
Subject: Re: [PATCH 5/5] xfs: fix memory reclaim recursion deadlock on
	locked inode buffer
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1279154300-2018-6-git-send-email-david@fromorbit.com>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
	<1279154300-2018-6-git-send-email-david@fromorbit.com>
Date: Thu, 15 Jul 2010 13:42:13 -0500
Message-ID: <1279219333.2054.64.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Thu, 2010-07-15 at 10:38 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Calling into memory reclaim with a locked inode buffer can deadlock
> if memory reclaim tries to lock the inode buffer during inode
> teardown. Convert the relevant memory allocations to use KM_NOFS to
> avoid this deadlock condition.

Looks good.  I wasn't able to find the paths that
led to xfs_iroot_realloc() and xfs_idata_realloc()
but I'm sure they're there...

Reviewed-by: Alex Elder <aelder@sgi.com>

> Reported-by: Peter Watkins <treestem@gmail.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c |   20 +++++++++++---------
>  1 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5715a9d..3c206b3 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -422,7 +422,7 @@ xfs_iformat(
>  	if (!XFS_DFORK_Q(dip))
>  		return 0;
>  	ASSERT(ip->i_afp == NULL);
> -	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
> +	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP|KM_NOFS);
>  	ip->i_afp->if_ext_max =
>  		XFS_IFORK_ASIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
>  	switch (dip->di_aformat) {
> @@ -505,7 +505,7 @@ xfs_iformat_local(
>  		ifp->if_u1.if_data = ifp->if_u2.if_inline_data;
>  	else {
>  		real_size = roundup(size, 4);
> -		ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP);
> +		ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP|KM_NOFS);
>  	}
>  	ifp->if_bytes = size;
>  	ifp->if_real_bytes = real_size;
> @@ -632,7 +632,7 @@ xfs_iformat_btree(
>  	}
>  
>  	ifp->if_broot_bytes = size;
> -	ifp->if_broot = kmem_alloc(size, KM_SLEEP);
> +	ifp->if_broot = kmem_alloc(size, KM_SLEEP|KM_NOFS);
>  	ASSERT(ifp->if_broot != NULL);
>  	/*
>  	 * Copy and convert from the on-disk structure
> @@ -2191,7 +2191,7 @@ xfs_iroot_realloc(
>  		 */
>  		if (ifp->if_broot_bytes == 0) {
>  			new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(rec_diff);
> -			ifp->if_broot = kmem_alloc(new_size, KM_SLEEP);
> +			ifp->if_broot = kmem_alloc(new_size, KM_SLEEP|KM_NOFS);
>  			ifp->if_broot_bytes = (int)new_size;
>  			return;
>  		}
> @@ -2207,7 +2207,7 @@ xfs_iroot_realloc(
>  		new_size = (size_t)XFS_BMAP_BROOT_SPACE_CALC(new_max);
>  		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
>  				(size_t)XFS_BMAP_BROOT_SPACE_CALC(cur_max), /* old size */
> -				KM_SLEEP);
> +				KM_SLEEP|KM_NOFS);
>  		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
>  						     ifp->if_broot_bytes);
>  		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
> @@ -2233,7 +2233,7 @@ xfs_iroot_realloc(
>  	else
>  		new_size = 0;
>  	if (new_size > 0) {
> -		new_broot = kmem_alloc(new_size, KM_SLEEP);
> +		new_broot = kmem_alloc(new_size, KM_SLEEP|KM_NOFS);
>  		/*
>  		 * First copy over the btree block header.
>  		 */
> @@ -2337,7 +2337,8 @@ xfs_idata_realloc(
>  		real_size = roundup(new_size, 4);
>  		if (ifp->if_u1.if_data == NULL) {
>  			ASSERT(ifp->if_real_bytes == 0);
> -			ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP);
> +			ifp->if_u1.if_data = kmem_alloc(real_size,
> +							KM_SLEEP|KM_NOFS);
>  		} else if (ifp->if_u1.if_data != ifp->if_u2.if_inline_data) {
>  			/*
>  			 * Only do the realloc if the underlying size
> @@ -2348,11 +2349,12 @@ xfs_idata_realloc(
>  					kmem_realloc(ifp->if_u1.if_data,
>  							real_size,
>  							ifp->if_real_bytes,
> -							KM_SLEEP);
> +							KM_SLEEP|KM_NOFS);
>  			}
>  		} else {
>  			ASSERT(ifp->if_real_bytes == 0);
> -			ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP);
> +			ifp->if_u1.if_data = kmem_alloc(real_size,
> +							KM_SLEEP|KM_NOFS);
>  			memcpy(ifp->if_u1.if_data, ifp->if_u2.if_inline_data,
>  				ifp->if_bytes);
>  		}



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
