Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 05:39:12 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QCd9ZT019025
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 05:39:09 -0700
Received: from mail.parisc-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE1DE182BB0B
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 05:40:10 -0700 (PDT)
Received: from mail.parisc-linux.org (palinux.external.hp.com [192.25.206.14]) by cuda.sgi.com with ESMTP id P9JbgbcGFPgJCuS4 for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 05:40:10 -0700 (PDT)
Date: Thu, 26 Jun 2008 06:40:09 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush requirements
Message-ID: <20080626124009.GY4392@parisc-linux.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <20080626112612.GW4392@parisc-linux.org> <20080626113209.GK11558@disturbed> <20080626114242.GX4392@parisc-linux.org> <20080626122112.GL11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626122112.GL11558@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 10:21:12PM +1000, Dave Chinner wrote:
> On Thu, Jun 26, 2008 at 05:42:42AM -0600, Matthew Wilcox wrote:
> > Then let's leave it as a semaphore.  You can get rid of the sema_t if
> > you like, but I don't think that turning completions into semaphores is
> > a good idea (because it's confusing).
> 
> So remind me what the point of the semaphore removal tree is again?

To remove the semaphores which don't need to be semaphores any more.

> As Christoph suggested, I can put this under another API that
> is implemented using completions. If I have to do that in XFS,
> so be it....

You could, yes.  But you could just use completions directly ...

> The main reason for this that we've just uncovered the fact that the
> way XFS uses semaphores is completely unsafe [*] on x86/x86_64 for
> kernels prior to the new generic semaphores.
> 
> [*] 2.6.20 panics in up() because of this race when I/O completion
> (the up call) races with a simultaneous down() (iowaiter):
> 
> 	T1		T2
> 	up()		down()
> 			kmem_free()
> 
> When the down() call completes, the up() call can still be
> referencing the semaphore, and hence if we free the structure after
> the down call then the up() will reference freed memory.  This is
> probably the cause of many unexplained log replay or unmount panics
> that we've been hitting for years with buffers that been freed while
> apparently still in use....

This is exactly the kind of thing completions were supposed to be used
for.  T1 should be calling complete() and T2 should be calling
wait_for_completion().

> Hence I'd prefer just to move completely away from semaphores for
> this flush interface.  I'd like to start with getting the upstream
> code fixed in a sane manner so all the backports to older kernels
> start from the same series of commits.

That's sane.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
