Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1606lrs173131 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 18:06:47 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C55E41B4C37
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2010 16:07:56 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	u2wMpEjSyPOE0suS for <xfs@oss.sgi.com>;
	Fri, 05 Feb 2010 16:07:56 -0800 (PST)
Date: Sat, 6 Feb 2010 11:07:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/10] xfs: Make inode reclaim states explicit
Message-ID: <20100206000752.GF11483@discord.disaster>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
	<1265153104-29680-2-git-send-email-david@fromorbit.com>
	<1265396780.2714.23.camel@doink1>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1265396780.2714.23.camel@doink1>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 05, 2010 at 01:06:20PM -0600, Alex Elder wrote:
> On Wed, 2010-02-03 at 10:24 +1100, Dave Chinner wrote:
> > A.K.A.: don't rely on xfs_iflush() return value in reclaim
> > 
> > We have gradually been moving checks out of the reclaim code because
> > they are duplicated in xfs_iflush(). We've had a history of problems
> > in this area, and many of them stem from the overloading of the
> > return values from xfs_iflush() and interaction with inode flush
> > locking to determine if the inode is safe to reclaim.
> > 
> > With the desire to move to delayed write flushing of inodes and
> > non-blocking inode tree reclaim walks, the overloading of the
> > return value of xfs_iflush makes it very difficult to determine
> > the correct thing to do next.
> > 
> > This patch explicitly re-adds the checks to the inode reclaim code,
> > removing the reliance on the return value of xfs_iflush() to
> > determine what to do next. It also means that we can clearly
> > document all the inode states that reclaim must handle and hence
> > we can easily see that we handled all the necessary cases.
> > 
> > This also removes the need for the xfs_inode_clean() check in
> > xfs_iflush() as all callers now check this first (safely).
> 
> I have a few comments, below.  One is a real bug.  At this
> point I'm trusting that your enumeration of all the possible
> inode states is correct.  Other than what I indicate below,
> this change looks good.

...

> It looks to me like your code adds a call to xfs_ifunlock(ip)
> in the bad inode case that was not there before.  My guess is
> that your way is correct, but I'd like to know whether you
> agree this differs.  Is this intentional?  Regardless, is
> the new xfs_ifunlock() call correct?

Yes, it is correct - the code before was broken.

> > +	if (xfs_iflags_test(ip, XFS_ISTALE))
> > +		goto reclaim;
> > +	if (xfs_inode_clean(ip))
> > +		goto reclaim;
> > +
> > +	/* Now we have an inode that needs flushing */
> > +	error = xfs_iflush(ip, sync_mode);
> > +	if (!error) {
> > +		switch(sync_mode) {
> > +		case XFS_IFLUSH_DELWRI_ELSE_ASYNC:
> > +		case XFS_IFLUSH_DELWRI:
> > +		case XFS_IFLUSH_ASYNC:
> > +		case XFS_IFLUSH_DELWRI_ELSE_SYNC:
> > +		case XFS_IFLUSH_SYNC:
> > +			/* IO issued, synchronise with IO completion */
> > +			xfs_iflock(ip);
> 
> You must not have run this with DEBUG enabled.
> You need a "break;" here.

I always run with DEBUG enabled, but I probably didn't
test this patch by iteself in the last iteration because
i don't have unlimited test cycles. This code gets removed
by the next patch, so the fact that it was broken would
not have been picked up by testing. I'll update it
and re-push it to the for-2.6.34 branch.

Cheers,
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
