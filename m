Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BHpS4O189627 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 12:51:28 -0500
Received: from crcuda.crossroads.com (crcuda.crossroads.com [66.219.50.99]) by
	cuda.sgi.com with ESMTP id YHHDToQARzBJnSYU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 10:53:00 -0700 (PDT)
Received: from crds-transport1.COMMSTOR.Crossroads.com
	(crds-transport1.commstor.crossroads.com [192.168.120.151]) by
	crcuda.crossroads.com with ESMTP id A4lDf2lzuodAlVWy
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Oct 2012 12:52:58 -0500 (CDT)
Message-ID: <5077077A.3040608@crossroads.com>
Date: Thu, 11 Oct 2012 12:52:58 -0500
From: Wayne Walker <wwalker@crossroads.com>
MIME-Version: 1.0
Subject: File system corruption
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

In short, I am able to:  mkfs...; mount...; cp 1gbfile...; sync; cp 
1gbfile...; sync  # and now the xfs is corrupt

I see multiple bugs

1. very simple, non-corner-case actions create a corrupted file system
2. corrupt data is knowingly written to the file system.
3. the file system stays online and writable
4. future write operations to the file system return success.

Details:

[wwalker@speedy ~] [] $ cat xfs_bug_report
bash-4.1# uname -a
Linux localhost.localdomain 2.6.32-71.29.1.el6.x86_64 #1 SMP Mon Jun 27 
19:49:27 BST 2011 x86_64 x86_64 x86_64 GNU/Linux

bash-4.1# xfs_repair -V
xfs_repair version 3.1.1


bash-4.1# cat /proc/meminfo
MemTotal:       98933876 kB
MemFree:        10626620 kB
Buffers:           88828 kB
Cached:          1693684 kB
SwapCached:            0 kB
Active:          2094048 kB
Inactive:         278972 kB
Active(anon):    1713716 kB
Inactive(anon):    95388 kB
Active(file):     380332 kB
Inactive(file):   183584 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:      20479992 kB
SwapFree:       20479992 kB
Dirty:               208 kB
Writeback:             0 kB
AnonPages:        590704 kB
Mapped:            57760 kB
Shmem:           1218600 kB
Slab:            1761776 kB
SReclaimable:     142184 kB
SUnreclaim:      1619592 kB
KernelStack:        4632 kB
PageTables:        13496 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    28003888 kB
Committed_AS:    3281984 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      489664 kB
VmallocChunk:   34307745544 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:   40960
HugePages_Free:    40794
HugePages_Rsvd:      173
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        5632 kB
DirectMap2M:     2082816 kB
DirectMap1G:    98566144 kB


bash-4.1# # 2 CPUs, E5620 8 core procs


bash-4.1# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 44
model name      : Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
stepping        : 2
cpu MHz         : 1600.000
cache size      : 12288 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good 
xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx 
smx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt aes lahf_lm 
ida arat tpr_shadow vnmi flexpriority ept vpid
bogomips        : 4800.20
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:

<14 core reports deleted>

processor       : 15
vendor_id       : GenuineIntel
cpu family      : 6
model           : 44
model name      : Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
stepping        : 2
cpu MHz         : 1600.000
cache size      : 12288 KB
physical id     : 1
siblings        : 8
core id         : 10
cpu cores       : 4
apicid          : 53
initial apicid  : 53
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good 
xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx 
smx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt aes lahf_lm 
ida arat tpr_shadow vnmi flexpriority ept vpid
bogomips        : 4799.88
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:


bash-4.1# cat /proc/mounts
rootfs / rootfs rw 0 0
/proc /proc proc rw,relatime 0 0
/sys /sys sysfs rw,relatime 0 0
udev /dev devtmpfs 
rw,relatime,size=49459988k,nr_inodes=12364997,mode=755 0 0
devpts /dev/pts devpts rw,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /dev/shm tmpfs rw,relatime 0 0
/dev/sdb1 / ext3 
rw,relatime,errors=continue,user_xattr,acl,barrier=1,data=ordered 0 0
/proc/bus/usb /proc/bus/usb usbfs rw,relatime 0 0
/dev/sdb5 /core xfs rw,relatime,attr2,noquota 0 0
/dev/sdb6 /data xfs rw,relatime,attr2,noquota 0 0
/dev/sdd1 /database xfs rw,relatime,attr2,noquota 0 0
/dev/sdb2 /secondary ext3 
rw,relatime,errors=continue,user_xattr,acl,barrier=1,data=ordered 0 0
tmpfs /dev/shm tmpfs rw,relatime 0 0
/dev/sda1 /vpd xfs rw,noatime,attr2,sunit=2048,swidth=8192,noquota 0 0
/dev/sda8 /cfg_backup xfs 
rw,noatime,attr2,sunit=2048,swidth=8192,noquota 0 0
/dev/sdg1 /db_backup xfs 
rw,relatime,attr2,sunit=2048,swidth=8192,noquota 0 0
/dev/sdf1 /dtfs_data/data2 xfs 
rw,noatime,attr2,nobarrier,logdev=/dev/sda6,sunit=2048,swidth=8192,noquota 
0 0
/dev/sdh1 /dtfs_data/data3 xfs 
rw,noatime,attr2,nobarrier,logdev=/dev/sda7,sunit=2048,swidth=8192,noquota 
0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
/etc/auto.misc /misc autofs 
rw,relatime,fd=7,pgrp=2972,timeout=300,minproto=5,maxproto=5,indirect 0 0
-hosts /net autofs 
rw,relatime,fd=13,pgrp=2972,timeout=300,minproto=5,maxproto=5,indirect 0 0


bash-4.1# cat /proc/partitions
major minor  #blocks  name

    8        0   39082680 sda
    8        1      18432 sda1
    8        2     391168 sda2
    8        3     390144 sda3
    8        4          1 sda4
    8        5     389120 sda5
    8        6     390144 sda6
    8        7     389120 sda7
    8        8   37108736 sda8
    8       16   78150744 sdb
    8       17   10240000 sdb1
    8       18   10240000 sdb2
    8       19   20480000 sdb3
    8       20          1 sdb4
    8       21    5120000 sdb5
    8       22   32067584 sdb6
    8       48 2254857216 sdd
    8       49 2147482624 sdd1
    8       32 4731979776 sdc
    8       33 4731977728 sdc1
    8       64 4732048384 sde
    8       65 4732046336 sde1
    8       96  712964096 sdg
    8       97  712962048 sdg1
    8      112 5502995456 sdh
    8      113 5502993408 sdh1
    8       80 5502925824 sdf
    8       81 5502923776 sdf1


bash-4.1# lspci | grep -i RAID
84:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 2208 
[Thunderbolt] (rev 01)
85:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 2208 
[Thunderbolt] (rev 01)

There is an SSD (INTEL SSDSA2CT040G3; sda) used as an external log.

Each controller has 8 SEAGATE ST33000650SS 3 TB SATA drives.

The file system with a problem (sde1) is a RAID 6 made up of 6 drives 
and split into 3 pieces (sdc, sdd, sde) of roughly 4.7 TB, 2.2 TB, 4.7 TB.
sdc and sdd are mounted but are idle (sdc) or probably idle (sdd has 
postgres data on it but no transactions occurring) during the steps to 
produce a corrupt fs.

There are no LVMs in use


Both BBUs are fully charged and good


All VDs are set to: WriteBack, ReadAhead, Direct, No Write Cache if bad BBU

There is no significant IO or CPU load on the machine at all during the 
tests.

The exact commands to create the failure:

/sbin/mkfs.xfs -f -l logdev=/dev/sda5 -b size=4096 -d su=1024k,sw=4 
/dev/sde1
cat /etc/fstab
mount -t xfs -o defaults,noatime,logdev=/dev/sda5 /dev/sde1 /dtfs_data/data1
cp random_data.1G /dtfs_data/data1
# returns 0
sync
# file system reported no failure yet
cp random_data.1G /dtfs_data/data1
# returns 0
sync
# file system reports stack trace, bad agf, and page discard

bash-4.1# xfs_info /dtfs_data/data1
meta-data=/dev/sde1              isize=256    agcount=5, 
agsize=268435200 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1183011584, imaxpct=5
          =                       sunit=256    swidth=1024 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =external               bsize=4096   blocks=97280, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
