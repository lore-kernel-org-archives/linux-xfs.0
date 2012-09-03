Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q834KeFx136448 for <xfs@oss.sgi.com>; Sun, 2 Sep 2012 23:20:40 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8CGCmogqPaNK52gP for <xfs@oss.sgi.com>;
	Sun, 02 Sep 2012 21:21:35 -0700 (PDT)
Date: Mon, 3 Sep 2012 14:20:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 1/4] xfs: add EOFBLOCKS inode tagging/untagging
Message-ID: <20120903042033.GQ15292@dastard>
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
	<1346097111-4476-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1346097111-4476-2-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 27, 2012 at 03:51:48PM -0400, Brian Foster wrote:
> Add the XFS_ICI_EOFBLOCKS_TAG inode tag to identify inodes with
> speculatively preallocated blocks beyond EOF. An inode is tagged
> when speculative preallocation occurs and untagged either via
> truncate down or when post-EOF blocks are freed via release or
> reclaim.
> 
> The tag management is intentionally not aggressive to prefer
> simplicity over the complexity of handling all the corner cases
> under which post-EOF blocks could be freed (i.e., forward
> truncation, fallocate, write error conditions, etc.). This means
> that a tagged inode may or may not have post-EOF blocks after a
> period of time. The tag is eventually cleared when the inode is
> released or reclaimed.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
.....
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 94b32f9..2cd2883 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -305,10 +305,16 @@ xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
>  }
>  
>  static inline void
> +__xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
> +{
> +	ip->i_flags &= ~flags;
> +}
> +
> +static inline void
>  xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
>  {
>  	spin_lock(&ip->i_flags_lock);
> -	ip->i_flags &= ~flags;
> +	__xfs_iflags_clear(ip, flags);
>  	spin_unlock(&ip->i_flags_lock);
>  }

Left overs from a previous version?

>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 973dff6..2968ee8 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -459,6 +459,13 @@ retry:
>  	if (!(imap[0].br_startblock || XFS_IS_REALTIME_INODE(ip)))
>  		return xfs_alert_fsblock_zero(ip, &imap[0]);
>  
> +	/*
> +	 * Tag the inode as speculatively preallocated so we can reclaim this
> +	 * space on demand, if necessary.
> +	 */
> +	if (prealloc)
> +		xfs_inode_set_eofblocks_tag(ip);
> +
>  	*ret_imap = imap[0];
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 4e00cf0..dcd1d5f 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -854,6 +854,9 @@ xfs_setattr_size(
>  		 * and do not wait the usual (long) time for writeout.
>  		 */
>  		xfs_iflags_set(ip, XFS_ITRUNCATED);
> +
> +		/* A truncate down always removes post-EOF blocks. */
> +		xfs_inode_clear_eofblocks_tag(ip);
>  	}
>  
>  	if (mask & ATTR_CTIME) {
> diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
> index 9654817..5e14741 100644
> --- a/fs/xfs/xfs_sync.c
> +++ b/fs/xfs/xfs_sync.c
> @@ -971,3 +971,79 @@ xfs_reclaim_inodes_count(
>  	return reclaimable;
>  }
>  
> +STATIC void
> +__xfs_inode_set_eofblocks_tag(
> +	struct xfs_perag	*pag,
> +	struct xfs_inode	*ip)
> +{
> +	int tagged = radix_tree_tagged(&pag->pag_ici_root,
> +				       XFS_ICI_EOFBLOCKS_TAG);
> +
> +	radix_tree_tag_set(&pag->pag_ici_root,
> +			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
> +			   XFS_ICI_EOFBLOCKS_TAG);
> +
> +	if (!tagged) {
> +		/* propagate the eofblocks tag up into the perag radix tree */
> +		spin_lock(&ip->i_mount->m_perag_lock);
> +		radix_tree_tag_set(&ip->i_mount->m_perag_tree,
> +				   XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
> +				   XFS_ICI_EOFBLOCKS_TAG);
> +		spin_unlock(&ip->i_mount->m_perag_lock);
> +
> +		trace_xfs_perag_set_eofblocks(ip->i_mount, pag->pag_agno,
> +					      -1, _RET_IP_);
> +	}
> +}
> +
> +void
> +xfs_inode_set_eofblocks_tag(
> +	xfs_inode_t	*ip)
> +{
> +	struct xfs_mount *mp = ip->i_mount;
> +	struct xfs_perag *pag;
> +
> +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +	spin_lock(&pag->pag_ici_lock);
> +	trace_xfs_set_eofblocks_tag(ip);
> +	__xfs_inode_set_eofblocks_tag(pag, ip);
> +	spin_unlock(&pag->pag_ici_lock);
> +	xfs_perag_put(pag);
> +}

I know the code you copied had this two-function structure, but that
was because it has callers of the __ versions of the functions. I'd
just make these a single function.

> +
> +STATIC void
> +__xfs_inode_clear_eofblocks(
> +	xfs_perag_t	*pag,
> +	xfs_inode_t	*ip)
> +{
> +	radix_tree_tag_clear(&pag->pag_ici_root,
> +			     XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
> +			     XFS_ICI_EOFBLOCKS_TAG);
> +
> +	if (!radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_EOFBLOCKS_TAG)) {
> +		/* clear the eofblocks tag from the perag radix tree */
> +		spin_lock(&ip->i_mount->m_perag_lock);
> +		radix_tree_tag_clear(&ip->i_mount->m_perag_tree,
> +				     XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
> +				     XFS_ICI_EOFBLOCKS_TAG);
> +		spin_unlock(&ip->i_mount->m_perag_lock);
> +		trace_xfs_perag_clear_eofblocks(ip->i_mount, pag->pag_agno,
> +					       -1, _RET_IP_);
> +	}
> +}
> +
> +void
> +xfs_inode_clear_eofblocks_tag(
> +	xfs_inode_t	*ip)
> +{
> +	struct xfs_mount *mp = ip->i_mount;
> +	struct xfs_perag *pag;
> +
> +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +	spin_lock(&pag->pag_ici_lock);
> +	trace_xfs_clear_eofblocks_tag(ip);
> +	__xfs_inode_clear_eofblocks(pag, ip);
> +	spin_unlock(&pag->pag_ici_lock);
> +	xfs_perag_put(pag);
> +}

Same here.

> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 2a5c6373..658ee2e 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -467,6 +467,8 @@ xfs_release(
>  		if (error)
>  			return error;
>  
> +		xfs_inode_clear_eofblocks_tag(ip);
> +
>  		/* delalloc blocks after truncation means it really is dirty */
>  		if (ip->i_delayed_blks)
>  			xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
> @@ -523,6 +525,7 @@ xfs_inactive(
>  			error = xfs_free_eofblocks(mp, ip, false);
>  			if (error)
>  				return VN_INACTIVE_CACHE;
> +			xfs_inode_clear_eofblocks_tag(ip);
>  		}
>  		goto out;

I think it's better to call xfs_inode_clear_eofblocks_tag() inside
xfs_free_eofblocks() - that's where the blocks are being freed,
after all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
