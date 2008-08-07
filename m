Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Aug 2008 10:22:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m77HMhGj018461
	for <xfs@oss.sgi.com>; Thu, 7 Aug 2008 10:22:43 -0700
Received: from wr-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39D6E373493
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2008 10:23:56 -0700 (PDT)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.229]) by cuda.sgi.com with ESMTP id FFYvfDrtrxYhcHMG for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 10:23:56 -0700 (PDT)
Received: by wr-out-0506.google.com with SMTP id 57so440709wri.12
        for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 10:23:56 -0700 (PDT)
Message-ID: <cc7060690808071023r6b29d6c0k9240eb677e78524e@mail.gmail.com>
Date: Thu, 7 Aug 2008 22:53:55 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: TAKE 981498 - use KM_MAYFAIL in xfs_mountfs
In-Reply-To: <20080806202256.GR21635@disturbed>
MIME-Version: 1.0
References: <20080806054121.CB2F258C52A4@chook.melbourne.sgi.com>
	 <cc7060690808061022i1dce01dfx9e43ad3a75e5c936@mail.gmail.com>
	 <489A01B0.5050606@sandeen.net> <20080806202256.GR21635@disturbed>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Bhagi rathi <jahnu77@gmail.com>, Lachlan McIlroy <lachlan@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Thu, Aug 7, 2008 at 1:52 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Aug 06, 2008 at 02:55:28PM -0500, Eric Sandeen wrote:
> > Bhagi rathi wrote:
> > > Why are we going to block for ever? Mounting a file-system
> > > requires in-core log space buffers, reading of other buffers
> > > which needs allocation of memory greater than per ag
> > > structures.
> .....
> > In general KM_MAYFAIL sounds like a good plan when you can handle the
> > failure gracefully, I think.
>
> Yes, and that is the long term plan - to remove all KM_SLEEP
> allocations from XFS and allow them to fail gracefully. There's
> lots of work needed before we get there, though. e.g.
> right now we cannot survive an ENOMEM error in a transaction....


 I am not sure that we are solving right problem. Isn't the above is
fall-out
 of XFS needing memory to clean dirty memory? That is of good priority
 to engineer than this handling of ENOMEM in transactions.


Cheers,
Bhagi.


>
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>


[[HTML alternate version deleted]]
