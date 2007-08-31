Return-Path: <dgc@sgi.com>
Date: Sat, 1 Sep 2007 01:19:04 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Increase lockdep MAX_LOCK_DEPTH
Message-ID: <20070831151904.GC734179@sgi.com>
References: <46D79C62.1010304@sandeen.net> <1188542389.6112.44.camel@twins> <20070831135042.GD422459@sgi.com> <1188570831.6112.64.camel@twins> <20070831150511.GA734179@sgi.com> <1188572961.6112.72.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188572961.6112.72.camel@twins>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, Ingo Molnar <mingo@elte.hu>
List-ID: <xfs>

On Fri, Aug 31, 2007 at 05:09:21PM +0200, Peter Zijlstra wrote:
> On Sat, 2007-09-01 at 01:05 +1000, David Chinner wrote:
> 
> > > Trouble is, we'd like to have a sane upper bound on the amount of held
> > > locks at any one time, obviously this is just wanting, because a lot of
> > > lock chains also depend on the number of online cpus...
> > 
> > Sure - this is an obvious case where it is valid to take >30 locks at
> > once in a single thread. In fact, worst case here we are taking twice this
> > number of locks - we actually take 2 per inode (ilock and flock) so a
> > full 32 inode cluster free would take >60 locks in the middle of this
> > function and we should be busting this depth couter limit all the
> > time. 
> 
> I think this started because jeffpc couldn't boot without XFS busting
> lockdep :-)

Ok....

> > Do semaphores (the flush locks) contribute to the lock depth
> > counters? 
> 
> No, alas, we cannot handle semaphores in lockdep. Semaphores don't have
> a strict owner, hence we cannot track them. This is one of the reasons
> to rid ourselves of semaphores - that and there are very few cases where
> the actual semantics of semaphores are needed. Most of the times code
> using semaphores can be expressed with either a mutex or a completion.

Yeah, and the flush lock is something we can't really use either of those
for as we require both the multi-process lock/unlock behaviour and the
mutual exclusion that a semaphore provides.

So I guess that means it's only the ilock nesting that is of issue here,
so that means right now a max lock depth of 40 would probably be ok....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
