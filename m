Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C66AF7CA7
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2016 16:45:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 86D51304032
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2016 14:45:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oFwuC5R1i7pf0MAN for <xfs@oss.sgi.com>;
	Wed, 07 Sep 2016 14:45:38 -0700 (PDT)
Date: Thu, 8 Sep 2016 07:45:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160907214536.GQ30056@dastard>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811234335.GX16044@dastard> <20160812025026.GA975@lst.de>
	<20160812095813.GZ16044@dastard> <20160905151529.GB16726@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160905151529.GB16726@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: peterz@infradead.org, xfs@oss.sgi.com

On Mon, Sep 05, 2016 at 05:15:29PM +0200, Christoph Hellwig wrote:
> Hi Dave,
> 
> I looked into killing the mrlock and ran into an unexpected problem.
> 
> Currently mr_writer tracks that there is someone holding a write lock,
> lockdep on the other hand checks if the calling thread has that lock.
> 
> While that generally is the right semantic, our hack to offload
> btree splits to a work item offends lockdep.  E.g. this callstack
> now asserts:

It's a semaphore, not a mutex. Semaphore locking is independent of
task context, the lock follows the object it protects, not the task
that took the lock. i.e. Lockdep is wrong to assume the "owner" of a
rw_sem will not change between lock and unlock.

> While it previously did fine.  I fear there might be other locking
> asserts in the code called from that work item as well.

Probably.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
