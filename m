Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 978E77CA0
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 01:28:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23A7EAC001
	for <xfs@oss.sgi.com>; Sun, 12 Jun 2016 23:28:20 -0700 (PDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com
	[74.125.82.67]) by cuda.sgi.com with ESMTP id YFTcobuIflLpVb4l
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Jun 2016 23:28:14 -0700 (PDT)
Received: by mail-wm0-f67.google.com with SMTP id k184so12196768wme.2
	for <xfs@oss.sgi.com>; Sun, 12 Jun 2016 23:28:14 -0700 (PDT)
Received: from [10.101.4.32] ([195.170.178.154])
	by smtp.gmail.com with ESMTPSA id
	d137sm5623294wmd.12.2016.06.12.23.28.11 for <xfs@oss.sgi.com>
	(version=TLSv1/SSLv3 cipher=OTHER);
	Sun, 12 Jun 2016 23:28:12 -0700 (PDT)
From: Martin Aleksov <martin.aleksov@gmail.com>
Subject: Metadata corruption
Message-ID: <7494383b-a153-7a79-b872-42ac6506ac9e@gmail.com>
Date: Mon, 13 Jun 2016 09:27:57 +0300
MIME-Version: 1.0
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

HiThere,

I'm using XFS on Arch linux.Each 2 days I'm receiving this error:


Metadata corruption detected at xfs_inode block 0x5bd20/0x8000

while doing this:


[martin@marto ~]$ sudo xfs_db -c frag -r /dev/sda2
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
Metadata corruption detected at xfs_inode block 0x5bd20/0x8000
xfs_db: out of memory



Here is the needed information:


Linux marto 4.6.2-1-ARCH #1 SMP PREEMPT Wed Jun 8 08:40:59 CEST 2016
x86_64 GNU/Linux
================================================

xfs_repair version 4.5.0
==================================================

lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                4
On-line CPU(s) list:   0-3
Thread(s) per core:    2
Core(s) per socket:    2
Socket(s):             1
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 58
Model name:            Intel(R) Core(TM) i5-3210M CPU @ 2.50GHz
Stepping:              9
CPU MHz:               1213.964
CPU max MHz:           3100.0000
CPU min MHz:           1200.0000
BogoMIPS:              4990.55
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              3072K
NUMA node0 CPU(s):     0-3
Flags:                 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm epb tpr_shadow vnmi
flexpriority ept vpid fsgsbase smep erms xsaveopt dtherm ida arat pln pts
==============================================================================

cat /proc/meminfo
MemTotal:       16025984 kB
MemFree:        13078108 kB
MemAvailable:   14024292 kB
Buffers:            5740 kB
Cached:          1373716 kB
SwapCached:            0 kB
Active:          1656728 kB
Inactive:         997388 kB
Active(anon):    1346700 kB
Inactive(anon):   158028 kB
Active(file):     310028 kB
Inactive(file):   839360 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       2047996 kB
SwapFree:        2047996 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:       1128564 kB
Mapped:           403056 kB
Shmem:            230068 kB
Slab:             131908 kB
SReclaimable:      97016 kB
SUnreclaim:        34892 kB
KernelStack:        7040 kB
PageTables:        17108 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    10060988 kB
Committed_AS:    3812328 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
HardwareCorrupted:     0 kB
AnonHugePages:    317440 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       82280 kB
DirectMap2M:    16279552 kB
==============================================
cat /proc/mounts
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sys /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
dev /dev devtmpfs
rw,nosuid,relatime,size=8009624k,nr_inodes=2002406,mode=755 0 0
run /run tmpfs rw,nosuid,nodev,relatime,mode=755 0 0
/dev/sda2 / xfs rw,relatime,attr2,inode64,noquota 0 0
securityfs /sys/kernel/security securityfs
rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
devpts /dev/pts devpts
rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /sys/fs/cgroup tmpfs ro,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup
rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd
0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/memory cgroup
rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/net_cls cgroup
rw,nosuid,nodev,noexec,relatime,net_cls 0 0
cgroup /sys/fs/cgroup/pids cgroup rw,nosuid,nodev,noexec,relatime,pids 0 0
cgroup /sys/fs/cgroup/cpuset cgroup
rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup
rw,nosuid,nodev,noexec,relatime,cpu,cpuacct 0 0
cgroup /sys/fs/cgroup/freezer cgroup
rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/devices cgroup
rw,nosuid,nodev,noexec,relatime,devices 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs
rw,relatime,fd=26,pgrp=1,timeout=0,minproto=5,maxproto=5,direct 0 0
mqueue /dev/mqueue mqueue rw,relatime 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,relatime 0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
tmpfs /tmp tmpfs rw 0 0
/dev/sda4 /home xfs rw,relatime,attr2,inode64,noquota 0 0
/dev/sda1 /boot ext4 rw,relatime,data=ordered 0 0
/dev/sdb1 /var xfs rw,relatime,attr2,inode64,noquota 0 0
/dev/sdb2 /data xfs rw,relatime,attr2,inode64,noquota 0 0
tmpfs /run/user/1000 tmpfs
rw,nosuid,nodev,relatime,size=1602600k,mode=700,uid=1000,gid=100 0 0
gvfsd-fuse /run/user/1000/gvfs fuse.gvfsd-fuse
rw,nosuid,nodev,relatime,user_id=1000,group_id=100 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
=================================================================

cat /proc/partitions
major minor  #blocks  name

   8        0  244198584 sda
   8        1     307200 sda1
   8        2   20480000 sda2
   8        3    2048000 sda3
   8        4  221362176 sda4
   8       16  488386584 sdb
   8       17   20971520 sdb1
   8       18  467414016 sdb2

======================================================


I'm Using Samsumng 850 Evo SSD and normal HDD.

=================================================

 sudo  hdparm -I /dev/sda  |grep -i "write ca"
[sudo] password for martin:
	   *	Write cache

=================================================

[martin@marto ~]$ sudo  hdparm -I /dev/sdb  |grep -i "write ca"
	   *	Write cache

========================================================



xfs_info  /dev/sda2
meta-data=/dev/sda2              isize=512    agcount=4, agsize=1280000 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0
data     =                       bsize=4096   blocks=5120000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

==========================================================================
[martin@marto ~]$ dmesg |grep -i xfs
[    3.659623] SGI XFS with ACLs, security attributes, realtime, no
debug enabled
[    3.662257] XFS (sda2): Mounting V5 Filesystem
[    3.676309] XFS (sda2): Ending clean mount
[    4.064618] XFS (sda4): Mounting V5 Filesystem
[    4.068012] XFS (sdb2): Mounting V5 Filesystem
[    4.074383] XFS (sdb1): Mounting V5 Filesystem
[    4.082505] XFS (sda4): Ending clean mount
[    4.299465] XFS (sdb1): Ending clean mount
[    4.300056] XFS (sdb2): Ending clean mount

After reboot the error is gone.Any advise what is causing this error and
how to fix the issue permenantly?



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
