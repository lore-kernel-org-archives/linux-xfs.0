Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C5DFA7F4E
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 07:45:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 44384AC004
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 05:45:01 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	XhWaLCHVGAMXgtC6 for <xfs@oss.sgi.com>;
	Mon, 08 Jul 2013 05:44:58 -0700 (PDT)
Date: Mon, 8 Jul 2013 22:44:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Some baseline tests on new hardware (was Re: [PATCH] xfs: optimise
	CIL insertion during transaction commit [RFC])
Message-ID: <20130708124453.GC3438@dastard>
References: <1372657476-9241-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372657476-9241-1-git-send-email-david@fromorbit.com>
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

[cc fsdevel because after all the XFS stuff I did a some testing on
mmotm w.r.t per-node LRU lock contention avoidance, and also some
scalability tests against ext4 and btrfs for comparison on some new
hardware. That bit ain't pretty. ]

On Mon, Jul 01, 2013 at 03:44:36PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Note: This is an RFC right now - it'll need to be broken up into
> several patches for final submission.
> 
> The CIL insertion during transaction commit currently does multiple
> passes across the transaction objects and requires multiple memory
> allocations per object that is to be inserted into the CIL. It is
> quite inefficient, and as such xfs_log_commit_cil() and it's
> children show up quite highly in profiles under metadata
> modification intensive workloads.
> 
> The current insertion tries to minimise ithe number of times the
> xc_cil_lock is grabbed and the hold times via a couple of methods:
> 
> 	1. an initial loop across the transaction items outside the
> 	lock to allocate log vectors, buffers and copy the data into
> 	them.
> 	2. a second pass across the log vectors that then inserts
> 	them into the CIL, modifies the CIL state and frees the old
> 	vectors.
> 
> This is somewhat inefficient. While it minimises lock grabs, the
> hold time is still quite high because we are freeing objects with
> the spinlock held and so the hold times are much higher than they
> need to be.
> 
> Optimisations that can be made:
.....
> 
> The result is that my standard fsmark benchmark (8-way, 50m files)
> on my standard test VM (8-way, 4GB RAM, 4xSSD in RAID0, 100TB fs)
> gives the following results with a xfs-oss tree. No CRCs:
> 
>                 vanilla         patched         Difference
> create  (time)  483s            435s            -10.0%  (faster)
>         (rate)  109k+/6k        122k+/-7k       +11.9%  (faster)
> 
> walk            339s            335s            (noise)
>      (sys cpu)  1134s           1135s           (noise)
> 
> unlink          692s            645s             -6.8%  (faster)
> 
> So it's significantly faster than the current code, and lock_stat
> reports lower contention on the xc_cil_lock, too. So, big win here.
> 
> With CRCs:
> 
>                 vanilla         patched         Difference
> create  (time)  510s            460s             -9.8%  (faster)
>         (rate)  105k+/5.4k      117k+/-5k       +11.4%  (faster)
> 
> walk            494s            486s            (noise)
>      (sys cpu)  1324s           1290s           (noise)
> 
> unlink          959s            889s             -7.3%  (faster)
> 
> Gains are of the same order, with walk and unlink still affected by
> VFS LRU lock contention. IOWs, with this changes, filesystems with
> CRCs enabled will still be faster than the old non-CRC kernels...

FWIW, I have new hardware here that I'll be using for benchmarking
like this, so here's a quick baseline comparison using the same
8p/4GB RAM VM (just migrated across) and same SSD based storage
(physically moved) and 100TB filesystem. The disks are behind a
faster RAID controller w/ 1GB of BBWC, so random read and write IOPS
are higher and hence traversal times will due to lower IO latency.

Create times
		  wall time(s)		     rate (files/s)
		vanilla	 patched   diff	   vanilla  patched    diff
Old system	  483	  435	 -10.0%	   109k+-6k 122k+-7k +11.9%
New system	  378	  342	  -9.5%	   143k+-9k 158k+-8k +10.5%
diff		-21.7%	-21.4%		    +31.2%   +29.5%

Walk times
		  wall time(s)
		vanilla	 patched   diff
Old system	  339	  335	 (noise)
New system	  194	  197	 (noise)
diff		-42.7%	-41.2%

Unlink times
		  wall time(s)
		vanilla	 patched   diff
Old system	  692	  645	  -7.3%
New system	  457	  405	 -11.4%
diff		-34.0%  -37.2%

So, overall, the new system is 20-40% faster than the old one on a
comparitive test. but I have a few more cores and a lot more memory
to play with, so a 16-way test on the same machine with the VM
expanded to 16p/16GB RAM, 4 fake numa nodes follows:

New system, patched kernel:

Threads	    create		walk		unlink
	time(s)	 rate		time(s)		time(s)
8	  342	158k+-8k	  197		  405
16	  222	266k+-32k	  170		  295
diff	-35.1%	 +68.4%		-13.7%		-27.2%

Create rates are much more variable because the memory reclaim
behaviour appears to be very harsh, pulling 4-6 million inodes out
of memory every 10s or so and thrashing on the LRU locks, and then
doing nothing until another large step occurs.

Walk rates improve, but not much because of lock contention. I added
8 cpu cores to the workload, and I'm burning at least 4 of those
cores on the inode LRU lock.

-  30.61%  [kernel]  [k] __ticket_spin_trylock
   - __ticket_spin_trylock
      - 65.33% _raw_spin_lock
         + 88.19% inode_add_lru
         + 7.31% dentry_lru_del
         + 1.07% shrink_dentry_list
         + 0.90% dput
         + 0.83% inode_sb_list_add
         + 0.59% evict
      + 27.79% do_raw_spin_lock
      + 4.03% do_raw_spin_trylock
      + 2.85% _raw_spin_trylock

The current mmotm (and hence probably 3.11) has the new per-node LRU
code in it, so this variance and contention should go away very
soon.

Unlinks go lots faster because they don't cause inode LRU lock
contention, but we are still a long way from linear scalability
from 8- to 16-way.

FWIW, the mmotm kernel (which has a fair bit of debug enabled, so
not quite comparitive) doesn't have any LRU lock contention to speak
of. For create:

-   7.81%  [kernel]  [k] __ticket_spin_trylock
   - __ticket_spin_trylock
      - 70.98% _raw_spin_lock
         + 97.55% xfs_log_commit_cil
         + 0.93% __d_instantiate
         + 0.58% inode_sb_list_add
      - 29.02% do_raw_spin_lock
         - _raw_spin_lock
            + 41.14% xfs_log_commit_cil
            + 8.29% _xfs_buf_find
            + 8.00% xfs_iflush_cluster

And the walk:

-  26.37%  [kernel]  [k] __ticket_spin_trylock
   - __ticket_spin_trylock
      - 49.10% _raw_spin_lock
         - 50.65% evict
              dispose_list
              prune_icache_sb
              super_cache_scan
            + shrink_slab
         - 26.99% list_lru_add
            + 89.01% inode_add_lru
            + 10.95% dput
         + 7.03% __remove_inode_hash
      - 40.65% do_raw_spin_lock
         - _raw_spin_lock
            - 41.96% evict
                 dispose_list
                 prune_icache_sb
                 super_cache_scan
               + shrink_slab
            - 13.55% list_lru_add
                 84.33% inode_add_lru
                    iput
                    d_kill
                    shrink_dentry_list
                    prune_dcache_sb
                    super_cache_scan
                    shrink_slab
                 15.01% dput
                 0.66% xfs_buf_rele
            + 10.10% __remove_inode_hash                                                                                                                               
                    system_call_fastpath

There's quite a different pattern of contention - it has moved
inward to evict which implies the inode_sb_list_lock is the next
obvious point of contention. I have patches in the works for that.
Also, the inode_hash_lock is causing some contention, even though we
fake inode hashing. I have a patch to fix that for XFS as well.

I also note an interesting behaviour of the per-node inode LRUs -
the contention is coming from the dentry shrinker on one node
freeing inodes allocated on a different node during reclaim. There's
scope for improvement there.

But here' the interesting part:

Kernel	    create		walk		unlink
	time(s)	 rate		time(s)		time(s)
3.10-cil  222	266k+-32k	  170		  295
mmotm	  251	222k+-16k	  128		  356

Even with all the debug enabled, the overall walk time dropped by
25% to 128s. So performance in this workload has substantially
improved because of the per-node LRUs and variability is also down
as well, as predicted. Once I add all the tweaks I have in the
3.10-cil tree to mmotm, I expect significant improvements to create
and unlink performance as well...

So, lets look at ext4 vs btrfs vs XFS at 16-way (this is on the
3.10-cil kernel I've been testing XFS on):

	    create		 walk		unlink
	 time(s)   rate		time(s)		time(s)
xfs	  222	266k+-32k	  170		  295
ext4	  978	 54k+- 2k	  325		 2053
btrfs	 1223	 47k+- 8k	  366		12000(*)

(*) Estimate based on a removal rate of 18.5 minutes for the first
4.8 million inodes.

Basically, neither btrfs or ext4 have any concurrency scaling to
demonstrate, and unlinks on btrfs a just plain woeful.

ext4 create rate is limited by the extent cache LRU locking:

-  41.81%  [kernel]  [k] __ticket_spin_trylock
   - __ticket_spin_trylock
      - 60.67% _raw_spin_lock
         - 99.60% ext4_es_lru_add
            + 99.63% ext4_es_lookup_extent
      - 39.15% do_raw_spin_lock
         - _raw_spin_lock
            + 95.38% ext4_es_lru_add
              0.51% insert_inode_locked
                 __ext4_new_inode
-   16.20%  [kernel]  [k] native_read_tsc
   - native_read_tsc
      - 60.91% delay_tsc
           __delay
           do_raw_spin_lock
         + _raw_spin_lock
      - 39.09% __delay
           do_raw_spin_lock
         + _raw_spin_lock

Ext4 unlink is serialised on orphan list processing:

-  12.67%  [kernel]  [k] __mutex_unlock_slowpath
   - __mutex_unlock_slowpath
      - 99.95% mutex_unlock
         + 54.37% ext4_orphan_del
         + 43.26% ext4_orphan_add
+   5.33%  [kernel]  [k] __mutex_lock_slowpath


btrfs create has tree lock problems:

-  21.68%  [kernel]  [k] __write_lock_failed
   - __write_lock_failed
      - 99.93% do_raw_write_lock
         - _raw_write_lock
            - 79.04% btrfs_try_tree_write_lock
               - btrfs_search_slot
                  - 97.48% btrfs_insert_empty_items
                       99.82% btrfs_new_inode
                  + 2.52% btrfs_lookup_inode
            - 20.37% btrfs_tree_lock
               - 99.38% btrfs_search_slot
                    99.92% btrfs_insert_empty_items
                 0.52% btrfs_lock_root_node
                    btrfs_search_slot
                    btrfs_insert_empty_items
-  21.24%  [kernel]  [k] _raw_spin_unlock_irqrestore
   - _raw_spin_unlock_irqrestore
      - 61.22% prepare_to_wait
         + 61.52% btrfs_tree_lock
         + 32.31% btrfs_tree_read_lock
           6.17% reserve_metadata_bytes
              btrfs_block_rsv_add

btrfs walk phase hammers the inode_hash_lock:

-  18.45%  [kernel]  [k] __ticket_spin_trylock
   - __ticket_spin_trylock
      - 47.38% _raw_spin_lock
         + 42.99% iget5_locked
         + 15.17% __remove_inode_hash
         + 13.77% btrfs_get_delayed_node
         + 11.27% inode_tree_add
         + 9.32% btrfs_destroy_inode
.....
      - 46.77% do_raw_spin_lock
         - _raw_spin_lock
            + 30.51% iget5_locked
            + 11.40% __remove_inode_hash
            + 11.38% btrfs_get_delayed_node
            + 9.45% inode_tree_add
            + 7.28% btrfs_destroy_inode
.....

I have a RCU inode hash lookup patch floating around somewhere if
someone wants it...

And, well, the less said about btrfs unlinks the better:

+  37.14%  [kernel]  [k] _raw_spin_unlock_irqrestore
+  33.18%  [kernel]  [k] __write_lock_failed
+  17.96%  [kernel]  [k] __read_lock_failed
+   1.35%  [kernel]  [k] _raw_spin_unlock_irq
+   0.82%  [kernel]  [k] __do_softirq
+   0.53%  [kernel]  [k] btrfs_tree_lock
+   0.41%  [kernel]  [k] btrfs_tree_read_lock
+   0.41%  [kernel]  [k] do_raw_read_lock
+   0.39%  [kernel]  [k] do_raw_write_lock
+   0.38%  [kernel]  [k] btrfs_clear_lock_blocking_rw
+   0.37%  [kernel]  [k] free_extent_buffer
+   0.36%  [kernel]  [k] btrfs_tree_read_unlock
+   0.32%  [kernel]  [k] do_raw_write_unlock

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
