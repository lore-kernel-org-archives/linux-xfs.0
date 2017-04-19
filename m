Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from firestarter.dermichi.com ([194.177.153.153]:53550 "EHLO
        firestarter.dermichi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936556AbdDSUK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 16:10:58 -0400
Received: from [2a00:12e0:f000:1:ed95:5178:e6f:eb84]
        by firestarter.dermichi.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim)
        (envelope-from <mw@dermichi.com>)
        id 1d0vwF-00077Q-GT
        for linux-xfs@vger.kernel.org; Wed, 19 Apr 2017 22:10:55 +0200
From: Michael Weissenbacher <mw@dermichi.com>
Subject: Re: xfsaild in D state seems to be blocking all other i/o
 sporadically
References: <e5f2ccc2-7923-934c-e655-59983903ca11@dermichi.com>
 <20170419121202.2m3pi4ffojpnqyxc@eorzea.usersys.redhat.com>
 <ced08a44-d736-6250-c682-0f495a882bea@dermichi.com>
 <82e1fa48-909c-97a4-6bf9-5b84cf0af986@dermichi.com>
 <20170419140446.3rl2pruz2dlcr5cg@eorzea.usersys.redhat.com>
 <d6f598d1-7e7e-ac85-3cdc-e4f4bfdba94e@dermichi.com>
 <20170419180811.GB41631@bfoster.bfoster>
Message-ID: <268ce851-dad0-a777-526a-82ad967490cd@dermichi.com>
Date: Wed, 19 Apr 2017 22:10:55 +0200
MIME-Version: 1.0
In-Reply-To: <20170419180811.GB41631@bfoster.bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi Brian!

On 2017-04-19 20:08, Brian Foster wrote:
> On Wed, Apr 19, 2017 at 06:36:00PM +0200, Michael Weissenbacher wrote:
>> On 19.04.2017 16:04, Carlos Maiolino wrote:
>>> If I am not blind, the task currently owning the cpu isn't listed there, which I
>>> suppose to be already running.
>> Correct, the only process utilizing the CPU is xfsaild. It is also the
>> only process doing I/O, and it looks like it's doing only reads. It
>> (xfsaild) never shows up in dmesg as blocked.
>>
> 
> A snippet of tracepoint output from the fs might also be interesting
> when you hit this state. E.g., 'trace-cmd start -e xfs:*' and save the
> output of /sys/kernel/debug/tracing/trace_pipe to a file for a few
> seconds or so.
> 
See:
https://we.tl/7AAyBZxt4R

> BTW, is the original /proc/meminfo output you posted from the system in
> a normal state or when the problem occurs? If the former, could you
> include it while the problem occurs as well?
It was from a normal state.

All the following was captured during the problem occurs.

*** snip ***
/proc/meminfo

Wed Apr 19 20:36:50 CEST 2017
MemTotal:       65886208 kB
MemFree:         2923552 kB
MemAvailable:   43018524 kB
Buffers:              52 kB
Cached:         32416864 kB
SwapCached:          580 kB
Active:         30685760 kB
Inactive:        2051532 kB
Active(anon):     165844 kB
Inactive(anon):   155516 kB
Active(file):   30519916 kB
Inactive(file):  1896016 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:      64511996 kB
SwapFree:       64506540 kB
Dirty:            202368 kB
Writeback:             0 kB
AnonPages:        319948 kB
Mapped:            18672 kB
Shmem:               868 kB
Slab:           22817492 kB
SReclaimable:   16332540 kB
SUnreclaim:      6484952 kB
KernelStack:        4048 kB
PageTables:        16516 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    97455100 kB
Committed_AS:     516532 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       88820 kB
DirectMap2M:     7155712 kB
DirectMap1G:    61865984 kB
*** snip ***

*** snip ***
Wed Apr 19 20:36:51 CEST 2017
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab>
<pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata
<active_slabs> <num_slabs> <sharedavail>
kcopyd_job             0      0   3240    2    2 : tunables   24   12
8 : slabdata      0      0      0
dm_uevent              0      0   2632    3    2 : tunables   24   12
8 : slabdata      0      0      0
t10_pr_reg_cache       0      0    704   11    2 : tunables   54   27
8 : slabdata      0      0      0
ext4_groupinfo_4k      8     28    144   28    1 : tunables  120   60
8 : slabdata      1      1      0
ext4_inode_cache     328    330   1072    3    1 : tunables   24   12
8 : slabdata    110    110      0
ext4_allocation_context      0      0    128   32    1 : tunables  120
60    8 : slabdata      0      0      0
ext4_io_end            0      0     64   64    1 : tunables  120   60
8 : slabdata      0      0      0
ext4_extent_status     36    198     40   99    1 : tunables  120   60
 8 : slabdata      2      2      0
jbd2_journal_head      0      0    112   36    1 : tunables  120   60
8 : slabdata      0      0      0
jbd2_revoke_table_s      0      0     16  240    1 : tunables  120   60
  8 : slabdata      0      0      0
jbd2_revoke_record_s      0      0     32  124    1 : tunables  120   60
   8 : slabdata      0      0      0
fscrypt_info           0      0     24  163    1 : tunables  120   60
8 : slabdata      0      0      0
fscrypt_ctx            0      0     48   83    1 : tunables  120   60
8 : slabdata      0      0      0
mbcache                0      0     56   71    1 : tunables  120   60
8 : slabdata      0      0      0
kvm_async_pf           0      0    136   30    1 : tunables  120   60
8 : slabdata      0      0      0
kvm_vcpu               0      0  19136    1    8 : tunables    8    4
0 : slabdata      0      0      0
kvm_mmu_page_header      0      0    168   24    1 : tunables  120   60
  8 : slabdata      0      0      0
xfs_dqtrx             14     14    528    7    1 : tunables   54   27
8 : slabdata      2      2      0
xfs_dquot            149    168    472    8    1 : tunables   54   27
8 : slabdata     21     21      0
xfs_rui_item           0      0    664    6    1 : tunables   54   27
8 : slabdata      0      0      0
xfs_rud_item           0      0    144   28    1 : tunables  120   60
8 : slabdata      0      0      0
xfs_icr                0      0    152   26    1 : tunables  120   60
8 : slabdata      0      0      0
xfs_inode         12898650 12907268    960    4    1 : tunables   54
27    8 : slabdata 3226817 3226817      0
xfs_efd_item           0      0    408   10    1 : tunables   54   27
8 : slabdata      0      0      0
xfs_da_state           0      0    480    8    1 : tunables   54   27
8 : slabdata      0      0      0
xfs_btree_cur        105    153    232   17    1 : tunables  120   60
8 : slabdata      9      9      0
bio-2                 52     96    320   12    1 : tunables   54   27
8 : slabdata      8      8      0
ip6-frags              0      0    200   20    1 : tunables  120   60
8 : slabdata      0      0      0
UDPv6                 18     28   1152    7    2 : tunables   24   12
8 : slabdata      4      4      0
tw_sock_TCPv6          0      0    240   17    1 : tunables  120   60
8 : slabdata      0      0      0
request_sock_TCPv6      0      0    304   13    1 : tunables   54   27
 8 : slabdata      0      0      0
TCPv6                  7     12   2112    3    2 : tunables   24   12
8 : slabdata      4      4      0
cfq_queue          99928  99977    240   17    1 : tunables  120   60
8 : slabdata   5881   5881      0
mqueue_inode_cache      1      4    896    4    1 : tunables   54   27
 8 : slabdata      1      1      0
userfaultfd_ctx_cache      0      0    128   32    1 : tunables  120
60    8 : slabdata      0      0      0
dio                    0      0    640    6    1 : tunables   54   27
8 : slabdata      0      0      0
pid_namespace          0      0   2232    3    2 : tunables   24   12
8 : slabdata      0      0      0
posix_timers_cache      0      0    216   18    1 : tunables  120   60
 8 : slabdata      0      0      0
ip4-frags             34    132    184   22    1 : tunables  120   60
8 : slabdata      6      6      0
PING                   0      0    896    4    1 : tunables   54   27
8 : slabdata      0      0      0
UDP                   44     44    960    4    1 : tunables   54   27
8 : slabdata     11     11      0
tw_sock_TCP            1     17    240   17    1 : tunables  120   60
8 : slabdata      1      1      0
request_sock_TCP       0      0    304   13    1 : tunables   54   27
8 : slabdata      0      0      0
TCP                   18     22   1920    2    1 : tunables   24   12
8 : slabdata     11     11      0
hugetlbfs_inode_cache      2      6    600    6    1 : tunables   54
27    8 : slabdata      1      1      0
dquot                  0      0    256   16    1 : tunables  120   60
8 : slabdata      0      0      0
request_queue          3     15   1488    5    2 : tunables   24   12
8 : slabdata      3      3      0
blkdev_ioc           100    234    104   39    1 : tunables  120   60
8 : slabdata      6      6      0
user_namespace         0      0    448    9    1 : tunables   54   27
8 : slabdata      0      0      0
dmaengine-unmap-256      1      3   2112    3    2 : tunables   24   12
  8 : slabdata      1      1      0
dmaengine-unmap-128      1      7   1088    7    2 : tunables   24   12
  8 : slabdata      1      1      0
sock_inode_cache     179    204    640    6    1 : tunables   54   27
8 : slabdata     34     34      0
file_lock_cache       83     95    208   19    1 : tunables  120   60
8 : slabdata      5      5      0
net_namespace          0      0   5888    1    2 : tunables    8    4
0 : slabdata      0      0      0
shmem_inode_cache    775    825    688   11    2 : tunables   54   27
8 : slabdata     75     75      0
taskstats              2     12    328   12    1 : tunables   54   27
8 : slabdata      1      1      0
proc_inode_cache    2024   2190    656    6    1 : tunables   54   27
8 : slabdata    343    365    200
sigqueue          12104736 12110275    160   25    1 : tunables  120
60    8 : slabdata 484411 484411      0
bdev_cache             8     20    832    4    1 : tunables   54   27
8 : slabdata      5      5      0
kernfs_node_cache  29210  29240    120   34    1 : tunables  120   60
8 : slabdata    860    860      0
mnt_cache         652927 827520    384   10    1 : tunables   54   27
8 : slabdata  82752  82752      0
inode_cache        12968  12985    584    7    1 : tunables   54   27
8 : slabdata   1854   1855      0
dentry            12741855 12742065    192   21    1 : tunables  120
60    8 : slabdata 606757 606765    480
iint_cache             0      0     72   56    1 : tunables  120   60
8 : slabdata      0      0      0
buffer_head       127140 127140    104   39    1 : tunables  120   60
8 : slabdata   3260   3260      0
fs_cache             171    378     64   63    1 : tunables  120   60
8 : slabdata      6      6      0
files_cache          158    220    704   11    2 : tunables   54   27
8 : slabdata     20     20      0
signal_cache         425    508   1024    4    1 : tunables   54   27
8 : slabdata    127    127      0
sighand_cache        261    294   2112    3    2 : tunables   24   12
8 : slabdata     98     98      0
task_struct          278    295   3648    1    1 : tunables   24   12
8 : slabdata    278    295      0
cred_jar           15411  17451    192   21    1 : tunables  120   60
8 : slabdata    831    831     60
Acpi-Operand      147223 147504     72   56    1 : tunables  120   60
8 : slabdata   2634   2634      0
Acpi-Parse            69    355     56   71    1 : tunables  120   60
8 : slabdata      5      5      0
Acpi-State             0      0     80   51    1 : tunables  120   60
8 : slabdata      0      0      0
Acpi-Namespace     13264  13365     40   99    1 : tunables  120   60
8 : slabdata    135    135      0
anon_vma_chain     11212  14336     64   64    1 : tunables  120   60
8 : slabdata    224    224     60
anon_vma            6167   7000     72   56    1 : tunables  120   60
8 : slabdata    125    125      0
pid                  312    576    128   32    1 : tunables  120   60
8 : slabdata     18     18      0
numa_policy            5    163     24  163    1 : tunables  120   60
8 : slabdata      1      1      0
trace_event_file    2418   2530     88   46    1 : tunables  120   60
8 : slabdata     55     55      0
ftrace_event_field   3691   3901     48   83    1 : tunables  120   60
 8 : slabdata     47     47      0
pool_workqueue        26     96    256   16    1 : tunables  120   60
8 : slabdata      6      6      0
radix_tree_node   1644760 1707538    576    7    1 : tunables   54   27
  8 : slabdata 243934 243934      0
task_group            43     84    576    7    1 : tunables   54   27
8 : slabdata     12     12      0
dma-kmalloc-4194304      0      0 4194304    1 1024 : tunables    1    1
   0 : slabdata      0      0      0
dma-kmalloc-2097152      0      0 2097152    1  512 : tunables    1    1
   0 : slabdata      0      0      0
dma-kmalloc-1048576      0      0 1048576    1  256 : tunables    1    1
   0 : slabdata      0      0      0
dma-kmalloc-524288      0      0 524288    1  128 : tunables    1    1
 0 : slabdata      0      0      0
dma-kmalloc-262144      0      0 262144    1   64 : tunables    1    1
 0 : slabdata      0      0      0
dma-kmalloc-131072      0      0 131072    1   32 : tunables    8    4
 0 : slabdata      0      0      0
dma-kmalloc-65536      0      0  65536    1   16 : tunables    8    4
0 : slabdata      0      0      0
dma-kmalloc-32768      0      0  32768    1    8 : tunables    8    4
0 : slabdata      0      0      0
dma-kmalloc-16384      0      0  16384    1    4 : tunables    8    4
0 : slabdata      0      0      0
dma-kmalloc-8192       0      0   8192    1    2 : tunables    8    4
0 : slabdata      0      0      0
dma-kmalloc-4096       0      0   4096    1    1 : tunables   24   12
8 : slabdata      0      0      0
dma-kmalloc-2048       0      0   2048    2    1 : tunables   24   12
8 : slabdata      0      0      0
dma-kmalloc-1024       0      0   1024    4    1 : tunables   54   27
8 : slabdata      0      0      0
dma-kmalloc-512        4      8    512    8    1 : tunables   54   27
8 : slabdata      1      1      0
dma-kmalloc-256        0      0    256   16    1 : tunables  120   60
8 : slabdata      0      0      0
dma-kmalloc-128        0      0    128   32    1 : tunables  120   60
8 : slabdata      0      0      0
dma-kmalloc-64         0      0     64   64    1 : tunables  120   60
8 : slabdata      0      0      0
dma-kmalloc-32         4    124     32  124    1 : tunables  120   60
8 : slabdata      1      1      0
dma-kmalloc-192        0      0    192   21    1 : tunables  120   60
8 : slabdata      0      0      0
dma-kmalloc-96         0      0    128   32    1 : tunables  120   60
8 : slabdata      0      0      0
kmalloc-4194304        0      0 4194304    1 1024 : tunables    1    1
 0 : slabdata      0      0      0
kmalloc-2097152        0      0 2097152    1  512 : tunables    1    1
 0 : slabdata      0      0      0
kmalloc-1048576        0      0 1048576    1  256 : tunables    1    1
 0 : slabdata      0      0      0
kmalloc-524288         1      1 524288    1  128 : tunables    1    1
0 : slabdata      1      1      0
kmalloc-262144         3      3 262144    1   64 : tunables    1    1
0 : slabdata      3      3      0
kmalloc-131072         3      3 131072    1   32 : tunables    8    4
0 : slabdata      3      3      0
kmalloc-65536         13     13  65536    1   16 : tunables    8    4
0 : slabdata     13     13      0
kmalloc-32768          4      4  32768    1    8 : tunables    8    4
0 : slabdata      4      4      0
kmalloc-16384         23     23  16384    1    4 : tunables    8    4
0 : slabdata     23     23      0
kmalloc-8192       44121  44121   8192    1    2 : tunables    8    4
0 : slabdata  44121  44121      0
kmalloc-4096       11850  11850   4096    1    1 : tunables   24   12
8 : slabdata  11850  11850     24
kmalloc-2048       18655  18718   2048    2    1 : tunables   24   12
8 : slabdata   9359   9359      0
kmalloc-1024      584913 603244   1024    4    1 : tunables   54   27
8 : slabdata 150811 150811      0
kmalloc-512       856079 1020576    512    8    1 : tunables   54   27
 8 : slabdata 127572 127572      0
kmalloc-256       114928 141968    256   16    1 : tunables  120   60
8 : slabdata   8873   8873    480
kmalloc-192       244249 272643    192   21    1 : tunables  120   60
8 : slabdata  12983  12983      0
kmalloc-96        3139278 3139328    128   32    1 : tunables  120   60
  8 : slabdata  98104  98104      0
kmalloc-64        25714408 33297024     64   64    1 : tunables  120
60    8 : slabdata 520266 520266      0
kmalloc-32        423132 631036     32  124    1 : tunables  120   60
8 : slabdata   5089   5089      0
kmalloc-128       213657 269952    128   32    1 : tunables  120   60
8 : slabdata   8436   8436      0
*** snip ***

*** snip ***
/proc/<pidof_xfsaild>/stack
Wed Apr 19 20:36:52 CEST 2017
[<ffffffff8ef3881e>] ring_buffer_unlock_commit+0x1e/0xa0
[<ffffffff8ef419a7>] trace_buffer_unlock_commit_regs+0x37/0x90
[<ffffffff8eea1e20>] wake_up_q+0x60/0x60
[<ffffffffc0719b5b>] xfs_buf_read_map+0x10b/0x180 [xfs]
[<ffffffffc0719888>] xfs_buf_submit_wait+0x78/0x210 [xfs]
[<ffffffffc074d2bd>] xfs_trans_read_buf_map+0xed/0x300 [xfs]
[<ffffffffc0719b5b>] xfs_buf_read_map+0x10b/0x180 [xfs]
[<ffffffffc074d2bd>] xfs_trans_read_buf_map+0xed/0x300 [xfs]
[<ffffffffc0702b77>] xfs_imap_to_bp+0x67/0xe0 [xfs]
[<ffffffffc072e84b>] xfs_iflush+0xdb/0x240 [xfs]
[<ffffffffc07437f9>] xfs_inode_item_push+0x69/0x140 [xfs]
[<ffffffffc0743886>] xfs_inode_item_push+0xf6/0x140 [xfs]
[<ffffffffc074bf25>] xfsaild+0x385/0x7e0 [xfs]
[<ffffffffc074bba0>] xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
[<ffffffff8ee96d64>] kthread+0x104/0x140
[<ffffffff8ee96d64>] kthread+0x104/0x140
[<ffffffff8ee96c60>] kthread_park+0x80/0x80
[<ffffffff8ee7ba79>] do_group_exit+0x39/0xb0
[<ffffffff8f4370b6>] ret_from_fork+0x26/0x40
[<ffffffffffffffff>] 0xffffffffffffffff
*** snip ***

*** snip ***
iotop --batch -o output

Total DISK READ :    1948.60 K/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:     974.30 K/s | Actual DISK WRITE:       0.00 B/s
    TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   1609 be/4 root     1948.60 K/s    0.00 B/s  0.00 %  0.00 %
[xfsaild/md127]
Total DISK READ :    1924.56 K/s | Total DISK WRITE :       3.94 K/s
Actual DISK READ:    1956.11 K/s | Actual DISK WRITE:       0.00 B/s
    TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   1609 be/4 root     1924.56 K/s    0.00 B/s  0.00 %  0.00 %
[xfsaild/md127]
Total DISK READ :       2.53 M/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:       2.51 M/s | Actual DISK WRITE:      63.77 K/s
    TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   1609 be/4 root        2.53 M/s    0.00 B/s  0.00 %  0.00 %
[xfsaild/md127]
Total DISK READ :       2.09 M/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:       2.10 M/s | Actual DISK WRITE:       0.00 B/s
    TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   1609 be/4 root        2.09 M/s    0.00 B/s  0.00 %  0.00 %
[xfsaild/md127]
Total DISK READ :      12.12 M/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:      12.10 M/s | Actual DISK WRITE:       0.00 B/s
    TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   1609 be/4 root       12.12 M/s    0.00 B/s  0.00 %  0.00 %
[xfsaild/md127]
Total DISK READ :       2.30 M/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:       2.28 M/s | Actual DISK WRITE:       0.00 B/s
    TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   1609 be/4 root        2.30 M/s    0.00 B/s  0.00 %  0.00 %
[xfsaild/md127]
Total DISK READ :       4.86 M/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:       4.88 M/s | Actual DISK WRITE:    2025.26 K/s
    TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   1609 be/4 root        4.86 M/s    0.00 B/s  0.00 %  0.00 %
[xfsaild/md127]
Total DISK READ :       2.64 M/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:       2.62 M/s | Actual DISK WRITE:       0.00 B/s
    TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   1609 be/4 root        2.64 M/s    0.00 B/s  0.00 %  0.00 %
[xfsaild/md127]
Total DISK READ :    1899.36 K/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:    1899.36 K/s | Actual DISK WRITE:       0.00 B/s
    TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   1609 be/4 root     1899.36 K/s    0.00 B/s  0.00 %  0.00 %
[xfsaild/md127]
Total DISK READ :    1837.53 K/s | Total DISK WRITE :       0.00 B/s
Actual DISK READ:    1837.53 K/s | Actual DISK WRITE:       0.00 B/s
    TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   1609 be/4 root     1837.53 K/s    0.00 B/s  0.00 %  0.00 %
[xfsaild/md127]
*** snip ***

