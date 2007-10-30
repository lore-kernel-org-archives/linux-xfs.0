Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Oct 2007 05:41:57 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9UCfprJ005849
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2007 05:41:54 -0700
Date: Tue, 30 Oct 2007 12:41:55 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix inode allocation latency
Message-ID: <20071030124155.GA31166@infradead.org>
References: <20071029233742.GS995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029233742.GS995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

On Tue, Oct 30, 2007 at 10:37:42AM +1100, David Chinner wrote:
> The log force added in xfs_iget_core() has been a performance
> issue since it was introduced for tight loops that allocate
> then unlink a single file. under heavy writeback, this can
> introduce unnecessary latency due tothe log I/o getting
> stuck behind bulk data writes.
> 
> Fix this latency problem by avoinding the need for the log
> force by moving the place we mark linux inode dirty to the
> transaction commit rather than on transaction completion.
> 
> This also closes a potential hole in the sync code where a
> linux inode is not dirty betwen the time it is modified and
> the time the log buffer has been written to disk.

The concept sounds fine to me, and the implementation looks good
aswell.

>  /*
> + * If the linux inode exists, mark it dirty.
> + * Used when commiting a dirty inode into a transaction so that
> + * the inode will get written back by the linux code
> + */
> +void
> +xfs_mark_inode_dirty_sync(
> +	xfs_inode_t	*ip)
> +{
> +	bhv_vnode_t	*vp;
> +
> +	vp = XFS_ITOV_NULL(ip);
> +	if (vp)
> +		mark_inode_dirty_sync(vn_to_inode(vp));
> +}

I think this should be:

void
xfs_mark_inode_dirty_sync(
	xfs_inode_t	*ip)
{
	if (ip->i_vnode)
		mark_inode_dirty_sync(ip->i_vnode);
}
