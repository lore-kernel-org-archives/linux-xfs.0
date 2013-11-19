Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3F3FC7F4E
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 15:30:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12016304051
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 13:30:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0zrpBBGmKF47ct6D for
	<xfs@oss.sgi.com>; Tue, 19 Nov 2013 13:30:26 -0800 (PST)
Message-ID: <528BD853.8090900@redhat.com>
Date: Tue, 19 Nov 2013 16:29:55 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/11] xfs: introduce the free inode btree
References: <1384353427-36205-1-git-send-email-bfoster@redhat.com>
	<20131113161711.GA14300@infradead.org>
	<5283BD1A.8000704@redhat.com> <20131113211017.GI6188@dastard>
In-Reply-To: <20131113211017.GI6188@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 11/13/2013 04:10 PM, Dave Chinner wrote:
...
> 
> The problem can be demonstrated with a single CPU and a single
> spindle. Create a single AG filesystem of a 100GB, and populate it
> with 10 million inodes.
> 
> Time how long it takes to create another 10000 inodes in a new
> directory. Measure CPU usage.
> 
> Randomly delete 10,000 inodes from the original population to
> sparsely populate the inobt with 10000 free inodes.
> 
> Time how long it takes to create another 10000 inodes in a new
> directory. Measure CPU usage.
> 
> The difference in time and CPU will be diretly related to the
> addition time spent searching the inobt for free inodes...
> 

Thanks for the suggestion, Dave. I've run some fs_mark tests along the
lines of what is described here. I create 10m files, randomly remove
~10k from that dataset and measure the process of allocating 10k new
inodes in both finobt and non-finobt scenarios (after a clean remount).

The tests run from a 4xcpu VM with 4GB RAM and against an isolated SATA
drive I had lying around (mapped directly via virtio). The drive is
formatted with a single VG/LV and as follows with xfs:

meta-data=/dev/mapper/testvg-testlv isize=512    agcount=1,
agsize=26214400 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0
data     =                       bsize=4096   blocks=26214400, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Once the fs has been prepared with a random set of free inodes, the
following command is used to measure performance:

	fs_mark -k -S 0 -D 4 -L 10 -n 1000 -s 0 -d /mnt/testdir

I've also collected some perf record data of these commands to compare
CPU usage. I can make the full/raw data available if desirable. Snippets
of the results are included below.

--- non-finobt, agi freecount = 9961 after random removal

- fs_mark

FSUse%        Count         Size    Files/sec     App Overhead
     5         1000            0       1020.1            10811
     5         2000            0        361.4            19498
     5         3000            0        230.1            12154
     5         4000            0        166.7            12816
     5         5000            0        129.7            27409
     5         6000            0        105.7            13946
     5         7000            0         87.6            31792
     5         8000            0         77.8            14921
     5         9000            0         67.3            15597
     5        10000            0         62.4            15835

- time

real    1m26.579s
user    0m0.120s
sys     1m26.113s

- perf report

     6.21%    :1994  [kernel.kallsyms]  [k] memcmp
     5.66%    :1993  [kernel.kallsyms]  [k] memcmp
     4.84%    :1992  [kernel.kallsyms]  [k] memcmp
     4.76%    :1994  [xfs]              [k] xfs_btree_check_sblock
     4.46%    :1993  [xfs]              [k] xfs_btree_check_sblock
     4.39%    :1991  [kernel.kallsyms]  [k] memcmp
     3.88%    :1992  [xfs]              [k] xfs_btree_check_sblock
     3.54%    :1990  [kernel.kallsyms]  [k] memcmp
     3.38%    :1991  [xfs]              [k] xfs_btree_check_sblock
     2.91%    :1989  [kernel.kallsyms]  [k] memcmp
     2.89%    :1990  [xfs]              [k] xfs_btree_check_sblock
     2.44%    :1988  [kernel.kallsyms]  [k] memcmp
     2.31%    :1989  [xfs]              [k] xfs_btree_check_sblock
     1.84%    :1988  [xfs]              [k] xfs_btree_check_sblock
     1.65%    :1987  [kernel.kallsyms]  [k] memcmp
     1.28%    :1987  [xfs]              [k] xfs_btree_check_sblock
     1.12%    :1994  [xfs]              [k] xfs_btree_increment
     1.08%    :1994  [xfs]              [k] xfs_btree_get_rec
     1.04%    :1993  [xfs]              [k] xfs_btree_increment
     1.00%    :1993  [xfs]              [k] xfs_btree_get_rec
     0.99%    :1986  [kernel.kallsyms]  [k] memcmp
     0.89%    :1992  [xfs]              [k] xfs_btree_increment
     0.85%    :1994  [xfs]              [k] xfs_inobt_get_rec
     0.84%    :1992  [xfs]              [k] xfs_btree_get_rec
     0.77%    :1991  [xfs]              [k] xfs_btree_increment
     0.77%    :1986  [xfs]              [k] xfs_btree_check_sblock
     0.77%    :1993  [xfs]              [k] xfs_inobt_get_rec
     0.75%    :1991  [xfs]              [k] xfs_btree_get_rec
     0.69%    :1992  [xfs]              [k] xfs_inobt_get_rec
     0.64%    :1990  [xfs]              [k] xfs_btree_increment
     0.62%    :1994  [xfs]              [k] xfs_inobt_get_maxrecs
     0.61%    :1990  [xfs]              [k] xfs_btree_get_rec
     0.58%    :1991  [xfs]              [k] xfs_inobt_get_rec
...

--- finobt, agi freecount = 10137 after random removal

- fs_mark

FSUse%        Count         Size    Files/sec     App Overhead
     5         1000            0       9210.0             8587
     5         2000            0       5592.1            14933
     5         3000            0       7095.4            11355
     5         4000            0       5371.1            13613
     5         5000            0       4919.3            14534
     5         6000            0       4375.7            15813
     5         7000            0       5011.3            15095
     5         8000            0       4629.8            17902
     5         9000            0       5622.9            12975
     5        10000            0       5761.4            12203

- time

real    0m1.831s
user    0m0.104s
sys     0m1.384s

- perf report

     1.82%    :2520  [kernel.kallsyms]  [k] lock_acquire
     1.65%    :2519  [kernel.kallsyms]  [k] lock_acquire
     1.65%    :2525  [kernel.kallsyms]  [k] lock_acquire
     1.45%    :2523  [kernel.kallsyms]  [k] lock_acquire
     1.44%    :2524  [kernel.kallsyms]  [k] lock_acquire
     1.34%    :2521  [kernel.kallsyms]  [k] lock_acquire
     1.27%    :2522  [kernel.kallsyms]  [k] lock_acquire
     1.18%    :2526  [kernel.kallsyms]  [k] lock_acquire
     1.15%    :2527  [kernel.kallsyms]  [k] lock_acquire
     1.09%    :2525  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
     1.03%    :2524  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
     0.88%    :2520  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
     0.83%    :2523  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
     0.81%    :2521  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
     0.79%    :2519  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
     0.79%    :2522  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
     0.76%    :2519  [kernel.kallsyms]  [k] kmem_cache_free
     0.76%    :2520  [kernel.kallsyms]  [k] kmem_cache_free
     0.73%    :2526  [kernel.kallsyms]  [k] kmem_cache_free
...
     0.30%    :2525  [xfs]              [k] xfs_dir3_leaf_check_int
     0.28%    :2525  [kernel.kallsyms]  [k] memcpy
     0.27%    :2527  [kernel.kallsyms]  [k] security_compute_sid.part.14
     0.26%    :2520  [kernel.kallsyms]  [k] memcpy
     0.26%    :2523  [xfs]              [k] _xfs_buf_find
     0.26%    :2526  [xfs]              [k] _xfs_buf_find

Summarized, the results show a nice improvement for inode allocation
into a set of inode chunks with random free inode availability. The 10k
inode allocation reduces from ~90s to ~2s and CPU usage from XFS drops
way down in the perf profile.

I haven't extensively tested the following, but a quick 1 million inode
allocation test on a fresh, single AG fs shows a slight degradation with
the finobt enabled in terms of time to complete:

	fs_mark -k -S 0 -D 4 -L 10 -n 100000 -s 0 -d /mnt/bigdir

- non-finobt

real    1m35.349s
user    0m4.555s
sys     1m29.749s

- finobt

real    1m42.396s
user    0m4.326s
sys     1m37.152s

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
