Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1H8WGH0219771 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 02:32:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC9551D7FFF
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 00:33:34 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 4KsBqZNboC2vOUuf for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2010 00:33:34 -0800 (PST)
Date: Wed, 17 Feb 2010 03:33:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] [PATCH 3/4] xfs: remove wrapper for the fsync file
	operation
Message-ID: <20100217083334.GC19943@infradead.org>
References: <20100215094445.528696829@bombadil.infradead.org>
	<20100215094604.640912740@bombadil.infradead.org>
	<20100217040944.GK28392@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100217040944.GK28392@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Feb 17, 2010 at 03:09:44PM +1100, Dave Chinner wrote:
> > +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > +		if (xfs_ipincount(ip)) {
> > +			if (ip->i_itemp->ili_last_lsn) {
> > +				error = _xfs_log_force_lsn(ip->i_mount,
> > +						ip->i_itemp->ili_last_lsn,
> > +						XFS_LOG_SYNC, &log_flushed);
> > +			} else {
> > +				error = _xfs_log_force(ip->i_mount,
> > +						XFS_LOG_SYNC, &log_flushed);
> > +			}
> > +		}
> 
> To be technically correct, the ilock should be held over the
> pincount check and log force, as is done in xfs_iunpin_wait().
> That way we can guarantee the inode was correctly forced and not
> unpinned between the unlock/check/log force being issued. I know
> this is just a copy of the existing fsync code, but I think that
> the existing code is wrong, too. ;)

Yes, no changes to the code semantics here.  But that ipincount check
is a relatively recent addition from me, too - so thanks for the
slightly delayed review as the comment is absolutely correct.  I'll
prepare a patch for it

> Also, if the inode is pinned while we have it locked, then
> ip->i_itemp->ili_last_lsn is guaranteed to be set as it is updated
> in IOP_COMMITTING() which is called during transaction commit.
> 
> As it is, ili_last_lsn is never reset to zero after a transaction,
> so i think the _xfs_log_force() branch will never be executed,
> either.

True, the same also applies to __xfs_iunpit_wait, I'll look into
that in another patch.  This will also apply to Ben's nfsd
commit_metadata patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
