Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BFC6829DF8
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 23:31:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D8468F8039
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 21:31:26 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id 1CTbcQK9Ta5OvL8b for
	<xfs@oss.sgi.com>; Mon, 27 May 2013 21:31:24 -0700 (PDT)
Date: Tue, 28 May 2013 00:31:20 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <861701102.7163229.1369715480182.JavaMail.root@redhat.com>
In-Reply-To: <20130527053608.GS29466@dastard>
References: <510292845.4997401.1369279175460.JavaMail.root@redhat.com>
	<1985929268.4997720.1369279277543.JavaMail.root@redhat.com>
	<20130523035115.GY24543@dastard>
	<986348673.5787542.1369385526612.JavaMail.root@redhat.com>
	<20130527053608.GS29466@dastard>
Subject: Re: 3.9.3: Oops running xfstests
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
To: Dave Chinner <david@fromorbit.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

Below is more information,

> What type of CPUs? That's why we ask for /proc/cpuinfo....
+ lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                8
On-line CPU(s) list:   0-7
Thread(s) per core:    1
Core(s) per socket:    2
Socket(s):             4
NUMA node(s):          4
Vendor ID:             AuthenticAMD
CPU family:            15
Model:                 65
Model name:            Dual-Core AMD Opteron(tm) Processor 8218
Stepping:              2
CPU MHz:               2599.855
BogoMIPS:              5199.28
Virtualization:        AMD-V
L1d cache:             64K
L1i cache:             64K
L2 cache:              1024K
NUMA node0 CPU(s):     0,4
NUMA node1 CPU(s):     1,5
NUMA node2 CPU(s):     2,6
NUMA node3 CPU(s):     3,7

or

+ lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                4
On-line CPU(s) list:   0-3
Thread(s) per core:    1
Core(s) per socket:    4
Socket(s):             1
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 42
Model name:            Intel(R) Xeon(R) CPU E31220 @ 3.10GHz
Stepping:              7
CPU MHz:               3092.721
BogoMIPS:              6185.44
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              8192K
NUMA node0 CPU(s):     0-3

> 
> > - contents of /proc/mounts: nothing special. Just Fedora-19 autopart
> 
> What are the contents?
+ cat /proc/mounts
rootfs / rootfs rw 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,seclabel,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs rw,seclabel,nosuid,size=8201464k,nr_inodes=2050366,mode=755 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
selinuxfs /sys/fs/selinux selinuxfs rw,relatime 0 0
tmpfs /dev/shm tmpfs rw,seclabel,nosuid,nodev 0 0
devpts /dev/pts devpts rw,seclabel,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,seclabel,nosuid,nodev,mode=755 0 0
tmpfs /sys/fs/cgroup tmpfs rw,seclabel,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpuacct,cpu 0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/net_cls cgroup rw,nosuid,nodev,noexec,relatime,net_cls 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/perf_event cgroup rw,nosuid,nodev,noexec,relatime,perf_event 0 0
/dev/mapper/rhel_ibm--ls41--02-root / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=32,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,seclabel,relatime 0 0
mqueue /dev/mqueue mqueue rw,seclabel,relatime 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
tmpfs /tmp tmpfs rw,seclabel 0 0
/dev/sda1 /boot xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
/dev/mapper/rhel_ibm--ls41--02-home /home xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0

or

+ cat /proc/mounts
rootfs / rootfs rw 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,seclabel,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs rw,seclabel,nosuid,size=4054696k,nr_inodes=1013674,mode=755 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
selinuxfs /sys/fs/selinux selinuxfs rw,relatime 0 0
tmpfs /dev/shm tmpfs rw,seclabel,nosuid,nodev 0 0
devpts /dev/pts devpts rw,seclabel,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,seclabel,nosuid,nodev,mode=755 0 0
tmpfs /sys/fs/cgroup tmpfs rw,seclabel,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpuacct,cpu 0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/net_cls cgroup rw,nosuid,nodev,noexec,relatime,net_cls 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/perf_event cgroup rw,nosuid,nodev,noexec,relatime,perf_event 0 0
/dev/mapper/rhel_storageqe--13-root / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=32,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
tmpfs /tmp tmpfs rw,seclabel 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
mqueue /dev/mqueue mqueue rw,seclabel,relatime 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,seclabel,relatime 0 0
/dev/mapper/rhel_storageqe--13-home /home xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
/dev/sda1 /boot xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
> 
> > - contents of /proc/partitions: nothing special. Just Fedora-19 autopart
> 
> Contents, please.
+ cat /proc/partitions
major minor  #blocks  name

   8       16   71687000 sdb
   8       17   71685120 sdb1
   8        0   71687000 sda
   8        1     512000 sda1
   8        2   71173120 sda2
 253        0    8257536 dm-0
 253        1   52428800 dm-1
 253        2   82169856 dm-2

or

+ cat /proc/partitions
major minor  #blocks  name

   8        0   71652960 sda
   8        1     512000 sda1
   8        2   71139328 sda2
 253        0    8142848 dm-0
 253        1   42328064 dm-1
 253        2   20664320 dm-2

> But what I see here is that there are partitions and LVM, and
> everything is using ext4. That's not useful to me. What I'm after is
> the output of pvdisplay, vgdisplay and lvdisplay. That's not very
> hard...
+ pvdisplay
  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               rhel_ibm-ls41-02
  PV Size               67.88 GiB / not usable 0   
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              17376
  Free PE               0
  Allocated PE          17376
  PV UUID               Y2xyqY-0Bcf-4NRi-9fmD-fYCm-XD8a-wtvwX6
   
  --- Physical volume ---
  PV Name               /dev/sdb1
  VG Name               rhel_ibm-ls41-02
  PV Size               68.36 GiB / not usable 0   
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              17501
  Free PE               0
  Allocated PE          17501
  PV UUID               RcT6SU-EP1j-Ig3S-pBD0-21p6-C3W1-ersGf9
   
+ echo

+ vgdisplay
  --- Volume group ---
  VG Name               rhel_ibm-ls41-02
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               3
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               136.24 GiB
  PE Size               4.00 MiB
  Total PE              34877
  Alloc PE / Size       34877 / 136.24 GiB
  Free  PE / Size       0 / 0   
  VG UUID               vciDnL-1VvD-Xxx1-caV8-06EH-cZLQ-f9X0vI
   
+ echo

+ lvdisplay
  --- Logical volume ---
  LV Path                /dev/rhel_ibm-ls41-02/swap
  LV Name                swap
  VG Name                rhel_ibm-ls41-02
  LV UUID                EgGvG9-XKJ0-sVBq-iQGQ-3jAc-rhbX-ZtCkPK
  LV Write Access        read/write
  LV Status              available
  # open                 2
  LV Size                7.88 GiB
  Current LE             2016
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
   
  --- Logical volume ---
  LV Path                /dev/rhel_ibm-ls41-02/home
  LV Name                home
  VG Name                rhel_ibm-ls41-02
  LV UUID                RFonzm-OXSb-rVKo-zZRi-YMri-fBC8-GdyRkq
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                78.36 GiB
  Current LE             20061
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2
   
  --- Logical volume ---
  LV Path                /dev/rhel_ibm-ls41-02/root
  LV Name                root
  VG Name                rhel_ibm-ls41-02
  LV UUID                AXEjh5-BakC-UwOu-AKjW-7JwD-dsoW-u57ffj
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                50.00 GiB
  Current LE             12800
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1

or

+ pvdisplay
  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               rhel_storageqe-13
  PV Size               67.84 GiB / not usable 4.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              17367
  Free PE               0
  Allocated PE          17367
  PV UUID               qJGFib-CawR-Dlhz-gXew-aqt4-erPL-LLtCeE
   
+ echo

+ vgdisplay
  --- Volume group ---
  VG Name               rhel_storageqe-13
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               3
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               67.84 GiB
  PE Size               4.00 MiB
  Total PE              17367
  Alloc PE / Size       17367 / 67.84 GiB
  Free  PE / Size       0 / 0   
  VG UUID               21QGVb-IqM8-DBto-Q1kl-23ql-y28i-ouwb0e
   
+ echo

+ lvdisplay
  --- Logical volume ---
  LV Path                /dev/rhel_storageqe-13/swap
  LV Name                swap
  VG Name                rhel_storageqe-13
  LV UUID                jBYJTC-BPds-lfo8-52rJ-MEXR-Chn5-tSChwg
  LV Write Access        read/write
  LV Status              available
  # open                 2
  LV Size                7.77 GiB
  Current LE             1988
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
   
  --- Logical volume ---
  LV Path                /dev/rhel_storageqe-13/home
  LV Name                home
  VG Name                rhel_storageqe-13
  LV UUID                3lJRDR-rnNO-7BBf-3Iyy-32ho-Sbnb-qP3Ut1
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                19.71 GiB
  Current LE             5045
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2
   
  --- Logical volume ---
  LV Path                /dev/rhel_storageqe-13/root
  LV Name                root
  VG Name                rhel_storageqe-13
  LV UUID                I2xPqj-Ew0z-NePE-4d7w-nfev-5DMo-fRuFUL
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                40.37 GiB
  Current LE             10334
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1

I never have had a chance to reproduce this just by running xfstests alone,
so it looks like there needs to be some fixture of the loads here. I'll try
to see if I can craft out a simpler reproducer...

CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
