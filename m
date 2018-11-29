Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40650 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbeK3JaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Nov 2018 04:30:07 -0500
Received: by mail-qk1-f195.google.com with SMTP id y16so2072134qki.7
        for <linux-xfs@vger.kernel.org>; Thu, 29 Nov 2018 14:23:05 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi1YZp+baxpON2R6mP09pjkUz5D-OE7Z2KmwVGycYTN-AA@mail.gmail.com>
 <20181129021800.GQ6311@dastard>
In-Reply-To: <20181129021800.GQ6311@dastard>
From: Ivan Babrou <ivan@cloudflare.com>
Date: Thu, 29 Nov 2018 14:22:53 -0800
Message-ID: <CABWYdi0Bd6sMAaTPkfHKupMGpw1QPSf_VohPF_Wg7Mm=W=j2bA@mail.gmail.com>
Subject: Re: Non-blocking socket stuck for multiple seconds on xfs_reclaim_inodes_ag()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, Shawn Bohrer <sbohrer@cloudflare.com>

On Wed, Nov 28, 2018 at 6:18 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Nov 28, 2018 at 04:36:25PM -0800, Ivan Babrou wrote:
> > Hello,
> >
> > We're experiencing some interesting issues with memory reclaim, both
> > kswapd and direct reclaim.
> >
> > A typical machine is 2 x NUMA with 128GB of RAM and 6 XFS filesystems.
> > Page cache is around 95GB and dirty pages hover around 50MB, rarely
> > jumping up to 1GB.
>
> What is your workload?

My test setup is an empty machine with 256GB of RAM booted from
network into memory with just systemd essentials running.

I create XFS on a 10TB drive (via LUKS), mount the drive and write
300GiB of randomness:

$ sudo mkfs.xfs /dev/mapper/luks-sda
$ sudo mount /dev/mapper/luks-sda /mnt
$ sudo dd if=/dev/urandom of=/mnt/300g.random bs=1M count=300K status=progress

Then I reboot and just mount the drive again to run my test workload:

$ dd if=/mnt/300g.random of=/dev/null bs=1M status=progress

After running it once and populating page cache I restart it to collect traces.

Here's xfs_info:

$ sudo xfs_info /mnt
meta-data=/dev/mapper/luks-sda   isize=512    agcount=10, agsize=268435455 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=2441608704, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

And here's slabinfo:

$ sudo cat /proc/slabinfo
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab>
<pagesperslab> : tunables <limit> <batchcount> <sharedfactor> :
slabdata <active_slabs> <num_slabs> <sharedavail>
kcopyd_job             0      0   3312    9    8 : tunables    0    0
  0 : slabdata      0      0      0
dm_uevent              0      0   2632   12    8 : tunables    0    0
  0 : slabdata      0      0      0
dax_cache             96    504    768   42    8 : tunables    0    0
  0 : slabdata     12     12      0
nf_conntrack_expect      0      0    224   36    2 : tunables    0
0    0 : slabdata      0      0      0
nf_conntrack           0      0    320   51    4 : tunables    0    0
  0 : slabdata      0      0      0
kvm_async_pf           0      0    136   30    1 : tunables    0    0
  0 : slabdata      0      0      0
kvm_vcpu               0      0  19392    1    8 : tunables    0    0
  0 : slabdata      0      0      0
kvm_mmu_page_header      0      0    168   48    2 : tunables    0
0    0 : slabdata      0      0      0
pte_list_desc          0      0     32  128    1 : tunables    0    0
  0 : slabdata      0      0      0
ip6-frags              0      0    208   39    2 : tunables    0    0
  0 : slabdata      0      0      0
RAWv6                168    168   1152   28    8 : tunables    0    0
  0 : slabdata      6      6      0
UDPv6                900    900   1280   25    8 : tunables    0    0
  0 : slabdata     36     36      0
tw_sock_TCPv6       1122   1122    248   33    2 : tunables    0    0
  0 : slabdata     34     34      0
request_sock_TCPv6      0      0    312   52    4 : tunables    0    0
   0 : slabdata      0      0      0
TCPv6                420    420   2240   14    8 : tunables    0    0
  0 : slabdata     30     30      0
cfq_io_cq           1156   1156    120   34    1 : tunables    0    0
  0 : slabdata     34     34      0
mqueue_inode_cache     34     34    960   34    8 : tunables    0    0
   0 : slabdata      1      1      0
xfs_dqtrx              0      0    528   31    4 : tunables    0    0
  0 : slabdata      0      0      0
xfs_rui_item           0      0    672   48    8 : tunables    0    0
  0 : slabdata      0      0      0
xfs_rud_item           0      0    152   53    2 : tunables    0    0
  0 : slabdata      0      0      0
xfs_ili              144    144    168   48    2 : tunables    0    0
  0 : slabdata      3      3      0
xfs_inode            170    170    960   34    8 : tunables    0    0
  0 : slabdata      5      5      0
xfs_efd_item           0      0    416   39    4 : tunables    0    0
  0 : slabdata      0      0      0
xfs_buf_item         132    132    248   33    2 : tunables    0    0
  0 : slabdata      4      4      0
xfs_da_state           0      0    480   34    4 : tunables    0    0
  0 : slabdata      0      0      0
xfs_btree_cur        420    420    232   35    2 : tunables    0    0
  0 : slabdata     12     12      0
xfs_log_ticket       308    308    184   44    2 : tunables    0    0
  0 : slabdata      7      7      0
bio-2                 51     51    320   51    4 : tunables    0    0
  0 : slabdata      1      1      0
nfs_direct_cache       0      0    336   48    4 : tunables    0    0
  0 : slabdata      0      0      0
nfs_read_data         36     36    896   36    8 : tunables    0    0
  0 : slabdata      1      1      0
nfs_inode_cache        0      0   1080   30    8 : tunables    0    0
  0 : slabdata      0      0      0
isofs_inode_cache      0      0    656   49    8 : tunables    0    0
  0 : slabdata      0      0      0
fat_inode_cache        0      0    744   44    8 : tunables    0    0
  0 : slabdata      0      0      0
fat_cache              0      0     40  102    1 : tunables    0    0
  0 : slabdata      0      0      0
jbd2_journal_head      0      0    120   34    1 : tunables    0    0
  0 : slabdata      0      0      0
jbd2_revoke_table_s      0      0     16  256    1 : tunables    0
0    0 : slabdata      0      0      0
ext4_inode_cache       0      0   1088   30    8 : tunables    0    0
  0 : slabdata      0      0      0
ext4_allocation_context      0      0    128   32    1 : tunables    0
   0    0 : slabdata      0      0      0
ext4_io_end            0      0     64   64    1 : tunables    0    0
  0 : slabdata      0      0      0
ext4_extent_status      0      0     40  102    1 : tunables    0    0
   0 : slabdata      0      0      0
mbcache                0      0     56   73    1 : tunables    0    0
  0 : slabdata      0      0      0
fscrypt_info           0      0     32  128    1 : tunables    0    0
  0 : slabdata      0      0      0
fscrypt_ctx            0      0     48   85    1 : tunables    0    0
  0 : slabdata      0      0      0
userfaultfd_ctx_cache      0      0    192   42    2 : tunables    0
 0    0 : slabdata      0      0      0
dio                    0      0    640   51    8 : tunables    0    0
  0 : slabdata      0      0      0
pid_namespace          0      0   2232   14    8 : tunables    0    0
  0 : slabdata      0      0      0
posix_timers_cache    884    884    240   34    2 : tunables    0    0
   0 : slabdata     26     26      0
rpc_inode_cache        0      0    704   46    8 : tunables    0    0
  0 : slabdata      0      0      0
ip4-frags            185    185    216   37    2 : tunables    0    0
  0 : slabdata      5      5      0
xfrm_dst_cache         0      0    448   36    4 : tunables    0    0
  0 : slabdata      0      0      0
RAW                 1564   1564    960   34    8 : tunables    0    0
  0 : slabdata     46     46      0
tw_sock_TCP          990    990    248   33    2 : tunables    0    0
  0 : slabdata     30     30      0
request_sock_TCP     520    520    312   52    4 : tunables    0    0
  0 : slabdata     10     10      0
TCP                  544    544   2048   16    8 : tunables    0    0
  0 : slabdata     34     34      0
hugetlbfs_inode_cache    104    104    624   52    8 : tunables    0
 0    0 : slabdata      2      2      0
dquot                  0      0    256   32    2 : tunables    0    0
  0 : slabdata      0      0      0
request_queue        195    195   2144   15    8 : tunables    0    0
  0 : slabdata     13     13      0
blkdev_ioc          1560   1560    104   39    1 : tunables    0    0
  0 : slabdata     40     40      0
user_namespace         0      0    440   37    4 : tunables    0    0
  0 : slabdata      0      0      0
dmaengine-unmap-256     15     15   2112   15    8 : tunables    0
0    0 : slabdata      1      1      0
dmaengine-unmap-128   1230   1230   1088   30    8 : tunables    0
0    0 : slabdata     41     41      0
sock_inode_cache    6808   6808    704   46    8 : tunables    0    0
  0 : slabdata    148    148      0
file_lock_cache     1600   1600    200   40    2 : tunables    0    0
  0 : slabdata     40     40      0
fsnotify_mark_connector   5610   5610     24  170    1 : tunables    0
   0    0 : slabdata     33     33      0
net_namespace          5      5   5888    5    8 : tunables    0    0
  0 : slabdata      1      1      0
taskstats           1813   1813    328   49    4 : tunables    0    0
  0 : slabdata     37     37      0
proc_inode_cache   13776  13776    680   48    8 : tunables    0    0
  0 : slabdata    287    287      0
sigqueue            2040   2040    160   51    2 : tunables    0    0
  0 : slabdata     40     40      0
bdev_cache           909   1287    832   39    8 : tunables    0    0
  0 : slabdata     33     33      0
shmem_inode_cache  48414  49864    712   46    8 : tunables    0    0
  0 : slabdata   1084   1084      0
kernfs_node_cache  54722  54780    136   30    1 : tunables    0    0
  0 : slabdata   1826   1826      0
mnt_cache           1890   1890    384   42    4 : tunables    0    0
  0 : slabdata     45     45      0
inode_cache        25175  26447    608   53    8 : tunables    0    0
  0 : slabdata    499    499      0
dentry            108066 117096    192   42    2 : tunables    0    0
  0 : slabdata   2788   2788      0
iint_cache             0      0     80   51    1 : tunables    0    0
  0 : slabdata      0      0      0
buffer_head          585    585    104   39    1 : tunables    0    0
  0 : slabdata     15     15      0
vm_area_struct     69560  69760    200   40    2 : tunables    0    0
  0 : slabdata   1744   1744      0
mm_struct           4920   4920   1088   30    8 : tunables    0    0
  0 : slabdata    164    164      0
files_cache         6624   6624    704   46    8 : tunables    0    0
  0 : slabdata    144    144      0
signal_cache        7040   7200   1024   32    8 : tunables    0    0
  0 : slabdata    225    225      0
sighand_cache       2670   2670   2112   15    8 : tunables    0    0
  0 : slabdata    178    178      0
task_struct         1431   1468   7744    4    8 : tunables    0    0
  0 : slabdata    367    367      0
cred_jar           20580  20580    192   42    2 : tunables    0    0
  0 : slabdata    490    490      0
Acpi-Operand       21504  21504     72   56    1 : tunables    0    0
  0 : slabdata    384    384      0
Acpi-Parse          2920   2920     56   73    1 : tunables    0    0
  0 : slabdata     40     40      0
Acpi-State          1836   1836     80   51    1 : tunables    0    0
  0 : slabdata     36     36      0
Acpi-Namespace     80882  82416     40  102    1 : tunables    0    0
  0 : slabdata    808    808      0
anon_vma_chain     95424  95744     64   64    1 : tunables    0    0
  0 : slabdata   1496   1496      0
anon_vma           47886  47886     88   46    1 : tunables    0    0
  0 : slabdata   1041   1041      0
pid                 7776   7776    128   32    1 : tunables    0    0
  0 : slabdata    243    243      0
numa_policy           62     62    264   31    2 : tunables    0    0
  0 : slabdata      2      2      0
trace_event_file    2208   2208     88   46    1 : tunables    0    0
  0 : slabdata     48     48      0
ftrace_event_field   4675   4675     48   85    1 : tunables    0    0
   0 : slabdata     55     55      0
radix_tree_node   1266533 1266720    584   28    4 : tunables    0
0    0 : slabdata  45240  45240      0
task_group           184    184    704   46    8 : tunables    0    0
  0 : slabdata      4      4      0
dma-kmalloc-8192       0      0   8192    4    8 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-4096       0      0   4096    8    8 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-2048       0      0   2048   16    8 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-1024       0      0   1024   32    8 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-512        0      0    512   32    4 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-256        0      0    256   32    2 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-128        0      0    128   32    1 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-64         0      0     64   64    1 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-32         0      0     32  128    1 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-16         0      0     16  256    1 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-8          0      0      8  512    1 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-192        0      0    192   42    2 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-96         0      0     96   42    1 : tunables    0    0
  0 : slabdata      0      0      0
kmalloc-8192        1292   1292   8192    4    8 : tunables    0    0
  0 : slabdata    323    323      0
kmalloc-4096        1056   1056   4096    8    8 : tunables    0    0
  0 : slabdata    132    132      0
kmalloc-2048        3246   3312   2048   16    8 : tunables    0    0
  0 : slabdata    207    207      0
kmalloc-1024        9056   9056   1024   32    8 : tunables    0    0
  0 : slabdata    283    283      0
kmalloc-512         7487   7488    512   32    4 : tunables    0    0
  0 : slabdata    234    234      0
kmalloc-256        17544  18528    256   32    2 : tunables    0    0
  0 : slabdata    579    579      0
kmalloc-192        10416  10416    192   42    2 : tunables    0    0
  0 : slabdata    248    248      0
kmalloc-128         6756   6816    128   32    1 : tunables    0    0
  0 : slabdata    213    213      0
kmalloc-96         48655  49308     96   42    1 : tunables    0    0
  0 : slabdata   1174   1174      0
kmalloc-64         23650  23808     64   64    1 : tunables    0    0
  0 : slabdata    372    372      0
kmalloc-32         34432  34432     32  128    1 : tunables    0    0
  0 : slabdata    269    269      0
kmalloc-16         27392  27392     16  256    1 : tunables    0    0
  0 : slabdata    107    107      0
kmalloc-8          37376  37376      8  512    1 : tunables    0    0
  0 : slabdata     73     73      0
kmem_cache_node     1725   1728     64   64    1 : tunables    0    0
  0 : slabdata     27     27      0
kmem_cache           966    966    384   42    4 : tunables    0    0
  0 : slabdata     23     23      0

To illustrate the issue I'm issuing the simplest command I can come up with:

$ date; sudo touch /mnt/empty
Thu Nov 29 20:09:35 UTC 2018

Now let's see what happens in 10s surrounding this event. Please read
through all events to see the whole picture.

1. Memory reclaim is happening as it should (my working set is bigger than RAM):

$ sudo /usr/share/bcc/tools/funclatency -mTi 1 shrink_node
Tracing 1 functions for "shrink_node"... Hit Ctrl-C to end.

...

20:09:30
     msecs               : count     distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 2        |**************************              |
         8 -> 15         : 1        |*************                           |
        16 -> 31         : 3        |****************************************|

20:09:31
     msecs               : count     distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 2        |****************************************|
         8 -> 15         : 1        |********************                    |

20:09:32
     msecs               : count     distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 0        |                                        |
         8 -> 15         : 0        |                                        |
        16 -> 31         : 3        |****************************************|

20:09:33
     msecs               : count     distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 2        |**************************              |
         8 -> 15         : 1        |*************                           |
        16 -> 31         : 3        |****************************************|

20:09:34

20:09:35
     msecs               : count     distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 2        |****************************************|
         8 -> 15         : 2        |****************************************|
        16 -> 31         : 2        |****************************************|

20:09:36
     msecs               : count     distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 1        |********************                    |
         8 -> 15         : 1        |********************                    |
        16 -> 31         : 2        |****************************************|
        32 -> 63         : 2        |****************************************|

20:09:37

20:09:38
     msecs               : count     distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 2        |****************************************|
         8 -> 15         : 2        |****************************************|
        16 -> 31         : 2        |****************************************|

20:09:39

20:09:40
     msecs               : count     distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 2        |****************************************|
         8 -> 15         : 2        |****************************************|
        16 -> 31         : 2        |****************************************|

2. XFS reclaim only kicks in when I create an empty file, silence otherwise:

$ sudo /usr/share/bcc/tools/funclatency -mTi 1 xfs_fs_free_cached_objects
Tracing 1 functions for "xfs_fs_free_cached_objects"... Hit Ctrl-C to end.

...

20:09:30

20:09:31

20:09:32

20:09:33

20:09:34

20:09:35

20:09:36

20:09:37
     msecs               : count     distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 0        |                                        |
         8 -> 15         : 0        |                                        |
        16 -> 31         : 0        |                                        |
        32 -> 63         : 2        |****************************************|

20:09:38

20:09:39

20:09:40

3. We can see that XFS inode is actually reclaimed from kswapd0:

$ sudo /usr/share/bcc/tools/stackcount -Ti 1 xfs_reclaim_inode
Tracing 1 functions for "xfs_reclaim_inode"... Hit Ctrl-C to end.

...

20:09:30

20:09:31

20:09:32

20:09:33

20:09:34

20:09:35

20:09:36
  xfs_reclaim_inode
  xfs_reclaim_inodes_ag
  xfs_reclaim_inodes_nr
  kretprobe_trampoline
    kswapd0 [1862]
    1


20:09:37

20:09:38

20:09:39

20:09:40

4. And we can also see that flush on disk is happening from the same kswapd0:

$ sudo /usr/share/bcc/tools/stackcount -Ti 1 xfs_iflush
Tracing 1 functions for "xfs_iflush"... Hit Ctrl-C to end.

...

20:09:30

20:09:31

20:09:32

20:09:33

20:09:34

20:09:35

20:09:36

20:09:37
  xfs_iflush
  xfs_reclaim_inode
  xfs_reclaim_inodes_ag
  xfs_reclaim_inodes_nr
  kretprobe_trampoline
    kswapd0 [1862]
    1


20:09:38

20:09:39

20:09:40

5. Back to XFS reclaim source locations, both kswapd0 and kswapd1 hit it:

ivan@36s336:~$ sudo /usr/share/bcc/tools/stackcount -Ti 1
xfs_fs_free_cached_objects
Tracing 1 functions for "xfs_fs_free_cached_objects"... Hit Ctrl-C to end.

...

20:09:30

20:09:31

20:09:32

20:09:33

20:09:34

20:09:35

20:09:36

20:09:37
  xfs_fs_free_cached_objects
  super_cache_scan
  shrink_slab.part.45
  shrink_node
  kretprobe_trampoline
    kswapd1 [1863]
    1

  xfs_fs_free_cached_objects
  super_cache_scan
  shrink_slab.part.45
  shrink_node
  kretprobe_trampoline
    kswapd0 [1862]
    1


20:09:38

20:09:39

20:09:40

6. And we can see that it was kswapd0 that flushed data to disk synchronously:

$ sudo /usr/share/bcc/tools/stackcount -Ti 1 xfs_buf_submit_wait
Tracing 1 functions for "xfs_buf_submit_wait"... Hit Ctrl-C to end.

...

20:09:30

20:09:31

20:09:32

20:09:33

20:09:34

20:09:35

20:09:36
  xfs_buf_submit_wait
  xfs_bwrite
  xfs_reclaim_inode
  xfs_reclaim_inodes_ag
  xfs_reclaim_inodes_nr
  kretprobe_trampoline
    kswapd0 [1862]
    1


20:09:37

20:09:38

20:09:39

20:09:40

7. Finally, we only see xfs_fs_nr_cached_objects return non-zero
around the same time:

$ sudo /usr/share/bcc/tools/trace -T 'r::xfs_fs_nr_cached_objects
(retval > 0) "cached = %d", retval'
TIME     PID     TID     COMM            FUNC             -
20:09:36 1862    1862    kswapd0         xfs_fs_nr_cached_objects cached = 1
20:09:36 1862    1862    kswapd0         xfs_fs_nr_cached_objects cached = 1
20:09:36 1863    1863    kswapd1         xfs_fs_nr_cached_objects cached = 1
20:09:36 1863    1863    kswapd1         xfs_fs_nr_cached_objects cached = 1

You can see that have 249GB of page cache:

$ free -h
              total        used        free      shared  buff/cache   available
Mem:           251G        1.0G        1.1G        656M        249G        248G
Swap:            0B          0B          0B

And the number of dirty pages is zero:

$ cat /proc/vmstat
nr_free_pages 295648
nr_zone_inactive_anon 99463
nr_zone_active_anon 76344
nr_zone_inactive_file 56796555
nr_zone_active_file 8297372
nr_zone_unevictable 0
nr_zone_write_pending 0
nr_mlock 0
nr_page_table_pages 1578
nr_kernel_stack 9168
nr_bounce 0
nr_free_cma 0
numa_hit 99220256
numa_miss 52104657
numa_foreign 52104657
numa_interleave 135792
numa_local 99127058
numa_other 52197855
nr_inactive_anon 99463
nr_active_anon 76344
nr_inactive_file 56796555
nr_active_file 8297372
nr_unevictable 0
nr_slab_reclaimable 194565
nr_slab_unreclaimable 43128
nr_isolated_anon 0
nr_isolated_file 0
workingset_refault 69892763
workingset_activate 289419
workingset_nodereclaim 0
nr_anon_pages 7700
nr_mapped 5765
nr_file_pages 65262134
nr_dirty 0
nr_writeback 0
nr_writeback_temp 0
nr_shmem 168119
nr_shmem_hugepages 0
nr_shmem_pmdmapped 0
nr_anon_transparent_hugepages 0
nr_unstable 0
nr_vmscan_write 0
nr_vmscan_immediate_reclaim 0
nr_dirtied 0
nr_written 0
nr_dirty_threshold 13017651
nr_dirty_background_threshold 6500878
pgpgin 594234184
pgpgout 2360
pswpin 0
pswpout 0
pgalloc_dma 0
pgalloc_dma32 348991
pgalloc_normal 151243219
pgalloc_movable 0
allocstall_dma 0
allocstall_dma32 0
allocstall_normal 0
allocstall_movable 0
pgskip_dma 0
pgskip_dma32 0
pgskip_normal 0
pgskip_movable 0
pgfree 151892594
pgactivate 8963375
pgdeactivate 742721
pglazyfree 0
pgfault 3796959
pgmajfault 0
pglazyfreed 0
pgrefill 742721
pgsteal_kswapd 83442196
pgsteal_direct 0
pgscan_kswapd 83442409
pgscan_direct 0
pgscan_direct_throttle 0
zone_reclaim_failed 0
pginodesteal 0
slabs_scanned 26710
kswapd_inodesteal 0
kswapd_low_wmark_hit_quickly 0
kswapd_high_wmark_hit_quickly 0
pageoutrun 1636
pgrotated 0
drop_pagecache 0
drop_slab 0
oom_kill 0
numa_pte_updates 0
numa_huge_pte_updates 0
numa_hint_faults 0
numa_hint_faults_local 0
numa_pages_migrated 0
pgmigrate_success 0
pgmigrate_fail 0
compact_migrate_scanned 0
compact_free_scanned 0
compact_isolated 0
compact_stall 0
compact_fail 0
compact_success 0
compact_daemon_wake 0
compact_daemon_migrate_scanned 0
compact_daemon_free_scanned 0
htlb_buddy_alloc_success 0
htlb_buddy_alloc_fail 0
unevictable_pgs_culled 18354
unevictable_pgs_scanned 0
unevictable_pgs_rescued 19851
unevictable_pgs_mlocked 19851
unevictable_pgs_munlocked 19851
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0
thp_fault_alloc 0
thp_fault_fallback 0
thp_collapse_alloc 0
thp_collapse_alloc_failed 0
thp_file_alloc 0
thp_file_mapped 0
thp_split_page 0
thp_split_page_failed 0
thp_deferred_split_page 0
thp_split_pmd 0
thp_split_pud 0
thp_zero_page_alloc 0
thp_zero_page_alloc_failed 0
thp_swpout 0
thp_swpout_fallback 0
balloon_inflate 0
balloon_deflate 0
balloon_migrate 0
swap_ra 0
swap_ra_hit 0

It's zero all the time, except for when I touch an empty file. There's
just no other write IO on the system.

The whole issue here is that synchronous IO from memory reclaim is
unbound in time. For all I know we can have 10TB drive that runs at
floppy drive speeds or worse.

The following can easily happen (correct me if it can't for some reason):

1. kswapd gets stuck because of slow storage and memory is not getting reclaimed
2. memory allocation doesn't have any free pages and kicks in direct reclaim
3. direct reclaim is stuck behind kswapd

I'm not sure why you say direct reclaim happens first, allocstall is zero.

> > The catalyst of our issue is terrible disks. It's not uncommon to see
> > the following stack in hung task detector:
> >
> > Nov 15 21:55:13 21m21 kernel: INFO: task some-task:156314 blocked for
> > more than 10 seconds.
> > Nov 15 21:55:13 21m21 kernel:       Tainted: G           O
> > 4.14.59-cloudflare-2018.7.5 #1
> > Nov 15 21:55:13 21m21 kernel: "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Nov 15 21:55:13 21m21 kernel: some-task     D11792 156314 156183 0x00000080
> > Nov 15 21:55:13 21m21 kernel: Call Trace:
> > Nov 15 21:55:13 21m21 kernel:  ? __schedule+0x21a/0x820
> > Nov 15 21:55:13 21m21 kernel:  schedule+0x28/0x80
> > Nov 15 21:55:13 21m21 kernel:  schedule_preempt_disabled+0xa/0x10
> > Nov 15 21:55:13 21m21 kernel:  __mutex_lock.isra.2+0x16a/0x490
> > Nov 15 21:55:13 21m21 kernel:  ? xfs_reclaim_inodes_ag+0x265/0x2d0
> > Nov 15 21:55:13 21m21 kernel:  xfs_reclaim_inodes_ag+0x265/0x2d0
> > Nov 15 21:55:13 21m21 kernel:  ? kmem_cache_alloc+0x14d/0x1b0
> > Nov 15 21:55:13 21m21 kernel:  ? radix_tree_gang_lookup_tag+0xc4/0x130
> > Nov 15 21:55:13 21m21 kernel:  ? __list_lru_walk_one.isra.5+0x33/0x130
> > Nov 15 21:55:13 21m21 kernel:  xfs_reclaim_inodes_nr+0x31/0x40
> > Nov 15 21:55:13 21m21 kernel:  super_cache_scan+0x156/0x1a0
> > Nov 15 21:55:13 21m21 kernel:  shrink_slab.part.51+0x1d2/0x3a0
> > Nov 15 21:55:13 21m21 kernel:  shrink_node+0x113/0x2e0
> > Nov 15 21:55:13 21m21 kernel:  do_try_to_free_pages+0xb3/0x310
> > Nov 15 21:55:13 21m21 kernel:  try_to_free_pages+0xd2/0x190
> > Nov 15 21:55:13 21m21 kernel:  __alloc_pages_slowpath+0x3a3/0xdc0
> > Nov 15 21:55:13 21m21 kernel:  ? ip_output+0x5c/0xc0
> > Nov 15 21:55:13 21m21 kernel:  ? update_curr+0x141/0x1a0
> > Nov 15 21:55:13 21m21 kernel:  __alloc_pages_nodemask+0x223/0x240
> > Nov 15 21:55:13 21m21 kernel:  skb_page_frag_refill+0x93/0xb0
> > Nov 15 21:55:13 21m21 kernel:  sk_page_frag_refill+0x19/0x80
> > Nov 15 21:55:13 21m21 kernel:  tcp_sendmsg_locked+0x247/0xdc0
> > Nov 15 21:55:13 21m21 kernel:  tcp_sendmsg+0x27/0x40
> > Nov 15 21:55:13 21m21 kernel:  sock_sendmsg+0x36/0x40
> > Nov 15 21:55:13 21m21 kernel:  sock_write_iter+0x84/0xd0
> > Nov 15 21:55:13 21m21 kernel:  __vfs_write+0xdd/0x140
> > Nov 15 21:55:13 21m21 kernel:  vfs_write+0xad/0x1a0
> > Nov 15 21:55:13 21m21 kernel:  SyS_write+0x42/0x90
> > Nov 15 21:55:13 21m21 kernel:  do_syscall_64+0x60/0x110
> > Nov 15 21:55:13 21m21 kernel:  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> >
> > Here "some-task" is trying to send some bytes over network and it's
> > stuck in direct reclaim. Naturally, kswapd is not keeping up with its
> > duties.
>
> That's not kswapd causing the problem here, that's direct reclaim.

I think direct reclaim happens concurrently with kswapd, see my
workload example.

> > It seems to me that our terrible disks sometimes take a pause to think
> > about the meaning of life for a few seconds.
>
> You've probably got lots of dirty inodes backed up waiting for IO.

I don't have lots of dirty inodes waiting on IO.

> How big are xfs inode slab caches (slabinfo output, please)? How big are the logs
> on the filesystems on the machine (xfs_info output, please)?

See my workload example.

> > During that time XFS
> > shrinker is stuck, which drives the whole system out of free memory
> > and in turns triggers direct reclaim.
>
> It happens the other way around. What you have here is direct
> reclaim trying to get the reclaim lock for a given AG to be able to
> reclaim inodes from it. direct reclaim only gets stuck here when all
> AGs are already being reclaimed from (i.e. already under direct
> reclaim).
>
> > One solution to this is to not go into direct reclaim by keeping more
> > free pages with vm.watermark_scale_factor,  but I'd like to discard
> > this and argue that we're going to hit direct reclaim at some point
> > anyway.
>
> Right, but the problem is that the mm/ subsystem allows effectively
> unbound direct reclaim concurrency. At some point, having tens to
> hundreds of direct reclaimers all trying to write dirty inodes to
> disk causes catastrophic IO breakdown and everything grinds to a
> halt forever. We have to prevent that breakdown from occurring.
>
> i.e. we have to throttle direct reclaim to before it reaches IO
> breakdown /somewhere/. The memory reclaim subsystem does not do it,
> so we have to do it in XFS itself. The problem here is that if we
> ignore direct reclaim (i.e do nothing rather than block waiting on
> reclaim progress) then the mm/ reclaim algorithms will eventually
> think they aren't making progress and unleash the OOM killer.
>
> > The solution I have in mind for this is not to try to write anything
> > to (disastrously terrible) storage in shrinkers. We have 95GB of page
> > cache readily available for reclaim and it seems a lot cheaper to grab
> > that.
>
> The mm/ subsystem tries to keep a balance between page cache and
> shrinker controlled caches. /proc/sys/vm/vfs_cache_pressure
> controls the balance between page cache and inode/dentry cache
> reclaim pressure..
>
> > That brings me to the first question around memory subsystem: are
> > shrinkers supposed to flush any dirty data?
>
> No shrinker does that, but if they wanted to they would be perfectly
> within their right to write back data.
>
> XFS is writing back /metadata/ here because direct reclaim is
> putting excessive pressure on the inode cache and not allowing the
> background cleaners to do their job.

Metadata is still data, XFS still writes it to the same block device.

> > My gut feeling is that
> > they should not do that, because there's already writeback mechanism
> > with own tunables for limits to take care of that. If a system runs
> > out of memory reclaimable without IO and dirty pages are under limit,
> > it's totally fair to OOM somebody.
> >
> > It's totally possible that I'm wrong about this feeling, but either
> > way I think docs need an update on this matter:
> >
> > * https://elixir.bootlin.com/linux/v4.14.55/source/Documentation/filesystems/vfs.txt
> >
> >   nr_cached_objects: called by the sb cache shrinking function for the
> >   filesystem to return the number of freeable cached objects it contains.
>
> You are assuming that "freeable" means "instantly freeable object",
> not "unreferenced object that can be freed in the near future". We
> use the latter definition in the shrinkers, not the former.

I'm only assuming things because documentation leaves room for
interpretation. I would love to this worded in a way that's crystal
clear and mentions possibility of IO.

> > My second question is conditional on the first one: if filesystems are
> > supposed to flush dirty data in response to shrinkers, then how can I
> > stop this, given my knowledge about combination of lots of available
> > page cache and terrible disks?
>
> Filesystems have more caches that just the page cache.
>
> > I've tried two things to address this problem ad-hoc.
> >
> > 1. Run the following systemtap script to trick shrinkers into thinking
> > that XFS has nothing to free:
> >
> > probe kernel.function("xfs_fs_nr_cached_objects").return {
> >   $return = 0
> > }
> >
> > That did the job and shrink_node latency dropped considerably, while
> > calls to xfs_fs_free_cached_objects disappeared.
>
> Which effectively turned off direct reclaim for XFS inodes. See
> above - this just means that when you have no easily reclaimable
> page cache the system will OOM kill rather than wait for inodes to
> be reclaimed. i.e. it looks good until everything suddenly goes
> wrong and then everything dies a horrible death.

We have hundreds of gigabytes of page cache, dirty pages are not
allowed to go near that mark. There's a separate limit for dirty data.

What I want to have is a way to tell the kernel to not try to flush
data to disk in response to reclaim, because that's choosing a very
real horrible life over imaginary horrible death. I can't possibly
create enough dirty inodes to cause the horrible death you describe.
This may be the case for low memory machines, but not for high memory
(which are arguably a commodity these days).

Can we have a sysctl toggle for no IO during reclaim?

> > 2. Use vm.vfs_cache_pressure to do the same thing. This failed
> > miserably, because of the following code in super_cache_count:
> >
> >   if (sb->s_op && sb->s_op->nr_cached_objects)
> >     total_objects = sb->s_op->nr_cached_objects(sb, sc);
> >
> >   total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
> >   total_objects += list_lru_shrink_count(&sb->s_inode_lru, sc);
> >
> >   total_objects = vfs_pressure_ratio(total_objects);
> >   return total_objects;
> >
> > XFS was doing its job cleaning up inodes with the background mechanims
> > it has (m_reclaim_workqueue), but kernel also stopped cleaning up
> > readily available inodes after XFS.
>
> You mean the kernel stopped handing readily available inodes to XFS
> to free.
>
> ie. The VFS has to release unreferenced inodes before they are
> handed to XFS to clean up and free. IOWs, I suspect you biased
> vm.vfs_cache_pressure to turn off inode reclaim to effectively do
> the same thing as above. However, by stopping the feed of
> unreferenced inodes to XFS you stopped inode reclaim altogether and
> that caused other problems.
>
> What I suspect you want to do is bias vfs_cache_pressure the other
> way, so that it /agressively/ feeds inode reclaim and so prevent
> large numbers of inodes from building up in the cache. That way
> reclaim won't have as many dirty inodes to block on when a sustained
> memory shortage drives large amounts of direct reclaim into the
> shrinkers...

No, I absolutely do not want to do that, because it still means writes
to disk in response to reclaim. That's the opposite of what I want.

> > I'm not a kernel hacker and to be honest with you I don't even
> > understand all the nuances here. All I know is:
> >
> > 1. I have lots of page cache and terrible disks.
> > 2. I want to reclaim page cache and never touch disks in response to
> > memory reclaim.
> > 3. Direct reclaim will happen at some point, somebody will want a big
> > chunk of memory all at once.
> > 4. I'm probably ok with reclaiming clean xfs inodes synchronously in
> > reclaim path.
> >
> > This brings me to my final question: what should I do to avoid latency
> > in reclaim (direct or kswapd)?
> >
> > To reiterate the importance of this issue: we see interactive
> > applications with zero IO stall for multiple seconds in writes to
> > non-blocking sockets and page faults on newly allocated memory, while
> > 95GB of memory is in page cache.
>
> It really just sounds like you are allowing too many dirty inodes to
> build up in memory. You have a huge amount of memory but really slow
> disks - that's just asking for idata and metadata writeback latency
> problems.

I don't care as much about idata and metadata writeback latency.
Writes are asynchronous as long as dirty page limit is not breached
and I don't breach it. What I care about is system freezes when
there's tons of memory to reclaim from page cache, because reclaim
writes to storage synchronously.

> It sounds like, you need to cause inode cleaning to happen
> earlier/faster than it is happening now, because your disks are slow
> and so you can't allow a big backlog to build up.  Reducing
> /proc/sys/fs/xfs/xfssyncd_centisecs can get background metadata
> writeback started earlier. As per Documentation/filesystems/xfs.txt:
>
>   fs.xfs.xfssyncd_centisecs     (Min: 100  Default: 3000  Max: 720000)
>         The interval at which the filesystem flushes metadata
>         out to disk and runs internal cache cleanup routines.
>
> If this doesn't help, then I'd suggest taht your config is simply
> allowing too many dirty inodes to build up in memory.  With XFS, the
> number of dirty inodes that can be held in memory at any point in
> time is bound by the size of the XFS log in the filesystem. Hence if
> you have hundreds of MB of journal space, then you can cache
> hundreds of thousands of dirty inodes in memory and so can take tens
> of minutes to write them back to slow disks. So if earlier writeback
> doesn't help, I'd suggest that using smaller logs with your
> filesystems is the only real option here....

You are right that our config allows too many dirty inodes to build up
in memory. Unfortunately, too many means any number larger than zero
and lowering fs.xfs.xfssyncd_centisecs to 600 made no difference in
real production workload.

> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
