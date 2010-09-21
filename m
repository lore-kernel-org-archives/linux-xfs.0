Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8LMXEi9032690 for <xfs@oss.sgi.com>; Tue, 21 Sep 2010 17:33:14 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54C74182E8E0
	for <xfs@oss.sgi.com>; Tue, 21 Sep 2010 15:34:06 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	I8NjTAeuHX0koOCJ for <xfs@oss.sgi.com>;
	Tue, 21 Sep 2010 15:34:06 -0700 (PDT)
Date: Wed, 22 Sep 2010 08:34:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/18] xfs: metadata and buffer cache scalability
	improvements
Message-ID: <20100921223403.GD2614@dastard>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284729700.5524.53.camel@doink> <20100921020203.GC2614@dastard>
	<1285086192.2024.17.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285086192.2024.17.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Tue, Sep 21, 2010 at 11:23:12AM -0500, Alex Elder wrote:
> On Tue, 2010-09-21 at 12:02 +1000, Dave Chinner wrote:
> > On Fri, Sep 17, 2010 at 08:21:40AM -0500, Alex Elder wrote:
> > > On Tue, 2010-09-14 at 20:55 +1000, Dave Chinner wrote:
> > > > This patchset has grown quite a bit - it started out as a "convert
> > > > the buffer cache to rbtrees" patch, and has gotten bigger as I
> > > > peeled the onion from one bottleneck to another.
> . . .
> 
> > 
> > All together, with the LRU code being reworked a bit w.r.t. stale
> > buffers and shrinker behaviour.
> > 
> > In reality, though, i don't think that separating them into separate
> > series make much sense. The order they are in right now is
> > bisectable and fairly logical....
> 
> I have been thinking about this since sending it.  I think my
> concern was not so much that they were all in one series.  It's
> more about the fact that you are doing a number of non-trivial
> changes, all together.  And as such my perception of the combined
> risk of committing them all at once is higher.  So what I was
> probably after was somehow being able to verify each chunk of
> the series separately, spilling them out gradually rather
> than all at once.
> 
> But in the end, I guess I agree with what you say.  If we could
> get some parts--like those you say are standalone--committed
> earlier (and then out for wider exposure sooner) that would be
> good, but otherwise it's OK as a single series.  I'll look for
> your next update, and will just wait for pull request(s) when
> you feel they're ready.

Ok, that sounds reaonable. I can split out all the stand
alone/cleanup stuff, and leave the functional changes to later. I'll
do a reorder later today.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
