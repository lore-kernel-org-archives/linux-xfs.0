Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CA5077F5E
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 02:44:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F1A38F8039
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 00:44:58 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NaGvaVu522VYgdQ1 for <xfs@oss.sgi.com>;
	Mon, 03 Jun 2013 00:44:56 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UjPRk-0001MQ-CV
	for xfs@oss.sgi.com; Mon, 03 Jun 2013 17:44:52 +1000
Date: Mon, 3 Jun 2013 17:44:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Debunking myths about metadata CRC overhead
Message-ID: <20130603074452.GZ29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi folks,

There has been some assertions made recently that metadata CRCs have
too much overhead to always be enabled.  So I'll run some quick
benchmarks to demonstrate the "too much overhead" assertions are
completely unfounded.

These are some numbers from my usual performance test VM. Note that
as this is a VM, it's not running the hardware CRC instructions so
I'm benchmarking the worst case overhead here. i.e. the kernel's
software CRC32c algorithm.

THe VM is 8p, 8GB RAM, 4 node fake-numa config with a 100TB XFS
filesystem being used for testing. The fs is backed by 4x64GB SSDs
sliced via LVM into a 160GB RAID0 device with an XFS filesytsem on
it to host the sparse 100TB image file. KVM is using
virtio,cache=none to use direct IO to write to the image file, and
the host is running a 3.8.5 kernel.

Baseline CRC32c performance
---------------------------

The VM runs the xfsprogs selftest program in:

crc32c: tests passed, 225944 bytes in 212 usec

so it can calulate CRCs at roughly 1GB/s on small, random chunks of
data through the software algorithm according to this. Given the
fsmark create workload only drives around 100MB/s of metadata and
journal IO, the minimum CRC32c overhead we should see on a load
spread across 8 CPUs is roughly:

	100MB/s / 1000MB/s / 8p * 100% = 1.25% per CPU

So, in a perfect world, that's what we should see from the kernel
profiles. It's not a perfect world, though, so it will never be
this low (4 cores all trying to use the same memory bus at the same
time, perhaps?), so if we get anywhere near that number I'd be very
happy.

Note that a hardware implementation should be faster than the SSE
optimised RAID5/6 calculations on the CPU, which come in at:

[    0.548004] raid6: sse2x4    7221 MB/s

which is a *lot* faster. So it's probably reasonable to assume
similar throughput for hardware CRC32c throughput. Hence Intel
servers will have substantially lower CRC overhead than the software
CRC32c implementation being measured here.

fs_mark workload
----------------

$ sudo mkfs.xfs -f -m crc=1 -l size=512m,sunit=8 /dev/vdc

vs

$ sudo mkfs.xfs -f -l size=512m,sunit=8 /dev/vdc

8-way 50 million zero-length file create, 8-way
find+stat of all the files, 8-unlink of all the files:

		no CRCs		CRCs		Difference
create	(time)	483s		510s		+5.2%	(slower)
	(rate)	109k+/6k	105k+/-5.4k	-3.8%	(slower)

walk		339s		494s		-30.3%	(slower)
     (sys cpu)	1134s		1324s		+14.4%	(slower)

unlink		692s		959s		-27.8%(*) (slower)

(*) All the slowdown here is from the traversal slowdown as seen in
the walk phase. i.e. not related to the unlink operations.

On the surface, it looks like there's a huge impact on the walk and
unlink phases from CRC calculations, but these numbers don't tell
the whole story. Lets look deeper:

Create phase top CPU users (>1% total):

  5.59%  [kernel]  [k] _xfs_buf_find
  5.52%  [kernel]  [k] xfs_dir2_node_addname
  4.58%  [kernel]  [k] memcpy
  3.28%  [kernel]  [k] xfs_dir3_free_hdr_from_disk
  3.05%  [kernel]  [k] __ticket_spin_trylock
  2.94%  [kernel]  [k] __slab_alloc
  1.96%  [kernel]  [k] xfs_log_commit_cil
  1.93%  [kernel]  [k] __slab_free
  1.90%  [kernel]  [k] kmem_cache_alloc
  1.72%  [kernel]  [k] xfs_next_bit
  1.65%  [kernel]  [k] __crc32c_le
  1.52%  [kernel]  [k] _raw_spin_unlock_irqrestore
  1.50%  [kernel]  [k] do_raw_spin_lock
  1.42%  [kernel]  [k] kmem_cache_free
  1.32%  [kernel]  [k] native_read_tsc
  1.28%  [kernel]  [k] __kmalloc
  1.17%  [kernel]  [k] xfs_buf_offset
  1.14%  [kernel]  [k] delay_tsc
  1.14%  [kernel]  [k] kfree
  1.10%  [kernel]  [k] xfs_buf_item_format
  1.06%  [kernel]  [k] xfs_btree_lookup

CRC overehad is at 1.65%, not much higher than the optimum 1.25%
overhead calculated above. So the overhead really isn't that
significant - it's far less overhead than, say, the 1.2 million
buffer lookups a second we are doing (_xfs_buf_find overhead) in
this workload...

Walk phase top CPU users:

  6.64%  [kernel]  [k] __ticket_spin_trylock
  6.05%  [kernel]  [k] _xfs_buf_find
  5.58%  [kernel]  [k] _raw_spin_unlock_irqrestore
  4.88%  [kernel]  [k] _raw_spin_unlock_irq
  3.30%  [kernel]  [k] native_read_tsc
  2.93%  [kernel]  [k] __crc32c_le
  2.87%  [kernel]  [k] delay_tsc
  2.32%  [kernel]  [k] do_raw_spin_lock
  1.98%  [kernel]  [k] blk_flush_plug_list
  1.79%  [kernel]  [k] __slab_alloc
  1.76%  [kernel]  [k] __d_lookup_rcu
  1.56%  [kernel]  [k] kmem_cache_alloc
  1.25%  [kernel]  [k] kmem_cache_free
  1.25%  [kernel]  [k] xfs_da_read_buf
  1.11%  [kernel]  [k] xfs_dir2_leaf_search_hash
  1.08%  [kernel]  [k] flat_send_IPI_mask
  1.02%  [kernel]  [k] radix_tree_lookup_element
  1.00%  [kernel]  [k] do_raw_spin_unlock

There's more CRC32c overhead indicating lower efficiency, but
there's an obvious cause for that - the CRC overhead is dwarfed by
something else new: lock contention.  A quick 30s call graph profile
during the middle of the walk phase shows:

-  12.74%  [kernel]  [k] __ticket_spin_trylock
   - __ticket_spin_trylock
      - 60.49% _raw_spin_lock
         + 91.79% inode_add_lru			>>> inode_lru_lock
         + 2.98% dentry_lru_del			>>> dcache_lru_lock
         + 1.30% shrink_dentry_list
         + 0.71% evict
      - 20.42% do_raw_spin_lock
         - _raw_spin_lock
            + 13.41% inode_add_lru		>>> inode_lru_lock
            + 10.55% evict
            + 8.26% dentry_lru_del		>>> dcache_lru_lock
            + 7.62% __remove_inode_hash
....
      - 10.37% do_raw_spin_trylock
         - _raw_spin_trylock
            + 79.65% prune_icache_sb		>>> inode_lru_lock
            + 11.04% shrink_dentry_list
            + 9.24% prune_dcache_sb		>>> dcache_lru_lock
      - 8.72% _raw_spin_trylock
         + 46.33% prune_icache_sb		>>> inode_lru_lock
         + 46.08% shrink_dentry_list
         + 7.60% prune_dcache_sb		>>> dcache_lru_lock

So the lock contention is variable - it's twice as high in this
short sample as the overall profile I measured above. It's also
pretty much all VFS cache LRU lock contention that is causing the
problems here. IOWs, the slowdowns are not related to the overhead
of CRC calculations; it's the change in memory access patterns that
are lowering the threshold of catastrophic lock contention that is
causing it. This VFS LRU problem is being fixed independently by the
generic numa-aware LRU list patchset I've been doing with Glauber
Costa.

Therefore, it is clear that the slowdown in this phase is not caused
by the overhead of CRCs, but that of lock contention elsewhere in
the kernel.  The unlink profiles show the same the thing as the walk
profiles - additional lock contention on the lookup phase of the
unlink walk.

----

Dbench:

$ sudo mkfs.xfs -f -m crc=1 -l size=128m,sunit=8 /dev/vdc

vs

$ sudo mkfs.xfs -f -l size=128m,sunit=8 /dev/vdc

Running:

$ dbench -t 120 -D /mnt/scratch 8

		no CRCs		CRCs		Difference
thruput		1098.06 MB/s	1229.65 MB/s	+10% (faster)
latency (max)	22.385 ms	22.661 ms	+1.3% (noise)

Well, now that's an interesting result, isn't it. CRC enabled
filesystems are 10% faster than non-crc filesystems. Again, let's
not take that number at face value, but ask ourselves why adding
CRCs improves performance (a.k.a. "know your benchmark")...

It's pretty obvious why - dbench uses xattrs and performance is
sensitive to how many attributes can be stored inline in the inode.
And CRCs increase the inode size to 512 bytes meaning attributes are
probably never out of line. So, let's make it an even playing field
and compare:

$ sudo mkfs.xfs -f -m crc=1 -l size=128m,sunit=8 /dev/vdc

vs

$ sudo mkfs.xfs -f -i size=512 -l size=128m,sunit=8 /dev/vdc

		no CRCs		CRCs		Difference
thruput		1273.22 MB/s	1229.65 MB/s	-3.5% (slower)
latency (max)	25.455 ms	22.661 ms	-12.4% (better)

So, we're back to the same relatively small difference seen in the
fsmark create phase, with similar CRC overhead being shown in the
profiles.

----

Compilebench

Testing the same filesystems with 512 byte inodes as for dbench:

$ ./compilebench -D /mnt/scratch
using working directory /mnt/scratch, 30 intial dirs 100 runs
.....

test				no CRCs		CRCs
			runs	avg		avg
==========================================================================
intial create		30	92.12 MB/s	90.24 MB/s
create			14	61.91 MB/s	61.13 MB/s
patch			15	41.04 MB/s	38.00 MB/s
compile			14	278.74 MB/s	262.00 MB/s
clean			10	1355.30 MB/s	1296.17 MB/s
read tree		11	25.68 MB/s	25.40 MB/s
read compiled tree	4	48.74 MB/s	48.65 MB/s
delete tree		10	2.97 seconds	3.05 seconds
delete compiled tree	4	2.96 seconds	3.05 seconds
stat tree		11	1.33 seconds	1.36 seconds
stat compiled tree	7	1.86 seconds	1.64 seconds

The numbers are so close that the differences are in the noise, and
the CRC overhead doesn't even show up in the ">1% usage" section
of the profile output.

----

Looking at these numbers realistically, dbench and compilebench
model two fairly common metadata intensive workloads - file servers
and code tree manipulations that developers tend to use all the
time. The difference that CRCs make to performance in these
workloads on equivalently configured filesystems varies between
0-5%, and for most operations they are small enough that they can
just about be considered to be noise.

Yes, we could argue over the fsmark walk/unlink phase results, but
the synthetic fsmark workload is designed to push the system to it's
limits and it's obvious that the addition of CRCs pushes the VFS into
lock contention hell. Further, we have to recognise that the same
workload on a 12p VM (run 12-way instead of 8-way) without CRCs hits
the same lock contention problem. IOWs, the slowdown is most
definitely not caused by the addition of CRC calculations to XFS
metadata.

The CPU overhead of CRCs is small and may be outweighed by other
changes for CRC filesystems that improve performance far more than
the cost of CRC calculations degrades it.  The numbers above simply
don't support the assertion that metadata CRCs have "too much
overhead".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
