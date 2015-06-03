Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2828D7F9B
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 02:07:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C15A2AC00A
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 00:07:31 -0700 (PDT)
Received: from emea01-db3-obe.outbound.protection.outlook.com
	(mail-db3on0117.outbound.protection.outlook.com
	[157.55.234.117]) by cuda.sgi.com with ESMTP id
	ArLKLZkd87EAglr3 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 00:07:28 -0700 (PDT)
Date: Wed, 3 Jun 2015 09:07:25 +0200
From: Anders Ossowicki <aowi@novozymes.com>
Subject: Re: "XFS: possible memory allocation deadlock in kmem_alloc" on high
	memory machine
Message-ID: <20150603070725.GA20743@otto>
References: <20150601145741.GA16608@otto> <20150601210113.GL24666@dastard>
	<20150602120648.GA22111@otto> <20150603015245.GN24666@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150603015245.GN24666@dastard>
Reply-To: aowi@novozymes.com
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jun 03, 2015 at 03:52:45AM +0200, Dave Chinner wrote:
> On Tue, Jun 02, 2015 at 02:06:48PM +0200, Anders Ossowicki wrote:
>
> > Slab:           79729144 kB
> > SReclaimable:   79040008 kB
>
> 80GB of slab caches as well - what is the output of /proc/slabinfo?

slabinfo - version: 2.1
# name         <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
btrfs_prelim_ref           0      0     80   51    1 : tunables    0    0    0 : slabdata      0      0      0
btrfs_delayed_data_ref     0      0     96   42    1 : tunables    0    0    0 : slabdata      0      0      0
btrfs_delayed_ref_head     0      0    160   51    2 : tunables    0    0    0 : slabdata      0      0      0
btrfs_delayed_node         0      0    304   53    4 : tunables    0    0    0 : slabdata      0      0      0
btrfs_ordered_extent       0      0    424   38    4 : tunables    0    0    0 : slabdata      0      0      0
btrfs_extent_buffer        0      0    280   58    4 : tunables    0    0    0 : slabdata      0      0      0
btrfs_extent_state         0      0     88   46    1 : tunables    0    0    0 : slabdata      0      0      0
btrfs_delalloc_work        0      0    152   53    2 : tunables    0    0    0 : slabdata      0      0      0
btrfs_trans_handle         0      0    176   46    2 : tunables    0    0    0 : slabdata      0      0      0
btrfs_inode                0      0   1000   32    8 : tunables    0    0    0 : slabdata      0      0      0
ufs_inode_cache            0      0    744   44    8 : tunables    0    0    0 : slabdata      0      0      0
qnx4_inode_cache           0      0    656   49    8 : tunables    0    0    0 : slabdata      0      0      0
hfsplus_attr_cache         0      0   3840    8    8 : tunables    0    0    0 : slabdata      0      0      0
hfsplus_icache             0      0    896   36    8 : tunables    0    0    0 : slabdata      0      0      0
hfs_inode_cache            0      0    768   42    8 : tunables    0    0    0 : slabdata      0      0      0
minix_inode_cache          0      0    648   50    8 : tunables    0    0    0 : slabdata      0      0      0
ntfs_big_inode_cache       0      0    896   36    8 : tunables    0    0    0 : slabdata      0      0      0
ntfs_inode_cache           0      0    312   52    4 : tunables    0    0    0 : slabdata      0      0      0
jfs_mp                    32     32    128   32    1 : tunables    0    0    0 : slabdata      1      1      0
jfs_ip                     0      0   1240   26    8 : tunables    0    0    0 : slabdata      0      0      0
reiser_inode_cache         0      0    744   44    8 : tunables    0    0    0 : slabdata      0      0      0
ext2_inode_cache           0      0    792   41    8 : tunables    0    0    0 : slabdata      0      0      0
nfsd4_openowners       13394  13838    440   37    4 : tunables    0    0    0 : slabdata    374    374      0
nfs_direct_cache           0      0    208   39    2 : tunables    0    0    0 : slabdata      0      0      0
nfs_commit_data         2167   2167    704   46    8 : tunables    0    0    0 : slabdata     48     48      0
nfs_inode_cache       174843 175088   1040   31    8 : tunables    0    0    0 : slabdata   5648   5648      0
fscache_cookie_jar      1702   1702     88   46    1 : tunables    0    0    0 : slabdata     37     37      0
rpc_inode_cache         2448   2448    640   51    8 : tunables    0    0    0 : slabdata     48     48      0
xfs_dquot                  0      0    472   34    4 : tunables    0    0    0 : slabdata      0      0      0
xfs_icr                    0      0    144   56    2 : tunables    0    0    0 : slabdata      0      0      0
xfs_ili              1066228 1066625   152   53    2 : tunables    0    0    0 : slabdata  20125  20125      0
xfs_inode            2522728 2523172  1024   32    8 : tunables    0    0    0 : slabdata  78857  78857      0
xfs_efd_item            8320   8920    400   40    4 : tunables    0    0    0 : slabdata    223    223      0
xfs_da_state            1632   1632    480   34    4 : tunables    0    0    0 : slabdata     48     48      0
xfs_btree_cur           1872   1872    208   39    2 : tunables    0    0    0 : slabdata     48     48      0
ext4_groupinfo_4k        896    896    144   56    2 : tunables    0    0    0 : slabdata     16     16      0
ip6-frags                  0      0    216   37    2 : tunables    0    0    0 : slabdata      0      0      0
UDPLITEv6                  0      0   1088   30    8 : tunables    0    0    0 : slabdata      0      0      0
UDPv6                   1440   1440   1088   30    8 : tunables    0    0    0 : slabdata     48     48      0
tw_sock_TCPv6           1312   1312    256   32    2 : tunables    0    0    0 : slabdata     41     41      0
TCPv6                    768    768   1984   16    8 : tunables    0    0    0 : slabdata     48     48      0
kcopyd_job                 0      0   3312    9    8 : tunables    0    0    0 : slabdata      0      0      0
dm_uevent                  0      0   2632   12    8 : tunables    0    0    0 : slabdata      0      0      0
dm_rq_target_io            0      0    408   40    4 : tunables    0    0    0 : slabdata      0      0      0
scsi_cmd_cache         93743 107688    384   42    4 : tunables    0    0    0 : slabdata   2564   2564      0
cfq_queue              21842  21910    232   35    2 : tunables    0    0    0 : slabdata    626    626      0
bsg_cmd                    0      0    312   52    4 : tunables    0    0    0 : slabdata      0      0      0
mqueue_inode_cache        36     36    896   36    8 : tunables    0    0    0 : slabdata      1      1      0
fuse_request               0      0    416   39    4 : tunables    0    0    0 : slabdata      0      0      0
fuse_inode                 0      0    768   42    8 : tunables    0    0    0 : slabdata      0      0      0
ecryptfs_key_record_cache  0      0    576   56    8 : tunables    0    0    0 : slabdata      0      0      0
ecryptfs_inode_cache       0      0   1024   32    8 : tunables    0    0    0 : slabdata      0      0      0
fat_inode_cache            0      0    720   45    8 : tunables    0    0    0 : slabdata      0      0      0
fat_cache                  0      0     40  102    1 : tunables    0    0    0 : slabdata      0      0      0
hugetlbfs_inode_cache   2592   2592    600   54    8 : tunables    0    0    0 : slabdata     48     48      0
jbd2_journal_handle     4080   4080     48   85    1 : tunables    0    0    0 : slabdata     48     48      0
journal_handle             0      0     24  170    1 : tunables    0    0    0 : slabdata      0      0      0
journal_head           17208  17712    112   36    1 : tunables    0    0    0 : slabdata    492    492      0
revoke_table             256    256     16  256    1 : tunables    0    0    0 : slabdata      1      1      0
revoke_record           6400   6400     32  128    1 : tunables    0    0    0 : slabdata     50     50      0
ext4_inode_cache      642098 775776   1008   32    8 : tunables    0    0    0 : slabdata  24243  24243      0
ext4_free_data         11328  11328     64   64    1 : tunables    0    0    0 : slabdata    177    177      0
ext4_allocation_context 1536   1536    128   32    1 : tunables    0    0    0 : slabdata     48     48      0
ext4_io_end             3024   3024     72   56    1 : tunables    0    0    0 : slabdata     54     54      0
ext4_extent_status     68877 105672     40  102    1 : tunables    0    0    0 : slabdata   1036   1036      0
ext3_inode_cache           0      0    816   40    8 : tunables    0    0    0 : slabdata      0      0      0
dquot                   1760   1760    256   32    2 : tunables    0    0    0 : slabdata     55     55      0
fsnotify_mark              0      0    112   36    1 : tunables    0    0    0 : slabdata      0      0      0
pid_namespace              0      0   2200   14    8 : tunables    0    0    0 : slabdata      0      0      0
posix_timers_cache     12541  12705    248   33    2 : tunables    0    0    0 : slabdata    385    385      0
UDP-Lite                   0      0    960   34    8 : tunables    0    0    0 : slabdata      0      0      0
xfrm_dst_cache             0      0    448   36    4 : tunables    0    0    0 : slabdata      0      0      0
ip_fib_trie              292    292     56   73    1 : tunables    0    0    0 : slabdata      4      4      0
UDP                     1632   1632    960   34    8 : tunables    0    0    0 : slabdata     48     48      0
tw_sock_TCP             2358   2624    256   32    2 : tunables    0    0    0 : slabdata     82     82      0
TCP                     3539   3808   1856   17    8 : tunables    0    0    0 : slabdata    224    224      0
blkdev_queue             323    464   1928   16    8 : tunables    0    0    0 : slabdata     29     29      0
blkdev_requests        13992  14740    368   44    4 : tunables    0    0    0 : slabdata    335    335      0
blkdev_ioc             23201  24141    104   39    1 : tunables    0    0    0 : slabdata    619    619      0
dmaengine-unmap-256       15     15   2112   15    8 : tunables    0    0    0 : slabdata      1      1      0
dmaengine-unmap-128      180    180   1088   30    8 : tunables    0    0    0 : slabdata      6      6      0
sock_inode_cache        6273   6273    640   51    8 : tunables    0    0    0 : slabdata    123    123      0
net_namespace              0      0   4352    7    8 : tunables    0    0    0 : slabdata      0      0      0
shmem_inode_cache       2784   2784    672   48    8 : tunables    0    0    0 : slabdata     58     58      0
ftrace_event_file       1702   1702     88   46    1 : tunables    0    0    0 : slabdata     37     37      0
taskstats               2352   2352    328   49    4 : tunables    0    0    0 : slabdata     48     48      0
proc_inode_cache       19293  24750    648   50    8 : tunables    0    0    0 : slabdata    495    495      0
sigqueue                3111   3111    160   51    2 : tunables    0    0    0 : slabdata     61     61      0
bdev_cache              1014   1014    832   39    8 : tunables    0    0    0 : slabdata     26     26      0
kernfs_node_cache     342112 342244    120   34    1 : tunables    0    0    0 : slabdata  10066  10066      0
mnt_cache               2448   2448    320   51    4 : tunables    0    0    0 : slabdata     48     48      0
inode_cache            36637  45080    584   56    8 : tunables    0    0    0 : slabdata    805    805      0
dentry               3217866 3702384   192   42    2 : tunables    0    0    0 : slabdata  88152  88152      0
iint_cache                 0      0     72   56    1 : tunables    0    0    0 : slabdata      0      0      0
buffer_head        370050715 400741536 104   39    1 : tunables    0    0    0 : slabdata 10275424 10275424  0
vm_area_struct        147654 150128    184   44    2 : tunables    0    0    0 : slabdata   3412   3412      0
mm_struct               9550  10404    896   36    8 : tunables    0    0    0 : slabdata    289    289      0
files_cache             4029   4029    640   51    8 : tunables    0    0    0 : slabdata     79     79      0
signal_cache            4383   5180   1152   28    8 : tunables    0    0    0 : slabdata    185    185      0
sighand_cache           3081   3255   2112   15    8 : tunables    0    0    0 : slabdata    217    217      0
task_xstate            10016  10881    832   39    8 : tunables    0    0    0 : slabdata    279    279      0
task_struct             1913   2070   6432    5    8 : tunables    0    0    0 : slabdata    414    414      0
Acpi-ParseExt           6048   6048     72   56    1 : tunables    0    0    0 : slabdata    108    108      0
Acpi-State               306    306     80   51    1 : tunables    0    0    0 : slabdata      6      6      0
Acpi-Namespace          2040   2040     40  102    1 : tunables    0    0    0 : slabdata     20     20      0
anon_vma               69129  72318     80   51    1 : tunables    0    0    0 : slabdata   1418   1418      0
shared_policy_node     27030  27285     48   85    1 : tunables    0    0    0 : slabdata    321    321      0
numa_policy             8160   8160     24  170    1 : tunables    0    0    0 : slabdata     48     48      0
radix_tree_node     64025078 64148728  584   56    8 : tunables    0    0    0 : slabdata 1145751 1145751    0
idr_layer_cache         3456   3709   2096   15    8 : tunables    0    0    0 : slabdata    251    251      0
dma-kmalloc-8192           0      0   8192    4    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-4096           0      0   4096    8    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-2048           0      0   2048   16    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-1024           0      0   1024   32    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-512           32     32    512   32    4 : tunables    0    0    0 : slabdata      1      1      0
dma-kmalloc-256            0      0    256   32    2 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-128            0      0    128   32    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-64             0      0     64   64    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-32             0      0     32  128    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-16             0      0     16  256    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-8              0      0      8  512    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-192            0      0    192   42    2 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-96             0      0     96   42    1 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-8192             779    832   8192    4    8 : tunables    0    0    0 : slabdata    208    208      0
kmalloc-4096            2918   3304   4096    8    8 : tunables    0    0    0 : slabdata    413    413      0
kmalloc-2048            3530   4224   2048   16    8 : tunables    0    0    0 : slabdata    264    264      0
kmalloc-1024           23980  27264   1024   32    8 : tunables    0    0    0 : slabdata    852    852      0
kmalloc-512           179639 222048    512   32    4 : tunables    0    0    0 : slabdata   6939   6939      0
kmalloc-256           488489 521296    256   32    2 : tunables    0    0    0 : slabdata  16291  16291      0
kmalloc-192            41454  53508    192   42    2 : tunables    0    0    0 : slabdata   1274   1274      0
kmalloc-128            54683  67168    128   32    1 : tunables    0    0    0 : slabdata   2099   2099      0
kmalloc-96             20274  37044     96   42    1 : tunables    0    0    0 : slabdata    882    882      0
kmalloc-64            329220 1136832    64   64    1 : tunables    0    0    0 : slabdata  17763  17763      0
kmalloc-32             76222  90112     32  128    1 : tunables    0    0    0 : slabdata    704    704      0
kmalloc-16            245496 247552     16  256    1 : tunables    0    0    0 : slabdata    967    967      0
kmalloc-8             570025 915456      8  512    1 : tunables    0    0    0 : slabdata   1788   1788      0
kmem_cache_node         1310   1472     64   64    1 : tunables    0    0    0 : slabdata     23     23      0
kmem_cache               512    512    256   32    2 : tunables    0    0    0 : slabdata     16     16      0

And just for good measure, this was meminfo at the same time:

MemTotal:       3170749444 kB
MemFree:        27109596 kB
MemAvailable:   2853545664 kB
Buffers:          442216 kB
Cached:         2882173504 kB
SwapCached:            0 kB
Active:         1636112224 kB
Inactive:       1303578276 kB
Active(anon):   188466588 kB
Inactive(anon):  6202588 kB
Active(file):   1447645636 kB
Inactive(file): 1297375688 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:      25353212 kB
SwapFree:       25353212 kB
Dirty:            924980 kB
Writeback:             0 kB
AnonPages:      57090800 kB
Mapped:         137637500 kB
Shmem:          137578904 kB
Slab:           82699516 kB
SReclaimable:   81921588 kB
SUnreclaim:       777928 kB
KernelStack:       27968 kB
PageTables:     101008148 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    1610727932 kB
Committed_AS:   205791344 kB
VmallocTotal:   34359738367 kB
VmallocUsed:     6629132 kB
VmallocChunk:   31937035472 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      172736 kB
DirectMap2M:    13412352 kB
DirectMap1G:    3207593984 kB


> > We have three hardware raid'ed disks with XFS on them, one of which receives
> > the bulk of the load. This is a raid 50 volume on SSDs with the raid controller
> > running in writethrough mode.
> 
> It doesn't seem like writeback of dirty pages is the problem; more
> the case that the page cache is rediculously huge and not being
> reclaimed in a sane manner. Do you really need 2.8TB of cached file
> data in memory for performance?

Yeah, disk cache is the primary reason for stuffing memory into that machine.

-- 
Anders Ossowicki

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
