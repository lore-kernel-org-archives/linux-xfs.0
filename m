Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Aug 2008 10:17:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m77HHWPG017728
	for <xfs@oss.sgi.com>; Thu, 7 Aug 2008 10:17:33 -0700
Received: from wr-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5209C124CA89
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2008 10:18:47 -0700 (PDT)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.230]) by cuda.sgi.com with ESMTP id b4dkVsMXfVTi3BhD for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 10:18:47 -0700 (PDT)
Received: by wr-out-0506.google.com with SMTP id 57so438565wri.12
        for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 10:18:47 -0700 (PDT)
Message-ID: <cc7060690808071018n3a264ca3ld1368d27b5b2f59b@mail.gmail.com>
Date: Thu, 7 Aug 2008 22:48:46 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: TAKE 981498 - use KM_MAYFAIL in xfs_mountfs
In-Reply-To: <489A01B0.5050606@sandeen.net>
MIME-Version: 1.0
References: <20080806054121.CB2F258C52A4@chook.melbourne.sgi.com>
	 <cc7060690808061022i1dce01dfx9e43ad3a75e5c936@mail.gmail.com>
	 <489A01B0.5050606@sandeen.net>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Lachlan McIlroy <lachlan@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Thu, Aug 7, 2008 at 1:25 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

> Bhagi rathi wrote:
> > Why are we going to block for ever? Mounting a file-system
> > requires in-core log space buffers, reading of other buffers
> > which needs allocation of memory greater than per ag
> > structures.
> >
> > I am trying to understand why xfs_perag_t? Mount/Unmount
> > are not frequent activities, it is better for them to succeed
> > if operating system can allocate memory and take them
> > forward.
>
> But that's the big if, right?
>
> If the system is so starved that you can't get this memory to even start
> the mount process, I'm sure it's better to fail the mount with -ENOMEM
> than to add to the current system memory stress.


 Not really. It is going to fail many automated scripts.  We are designing
 for a problem that system  is starved with memory. It points to a bug
 in memory & system dirty state cleaning, they are the ideal problems
 to be solved this instead of this.  As long as system recovers, it is  good
 not to disturb automated scripts by introducing these kind of  unnecessary
 failures of the mount command.



>
>
> In general KM_MAYFAIL sounds like a good plan when you can handle the
> failure gracefully, I think.


 Not really. It fails mount gracefully, however, it needs administrative
action.
 It is expected that operating system will recover and functional without
 admin intervention.

Cheers,
Bhagi.

>
>
> -Eric
>


[[HTML alternate version deleted]]
