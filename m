Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0L5Ps5e221614 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 23:25:55 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2734B148BB33
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 21:28:13 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AAG8DmchX09D8Cum for <xfs@oss.sgi.com>;
	Thu, 20 Jan 2011 21:28:13 -0800 (PST)
Date: Fri, 21 Jan 2011 16:28:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] Re: XFS deadlock in 2.6.37
Message-ID: <20110121052802.GA16267@dastard>
References: <alpine.DEB.2.00.1101201702260.29071@callisto.malc.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101201702260.29071@callisto.malc.org.uk>
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
To: Malcolm Scott <lkml@malc.org.uk>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

[cc xfs@os.sgi.com]

On Thu, Jan 20, 2011 at 05:08:45PM +0000, Malcolm Scott wrote:
> Hi all,
> 
> I've had the following deadlock happen twice on a 2.6.37 system with
> several XFS filesystems (including root) and no swap (may be
> relevant, considering that kswapd is one task involved here).  Some
> minor filesystem corruption resulted (but maybe only because the
> root fs couldn't be synced/umounted).
> 
> If you need any more info, please let me know.
> 
> --- first crash ---
> 
> [504603.250208] INFO: task kswapd0:37 blocked for more than 120 seconds.
> [504603.261107] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [504603.273465] kswapd0       D 0000000000000003     0    37      2 0x00000000
> [504603.273473]  ffff88034428bc10 0000000000000046 ffff88034428bfd8 ffff88034428a000
> [504603.273479]  0000000000013a80 ffff8803442903a0 ffff88034428bfd8 0000000000013a80
> [504603.273483]  ffff88034572ad80 ffff880344290000 ffffffffffffff10 ffff880343a51e28
> [504603.273488] Call Trace:
> [504603.273500]  [<ffffffff815ce917>] __mutex_lock_slowpath+0xf7/0x180
> [504603.273504]  [<ffffffff815ce303>] mutex_lock+0x23/0x50
> [504603.273541]  [<ffffffffa00cf709>] xfs_qm_dqreclaim_one+0x29/0x350 [xfs]
> [504603.273554]  [<ffffffffa00cfaed>] xfs_qm_shake_freelist+0x1d/0x40 [xfs]
> [504603.273567]  [<ffffffffa00cfb69>] xfs_qm_shake+0x59/0x70 [xfs]
> [504603.273573]  [<ffffffff8111d619>] shrink_slab+0x89/0x180
> [504603.273577]  [<ffffffff81120420>] balance_pgdat+0x2b0/0x530
> [504603.273580]  [<ffffffff811207df>] kswapd+0x13f/0x2b0
> [504603.273585]  [<ffffffff81087d30>] ? autoremove_wake_function+0x0/0x40
> [504603.273588]  [<ffffffff811206a0>] ? kswapd+0x0/0x2b0
> [504603.273591]  [<ffffffff81087606>] kthread+0x96/0xa0
> [504603.273596]  [<ffffffff8100cea4>] kernel_thread_helper+0x4/0x10
> [504603.273599]  [<ffffffff81087570>] ? kthread+0x0/0xa0
> [504603.273603]  [<ffffffff8100cea0>] ? kernel_thread_helper+0x0/0x10

[snip]

Looks like everything is hung up on the freelist lock. Can you
test the patch below?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: fix dquot shaker deadlock

From: Dave Chinner <dchinner@redhat.com>

Commit 368e136 ("xfs: remove duplicate code from dquot reclaim") fails
to unlock the dquot freelist when the number of loop restarts is
exceeded in xfs_qm_dqreclaim_one(). This causes hangs in memory
reclaim. Remove the bogus loop exit check that causes the problem.

Reported-by: Malcolm Scott <lkml@malc.org.uk>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/quota/xfs_qm.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index f8e854b..9431c56 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -1992,8 +1992,6 @@ dqfunlock:
 		xfs_dqunlock(dqp);
 		if (dqpout)
 			break;
-		if (restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
-			return NULL;
 	}
 	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 	return dqpout;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
