Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BC1447CA2
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 23:29:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 90D158F8033
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 21:29:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id a7LJz7ToBxJRcD63 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 13 Jun 2016 21:29:14 -0700 (PDT)
Date: Mon, 13 Jun 2016 23:29:12 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: Internal error xfs_trans_cancel
Message-ID: <20160614042912.k4xifnftaik4rnar@treble>
References: <ab487269-a423-e3dc-6f59-3dda004960c3@monom.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ab487269-a423-e3dc-6f59-3dda004960c3@monom.org>
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
To: Daniel Wagner <wagi@monom.org>
Cc: linux-fsdevel@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Jun 01, 2016 at 07:52:31AM +0200, Daniel Wagner wrote:
> Hi,
> 
> I got the error message below while compiling a kernel 
> on that system. I can't really say if I did something
> which made the file system unhappy before the crash.
> 
> 
> [Jun 1 07:41] XFS (sde1): Internal error xfs_trans_cancel at line 984 of file fs/xfs/xfs_trans.c.  Caller xfs_rename+0x453/0x960 [xfs]
> [  +0.000095] CPU: 22 PID: 8640 Comm: gcc Not tainted 4.7.0-rc1 #16
> [  +0.000035] Hardware name: Dell Inc. PowerEdge R820/066N7P, BIOS 2.0.20 01/16/2014
> [  +0.000048]  0000000000000286 00000000c8be6bc3 ffff885fa9473cb0 ffffffff813d146e
> [  +0.000056]  ffff885fa9ac5ed0 0000000000000001 ffff885fa9473cc8 ffffffffa0213cdc
> [  +0.000053]  ffffffffa02257b3 ffff885fa9473cf0 ffffffffa022eb36 ffff883faa502d00
> [  +0.000053] Call Trace:
> [  +0.000028]  [<ffffffff813d146e>] dump_stack+0x63/0x85
> [  +0.000069]  [<ffffffffa0213cdc>] xfs_error_report+0x3c/0x40 [xfs]
> [  +0.000065]  [<ffffffffa02257b3>] ? xfs_rename+0x453/0x960 [xfs]
> [  +0.000064]  [<ffffffffa022eb36>] xfs_trans_cancel+0xb6/0xe0 [xfs]
> [  +0.000065]  [<ffffffffa02257b3>] xfs_rename+0x453/0x960 [xfs]
> [  +0.000062]  [<ffffffffa021fa63>] xfs_vn_rename+0xb3/0xf0 [xfs]
> [  +0.000040]  [<ffffffff8124f92c>] vfs_rename+0x58c/0x8d0
> [  +0.000032]  [<ffffffff81253fb1>] SyS_rename+0x371/0x390
> [  +0.000036]  [<ffffffff817d2032>] entry_SYSCALL_64_fastpath+0x1a/0xa4
> [  +0.000040] XFS (sde1): xfs_do_force_shutdown(0x8) called from line 985 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffffa022eb4f
> [  +0.027680] XFS (sde1): Corruption of in-memory data detected.  Shutting down filesystem
> [  +0.000057] XFS (sde1): Please umount the filesystem and rectify the problem(s)
> [Jun 1 07:42] XFS (sde1): xfs_log_force: error -5 returned.
> [ +30.081016] XFS (sde1): xfs_log_force: error -5 returned.

I saw this today.  I was just building/installing kernels, rebooting,
running kexec, running perf.


[ 1359.005573] ------------[ cut here ]------------
[ 1359.010191] WARNING: CPU: 4 PID: 6031 at fs/inode.c:280 drop_nlink+0x3e/0x50
[ 1359.017231] Modules linked in: rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm intel_powerclamp coretemp kvm_intel kvm nfsd ipmi_ssif ipmi_devintf ipmi_si iTCO_wdt irqbypass iTCO_vendor_support ipmi_msghandler i7core_edac shpchp sg edac_core pcspkr wmi lpc_ich dcdbas mfd_core acpi_power_meter auth_rpcgss acpi_cpufreq nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod sr_mod cdrom iw_cxgb3 ib_core mgag200 ata_generic pata_acpi i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm mptsas scsi_transport_sas ata_piix mptscsih libata cxgb3 crc32c_intel i2c_core serio_raw mptbase bnx2 fjes mdio dm_mirror dm_region_hash dm_log dm_mod
[ 1359.088447] CPU: 4 PID: 6031 Comm: depmod Tainted: G          I     4.7.0-rc3+ #4
[ 1359.095911] Hardware name: Dell Inc. PowerEdge R410/0N051F, BIOS 1.11.0 07/20/2012
[ 1359.103461]  0000000000000286 00000000a0bc39d9 ffff8802143dfd18 ffffffff8134bb7f
[ 1359.110871]  0000000000000000 0000000000000000 ffff8802143dfd58 ffffffff8108b671
[ 1359.118280]  00000118575f7d13 ffff880222c9a6e8 ffff8803ec3874d8 ffff880428827000
[ 1359.125693] Call Trace:
[ 1359.128133]  [<ffffffff8134bb7f>] dump_stack+0x63/0x84
[ 1359.133259]  [<ffffffff8108b671>] __warn+0xd1/0xf0
[ 1359.138037]  [<ffffffff8108b7ad>] warn_slowpath_null+0x1d/0x20
[ 1359.143855]  [<ffffffff81238fde>] drop_nlink+0x3e/0x50
[ 1359.149017]  [<ffffffffa0327148>] xfs_droplink+0x28/0x60 [xfs]
[ 1359.154864]  [<ffffffffa0328c81>] xfs_remove+0x231/0x350 [xfs]
[ 1359.160682]  [<ffffffff812cd70a>] ? security_inode_permission+0x3a/0x60
[ 1359.167309]  [<ffffffffa03235e8>] xfs_vn_unlink+0x58/0xa0 [xfs]
[ 1359.173213]  [<ffffffff812d7e33>] ? selinux_inode_unlink+0x13/0x20
[ 1359.179379]  [<ffffffff8122b29a>] vfs_unlink+0xda/0x190
[ 1359.184590]  [<ffffffff8122df53>] do_unlinkat+0x263/0x2a0
[ 1359.189974]  [<ffffffff8122ea1b>] SyS_unlinkat+0x1b/0x30
[ 1359.195272]  [<ffffffff81003b12>] do_syscall_64+0x62/0x110
[ 1359.200743]  [<ffffffff816d7961>] entry_SYSCALL64_slow_path+0x25/0x25
[ 1359.207178] ---[ end trace 0d397afdaff9f340 ]---
[ 1359.211830] XFS (dm-0): Internal error xfs_trans_cancel at line 984 of file fs/xfs/xfs_trans.c.  Caller xfs_remove+0x1d1/0x350 [xfs]
[ 1359.223723] CPU: 4 PID: 6031 Comm: depmod Tainted: G        W I     4.7.0-rc3+ #4
[ 1359.231185] Hardware name: Dell Inc. PowerEdge R410/0N051F, BIOS 1.11.0 07/20/2012
[ 1359.238736]  0000000000000286 00000000a0bc39d9 ffff8802143dfd60 ffffffff8134bb7f
[ 1359.246147]  ffff8803ec3874d8 0000000000000001 ffff8802143dfd78 ffffffffa03176bb
[ 1359.253559]  ffffffffa0328c21 ffff8802143dfda0 ffffffffa03327a6 ffff880222e7e180
[ 1359.260969] Call Trace:
[ 1359.263407]  [<ffffffff8134bb7f>] dump_stack+0x63/0x84
[ 1359.268560]  [<ffffffffa03176bb>] xfs_error_report+0x3b/0x40 [xfs]
[ 1359.274755]  [<ffffffffa0328c21>] ? xfs_remove+0x1d1/0x350 [xfs]
[ 1359.280778]  [<ffffffffa03327a6>] xfs_trans_cancel+0xb6/0xe0 [xfs]
[ 1359.286973]  [<ffffffffa0328c21>] xfs_remove+0x1d1/0x350 [xfs]
[ 1359.292820]  [<ffffffffa03235e8>] xfs_vn_unlink+0x58/0xa0 [xfs]
[ 1359.298724]  [<ffffffff812d7e33>] ? selinux_inode_unlink+0x13/0x20
[ 1359.304890]  [<ffffffff8122b29a>] vfs_unlink+0xda/0x190
[ 1359.310100]  [<ffffffff8122df53>] do_unlinkat+0x263/0x2a0
[ 1359.315486]  [<ffffffff8122ea1b>] SyS_unlinkat+0x1b/0x30
[ 1359.320784]  [<ffffffff81003b12>] do_syscall_64+0x62/0x110
[ 1359.326256]  [<ffffffff816d7961>] entry_SYSCALL64_slow_path+0x25/0x25
[ 1359.332692] XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 985 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffffa03327bf
[ 1360.461638] XFS (dm-0): Corruption of in-memory data detected.  Shutting down filesystem
[ 1360.469729] XFS (dm-0): Please umount the filesystem and rectify the problem(s)
[ 1360.595843] XFS (dm-0): xfs_log_force: error -5 returned.


# uname -a
Linux dell-per410-01.khw.lab.eng.bos.redhat.com 4.7.0-rc3+ #5 SMP Mon Jun 13 23:35:14 EDT 2016 x86_64 x86_64 x86_64 GNU/Linux

# xfs_repair -V
xfs_repair version 3.2.2

# cat /proc/cpuinfo | grep CPU | wc -l
16

# cat /proc/meminfo
MemTotal:       16415296 kB
MemFree:        15723380 kB
MemAvailable:   15796192 kB
Buffers:             964 kB
Cached:           350700 kB
SwapCached:            0 kB
Active:           248992 kB
Inactive:         223000 kB
Active(anon):     121176 kB
Inactive(anon):     8116 kB
Active(file):     127816 kB
Inactive(file):   214884 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       8257532 kB
SwapFree:        8257532 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:        120340 kB
Mapped:            40136 kB
Shmem:              8964 kB
Slab:              80092 kB
SReclaimable:      25208 kB
SUnreclaim:        54884 kB
KernelStack:        5872 kB
PageTables:         5468 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    16465180 kB
Committed_AS:     355084 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
HardwareCorrupted:     0 kB
AnonHugePages:     51200 kB
CmaTotal:              0 kB
CmaFree:               0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      177572 kB
DirectMap2M:    16586752 kB

# cat /proc/mounts
sysfs /sys sysfs rw,seclabel,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs rw,seclabel,nosuid,size=8161852k,nr_inodes=2040463,mode=755 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,seclabel,nosuid,nodev 0 0
devpts /dev/pts devpts rw,seclabel,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,seclabel,nosuid,nodev,mode=755 0 0
tmpfs /sys/fs/cgroup tmpfs ro,seclabel,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
pstore /sys/fs/pstore pstore rw,seclabel,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpu,cpuacct 0 0
cgroup /sys/fs/cgroup/net_cls cgroup rw,nosuid,nodev,noexec,relatime,net_cls 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/pids cgroup rw,nosuid,nodev,noexec,relatime,pids 0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/perf_event cgroup rw,nosuid,nodev,noexec,relatime,perf_event 0 0
cgroup /sys/fs/cgroup/hugetlb cgroup rw,nosuid,nodev,noexec,relatime,hugetlb 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
/dev/mapper/rhel_dell--per410--01-root / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
selinuxfs /sys/fs/selinux selinuxfs rw,relatime 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=28,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
debugfs /sys/kernel/debug debugfs rw,seclabel,relatime 0 0
mqueue /dev/mqueue mqueue rw,seclabel,relatime 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,seclabel,relatime 0 0
sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
/dev/mapper/rhel_dell--per410--01-home /home xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0
/dev/sda1 /boot xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
tmpfs /run/user/0 tmpfs rw,seclabel,nosuid,nodev,relatime,size=1641532k,mode=700 0 0
tracefs /sys/kernel/debug/tracing tracefs rw,relatime 0 0

# cat /proc/partitions
major minor  #blocks  name

  11        0    1048575 sr0
   8       16  143374740 sdb
   8       17  143373312 sdb1
   8        0  143374740 sda
   8        1     512000 sda1
   8        2  142861312 sda2
 253        0   52428800 dm-0
 253        1    8257536 dm-1
 253        2  225480704 dm-2

# pvdisplay
  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               rhel_dell-per410-01
  PV Size               136.24 GiB / not usable 0   
  Allocatable           yes 
  PE Size               4.00 MiB
  Total PE              34878
  Free PE               16
  Allocated PE          34862
  PV UUID               cTa6X3-dz3E-HmdE-bY1J-XEoo-USwY-dl2lRm
   
  --- Physical volume ---
  PV Name               /dev/sdb1
  VG Name               rhel_dell-per410-01
  PV Size               136.73 GiB / not usable 0   
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              35003
  Free PE               0
  Allocated PE          35003
  PV UUID               ZzXTQx-9CN1-TaMu-UfrN-Usuz-aFvl-A6PKJS
   
# lvdisplay
  --- Logical volume ---
  LV Path                /dev/rhel_dell-per410-01/swap
  LV Name                swap
  VG Name                rhel_dell-per410-01
  LV UUID                E6Y5qQ-URKt-9wc6-3fRc-2wbZ-ev2n-IliB7s
  LV Write Access        read/write
  LV Creation host, time dell-per410-01.khw.lab.eng.bos.redhat.com, 2016-06-13 12:55:31 -0400
  LV Status              available
  # open                 2
  LV Size                7.88 GiB
  Current LE             2016
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:1
   
  --- Logical volume ---
  LV Path                /dev/rhel_dell-per410-01/home
  LV Name                home
  VG Name                rhel_dell-per410-01
  LV UUID                Zq6BIP-0Yem-3NAp-gJ5K-2c6Q-Zc67-mdp51k
  LV Write Access        read/write
  LV Creation host, time dell-per410-01.khw.lab.eng.bos.redhat.com, 2016-06-13 12:55:31 -0400
  LV Status              available
  # open                 1
  LV Size                215.04 GiB
  Current LE             55049
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:2
   
  --- Logical volume ---
  LV Path                /dev/rhel_dell-per410-01/root
  LV Name                root
  VG Name                rhel_dell-per410-01
  LV UUID                T4rKVg-cuiW-jc6c-grNW-DJQQ-mCt8-N8Ig5l
  LV Write Access        read/write
  LV Creation host, time dell-per410-01.khw.lab.eng.bos.redhat.com, 2016-06-13 12:55:35 -0400
  LV Status              available
  # open                 1
  LV Size                50.00 GiB
  Current LE             12800
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:0
   
# hdparm -i /dev/sda

/dev/sda:
SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 28 00 00 00 00 20 00 00 00 00 00 00 85 55 06 01 00 00 00 00 00 00 00 00 00
 HDIO_GET_IDENTITY failed: Invalid argument
# hdparm -i /dev/sdb

/dev/sdb:
SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 28 00 00 00 00 20 00 00 00 00 00 00 85 55 06 01 00 00 00 00 00 00 00 00 00
 HDIO_GET_IDENTITY failed: Invalid argument

(I don't know anything about the disks, but I can try to find out if you
need it.)

# xfs_info /dev/mapper/rhel_dell--per410--01-root
meta-data=/dev/mapper/rhel_dell--per410--01-root isize=256    agcount=4, agsize=3276800 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=13107200, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=6400, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

-- 
Josh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
