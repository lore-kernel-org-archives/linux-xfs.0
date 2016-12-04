Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:34629 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbcLDWHV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Dec 2016 17:07:21 -0500
Received: by mail-yb0-f178.google.com with SMTP id d59so53108163ybi.1
        for <linux-xfs@vger.kernel.org>; Sun, 04 Dec 2016 14:07:21 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc on
 glusterfs setup
From: Cyril Peponnet <cyril.peponnet@nuagenetworks.net>
In-Reply-To: <20161204214950.GL31101@dastard>
Date: Sun, 4 Dec 2016 14:07:18 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <9B23CFED-4AFC-46FC-8E35-AD85B11FEA02@nuagenetworks.net>
References: <E861E5C1-D1C2-4368-8BFC-505533C9A3A3@nuagenetworks.net>
 <20161204214950.GL31101@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi here is the details. The issue is on the scratch RAID array (used to =
store kvm snapshots). The other raid array is fine (no snapshot =
storage).

	=E2=80=A2 kernel version (uname -a) : Linux gluster05 =
3.10.0-123.el7.x86_64 #1 SMP Mon Jun 30 12:09:22 UTC 2014 x86_64 x86_64 =
x86_64 GNU/Linux

	=E2=80=A2 xfsprogs version (xfs_repair -V) : xfs_repair version =
3.2.0-alpha2

	=E2=80=A2 number of CPUs Bi Intel=C2=AE Xeon=C2=AE CPU E5-2630 =
v3 @ 2.40GHz (8 cores)

	=E2=80=A2 contents of /proc/meminfo
MemTotal:       65699268 kB
MemFree:         2058304 kB
MemAvailable:   62753028 kB
Buffers:              12 kB
Cached:         57664044 kB
SwapCached:        14840 kB
Active:         26757700 kB
Inactive:       31967204 kB
Active(anon):     502064 kB
Inactive(anon):   719452 kB
Active(file):   26255636 kB
Inactive(file): 31247752 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       4194300 kB
SwapFree:        3679388 kB
Dirty:              6804 kB
Writeback:           120 kB
AnonPages:       1048576 kB
Mapped:            55104 kB
Shmem:            160888 kB
Slab:            3999548 kB
SReclaimable:    3529220 kB
SUnreclaim:       470328 kB
KernelStack:        4240 kB
PageTables:         9464 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    37043932 kB
Committed_AS:    2200816 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      422024 kB
VmallocChunk:   34324311040 kB
HardwareCorrupted:     0 kB
AnonHugePages:    899072 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      111936 kB
DirectMap2M:     7118848 kB
DirectMap1G:    61865984 kB

	=E2=80=A2 contents of /proc/mounts
rootfs / rootfs rw 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs =
rw,nosuid,size=3D32842984k,nr_inodes=3D8210746,mode=3D755 0 0
securityfs /sys/kernel/security securityfs =
rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
devpts /dev/pts devpts =
rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmode=3D000 0 0
tmpfs /run tmpfs rw,nosuid,nodev,mode=3D755 0 0
tmpfs /sys/fs/cgroup tmpfs rw,nosuid,nodev,noexec,mode=3D755 0 0
cgroup /sys/fs/cgroup/systemd cgroup =
rw,nosuid,nodev,noexec,relatime,xattr,release_agent=3D/usr/lib/systemd/sys=
temd-cgroups-agent,name=3Dsystemd 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/cpuset cgroup =
rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup =
rw,nosuid,nodev,noexec,relatime,cpuacct,cpu 0 0
cgroup /sys/fs/cgroup/memory cgroup =
rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/devices cgroup =
rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/freezer cgroup =
rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/net_cls cgroup =
rw,nosuid,nodev,noexec,relatime,net_cls 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio =
0 0
cgroup /sys/fs/cgroup/perf_event cgroup =
rw,nosuid,nodev,noexec,relatime,perf_event 0 0
cgroup /sys/fs/cgroup/hugetlb cgroup =
rw,nosuid,nodev,noexec,relatime,hugetlb 0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
/dev/mapper/system-root_vol / xfs rw,relatime,attr2,inode64,noquota 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs =
rw,relatime,fd=3D36,pgrp=3D1,timeout=3D300,minproto=3D5,maxproto=3D5,direc=
t 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,relatime 0 0
mqueue /dev/mqueue mqueue rw,relatime 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
sunrpc /proc/fs/nfsd nfsd rw,relatime 0 0
/dev/sdc1 /boot ext4 rw,relatime,data=3Dordered 0 0
/dev/sda /export/raid/data xfs =
rw,noatime,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,=
swidth=3D1536,noquota 0 0
/dev/sdb /export/raid/scratch xfs =
rw,noatime,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,=
swidth=3D1024,noquota 0 0
binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
=09
	=E2=80=A2 contents of /proc/partitions
major minor  #blocks  name

   8        0 11717836800 sda
   8       16 7811891200 sdb
   8       32  500107608 sdc
   8       33     512000 sdc1
   8       34    4194304 sdc2
   8       35  495399936 sdc3
 253        0  495386624 dm-0
	=E2=80=A2 RAID layout (hardware and/or software) - Hardware
VD LIST :
=3D=3D=3D=3D=3D=3D=3D

----------------------------------------------------------------
DG/VD TYPE  State Access Consist Cache Cac sCC     Size Name
----------------------------------------------------------------
0/0   RAID0 Optl  RW     Yes     RAWBC -   ON  7.275 TB scratch
----------------------------------------------------------------

Cac=3DCacheCade|Rec=3DRecovery|OfLn=3DOffLine|Pdgd=3DPartially =
Degraded|dgrd=3DDegraded
Optl=3DOptimal|RO=3DRead Only|RW=3DRead =
Write|HD=3DHidden|B=3DBlocked|Consist=3DConsistent|
R=3DRead Ahead Always|NR=3DNo Read Ahead|WB=3DWriteBack|
AWB=3DAlways WriteBack|WT=3DWriteThrough|C=3DCached IO|D=3DDirect =
IO|sCC=3DScheduled
Check Consistency

Physical Drives =3D 4

PD LIST :
=3D=3D=3D=3D=3D=3D=3D

=
--------------------------------------------------------------------------=
---
EID:Slt DID State DG     Size Intf Med SED PI SeSz Model                 =
 Sp
=
--------------------------------------------------------------------------=
---
252:0     8 Onln   0 1.818 TB SATA HDD N   N  512B WDC =
WD2000FYYZ-01UL1B2 U
252:1    10 Onln   0 1.818 TB SATA HDD N   N  512B WDC =
WD2000FYYZ-01UL1B2 U
252:2    11 Onln   0 1.818 TB SATA HDD N   N  512B WDC =
WD2000FYYZ-01UL1B2 U
252:3     9 Onln   0 1.818 TB SATA HDD N   N  512B WDC =
WD2000FYYZ-01UL1B2 U
=
--------------------------------------------------------------------------=
---

	=E2=80=A2 xfs_info output on the filesystem in question

xfs_info /export/raid/scratch/
meta-data=3D/dev/sdb               isize=3D256    agcount=3D32, =
agsize=3D61030368 blks
         =3D                       sectsz=3D512   attr=3D2, =
projid32bit=3D1
         =3D                       crc=3D0
data     =3D                       bsize=3D4096   blocks=3D1952971776, =
imaxpct=3D5
         =3D                       sunit=3D32     swidth=3D128 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, =
version=3D2
         =3D                       sectsz=3D512   sunit=3D32 blks, =
lazy-count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0

	=E2=80=A2 dmesg output showing all error messages and stack =
traces

Nothing relevant in dmesg except several occurences of the following.

[7649583.386283] XFS: possible memory allocation deadlock in kmem_alloc =
(mode:0x250)
[7649585.370830] XFS: possible memory allocation deadlock in kmem_alloc =
(mode:0x250)
[7649587.241290] XFS: possible memory allocation deadlock in kmem_alloc =
(mode:0x250)
[7649589.243881] XFS: possible memory allocation deadlock in kmem_alloc =
(mode:0x250)

Thanks

> On Dec 4, 2016, at 1:49 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Sat, Dec 03, 2016 at 11:08:58AM -0800, Cyril Peponnet wrote:
>> Hi xfs community :),
>>=20
>> We have a glusterfs setup running under centos7.2. We are using
>> xfs as underlying storage for the bricks.  The volume is used to
>> store vm snapshots that=E2=80=99s gets created dynamically from the
>> hypervisors through glusterfs mount points.
>>=20
>> While this is working fine we have some issues from time to time
>> that make the mount points hang.
>>=20
>> We have the famous XFS: possible memory allocation deadlock in
>> kmem_alloc (mode:0x250) errors appearing from time to time on some
>> of our gluster nodes.
>=20
> And the complete output in dmesg is?
>=20
>> Let me know if you need more information about our systems (like
>> kernel version, underlying storage=E2=80=A6)
>=20
> =
http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when=
_reporting_a_problem.3F
>=20
> -Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

