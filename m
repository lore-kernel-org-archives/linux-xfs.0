Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 21:40:48 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3K4eefB009871
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 21:40:41 -0700
Subject: Re: review: allocate bmapi args
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20070419082331.GW48531920@melbourne.sgi.com>
References: <20070419072505.GS48531920@melbourne.sgi.com>
	 <1176969062.6273.169.camel@edge>
	 <20070419082331.GW48531920@melbourne.sgi.com>
Content-Type: text/plain
Date: Fri, 20 Apr 2007 14:41:57 +1000
Message-Id: <1177044117.6273.203.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, 2007-04-19 at 18:23 +1000, David Chinner wrote:
> ...
> > Are you sure this is legit though?
> 
> It *must* be. We already rely on being able to do substantial
> amounts of allocation in this path....

Not necessarily, we only sometimes (for some values of BMAPI flags
I mean) do memory allocations.

> ...
> We modify the incore extent list as it grows and shrinks in this
> path. It is critical that we are able to allocate at least small 

Well, not always.  For cases where we modify the extents we must
call in here with Steve's funky I'm-in-a-transaction process-flag
set, which is the secret handshake for the memory allocator to not
use GFP_FS.  For cases where we are only reading the extent list,
we would not be doing allocations before and we'd not be protected
by that extra magic.  So now those paths can start getting ENOMEM
in places where that wouldn't have happened before.. I guess that
filesystem shutdowns could result, possibly.

> FWIW, I have done low memory testing and I wasn't about to trigger
> any problems.....

It would be a once-in-a-blue-moon type problem though, unfortunately;
one of the really-really-hard to trigger types of problem.

> > (Oh, and why the _zalloc?  Could just do an _alloc, since previous
> > code was using non-zeroed memory - so, should have been filling in
> > all fields).
> 
> Habit. And it doesn't hurt performance at all - we've got to take

Hrmmm... is there any point in having a non-zeroing interface at
all then?  I thought the non-zeroing version was about all using
the fact that you know you're going to overwrite all the fields
anyway shortly, so theres no point zeroing initially...

cheers.

-- 
Nathan
