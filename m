Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Nov 2007 04:39:15 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA4Cd9Vg021712
	for <xfs@oss.sgi.com>; Sun, 4 Nov 2007 04:39:10 -0800
Date: Sun, 4 Nov 2007 07:39:13 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state (md3_raid5 stuck in endless
 loop?)
In-Reply-To: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0711040730310.30831@p34.internal.lan>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: xfs@oss.sgi.com

Time to reboot, before reboot:

top - 07:30:23 up 13 days, 13:33, 10 users,  load average: 16.00, 15.99, 14.96
Tasks: 221 total,   7 running, 209 sleeping,   0 stopped,   5 zombie
Cpu(s):  0.0%us, 25.5%sy,  0.0%ni, 74.5%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   8039432k total,  1744356k used,  6295076k free,      164k buffers
Swap: 16787768k total,      160k used, 16787608k free,   616960k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
   688 root      15  -5     0    0    0 R  100  0.0 121:21.43 md3_raid5
   273 root      20   0     0    0    0 D    0  0.0  14:40.68 pdflush
   274 root      20   0     0    0    0 D    0  0.0  13:00.93 pdflush

# cat /proc/fs/xfs/stat
extent_alloc 301974 256068291 310513 240764389
abt 1900173 15346352 738568 731314
blk_map 276979807 235589732 864002 211245834 591619 513439614 0
bmbt 50717 367726 14177 11846
dir 3818065 361561 359723 975628
trans 48452 2648064 570998
ig 6034530 2074424 43153 3960106 0 3869384 460831
log 282781 10454333 3028 399803 173488
push_ail 3267594 0 1620 2611 730365 0 4476 0 10269 0
xstrat 291940 0
rw 61423078 103732605
attr 0 0 0 0
icluster 312958 97323 419837
vnodes 90721 4019823 0 1926744 3929102 3929102 3929102 0
buf 14678900 11027087 3651843 25743 760449 0 0 15775888 280425
xpc 966925905920 1047628533165 1162276949815
debug 0

# cat meminfo
MemTotal:      8039432 kB
MemFree:       6287000 kB
Buffers:           164 kB
Cached:         617072 kB
SwapCached:          0 kB
Active:         178404 kB
Inactive:       589880 kB
SwapTotal:    16787768 kB
SwapFree:     16787608 kB
Dirty:          494280 kB
Writeback:       86004 kB
AnonPages:      151240 kB
Mapped:          17092 kB
Slab:           259696 kB
SReclaimable:   170876 kB
SUnreclaim:      88820 kB
PageTables:      11448 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:  20807484 kB
Committed_AS:   353536 kB
VmallocTotal: 34359738367 kB
VmallocUsed:     15468 kB
VmallocChunk: 34359722699 kB

# echo 3 > /proc/sys/vm/drop_caches

# cat /proc/meminfo
MemTotal:      8039432 kB
MemFree:       6418352 kB
Buffers:            32 kB
Cached:         597908 kB
SwapCached:          0 kB
Active:         172028 kB
Inactive:       579808 kB
SwapTotal:    16787768 kB
SwapFree:     16787608 kB
Dirty:          494312 kB
Writeback:       86004 kB
AnonPages:      154104 kB
Mapped:          17416 kB
Slab:           144072 kB
SReclaimable:    53100 kB
SUnreclaim:      90972 kB
PageTables:      11832 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:  20807484 kB
Committed_AS:   360748 kB
VmallocTotal: 34359738367 kB
VmallocUsed:     15468 kB
VmallocChunk: 34359722699 kB

Nothing is actually happening on the device itself however.

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
sdc               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
sdd               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
sde               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
sdf               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
sdg               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
sdh               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
sdi               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
sdj               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
sdk               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
sdl               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
md0               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
md3               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
md2               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00
md1               0.00     0.00    0.00    0.00     0.00     0.00     0.00 
0.00    0.00   0.00   0.00

# vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- 
----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  6  0    160 6420244     32 600092    0    0   221   227    5    1  1  1 98  0
  6  0    160 6420228     32 600120    0    0     0     0 1015  142  0 25 75  0
  6  0    160 6420228     32 600120    0    0     0     0 1005  127  0 25 75  0
  6  0    160 6420228     32 600120    0    0     0    41 1022  151  0 26 74  0
  6  0    160 6420228     32 600120    0    0     0     0 1011  131  0 25 75  0
  6  0    160 6420228     32 600120    0    0     0     0 1013  124  0 25 75  0
  6  0    160 6420228     32 600120    0    0     0     0 1042  129  0 25 75  0

# uname -mr
2.6.23.1 x86_64

# cat /proc/vmstat
nr_free_pages 1598911
nr_inactive 146381
nr_active 42724
nr_anon_pages 37181
nr_mapped 4097
nr_file_pages 151975
nr_dirty 123572
nr_writeback 21501
nr_slab_reclaimable 16152
nr_slab_unreclaimable 24284
nr_page_table_pages 2823
nr_unstable 0
nr_bounce 0
nr_vmscan_write 20712
pgpgin 1015377151
pgpgout 1043634578
pswpin 0
pswpout 40
pgalloc_dma 4
pgalloc_dma32 319052932
pgalloc_normal 621945603
pgalloc_movable 0
pgfree 942598566
pgactivate 31123819
pgdeactivate 18438560
pgfault 360236898
pgmajfault 16158
pgrefill_dma 0
pgrefill_dma32 11683348
pgrefill_normal 18799274
pgrefill_movable 0
pgsteal_dma 0
pgsteal_dma32 176658679
pgsteal_normal 233628315
pgsteal_movable 0
pgscan_kswapd_dma 0
pgscan_kswapd_dma32 164181746
pgscan_kswapd_normal 217338820
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_dma32 13074075
pgscan_direct_normal 17342937
pgscan_direct_movable 0
pginodesteal 332816
slabs_scanned 12368000
kswapd_steal 380216091
kswapd_inodesteal 9858653
pageoutrun 1167045
allocstall 68454
pgrotated 40

# cat /proc/zoneinfo
Node 0, zone      DMA
   pages free     2601
         min      3
         low      3
         high     4
         scanned  0 (a: 11 i: 12)
         spanned  4096
         present  2486
     nr_free_pages 2601
     nr_inactive  0
     nr_active    0
     nr_anon_pages 0
     nr_mapped    1
     nr_file_pages 0
     nr_dirty     0
     nr_writeback 0
     nr_slab_reclaimable 0
     nr_slab_unreclaimable 4
     nr_page_table_pages 0
     nr_unstable  0
     nr_bounce    0
     nr_vmscan_write 0
         protection: (0, 3246, 7917, 7917)
   pagesets
     cpu: 0 pcp: 0
               count: 0
               high:  0
               batch: 1
     cpu: 0 pcp: 1
               count: 0
               high:  0
               batch: 1
   vm stats threshold: 6
     cpu: 1 pcp: 0
               count: 0
               high:  0
               batch: 1
     cpu: 1 pcp: 1
               count: 0
               high:  0
               batch: 1
   vm stats threshold: 6
     cpu: 2 pcp: 0
               count: 0
               high:  0
               batch: 1
     cpu: 2 pcp: 1
               count: 0
               high:  0
               batch: 1
   vm stats threshold: 6
     cpu: 3 pcp: 0
               count: 0
               high:  0
               batch: 1
     cpu: 3 pcp: 1
               count: 0
               high:  0
               batch: 1
   vm stats threshold: 6
   all_unreclaimable: 1
   prev_priority:     12
   start_pfn:         0
Node 0, zone    DMA32
   pages free     699197
         min      1166
         low      1457
         high     1749
         scanned  0 (a: 14 i: 0)
         spanned  1044480
         present  831104
     nr_free_pages 699197
     nr_inactive  38507
     nr_active    11855
     nr_anon_pages 11228
     nr_mapped    612
     nr_file_pages 39127
     nr_dirty     38462
     nr_writeback 34
     nr_slab_reclaimable 8164
     nr_slab_unreclaimable 4747
     nr_page_table_pages 756
     nr_unstable  0
     nr_bounce    0
     nr_vmscan_write 6132
         protection: (0, 0, 4671, 4671)
   pagesets
     cpu: 0 pcp: 0
               count: 183
               high:  186
               batch: 31
     cpu: 0 pcp: 1
               count: 52
               high:  62
               batch: 15
   vm stats threshold: 36
     cpu: 1 pcp: 0
               count: 23
               high:  186
               batch: 31
     cpu: 1 pcp: 1
               count: 14
               high:  62
               batch: 15
   vm stats threshold: 36
     cpu: 2 pcp: 0
               count: 173
               high:  186
               batch: 31
     cpu: 2 pcp: 1
               count: 61
               high:  62
               batch: 15
   vm stats threshold: 36
     cpu: 3 pcp: 0
               count: 95
               high:  186
               batch: 31
     cpu: 3 pcp: 1
               count: 57
               high:  62
               batch: 15
   vm stats threshold: 36
   all_unreclaimable: 0
   prev_priority:     12
   start_pfn:         4096
Node 0, zone   Normal
   pages free     897091
         min      1678
         low      2097
         high     2517
         scanned  0 (a: 29 i: 0)
         spanned  1212416
         present  1195840
     nr_free_pages 897091
     nr_inactive  107874
     nr_active    30878
     nr_anon_pages 25956
     nr_mapped    3484
     nr_file_pages 112857
     nr_dirty     85110
     nr_writeback 21467
     nr_slab_reclaimable 7988
     nr_slab_unreclaimable 19546
     nr_page_table_pages 2067
     nr_unstable  0
     nr_bounce    0
     nr_vmscan_write 14580
         protection: (0, 0, 0, 0)
   pagesets
     cpu: 0 pcp: 0
               count: 124
               high:  186
               batch: 31
     cpu: 0 pcp: 1
               count: 1
               high:  62
               batch: 15
   vm stats threshold: 42
     cpu: 1 pcp: 0
               count: 68
               high:  186
               batch: 31
     cpu: 1 pcp: 1
               count: 9
               high:  62
               batch: 15
   vm stats threshold: 42
     cpu: 2 pcp: 0
               count: 79
               high:  186
               batch: 31
     cpu: 2 pcp: 1
               count: 10
               high:  62
               batch: 15
   vm stats threshold: 42
     cpu: 3 pcp: 0
               count: 47
               high:  186
               batch: 31
     cpu: 3 pcp: 1
               count: 60
               high:  62
               batch: 15
   vm stats threshold: 42
   all_unreclaimable: 0
   prev_priority:     12
   start_pfn:         1048576

On Sun, 4 Nov 2007, Justin Piszcz wrote:

> # ps auxww | grep D
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [pdflush]
> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [pdflush]
>
> After several days/weeks, this is the second time this has happened, while 
> doing regular file I/O (decompressing a file), everything on the device went 
> into D-state.
>
> # mdadm -D /dev/md3
> /dev/md3:
>        Version : 00.90.03
>  Creation Time : Wed Aug 22 10:38:53 2007
>     Raid Level : raid5
>     Array Size : 1318680576 (1257.59 GiB 1350.33 GB)
>  Used Dev Size : 146520064 (139.73 GiB 150.04 GB)
>   Raid Devices : 10
>  Total Devices : 10
> Preferred Minor : 3
>    Persistence : Superblock is persistent
>
>    Update Time : Sun Nov  4 06:38:29 2007
>          State : active
> Active Devices : 10
> Working Devices : 10
> Failed Devices : 0
>  Spare Devices : 0
>
>         Layout : left-symmetric
>     Chunk Size : 1024K
>
>           UUID : e37a12d1:1b0b989a:083fb634:68e9eb49
>         Events : 0.4309
>
>    Number   Major   Minor   RaidDevice State
>       0       8       33        0      active sync   /dev/sdc1
>       1       8       49        1      active sync   /dev/sdd1
>       2       8       65        2      active sync   /dev/sde1
>       3       8       81        3      active sync   /dev/sdf1
>       4       8       97        4      active sync   /dev/sdg1
>       5       8      113        5      active sync   /dev/sdh1
>       6       8      129        6      active sync   /dev/sdi1
>       7       8      145        7      active sync   /dev/sdj1
>       8       8      161        8      active sync   /dev/sdk1
>       9       8      177        9      active sync   /dev/sdl1
>
> If I wanted to find out what is causing this, what type of debugging would I 
> have to enable to track it down?  Any attempt to read/write files on the 
> devices fails (also going into d-state).  Is there any useful information I 
> can get currently before rebooting the machine?
>
> # pwd
> /sys/block/md3/md
> # ls
> array_state      dev-sdj1/         rd2@              stripe_cache_active
> bitmap_set_bits  dev-sdk1/         rd3@              stripe_cache_size
> chunk_size       dev-sdl1/         rd4@              suspend_hi
> component_size   layout            rd5@              suspend_lo
> dev-sdc1/        level             rd6@              sync_action
> dev-sdd1/        metadata_version  rd7@              sync_completed
> dev-sde1/        mismatch_cnt      rd8@              sync_speed
> dev-sdf1/        new_dev           rd9@              sync_speed_max
> dev-sdg1/        raid_disks        reshape_position  sync_speed_min
> dev-sdh1/        rd0@              resync_start
> dev-sdi1/        rd1@              safe_mode_delay
> # cat array_state
> active-idle
> # cat mismatch_cnt
> 0
> # cat stripe_cache_active
> 1
> # cat stripe_cache_size
> 16384
> # cat sync_action
> idle
> # cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md1 : active raid1 sdb2[1] sda2[0]
>      136448 blocks [2/2] [UU]
>
> md2 : active raid1 sdb3[1] sda3[0]
>      129596288 blocks [2/2] [UU]
>
> md3 : active raid5 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[3] 
> sde1[2] sdd1[1] sdc1[0]
>      1318680576 blocks level 5, 1024k chunk, algorithm 2 [10/10] 
> [UUUUUUUUUU]
>
> md0 : active raid1 sdb1[1] sda1[0]
>      16787776 blocks [2/2] [UU]
>
> unused devices: <none>
> #
>
> Justin.
>
