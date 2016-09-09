Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EF4467CA1
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 03:33:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5FD4FAC004
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 01:33:12 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 0VdBEJPmmGkMj1uM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Sep 2016 01:33:08 -0700 (PDT)
Date: Fri, 9 Sep 2016 10:33:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160909083306.GA19964@lst.de>
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
Cc: peterz@infradead.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Sep 08, 2016 at 07:45:36AM +1000, Dave Chinner wrote:
> It's a semaphore, not a mutex. Semaphore locking is independent of
> task context, the lock follows the object it protects, not the task
> that took the lock. i.e. Lockdep is wrong to assume the "owner" of a
> rw_sem will not change between lock and unlock.

That's not the case - rw_semaphores had strict owner semanics for a
long time (although I wish we could get rid of that for a different
reason..).

The problem here is not that we have different tasks acquire and release
the lock - it's always the same.

The "problem" is that that we hand off work to a different task inbetween
and that task asserts that the lock is held.  With the old mrlock hack
our islocked macros would return true as long as _someone_ holds the
lock, while lockdep is generally more strict and wants the current
process to hold the lock.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
