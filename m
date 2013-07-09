Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B4737F4E
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 03:26:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D5D48F8037
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 01:26:44 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wrUvcamMXif8CoLb for <xfs@oss.sgi.com>;
	Tue, 09 Jul 2013 01:26:42 -0700 (PDT)
Date: Tue, 9 Jul 2013 18:26:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Some baseline tests on new hardware (was Re: [PATCH] xfs:
	optimise CIL insertion during transaction commit [RFC])
Message-ID: <20130709082621.GI3438@dastard>
References: <1372657476-9241-1-git-send-email-david@fromorbit.com>
	<20130708124453.GC3438@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130708124453.GC3438@dastard>
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

On Mon, Jul 08, 2013 at 10:44:53PM +1000, Dave Chinner wrote:
> [cc fsdevel because after all the XFS stuff I did a some testing on
> mmotm w.r.t per-node LRU lock contention avoidance, and also some
> scalability tests against ext4 and btrfs for comparison on some new
> hardware. That bit ain't pretty. ]

A quick follow on mmotm:

> FWIW, the mmotm kernel (which has a fair bit of debug enabled, so
> not quite comparitive) doesn't have any LRU lock contention to speak
> of. For create:
> 
> -   7.81%  [kernel]  [k] __ticket_spin_trylock
>    - __ticket_spin_trylock
>       - 70.98% _raw_spin_lock
>          + 97.55% xfs_log_commit_cil
>          + 0.93% __d_instantiate
>          + 0.58% inode_sb_list_add
>       - 29.02% do_raw_spin_lock
>          - _raw_spin_lock
>             + 41.14% xfs_log_commit_cil
>             + 8.29% _xfs_buf_find
>             + 8.00% xfs_iflush_cluster

So i just ported all my prototype sync and inode_sb_list_lock
changes across to mmotm, as well as the XFS CIL optimisations.

-   2.33%  [kernel]  [k] __ticket_spin_trylock
   - __ticket_spin_trylock
      - 70.14% do_raw_spin_lock
         - _raw_spin_lock
            + 16.91% _xfs_buf_find
            + 15.20% list_lru_add
            + 12.83% xfs_log_commit_cil
            + 11.18% d_alloc
            + 7.43% dput
            + 4.56% __d_instantiate
....

Most of the spinlock contention has gone away.
 

> And the walk:
> 
> -  26.37%  [kernel]  [k] __ticket_spin_trylock
>    - __ticket_spin_trylock
>       - 49.10% _raw_spin_lock
>          - 50.65% evict
...
>          - 26.99% list_lru_add
>             + 89.01% inode_add_lru
>             + 10.95% dput
>          + 7.03% __remove_inode_hash
>       - 40.65% do_raw_spin_lock
>          - _raw_spin_lock
>             - 41.96% evict
....
>             - 13.55% list_lru_add
>                  84.33% inode_add_lru
....
>             + 10.10% __remove_inode_hash                                                                                                                               
>                     system_call_fastpath

-  15.44%  [kernel]  [k] __ticket_spin_trylock
   - __ticket_spin_trylock
      - 46.59% _raw_spin_lock
         + 69.40% list_lru_add
           17.65% list_lru_del
           5.70% list_lru_count_node
           2.44% shrink_dentry_list
              prune_dcache_sb
              super_cache_scan
              shrink_slab
           0.86% __page_check_address
      - 33.06% do_raw_spin_lock
         - _raw_spin_lock
            + 36.96% list_lru_add
            + 11.98% list_lru_del
            + 6.68% shrink_dentry_list
            + 6.43% d_alloc
            + 4.79% _xfs_buf_find
.....
      + 11.48% do_raw_spin_trylock
      + 8.87% _raw_spin_trylock

So now we see that CPU wasted on contention is down by 40%.
Observation shows that most of the list_lru_add/list_lru_del
contention occurs when reclaim is running - before memory filled
up the lookup rate was on the high side of 600,000 inodes/s, but
fell back to about 425,000/s once reclaim started working.

> 
> There's quite a different pattern of contention - it has moved
> inward to evict which implies the inode_sb_list_lock is the next
> obvious point of contention. I have patches in the works for that.
> Also, the inode_hash_lock is causing some contention, even though we
> fake inode hashing. I have a patch to fix that for XFS as well.
> 
> I also note an interesting behaviour of the per-node inode LRUs -
> the contention is coming from the dentry shrinker on one node
> freeing inodes allocated on a different node during reclaim. There's
> scope for improvement there.
> 
> But here' the interesting part:
> 
> Kernel	    create		walk		unlink
> 	time(s)	 rate		time(s)		time(s)
> 3.10-cil  222	266k+-32k	  170		  295
> mmotm	  251	222k+-16k	  128		  356

mmotm-cil  225  258k+-26k	  122		  296

So even with all the debug on, the mmotm kernel with most of the
mods as I was running in 3.10-cil, plus the s_inodes ->list_lru
conversion gets the same throughput for create and unlink and has
much better walk times.

> Even with all the debug enabled, the overall walk time dropped by
> 25% to 128s. So performance in this workload has substantially
> improved because of the per-node LRUs and variability is also down
> as well, as predicted. Once I add all the tweaks I have in the
> 3.10-cil tree to mmotm, I expect significant improvements to create
> and unlink performance as well...
> 
> So, lets look at ext4 vs btrfs vs XFS at 16-way (this is on the
> 3.10-cil kernel I've been testing XFS on):
> 
> 	    create		 walk		unlink
> 	 time(s)   rate		time(s)		time(s)
> xfs	  222	266k+-32k	  170		  295
> ext4	  978	 54k+- 2k	  325		 2053
> btrfs	 1223	 47k+- 8k	  366		12000(*)
> 
> (*) Estimate based on a removal rate of 18.5 minutes for the first
> 4.8 million inodes.

So, let's run these again on my current mmotm tree - it has the ext4
extent tree fixes in it and my rcu inode hash lookup patch...

	    create		 walk		unlink
	 time(s)   rate		time(s)		time(s)
xfs	  225	258k+-26k	  122		  296
ext4	  456	118k+- 4k	  128		 1632
btrfs	 1122	 51k+- 3k	  281		 3200(*)

(*) about 4.7 million inodes removed in 5 minutes.

ext4 is a lot healthier: create speed doubles from the extent cache
lock contention fixes, and the walk time halves due to the rcu inode
cache lookup. That said, it is still burning a huge amount of CPU on
the inode_hash_lock adding and removing inodes. Unlink perf is a bit
faster, but still slow.  So, yeah, things will get better in the
not-too distant future...

And for btrfs? Well, create is a tiny bit faster, the walk is 20%
faster thanks to the rcu hash lookups, and unlinks are markedly
faster (3x). Still not fast enough for me to hang around waiting for
them to complete, though.

FWIW, while the results are a lot better for ext4, let me just point
out how hard it is driving the storage to get that performance:

load	|    create  |	    walk    |		unlink
IO type	|    write   |	    read    |	   read	    |	   write
	| IOPS	 BW  |	 IOPS	 BW |	IOPS	BW  |	 IOPS	 BW
--------+------------+--------------+---------------+--------------
xfs	|  900	200  |	18000	140 |	7500	50  |	  400	 50
ext4	|23000	390  |	55000	200 |	2000	10  |	13000	160
btrfs(*)|peaky	 75  |	26000	100 |	decay	10  |	peaky peaky

ext4 is hammering the SSDs far harder than XFS, both in terms of
IOPS and bandwidth. You do not want to run ext4 on your SSD if you
have a metadata intensive workload as it will age the SSD much, much
faster than XFS with that sort of write behaviour.

(*) the btrfs create IO pattern is 5s peaks of write IOPS every 30s.
The baseline is about 500 IOPS, but the peaks reach upwards of
30,000 write IOPS. Unlink does this as well.  There are also short
bursts of 2-3000 read IOPS just before the write IOPS bursts in the
create workload. For the unlink, it starts off with about 10,000
read IOPS, and goes quickly into exponential decay down to about
2000 read IOPS in 90s.  Then it hits some trigger and the cycle
starts again. The trigger appears to co-incide with the reclaim 1-2
million dentries being reclaimed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
