Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 16:12:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7NNCq4p008900
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 16:12:54 -0700
Date: Fri, 24 Aug 2007 09:12:40 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 4/17] kill the v_flag member in struct bhv_vnode
Message-ID: <20070823231237.GY72985246@sgi.com>
References: <20070823193807.GE8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823193807.GE8050@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Aug 23, 2007 at 09:38:07PM +0200, Christoph Hellwig wrote:
> 
> All flags previous handled at the vnode level are not in the xfs_inode
> where we already have a flags mechanisms and free bits for flags
> previously in the vnode.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
....
> Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-08-13 18:00:49.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-08-13 18:00:51.000000000 +0200
....
> @@ -1536,7 +1538,13 @@ xfs_release(
>  		 * significantly reducing the time window where we'd otherwise
>  		 * be exposed to that problem.
>  		 */
> -		if (VUNTRUNCATE(vp) && VN_DIRTY(vp) && ip->i_delayed_blks > 0)
> +		spin_lock(&ip->i_flags_lock);
> +		truncated = __xfs_iflags_test(ip, XFS_ITRUNCATED);
> +		if (truncated)
> +			ip->i_flags &= ~XFS_ITRUNCATED;
> +		spin_unlock(&ip->i_flags_lock);
> +
> +		if (truncated && VN_DIRTY(vp) && ip->i_delayed_blks > 0)
>  			xfs_flush_pages(ip, 0, -1, XFS_B_ASYNC, FI_NONE);
>  	}

This is kind of icky - doing an open coded flag clear instead of wrapping
it in a xfs_iflags_test_and_clear() type operation. Something like:

static inline int
xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned short flags)
{
	int	ret;

	spin_lock(&ip->i_flags_lock);
	ret = ip->i_flags & flags;
	if (ret)
		ip->i_flags &= ~flags;
	spin_unlock(&ip->i_flags_lock);
	return ret;
}

And then the code can become:

	if (xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED) &&
	    VN_DIRTY(vp) && ip->i_delayed_blks > 0))
		xfs_flush_pages(ip, 0, -1, XFS_B_ASYNC, FI_NONE);

FWIW, for changes to this series I think incremental patches would
probably be the easiest way to handle it.

Cheers,

Dave.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
