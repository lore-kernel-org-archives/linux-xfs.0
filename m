Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B2D957CA2
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 14:43:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 736988F8040
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 12:43:03 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id J3CiRRGuePG2uCUG (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Sep 2016 12:42:35 -0700 (PDT)
Date: Tue, 13 Sep 2016 21:42:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160913194226.GH5008@twins.programming.kicks-ass.net>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811234335.GX16044@dastard> <20160812025026.GA975@lst.de>
	<20160812095813.GZ16044@dastard> <20160905151529.GB16726@lst.de>
	<20160907214536.GQ30056@dastard>
	<20160908065442.GV10138@twins.programming.kicks-ass.net>
	<20160909010601.GC30056@dastard>
	<20160909082139.GE10153@twins.programming.kicks-ass.net>
	<20160911001708.GJ30056@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160911001708.GJ30056@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Sun, Sep 11, 2016 at 10:17:08AM +1000, Dave Chinner wrote:
> On Fri, Sep 09, 2016 at 10:21:39AM +0200, Peter Zijlstra wrote:
> > On Fri, Sep 09, 2016 at 11:06:01AM +1000, Dave Chinner wrote:
> > > On Thu, Sep 08, 2016 at 08:54:42AM +0200, Peter Zijlstra wrote:
> > > From my perspective, lockdep is a very poor replacement for
> > > architecting a robust locking model and then implementing code that
> > > directly asserts that the correct locks are held at the correct
> > > time.
> > 
> > Very few people people architect locking :-/,
> 
> And so lockdep was written to help catch such situations. Instead of
> encouraging people more careful about locking, it has become a
> crutch that people lean on: "if lockdep is silent, my locking must
> be good now"...

You know as well as anybody that with the number of people working on
the kernel you simply cannot 'encourage' to any level of practical
result.

Also, lockdep has caught, and I'm sure still does (although its mostly
invisible since people tend to not send out code with obvious lockdep
fail) locking fail in core kernel code, written by people who really do
know wth they're on about (mostly :-).

I understand you're frustrated, but really, you don't want to return to
the state of locking fail we had.

> Yup, that's been a standard practice in XFS since day zero.  I'm
> glad to see that locking development practices are slowly catching
> up with the state of the art from the early 90s. :P

Meh, asserts and testing invariants was well established in the 70s even
I think. They even had SMP back then :-)

> > Now, the problem is that lockdep also asserts the caller is the lock
> > owner, and not some other random thing.
> 
> Yeah, it is does not handle the "lock follows object" model used by
> multi-process asynchronous execution engines (which is pretty much
> what the linux IO subsystem is). As XFS is likely to move more
> towards async execution in future, the need for non-owner support in
> semaphores is more important than ever...

So we'll have to talk about that, because at the same time there's the
push towards RT.

> > And given the amount of locking fail caught by lockdep (still..) you
> > really cannot argue against it.
> 
> Sure, but I'm not saying "remove lockdep". What I'm saying is that
> /lockdep does not define locking primitve behaviour/. Lockdep is
> *only a debugging tool*.

If you make it too easy to not use the tool, it'll not be used.

Similarly, you very much want to discourage async locking in general,
because its impossible to do PI on it. Also, it really is harder to get
right.

And yes, IO is the special case here, and I realize you're having pain.

> IMO, it is wrong to restrict the semantics of a lock type because of
> the limitations of a debugging tool. All that does is encourage
> people to invent their own locking primitives that are hidden from
> the debugging tool and are more likely to be broken than not. We've
> done this several times in XFS, and we've even propagated such
> frakenstein infrastructure into the VFS to save others the pain of
> inventing their own non-owner exclusion mechanisms...

I'm sure I don't know the details of what you're referring to. But
general infrastructure is better than many copies.

> > So the xfs mrlock already uses rwsem, semantics have not changed. So the
> > case Christoph found should already conform to the owner semantics.
> 
> Which, until there was "spin on owner" added to the rwsems, the
> rwsem did not track ownership of the lock. i.e. prior to 2014
> (commit 4fc828e "locking/rwsem: Support optimistic spinning"), the
> rwsem contained:
> 
> struct rw_semaphore {
>       long                    count;
>       raw_spinlock_t          wait_lock;
>       struct list_head        wait_list;
> #ifdef CONFIG_DEBUG_LOCK_ALLOC
>       struct lockdep_map      dep_map;
> #endif
> };
> 
> i.e. historically the only "ownership dependency" a rwsem has ever
> had was added by lockdep, which then required annotations to tell
> lockdep the usage model of the lock. And even now the optimistic
> spinning code doesn't actually use the owner for checking ownership
> - the value is simply a special cookie to determine if the lock is
> held in read or write mode...

Not entirely accurate, the RT patches actually did the ownership thing
before lockdep (lockdep was born out of RT running into a giant heap of
locking fail).

RT needs ownership because of PI.

And I realize RT isn't in mainline and therefore is less visible, but
people are now spending moneys on getting this 'fixed', there's a
Linux Foundation project for it etc..

But yes, the spin-on-owner is an optimization that's clearly taking
advantage of actually having an owner.

> > I've not looked at code, but if the worker is synchronized against the
> > critical section (it'd pretty much have to be to rely on its locking)
> > there's nothing wrong, its just that the lockdep_assert_held() thingies
> > cannot work as it.
> > 
> > That is:
> > 
> > 	task A				task B
> > 
> > 	down_write(&rwsem);
> > 	queue_work(&work);
> > 					worker()
> > 					  lockdep_assert_held(&rwsem);
> > 	flush_work(&work);
> > 	up_write(&rwsem);
> > 
> > 
> > Doesn't work. Explicitly so in fact.
> 
> Then lockdep behaviour is incorrect for rwsems. By definition,
> semaphores have explicit non-owner semantics - a semaphore with
> strict task ownership constraints is a mutex, not a semaphore....

I know, there's been a fair number of discussions on renaming the thing;
but we've never actually managed to come up with a 'better' name.

rw-mutex is equally silly, because MutEx stands for Mutual-Exclusion,
which is very much not the case for the reader part. rwlock is already
taken by the spinning variant.

Also, renaming the thing is a massive pain :-)

But really, at this point rwsem should not be considered a traditional
semaphore, whatever the name says.

Also, strictly speaking, a semaphore is a counter that blocks on going
0, the rwsem cannot be a counting sem in order to actually provide the
exclusive state (w) (nor for the 'unlimited' (r)). Therefore
they've never actually been proper semaphores to begin with and one can
argue the thing has been a misnomer from the very start.

> > Does the worker have a pointer back to taskA ?
> 
> Nope. it runs the work while task A sleeps on a completion. When
> it's done, task A is woken and it continues.

Sure, but that doesn't preclude getting the owner, but I understand this
is a special hack to get around stack size limits.

> And, FWIW, we can take locks on objects (e.g. buffers) in task B
> that are then released by task A, too.  Unsurprisingly, those
> objects are also protected by semaphores, explicitly because of the
> non-owner behaviour those object locks have...

In general, or in this specific case?

For this specific case, we could actually teach lockdep to transfer
owner back and forth since they're fully serialized.

> > I could try something
> > like lockdep_assert_held_by(lock, task), just need to be careful,
> > the per-task lock state is just that, per-task, no serialization.
> 
> Add a lockdep init flag for rwsems to say "don't track owners" and
> we'll set it on the rwsems we pass to other contexts. Then you can
> make sure that lockdep asserts don't fire when we pass those locked
> objects to other tasks and/or get locked/unlocked by different
> tasks...

With the spin-on-owner there's more than just lockdep that wants this
owner thing.


In any case, as Christoph already indicated, we can talk about solutions
for the IO case, but I would very much like to not introduce (more)
async locking primitives for generic use, such things subvert PI and
could tempt Joe random Dev to write 'creative' code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
