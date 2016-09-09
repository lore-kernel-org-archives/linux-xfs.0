Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AE0477CA1
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 03:21:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2AEA3AC002
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 01:21:42 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gSH5Ado63iCKQEzT (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Sep 2016 01:21:41 -0700 (PDT)
Date: Fri, 9 Sep 2016 10:21:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160909082139.GE10153@twins.programming.kicks-ass.net>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811234335.GX16044@dastard> <20160812025026.GA975@lst.de>
	<20160812095813.GZ16044@dastard> <20160905151529.GB16726@lst.de>
	<20160907214536.GQ30056@dastard>
	<20160908065442.GV10138@twins.programming.kicks-ass.net>
	<20160909010601.GC30056@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160909010601.GC30056@dastard>
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
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Sep 09, 2016 at 11:06:01AM +1000, Dave Chinner wrote:
> On Thu, Sep 08, 2016 at 08:54:42AM +0200, Peter Zijlstra wrote:

> > We've added strict owner semantics to rwsem a long time ago.
> 
> /me sighs.
> 
> History repeats.

I doubt it, this was 2006 we're talking about.

> From my perspective, lockdep is a very poor replacement for
> architecting a robust locking model and then implementing code that
> directly asserts that the correct locks are held at the correct
> time.

Very few people people architect locking :-/, but lockdep as the assert,
and I've been encouraging people to use that instead of comments like:

  /* this function should be called with foo lock held */

Now, the problem is that lockdep also asserts the caller is the lock
owner, and not some other random thing.

And given the amount of locking fail caught by lockdep (still..) you
really cannot argue against it.

Sure its a pain at times, but so is pretty much everything.

> > you should use
> > {down,up}_read_non_owner().
> > I'm not sure we've got write_non_owner() variants for this.
> 
> For the case Christoph reported, it's the write side context of the
> inode locks that is handed off to other threads. And no, we don't
> have annotations for that.

So the xfs mrlock already uses rwsem, semantics have not changed. So the
case Christoph found should already conform to the owner semantics.

I've not looked at code, but if the worker is synchronized against the
critical section (it'd pretty much have to be to rely on its locking)
there's nothing wrong, its just that the lockdep_assert_held() thingies
cannot work as it.

That is:

	task A				task B

	down_write(&rwsem);
	queue_work(&work);
					worker()
					  lockdep_assert_held(&rwsem);
	flush_work(&work);
	up_write(&rwsem);


Doesn't work. Explicitly so in fact.

Does the worker have a pointer back to taskA ? I could try something
like lockdep_assert_held_by(lock, task), just need to be careful,
the per-task lock state is just that, per-task, no serialization.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
