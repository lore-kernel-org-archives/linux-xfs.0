Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7Q1CFxW005398 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 20:12:15 -0500
Subject: Re: [PATCH 2/6] xfs: don't serialise adjacent concurrent direct IO
	appending writes
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1314256626-11136-3-git-send-email-david@fromorbit.com>
References: <1314256626-11136-1-git-send-email-david@fromorbit.com>
	<1314256626-11136-3-git-send-email-david@fromorbit.com>
Date: Thu, 25 Aug 2011 16:08:03 -0500
Message-ID: <1314306483.3136.105.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-08-25 at 17:17 +1000, Dave Chinner wrote:
> For append write workloads, extending the file requires a certain
> amount of exclusive locking to be done up front to ensure sanity in
> things like ensuring that we've zeroed any allocated regions
> between the old EOF and the start of the new IO.
> 
> For single threads, this typically isn't a problem, and for large
> IOs we don't serialise enough for it to be a problem for two
> threads on really fast block devices. However for smaller IO and
> larger thread counts we have a problem.
> 
> Take 4 concurrent sequential, single block sized and aligned IOs.
> After the first IO is submitted but before it completes, we end up
> with this state:
> 
>         IO 1    IO 2    IO 3    IO 4
>       +-------+-------+-------+-------+
>       ^       ^
>       |       |
>       |       |
>       |       |
>       |       \- ip->i_new_size
>       \- ip->i_size
> 
> And the IO is done without exclusive locking because offset <=
> ip->i_size. When we submit IO 2, we see offset > ip->i_size, and
> grab the IO lock exclusive, because there is a chance we need to do
> EOF zeroing. However, there is already an IO in progress that avoids
> the need for IO zeroing because offset <= ip->i_new_size. hence we
> could avoid holding the IO lock exlcusive for this. Hence after
> submission of the second IO, we'd end up this state:
> 
>         IO 1    IO 2    IO 3    IO 4
>       +-------+-------+-------+-------+
>       ^               ^
>       |               |
>       |               |
>       |               |
>       |               \- ip->i_new_size
>       \- ip->i_size
> 
> There is no need to grab the i_mutex of the IO lock in exclusive
> mode if we don't need to invalidate the page cache. Taking these
> locks on every direct IO effective serialises them as taking the IO
> lock in exclusive mode has to wait for all shared holders to drop
> the lock. That only happens when IO is complete, so effective it
> prevents dispatch of concurrent direct IO writes to the same inode.
> 
> And so you can see that for the third concurrent IO, we'd avoid
> exclusive locking for the same reason we avoided the exclusive lock
> for the second IO.
> 
> Fixing this is a bit more complex than that, because we need to hold
> a write-submission local value of ip->i_new_size to that clearing
> the value is only done if no other thread has updated it before our
> IO completes.....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This looks good.  What did you do with the little
"If the IO is clearly not beyond the on-disk inode size,
return before we take locks" optimization in xfs_setfilesize()
from the last time you posted this?

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
