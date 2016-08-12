Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 68DE67CA0
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 09:04:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 39B76304043
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 07:04:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OCdmzLG1RJZgF9o4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Aug 2016 07:04:17 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 53B2E81110
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 14:04:16 +0000 (UTC)
Received: from localhost (dhcp-13-153.nay.redhat.com [10.66.13.153])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7CE4F1x013442
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 10:04:15 -0400
Date: Fri, 12 Aug 2016 22:04:14 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: XFS: Assertion failed: bp->b_flags & XBF_ASYNC, file:
	fs/xfs/xfs_buf.c, line: 118 on 4.8-rc1 kernel
Message-ID: <20160812140414.GV27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi,

I hit oops while building kernel on XFS, 4.8-rc1 kernel, hit twice in
six kernel builds. I'm not sure if it's a regression since 4.7 kernel
yet, will do more testings.

The host is a x86_64 kvm guest running RHEL7.2 with upstream 4.8-rc1
kernel.  Detailed console log and XFS info and memory & cpu info please
see the end of this mail.

Actually I was bisecting an issue caused by generic/224, I saw the
following message flooding dmesg.

...
[   92.394306] XFS (sda6): page discard on page ffffea000204c9c0, inode 0x2e4, offset 84959232.
[   92.401061] XFS (sda6): page discard on page ffffea000204ca00, inode 0x2e4, offset 84963328.
[   92.406592] XFS (sda6): page discard on page ffffea000204ca40, inode 0x2e4, offset 84967424.
[   92.409813] XFS (sda6): page discard on page ffffea000204ca80, inode 0x2e4, offset 84971520.
...

I'll send another email once I get bisect result.

Thanks,
Eryu

Host information:
[root@dhcp-66-86-11 ~]# xfs_info /dev/sdb1
meta-data=/dev/sdb1              isize=256    agcount=4, agsize=6553536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=26214144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=12799, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@dhcp-66-86-11 ~]# df -h /dev/sdb1
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb1       100G   47G   54G  47% /root/workspace
[root@dhcp-66-86-11 ~]# free -m
              total        used        free      shared  buff/cache   available
Mem:           7982         111        7660           8         211        7594
Swap:          8063           0        8063
[root@dhcp-66-86-11 ~]# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                4
On-line CPU(s) list:   0-3
Thread(s) per core:    1
Core(s) per socket:    1
Socket(s):             4
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 13
Model name:            QEMU Virtual CPU version (cpu64-rhel6)
Stepping:              3
CPU MHz:               2892.421
BogoMIPS:              5785.49
Hypervisor vendor:     KVM
Virtualization type:   full
L1d cache:             32K
L1i cache:             32K
L2 cache:              4096K
NUMA node0 CPU(s):     0-3

Console log:
[  505.226162] XFS: Assertion failed: bp->b_flags & XBF_ASYNC, file: fs/xfs/xfs_buf.c, line: 118
[  505.226796] ------------[ cut here ]------------
[  505.227010] kernel BUG at fs/xfs/xfs_message.c:113!
[  505.227010] invalid opcode: 0000 [#1] SMP
[  505.227010] Modules linked in: btrfs xor raid6_pq ppdev i2c_piix4 parport_pc sg parport i2c_core virtio_balloon pcspkr acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod ata_generic pata_acpi virtio_scsi ata_piix libata serio_raw virtio_pci 8139too virtio_ring 8139cp virtio mii floppy
[  505.227010] CPU: 3 PID: 57 Comm: kswapd0 Not tainted 4.8.0-rc1 #17
[  505.227010] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[  505.234430] task: ffff880215cde680 task.stack: ffff880210ad0000
[  505.234430] RIP: 0010:[<ffffffffa013c9a2>]  [<ffffffffa013c9a2>] assfail+0x22/0x30 [xfs]
[  505.234430] RSP: 0018:ffff880210ad3a00  EFLAGS: 00010246
[  505.234430] RAX: 0000000000000000 RBX: ffff88011ec02ad8 RCX: 0000000000000000
[  505.234430] RDX: ffff880210ad3908 RSI: 000000000000000a RDI: ffffffffa016eb95
[  505.234430] RBP: ffff880210ad3a00 R08: 0000000000000000 R09: 0000000000000000
[  505.234430] R10: 000000000000000a R11: f000000000000000 R12: ffff88011ec02a80
[  505.234430] R13: ffff8802107c1998 R14: ffff8802107c1900 R15: 0000000000000000
[  505.234430] FS:  0000000000000000(0000) GS:ffff88021fd80000(0000) knlGS:0000000000000000
[  505.234430] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  505.234430] CR2: 0000000001137000 CR3: 00000000447a7000 CR4: 00000000000006e0
[  505.234430] Stack:
[  505.234430]  ffff880210ad3a38 ffffffffa0123332 ffff880201026c00 ffff880201026d24
[  505.234430]  ffff88011ec02a80 ffff8802107c1900 0000000000000000 ffff880210ad3a88
[  505.234430]  ffffffffa012e05d 0000000008405eae ffff88011ec02a80 00000000ec38fc98
[  505.234430] Call Trace:
[  505.234430]  [<ffffffffa0123332>] xfs_buf_rele+0x2f2/0x380 [xfs]
[  505.234430]  [<ffffffffa012e05d>] xfs_reclaim_inode+0x38d/0x3a0 [xfs]
[  505.234430]  [<ffffffffa012e293>] xfs_reclaim_inodes_ag+0x223/0x360 [xfs]
[  505.234430]  [<ffffffff810b5638>] ? try_to_wake_up+0x58/0x390
[  505.234430]  [<ffffffff810b5985>] ? wake_up_process+0x15/0x20
[  505.234430]  [<ffffffffa012e4b3>] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
[  505.234430]  [<ffffffffa013f709>] xfs_fs_free_cached_objects+0x19/0x20 [xfs]
[  505.234430]  [<ffffffff81225f81>] super_cache_scan+0x181/0x190
[  505.234430]  [<ffffffff811a8837>] shrink_slab+0x237/0x400
[  505.234430]  [<ffffffff811ad4c3>] shrink_node+0x303/0x310
[  505.234430]  [<ffffffff811ae2d2>] kswapd+0x302/0x6f0
[  505.234430]  [<ffffffff811adfd0>] ? mem_cgroup_shrink_node+0x180/0x180
[  505.234430]  [<ffffffff810aa198>] kthread+0xd8/0xf0
[  505.234430]  [<ffffffff816d797f>] ret_from_fork+0x1f/0x40
[  505.234430]  [<ffffffff810aa0c0>] ? kthread_park+0x60/0x60
[  505.234430] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 c7 c6 30 a9 17 a0 48 89 fa 31 c0 48 89 e5 31 ff e8 ae f8 ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  505.234430] RIP  [<ffffffffa013c9a2>] assfail+0x22/0x30 [xfs]
[  505.234430]  RSP <ffff880210ad3a00>
[  505.251864] ---[ end trace d6c2d984ee03a700 ]---
[  505.252246] Kernel panic - not syncing: Fatal exception
[  505.252662] Kernel Offset: disabled
[  505.252929] ---[ end Kernel panic - not syncing: Fatal exception

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
