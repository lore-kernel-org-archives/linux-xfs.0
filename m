Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Aug 2008 22:21:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m785LZLA017654
	for <xfs@oss.sgi.com>; Thu, 7 Aug 2008 22:21:36 -0700
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 243F211F5CEF
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2008 22:22:50 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.169]) by cuda.sgi.com with ESMTP id Ai7uBcbotS4Ptxyz for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 22:22:50 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 26so698268wfd.32
        for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 22:22:50 -0700 (PDT)
Message-ID: <cc7060690808072222k759fe0cer4c8c1ee66d40989b@mail.gmail.com>
Date: Fri, 8 Aug 2008 10:52:50 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: TAKE 981498 - use KM_MAYFAIL in xfs_mountfs
In-Reply-To: <20080808003147.GA24344@disturbed>
MIME-Version: 1.0
References: <20080806054121.CB2F258C52A4@chook.melbourne.sgi.com>
	 <cc7060690808061022i1dce01dfx9e43ad3a75e5c936@mail.gmail.com>
	 <489A01B0.5050606@sandeen.net> <20080806202256.GR21635@disturbed>
	 <cc7060690808071023r6b29d6c0k9240eb677e78524e@mail.gmail.com>
	 <20080808003147.GA24344@disturbed>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, Lachlan McIlroy <lachlan@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Fri, Aug 8, 2008 at 6:01 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Aug 07, 2008 at 10:53:55PM +0530, Bhagi rathi wrote:
> > On Thu, Aug 7, 2008 at 1:52 AM, Dave Chinner <david@fromorbit.com>
> wrote:
> >
> > > On Wed, Aug 06, 2008 at 02:55:28PM -0500, Eric Sandeen wrote:
> > > > Bhagi rathi wrote:
> > > > > Why are we going to block for ever? Mounting a file-system
> > > > > requires in-core log space buffers, reading of other buffers
> > > > > which needs allocation of memory greater than per ag
> > > > > structures.
> > > .....
> > > > In general KM_MAYFAIL sounds like a good plan when you can handle the
> > > > failure gracefully, I think.
> > >
> > > Yes, and that is the long term plan - to remove all KM_SLEEP
> > > allocations from XFS and allow them to fail gracefully. There's
> > > lots of work needed before we get there, though. e.g.
> > > right now we cannot survive an ENOMEM error in a transaction....
> >
> >
> >  I am not sure that we are solving right problem. Isn't the above is
> > fall-out
> >  of XFS needing memory to clean dirty memory?
>
> We can't avoid that. It is inherent in the design of XFS.  And the
> amount of memory is not easily bounded so existing solutions like
> wrapping slabs in mempools don't work, either.


 Interesting. The only dirty items are xfs inodes,  quota's and
 meta-data buffers.  We can fixed number of these items and
 ensure pushing of data  one after the other in the case of crunch.

 What are the objects of dirty data where the memory is not bounded?


>
> >  That is of good priority
> >  to engineer than this handling of ENOMEM in transactions.
>
> That's just one example of an extremely non-trivial piece of work
> that needs to be done to allow all memory allocations to fail.
> This work will be done for other reasons (like transaction
> rollback to prevent shutdowns on errors inside a dirty
> transaction), not specifically to allow memory allocations
> to fail.


Yes. I agree.

-Saradhi.


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>


[[HTML alternate version deleted]]
