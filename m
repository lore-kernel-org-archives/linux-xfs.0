Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C04A37CA0
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 20:06:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 73E86304051
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 18:06:07 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tqTU8e7ZFJjekSeD for <xfs@oss.sgi.com>;
	Thu, 08 Sep 2016 18:06:04 -0700 (PDT)
Date: Fri, 9 Sep 2016 11:06:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160909010601.GC30056@dastard>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811234335.GX16044@dastard> <20160812025026.GA975@lst.de>
	<20160812095813.GZ16044@dastard> <20160905151529.GB16726@lst.de>
	<20160907214536.GQ30056@dastard>
	<20160908065442.GV10138@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160908065442.GV10138@twins.programming.kicks-ass.net>
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

On Thu, Sep 08, 2016 at 08:54:42AM +0200, Peter Zijlstra wrote:
> On Thu, Sep 08, 2016 at 07:45:36AM +1000, Dave Chinner wrote:
> > On Mon, Sep 05, 2016 at 05:15:29PM +0200, Christoph Hellwig wrote:
> > > Hi Dave,
> > > 
> > > I looked into killing the mrlock and ran into an unexpected problem.
> > > 
> > > Currently mr_writer tracks that there is someone holding a write lock,
> > > lockdep on the other hand checks if the calling thread has that lock.
> > > 
> > > While that generally is the right semantic, our hack to offload
> > > btree splits to a work item offends lockdep.  E.g. this callstack
> > > now asserts:
> > 
> > It's a semaphore, not a mutex. Semaphore locking is independent of
> > task context, the lock follows the object it protects, not the task
> > that took the lock. i.e. Lockdep is wrong to assume the "owner" of a
> > rw_sem will not change between lock and unlock.
> 
> We've added strict owner semantics to rwsem a long time ago.

/me sighs.

History repeats.

We went through all this crap about semaphores and strict ownership
a few years ago when someone tried to make the struct semaphore
require strict ownership and XFS went all explodey. :/

> If you want the actual semaphore semantics (which we greatly discourage,
> because you cannot do validation on it)

What you actually means is "you cannot use /lockdep/ on it", not
"cannot do validation" on it.  Indeed, this discussion started from
wanting to remove the wrappers that implement XFS context
specific locking validation on top of rwsems.

Yes, lockdep has it's uses, but let's not ignore the fact that it
also has significant limitations, introduces serious annotation
complexity for non-trivial locking models (e.g. XFS inodes), and
many people use it as a crutch to avoid thinking about locking
models (i.e. "lockdep doesn't complain, so it must be good!").

>From my perspective, lockdep is a very poor replacement for
architecting a robust locking model and then implementing code that
directly asserts that the correct locks are held at the correct
time. We trip over failed XFS locking asserts during development all
the time, but it's very, very rare to have lockdep tell us we have a
problem in XFS because we catch the problems long before lockdep
will notice them.

> you should use
> {down,up}_read_non_owner().
> I'm not sure we've got write_non_owner() variants for this.

For the case Christoph reported, it's the write side context of the
inode locks that is handed off to other threads. And no, we don't
have annotations for that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
