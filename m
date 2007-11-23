Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Nov 2007 09:58:59 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lANHwrkT000443
	for <xfs@oss.sgi.com>; Fri, 23 Nov 2007 09:58:55 -0800
Date: Fri, 23 Nov 2007 17:59:01 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/9] Remove xfs_icluster
Message-ID: <20071123175901.GA12866@infradead.org>
References: <20071122003952.GL114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122003952.GL114266761@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

On Thu, Nov 22, 2007 at 11:39:52AM +1100, David Chinner wrote:
> Remove the xfs_icluster structure and replace with a radix tree lookup.
> 
> We don't need to keep a list of inodes in each cluster around anymore
> as we can look them up quickly when we need to. The only time we need
> to do this now is during inode writeback.
> 
> Factor the inode cluster writeback code out of xfs_iflush and convert
> it to use radix_tree_gang_lookup() instead of walking a list of
> inodes built when we first read in the inodes.
> 
> This remove 3 pointers from each xfs_inode structure and the xfs_icluster
> structure per inode cluster. Hence we reduce the cache footprint of the
> xfs_inodes by between 5-10% depending on cluster sparseness.
> 
> To be truly efficient we need a radix_tree_gang_lookup_range() call
> to stop searching once we are past the end of the cluster instead
> of trying to find a full cluster's worth of inodes.

Nice, I like this a lot.  I was wondering about something like this
already when you put in the radix-tree based inode cache.

> +STATIC int
> +xfs_iflush_cluster(
> +	xfs_inode_t	*ip,
> +	xfs_buf_t	*bp)
> +{
> +	xfs_mount_t		*mp = ip->i_mount;
> +	xfs_perag_t		*pag = xfs_get_perag(mp, ip->i_ino);
> +	unsigned long		first_index, mask;
> +	int			ilist_size;
> +	xfs_inode_t		*ilist;
> +	xfs_inode_t		*iq;
> +	xfs_inode_log_item_t	*iip;
> +	int			nr_found;
> +	int			clcount = 0;
> +	int			bufwasdelwri;
> +
> +	ASSERT(pag->pagi_inodeok);
> +	ASSERT(pag->pag_ici_init);
> +
> +	ilist_size = XFS_INODE_CLUSTER_SIZE(mp) * sizeof(xfs_inode_t *);
> +	ilist = kmem_alloc(ilist_size, KM_MAYFAIL);
> +	if (!ilist)
> +		return 0;

Now if you just used the linux native allocator this could be a kcalloc :)

> +		if ((iq->i_update_core == 0) &&
> +		    ((iip == NULL) ||
> +		     !(iip->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
> +		      xfs_ipincount(iq) == 0) {
> +			continue;
> +		}

		if (!iq->i_update_core &&
		    (!iip || !(iip->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
		    !xfs_ipincount(iq))
		    	continue;

> +		/*
> +		 * arriving here means that this inode can be flushed.  First
> +		 * re-check that it's dirty before flushing.
> +		 */
> +		iip = iq->i_itemp;
> +		if ((iq->i_update_core != 0) || ((iip != NULL) &&
> +		     (iip->ili_format.ilf_fields & XFS_ILOG_ALL))) {

		if (!iq->i_update_core ||
		    (!iip && (iip->ili_format.ilf_fields & XFS_ILOG_ALL)) {

> +	/*
> +	 * Clean up the buffer.  If it was B_DELWRI, just release it --
> +	 * brelse can handle it with no problems.  If not, shut down the
> +	 * filesystem before releasing the buffer.
> +	 */
> +	bufwasdelwri = XFS_BUF_ISDELAYWRITE(bp);
> +	if (bufwasdelwri)
> +		xfs_buf_relse(bp);
> +
> +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +
> +	if (!bufwasdelwri) {
> +		/*
> +		 * Just like incore_relse: if we have b_iodone functions,
> +		 * mark the buffer as an error and call them.  Otherwise
> +		 * mark it as stale and brelse.
> +		 */
> +		if (XFS_BUF_IODONE_FUNC(bp)) {
> +			XFS_BUF_CLR_BDSTRAT_FUNC(bp);
> +			XFS_BUF_UNDONE(bp);
> +			XFS_BUF_STALE(bp);
> +			XFS_BUF_SHUT(bp);
> +			XFS_BUF_ERROR(bp,EIO);
> +			xfs_biodone(bp);
> +		} else {
> +			XFS_BUF_STALE(bp);
> +			xfs_buf_relse(bp);
> +		}
> +	}

What's the point of all this if the filesystem is shut down anyway?
