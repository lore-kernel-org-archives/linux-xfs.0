Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q856f8uk256318 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 01:41:08 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	282AOIydbbNdG6H7 for <xfs@oss.sgi.com>;
	Tue, 04 Sep 2012 23:42:05 -0700 (PDT)
Date: Wed, 5 Sep 2012 16:42:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 2/4] xfs: create function to scan and clear EOFBLOCKS
	inodes
Message-ID: <20120905064202.GG15292@dastard>
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
	<1346097111-4476-3-git-send-email-bfoster@redhat.com>
	<20120903050612.GR15292@dastard> <50460BB8.1060701@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50460BB8.1060701@redhat.com>
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

On Tue, Sep 04, 2012 at 10:10:00AM -0400, Brian Foster wrote:
> On 09/03/2012 01:06 AM, Dave Chinner wrote:
> > On Mon, Aug 27, 2012 at 03:51:49PM -0400, Brian Foster wrote:
> ...
> >> +/*
> >> + * Handle an EOFBLOCKS tagged inode. If this is a forced scan, we wait on the
> >> + * iolock ourselves rather than rely on the trylock in xfs_free_eofblocks(). 
> >> + *
> >> + * We rely on the output parameter from xfs_free_eofblocks() to determine
> >> + * whether we should clear the tag because in the trylock case, it could have
> >> + * skipped the inode due to lock contention.
> >> + */
> >> +STATIC int
> >> +xfs_inode_free_eofblocks(
> >> +	struct xfs_inode	*ip,
> >> +	int			flags)
> >> +{
> >> +	int ret = 0;
> >> +	bool freed = false;
> >> +	bool wait_iolock = (flags & EOFBLOCKS_WAIT) ? true : false;
> >> +
> >> +	if (wait_iolock)
> >> +		xfs_ilock(ip, XFS_IOLOCK_EXCL);
> > 
> > Why do we need the IO lock here? xfs_free_eofblocks() does all the
> > necessary locking....
> > 
> 
> This was for the wait case (e.g., xfs_free_eofblocks() does a trylock
> on the IO lock and we want to wait for the lock in this case).

Does it really matter if we can't get the iolock and skip the inode?

Note that xfs_inode_ag_walk() will keep a skipped count if you
return EAGAIN, and re-run the walk on the AG if any inodes are
skipped. This is done to prevent blocking on locks slowing down the
scan - instead of blocking we move on to the next inode, and revist
the blocked inodes again in a later pass.

IOWs, if you convert the code to use the generic walk and make
xfs_free_eofblocks() return EAGAIN when it can't get the io lock,
you get the retry for free...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
