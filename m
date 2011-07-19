Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6J3EXxc143079 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 22:14:33 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 680DF7CEE7
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 20:14:31 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	KaKuFnhQb6Z3ke5C for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2011 20:14:31 -0700 (PDT)
Date: Tue, 19 Jul 2011 13:14:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: introduce an allocation workqueue
Message-ID: <20110719031429.GM30254@dastard>
References: <1310960989-10284-1-git-send-email-david@fromorbit.com>
	<1310960989-10284-2-git-send-email-david@fromorbit.com>
	<20110718160046.GA14094@infradead.org>
	<20110719012450.GG30254@dastard>
	<20110719020214.GB4259@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110719020214.GB4259@infradead.org>
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

On Mon, Jul 18, 2011 at 10:02:14PM -0400, Christoph Hellwig wrote:
> On Tue, Jul 19, 2011 at 11:24:50AM +1000, Dave Chinner wrote:
> > Honestly, I'd prefer not to do that because it's a slippery slope.
> > I've got plenty more "do stuff in the background via workqueues"
> > patches lined up, so if we start adding knobs/mount options to turn
> > each of them off "just in case there's an issue".
> > 
> > So far I haven't found any issues at all and I've been running this
> > split allocation stack like this in -all- my performance testing for
> > the past 2-3 months. I know that is not conclusive, but if the
> > bechmarks I've been using to improve XFS performance over the past
> > 18 months don't show regressions, that's fairly indicative of the
> > fact that most workloads won't even notice the change....
> 
> Maybe.  One thing I'd like to see is stuff like high-iop direct or
> O_SYNC I/O that actually calls the allocator.

What do you want me to run? I don't have any particularly high IOP
hardware here, but I might be able to do something that just hits
the BBWC....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
