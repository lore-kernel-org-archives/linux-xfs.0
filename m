Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1A96c8l035220 for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 03:06:41 -0600
Date: Wed, 10 Feb 2010 04:07:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 2/2] xfs_export_operations.commit_metadata
Message-ID: <20100210090750.GB21875@infradead.org>
References: <20100210003220.6021.74943.stgit@case>
	<20100210003337.6021.10942.stgit@case>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100210003337.6021.10942.stgit@case>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 09, 2010 at 06:33:37PM -0600, Ben Myers wrote:
> Here is the commit_metadata export_operation for xfs.  We take two dentries and
> force the log up to the larger lsn.  It looks to me that in nfsd the child is
> always modified after the parent so generally we expect the child's lsn to be
> larger.  If that's not the case we'll just force the entire thing.
> 
> The basic form of this is based upon one of Christoph's suggestions.  I'm an
> xfs newbie so I'm not very comfortable with it yet.  My understanding is that I
> need to verify that all of the necessary changes make it into the transations
> we're forcing into the log here.  I am still looking into that and hopefully
> the XFS gurus can continue to provide guidance.

Ccing the xfs list would help with that :)  Anyway, I think it looks
pretty good, but there's quite a few smaller nitpicks:

> +STATIC int
> +xfs_fs_nfs_commit_metadata(
> +	struct dentry		*parent,
> +	struct dentry		*child)
> +{
> +	struct xfs_inode	*p_xip = NULL, *c_xip = NULL;

Normal xfs naming would be dp for the parent, and ip for the child,
it would be good to stick to that.

> +	struct xfs_mount	*i_mount = NULL;	

Normal name all over xfs would be mp.

> +	} else if (parent && child) {
> +		p_xip = XFS_I(parent->d_inode);
> +		c_xip = XFS_I(child->d_inode);
> +		xfs_ilock(p_xip, XFS_ILOCK_SHARED);
> +		xfs_ilock(c_xip, XFS_ILOCK_SHARED);

If we need to lock both parent and child we need to use
xfs_lock_two_inodes to make sure the lock order is correct.

> +		if (xfs_ipincount(c_xip)) {
> +			/*
> +			 * AFAICS the child is always modified after the parent
> +			 * in nfsd so should always have a larger lsn.
> +			 */
> +			if (c_xip->i_itemp->ili_last_lsn > force_lsn) {
> +				force_lsn = c_xip->i_itemp->ili_last_lsn;
> +			} else {
> +				force_lsn = 0; /* whole thing */
> +			}

I wouldn't rely on that and always take the larger one.


Now with the simplification of always having a non-zero first argument
suggested in the previous mail this might be simplified down to:

STATIC int
xfs_fs_nfs_commit_metadata(
	struct dentry		*parent,
	struct dentry		*child)
{
	struct xfs_inode	*dp = XFS_I(parent->d_inode);
	struct xfs_inode	*ip = NULL;
	struct xfs_mount	*mp = dp->i_mount;
	xfs_lsn_t		force_lsn = 0;
	int			error = 0;

	if (child) {
		ip = XFS_I(child->d_inode);
		xfs_lock_two_inodes(dp, ip, XFS_ILOCK_SHARED);
	} else {
		xfs_ilock(dp, XFS_ILOCK_SHARED);
	}

	if (xfs_ipincount(dp))
		force_lsn = dp->i_itemp->ili_last_lsn;
	if (ip && xfs_ipincount(ip))
		force_lsn = max(force_lsn, ip->i_itemp->ili_last_lsn);

	error = _xfs_log_force_lsn(mp, force_lsn, NULL);

	if (ip)
		xfs_iunlock(ip, XFS_ILOCK_SHARED);
	xfs_iunlock(dp, XFS_ILOCK_SHARED);

	return error;
}

Note that _xfs_log_force_lsn is new in the XFS tree, mainline still
has _xfs_log_force with an lsn argument.

Also note that ->commit_metadata probably should take just two inodes
instead of two dentires given the level it operates on, but it shouldn't
matter too much.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
