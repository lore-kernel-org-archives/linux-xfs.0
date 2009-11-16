Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAG3o4XW078518 for <xfs@oss.sgi.com>; Sun, 15 Nov 2009 21:50:05 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CAAC68BF8B
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2009 19:50:23 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	NAz1AoZxMRilIpcm for <xfs@oss.sgi.com>;
	Sun, 15 Nov 2009 19:50:23 -0800 (PST)
Date: Mon, 16 Nov 2009 14:50:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: improve metadata I/O merging in the elevator
Message-ID: <20091116035019.GI9467@discord.disaster>
References: <20091112190930.GB32110@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091112190930.GB32110@infradead.org>
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

On Thu, Nov 12, 2009 at 02:09:31PM -0500, Christoph Hellwig wrote:
> I had the patch below from Dave in my queue for a while, but previously
> couldn't really reproduce his numbers.  After some discussions of the
> bio types I've reteseted it again and can see constant improvements when
> using cfq on my large array box with it (5-10% for the sequential create
> workloads), but still nothing on deadline.  Given that people also want
> it for better marking in blktrace it might be time to put it in.
> 
> Comments?

Definitely should be done, but....

It looks like the patch you posted isn't quite doing what was
intended - async write buffers are being classified as WRITE, not
WRITE_META. That means we get more write combining in the elevator
(performance increase) like with WRITE_META, but don't get the
faster dispatch (latency reduction) by using the META queue to keep
the metadata writeback separate from the bulk data writeback.
That may be why deadline is not showing any improvement...

FWIW, the original patch here:

http://oss.sgi.com/archives/xfs/2008-01/msg00630.html

uses WRITE_META, but it looks like you've taken bits of this
patch:

http://oss.sgi.com/archives/xfs/2008-01/msg00653.html

and added the log buffer marking to this patch and accidentally
dropped the WRITE_META marking. i.e. this:

> +	} else if (bp->b_flags & _XBF_RUN_QUEUES) {
> +		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
> +		bp->b_flags &= ~_XBF_RUN_QUEUES;
> +		rw = (bp->b_flags & XBF_WRITE) ? WRITE : READ_META;

I think should be:

+		rw = (bp->b_flags & XBF_WRITE) ? WRITE_META : READ_META;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
