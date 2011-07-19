Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6J22FYO139888 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 21:02:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E8311E65070
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 19:02:14 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	IBF2oFANIEOudQjl for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2011 19:02:14 -0700 (PDT)
Date: Mon, 18 Jul 2011 22:02:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: introduce an allocation workqueue
Message-ID: <20110719020214.GB4259@infradead.org>
References: <1310960989-10284-1-git-send-email-david@fromorbit.com>
	<1310960989-10284-2-git-send-email-david@fromorbit.com>
	<20110718160046.GA14094@infradead.org>
	<20110719012450.GG30254@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110719012450.GG30254@dastard>
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

On Tue, Jul 19, 2011 at 11:24:50AM +1000, Dave Chinner wrote:
> Honestly, I'd prefer not to do that because it's a slippery slope.
> I've got plenty more "do stuff in the background via workqueues"
> patches lined up, so if we start adding knobs/mount options to turn
> each of them off "just in case there's an issue".
> 
> So far I haven't found any issues at all and I've been running this
> split allocation stack like this in -all- my performance testing for
> the past 2-3 months. I know that is not conclusive, but if the
> bechmarks I've been using to improve XFS performance over the past
> 18 months don't show regressions, that's fairly indicative of the
> fact that most workloads won't even notice the change....

Maybe.  One thing I'd like to see is stuff like high-iop direct or
O_SYNC I/O that actually calls the allocator.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
