Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1ALS5Vn081992 for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 15:28:05 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 201E81C358C
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 13:29:17 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	N2k4M3sABXePSSr8 for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2010 13:29:17 -0800 (PST)
Date: Thu, 11 Feb 2010 08:29:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 2/2] xfs_export_operations.commit_metadata
Message-ID: <20100210212914.GT11483@discord.disaster>
References: <20100210003220.6021.74943.stgit@case>
	<20100210003337.6021.10942.stgit@case>
	<20100210090750.GB21875@infradead.org>
	<20100210201527.GJ23654@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100210201527.GJ23654@sgi.com>
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
To: bpm@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Feb 10, 2010 at 02:15:27PM -0600, bpm@sgi.com wrote:
> Howdy,
> 
> On Wed, Feb 10, 2010 at 04:07:50AM -0500, Christoph Hellwig wrote:
> > On Tue, Feb 09, 2010 at 06:33:37PM -0600, Ben Myers wrote:
> > > hopefully
> > > the XFS gurus can continue to provide guidance.
> > 
> > Ccing the xfs list would help with that :) 
> 
> I'll cross-post the next rev.  ;)
> 
> > > +		if (xfs_ipincount(c_xip)) {
> > > +			/*
> > > +			 * AFAICS the child is always modified after the parent
> > > +			 * in nfsd so should always have a larger lsn.
> > > +			 */
> > > +			if (c_xip->i_itemp->ili_last_lsn > force_lsn) {
> > > +				force_lsn = c_xip->i_itemp->ili_last_lsn;
> > > +			} else {
> > > +				force_lsn = 0; /* whole thing */
> > > +			}
> > 
> > I wouldn't rely on that and always take the larger one.
> 
> I am concerned that ili_last_lsn will roll over at some point.  I
> haven't figured out how to detect that yet.

XFS_LSN_CMP() should be used for LSN comparisons - it handles
rollover corectly.


> > Now with the simplification of always having a non-zero first argument
> > suggested in the previous mail this might be simplified down to:
> > 
> > STATIC int
> > xfs_fs_nfs_commit_metadata(
> > 	struct dentry		*parent,
> > 	struct dentry		*child)
> > {
> > 	struct xfs_inode	*dp = XFS_I(parent->d_inode);
> > 	struct xfs_inode	*ip = NULL;
> > 	struct xfs_mount	*mp = dp->i_mount;
> > 	xfs_lsn_t		force_lsn = 0;
> > 	int			error = 0;
> > 
> > 	if (child) {
> > 		ip = XFS_I(child->d_inode);
> > 		xfs_lock_two_inodes(dp, ip, XFS_ILOCK_SHARED);
> > 	} else {
> > 		xfs_ilock(dp, XFS_ILOCK_SHARED);
> > 	}
> > 
> > 	if (xfs_ipincount(dp))
> > 		force_lsn = dp->i_itemp->ili_last_lsn;
> > 	if (ip && xfs_ipincount(ip))
> > 		force_lsn = max(force_lsn, ip->i_itemp->ili_last_lsn);

So this should be:

		if (XFS_LSN_CMP(force_lsn, ip->i_itemp->ili_last_lsn) < 0)
			force_lsn = ip->i_itemp->ili_last_lsn;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
