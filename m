Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D618E7CA1
	for <xfs@oss.sgi.com>; Sat, 10 Sep 2016 19:17:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5800EAC001
	for <xfs@oss.sgi.com>; Sat, 10 Sep 2016 17:17:14 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iDxbyDUhwU56bJGD for <xfs@oss.sgi.com>;
	Sat, 10 Sep 2016 17:17:11 -0700 (PDT)
Date: Sun, 11 Sep 2016 10:17:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160911001708.GJ30056@dastard>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811234335.GX16044@dastard> <20160812025026.GA975@lst.de>
	<20160812095813.GZ16044@dastard> <20160905151529.GB16726@lst.de>
	<20160907214536.GQ30056@dastard>
	<20160908065442.GV10138@twins.programming.kicks-ass.net>
	<20160909010601.GC30056@dastard>
	<20160909082139.GE10153@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160909082139.GE10153@twins.programming.kicks-ass.net>
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
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Sep 09, 2016 at 10:21:39AM +0200, Peter Zijlstra wrote:
> On Fri, Sep 09, 2016 at 11:06:01AM +1000, Dave Chinner wrote:
> > On Thu, Sep 08, 2016 at 08:54:42AM +0200, Peter Zijlstra wrote:
> > From my perspective, lockdep is a very poor replacement for
> > architecting a robust locking model and then implementing code that
> > directly asserts that the correct locks are held at the correct
> > time.
> 
> Very few people people architect locking :-/,

And so lockdep was written to help catch such situations. Instead of
encouraging people more careful about locking, it has become a
crutch that people lean on: "if lockdep is silent, my locking must
be good now"...

Law of unintended consequences, eh?

> but lockdep as the assert,
> and I've been encouraging people to use that instead of comments like:
> 
>   /* this function should be called with foo lock held */

Yup, that's been a standard practice in XFS since day zero.  I'm
glad to see that locking development practices are slowly catching
up with the state of the art from the early 90s. :P

> Now, the problem is that lockdep also asserts the caller is the lock
> owner, and not some other random thing.

Yeah, it is does not handle the "lock follows object" model used by
multi-process asynchronous execution engines (which is pretty much
what the linux IO subsystem is). As XFS is likely to move more
towards async execution in future, the need for non-owner support in
semaphores is more important than ever...

> And given the amount of locking fail caught by lockdep (still..) you
> really cannot argue against it.

Sure, but I'm not saying "remove lockdep". What I'm saying is that
/lockdep does not define locking primitve behaviour/. Lockdep is
*only a debugging tool*.

IMO, it is wrong to restrict the semantics of a lock type because of
the limitations of a debugging tool. All that does is encourage
people to invent their own locking primitives that are hidden from
the debugging tool and are more likely to be broken than not. We've
done this several times in XFS, and we've even propagated such
frakenstein infrastructure into the VFS to save others the pain of
inventing their own non-owner exclusion mechanisms...

> > > you should use
> > > {down,up}_read_non_owner().
> > > I'm not sure we've got write_non_owner() variants for this.
> > 
> > For the case Christoph reported, it's the write side context of the
> > inode locks that is handed off to other threads. And no, we don't
> > have annotations for that.
> 
> So the xfs mrlock already uses rwsem, semantics have not changed. So the
> case Christoph found should already conform to the owner semantics.

Which, until there was "spin on owner" added to the rwsems, the
rwsem did not track ownership of the lock. i.e. prior to 2014
(commit 4fc828e "locking/rwsem: Support optimistic spinning"), the
rwsem contained:

struct rw_semaphore {
      long                    count;
      raw_spinlock_t          wait_lock;
      struct list_head        wait_list;
#ifdef CONFIG_DEBUG_LOCK_ALLOC
      struct lockdep_map      dep_map;
#endif
};

i.e. historically the only "ownership dependency" a rwsem has ever
had was added by lockdep, which then required annotations to tell
lockdep the usage model of the lock. And even now the optimistic
spinning code doesn't actually use the owner for checking ownership
- the value is simply a special cookie to determine if the lock is
held in read or write mode...

> I've not looked at code, but if the worker is synchronized against the
> critical section (it'd pretty much have to be to rely on its locking)
> there's nothing wrong, its just that the lockdep_assert_held() thingies
> cannot work as it.
> 
> That is:
> 
> 	task A				task B
> 
> 	down_write(&rwsem);
> 	queue_work(&work);
> 					worker()
> 					  lockdep_assert_held(&rwsem);
> 	flush_work(&work);
> 	up_write(&rwsem);
> 
> 
> Doesn't work. Explicitly so in fact.

Then lockdep behaviour is incorrect for rwsems. By definition,
semaphores have explicit non-owner semantics - a semaphore with
strict task ownership constraints is a mutex, not a semaphore....

> Does the worker have a pointer back to taskA ?

Nope. it runs the work while task A sleeps on a completion. When
it's done, task A is woken and it continues.

And, FWIW, we can take locks on objects (e.g. buffers) in task B
that are then released by task A, too.  Unsurprisingly, those
objects are also protected by semaphores, explicitly because of the
non-owner behaviour those object locks have...

> I could try something
> like lockdep_assert_held_by(lock, task), just need to be careful,
> the per-task lock state is just that, per-task, no serialization.

Add a lockdep init flag for rwsems to say "don't track owners" and
we'll set it on the rwsems we pass to other contexts. Then you can
make sure that lockdep asserts don't fire when we pass those locked
objects to other tasks and/or get locked/unlocked by different
tasks...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
