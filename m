Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C61CF7F4E
	for <xfs@oss.sgi.com>; Sun, 23 Nov 2014 05:37:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B15C830404E
	for <xfs@oss.sgi.com>; Sun, 23 Nov 2014 03:37:49 -0800 (PST)
Received: from mout.web.de (mout.web.de [212.227.17.12]) by cuda.sgi.com with
	ESMTP id Vrn0g8YhxIlXodlw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Nov 2014 03:37:43 -0800 (PST)
Message-ID: <5471C703.2090109@web.de>
Date: Sun, 23 Nov 2014 12:37:39 +0100
From: Markus Rhonheimer <markus.rhonheimer@web.de>
MIME-Version: 1.0
Subject: Re: Virtual Block device resize corrupts XFS
References: <5468FC60.10901@web.de> <20141116223630.GH23575@dastard>
In-Reply-To: <20141116223630.GH23575@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

I am back at the PC now and here is more information:

[root@localhost ~]# uname -a
Linux localhost.localdomain 3.10.0-123.el7.x86_64 #1 SMP Mon Jun 30 
12:09:22 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

[root@localhost ~]# xfs_repair -V
xfs_repair Version 3.2.0-alpha2

[root@localhost ~]# cat /proc/meminfo
MemTotal:       16307660 kB
MemFree:          257876 kB
MemAvailable:     475640 kB
Buffers:               0 kB
Cached:           757256 kB
SwapCached:       946432 kB
Active:          4082924 kB
Inactive:        1807204 kB
Active(anon):    4009728 kB
Inactive(anon):  1689444 kB
Active(file):      73196 kB
Inactive(file):   117760 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       4095932 kB
SwapFree:        1980064 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:       4210260 kB
Mapped:            23340 kB
Shmem:            566300 kB
Slab:             452760 kB
SReclaimable:     280224 kB
SUnreclaim:       172536 kB
KernelStack:        3632 kB
PageTables:        23704 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    12249760 kB
Committed_AS:    8874152 kB
VmallocTotal:   34359738367 kB
VmallocUsed:     9586152 kB
VmallocChunk:   34345555948 kB
HardwareCorrupted:     0 kB
AnonHugePages:    419840 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      776724 kB
DirectMap2M:    15972352 kB

[root@localhost ~]# cat /proc/mounts
rootfs / rootfs rw 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,seclabel,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs 
rw,seclabel,nosuid,size=8114764k,nr_inodes=2028691,mode=755 0 0
securityfs /sys/kernel/security securityfs 
rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,seclabel,nosuid,nodev 0 0
devpts /dev/pts devpts 
rw,seclabel,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,seclabel,nosuid,nodev,mode=755 0 0
tmpfs /sys/fs/cgroup tmpfs rw,seclabel,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup 
rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 
0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/cpuset cgroup 
rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup 
rw,nosuid,nodev,noexec,relatime,cpuacct,cpu 0 0
cgroup /sys/fs/cgroup/memory cgroup 
rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/devices cgroup 
rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/freezer cgroup 
rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/net_cls cgroup 
rw,nosuid,nodev,noexec,relatime,net_cls 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/perf_event cgroup 
rw,nosuid,nodev,noexec,relatime,perf_event 0 0
cgroup /sys/fs/cgroup/hugetlb cgroup 
rw,nosuid,nodev,noexec,relatime,hugetlb 0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
/dev/md125 / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
selinuxfs /sys/fs/selinux selinuxfs rw,relatime 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs 
rw,relatime,fd=34,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
mqueue /dev/mqueue mqueue rw,seclabel,relatime 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,seclabel,relatime 0 0
sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
sunrpc /proc/fs/nfsd nfsd rw,relatime 0 0
/dev/md126 /boot xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
littleraid /littleraid zfs rw,seclabel,relatime,xattr,noacl 0 0
/dev/zd256 /mnt xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0

[root@localhost ~]# cat /proc/partitions
major minor  #blocks  name

    8      144  156290904 sdj
    8      145    4098048 sdj1
    8      146    1024000 sdj2
    8      147  151166976 sdj3
    8      128  156290904 sdi
    8      129    4098048 sdi1
    8      130    1024000 sdi2
    8      131  151166976 sdi3
    8      160 2930266584 sdk
    8      161 2930256896 sdk1
    8      169       8192 sdk9
    8      176 2930266584 sdl
    8      177 2930256896 sdl1
    8      185       8192 sdl9
    8      192 2930266584 sdm
    8      193 2930256896 sdm1
    8      201       8192 sdm9
    8      208 2930266584 sdn
    8      209 2930256896 sdn1
    8      217       8192 sdn9
    8       48 2930266584 sdd
    8       49 2930256896 sdd1
    8       57       8192 sdd9
    8       32 1465138584 sdc
    8       33 1465128960 sdc1
    8       41       8192 sdc9
    8       16 1465138584 sdb
    8       17 1465128960 sdb1
    8       25       8192 sdb9
    8      112 1465138584 sdh
    8      113 1465128960 sdh1
    8      121       8192 sdh9
    8       96 1465138584 sdg
    8       97 1465128960 sdg1
    8      105       8192 sdg9
    8       80 1465138584 sdf
    8       81 1465128960 sdf1
    8       89       8192 sdf9
    8       64 1465138584 sde
    8       65 1465128960 sde1
    8       73       8192 sde9
    9      127    4095936 md127
    9      126    1023936 md126
    9      125  151035776 md125
    8        0 2930266584 sda
    8        1 2930256896 sda1
    8        9       8192 sda9
  230       16  524288000 zd16
  230       17  524286959 zd16p1
  230       48   10485760 zd48
  230       64  576716800 zd64
  230       65  576715759 zd64p1
  230       80  209715200 zd80
  230       81  209714159 zd80p1
  230       96 1048576000 zd96
  230       97 1048574959 zd96p1
  230      112  524288000 zd112
  230      113  524286959 zd112p1
  230      128  104857600 zd128
  230      129     131072 zd128p1
  230      130  104724480 zd128p2
  230      144  104857600 zd144
  230      145  104856559 zd144p1
  230      160  524288000 zd160
  230      161  524286959 zd160p1
  230      176  104857600 zd176
  230      177  104856559 zd176p1
  230      192  209715200 zd192
  230      193  209714159 zd192p1
  230      208   10485760 zd208
  230      224  209715200 zd224
  230      225  209714159 zd224p1
    8      224 1953514584 sdo
    8      225 1953505280 sdo1
    8      233       8192 sdo9
    8      240 1953514584 sdp
    8      241 1953505280 sdp1
    8      249       8192 sdp9
  230      240 2044723200 zd240
  230      256 8388608000 zd256
   65        0 1953514584 sdq
   65        1 1953505280 sdq1
   65        9       8192 sdq9
   65       16 1953514584 sdr
   65       17 1953505280 sdr1
   65       25       8192 sdr9

[root@localhost ~]# xfs_info /mnt
meta-data=/dev/zd256             isize=256    agcount=144, 
agsize=13107200 blks
          =                       sectsz=4096  attr=2, projid32bit=0
          =                       crc=0
data     =                       bsize=4096   blocks=1887436800, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =Intern                 bsize=4096   blocks=25600, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =keine                  extsz=4096   blocks=0, rtextents=0


dmesg shows no errors

I tried to save as much as I can:

[root@localhost ~]# rsync -ave ssh /mnt/* me@192.168.64.58:/speicher/ 
1>>/root/fehler1.log 2>/root/fehler2.log
me@192.168.64.58's password:

Message from syslogd@localhost at Nov 23 11:51:44 ...
  kernel:BUG: soft lockup - CPU#0 stuck for 23s! [kworker/0:3:6285]

journald outputs these massages, as I do the rsync:

Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): metadata I/O 
error: block 0x33f215488 ("xfs_trans_read_buf_map") error 117 numblks 8
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): Metadata 
corruption detected at xfs_bmbt_read_verify+0x79/0xc0 [xfs], block 
0x33f215488
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): Unmount and 
run xfs_repair
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): First 64 
bytes of corrupted metadata buffer:
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65000: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65010: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65020: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65030: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): metadata I/O 
error: block 0x33f215488 ("xfs_trans_read_buf_map") error 117 numblks 8
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): Metadata 
corruption detected at xfs_bmbt_read_verify+0x79/0xc0 [xfs], block 
0x33f215488
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): Unmount and 
run xfs_repair
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): First 64 
bytes of corrupted metadata buffer:
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65000: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65010: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65020: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65030: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): metadata I/O 
error: block 0x33f215488 ("xfs_trans_read_buf_map") error 117 numblks 8
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): Metadata 
corruption detected at xfs_bmbt_read_verify+0x79/0xc0 [xfs], block 
0x33f215488
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): Unmount and 
run xfs_repair
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): First 64 
bytes of corrupted metadata buffer:
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65000: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65010: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65020: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65030: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): metadata I/O 
error: block 0x33f215488 ("xfs_trans_read_buf_map") error 117 numblks 8
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): Metadata 
corruption detected at xfs_bmbt_read_verify+0x79/0xc0 [xfs], block 
0x33f215488
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): Unmount and 
run xfs_repair
Nov 21 20:17:15 localhost.localdomain kernel: XFS (zd256): First 64 
bytes of corrupted metadata buffer:
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65000: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65010: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65020: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Nov 21 20:17:15 localhost.localdomain kernel: ffff88014cc65030: 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00  ................

I hope this is the right way to post the output.

Would appreciate any ideas how to find out which files are broken.

kind regards,
Markus



Am 16.11.2014 um 23:36 schrieb Dave Chinner:
> On Sun, Nov 16, 2014 at 08:34:56PM +0100, Markus Rhonheimer wrote:
>> Hi,
>>
>> I am running Centos 7 and have created a virtual block device with
>> ZFS (ZVOL). I put XFS onto the block device without partitioning it.
>>
>> This worked very well as storage disk for a VM.
>>
>> A few days ago I wanted to increase the size of the block device,
>> but accidently decreased it by 1 TB (from 7 to 6). I found out about
>> it and immediately increased the size of the drive to 8 TB
>> afterward.
> If that was a normal LVM block device, there would have been no
> trouble. But you're using something special, unusual and completely
> untested, so the most likely outcome is going to be that you still
> have a pile of broken bits.
>
>> The XFS partition can still be mounted and I can list the files on
>> it, but xfs_repair -n says: "/Sorry/, /could not find valid
>> secondary superblock"
> Full output, please, as well as the version of xfs_repair you are
> using...
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
