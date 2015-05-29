Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BD16F7F50
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 01:32:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9D576304051
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 23:32:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0QgwbKAaoFPTxevN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 23:32:18 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 6D7AE2C72EA
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 06:32:17 +0000 (UTC)
Received: from localhost (dhcp12-136.nay.redhat.com [10.66.12.136] (may be
	forged))
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t4T6WFa8007255
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 02:32:16 -0400
Date: Fri, 29 May 2015 14:32:14 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: generic/247 triggers warnings occasionally
Message-ID: <20150529063214.GP3672@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="DrWhICOqskFTAXiy"
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--DrWhICOqskFTAXiy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I've seen generic/247 trigger the following warning occasionally, on
4.1.0-rc5 kernel. And I can reproduce it back on 4.0.0 kernel.

[60397.806729] run fstests generic/247 at 2015-05-29 13:19:55
[60400.197970] ------------[ cut here ]------------
[60400.199285] WARNING: CPU: 1 PID: 13161 at fs/xfs/xfs_file.c:726 xfs_file_dio_aio_write+0x176/0x2a8 [xfs]()
[60400.201783] Modules linked in: loop btrfs xor raid6_pq ppdev parport_pc i2c_piix4 parport i2c_core pcspkr serio_raw acpi_cpufreq xfs sd_mod ata_generic pata_acpi 8139too ata_piix 8139cp libata mii virtio_pci floppy virtio virtio_ring
[60400.207266] CPU: 1 PID: 13161 Comm: dd Not tainted 4.1.0-rc5 #61
[60400.208067] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[60400.208734]  0000000000000000 00000000726fc8c5 ffff880213f83cf8 ffffffff816d825d
[60400.209515]  0000000000000000 0000000000000000 ffff880213f83d38 ffffffff8107deaa
[60400.210260]  ffffea0007f56140 ffff880213f83e40 ffff8800d661f400 ffff8800d661f728
[60400.211207] Call Trace:
[60400.211423]  [<ffffffff816d825d>] dump_stack+0x45/0x57
[60400.211860]  [<ffffffff8107deaa>] warn_slowpath_common+0x8a/0xc0
[60400.212385]  [<ffffffff8107dfda>] warn_slowpath_null+0x1a/0x20
[60400.212909]  [<ffffffffa0145f01>] xfs_file_dio_aio_write+0x176/0x2a8 [xfs]
[60400.213507]  [<ffffffff81342978>] ? __clear_user+0x28/0x50
[60400.213981]  [<ffffffffa011291e>] xfs_file_write_iter+0x10e/0x120 [xfs]
[60400.214554]  [<ffffffff811fd721>] __vfs_write+0xd1/0x110
[60400.215004]  [<ffffffff811fddb9>] vfs_write+0xa9/0x1b0
[60400.215454]  [<ffffffff8102472c>] ? do_audit_syscall_entry+0x6c/0x70
[60400.215984]  [<ffffffff811fec65>] SyS_write+0x55/0xd0
[60400.216431]  [<ffffffff816df96e>] system_call_fastpath+0x12/0x71
[60400.216946] ---[ end trace c403c17f7a0c57a7 ]---
[60404.341600] XFS (sda5): Unmounting Filesystem
[60404.512757] XFS (sda5): Mounting V4 Filesystem
[60404.540546] XFS (sda5): Ending clean mount
[60404.609414] XFS (sda5): Unmounting Filesystem

fs/xfs/xfs_file.c:723
   723			ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
   724						pos >> PAGE_CACHE_SHIFT,
   725						end >> PAGE_CACHE_SHIFT);
   726			WARN_ON_ONCE(ret);
   727			ret = 0;

It can be reproduced by running generic/247 in loop(usually within 100
loops), without any special parameters/options.

	while ./check generic/247; do : ; done

Attachments are my xfstests config file and host info requested by
http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Thanks,
Eryu

--DrWhICOqskFTAXiy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=hostinfo

[root@dhcp-66-86-11 ~]# uname -a
Linux dhcp-66-86-11.rhts.eng.nay.redhat.com 4.1.0-rc5 #61 SMP Thu May 28 12:28:22 CST 2015 x86_64 x86_64 x86_64 GNU/Linux
[root@dhcp-66-86-11 ~]# rpm -q xfsprogs
xfsprogs-3.2.1-6.el7.x86_64
[root@dhcp-66-86-11 ~]# grep -c proc /proc/cpuinfo
4
[root@dhcp-66-86-11 ~]# cat /proc/meminfo
MemTotal:        7912932 kB
MemFree:         7547480 kB
MemAvailable:    7599440 kB
Buffers:             944 kB
Cached:           219292 kB
SwapCached:            0 kB
Active:           170072 kB
Inactive:         106352 kB
Active(anon):      56476 kB
Inactive(anon):     8384 kB
Active(file):     113596 kB
Inactive(file):    97968 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       8257532 kB
SwapFree:        8257532 kB
Dirty:             42556 kB
Writeback:             0 kB
AnonPages:         56020 kB
Mapped:            33008 kB
Shmem:              8552 kB
Slab:              42520 kB
SReclaimable:      18648 kB
SUnreclaim:        23872 kB
KernelStack:        2336 kB
PageTables:         3280 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    12213996 kB
Committed_AS:     260636 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       26336 kB
VmallocChunk:   34359623680 kB
HardwareCorrupted:     0 kB
AnonHugePages:     12288 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       69620 kB
DirectMap2M:     8318976 kB
[root@dhcp-66-86-11 ~]# cat /proc/mounts
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,seclabel,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs rw,seclabel,nosuid,size=3943408k,nr_inodes=985852,mode=755 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,seclabel,nosuid,nodev 0 0
devpts /dev/pts devpts rw,seclabel,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,seclabel,nosuid,nodev,mode=755 0 0
tmpfs /sys/fs/cgroup tmpfs rw,seclabel,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
pstore /sys/fs/pstore pstore rw,seclabel,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpu,cpuacct 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/net_cls cgroup rw,nosuid,nodev,noexec,relatime,net_cls 0 0
cgroup /sys/fs/cgroup/perf_event cgroup rw,nosuid,nodev,noexec,relatime,perf_event 0 0
cgroup /sys/fs/cgroup/hugetlb cgroup rw,nosuid,nodev,noexec,relatime,hugetlb 0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
/dev/sda3 / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
selinuxfs /sys/fs/selinux selinuxfs rw,relatime 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=34,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
debugfs /sys/kernel/debug debugfs rw,seclabel,relatime 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,seclabel,relatime 0 0
mqueue /dev/mqueue mqueue rw,seclabel,relatime 0 0
/dev/sda1 /boot xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
/dev/sda6 /mnt/testarea/scratch xfs rw,context=system_u:object_r:nfs_t:s0,relatime,attr2,inode64,noquota 0 0
/dev/sda5 /mnt/testarea/test xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
[root@dhcp-66-86-11 ~]# cat /proc/partitions
major minor  #blocks  name

   8        0  314572800 sda
   8        1     512000 sda1
   8        2    8257536 sda2
   8        3   52428800 sda3
   8        4          1 sda4
   8        5   15728640 sda5
   8        6   15728640 sda6
   8        7   15728640 sda7
   8        8   15728640 sda8
   8        9   15728640 sda9
   8       10   15728640 sda10
   8       11   15728640 sda11
   8       16  104857600 sdb
   8       17  104856576 sdb1
[root@dhcp-66-86-11 ~]# lvs
[root@dhcp-66-86-11 ~]#

--DrWhICOqskFTAXiy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="local.config"

TEST_DEV=/dev/sda5
TEST_DIR=/mnt/testarea/test				# mount point of TEST PARTITION
SCRATCH_MNT=/mnt/testarea/scratch			# mount point for SCRATCH PARTITION
SCRATCH_DEV=/dev/sda6

--DrWhICOqskFTAXiy
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--DrWhICOqskFTAXiy--
