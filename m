Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3N3MJY9009176 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 22:22:19 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB11E1059135
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 20:24:18 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	wGfNnsqa2rcIiB28 for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 20:24:18 -0700 (PDT)
Date: Fri, 23 Apr 2010 13:24:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Improve scalability of busy extent tracking
Message-ID: <20100423032415.GD10390@dastard>
References: <1271828835-2094-1-git-send-email-david@fromorbit.com>
	<20100422110143.GA21867@infradead.org>
	<20100422161626.GE23541@dastard>
	<20100422170848.GA26101@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100422170848.GA26101@infradead.org>
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

On Thu, Apr 22, 2010 at 01:08:49PM -0400, Christoph Hellwig wrote:
> Been looking at this a bit and I have a theory:
> 
>  - a tid is not actually unique to a xfs_trans structure, if
>    we call xfs_trans_dup a single xlog_ticket, and with that the
>    tid is re-used by multiple transaction structure.

Good point, and an angle I had missed.

>  - because of that the major semantic change in the version vs
>    the previous one is that we now do not force the synchronous
>    transaction for the case where we re-used a block in
>    the rolled over transaction.

The problem case is not re-allocation of the busy extent, it's the
subsequent freeing of that extent that is already busy.  i.e. we've
done "free - alloc - free" before the transaction containing the
alloc has hit the disk and cleared the original busy extent from the
tree.

In a single transaction case, the alloc should mark the transaction
synchronous, so the second free should match the tid and assert that
it is synchronous.

The mutliple transaction case can be split up:

	{free} {alloc} {free}: mismatched tids -> log force
	{free - alloc} {free}: mismatched tids -> log force
	{free} {alloc - free}: same as the single transaction case

But as you point out, the mutiple transaction case could have
duplicate tids, so the first two cases could be getting it wrong.
However, if the tids match, then the ASSERT should fire if the
transactions were not sycnhronous.

Hence all I can conclude is that xfsqa is not triggering the first
two cases from duplicated transactions, but we need to change
tid of the log ticket when we dup transactions.

FWIW, now that you've pointed this out, this appears to be another
existing source of duplicate TIDs in the log that I did not identify
when I first saw them in the log.  It seems to me that the best
approach to fixing this is that when we regrant the log space on a
permanent log ticket we need to regenerate the ticket tid so that
individual components of rolling transactions are not confused in
log replay. Does this seem reasonable?

Doing this would also handle the above two cases correctly as well.
Despite this, I still can't see how such a scenario would cause the
problems with transaction pointer matching because the "same
transaction pointer but different transactions" situation still
can't occur even with duplicated transactions....

> Still not quite sure about the implications of this.

I'll change it and run some tests. It'll be next week before I can
get to this, though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
