Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C40687F47
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 18:44:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 911FB8F8035
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 16:44:58 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AabPVRmp0D9szhHH for <xfs@oss.sgi.com>;
	Thu, 12 Jun 2014 16:44:55 -0700 (PDT)
Date: Fri, 13 Jun 2014 09:44:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: wire up aio_fsync method
Message-ID: <20140612234441.GT9508@dastard>
References: <1402562047-31276-1-git-send-email-david@fromorbit.com>
	<20140612141329.GA11676@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140612141329.GA11676@infradead.org>
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

On Thu, Jun 12, 2014 at 07:13:29AM -0700, Christoph Hellwig wrote:
> There doesn't really seem anything XFS specific here, so instead
> of wiring up ->aio_fsync I'd implement IOCB_CMD_FSYNC in fs/aio.c
> based on the workqueue and ->fsync.

I really don't know whether the other ->fsync methods in other
filesystems can stand alone like that. I also don't have the
time to test that it works properly on all filesystems right now.

Also, doing this implementation in fs/aio.c would mean we can't
optimise it to reduce things like log forces by splitting up the
work of concurrent fsyncs into a single log force of the highest
LSN of the batch of fsyncs being run. We also want to be able to do
"background fsync" where latency doesn't matter and we only want to
trickle them out rather than issue them as fast as we possibly can.

So I really don't see this as the infrastructure solution that
everyone uses. It could be made a generic method with the filesystem
passing the workqueue to use to generic_aio_fsync(), but for XFS I
see it turning into something much more complex and optimised...

Like I said, this is just a brute force proof of concept.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
