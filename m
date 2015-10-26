Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DB2307F63
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 06:49:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B531304039
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 04:49:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ykGW2OMpgS3iFwTC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 26 Oct 2015 04:49:31 -0700 (PDT)
Date: Mon, 26 Oct 2015 07:49:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: optimise away log forces on timestamp updates for
	fdatasync
Message-ID: <20151026114929.GA59738@bfoster.bfoster>
References: <1445396343-4361-1-git-send-email-david@fromorbit.com>
	<20151022173618.GC13661@bfoster.bfoster>
	<20151026050720.GG8773@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151026050720.GG8773@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: sage@redhat.com, xfs@oss.sgi.com

On Mon, Oct 26, 2015 at 04:07:20PM +1100, Dave Chinner wrote:
> On Thu, Oct 22, 2015 at 01:36:19PM -0400, Brian Foster wrote:
> > On Wed, Oct 21, 2015 at 01:59:03PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > xfs: timestamp updates cause excessive fdatasync log traffic
> ....
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -248,8 +248,10 @@ xfs_file_fsync(
> > >  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> > >  	if (xfs_ipincount(ip)) {
> > >  		if (!datasync ||
> > > -		    (ip->i_itemp->ili_fields & ~XFS_ILOG_TIMESTAMP))
> > > +		    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP)) {
> > >  			lsn = ip->i_itemp->ili_last_lsn;
> > > +			ip->i_itemp->ili_fsync_fields = 0;
> > > +		}
> > 
> > Ok, so we check what's been logged since the last fsync that forced the
> > log. If anything other than the timestamp has been logged, we force the
> > log and clear the fields. Seems like a reasonable optimization to me.
> > 
> > One question... is it safe to clear the ili_fsync fields here if we have
> > parallel fsync()/fdatasync() calls coming in? This is under the shared
> > ilock, so assume that one fsync() comes in and finds non-timestamp
> > changes to flush. It grabs the lsn, clears the flags and calls the log
> > force. If an fdatasync() comes in before the log force completes,
> > shouldn't it wait?
> 
> Probably, but the only way to do that is to run a log force on that
> same lsn. Actually, it is safe to do that log force while holding
> the XFS_ILOCK (xfs_trans_commit() does that for synchronous
> transactions), so we should simply be able to do:
> 

Yeah, a parallel fsync on a single inode situation is probably not the
most likely thing. Thinking about it further, the case where multiple
inodes happen to have the same lsn might be more likely and takes the
shared ilock out of the equation.

> 	xfs_ilock(ip, XFS_ILOCK_SHARED);
> 	if (xfs_ipincount(ip)) {
> 		if (!datasync ||
> 		    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> 			lsn = ip->i_itemp->ili_last_lsn;
> 	}
> 
> 	if (lsn) {
> 		error = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
> 		ip->i_itemp->ili_fsync_fields = 0;
> 	}
> 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> 

This looks better to me. We send the caller through the log force
infrastructure until we know the log has been forced.

> 
> > Also, is it me or are we sending an unconditional flush in the hunk
> > following the log force call in xfs_file_fsync() (even if we've skipped
> > the log force)?
> 
> The flush is needed - fdatasync needs to guarantee the data is
> on stable storage even if no metadata needs to be written to the
> journal.
> 

Ok. Well it's too bad we don't get any feedback about what was written
from the filemap_write_and_wait_range() call. As it is, we send a flush
even if there's nothing to write back. I suppose that's also not a major
problem since an fsync() caller implies something was modified one way
or another. Thanks.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
