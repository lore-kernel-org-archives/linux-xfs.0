Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6J0EOlM174375 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 19:14:24 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C26741E2BDA6
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 17:17:22 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	uUw2loMCZD7erOPm for <xfs@oss.sgi.com>;
	Sun, 18 Jul 2010 17:17:22 -0700 (PDT)
Date: Mon, 19 Jul 2010 10:17:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: track AGs with reclaimable inodes in per-ag
	radix tree
Message-ID: <20100719001719.GD23223@dastard>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
	<1279154300-2018-2-git-send-email-david@fromorbit.com>
	<1279216900.2054.28.camel@doink>
	<20100716051700.GB29915@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100716051700.GB29915@infradead.org>
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
Cc: XFS Mailing List <xfs@oss.sgi.com>, Alex Elder <aelder@sgi.com>

On Fri, Jul 16, 2010 at 01:17:00AM -0400, Christoph Hellwig wrote:
> On Thu, Jul 15, 2010 at 01:01:40PM -0500, Alex Elder wrote:
> > Using the same tag represent a perag with reclaimable
> > inodes as the tag representing an inode is reclaimable
> > is nicely consistent...
> 
> Oh, didn't notice that when reviewing it.  Not sure I like it
> too much.  If we ever grow more tags on the perag tree this
> might get rather confusing.

Sure. But it's an in-memory flag so we can change it whenever we
need to. If we grow another tag on the perag tree, we can sort it
out then....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
