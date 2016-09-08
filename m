Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7A3D17CB5
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 01:54:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D33A304048
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2016 23:54:52 -0700 (PDT)
Received: from merlin.infradead.org (merlin.infradead.org [205.233.59.134]) by
	cuda.sgi.com with ESMTP id AW9BzjxW9RnMqHHe (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Sep 2016 23:54:46 -0700 (PDT)
Date: Thu, 8 Sep 2016 08:54:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160908065442.GV10138@twins.programming.kicks-ass.net>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811234335.GX16044@dastard> <20160812025026.GA975@lst.de>
	<20160812095813.GZ16044@dastard> <20160905151529.GB16726@lst.de>
	<20160907214536.GQ30056@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160907214536.GQ30056@dastard>
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

On Thu, Sep 08, 2016 at 07:45:36AM +1000, Dave Chinner wrote:
> On Mon, Sep 05, 2016 at 05:15:29PM +0200, Christoph Hellwig wrote:
> > Hi Dave,
> > 
> > I looked into killing the mrlock and ran into an unexpected problem.
> > 
> > Currently mr_writer tracks that there is someone holding a write lock,
> > lockdep on the other hand checks if the calling thread has that lock.
> > 
> > While that generally is the right semantic, our hack to offload
> > btree splits to a work item offends lockdep.  E.g. this callstack
> > now asserts:
> 
> It's a semaphore, not a mutex. Semaphore locking is independent of
> task context, the lock follows the object it protects, not the task
> that took the lock. i.e. Lockdep is wrong to assume the "owner" of a
> rw_sem will not change between lock and unlock.

We've added strict owner semantics to rwsem a long time ago.

If you want the actual semaphore semantics (which we greatly discourage,
because you cannot do validation on it) you should use
{down,up}_read_non_owner().

I'm not sure we've got write_non_owner() variants for this.

Turns out, there really are very few 'semaphore' users.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
