Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R2LhSb179980 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 20:21:43 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBA201A386E3
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 18:24:06 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	molWRzVFCx191dA8 for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 18:24:06 -0800 (PST)
Date: Thu, 27 Jan 2011 13:24:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/8] xfs: fix dquot shaker deadlock
Message-ID: <20110127022404.GG21311@dastard>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-9-git-send-email-david@fromorbit.com>
	<20110125095242.GB23990@infradead.org>
	<20110127015420.GF21311@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110127015420.GF21311@dastard>
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

On Thu, Jan 27, 2011 at 12:54:20PM +1100, Dave Chinner wrote:
> On Tue, Jan 25, 2011 at 04:52:42AM -0500, Christoph Hellwig wrote:
> > On Tue, Jan 25, 2011 at 07:50:44PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Commit 368e136 ("xfs: remove duplicate code from dquot reclaim") fails
> > > to unlock the dquot freelist when the number of loop restarts is
> > > exceeded in xfs_qm_dqreclaim_one(). This causes hangs in memory
> > > reclaim. Remove the bogus loop exit check that causes the problem.
> > 
> > The fix looks correct, but it's a bit inconsequential about when
> > to adhere the retry limit and when not.  Shouldn't we just turn the
> > exit condition into:
> > 
> > 	if (dqout || restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
> > 		break;
> 
> I'm guessing that you are suggesting changing the code increments
> and checks restarts to:
> 
> 	restarts++;
> 	goto startagain;
> 
> otherwise this doesn't make sense as restarts will never go above
> XFS_QM_RECLAIM_MAX_RESTARTS at this point in the loop.

Argh, there's one loop case where it does increment restarts without
jumping to startagain. I'm going to change this loop to stack the
loop exit cases rather than do them all individually and making it
difficult to work out what is going on.

So each case will increment restarts itself as necessary, set a
"startagain" flag if a loop restart is required, and set dqpout if a
successful reclaim occurred. That way each case can then jump to the
correctly stacked unlock point and all the loop exit logic is in one
place.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
