Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED7287F58
	for <xfs@oss.sgi.com>; Sat,  7 Sep 2013 20:04:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 60FBDAC001
	for <xfs@oss.sgi.com>; Sat,  7 Sep 2013 18:04:43 -0700 (PDT)
Received: from mail-qc0-f174.google.com (mail-qc0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	PQv5FZdNIDDcxW7o (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Sep 2013 18:04:41 -0700 (PDT)
Received: by mail-qc0-f174.google.com with SMTP id n9so134477qcw.33
	for <xfs@oss.sgi.com>; Sat, 07 Sep 2013 18:04:40 -0700 (PDT)
Message-ID: <522BCD20.9040405@gmail.com>
Date: Sat, 07 Sep 2013 21:04:32 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 00/11] xfs: introduce the free inode btree
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<5228F4D6.4050306@gmail.com> <20130906213555.GC12541@dastard>
	<522B1CA6.1070804@redhat.com>
In-Reply-To: <522B1CA6.1070804@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 09/07/2013 08:31 AM, Brian Foster wrote:
> On 09/06/2013 05:35 PM, Dave Chinner wrote:
>> On Thu, Sep 05, 2013 at 05:17:10PM -0400, Michael L. Semon wrote:
>> ....
>>> [  814.376620] XFS (sdb4): Mounting Filesystem
>>> [  815.050778] XFS (sdb4): Ending clean mount
>>> [  823.169368] 
>>> [  823.170932] ======================================================
>>> [  823.172146] [ INFO: possible circular locking dependency detected ]
>>> [  823.172146] 3.11.0+ #5 Not tainted
>>> [  823.172146] -------------------------------------------------------
>>> [  823.172146] dirstress/5276 is trying to acquire lock:
>>> [  823.172146]  (sb_internal){.+.+.+}, at: [<c11c5e60>] xfs_trans_alloc+0x1f/0x35
>>> [  823.172146] 
>>> [  823.172146] but task is already holding lock:
>>> [  823.172146]  (&(&ip->i_lock)->mr_lock){+++++.}, at: [<c1206cfb>] xfs_ilock+0x100/0x1f1
>>> [  823.172146] 
>>> [  823.172146] which lock already depends on the new lock.
>>> [  823.172146] 
>>> [  823.172146] 
>>> [  823.172146] the existing dependency chain (in reverse order) is:
>>> [  823.172146] 
>>> [  823.172146] -> #1 (&(&ip->i_lock)->mr_lock){+++++.}:
>>> [  823.172146]        [<c1070a11>] __lock_acquire+0x345/0xa11
>>> [  823.172146]        [<c1071c45>] lock_acquire+0x88/0x17e
>>> [  823.172146]        [<c14bff98>] _raw_spin_lock+0x47/0x74
>>> [  823.172146]        [<c1116247>] __mark_inode_dirty+0x171/0x38c
>>> [  823.172146]        [<c111acab>] __set_page_dirty+0x5f/0x95
>>> [  823.172146]        [<c111b93e>] mark_buffer_dirty+0x58/0x12b
>>> [  823.172146]        [<c111baff>] __block_commit_write.isra.17+0x64/0x82
>>> [  823.172146]        [<c111c197>] block_write_end+0x2b/0x53
>>> [  823.172146]        [<c111c201>] generic_write_end+0x42/0x9a
>>> [  823.172146]        [<c11a42d5>] xfs_vm_write_end+0x60/0xbe
>>> [  823.172146]        [<c10bd47a>] generic_file_buffered_write+0x140/0x20f
>>> [  823.172146]        [<c11b2347>] xfs_file_buffered_aio_write+0x10b/0x205
>>> [  823.172146]        [<c11b24ee>] xfs_file_aio_write+0xad/0xec
>>> [  823.172146]        [<c10f0c5f>] do_sync_write+0x60/0x87
>>> [  823.172146]        [<c10f0e0f>] vfs_write+0x9c/0x189
>>> [  823.172146]        [<c10f0fc6>] SyS_write+0x49/0x81
>>> [  823.172146]        [<c14c14bb>] sysenter_do_call+0x12/0x32
>>> [  823.172146] 
>>> [  823.172146] -> #0 (sb_internal){.+.+.+}:
>>> [  823.172146]        [<c106e972>] validate_chain.isra.35+0xfc7/0xff4
>>> [  823.172146]        [<c1070a11>] __lock_acquire+0x345/0xa11
>>> [  823.172146]        [<c1071c45>] lock_acquire+0x88/0x17e
>>> [  823.172146]        [<c10f36eb>] __sb_start_write+0xad/0x177
>>> [  823.172146]        [<c11c5e60>] xfs_trans_alloc+0x1f/0x35
>>> [  823.172146]        [<c120a823>] xfs_inactive+0x129/0x4a3
>>> [  823.172146]        [<c11c280d>] xfs_fs_evict_inode+0x6c/0x114
>>> [  823.172146]        [<c1106678>] evict+0x8e/0x15d
>>> [  823.172146]        [<c1107126>] iput+0xc4/0x138
>>> [  823.172146]        [<c1103504>] dput+0x1b2/0x257
>>> [  823.172146]        [<c10f1a30>] __fput+0x140/0x1eb
>>> [  823.172146]        [<c10f1b0f>] ____fput+0xd/0xf
>>> [  823.172146]        [<c1048477>] task_work_run+0x67/0x90
>>> [  823.172146]        [<c1001ea5>] do_notify_resume+0x61/0x63
>>> [  823.172146]        [<c14c0cfa>] work_notifysig+0x1f/0x25
>>> [  823.172146] 
>>> [  823.172146] other info that might help us debug this:
>>> [  823.172146] 
>>> [  823.172146]  Possible unsafe locking scenario:
>>> [  823.172146] 
>>> [  823.172146]        CPU0                    CPU1
>>> [  823.172146]        ----                    ----
>>> [  823.172146]   lock(&(&ip->i_lock)->mr_lock);
>>> [  823.172146]                                lock(sb_internal);
>>> [  823.172146]                                lock(&(&ip->i_lock)->mr_lock);
>>> [  823.172146]   lock(sb_internal);
>>
>> Ah, now there's something I missed in all the xfs_inactive
>> transaction rework - you can't call
>> xfs_trans_alloc()/xfs-trans_reserve with the XFS_ILOCK_??? held.
>> It's not the freeze locks you really have to worry about deadlocking
>> if you do, it's deadlocking against log space that is much more
>> likely.
>>
>> i.e. if you hold the ILOCK, the AIL can't get it to flush the inode
>> to disk. That means if the inode you hold locked is pinning the tail
>> of the log and there is no logspace for the transaction you are
>> about to run, xfs_trans_reserve() will block forever waiting for the
>> inode to be flushed and the tail of the log to move forward. This
>> will end up blocking all further reservations and hence deadlock the
>> filesystem...
>>
>> Brian, if you rewrite xfs_inactive in the way that I suggested, this
>> problem goes away ;)
>>
>> Thanks for reporting this, Michael.
>>
> 
> Oh, very interesting scenario. Thanks again for catching this, Michael,
> and for the analysis, Dave. I'll get this cleaned up in the next
> revision as well.
> 
> Brian
> 
>> Cheers,
>>
>> Dave.
>>
> 

No problem, Brian.  I'll try out your userspace as well.  I had worked a 
bit on getting some sane numbers that are better than "results for copying 
3 kernel gits to a 1k-blocksize FS with write cache turned off."  Here's 
my attempt, as a more formal report.  Thanks!

Michael

[REPORT FOLLOWS]

Lockdep threw off the debug numbers for your patchset--a new lockdep 
is at the very end--so these tests were done with a fairly non-debug
setup.  The write cache is on for these tests as well.

Casual "user command" benchmark using built 3.11.0+ kernel git 
tarball.  The idea behind it:

1) Unpack a tarball, and
2) do something with its contents.

The total files are among these:

$TEST_DIR/a/linux/ ...
$TEST_DIR/b/linux/ ...
$TEST_DIR/kernel-git-built-2013-08-05.tar.gz

The file systems are as follows:

v4: mkfs.xfs -l logdev=$TEST_LOGDEV $TEST_DEV
v4dirent: mkfs.xfs -n ftype=1 -l logdev=$TEST_LOGDEV $TEST_DEV
v4d512bi: mkfs.xfs -n ftype=1 -i log=9 -l logdev=$TEST_LOGDEV $TEST_DEV
v5: mkfs.xfs -m crc=1 -l logdev=$TEST_LOGDEV $TEST_DEV

Dave had a benchmark set to break down v5 performance changes into
a 512-byte-inode component and a CRC component.  This is my edition
of the benchmark, done with old spinning rust on x86 hardware, and
updated to reflect your patchset.

Patchset notation: "normal" is the normal xfs-oss/master with Dave's
latest patches on top; "itree" adds the inode btree code.

This is non-debug XFS.  Tracers, lockdep, and almost all other "Kernel 
Hacking" kernel config items are not enabled.  It's still a 
CONFIG_KERNEL_DEBUG=y kernel, though.

======================= REAL ========================
command    patch     v4    v4dirent v4d512bi    v5
==========|======|========|========|========|========
tar -xf    normal  103.202  104.951  101.771  104.486
tar -xf    itree   104.610  101.705   98.784  101.919
----------+------+--------+--------+--------+--------
sha256sum  normal  227.456  228.321  231.947  234.127
sha256sum  itree   230.233  229.375  231.509  233.253
----------+------+--------+--------+--------+--------
cp -r a b  normal  239.714  242.754  248.994  249.584
cp -r a b  itree   241.273  243.216  248.531  254.501
----------+------+--------+--------+--------+--------
find .     normal   11.894   12.370   12.324   12.397
find .     itree    12.043   12.310   12.736   13.216
----------+------+--------+--------+--------+--------
rm -r b    normal    8.556    8.744   11.298   11.774
rm -r b    itree     8.904    8.981   10.590   12.057
----------+------+--------+--------+--------+--------
cp -r b a  normal  262.065  256.448  272.290  272.221
cp -r b a  itree   264.116  265.875  267.346  270.811
----------+------+--------+--------+--------+--------
rm -r b    normal    8.585    9.258    8.791   10.058
rm -r b    itree     9.061    8.345    9.909    9.273
----------+------+--------+--------+--------+--------
stat       normal  161.853  162.772  163.555  165.046
stat       itree   162.641  163.148  163.698  164.015
----------+------+--------+--------+--------+--------
sha check  normal  133.938  133.016  141.352  142.921
sha check  itree   133.885  133.399  138.013  143.315
----------+------+--------+--------+--------+--------
cp tarball normal   44.102   42.812   43.603   43.722
cp tarball itree    43.724   44.187   44.339   42.761
==========|======|========|========|========|========
TOTAL      normal 1201.365 1201.446 1235.925 1246.336
TOTAL      itree  1210.490 1210.541 1225.455 1245.121

======================= USER ========================
command    patch     v4    v4dirent v4d512bi    v5
==========|======|========|========|========|========
tar -xf    normal   59.223   59.473   58.817   59.640
tar -xf    itree    59.420   59.473   58.953   59.893
----------+------+--------+--------+--------+--------
sha256sum  normal   49.877   49.877   49.787   49.730
sha256sum  itree    49.437   49.863   49.583   49.673
----------+------+--------+--------+--------+--------
cp -r a b  normal    0.697    0.707    0.743    0.800
cp -r a b  itree     0.657    0.710    0.677    0.703
----------+------+--------+--------+--------+--------
find .     normal    0.257    0.237    0.233    0.223
find .     itree     0.283    0.223    0.223    0.203
----------+------+--------+--------+--------+--------
rm -r b    normal    0.170    0.120    0.147    0.160
rm -r b    itree     0.160    0.163    0.130    0.137
----------+------+--------+--------+--------+--------
cp -r b a  normal    0.817    0.763    0.817    0.763
cp -r b a  itree     0.737    0.740    0.787    0.670
----------+------+--------+--------+--------+--------
rm -r b    normal    0.170    0.153    0.140    0.133
rm -r b    itree     0.140    0.157    0.143    0.163
----------+------+--------+--------+--------+--------
stat       normal    1.660    1.653    1.570    1.720
stat       itree     1.737    1.727    1.700    1.630
----------+------+--------+--------+--------+--------
sha check  normal   58.467   58.603   58.550   58.370
sha check  itree    58.157   58.183   58.620   58.343
----------+------+--------+--------+--------+--------
cp tarball normal    0.023    0.027    0.033    0.037
cp tarball itree     0.017    0.020    0.020    0.020
==========|======|========|========|========|========
TOTAL      normal  171.361  171.613  170.837  171.576
TOTAL      itree   170.745  171.259  170.836  171.435

======================== SYS ========================
command    patch     v4    v4dirent v4d512bi    v5
==========|======|========|========|========|========
tar -xf    normal   19.770   19.800   19.960   20.770
tar -xf    itree    19.550   19.930   20.067   20.963
----------+------+--------+--------+--------+--------
sha256sum  normal   17.157   14.607   14.393   16.053
sha256sum  itree    17.277   14.813   14.550   15.007
----------+------+--------+--------+--------+--------
cp -r a b  normal   18.697   18.973   18.687   19.253
cp -r a b  itree    19.033   18.993   18.783   19.703
----------+------+--------+--------+--------+--------
find .     normal    0.820    0.573    0.537    0.597
find .     itree     0.793    0.593    0.547    0.610
----------+------+--------+--------+--------+--------
rm -r b    normal    3.883    3.827    3.800    3.967
rm -r b    itree     4.053    3.937    4.003    4.143
----------+------+--------+--------+--------+--------
cp -r b a  normal   19.043   19.083   18.753   19.503
cp -r b a  itree    19.203   19.100   19.040   19.680
----------+------+--------+--------+--------+--------
rm -r b    normal    4.097    3.947    3.900    4.123
rm -r b    itree     4.287    4.067    4.093    4.227
----------+------+--------+--------+--------+--------
stat       normal   11.337   10.730   10.727   10.680
stat       itree    11.080   10.827   10.800   10.457
----------+------+--------+--------+--------+--------
sha check  normal    8.970    8.920    8.980    9.507
sha check  itree     9.053    9.143    8.540    9.420
----------+------+--------+--------+--------+--------
cp tarball normal    5.537    5.397    5.470    5.373
cp tarball itree     5.390    5.313    5.460    5.343
==========|======|========|========|========|========
TOTAL      normal  109.311  105.857  105.207  109.826
TOTAL      itree   109.719  106.716  105.883  109.553

The rest of this report is supplementary noise and the lockdep.

# XFS kernel configuration:

CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set

# `uname -a` output:
Linux plbearer 3.11.0+ #4 Sat Sep 7 13:04:53 EDT 2013 
i686 Intel(R) Pentium(R) 4 CPU 1.80GHz GenuineIntel GNU/Linux

RAM: 512 MB, less 9 MB for capture kernel

# Hard drive used for $TEST_DEV:
Model Family:     Western Digital Caviar
Device Model:     WDC WD600BB-75CAA0
User Capacity:    60,022,480,896 bytes [60.0 GB]

# Hard drive used for $TEST_LOGDEV and kernel-git tarball:
Model Family:     Seagate Barracuda 7200.9
Device Model:     ST3120814A
User Capacity:    120,034,123,776 bytes [120 GB]
root@plbearer:~/results# uname -a

# Sample xfs_info output for $TEST_DEV, to show how XFS is using the partition:
meta-data=/dev/sdb4              isize=512    agcount=4, agsize=720896 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0
data     =                       bsize=4096   blocks=2883584, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =external               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# cat /proc/partitions
major minor  #blocks  name
   8        0  117220824 sda
   8        1      98304 sda1 # shared /boot
   8        2          1 sda2
   8        5      65536 sda5
   8        6     131072 sda6 # $TEST_LOGDEV
   8        7     131072 sda7
   8        8     616448 sda8
   8        9   11275264 sda9 # inactive root (v5 XFS), holds tarball
   8       10  104895960 sda10

  11        0    1048575 sr0

   8       16   58615704 sdb
   8       17    3406848 sdb1 # active root partition (JFS)
   8       18     786432 sdb2
   8       19   20971520 sdb3
   8       20   11534336 sdb4 # $TEST_DEV
   8       21    4128768 sdb5
   8       22     786432 sdb6
   8       23     524288 sdb7
   8       24     524288 sdb8
   8       25    1048576 sdb9
   8       26   10708871 sdb10
   8       27    4194304 sdb11

Lockdep that kept tar jobs from completing.  It was found during several 
other tests before I gave up on the debug benchmark idea.

=================================
[ INFO: inconsistent lock state ]
3.11.0+ #2 Not tainted
---------------------------------
inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
tar/287 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&(&ip->i_lock)->mr_lock){++++?-}, at: [<c120cc1b>] xfs_ilock+0x100/0x1f1
{IN-RECLAIM_FS-W} state was registered at:
  [<c1070697>] __lock_acquire+0x63b/0x1953
  [<c1072515>] lock_acquire+0x88/0x17e
  [<c104fc0f>] down_write_nested+0x4f/0x9d
  [<c120cc1b>] xfs_ilock+0x100/0x1f1
  [<c11bd00d>] xfs_reclaim_inode+0xf4/0x30a
  [<c11bd4d4>] xfs_reclaim_inodes_ag+0x2b1/0x488
  [<c11bd729>] xfs_reclaim_inodes_nr+0x2d/0x33
  [<c11c7e1e>] xfs_fs_free_cached_objects+0x13/0x15
  [<c10f3778>] prune_super+0xd1/0x15c
  [<c10c99da>] shrink_slab+0x143/0x3d8
  [<c10cc768>] kswapd+0x45d/0x835
  [<c104b617>] kthread+0xa7/0xa9
  [<c14e26b7>] ret_from_kernel_thread+0x1b/0x28
irq event stamp: 23333689
hardirqs last  enabled at (23333689): [<c14e1375>] _raw_spin_unlock_irq+0x27/0x36
hardirqs last disabled at (23333688): [<c14e11ea>] _raw_spin_lock_irq+0x15/0x7a
softirqs last  enabled at (23333678): [<c1031d2d>] __do_softirq+0x142/0x2ce
softirqs last disabled at (23333649): [<c1031fec>] irq_exit+0x6d/0x73

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&ip->i_lock)->mr_lock);
  <Interrupt>
    lock(&(&ip->i_lock)->mr_lock);

 *** DEADLOCK ***

3 locks held by tar/287:
 #0:  (sb_writers#8){.+.+.+}, at: [<c110d858>] mnt_want_write+0x1e/0x3e
 #1:  (&(&ip->i_lock)->mr_lock){++++?-}, at: [<c120cc1b>] xfs_ilock+0x100/0x1f1
 #2:  (sb_internal){.+.+.+}, at: [<c11cb6d0>] xfs_trans_alloc+0x1f/0x35

stack backtrace:
CPU: 0 PID: 287 Comm: tar Not tainted 3.11.0+ #2
Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
 de296540 de296540 de3e7d5c c14db319 de3e7d98 c14d8708 c1618f4e c1619343
 0000011f 00000000 00000000 00000000 00000000 00000001 00000001 c1619343
 0000000a de2969b0 00000400 de3e7dcc c106e6c4 0000000a de3e7e1c c10703d1
Call Trace:
 [<c14db319>] dump_stack+0x16/0x18
 [<c14d8708>] print_usage_bug+0x1dc/0x1e6
 [<c106e6c4>] mark_lock+0x28c/0x2c1
 [<c10703d1>] ? __lock_acquire+0x375/0x1953
 [<c106dc88>] ? print_shortest_lock_dependencies+0x18f/0x18f
 [<c106e77a>] mark_held_locks+0x81/0xe7
 [<c106f136>] lockdep_trace_alloc+0xa1/0xe3
 [<c10ec3ed>] kmem_cache_alloc+0x28/0x1f2
 [<c11cd53f>] ? kmem_zone_alloc+0x55/0xd0
 [<c11cd53f>] kmem_zone_alloc+0x55/0xd0
 [<c11cb6d0>] ? xfs_trans_alloc+0x1f/0x35
 [<c11cd5cb>] kmem_zone_zalloc+0x11/0x36
 [<c11cb663>] _xfs_trans_alloc+0x2e/0x7c
 [<c11cb6de>] xfs_trans_alloc+0x2d/0x35
 [<c1210743>] xfs_inactive+0x129/0x4a3
 [<c106ebaf>] ? trace_hardirqs_on+0xb/0xd
 [<c14e1375>] ? _raw_spin_unlock_irq+0x27/0x36
 [<c11c807d>] xfs_fs_evict_inode+0x6c/0x114
 [<c1108268>] evict+0x8e/0x15d
 [<c1108d16>] iput+0xc4/0x138
 [<c10fec3c>] do_unlinkat+0x127/0x17f
 [<c102547e>] ? vmalloc_sync_all+0x133/0x133
 [<c10fecb7>] SyS_unlinkat+0x23/0x3a
 [<c14e273b>] sysenter_do_call+0x12/0x32

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
