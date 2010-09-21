Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8LGMMv7018631 for <xfs@oss.sgi.com>; Tue, 21 Sep 2010 11:22:22 -0500
Subject: Re: [PATCH 0/18] xfs: metadata and buffer cache scalability
	improvements
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100921020203.GC2614@dastard>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284729700.5524.53.camel@doink>  <20100921020203.GC2614@dastard>
Date: Tue, 21 Sep 2010 11:23:12 -0500
Message-ID: <1285086192.2024.17.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Tue, 2010-09-21 at 12:02 +1000, Dave Chinner wrote:
> On Fri, Sep 17, 2010 at 08:21:40AM -0500, Alex Elder wrote:
> > On Tue, 2010-09-14 at 20:55 +1000, Dave Chinner wrote:
> > > This patchset has grown quite a bit - it started out as a "convert
> > > the buffer cache to rbtrees" patch, and has gotten bigger as I
> > > peeled the onion from one bottleneck to another.
. . .

> 
> All together, with the LRU code being reworked a bit w.r.t. stale
> buffers and shrinker behaviour.
> 
> In reality, though, i don't think that separating them into separate
> series make much sense. The order they are in right now is
> bisectable and fairly logical....

I have been thinking about this since sending it.  I think my
concern was not so much that they were all in one series.  It's
more about the fact that you are doing a number of non-trivial
changes, all together.  And as such my perception of the combined
risk of committing them all at once is higher.  So what I was
probably after was somehow being able to verify each chunk of
the series separately, spilling them out gradually rather
than all at once.

But in the end, I guess I agree with what you say.  If we could
get some parts--like those you say are standalone--committed
earlier (and then out for wider exposure sooner) that would be
good, but otherwise it's OK as a single series.  I'll look for
your next update, and will just wait for pull request(s) when
you feel they're ready.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
