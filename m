Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 816697F59
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 17:16:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 723B38F804C
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 15:16:17 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	etXn7i07WFJr7GEE for <xfs@oss.sgi.com>;
	Tue, 12 May 2015 15:16:14 -0700 (PDT)
Date: Wed, 13 May 2015 08:15:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: any chance for xfs shrinking?
Message-ID: <20150512221534.GI15721@dastard>
References: <5551EBB2.9010508@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5551EBB2.9010508@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, May 12, 2015 at 02:01:54PM +0200, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> while cloud / vms usage become more and more popular and qemu now also
> offers memory hot add and unplug, cpu hot add and unplug, we still
> suffer from a missing xfs shrink.

Over the years lots of people have come along and said "we want to
implement shrink" and we've pointed them at the pieces that need to
be put together to make it work. However, shrink is a terribly complex
operation which, as Eric has pointed out, scrambles the filesystem
up badly, and so for the most part it isn't a desired operation
to perform on a filesystem.

The reality is that nobody has needed shrink badly enough to push
such a complex set of operations through to completion, or fund a
developer to push it through to completion. Note that it's not just
code that needs to be written, the verification of shrink behaviour
and correctness is also difficult and time consuming.

> I would like to continue to use XFS as it is a rock solid base since
> around 10 years for us.
> 
> But one missing piece in variable ressource usage for us is disk
> shrinking. Is there any chance to get an xfs online shrinking?

In a world of infinite resources at my disposal, I'd say yes. But
when I already have a backlog of development work longer than my
arm, finding 3-6 months to implement shrink is not easy to
accomplish. And, really, reverse mapping btrees and parent pointers
come first so that shrink can be implemented efficiently (shrink
needs reverse block-to-path mapping), and that's another 6 months
worth of work before shrink....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
