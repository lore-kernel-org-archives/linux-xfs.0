Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 05:20:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QCKFhQ015980
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 05:20:16 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74C7112CBC02
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 05:21:15 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id MVCsAdtNA3Gmeuor for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 05:21:15 -0700 (PDT)
Date: Thu, 26 Jun 2008 22:21:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080626122112.GL11558@disturbed>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <20080626112612.GW4392@parisc-linux.org> <20080626113209.GK11558@disturbed> <20080626114242.GX4392@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626114242.GX4392@parisc-linux.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthew Wilcox <matthew@wil.cx>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 05:42:42AM -0600, Matthew Wilcox wrote:
> On Thu, Jun 26, 2008 at 09:32:09PM +1000, Dave Chinner wrote:
> > On Thu, Jun 26, 2008 at 05:26:12AM -0600, Matthew Wilcox wrote:
> > > On Thu, Jun 26, 2008 at 02:41:12PM +1000, Dave Chinner wrote:
> > > > XFS object flushing doesn't quite match existing completion semantics.  It
> > > > mixed exclusive access with completion. That is, we need to mark an object as
> > > > being flushed before flushing it to disk, and then block any other attempt to
> > > > flush it until the completion occurs.
> > > 
> > > This sounds like mutex semantics.  Why are the existing mutexes not
> > > appropriate for your needs?
> > 
> > Different threads doing wait and complete.
> 
> Then let's leave it as a semaphore.  You can get rid of the sema_t if
> you like, but I don't think that turning completions into semaphores is
> a good idea (because it's confusing).

So remind me what the point of the semaphore removal tree is again?

As Christoph suggested, I can put this under another API that
is implemented using completions. If I have to do that in XFS,
so be it....

The main reason for this that we've just uncovered the fact that the
way XFS uses semaphores is completely unsafe [*] on x86/x86_64 for
kernels prior to the new generic semaphores.

[*] 2.6.20 panics in up() because of this race when I/O completion
(the up call) races with a simultaneous down() (iowaiter):

	T1		T2
	up()		down()
			kmem_free()

When the down() call completes, the up() call can still be
referencing the semaphore, and hence if we free the structure after
the down call then the up() will reference freed memory.  This is
probably the cause of many unexplained log replay or unmount panics
that we've been hitting for years with buffers that been freed while
apparently still in use....

Hence I'd prefer just to move completely away from semaphores for
this flush interface.  I'd like to start with getting the upstream
code fixed in a sane manner so all the backports to older kernels
start from the same series of commits.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
