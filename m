Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R1q0Q9178538 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 19:52:00 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6A3F1A358B6
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 17:54:22 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	JEDj6fjVUZxEaEn0 for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 17:54:22 -0800 (PST)
Date: Thu, 27 Jan 2011 12:54:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/8] xfs: fix dquot shaker deadlock
Message-ID: <20110127015420.GF21311@dastard>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-9-git-send-email-david@fromorbit.com>
	<20110125095242.GB23990@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110125095242.GB23990@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Jan 25, 2011 at 04:52:42AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 25, 2011 at 07:50:44PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Commit 368e136 ("xfs: remove duplicate code from dquot reclaim") fails
> > to unlock the dquot freelist when the number of loop restarts is
> > exceeded in xfs_qm_dqreclaim_one(). This causes hangs in memory
> > reclaim. Remove the bogus loop exit check that causes the problem.
> 
> The fix looks correct, but it's a bit inconsequential about when
> to adhere the retry limit and when not.  Shouldn't we just turn the
> exit condition into:
> 
> 	if (dqout || restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
> 		break;

I'm guessing that you are suggesting changing the code increments
and checks restarts to:

	restarts++;
	goto startagain;

otherwise this doesn't make sense as restarts will never go above
XFS_QM_RECLAIM_MAX_RESTARTS at this point in the loop.

Even so, I don't think this is a good idea, because it means we have
to get to the end of the loop before we check restarts for loop
termination. Given that the restarts is counting the number of times
we fail to get locks, encounter dquots that are being recycled, etc,
this would render then restart counter ineffective as a method of
determining whether we are making progress or not. Hence I think
that simply removing the check that I did is the correct fix.

> also the failure to acquite qi_dqlist_lock increments the restart
> count twice, which was also added in the same commit.

I'll fix that, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
