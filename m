Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6C2cEOT260507 for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 21:38:15 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C78615B03F6
	for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 19:41:08 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	mW2K1FG3LOPyEXLx for <xfs@oss.sgi.com>;
	Sun, 11 Jul 2010 19:41:08 -0700 (PDT)
Date: Mon, 12 Jul 2010 12:41:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] Per superblock shrinkers V2
Message-ID: <20100712024104.GD25335@dastard>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
	<20100702121304.GA10075@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100702121304.GA10075@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jul 02, 2010 at 08:13:04AM -0400, Christoph Hellwig wrote:
> Did you plan to resubmit this with the few review comments addressed?
> I'd really hate to not see this in 2.6.36.

I've been doing some more testing on it, and while I can get a 25%
reduction in the time to create and remove 10 million inodes with
per-sb shrinker, I can't get the reclaim pattern stable enough for
my liking.

At this point in the cycle, I'd much prefer just to go with adding a
context to the shrinker API to fix the XFS locking issues (i.e.  the
original patches I sent) and spend a bit more time working out which
combination of Nick's and my bits that improves reclaim speed whilst
retaining the stability of the courrent code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
