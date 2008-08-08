Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Aug 2008 17:30:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m780Uab4012622
	for <xfs@oss.sgi.com>; Thu, 7 Aug 2008 17:30:38 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32E5EF193C2
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2008 17:31:51 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 7RXFd4EHHSqtbjt0 for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 17:31:51 -0700 (PDT)
Date: Fri, 8 Aug 2008 10:31:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: TAKE 981498 - use KM_MAYFAIL in xfs_mountfs
Message-ID: <20080808003147.GA24344@disturbed>
References: <20080806054121.CB2F258C52A4@chook.melbourne.sgi.com> <cc7060690808061022i1dce01dfx9e43ad3a75e5c936@mail.gmail.com> <489A01B0.5050606@sandeen.net> <20080806202256.GR21635@disturbed> <cc7060690808071023r6b29d6c0k9240eb677e78524e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc7060690808071023r6b29d6c0k9240eb677e78524e@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Lachlan McIlroy <lachlan@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Thu, Aug 07, 2008 at 10:53:55PM +0530, Bhagi rathi wrote:
> On Thu, Aug 7, 2008 at 1:52 AM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Wed, Aug 06, 2008 at 02:55:28PM -0500, Eric Sandeen wrote:
> > > Bhagi rathi wrote:
> > > > Why are we going to block for ever? Mounting a file-system
> > > > requires in-core log space buffers, reading of other buffers
> > > > which needs allocation of memory greater than per ag
> > > > structures.
> > .....
> > > In general KM_MAYFAIL sounds like a good plan when you can handle the
> > > failure gracefully, I think.
> >
> > Yes, and that is the long term plan - to remove all KM_SLEEP
> > allocations from XFS and allow them to fail gracefully. There's
> > lots of work needed before we get there, though. e.g.
> > right now we cannot survive an ENOMEM error in a transaction....
> 
> 
>  I am not sure that we are solving right problem. Isn't the above is
> fall-out
>  of XFS needing memory to clean dirty memory?

We can't avoid that. It is inherent in the design of XFS.  And the
amount of memory is not easily bounded so existing solutions like
wrapping slabs in mempools don't work, either.

>  That is of good priority
>  to engineer than this handling of ENOMEM in transactions.

That's just one example of an extremely non-trivial piece of work
that needs to be done to allow all memory allocations to fail.
This work will be done for other reasons (like transaction
rollback to prevent shutdowns on errors inside a dirty
transaction), not specifically to allow memory allocations
to fail.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
