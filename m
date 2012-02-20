Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1K67URi058130 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 00:07:30 -0600
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id LrvLATbtzLbQVYjK
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 19 Feb 2012 22:07:28 -0800 (PST)
Received: by yhjj72 with SMTP id j72so3594688yhj.26
	for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 22:07:28 -0800 (PST)
MIME-Version: 1.0
From: "Guk-Bong, Kwon" <gbkwon@gmail.com>
Date: Mon, 20 Feb 2012 15:06:48 +0900
Message-ID: <CAJ-WH_ydP-_k5zhcUh5QptkDkjvFQRNGUihgU1=yb8VX0Qp4Cg@mail.gmail.com>
Subject: [help] xfs quotacheck problem when xfs filesystem mount
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
To: xfs@oss.sgi.com

[help] xfs quotacheck problem when xfs filesystem mount

hi all..

i test xfs project quota with various version vanilla kernel


Test Scenario

1. mkfs.xfs -i size=512 -l lazy-count=1 /dev/ld/lv1
2. xfs filesystem mount with project quota. and setting project quota
3. make many file into xfs filesystem (eg. 1K~1M size, number 300 million over)
4. xfs filesystem umount
5. xfs filesystem mount without project quota
6. make some file
7. umount xfs filesystem
8. again mount with project quota


some kernel is ok when mount with project quota

some kernel is occurs oom-killer when mount with project quota

i tested kernel version 2.6.27.59, 2.6.32.46, 3.1.10.

only 2.6.27.59 kernel is not occurs oom-killer.


What is my mistake?


more information see below

===============================================================================
# free -m
             total       used       free     shared    buffers     cached
Mem:           999        232        767          0         56         90
-/+ buffers/cache:         86        913
Swap:        10221          0      10221


# cat /proc/cpuinfo
processor       : 3
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      : Intel(R) Xeon(TM) CPU 3.00GHz
stepping        : 3
cpu MHz         : 2992.514
cache size      : 2048 KB
physical id     : 3
siblings        : 2
core id         : 0
cpu cores       : 1
apicid          : 7
initial apicid  : 7
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc pebs bts nopl pni dtes64 monitor ds_cpl cid
cx16 xtpr
bogomips        : 5983.80
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:


# mkfs.xfs -i size=512 -l lazy-count=1 /dev/ld/lv1


# mount -o prjquota,noatime /dev/ld/lv1 /lv1/


# cat /proc/mounts
rootfs / rootfs rw 0 0
/proc /proc proc rw 0 0
/dev/root / ext3 rw,noatime,nodiratime,errors=continue,data=journal 0 0
/proc /proc proc rw 0 0
/sys /sys sysfs rw 0 0
/dev/shm /dev/shm tmpfs rw 0 0
none /dev/pts devpts rw,gid=5,mode=620 0 0
nfsd /proc/fs/nfsd nfsd rw 0 0
/dev/sda2 /var ext3 rw,noatime,nodiratime,errors=continue,data=journal 0 0
/dev/ld/lv1 /lv1 xfs rw,noatime,attr2,nobarrier,prjquota,grpquota 0 0


# mkdir /lv1/d1
# mkdir /lv1/d2
...
# mkdir /lv1/d29
# mkdir /lv1/d30


# cat /etc/projid
1:1
2:2
...
29:29
30:30


# cat /etc/projects
1:/lv1/d1
2:/lv1/d2
...
29:/lv1/d29
30:/lv1/d30


# xfs_quota -x -c 'limit -p bsoft=10g bhard=10g 1' /lv1
# xfs_quota -x -c 'limit -p bsoft=10g bhard=10g 2' /lv1
# ...
# xfs_quota -x -c 'limit -p bsoft=10g bhard=10g 29' /lv1
# xfs_quota -x -c 'limit -p bsoft=10g bhard=10g 30' /lv1


# make many file


# xfs_quota -x -c 'report -p -b -h' /lv1
Project quota on /lv1 (/dev/ld/lv1)
                        Blocks
Project ID   Used   Soft   Hard Warn/Grace
---------- ---------------------------------
1            1.4G    10G    10G  00 [------]
2            1.8G    10G    10G  00 [------]
3            1.9G    10G    10G  00 [------]
...


# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda1             5.0G  2.3G  2.4G  49% /
/dev/sda2             5.0G  396M  4.3G   9% /var
none                  502M   28K  502M   1% /dev/shm
/dev/mapper/ld-lv1     49G   16G   33G  33% /lv1


# df -i
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/sda1               640K     55K    586K    9% /
/dev/sda2               640K    1.4K    639K    1% /var
none                    126K      14    126K    1% /dev/shm
/dev/mapper/ld-lv1       25M    4.2M     20M   18% /lv1


# umount /dev/ld/lv1


# mount /dev/ld/lv1 /lv1


# cat /proc/mounts
rootfs / rootfs rw 0 0
/proc /proc proc rw 0 0
/dev/root / ext3 rw,noatime,nodiratime,errors=continue,data=journal 0 0
/proc /proc proc rw 0 0
/sys /sys sysfs rw 0 0
/dev/shm /dev/shm tmpfs rw 0 0
none /dev/pts devpts rw,gid=5,mode=620 0 0
nfsd /proc/fs/nfsd nfsd rw 0 0
/dev/sda2 /var ext3 rw,noatime,nodiratime,errors=continue,data=journal 0 0
/dev/ld/lv1 /lv1 xfs rw,attr2,nobarrier,noquota 0 0


# dmesg | tail -n 4
Filesystem "dm-1": Disabling barriers, trial barrier write failed
XFS mounting filesystem dm-1
XFS resetting qflags for filesystem dm-1
Ending clean XFS mount for filesystem: dm-1


# make some file


# umount /lv1/


# mount -o prjquota,noatime /dev/ld/lv1 /lv1/


kernel 2.6.27.59
===============================================================================
# slabtop
 Active / Total Objects (% used)    : 57099 / 69863 (81.7%)
 Active / Total Slabs (% used)      : 2461 / 2461 (100.0%)
 Active / Total Caches (% used)     : 52 / 61 (85.2%)
 Active / Total Size (% used)       : 15820.23K / 19563.04K (80.9%)
 Minimum / Average / Maximum Object : 0.01K / 0.28K / 4.00K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
 15600   8223  52%    0.20K    780       20      3120K dentry
  8160   8147  99%    0.08K    160       51       640K sysfs_dir_cache
  7600   7584  99%    0.49K    475       16      3800K inode_cache
  7192   5130  71%    0.55K    248       29      3968K radix_tree_node
  3480   3463  99%    0.16K    145       24       580K vm_area_struct
  3072   3062  99%    0.01K      6      512        24K kmalloc-8
  3072   2479  80%    0.02K     12      256        48K kmalloc-16
  2176   2040  93%    0.03K     17      128        68K kmalloc-32
  1904   1904 100%    0.07K     34       56       136K Acpi-ParseExt
  1728   1530  88%    0.06K     27       64       108K kmalloc-64
  1587    551  34%    0.69K     69       23      1104K ext3_inode_cache
  1554   1534  98%    0.09K     37       42       148K kmalloc-96
  1360   1192  87%    0.02K      8      170        32K scsi_data_buffer
  1280    967  75%    0.03K     10      128        40K anon_vma
  1088    977  89%    0.12K     34       32       136K kmalloc-128
  1050    970  92%    0.19K     50       21       200K kmalloc-192
   720    661  91%    0.25K     45       16       180K kmalloc-256
   688    684  99%    1.00K     43       16       688K kmalloc-1024
   680    680 100%    0.02K      4      170        16K journal_handle
   608    563  92%    2.00K     38       16      1216K kmalloc-2048
   512    512 100%    0.02K      2      256         8K revoke_table
   399    350  87%    0.81K     21       19       336K signal_cache
   396    240  60%    0.11K     11       36        44K buffer_head
   345    323  93%    1.38K     15       23       480K task_struct
   315    294  93%    2.06K     21       15       672K sighand_cache
   292    292 100%    0.05K      4       73        16K nsproxy
   290    195  67%    0.54K     10       29       160K proc_inode_cache
   288    260  90%    0.50K     18       16       144K kmalloc-512
   180    180 100%    0.53K      6       30        96K idr_layer_cache
   168    121  72%    0.38K      8       21        64K ip_dst_cache
   168    168 100%    0.09K      4       42        16K journal_head
   161    120  74%    0.69K      7       23       112K files_cache
   156    116  74%    0.30K      6       26        48K blkdev_requests
   128    124  96%    4.00K     16        8       512K kmalloc-4096
   125    122  97%    0.62K      5       25        80K sock_inode_cache
   105    105 100%    0.75K      5       21        80K UDP
   100    100 100%    0.16K      4       25        16K sigqueue
    96     96 100%    0.50K      6       16        48K xfs_vnode
    96     96 100%    0.50K      6       16        48K xfs_inode
    92     92 100%    0.69K      4       23        64K bdev_cache
    92     92 100%    0.68K      4       23        64K shmem_inode_cache
    88     88 100%    0.18K      4       22        16K file_lock_cache
    88     88 100%    0.18K      4       22        16K xfs_buf_item
    85     85 100%    0.05K      1       85         4K Acpi-Parse
    85     85 100%    0.45K      5       17        40K xfs_dquots
    84     84 100%    1.50K      4       21       128K TCP
    80     80 100%    0.20K      4       20        16K xfs_log_ticket
    80     80 100%    0.78K      4       20        64K xfs_trans
    72     72 100%    1.74K      4       18       128K blkdev_queue
    64     64 100%    0.48K      4       16        32K xfs_da_state
    18     18 100%    0.88K      1       18        16K mqueue_inode_cache
    16     16 100%    0.49K      1       16         8K hugetlbfs_inode_cache


# vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 2  0  22824 771404    112 187288    0    0 11532    96 1448 1526  0  4 96  0
 1  0  22824 760592    112 193928    0    0  6504     0 2126 1937  0  5 95  0
 0  0  22824 757800    112 200968    0    0  7072     0 2313 2116  0  6 94  0
 0  0  22824 745976    112 212244    0    0 11372    20 1735 1475  0  5 95  0
 0  0  22824 738772    128 220260    0    0  7956     0 1939 1762  1  4 95  0
 1  0  22824 729536    196 225696    0    0  5468    16 2316 1784  1  6 91  2
 0  0  22824 727088    196 231692    0    0  6016     0 2096 1877  0  5 95  0
 0  0  22824 716836    196 241680    0    0  9980     0 2089 1815  0  6 94  0
 0  0  22824 708288    196 250636    0    0  9032     0 1984 1930  0  6 94  0
 0  0  22824 700896    340 258148    0    0  7592     4 2201 2180  0  5 93  2
 0  0  22824 700800    340 258164    0    0     0     1   68   37  0  0 100  0
 0  0  22824 700564    360 258452    0    0   308    24 1426 1010  3  6 89  2
 0  0  22824 700552    360 258460    0    0     0     0   61   27  0  0 100  0
 0  0  22824 700552    360 258460    0    0     0     4   62   29  0  0 100  0
 0  0  22824 700552    360 258460    0    0     0    12   77   31  0  0 100  0
 0  0  22824 700264    372 258460    0    0     4    60  430  158  2  2 96  1
 0  0  22824 700404    372 258512   96    0   164     0  158   83  0  0 98  1


kernel 2.6.32.56
===============================================================================

# slabtop
 Active / Total Objects (% used)    : 480768 / 490400 (98.0%)
 Active / Total Slabs (% used)      : 15343 / 15343 (100.0%)
 Active / Total Caches (% used)     : 56 / 72 (77.8%)
 Active / Total Size (% used)       : 437468.87K / 440362.06K (99.3%)
 Minimum / Average / Maximum Object : 0.01K / 0.90K / 8.00K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
416032 416032 100%    1.00K  13001       32    416032K xfs_inode
 14868   7876  52%    0.19K    708       21      2832K dentry
  9715   9641  99%    0.55K    335       29      5360K radix_tree_node
  9027   8987  99%    0.08K    177       51       708K sysfs_dir_cache
  7644   7526  98%    0.61K    294       26      4704K inode_cache
  3726   3697  99%    0.17K    162       23       648K vm_area_struct
  3584   3583  99%    0.01K      7      512        28K kmalloc-8
  2304   2295  99%    0.02K      9      256        36K kmalloc-16
  1848   1848 100%    0.07K     33       56       132K Acpi-ParseExt
  1806   1806 100%    0.09K     43       42       172K kmalloc-96
  1716    404  23%    0.81K     44       39      1408K ext3_inode_cache
  1491   1396  93%    0.19K     71       21       284K kmalloc-192
  1472   1303  88%    0.06K     23       64        92K kmalloc-64
  1440   1407  97%    0.12K     45       32       180K kmalloc-128
  1408   1403  99%    0.03K     11      128        44K kmalloc-32
  1280    996  77%    0.03K     10      128        40K anon_vma
  1190   1190 100%    0.02K      7      170        28K fsnotify_event_holder
  1120   1114  99%    0.25K     35       32       280K kmalloc-256
  1020    920  90%    0.04K     10      102        40K dm_io
   680    680 100%    0.02K      4      170        16K journal_handle
   640    628  98%    1.00K     20       32       640K kmalloc-1024
   544    531  97%    0.50K     17       32       272K kmalloc-512
   512    512 100%    0.02K      2      256         8K revoke_table
   392    372  94%    4.00K     49        8      1568K kmalloc-4096
   360    356  98%    0.88K     10       36       320K signal_cache
   352    320  90%    1.41K     16       22       512K task_struct
   330    310  93%    2.06K     22       15       704K sighand_cache
   292    292 100%    0.05K      4       73        16K uhci_urb_priv
   288    258  89%    2.00K     18       16       576K kmalloc-2048
   255    255 100%    0.05K      3       85        12K Acpi-Parse
   240    232  96%    0.33K     10       24        80K blkdev_requests
   216    154  71%    0.11K      6       36        24K buffer_head
   189    125  66%    0.38K      9       21        72K ip_dst_cache
   180    180 100%    0.53K      6       30        96K idr_layer_cache
   168    111  66%    0.66K      7       24       112K proc_inode_cache
   161    118  73%    0.69K      7       23       112K files_cache
   160    160 100%    8.00K     40        4      1280K kmalloc-8192
   156    156 100%    0.81K      4       39       128K mm_struct
   156    156 100%    0.20K      4       39        32K xfs_btree_cur
   144    144 100%    0.88K      4       36       128K bdev_cache
   144    144 100%    0.11K      4       36        16K journal_head
   105    105 100%    0.75K      5       21        80K sock_inode_cache
   100    100 100%    0.16K      4       25        16K sigqueue
   100    100 100%    0.62K      4       25        64K UNIX
    88     88 100%    0.18K      4       22        16K file_lock_cache
    84     84 100%    1.50K      4       21       128K TCP
    84     84 100%    0.75K      4       21        64K UDP
    84     84 100%    0.75K      4       21        64K RAW
    80     80 100%    0.80K      4       20        64K shmem_inode_cache
    80     80 100%    0.20K      4       20        16K xfs_log_ticket
    80     80 100%    0.78K      4       20        64K xfs_trans
    75     75 100%    2.06K      5       15       160K blkdev_queue
    68     68 100%    0.46K      2       34        32K xfs_dquots
    64     64 100%    0.25K      2       32        16K tw_sock_TCP
    32     32 100%    1.00K      1       32        32K mqueue_inode_cache
    26     26 100%    0.61K      1       26        16K hugetlbfs_inode_cache


# vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  6  26308 629672    120  10832 6936 1336 38684  1528 3984 4832  0  1 51 48
 0  5  26132 627972    100  10792 8344 1992 37268  2176 3858 4270  0  1 48 51
 0  6  26112 625360    108  11120 5728 1012 24400  1080 4197 4197  0  1 48 52
 0  4  26012 622216    100  12184 4232 1084 49108  1168 1812 2003  0  1 54 45
 0  7  26136 617312    100  12292 5012  724 22468   840 3820 3811  0  1 60 39
 0  6  26900 607272    112  10852 4416 1936 20164  2020 3765 4018  0  2 38 60
 0  8  26956 605556    112  11088 10028 2060 36976  2188 3815 4206  0  1 50 50
 0  8  27136 603588    104  11804 6652 1484 30004  1560 4408 4292  0  1 47 52
 0  9  27232 603032     92  10872 11192 2060 44168  2196 3064 4193  0  1 48 51
 0  9  27268 600808    108  11484 5608 1100 24528  1180 3820 5032  0  1 45 55
 0  8  27176 597888     92  13240 4176  776 16144   804 1740 1991  0  1 43 56
 0  9  27344 597520     88  11856 4264 1024 17204  1092 2151 2285  0  1 46 53
 0  9  27256 595072     84  13612 4012  672 16788   712 1766 1728  0  0 49 50
 0  7  27380 596036     76  10692 4632 1004 19932  1112 2502 2615  0  1 44 55
 0  8  27364 595124     84  10672 7124 1280 29760  1360 2087 2340  0  1 54 46
 0  4  25804 557156    220  25100 2380    0 14900    64 5912 13791  1  3 43 53
 0  7  30616 558984    148  10960 6244 5936 30808  6080 5464 6092  1  3 43 54
 1  8  30684 557096    144  10748 4696  856 17660   912 2882 3462  0  1 50 49
 0  9  30636 555916    148  10724 4844 1096 18504  1152 1930 1882  0  1 48 52
 0  7  30760 555464    124  10632 3464  772 47860   804 2756 2311  0  1 48 51
 2  9  30708 552508    128  11080 5600 1212 27764  1312 3246 5115  0  1 51 48
 0  9  30576 550956    124  10920 6680 1212 28460  1288 3680 3391  0  1 49 50
 1  7  30652 543576    168  15832 4084 1420 15116  1444 2166 1994  0  1 41 58
 0  8  31504 548592    128  10072 5744 2224 13168  2272 2497 2356  0  1 42 57
 0  7  30284 538804    164  12796 3784 1064 14220  1128 2793 3585  0  1 49 50
 0  6  28988 529760    228  19680 5236  584 11752   624 2569 1870  0  2 37 61
 0  8  30132 537608    124  11704 4736 1948 16048  2060 2335 2714  0  1 48 52
 0  7  29952 536456    160  12444 6068 1260 14908  1316 1857 2408  0  1 48 52
 1  7  30288 535668    156  12084 4952 1692 11324  1748 2286 2741  0  1 49 50
 0  7  30452 536408    132  10644 10128 1780 29128  1916 3161 5233  0  0 49 50
 0 12  30472 535008    128  11148 9836 1656 37876  1744 4245 5299  0  0 65 34
 0 11  30568 533392    128  12140 10000 2448 37572  2532 3759 4130  0  1 59 40
 0 11  30628 534444    108  10608 8116 1736 30740  1784 5541 5724  0  1 46 54
 0  8  30328 531032    108  12924 5404 1076 16324  1128 3451 3183  0  1 46 53
 0  9  30400 533212    104  11136 4608 1176 14616  1216 2326 2648  0  1 46 53
 0 11  30296 532704    116  10800 6708 1440 25280  1516 2927 3307  0  1 47 52
 0 11  30272 529704    104  12772 4916 1232 15496  1272 2074 2524  0  1 48 52
 0  8  30576 532268    100  11052 5724 1412 16424  1448 2462 2833  0  1 51 48
 0 11  30344 531728    100  10900 8640 2000 34480  2080 3452 5607  0  1 41 59
 0 11  30360 529976     88  11688 5432 1352 24172  1408 3961 6200  0  1 46 53
 0 11  30268 528664     84  12972 6576 1460 31992  1548 4034 5064  0  1 43 56
 0 14  30288 530108    104  11436 8188 1684 29112  1744 4197 5561  0  0 47 52
 0 18  30132 529456    128  11372 21580 3968 70524  4028 4764 6888  0  1 47 52
 0 16  29796 529032    112  11736 26780 5956 102288  6096 13129 19791
0  1 43 56
 0 17  29524 528248    120  12868 35696 8056 140268  8224 10286 14513
0  1 44 56
 0 15  22308 528696    132  12140 27956 7296 120788  7520 18155 28256
0  1 45 54

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
