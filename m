Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 510F97F72
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 19:54:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3CF848F8050
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 17:54:02 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	KaRu6ETHyXM7vv2M for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 17:54:01 -0700 (PDT)
Date: Fri, 29 Aug 2014 10:53:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: don't dirty buffers beyond EOF
Message-ID: <20140829005358.GY20518@dastard>
References: <1409226551-16570-1-git-send-email-david@fromorbit.com>
	<1409226551-16570-2-git-send-email-david@fromorbit.com>
	<20140829003911.GA30463@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140829003911.GA30463@infradead.org>
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

On Thu, Aug 28, 2014 at 05:39:11PM -0700, Christoph Hellwig wrote:
> Not sure if my 10 cents are worth anything given that I haven't spent
> much time with this code recently, but I feel very uneasy diverging
> from the generic path in this area.

I can't see how we have any other choice right now. We're caught
between a rock and a hard place - XFS uses bufferheads differently
to all other filesystems (esp. w.r.t. to EOF block zeroing
behaviour), and so changing behaviour in the generic code to suit
XFS is likely to introduce subtle data corruption bugs in other
filesystems.

I think the best thing we can do is move away from bufferheads in
XFS. We've already got lots of hacky code to manage
bufferhead/extent state coherency and so the sooner we get rid of
bufferheads the sooner that crap goes away, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
