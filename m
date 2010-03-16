Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2G1CVlI105399 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 20:12:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 314F624C945
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 18:14:05 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	ipFOEeNKEPHZBHjx for <xfs@oss.sgi.com>;
	Mon, 15 Mar 2010 18:14:05 -0700 (PDT)
Date: Tue, 16 Mar 2010 12:14:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Delayed logging
Message-ID: <20100316011403.GB12369@dastard>
References: <20100315043000.GK4732@dastard>
	<20100315160801.GB10406@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100315160801.GB10406@infradead.org>
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

On Mon, Mar 15, 2010 at 12:08:01PM -0400, Christoph Hellwig wrote:
> Some comments on the patches:
> 
>  - "xfs: cluster fsync transaction" seems like something that can stand
>    on it's own and go into the tree now.  Despite the comments it
>    currently only clusters in fsync and not write_inode which might
>    lead to higher benefits, btw.

As I said, I'll have a bit more of a think about this one...

>  - the busy extent tracking might be worth to be reordered before the
>    delayed logging series.  In itself it might also want some reordering
>    as there's a lot churn in the patches there.  Making
>    "XFS: Simplify transaction busy extent tracking" first in that
>    subseries might help quite a bit to reduce that churn

Agreed. They were ordered this way because I only added the extent
tracking after doing the delayed logging and tracking down one of
the sources of log forces that was limiting performance was
overflowing the per-ag busy extent array. I'll rework it....

>  - The actual CIL implementation seems to be split into too small
>    patches IMHO.  E.g. "xfs: extend the log item to support delayed
>    logging" and "xfs: Introduce the Committed Item List" are two
>    sides of the same coin and splitting it might not make too much
>    sense.

True, it might be a bit fine grained. Really, what I wanted to do is
split the changes that affected the non-delayed logging from those
that are only executed when delayed logging is active. That way I
could confirm that the non-delayed path was still operating
correctly before adding all the delayed logging code that used
it. I can combine them together again if you want.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
