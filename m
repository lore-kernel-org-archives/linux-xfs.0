Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM9SoVa132030 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 03:28:50 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF81626C7F0
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 01:28:47 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	x3bVZoDGTywQTWLN for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 01:28:47 -0800 (PST)
Date: Tue, 22 Nov 2011 20:28:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC][PATCH 0/8] xfstests: rework large filesystem testing
Message-ID: <20111122092843.GA8098@dastard>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
	<CF9FF112-852A-473B-99E4-3A5B790AE147@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CF9FF112-852A-473B-99E4-3A5B790AE147@mit.edu>
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
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 21, 2011 at 07:10:45AM -0500, Theodore Tso wrote:
> 
> On Nov 21, 2011, at 6:31 AM, Dave Chinner wrote:
> 
> > ext4, however, still has serious issues with this - either we take
> > the mkfs.ext4 time hit to initialise all the block groups, or we
> > take it during the preallocation.  IOWs, the "don't do work at mkfs
> > but do it after mount" hack^Wtradeoff simply does not work for
> > testing large filesystems in this manner.  While it is possible to
> > run large filesystem tests on ext4 using this mechanism, it is
> > extremely painful to do so.
> 
> For testing, we can disable the "do it after the mount " aspect
> of  ext4 by using the mount option "noinit_itable".   We basically
> only need to zero the inode table to make sure e2fsck doesn't
> confuse old inode tables as new ones in the event that the block

It's not the deferred inode table initialisation that is the problem
for the preallocation immediately after a mkfs and mount - it's
initialising block groups that is the problem:

363806.042907] SysRq : Show Blocked State
[363806.044586]   task                        PC stack   pid father
[363806.046400] xfs_io          D ffff8801099aed08     0  7264   7064 0x00000000
[363806.046400]  ffff880117e33868 0000000000000086 0000000000000000 ffffffffb13a2903
[363806.046400]  ffff8801099ae980 ffff880117e33fd8 ffff880117e33fd8 ffff880117e33fd8
[363806.046400]  ffff88011afb44c0 ffff8801099ae980 ffff880117e33868 00000001810b59ed
[363806.046400] Call Trace:
[363806.046400]  [<ffffffff8118eec0>] ? __wait_on_buffer+0x30/0x30
[363806.046400]  [<ffffffff81aab3af>] schedule+0x3f/0x60
[363806.046400]  [<ffffffff81aab45f>] io_schedule+0x8f/0xd0
[363806.046400]  [<ffffffff8118eece>] sleep_on_buffer+0xe/0x20
[363806.046400]  [<ffffffff81aabc2f>] __wait_on_bit+0x5f/0x90
[363806.046400]  [<ffffffff8167e177>] ? generic_make_request+0xc7/0x100
[363806.046400]  [<ffffffff8118eec0>] ? __wait_on_buffer+0x30/0x30
[363806.046400]  [<ffffffff81aabcdc>] out_of_line_wait_on_bit+0x7c/0x90
[363806.046400]  [<ffffffff810ac360>] ? autoremove_wake_function+0x40/0x40
[363806.046400]  [<ffffffff8118eebe>] __wait_on_buffer+0x2e/0x30
[363806.046400]  [<ffffffff812824c3>] ext4_mb_init_cache+0x223/0x9c0
[363806.046400]  [<ffffffff81118583>] ? add_to_page_cache_locked+0xb3/0x100
[363806.046400]  [<ffffffff81282dae>] ext4_mb_init_group+0x14e/0x210
[363806.046400]  [<ffffffff812832d9>] ext4_mb_load_buddy+0x339/0x350
[363806.046400]  [<ffffffff8128465b>] ext4_mb_find_by_goal+0x6b/0x2b0
[363806.046400]  [<ffffffff81285034>] ext4_mb_regular_allocator+0x64/0x430
[363806.046400]  [<ffffffff81286d8d>] ext4_mb_new_blocks+0x40d/0x560
[363806.046400]  [<ffffffff81aad1ee>] ? _raw_spin_lock+0xe/0x20
[363806.046400]  [<ffffffff81aad1ee>] ? _raw_spin_lock+0xe/0x20
[363806.046400]  [<ffffffff8127c6a1>] ext4_ext_map_blocks+0xfa1/0x1d10
[363806.046400]  [<ffffffff8129a6aa>] ? jbd2__journal_start+0xca/0x110
[363806.046400]  [<ffffffff81252535>] ext4_map_blocks+0x1b5/0x280
[363806.046400]  [<ffffffff8127ddf5>] ext4_fallocate+0x1c5/0x530
[363806.046400]  [<ffffffff8115e992>] do_fallocate+0xf2/0x160
[363806.046400]  [<ffffffff8115ea4b>] sys_fallocate+0x4b/0x70
[363806.046400]  [<ffffffff81ab5082>] system_call_fastpath+0x16/0x1b

this initialisation runs at about 50MB/s for some periods of the
preallocation. Sample from iostat -d -x -m 5:

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
vdc               0.00  1352.30   46.91  178.64     0.18    51.44   468.74     4.38   19.42   18.57   19.64   4.00  90.30

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
vdc               0.00  1405.40   47.20  184.40     0.18    50.97   452.34     5.99   25.84   18.31   27.77   3.91  90.56

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
vdc               0.00  4302.40   38.60  377.40     0.15    57.49   283.79    31.68   76.17   23.50   81.55   2.20  91.68

shows it is close to IO bound. This in on a 12 disk RAID-0 array w/
a 512MB BBWC. That indicates that most of the IO being done is
random. perf top shows that that the limited amount of CPU time
being spent is distributed like this:

            samples  pcnt function                      DSO
             _______ _____ _____________________________ _________________

               83.00  6.7% ext4_init_block_bitmap        [kernel.kallsyms]
               82.00  6.6% crc16                         [kernel.kallsyms]
               73.00  5.9% __find_get_block              [kernel.kallsyms]
               65.00  5.2% ext4_num_overhead_clusters    [kernel.kallsyms]
               62.00  5.0% ext4_set_bits                 [kernel.kallsyms]
               56.00  4.5% ext4_ext_find_extent          [kernel.kallsyms]
               55.00  4.4% ext4_mark_iloc_dirty          [kernel.kallsyms]
               53.00  4.3% jbd2_journal_add_journal_head [kernel.kallsyms]
               50.00  4.0% do_get_write_access           [kernel.kallsyms]
               45.00  3.6% mb_find_order_for_block       [kernel.kallsyms]
               41.00  3.3% ext4_ext_map_blocks           [kernel.kallsyms]
               34.00  2.7% jbd2_journal_cancel_revoke    [kernel.kallsyms]
               28.00  2.3% jbd2_journal_dirty_metadata   [kernel.kallsyms]
               27.00  2.2% jbd2_journal_put_journal_head [kernel.kallsyms]

The rest of the time, there is no IO and the preallocation is
is severely CPU bound. Top shows:

 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7523 root      20   0 10848  792  636 R   99  0.0   0:23.39 xfs_io

and perf top -p <pid of xfs_io> shows:

            samples  pcnt function                    DSO
             _______ _____ ___________________________ _________________

            13840.00 89.2% ext4_mb_good_group          [kernel.kallsyms]
             1218.00  7.8% ext4_mb_regular_allocator   [kernel.kallsyms]
              148.00  1.0% mb_find_order_for_block     [kernel.kallsyms]
               85.00  0.5% find_next_zero_bit          [kernel.kallsyms]
               78.00  0.5% radix_tree_lookup_element   [kernel.kallsyms]
               54.00  0.3% find_get_page               [kernel.kallsyms]
               53.00  0.3% mb_find_extent.constprop.31 [kernel.kallsyms]
               12.00  0.1% mb_find_buddy               [kernel.kallsyms]
               10.00  0.1% ext4_mb_load_buddy          [kernel.kallsyms]

which, if I read the code correctly, is CPU bound searching for a
block group to allocate from.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
