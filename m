Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B8F217F4E
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 00:08:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8DC25304032
	for <xfs@oss.sgi.com>; Sun, 25 Oct 2015 22:07:58 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	15YmFUn7TJifzCnm for <xfs@oss.sgi.com>;
	Sun, 25 Oct 2015 22:07:51 -0700 (PDT)
Date: Mon, 26 Oct 2015 16:07:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: optimise away log forces on timestamp updates for
	fdatasync
Message-ID: <20151026050720.GG8773@dastard>
References: <1445396343-4361-1-git-send-email-david@fromorbit.com>
	<20151022173618.GC13661@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151022173618.GC13661@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: sage@redhat.com, xfs@oss.sgi.com

On Thu, Oct 22, 2015 at 01:36:19PM -0400, Brian Foster wrote:
> On Wed, Oct 21, 2015 at 01:59:03PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs: timestamp updates cause excessive fdatasync log traffic
....
> > +++ b/fs/xfs/xfs_file.c
> > @@ -248,8 +248,10 @@ xfs_file_fsync(
> >  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> >  	if (xfs_ipincount(ip)) {
> >  		if (!datasync ||
> > -		    (ip->i_itemp->ili_fields & ~XFS_ILOG_TIMESTAMP))
> > +		    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP)) {
> >  			lsn = ip->i_itemp->ili_last_lsn;
> > +			ip->i_itemp->ili_fsync_fields = 0;
> > +		}
> 
> Ok, so we check what's been logged since the last fsync that forced the
> log. If anything other than the timestamp has been logged, we force the
> log and clear the fields. Seems like a reasonable optimization to me.
> 
> One question... is it safe to clear the ili_fsync fields here if we have
> parallel fsync()/fdatasync() calls coming in? This is under the shared
> ilock, so assume that one fsync() comes in and finds non-timestamp
> changes to flush. It grabs the lsn, clears the flags and calls the log
> force. If an fdatasync() comes in before the log force completes,
> shouldn't it wait?

Probably, but the only way to do that is to run a log force on that
same lsn. Actually, it is safe to do that log force while holding
the XFS_ILOCK (xfs_trans_commit() does that for synchronous
transactions), so we should simply be able to do:

	xfs_ilock(ip, XFS_ILOCK_SHARED);
	if (xfs_ipincount(ip)) {
		if (!datasync ||
		    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
			lsn = ip->i_itemp->ili_last_lsn;
	}

	if (lsn) {
		error = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
		ip->i_itemp->ili_fsync_fields = 0;
	}
	xfs_iunlock(ip, XFS_ILOCK_SHARED);


> Also, is it me or are we sending an unconditional flush in the hunk
> following the log force call in xfs_file_fsync() (even if we've skipped
> the log force)?

The flush is needed - fdatasync needs to guarantee the data is
on stable storage even if no metadata needs to be written to the
journal.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
