Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Mar 2008 03:45:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2IAjZhq031162
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 03:45:36 -0700
Received: from smtp-tls.univ-nantes.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5780C6B58C2
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 03:46:05 -0700 (PDT)
Received: from smtp-tls.univ-nantes.fr (Smtp-Tls1.univ-nantes.fr [193.52.101.145]) by cuda.sgi.com with ESMTP id qYI9A7DeiWbH9H2W for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 03:46:05 -0700 (PDT)
Message-ID: <47DF9D6A.3000700@univ-nantes.fr>
Date: Tue, 18 Mar 2008 11:46:02 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: xfs corruption / memory problem or evms or device mapper involved
 ??
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, dm-devel@redhat.com
Cc: evms-devel@lists.sourceforge.net, Arnaud ABELARD <arnaud.abelard@univ-nantes.fr>

Hello.
Yesterday I had to expand an xfs volume.  The machine use a 
2.6.18-4-vserver amd64 kernel.

The process never finished. I hard to hard reboot the machine, leaving 
the xfs filesystem in a bad state, as far as I can see (2nd part of the 
mail)

Here are the logs.


I have this since yesterday :

Here are the failed expand operation with evms :

First, add of a scsi disk on SAN

Mar 17 15:33:20 speyburn kernel:   Vendor: IFT       Model: 
ER2510FS-6RH      Rev: 342R
Mar 17 15:33:20 speyburn kernel:   Type:   
Direct-Access                      ANSI SCSI revision: 03
Mar 17 15:33:20 speyburn kernel: SCSI device sdh: 215040000 512-byte 
hdwr sectors (110100 MB)
Mar 17 15:33:20 speyburn kernel: sdh: Write Protect is off
Mar 17 15:33:20 speyburn kernel: sdh: Mode Sense: 8f 00 00 08
Mar 17 15:33:20 speyburn kernel: SCSI device sdh: drive cache: write back
Mar 17 15:33:20 speyburn kernel: SCSI device sdh: 215040000 512-byte 
hdwr sectors (110100 MB)
Mar 17 15:33:20 speyburn kernel: sdh: Write Protect is off
Mar 17 15:33:20 speyburn kernel: sdh: Mode Sense: 8f 00 00 08
Mar 17 15:33:20 speyburn kernel: SCSI device sdh: drive cache: write back
Mar 17 15:33:20 speyburn kernel:  sdh: unknown partition table
Mar 17 15:33:20 speyburn kernel: sd 0:0:1:6: Attached scsi disk sdh
Mar 17 15:33:20 speyburn kernel: sd 0:0:1:6: Attached scsi generic sg13 
type 0
----
Then evms expand operation - The root of the problem.

Mar 17 15:45:23 speyburn kernel: Bad page state in process 'evmsn'
Mar 17 15:45:23 speyburn kernel:  [<ffffffff880de1d9>] 
:dm_mod:dm_suspend+0xe1/0x239
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8027fbbb>] 
default_wake_function+0x0/0xe
Mar 17 15:45:23 speyburn kernel:  [<ffffffff880e0c33>] 
:dm_mod:dev_suspend+0xda/0x16f
Mar 17 15:45:23 speyburn kernel:  [<ffffffff880e152d>] 
:dm_mod:ctl_ioctl+0x213/0x25e
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8028bb88>] 
signal_wake_up+0x1e/0x2d
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8023f837>] do_ioctl+0x55/0x6b
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8022ed20>] 
vfs_ioctl+0x364/0x38b
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8029d63d>] 
sys_futex+0x102/0x124
Mar 17 15:45:23 speyburn kernel:  [<ffffffff80249f22>] sys_ioctl+0x59/0x78
Mar 17 15:45:23 speyburn kernel:
Mar 17 15:45:23 speyburn kernel: RIP: 0010:[<ffffffff8020c207>]  
[<ffffffff8020c207>] put_page+0x13/0x2e
Mar 17 15:45:23 speyburn kernel: RSP: 0000:ffff81027fccd970  EFLAGS: 
00010246
Mar 17 15:45:23 speyburn kernel: RAX: 0000000000000000 RBX: 
0000000000000001 RCX: ffff810128f10a20
Mar 17 15:45:23 speyburn kernel: RDX: ffff810128f10b40 RSI: 
ffff810320954970 RDI: ffff81032f9896e0
Mar 17 15:45:23 speyburn kernel: RBP: ffff810128f109c0 R08: 
004740e900000c82 R09: ffff810128f109c0
Mar 17 15:45:23 speyburn kernel: R10: ffffffff88195b04 R11: 
0000000000000098 R12: ffff810324ad1024
Mar 17 15:45:23 speyburn kernel: R13: ffff810324ad1028 R14: 
004740e900000e14 R15: 0000000000000000
Mar 17 15:45:23 speyburn kernel: FS:  0000000000000000(0000) 
GS:ffffffff80530000(0063) knlGS:00000000f7dafaa0
Mar 17 15:45:23 speyburn kernel: CS:  0010 DS: 002b ES: 002b CR0: 
000000008005003b
Mar 17 15:45:23 speyburn kernel: CR2: 00000000f7e5aca0 CR3: 
00000001eac8e000 CR4: 00000000000006e0
----
Then processes on the  machine seems affected by 'bad pages' ?


Mar 17 15:45:23 speyburn kernel: Process imapd (pid: 10575[#49152], 
threadinfo ffff81027fccc000, task ffff8103172177c0)
Mar 17 15:45:23 speyburn kernel: Stack:  ffffffff8819391b 
ffff810163a762b0 ffff810324ad1000 ffff810324ad1024
Mar 17 15:45:23 speyburn kernel: CPU 0
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8818c344>] 
:xfs:xfs_lookup+0x6c/0x7d
Mar 17 15:45:23 speyburn kernel: RIP  [<ffffffff8020c207>] 
put_page+0x13/0x2e
Mar 17 15:45:23 speyburn kernel: R13: ffff810324ad1028 R14: 
004740e900000e14 R15: 0000000000000000
Mar 17 15:45:23 speyburn kernel:  [<ffffffff80220a18>] __up_read+0x13/0x8a
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8818eeb8>] 
:xfs:xfs_create+0x1f0/0x5dd
Mar 17 15:45:23 speyburn kernel:  RSP <ffff8101d7021970>
Mar 17 15:45:23 speyburn kernel:  ----------- [cut here ] --------- 
[please bite here ] ---------
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8819165d>] 
:xfs:kmem_zone_zalloc+0x1e/0x2f
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8025dc22>] ia32_sysret+0x0/0xa
Mar 17 15:45:23 speyburn kernel:
Mar 17 15:45:23 speyburn kernel:
Mar 17 15:45:23 speyburn kernel: Call Trace:
Mar 17 15:45:23 speyburn kernel:  [<ffffffff80237f6c>] 
may_delete+0x42/0x12b
Mar 17 15:45:23 speyburn kernel: RDX: ffff810128f10b40 RSI: 
ffff810320954970 RDI: ffff81032f9896e0
Mar 17 15:45:23 speyburn kernel: Process imapd (pid: 7935[#49152], 
threadinfo ffff810231714000, task ffff8102ae037880)
Mar 17 15:45:23 speyburn kernel: Stack:  ffffffff8819391b 
ffff810163a762b0 ffff810324ad1000 ffff810324ad1024
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8022ba1e>] 
mntput_no_expire+0x19/0x8b
Mar 17 15:45:23 speyburn kernel: Pid: 10600, comm: imapd Tainted: G    B 
2.6.18-4-vserver-amd64 #1
Mar 17 15:45:23 speyburn kernel: Call Trace:
Mar 17 15:45:23 speyburn kernel:  [<ffffffff88197cba>] 
:xfs:xfs_vn_permission+0x14/0x18
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8020cf8a>] 
permission+0xf0/0x155
Mar 17 15:45:23 speyburn kernel: CPU 0
Mar 17 15:45:23 speyburn kernel:  [<ffffffff88197cba>] 
:xfs:xfs_vn_permission+0x14/0x18
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8020cf8a>] 
permission+0xf0/0x155
Mar 17 15:45:23 speyburn kernel:
Mar 17 15:45:23 speyburn kernel: CPU 0
Mar 17 15:45:23 speyburn kernel:  [<ffffffff88186d70>] 
:xfs:xfs_trans_reserve+0xea/0x1cb
Mar 17 15:45:23 speyburn kernel:  RSP <ffff81013917f970>
Mar 17 15:45:23 speyburn kernel:
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8027601f>] 
sys32_lstat64+0x20/0x29
Mar 17 15:45:23 speyburn kernel: <0>Bad page state in process 'imapd'
Mar 17 15:45:23 speyburn kernel: page:ffff81032f9e0498 
flags:0x020000000000020c mapping:ffff810321d2fd20 mapcount:0 count:0
Mar 17 15:45:23 speyburn kernel: Trying to fix it up, but a reboot is 
needed
Mar 17 15:45:23 speyburn kernel: Backtrace:
Mar 17 15:45:23 speyburn kernel:
Mar 17 15:45:23 speyburn kernel: Call Trace:
Mar 17 15:45:23 speyburn kernel:  [<ffffffff802b1830>] bad_page+0x4e/0x78
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8020b2b1>] 
free_hot_cold_page+0x73/0xff
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8819391b>] 
:xfs:xfs_buf_free+0x99/0xdd
Mar 17 15:45:23 speyburn kernel:  [<ffffffff88187a6c>] 
:xfs:xfs_trans_push_ail+0xaf/0x237
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8817e264>] 
:xfs:xfs_log_reserve+0x443/0x6a6
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8819165d>] 
:xfs:kmem_zone_zalloc+0x1e/0x2f
Mar 17 15:45:23 speyburn kernel:
Mar 17 15:45:23 speyburn kernel: Bad page state in process 'imapd'
Mar 17 15:45:23 speyburn kernel: Trying to fix it up, but a reboot is 
needed
Mar 17 15:45:23 speyburn kernel:  [<ffffffff88197cba>] 
:xfs:xfs_vn_permission+0x14/0x18
Mar 17 15:45:23 speyburn kernel: Unable to handle kernel NULL pointer 
dereference at 0000000000000000 RIP:
Mar 17 15:45:23 speyburn kernel:  [<ffffffff881941d2>] 
:xfs:_xfs_buf_find+0x93/0x1f2
Mar 17 15:45:23 speyburn kernel: PGD 1c9561067 PUD 2ba02f067 PMD 0
Mar 17 15:45:23 speyburn kernel: Oops: 0000 [131] SMP
Mar 17 15:45:23 speyburn kernel: CPU 0
Mar 17 15:45:23 speyburn kernel: Modules linked in: iptable_filter 
ip_tables x_tables ipv6 ext2 mbcache dm_snapshot dm_mirror tsdev psmouse 
shpchp serio_raw pci_hotplug pcspkr evdev sg st xfs raid456 xor raid10 
raid1 raid0 linear md_mod dm_mod ch sd_mod mptsas mptscsih mptbase 
scsi_transport_sas ehci_hcd bnx2 qla2xxx firmware_class uhci_hcd 
scsi_transport_fc scsi_mod thermal processor fan
Mar 17 15:45:23 speyburn kernel: Pid: 10598, comm: imapd Tainted: G    B 
2.6.18-4-vserver-amd64 #1
Mar 17 15:45:23 speyburn kernel: RIP: 0010:[<ffffffff881941d2>]  
[<ffffffff881941d2>] :xfs:_xfs_buf_find+0x93/0x1f2
Mar 17 15:45:23 speyburn kernel: RSP: 0000:ffff81028f26b918  EFLAGS: 
00010287
Mar 17 15:45:23 speyburn kernel: RAX: ffffffffffffffa0 RBX: 
ffffffffffffffa0 RCX: ffff810128f10a20
Mar 17 15:45:23 speyburn kernel: RDX: 0000000000000010 RSI: 
0000000000000000 RDI: ffff810320954970
Mar 17 15:45:23 speyburn kernel: RBP: ffff810320954960 R08: 
0000000000000000 R09: ffffffff88194e39
Mar 17 15:45:23 speyburn kernel: R10: 000000003e21e352 R11: 
ffff810001036640 R12: 0000000000000000
Mar 17 15:45:23 speyburn kernel: R13: 0000000000002000 R14: 
ffff8103243d7340 R15: 00000000d1bd5000
Mar 17 15:45:23 speyburn kernel: FS:  0000000000000000(0000) 
GS:ffffffff80530000(0063) knlGS:00000000f7e0eaa0
Mar 17 15:45:23 speyburn kernel: CS:  0010 DS: 002b ES: 002b CR0: 
000000008005003b
Mar 17 15:45:23 speyburn kernel:  [<ffffffff80209112>] 
__link_path_walk+0x1a2/0xf88
Mar 17 15:45:23 speyburn kernel: <0>Bad page state in process 'imapd'
Mar 17 15:45:23 speyburn kernel: page:ffff81032874f928 
flags:0x020000000000020c mapping:ffff810321d2fd20 mapcount:0 count:0
Mar 17 15:45:23 speyburn kernel: Trying to fix it up, but a reboot is 
needed
Mar 17 15:45:23 speyburn kernel: Backtrace:
Mar 17 15:45:23 speyburn kernel:
Mar 17 15:45:23 speyburn kernel: Call Trace:
Mar 17 15:45:23 speyburn kernel:  [<ffffffff802b1830>] bad_page+0x4e/0x78
Mar 17 15:45:23 speyburn kernel:  [<ffffffff8020b2b1>] 
free_hot_cold_page+0x73/0xff
Mar 17 15:45:24 speyburn kernel:
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8020e04e>] 
link_path_walk+0x5c/0xe5
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8025f3e8>] 
thread_return+0x0/0xe7
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8023f6de>] d_rehash+0x6a/0x80
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8816e3bc>] 
:xfs:xfs_corruption_error+0xe4/0xf6
Mar 17 15:45:24 speyburn kernel:  [<ffffffff88168c85>] 
:xfs:xfs_dir2_leaf_lookup_int+0x105/0x1fd
Mar 17 15:45:24 speyburn kernel:  [<ffffffff88165933>] 
:xfs:xfs_dir2_isleaf+0x19/0x4a
Mar 17 15:45:24 speyburn kernel: Filesystem "dm-17": XFS internal error 
xfs_da_do_buf(2) at line 2084 of file fs/xfs/xfs_da_btree.c.  Caller 
0xffffffff88163646
Mar 17 15:45:24 speyburn kernel: Bad page state in process 'imapd'
Mar 17 15:45:24 speyburn kernel: page:ffff81032c4d79c0 
flags:0x020000000000020c mapping:ffff810321d2fd20 mapcount:0 count:0
Mar 17 15:45:24 speyburn kernel: Trying to fix it up, but a reboot is 
needed
Mar 17 15:45:24 speyburn kernel: Backtrace:
Mar 17 15:45:24 speyburn kernel:
Mar 17 15:45:24 speyburn kernel: Call Trace:
Mar 17 15:45:24 speyburn kernel:  [<ffffffff802b1830>] bad_page+0x4e/0x78
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8020b2b1>] 
free_hot_cold_page+0x73/0xff
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8819391b>] 
:xfs:xfs_buf_free+0x99/0xdd
Mar 17 15:45:24 speyburn kernel:  [<ffffffff88187a6c>] 
:xfs:xfs_trans_push_ail+0xaf/0x237
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8817e264>] 
:xfs:xfs_log_reserve+0x443/0x6a6
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8819165d>] 
:xfs:kmem_zone_zalloc+0x1e/0x2f
Mar 17 15:45:24 speyburn kernel:  [<ffffffff88186d70>] 
:xfs:xfs_trans_reserve+0xea/0x1cb
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8818eeb8>] 
:xfs:xfs_create+0x1f0/0x5dd
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8818c344>] 
:xfs:xfs_lookup+0x6c/0x7d
Mar 17 15:45:24 speyburn kernel:  [<ffffffff80209112>] 
__link_path_walk+0x1a2/0xf88
Mar 17 15:45:24 speyburn kernel:  [<ffffffff80225d1d>] 
do_filp_open+0x1c/0x3d
Mar 17 15:45:24 speyburn kernel: imapd[10611]: segfault at 
00000000385f442c rip 00000000f7e678ac rsp 00000000fffc8cd8 error 4
Mar 17 15:45:24 speyburn kernel:  [<ffffffff802180e0>] 
do_sys_open+0x44/0xc5
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8025dc22>] ia32_sysret+0x0/0xa
Mar 17 15:45:24 speyburn kernel:
Mar 17 15:45:24 speyburn kernel: Bad page state in process 'imapd'
Mar 17 15:45:24 speyburn kernel: page:ffff8103296d6bd0 
flags:0x020000000000020c mapping:ffff810321d2fd20 mapcount:0 count:0
Mar 17 15:45:24 speyburn kernel: Trying to fix it up, but a reboot is 
needed
Mar 17 15:45:24 speyburn kernel: Backtrace:
Mar 17 15:45:24 speyburn kernel:
Mar 17 15:45:24 speyburn kernel: Call Trace:
Mar 17 15:45:24 speyburn kernel:  [<ffffffff802b1830>] bad_page+0x4e/0x78
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8020b2b1>] 
free_hot_cold_page+0x73/0xff
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8819391b>] 
:xfs:xfs_buf_free+0x99/0xdd
Mar 17 15:45:24 speyburn kernel:  [<ffffffff88187a6c>] 
:xfs:xfs_trans_push_ail+0xaf/0x237
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8817e264>] 
:xfs:xfs_log_reserve+0x443/0x6a6
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8819165d>] 
:xfs:kmem_zone_zalloc+0x1e/0x2f
Mar 17 15:45:24 speyburn kernel:  [<ffffffff88186d70>] 
:xfs:xfs_trans_reserve+0xea/0x1cb
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8818eeb8>] 
:xfs:xfs_create+0x1f0/0x5dd
Mar 17 15:45:24 speyburn kernel: Unable to handle kernel paging request 
at 0000000000100108 RIP:
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8020a084>] 
get_page_from_freelist+0x18c/0x3a6
Mar 17 15:45:24 speyburn kernel: PGD 268228067 PUD 143e6f067 PMD 0
Mar 17 15:45:24 speyburn kernel: Oops: 0002 [133] SMP
Mar 17 15:45:24 speyburn kernel: CPU 1
Mar 17 15:45:24 speyburn kernel: Modules linked in: iptable_filter 
ip_tables x_tables ipv6 ext2 mbcache dm_snapshot dm_mirror tsdev psmouse 
shpchp serio_raw pci_hotplug pcspkr evdev sg st xfs raid456 xor raid10 
raid1 raid0 linear md_mod dm_mod ch sd_mod mptsas mptscsih mptbase 
scsi_transport_sas ehci_hcd bnx2 qla2xxx firmware_class uhci_hcd 
scsi_transport_fc scsi_mod thermal processor fan
Mar 17 15:45:24 speyburn kernel: Pid: 10615, comm: imapd Tainted: G    B 
2.6.18-4-vserver-amd64 #1
Mar 17 15:45:24 speyburn kernel: RIP: 0010:[<ffffffff8020a084>]  
[<ffffffff8020a084>] get_page_from_freelist+0x18c/0x3a6
Mar 17 15:45:24 speyburn kernel: RSP: 0000:ffff8103125b1d08  EFLAGS: 
00010002
Mar 17 15:45:24 speyburn kernel: RAX: ffff81032bce0b10 RBX: 
ffff810324d75d40 RCX: 0000000000100100
Mar 17 15:45:24 speyburn kernel: RDX: ffff810324d75d50 RSI: 
0000000000000c8b RDI: ffff810000016800
Mar 17 15:45:24 speyburn kernel: RBP: 0000000000000282 R08: 
0000000000000000 R09: 0000000000002d3d
Mar 17 15:45:24 speyburn kernel: R10: 0000000000000000 R11: 
0000000000000002 R12: ffff810000016800
Mar 17 15:45:24 speyburn kernel: R13: ffff81032bce0ae8 R14: 
ffff810000018010 R15: 00003ffffffff000
Mar 17 15:45:24 speyburn kernel: FS:  0000000000000000(0000) 
GS:ffff810324d75c40(0063) knlGS:00000000f7d77aa0
Mar 17 15:45:24 speyburn kernel: CS:  0010 DS: 002b ES: 002b CR0: 
000000008005003b
Mar 17 15:45:24 speyburn kernel: CR2: 0000000000100108 CR3: 
0000000209207000 CR4: 00000000000006e0
Mar 17 15:45:24 speyburn kernel: Process imapd (pid: 10615[#49152], 
threadinfo ffff8103125b0000, task ffff81012db1b880)
Mar 17 15:45:24 speyburn kernel: Stack:  ffff81005406e0c0 
0000004400000015 ffff810000018010 000280d200000000
Mar 17 15:45:24 speyburn kernel:  0000000000000002 ffffffff8023695f 
ffff8103125b1e08 000000008027e850
Mar 17 15:45:24 speyburn kernel:  0000000000000001 ffffffff8027e708 
ffff810320b34000 ffff810000018010
Mar 17 15:45:24 speyburn kernel: Call Trace:
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8023695f>] 
do_sock_write+0xcb/0x19c
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8027e708>] 
__activate_task+0x27/0x39
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8020e1b0>] 
__alloc_pages+0x5c/0x2a9
Mar 17 15:45:24 speyburn kernel:  [<ffffffff802085d3>] 
__handle_mm_fault+0x1e2/0xa80
Mar 17 15:45:24 speyburn kernel:  [<ffffffff802b6c60>] 
expand_stack+0x13c/0x170
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8020a89c>] 
do_page_fault+0x39d/0x706
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8025f3e8>] 
thread_return+0x0/0xe7
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8025b6e5>] error_exit+0x0/0x84
Mar 17 15:45:24 speyburn kernel:
Mar 17 15:45:24 speyburn kernel:
Mar 17 15:45:24 speyburn kernel: Code: 48 89 51 08 48 89 0a 48 c7 40 08 
00 02 20 00 48 c7 00 00 01
Mar 17 15:45:24 speyburn kernel: RIP  [<ffffffff8020a084>] 
get_page_from_freelist+0x18c/0x3a6
Mar 17 15:45:24 speyburn kernel:  RSP <ffff8103125b1d08>
Mar 17 15:45:24 speyburn kernel: CR2: 0000000000100108
Mar 17 15:45:24 speyburn kernel: <0>Bad page state in process 'imapd'
Mar 17 15:45:24 speyburn kernel: page:ffff81032884a700 
flags:0x020000000000020c mapping:ffff810321d2fd20 mapcount:0 count:0
Mar 17 15:45:24 speyburn kernel: Trying to fix it up, but a reboot is 
needed
Mar 17 15:45:24 speyburn kernel: Backtrace:
Mar 17 15:45:24 speyburn kernel:
Mar 17 15:45:24 speyburn kernel: Call Trace:
Mar 17 15:45:24 speyburn kernel:  [<ffffffff802b1830>] bad_page+0x4e/0x78
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8020b2b1>] 
free_hot_cold_page+0x73/0xff
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8819391b>] 
:xfs:xfs_buf_free+0x99/0xdd
Mar 17 15:45:24 speyburn kernel:  [<ffffffff88187a6c>] 
:xfs:xfs_trans_push_ail+0xaf/0x237
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8817e264>] 
:xfs:xfs_log_reserve+0x443/0x6a6
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8819165d>] 
:xfs:kmem_zone_zalloc+0x1e/0x2f
Mar 17 15:45:24 speyburn kernel:  [<ffffffff88186d70>] 
:xfs:xfs_trans_reserve+0xea/0x1cb
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8818eeb8>] 
:xfs:xfs_create+0x1f0/0x5dd
Mar 17 15:45:24 speyburn kernel:  [<ffffffff88197702>] 
:xfs:xfs_vn_mknod+0x1bd/0x3c8
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8817375e>] 
:xfs:xfs_iunlock+0x57/0x79
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8818c344>] 
:xfs:xfs_lookup+0x6c/0x7d
Mar 17 15:45:24 speyburn kernel:  [<ffffffff80220a18>] __up_read+0x13/0x8a
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8817375e>] 
:xfs:xfs_iunlock+0x57/0x79
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8818c392>] 
:xfs:xfs_access+0x3d/0x46
Mar 17 15:45:24 speyburn kernel:  [<ffffffff88197cba>] 
:xfs:xfs_vn_permission+0x14/0x18
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8020cf8a>] 
permission+0xf0/0x155
Mar 17 15:45:24 speyburn kernel:  [<ffffffff80209112>] 
__link_path_walk+0x1a2/0xf88
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8022ba1e>] 
mntput_no_expire+0x19/0x8b
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8020e0c5>] 
link_path_walk+0xd3/0xe5
Mar 17 15:45:24 speyburn kernel:  [<ffffffff80239523>] 
vfs_create+0xe7/0x12c
Mar 17 15:45:24 speyburn kernel:  [<ffffffff80219430>] 
open_namei+0x18c/0x6a0
Mar 17 15:45:24 speyburn kernel:  [<ffffffff80225d1d>] 
do_filp_open+0x1c/0x3d
Mar 17 15:45:24 speyburn kernel:  [<ffffffff802180e0>] 
do_sys_open+0x44/0xc5
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8025dc22>] ia32_sysret+0x0/0xa
Mar 17 15:45:24 speyburn kernel:
Mar 17 15:45:24 speyburn kernel: Bad page state in process 'imapd'
Mar 17 15:45:24 speyburn kernel: page:ffff81032bce0ae8 
flags:0x020000000000020c mapping:0000000000000000 mapcount:1 count:0
Mar 17 15:45:24 speyburn kernel: Trying to fix it up, but a reboot is 
needed
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8818c344>] 
:xfs:xfs_lookup+0x6c/0x7d
Mar 17 15:45:24 speyburn kernel: ----------- [cut here ] --------- 
[please bite here ] ---------
Mar 17 15:45:24 speyburn kernel: Kernel BUG at include/linux/mm.h:300
Mar 17 15:45:24 speyburn kernel: Bad page state in process 'imaplogin'
Mar 17 15:45:24 speyburn kernel: <1>Unable to handle kernel paging 
request at 0000000000200200 RIP:
Mar 17 15:45:24 speyburn kernel:  [<ffffffff80210bfe>] 
get_empty_filp+0x5b/0x1a6
Mar 17 15:45:24 speyburn kernel: R13: ffff810000016800 R14: 
000000000000000d R15: 0000000000000002
Mar 17 15:45:24 speyburn kernel: Call Trace:
Mar 17 15:45:24 speyburn kernel:  [<ffffffff8020a030>] 
get_page_from_freelist+0x138/0x3a6

-----

At that point, a hard reboot was needed !!
Is there any body who knows what has happened ??


And now, 2nd part of thge problem : Now my XFS FS seems in bad state , 
Every second or sao I have this problem :


Mar 17 15:55:03 speyburn kernel: 0x0: 70 72 69 76 65 2c 53 3d 34 35 32 
33 3a 30 0a 31
Mar 17 15:55:03 speyburn kernel: Filesystem "dm-17": XFS internal error 
xfs_da_do_buf(2) at line 2084 of file fs/xfs/xfs_da_btree.c.  Caller 
0xffffffff88165646
Mar 17 15:55:03 speyburn kernel:
Mar 17 15:55:03 speyburn kernel: Call Trace:
Mar 17 15:55:03 speyburn kernel:  [<ffffffff881703bc>] 
:xfs:xfs_corruption_error+0xe4/0xf6
Mar 17 15:55:03 speyburn kernel:  [<ffffffff881935f2>] 
:xfs:kmem_zone_alloc+0x56/0xa3
Mar 17 15:55:03 speyburn kernel:  [<ffffffff88165515>] 
:xfs:xfs_da_do_buf+0x53c/0x61e
Mar 17 15:55:03 speyburn kernel:  [<ffffffff88165646>] 
:xfs:xfs_da_read_buf+0x16/0x1b
Mar 17 15:55:03 speyburn kernel:  [<ffffffff88165646>] 
:xfs:xfs_da_read_buf+0x16/0x1b
Mar 17 15:55:03 speyburn kernel:  [<ffffffff8816b57b>] 
:xfs:xfs_dir2_leaf_getdents+0x3c3/0x6d9
Mar 17 15:55:03 speyburn kernel:  [<ffffffff8816b57b>] 
:xfs:xfs_dir2_leaf_getdents+0x3c3/0x6d9
Mar 17 15:55:03 speyburn kernel:  [<ffffffff88167e82>] 
:xfs:xfs_dir2_put_dirent64_direct+0x0/0x6b
Mar 17 15:55:03 speyburn kernel:  [<ffffffff88167e5a>] 
:xfs:xfs_dir_getdents+0xf2/0x11a
Mar 17 15:55:03 speyburn kernel:  [<ffffffff80220a18>] __up_read+0x13/0x8a
Mar 17 15:55:03 speyburn kernel:  [<ffffffff8818e0d7>] 
:xfs:xfs_readdir+0x3f/0x58
Mar 17 15:55:03 speyburn kernel:  [<ffffffff88197712>] 
:xfs:xfs_file_readdir+0xb6/0x1a7
Mar 17 15:55:03 speyburn kernel:  [<ffffffff802d95a0>] 
compat_filldir+0x0/0xb6
Mar 17 15:55:03 speyburn kernel:  [<ffffffff802d95a0>] 
compat_filldir+0x0/0xb6
Mar 17 15:55:03 speyburn kernel:  [<ffffffff80233c76>] 
vfs_readdir+0x77/0xa9
Mar 17 15:55:03 speyburn kernel:  [<ffffffff802dac4b>] 
compat_sys_getdents+0x75/0xbd
Mar 17 15:55:03 speyburn kernel:  [<ffffffff8025d2da>] ia32_sysret+0x0/0xa
Mar 17 15:55:03 speyburn kernel:
Mar 17 15:55:04 speyburn kernel: 0x0: 70 72 69 76 65 2c 53 3d 34 35 32 
33 3a 30 0a 31
Mar 17 15:55:04 speyburn kernel: Filesystem "dm-17": XFS internal error 
xfs_da_do_buf(2) at line 2084 of file fs/xfs/xfs_da_btree.c.  Caller 
0xffffffff88165646
Mar 17 15:55:04 speyburn kernel:
Mar 17 15:55:04 speyburn kernel: Call Trace:
Mar 17 15:55:04 speyburn kernel:  [<ffffffff881703bc>] 
:xfs:xfs_corruption_error+0xe4/0xf6
Mar 17 15:55:04 speyburn kernel:  [<ffffffff881935f2>] 
:xfs:kmem_zone_alloc+0x56/0xa3
Mar 17 15:55:04 speyburn kernel:  [<ffffffff88165515>] 
:xfs:xfs_da_do_buf+0x53c/0x61e
Mar 17 15:55:04 speyburn kernel:  [<ffffffff88165646>] 
:xfs:xfs_da_read_buf+0x16/0x1b
Mar 17 15:55:04 speyburn kernel:  [<ffffffff88165646>] 
:xfs:xfs_da_read_buf+0x16/0x1b
Mar 17 15:55:04 speyburn kernel:  [<ffffffff8816b57b>] 
:xfs:xfs_dir2_leaf_getdents+0x3c3/0x6d9
Mar 17 15:55:04 speyburn kernel:  [<ffffffff8816b57b>] 
:xfs:xfs_dir2_leaf_getdents+0x3c3/0x6d9
Mar 17 15:55:04 speyburn kernel:  [<ffffffff88167e82>] 
:xfs:xfs_dir2_put_dirent64_direct+0x0/0x6b
Mar 17 15:55:04 speyburn kernel:  [<ffffffff88167e5a>] 
:xfs:xfs_dir_getdents+0xf2/0x11a
Mar 17 15:55:04 speyburn kernel:  [<ffffffff80220a18>] __up_read+0x13/0x8a
Mar 17 15:55:04 speyburn kernel:  [<ffffffff8818e0d7>] 
:xfs:xfs_readdir+0x3f/0x58
Mar 17 15:55:04 speyburn kernel:  [<ffffffff88197712>] 
:xfs:xfs_file_readdir+0xb6/0x1a7
Mar 17 15:55:04 speyburn kernel:  [<ffffffff802d95a0>] 
compat_filldir+0x0/0xb6
Mar 17 15:55:04 speyburn kernel:  [<ffffffff8025e033>] 
__sched_text_start+0x173/0xbd8
Mar 17 15:55:04 speyburn kernel:  [<ffffffff802d95a0>] 
compat_filldir+0x0/0xb6
Mar 17 15:55:04 speyburn kernel:  [<ffffffff80233c76>] 
vfs_readdir+0x77/0xa9
Mar 17 15:55:04 speyburn kernel:  [<ffffffff802dac4b>] 
compat_sys_getdents+0x75/0xbd
Mar 17 15:55:04 speyburn kernel:  [<ffffffff8025d2da>] ia32_sysret+0x0/0xa
Mar 17 15:55:04 speyburn kernel:
Mar 17 15:56:04 speyburn kernel: 0x0: 70 72 69 76 65 2c 53 3d 34 35 32 
33 3a 30 0a 31
Mar 17 15:56:04 speyburn kernel: Filesystem "dm-17": XFS internal error 
xfs_da_do_buf(2) at line 2084 of file fs/xfs/xfs_da_btree.c.  Caller 
0xffffffff88165646
Mar 17 15:56:04 speyburn kernel:
Mar 17 15:56:04 speyburn kernel: Call Trace:
Mar 17 15:56:04 speyburn kernel:  [<ffffffff881703bc>] 
:xfs:xfs_corruption_error+0xe4/0xf6
Mar 17 15:56:04 speyburn kernel:  [<ffffffff881935f2>] 
:xfs:kmem_zone_alloc+0x56/0xa3
Mar 17 15:56:04 speyburn kernel:  [<ffffffff88165515>] 
:xfs:xfs_da_do_buf+0x53c/0x61e
Mar 17 15:56:04 speyburn kernel:  [<ffffffff88165646>] 
:xfs:xfs_da_read_buf+0x16/0x1b
Mar 17 15:56:04 speyburn kernel:  [<ffffffff88165646>] 
:xfs:xfs_da_read_buf+0x16/0x1b
Mar 17 15:56:04 speyburn kernel:  [<ffffffff8816b57b>] 
:xfs:xfs_dir2_leaf_getdents+0x3c3/0x6d9
Mar 17 15:56:04 speyburn kernel:  [<ffffffff8816b57b>] 
:xfs:xfs_dir2_leaf_getdents+0x3c3/0x6d9
Mar 17 15:56:04 speyburn kernel:  [<ffffffff88167e82>] 
:xfs:xfs_dir2_put_dirent64_direct+0x0/0x6b
Mar 17 15:56:04 speyburn kernel:  [<ffffffff88167e5a>] 
:xfs:xfs_dir_getdents+0xf2/0x11a
Mar 17 15:56:04 speyburn kernel:  [<ffffffff80220a18>] __up_read+0x13/0x8a
Mar 17 15:56:04 speyburn kernel:  [<ffffffff8818e0d7>] 
:xfs:xfs_readdir+0x3f/0x58
Mar 17 15:56:04 speyburn kernel:  [<ffffffff88197712>] 
:xfs:xfs_file_readdir+0xb6/0x1a7
Mar 17 15:56:04 speyburn kernel:  [<ffffffff802d95a0>] 
compat_filldir+0x0/0xb6
Mar 17 15:56:04 speyburn kernel:  [<ffffffff8025e033>] 
__sched_text_start+0x173/0xbd8
Mar 17 15:56:04 speyburn kernel:  [<ffffffff802d95a0>] 
compat_filldir+0x0/0xb6
Mar 17 15:56:04 speyburn kernel:  [<ffffffff80233c76>] 
vfs_readdir+0x77/0xa9
Mar 17 15:56:04 speyburn kernel:  [<ffffffff802dac4b>] 
compat_sys_getdents+0x75/0xbd
Mar 17 15:56:04 speyburn kernel:  [<ffffffff8025d2da>] ia32_sysret+0x0/0xa
Mar 17 15:56:04 speyburn kernel:
Mar 17 15:57:04 speyburn kernel: 0x0: 70 72 69 76 65 2c 53 3d 34 35 32 
33 3a 30 0a 31
Mar 17 15:57:04 speyburn kernel: Filesystem "dm-17": XFS internal error 
xfs_da_do_buf(2) at line 2084 of file fs/xfs/xfs_da_btree.c.  Caller 
0xffffffff88165646
Mar 17 15:57:04 speyburn kernel:
Mar 17 15:57:04 speyburn kernel: Call Trace:
Mar 17 15:57:04 speyburn kernel:  [<ffffffff881703bc>] 
:xfs:xfs_corruption_error+0xe4/0xf6
Mar 17 15:57:04 speyburn kernel:  [<ffffffff881935f2>] 
:xfs:kmem_zone_alloc+0x56/0xa3
Mar 17 15:57:04 speyburn kernel:  [<ffffffff88165515>] 
:xfs:xfs_da_do_buf+0x53c/0x61e
Mar 17 15:57:04 speyburn kernel:  [<ffffffff88165646>] 
:xfs:xfs_da_read_buf+0x16/0x1b
Mar 17 15:57:04 speyburn kernel:  [<ffffffff88165646>] 
:xfs:xfs_da_read_buf+0x16/0x1b
Mar 17 15:57:04 speyburn kernel:  [<ffffffff8816b57b>] 
:xfs:xfs_dir2_leaf_getdents+0x3c3/0x6d9
Mar 17 15:57:04 speyburn kernel:  [<ffffffff8816b57b>] 
:xfs:xfs_dir2_leaf_getdents+0x3c3/0x6d9
Mar 17 15:57:04 speyburn kernel:  [<ffffffff88167e82>] 
:xfs:xfs_dir2_put_dirent64_direct+0x0/0x6b
Mar 17 15:57:04 speyburn kernel:  [<ffffffff88167e5a>] 
:xfs:xfs_dir_getdents+0xf2/0x11a
Mar 17 15:57:04 speyburn kernel:  [<ffffffff80220a18>] __up_read+0x13/0x8a
Mar 17 15:57:04 speyburn kernel:  [<ffffffff8818e0d7>] 
:xfs:xfs_readdir+0x3f/0x58
Mar 17 15:57:04 speyburn kernel:  [<ffffffff88197712>] 
:xfs:xfs_file_readdir+0xb6/0x1a7
Mar 17 15:57:04 speyburn kernel:  [<ffffffff802d95a0>] 
compat_filldir+0x0/0xb6
Mar 17 15:57:04 speyburn kernel:  [<ffffffff8025e033>] 
__sched_text_start+0x173/0xbd8
Mar 17 15:57:04 speyburn kernel:  [<ffffffff802d95a0>] 
compat_filldir+0x0/0xb6
Mar 17 15:57:04 speyburn kernel:  [<ffffffff80233c76>] 
vfs_readdir+0x77/0xa9
Mar 17 15:57:04 speyburn kernel:  [<ffffffff802dac4b>] 
compat_sys_getdents+0x75/0xbd
Mar 17 15:57:04 speyburn kernel:  [<ffffffff8025d2da>] ia32_sysret+0x0/0xa
Mar 17 15:57:04 speyburn kernel:
Mar 17 15:58:04 speyburn kernel: 0x0: 70 72 69 76 65 2c 53 3d 34 35 32 
33 3a 30 0a 31
Mar 17 15:58:04 speyburn kernel: Filesystem "dm-17": XFS internal error 
xfs_da_do_buf(2) at line 2084 of file fs/xfs/xfs_da_btree.c.  Caller 
0xffffffff88165646
Mar 17 15:58:04 speyburn kernel:
Mar 17 15:58:04 speyburn kernel: Call Trace:
Mar 17 15:58:04 speyburn kernel:  [<ffffffff881703bc>] 
:xfs:xfs_corruption_error+0xe4/0xf6
Mar 17 15:58:04 speyburn kernel:  [<ffffffff881935f2>] 
:xfs:kmem_zone_alloc+0x56/0xa3
Mar 17 15:58:04 speyburn kernel:  [<ffffffff88165515>] 
:xfs:xfs_da_do_buf+0x53c/0x61e
Mar 17 15:58:04 speyburn kernel:  [<ffffffff88165646>] 
:xfs:xfs_da_read_buf+0x16/0x1b
Mar 17 15:58:04 speyburn kernel:  [<ffffffff88165646>] 
:xfs:xfs_da_read_buf+0x16/0x1b
Mar 17 15:58:04 speyburn kernel:  [<ffffffff8816b57b>] 
:xfs:xfs_dir2_leaf_getdents+0x3c3/0x6d9
Mar 17 15:58:04 speyburn kernel:  [<ffffffff8816b57b>] 
:xfs:xfs_dir2_leaf_getdents+0x3c3/0x6d9
Mar 17 15:58:04 speyburn kernel:  [<ffffffff88167e82>] 
:xfs:xfs_dir2_put_dirent64_direct+0x0/0x6b
Mar 17 15:58:04 speyburn kernel:  [<ffffffff88167e5a>] 
:xfs:xfs_dir_getdents+0xf2/0x11a
Mar 17 15:58:04 speyburn kernel:  [<ffffffff80220a18>] __up_read+0x13/0x8a
Mar 17 15:58:04 speyburn kernel:  [<ffffffff8818e0d7>] 
:xfs:xfs_readdir+0x3f/0x58
Mar 17 15:58:04 speyburn kernel:  [<ffffffff88197712>] 
:xfs:xfs_file_readdir+0xb6/0x1a7
Mar 17 15:58:04 speyburn kernel:  [<ffffffff802d95a0>] 
compat_filldir+0x0/0xb6
Mar 17 15:58:04 speyburn kernel:  [<ffffffff8025e033>] 
__sched_text_start+0x173/0xbd8
Mar 17 15:58:04 speyburn kernel:  [<ffffffff802d95a0>] 
compat_filldir+0x0/0xb6
Mar 17 15:58:04 speyburn kernel:  [<ffffffff80233c76>] 
vfs_readdir+0x77/0xa9
Mar 17 15:58:04 speyburn kernel:  [<ffffffff802dac4b>] 
compat_sys_getdents+0x75/0xbd
Mar 17 15:58:04 speyburn kernel:  [<ffffffff8025d2da>] ia32_sysret+0x0/0xa
Mar 17 15:58:04 speyburn kernel:
Mar 17 15:59:04 speyburn kernel: 0x0: 70 72 69 76 65 2c 53 3d 34 35 32 
33 3a 30 0a 31
Mar 17 15:59:04 speyburn kernel: Filesystem "dm-17": XFS internal error 
xfs_da_do_buf(2) at line 2084 of file fs/xfs/xfs_da_btree.c.  Caller 
0xffffffff88165646
Mar 17 15:59:04 speyburn kernel:
Mar 17 15:59:04 speyburn kernel: Call Trace:
Mar 17 15:59:04 speyburn kernel:  [<ffffffff881703bc>] 
:xfs:xfs_corruption_error+0xe4/0xf6
Mar 17 15:59:04 speyburn kernel:  [<ffffffff881935f2>] 
:xfs:kmem_zone_alloc+0x56/0xa3
Mar 17 15:59:04 speyburn kernel:  [<ffffffff88165515>] 
:xfs:xfs_da_do_buf+0x53c/0x61e
Mar 17 15:59:04 speyburn kernel:  [<ffffffff88165646>] 
:xfs:xfs_da_read_buf+0x16/0x1b
Mar 17 15:59:04 speyburn kernel:  [<ffffffff88165646>] 
:xfs:xfs_da_read_buf+0x16/0x1b
Mar 17 15:59:04 speyburn kernel:  [<ffffffff8816b57b>] 
:xfs:xfs_dir2_leaf_getdents+0x3c3/0x6d9
Mar 17 15:59:04 speyburn kernel:  [<ffffffff8816b57b>] 
:xfs:xfs_dir2_leaf_getdents+0x3c3/0x6d9
Mar 17 15:59:04 speyburn kernel:  [<ffffffff88167e82>] 
:xfs:xfs_dir2_put_dirent64_direct+0x0/0x6b
Mar 17 15:59:04 speyburn kernel:  [<ffffffff88167e5a>] 
:xfs:xfs_dir_getdents+0xf2/0x11a
Mar 17 15:59:04 speyburn kernel:  [<ffffffff80220a18>] __up_read+0x13/0x8a
Mar 17 15:59:04 speyburn kernel:  [<ffffffff8818e0d7>] 
:xfs:xfs_readdir+0x3f/0x58
Mar 17 15:59:04 speyburn kernel:  [<ffffffff88197712>] 
:xfs:xfs_file_readdir+0xb6/0x1a7
Mar 17 15:59:04 speyburn kernel:  [<ffffffff802d95a0>] 
compat_filldir+0x0/0xb6
Mar 17 15:59:04 speyburn kernel:  [<ffffffff8025e033>] 
__sched_text_start+0x173/0xbd8
Mar 17 15:59:04 speyburn kernel:  [<ffffffff802d95a0>] 
compat_filldir+0x0/0xb6
Mar 17 15:59:04 speyburn kernel:  [<ffffffff80233c76>] 
vfs_readdir+0x77/0xa9
Mar 17 15:59:04 speyburn kernel:  [<ffffffff802dac4b>] 
compat_sys_getdents+0x75/0xbd
Mar 17 15:59:04 speyburn kernel:  [<ffffffff8025d2da>] ia32_sysret+0x0/0xa
Mar 17 15:59:04 speyburn kernel:
Mar 17 16:00:06 speyburn kernel: 0x0: 70 72 69 76 65 2c 53 3d 34 35 32 
33 3a 30 0a 31
Mar 17 16:01:04 speyburn kernel: 0x0: 70 72 69 76 65 2c 53 3d 34 35 32 
33 3a 30 0a 31
Mar 17 16:01:04 speyburn kernel: Filesystem "dm-17": XFS internal error 
xfs_da_do_buf(2) at line 2084 of file fs/xfs/xfs_da_btree.c.  Caller 
0xffffffff88165646

So I have to check the filesystem :(

The curious part is that in spite of the continuous messages, the FS 
(lots of maildirs) seems consistent for now and works OK. But i'm quite 
scared and will go for a complete check now.

Sincerely ,

-- 
Yann Dupont - Pôle IRTS, DSI Université de Nantes
Tel : 02.51.12.53.91 - Mail/Jabber : Yann.Dupont@univ-nantes.fr
