Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6SCsKVt251108 for <xfs@oss.sgi.com>; Wed, 28 Jul 2010 07:54:22 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2BB3111A565D
	for <xfs@oss.sgi.com>; Wed, 28 Jul 2010 06:04:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	8cTq95ur6TIcQHr5 for <xfs@oss.sgi.com>;
	Wed, 28 Jul 2010 06:04:49 -0700 (PDT)
Date: Wed, 28 Jul 2010 22:57:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: VFS scalability git tree
Message-ID: <20100728125717.GI655@dastard>
References: <20100722190100.GA22269@amd> <20100723135514.GJ32635@dastard>
	<20100727070538.GA2893@amd> <20100727080632.GA4958@amd>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100727080632.GA4958@amd>
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
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 27, 2010 at 06:06:32PM +1000, Nick Piggin wrote:
> On Tue, Jul 27, 2010 at 05:05:39PM +1000, Nick Piggin wrote:
> > On Fri, Jul 23, 2010 at 11:55:14PM +1000, Dave Chinner wrote:
> > > On Fri, Jul 23, 2010 at 05:01:00AM +1000, Nick Piggin wrote:
> > > > I'm pleased to announce I have a git tree up of my vfs scalability work.
> > > > 
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
> > > > http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git
> > > > 
> > > > Branch vfs-scale-working
> > > 
> > > With a production build (i.e. no lockdep, no xfs debug), I'll
> > > run the same fs_mark parallel create/unlink workload to show
> > > scalability as I ran here:
> > > 
> > > http://oss.sgi.com/archives/xfs/2010-05/msg00329.html
> > 
> > I've made a similar setup, 2s8c machine, but using 2GB ramdisk instead
> > of a real disk (I don't have easy access to a good disk setup ATM, but
> > I guess we're more interested in code above the block layer anyway).
> > 
> > Made an XFS on /dev/ram0 with 16 ags, 64MB log, otherwise same config as
> > yours.
> > 
> > I found that performance is a little unstable, so I sync and echo 3 >
> > drop_caches between each run. When it starts reclaiming memory, things
> > get a bit more erratic (and XFS seemed to be almost livelocking for tens
> > of seconds in inode reclaim).
> 
> So about this XFS livelock type thingy. It looks like this, and happens
> periodically while running the above fs_mark benchmark requiring reclaim
> of inodes:
....

> Nothing much happening except 100% system time for seconds at a time
> (length of time varies). This is on a ramdisk, so it isn't waiting
> for IO.
> 
> During this time, lots of things are contending on the lock:
> 
>     60.37%         fs_mark  [kernel.kallsyms]   [k] __write_lock_failed
>      4.30%         kswapd0  [kernel.kallsyms]   [k] __write_lock_failed
>      3.70%         fs_mark  [kernel.kallsyms]   [k] try_wait_for_completion
>      3.59%         fs_mark  [kernel.kallsyms]   [k] _raw_write_lock
>      3.46%         kswapd1  [kernel.kallsyms]   [k] __write_lock_failed
>                    |
>                    --- __write_lock_failed
>                       |
>                       |--99.92%-- xfs_inode_ag_walk
>                       |          xfs_inode_ag_iterator
>                       |          xfs_reclaim_inode_shrink
>                       |          shrink_slab
>                       |          shrink_zone
>                       |          balance_pgdat
>                       |          kswapd
>                       |          kthread
>                       |          kernel_thread_helper
>                        --0.08%-- [...]
> 
>      3.02%         fs_mark  [kernel.kallsyms]   [k] _raw_spin_lock
>      1.82%         fs_mark  [kernel.kallsyms]   [k] _xfs_buf_find
>      1.16%         fs_mark  [kernel.kallsyms]   [k] memcpy
>      0.86%         fs_mark  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave
>      0.75%         fs_mark  [kernel.kallsyms]   [k] xfs_log_commit_cil
>                    |
>                    --- xfs_log_commit_cil
>                        _xfs_trans_commit
>                       |
>                       |--60.00%-- xfs_remove
>                       |          xfs_vn_unlink
>                       |          vfs_unlink
>                       |          do_unlinkat
>                       |          sys_unlink
> 
> I'm not sure if there was a long-running read locker in there causing
> all the write lockers to fail, or if they are just running into one
> another.

The longest hold is in the inode cluster writeback
(xfs_iflush_cluster), but if there is no IO then I don't see how
that would be a problem.

I suspect that it might be caused by having several CPUs
all trying to run the shrinker at the same time and them all
starting at the same AG and therefore lockstepping and getting
nothing done because they are all scanning the same inodes.

Maybe a start AG rotor for xfs_inode_ag_iterator() is needed to
avoid this lockstepping.  I've attached a patch below to do this
- can you give it a try?

> But anyway, I hacked the following patch which seemed to
> improve that behaviour. I haven't run any throughput numbers on it yet,
> but I could if you're interested (and it's not completely broken!)

Batching is certainly something that I have been considering, but
apart from the excessive scanning bug, the per-ag inode tree lookups
hve not featured prominently in any profiling I've done, so it
hasn't been a high priority.

You patch looks like it will work fine, but I think it can be made a
lot cleaner. I'll have a closer look at this once I get to the bottom of
the dbench hang you are seeing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: add an AG iterator start rotor

From: Dave Chinner <dchinner@redhat.com>

To avoid multiple CPUs from executing inode cache shrinkers on the same AG all
at the same time, make every shrinker call start on a different AG. This will
mostly prevent concurrent shrinker calls from competing for the serialising
pag_ici_lock and lock-stepping reclaim.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   11 ++++++++++-
 fs/xfs/xfs_mount.h          |    1 +
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index dfcbd98..5322105 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -181,11 +181,14 @@ xfs_inode_ag_iterator(
 	struct xfs_perag	*pag;
 	int			error = 0;
 	int			last_error = 0;
+	xfs_agnumber_t		start_ag;
 	xfs_agnumber_t		ag;
 	int			nr;
+	int			looped = 0;
 
 	nr = nr_to_scan ? *nr_to_scan : INT_MAX;
-	ag = 0;
+	start_ag = atomic_inc_return(&mp->m_agiter_rotor) & mp->m_sb.sb_agcount;
+	ag = start_ag;
 	while ((pag = xfs_inode_ag_iter_next_pag(mp, &ag, tag))) {
 		error = xfs_inode_ag_walk(mp, pag, execute, flags, tag,
 						exclusive, &nr);
@@ -197,6 +200,12 @@ xfs_inode_ag_iterator(
 		}
 		if (nr <= 0)
 			break;
+		if (ag >= mp->m_sb.sb_agcount) {
+			looped = 1;
+			ag = 0;
+		}
+		if (ag >= start_ag && looped)
+			break;
 	}
 	if (nr_to_scan)
 		*nr_to_scan = nr;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 622da21..fae61bb 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -199,6 +199,7 @@ typedef struct xfs_mount {
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
 	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
+	atomic_t		m_agiter_rotor; /* ag iterator start rotor */
 } xfs_mount_t;
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
