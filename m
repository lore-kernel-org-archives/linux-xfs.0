Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3H09guQ258137 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 19:09:42 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Q633YkMGjVZzRHty for <xfs@oss.sgi.com>;
	Mon, 16 Apr 2012 17:09:41 -0700 (PDT)
Date: Tue, 17 Apr 2012 10:09:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: task blocked on waiter in xfs_trans_dqlockedjoin()
Message-ID: <20120417000939.GB6734@dastard>
References: <4F8C1FDD.70600@dreamhost.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F8C1FDD.70600@dreamhost.com>
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
To: Alex Elder <elder@dreamhost.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 16, 2012 at 08:34:21AM -0500, Alex Elder wrote:
> I am getting the following warning while running xfstests.  I haven't
> started looking at it closely yet, but I wanted to report it so others
> could have a look.  The XFS code in use was at commit c922bbc819,

Which does not modify locking at all.

> with ad637a10f4 cherry-picked on top of it.  The tests all passed,

And that modifies the way we do inode reclaim synchronisation by
ILOCK rather than by IOLOCK|ILOCK. Neither of these are touching the
dquot locking at all, so I'm having trouble understanding why these
commits would cause a problem with a dquot mutex....

> so now I'm going to have to narrow down which test produces the failure
> (it was not near the first, nor the last test...).
> 
> Here is the source of the warning:
>         DEBUG_LOCKS_WARN_ON(ti->task->blocked_on != waiter);

That implies that the task is currently trying to acquire two
mutexes at once - which I can't see is possible. How different are
the two values i.e. are you seeing memory corruption?

Also, what case is the code running through? is it taking the
xfs_dqlock2() branch, and if so are the two dquots different?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
