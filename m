Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB88329DF8
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 01:01:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 71AD58F8039
	for <xfs@oss.sgi.com>; Thu, 15 May 2014 23:01:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	noLv0uRayJ4WAwrx for <xfs@oss.sgi.com>;
	Thu, 15 May 2014 23:01:52 -0700 (PDT)
Date: Fri, 16 May 2014 16:01:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] xfs: fixes for 3.15-rc6
Message-ID: <20140516060139.GG26353@dastard>
References: <20140516021144.GK5421@dastard>
	<20140516055320.GA20975@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140516055320.GA20975@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, May 15, 2014 at 10:53:20PM -0700, Christoph Hellwig wrote:
> On Fri, May 16, 2014 at 12:11:44PM +1000, Dave Chinner wrote:
> > Hi Linus,
> > 
> > Can you please pull the updates listed below? I found a bunch of
> > error sign issues while determine what we need to do to rid XFS of
> > this problem permanently. A couple of the bugs are in data integirty
> > operations, a couple more are in the new COLLAPSE_RANGE code. One of
> > these came in through a recent ext4 merge and so I had to update the
> > base tree to 3.15-rc5 before fixing the issues.
> 
> Doesn't this miss the log roundin fix?

I'm still verifying/testing that fix (a several day stress
test was need to uncover it in the first place). It will need to be pushed back to
the -stable kernels, anyway, so it doesn't really matter which
kernel it goes into as long as it has the cc: stable tag in it...

> Linus said he is away for about a weeke anyway, while we're at it.

I missed that. Not a big problem, I'll just resend the pull request
when he gets back...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
