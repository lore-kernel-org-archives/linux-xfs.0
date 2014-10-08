Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A29037F3F
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 09:14:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11012AC005
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 07:14:36 -0700 (PDT)
Received: from mxi1.enovance.com (mxi1.enovance.com [94.143.114.217]) by
	cuda.sgi.com with ESMTP id BCWCgZshG6vHqUOk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Oct 2014 07:14:31 -0700 (PDT)
Received: from zimbra.enovance.com (94-143-114-250.enovance.net
	[94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 0345D863839
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 16:14:30 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id F419B5A8DC06
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 16:14:29 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id QNvcJTKSGdYG for <xfs@oss.sgi.com>;
	Wed,  8 Oct 2014 16:14:27 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 018DF58D8846
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 16:14:27 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id EM1s5GNBQhIN for <xfs@oss.sgi.com>;
	Wed,  8 Oct 2014 16:14:26 +0200 (CEST)
Received: from zimbra.enovance.com (zimbra.enovance.com [94.143.114.250])
	by zimbra.enovance.com (Postfix) with ESMTP id C386778080F
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 16:14:26 +0200 (CEST)
Date: Wed, 8 Oct 2014 16:14:26 +0200 (CEST)
From: victor stinner <victor.stinner@enovance.com>
Message-ID: <734140413.8186921.1412777666412.JavaMail.zimbra@enovance.com>
In-Reply-To: <1211918248.8179166.1412774638265.JavaMail.zimbra@enovance.com>
Subject: Can you help me to investiage a soft lockup?
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_8186919_654588180.1412777666395"
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

------=_Part_8186919_654588180.1412777666395
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,

I'm working on OpenStack, and we hit a bug on Swift (distributed storage). The Linux kernel 3.2 logged many "soft lockup" messages which looks to be related to XFS: see kernel messages at the end of this email (it's only an extract of first messages, there are more later).

I'm trying to find with google if the bug is known or not. "soft lockup" looks to be a "common" bug on Linux, but it's hard (for me) to check if existing bug reports are similar to our issue or not.

And how can I check if it's an hardware issue or a Linux kernel (XFS?) issue?

The following issues look similiar:

- http://oss.sgi.com/archives/xfs/2013-06/msg00865.html : Centos, Linux kernel 2.6.32
  This email mentions two bugzilla issues, probably the following ones, but I'm not allowed to see them :-/
  https://bugzilla.redhat.com/show_bug.cgi?id=896224
  https://bugzilla.redhat.com/show_bug.cgi?id=921961
- https://retrace.fedoraproject.org/faf/reports/98448/ : Fedora 18, Linux kernel 3.8
- https://bugs.centos.org/view.php?id=6287 : Linux 2.6.32
- https://lkml.org/lkml/2013/10/16/263 : RC version of Linux (3.12.0-rc1), maybe not reliable

Some info about the server:

- Dell PowerEdge R720xd/0X6H47
- Ubuntu 12.04
- Linux kernel 3.2.0-51-generic
- Intel(R) Xeon(R) CPU E5-2665 0 @ 2.40GHz : 32 cores
- 2 NUMA nodes

There are 26 disks, HDD and SSD. All partitions used to store Swift objects are formatted with XFS, only a few system partitions are formatted as ext4 (and ext3 for /boot). There are 2 disk controllers: internal and a PCI Express controller.


Victor

Linux kernel messages:

BUG: soft lockup - CPU#28 stuck for 22s! [swift-object-se:4354]
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]
CPU 28
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]

Pid: 4354, comm: swift-object-se Tainted: G        WC   3.2.0-51-generic #77-Ubuntu Dell Inc. PowerEdge R720xd/0X6H47
RIP: 0010:[<ffffffff8103ebc5>]  [<ffffffff8103ebc5>] __ticket_spin_lock+0x25/0x30
RSP: 0018:ffff8802a0d95b68  EFLAGS: 00000293
RAX: 0000000000007c1c RBX: ffffffff811641cf RCX: ffff88080830a960
RDX: 0000000000007c1e RSI: ffff8801c6235c00 RDI: ffff88082420fea8
RBP: ffff8802a0d95b68 R08: ffff8802a0d95ca0 R09: ffff8802a0d95cac
R10: 0000000000002134 R11: 000000000000000a R12: ffff8802a0d95b50
R13: ffff88082420fe00 R14: ffff880424d676f8 R15: ffff8802a0d95ae8
FS:  00007f3d8dffb700(0000) GS:ffff88042fdc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3dbcd1b000 CR3: 00000004140bf000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swift-object-se (pid: 4354, threadinfo ffff8802a0d94000, task ffff8801c6235c00)
Stack:
 ffff8802a0d95b78 ffffffff816606be ffff8802a0d95c18 ffffffffa01cc548
 ffff8802a0d95cac ffff8802a0d95ca0 ffff8802a0d95c90 000022546322c000
 00000000000144c0 ffff8801c6235c00 ffff8802a0d95df5 000000000000000e
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01cc548>] xlog_state_get_iclog_space+0x58/0x2e0 [xfs]
 [<ffffffff8116655d>] ? kmem_cache_alloc+0x11d/0x140
 [<ffffffffa01ccb99>] xlog_write+0xe9/0x400 [xfs]
 [<ffffffffa018c877>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
 [<ffffffffa01ce40c>] xlog_cil_push+0x20c/0x380 [xfs]
 [<ffffffffa01ced2e>] xlog_cil_force_lsn+0x10e/0x120 [xfs]
 [<ffffffff8119e031>] ? setxattr+0xd1/0x120
 [<ffffffffa01cd367>] _xfs_log_force_lsn+0x57/0x2e0 [xfs]
 [<ffffffff8165f986>] ? down_read+0x16/0x2b
 [<ffffffffa017d116>] ? xfs_iunlock+0xe6/0x150 [xfs]
 [<ffffffffa0179123>] ? xfs_file_fsync+0x113/0x300 [xfs]
 [<ffffffffa017920c>] xfs_file_fsync+0x1fc/0x300 [xfs]
 [<ffffffff811a8c56>] do_fsync+0x56/0x80
 [<ffffffff811a8f80>] sys_fsync+0x10/0x20
 [<ffffffff81668d02>] system_call_fastpath+0x16/0x1b
Code: 90 90 90 90 90 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 13 66 0f 1f 84 00 00 00 00 00 f3 90 0f b7 07 <66> 39 d0 75 f6 5d c3 0f 1f 40 00 8b 17 55 31 c0 48 89 e5 89 d1
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01cc548>] xlog_state_get_iclog_space+0x58/0x2e0 [xfs]
 [<ffffffff8116655d>] ? kmem_cache_alloc+0x11d/0x140
 [<ffffffffa01ccb99>] xlog_write+0xe9/0x400 [xfs]
 [<ffffffffa018c877>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
 [<ffffffffa01ce40c>] xlog_cil_push+0x20c/0x380 [xfs]
 [<ffffffffa01ced2e>] xlog_cil_force_lsn+0x10e/0x120 [xfs]
 [<ffffffff8119e031>] ? setxattr+0xd1/0x120
 [<ffffffffa01cd367>] _xfs_log_force_lsn+0x57/0x2e0 [xfs]
 [<ffffffff8165f986>] ? down_read+0x16/0x2b
 [<ffffffffa017d116>] ? xfs_iunlock+0xe6/0x150 [xfs]
 [<ffffffffa0179123>] ? xfs_file_fsync+0x113/0x300 [xfs]
 [<ffffffffa017920c>] xfs_file_fsync+0x1fc/0x300 [xfs]
 [<ffffffff811a8c56>] do_fsync+0x56/0x80
 [<ffffffff811a8f80>] sys_fsync+0x10/0x20
 [<ffffffff81668d02>] system_call_fastpath+0x16/0x1b


BUG: soft lockup - CPU#30 stuck for 22s! [xfsaild/sdf1:2876]
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]
CPU 30
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]

Pid: 2876, comm: xfsaild/sdf1 Tainted: G        WC   3.2.0-51-generic #77-Ubuntu Dell Inc. PowerEdge R720xd/0X6H47
RIP: 0010:[<ffffffff8103ebc5>]  [<ffffffff8103ebc5>] __ticket_spin_lock+0x25/0x30
RSP: 0018:ffff88041116bc20  EFLAGS: 00000297
RAX: 00000000000007e5 RBX: 0000000000000000 RCX: 0000000000000231
RDX: 00000000000007e6 RSI: ffff88082420fea8 RDI: ffff880824b32e78
RBP: ffff88041116bc20 R08: 0000000000000001 R09: 0000000000000000
R10: ffff88041116ba24 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8807eeedad80 R14: 0003000100000000 R15: ffff88041116bb88
FS:  0000000000000000(0000) GS:ffff88042fde0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f3dbcd1b000 CR3: 0000000001c05000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process xfsaild/sdf1 (pid: 2876, threadinfo ffff88041116a000, task ffff880819d35c00)
Stack:
 ffff88041116bc30 ffffffff816606be ffff88041116bc50 ffffffffa01d13d4
 ffff88082420fe00 ffff88082420fe00 ffff88041116bc70 ffffffffa01cc3fe
 ffff88041116bcc0 ffff88042121c800 ffff88041116bca0 ffffffffa01cc4d3
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01d13d4>] xfs_ail_min_lsn+0x24/0x60 [xfs]
 [<ffffffffa01cc3fe>] xlog_assign_tail_lsn+0x1e/0x40 [xfs]
 [<ffffffffa01cc4d3>] xlog_state_release_iclog+0xb3/0xd0 [xfs]
 [<ffffffffa01cd156>] _xfs_log_force+0x126/0x2a0 [xfs]
 [<ffffffff810916d6>] ? down_trylock+0x36/0x50
 [<ffffffffa01cd2e8>] xfs_log_force+0x18/0x40 [xfs]
 [<ffffffffa01760b0>] xfs_buf_trylock+0xd0/0xe0 [xfs]
 [<ffffffffa01cf1c8>] xfs_buf_item_trylock+0x58/0xc0 [xfs]
 [<ffffffffa01d177a>] xfsaild_push+0x24a/0x680 [xfs]
 [<ffffffffa01d1c12>] xfsaild+0x62/0xc0 [xfs]
 [<ffffffffa01d1bb0>] ? xfsaild_push+0x680/0x680 [xfs]
 [<ffffffff8108b78c>] kthread+0x8c/0xa0
 [<ffffffff8166ae74>] kernel_thread_helper+0x4/0x10
 [<ffffffff8108b700>] ? flush_kthread_worker+0xa0/0xa0
 [<ffffffff8166ae70>] ? gs_change+0x13/0x13
Code: 90 90 90 90 90 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 13 66 0f 1f 84 00 00 00 00 00 f3 90 0f b7 07 <66> 39 d0 75 f6 5d c3 0f 1f 40 00 8b 17 55 31 c0 48 89 e5 89 d1
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01d13d4>] xfs_ail_min_lsn+0x24/0x60 [xfs]
 [<ffffffffa01cc3fe>] xlog_assign_tail_lsn+0x1e/0x40 [xfs]
 [<ffffffffa01cc4d3>] xlog_state_release_iclog+0xb3/0xd0 [xfs]
 [<ffffffffa01cd156>] _xfs_log_force+0x126/0x2a0 [xfs]
 [<ffffffff810916d6>] ? down_trylock+0x36/0x50
 [<ffffffffa01cd2e8>] xfs_log_force+0x18/0x40 [xfs]
 [<ffffffffa01760b0>] xfs_buf_trylock+0xd0/0xe0 [xfs]
 [<ffffffffa01cf1c8>] xfs_buf_item_trylock+0x58/0xc0 [xfs]
 [<ffffffffa01d177a>] xfsaild_push+0x24a/0x680 [xfs]
 [<ffffffffa01d1c12>] xfsaild+0x62/0xc0 [xfs]
 [<ffffffffa01d1bb0>] ? xfsaild_push+0x680/0x680 [xfs]
 [<ffffffff8108b78c>] kthread+0x8c/0xa0
 [<ffffffff8166ae74>] kernel_thread_helper+0x4/0x10
 [<ffffffff8108b700>] ? flush_kthread_worker+0xa0/0xa0
 [<ffffffff8166ae70>] ? gs_change+0x13/0x13


BUG: soft lockup - CPU#0 stuck for 22s! [kworker/0:3:27580]
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]
CPU 0
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]

Pid: 27580, comm: kworker/0:3 Tainted: G        WC   3.2.0-51-generic #77-Ubuntu Dell Inc. PowerEdge R720xd/0X6H47
RIP: 0010:[<ffffffff8103ebc5>]  [<ffffffff8103ebc5>] __ticket_spin_lock+0x25/0x30
RSP: 0018:ffff8801aeae3d40  EFLAGS: 00000293
RAX: 00000000000007e5 RBX: ffff8801aeae3cd0 RCX: 0000000000000003
RDX: 00000000000007e7 RSI: ffff880823a117d0 RDI: ffff880824b32e78
RBP: ffff8801aeae3d40 R08: ffff8801aeae2000 R09: 0000000000000093
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000002
R13: ffff88042fc137c0 R14: ffff880425a37a00 R15: 000000000000014b
FS:  0000000000000000(0000) GS:ffff88042fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007effa8b52ef7 CR3: 0000000001c05000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:3 (pid: 27580, threadinfo ffff8801aeae2000, task ffff8800a5015c00)
Stack:
 ffff8801aeae3d50 ffffffff816606be ffff8801aeae3d80 ffffffffa01cfe1b
 ffff8806e3d3dc48 ffff8800339f1600 ffff880421b76940 ffff8801bbe53500
 ffff8801aeae3da0 ffffffffa01cef1c 0000000000000000 ffff880421b76940
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01cfe1b>] xfs_buf_iodone+0x2b/0x60 [xfs]
 [<ffffffffa01cef1c>] xfs_buf_do_callbacks+0x3c/0x50 [xfs]
 [<ffffffffa01cef96>] xfs_buf_iodone_callbacks+0x46/0x220 [xfs]
 [<ffffffffa0176843>] xfs_buf_iodone_work+0x23/0x50 [xfs]
 [<ffffffff81085e37>] process_one_work+0x127/0x470
 [<ffffffff81086f44>] worker_thread+0x164/0x370
 [<ffffffff81086de0>] ? manage_workers.isra.31+0x130/0x130
 [<ffffffff8108b78c>] kthread+0x8c/0xa0
 [<ffffffff8166ae74>] kernel_thread_helper+0x4/0x10
 [<ffffffff8108b700>] ? flush_kthread_worker+0xa0/0xa0
 [<ffffffff8166ae70>] ? gs_change+0x13/0x13
Code: 90 90 90 90 90 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 13 66 0f 1f 84 00 00 00 00 00 f3 90 0f b7 07 <66> 39 d0 75 f6 5d c3 0f 1f 40 00 8b 17 55 31 c0 48 89 e5 89 d1
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01cfe1b>] xfs_buf_iodone+0x2b/0x60 [xfs]
 [<ffffffffa01cef1c>] xfs_buf_do_callbacks+0x3c/0x50 [xfs]
 [<ffffffffa01cef96>] xfs_buf_iodone_callbacks+0x46/0x220 [xfs]
 [<ffffffffa0176843>] xfs_buf_iodone_work+0x23/0x50 [xfs]
 [<ffffffff81085e37>] process_one_work+0x127/0x470
 [<ffffffff81086f44>] worker_thread+0x164/0x370
 [<ffffffff81086de0>] ? manage_workers.isra.31+0x130/0x130
 [<ffffffff8108b78c>] kthread+0x8c/0xa0
 [<ffffffff8166ae74>] kernel_thread_helper+0x4/0x10
 [<ffffffff8108b700>] ? flush_kthread_worker+0xa0/0xa0
 [<ffffffff8166ae70>] ? gs_change+0x13/0x13


BUG: soft lockup - CPU#7 stuck for 23s! [swift-object-se:4340]
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]
CPU 7
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]

Pid: 4340, comm: swift-object-se Tainted: G        WC   3.2.0-51-generic #77-Ubuntu Dell Inc. PowerEdge R720xd/0X6H47
RIP: 0010:[<ffffffff8103ebc5>]  [<ffffffff8103ebc5>] __ticket_spin_lock+0x25/0x30
RSP: 0018:ffff8803362a1498  EFLAGS: 00000297
RAX: 0000000000007c1c RBX: 0000000700000006 RCX: ffff8804186a7ce8
RDX: 0000000000007c1d RSI: ffff8804112c9700 RDI: ffff88082420fea8
RBP: ffff8803362a1498 R08: ffff8803362a15d0 R09: ffff8803362a15dc
R10: 000000000000121c R11: 0000000000000006 R12: ffffffffa01a6587
R13: ffff8803362a1428 R14: ffff8803362a1544 R15: 0000000000000000
FS:  00007f3db1ffb700(0000) GS:ffff88083fc60000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3dbcd1b000 CR3: 00000002955f6000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swift-object-se (pid: 4340, threadinfo ffff8803362a0000, task ffff8804112c9700)
Stack:
 ffff8803362a14a8 ffffffff816606be ffff8803362a1548 ffffffffa01cc548
 ffff8803362a15dc ffff8803362a15d0 ffff8803362a15c0 000013248103ec59
 00000000000144c0 ffff8804112c9700 0000000000000286 ffff880556253d78
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01cc548>] xlog_state_get_iclog_space+0x58/0x2e0 [xfs]
 [<ffffffff810918a2>] ? up+0x32/0x50
 [<ffffffff8116655d>] ? kmem_cache_alloc+0x11d/0x140
 [<ffffffffa01ccb99>] xlog_write+0xe9/0x400 [xfs]
 [<ffffffffa018c877>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
 [<ffffffffa01ce40c>] xlog_cil_push+0x20c/0x380 [xfs]
 [<ffffffffa01ced2e>] xlog_cil_force_lsn+0x10e/0x120 [xfs]
 [<ffffffffa01bd97e>] ? xfs_iext_insert+0x7e/0x100 [xfs]
 [<ffffffffa019b662>] ? xfs_bmap_add_extent_hole_real+0x112/0xad0 [xfs]
 [<ffffffffa01cd098>] _xfs_log_force+0x68/0x2a0 [xfs]
 [<ffffffffa01cd2e8>] xfs_log_force+0x18/0x40 [xfs]
 [<ffffffffa01760b0>] xfs_buf_trylock+0xd0/0xe0 [xfs]
 [<ffffffffa017621b>] ? _xfs_buf_find+0x4b/0x240 [xfs]
 [<ffffffffa017628c>] _xfs_buf_find+0xbc/0x240 [xfs]
 [<ffffffffa0176694>] xfs_buf_get+0x34/0x1c0 [xfs]
 [<ffffffffa01d2507>] xfs_trans_get_buf+0x127/0x1a0 [xfs]
 [<ffffffffa01abce9>] xfs_da_do_buf+0x3d9/0x630 [xfs]
 [<ffffffffa01abfd1>] xfs_da_get_buf+0x21/0x30 [xfs]
 [<ffffffffa01949b7>] xfs_attr_leaf_create.isra.2+0x47/0x100 [xfs]
 [<ffffffffa0197264>] xfs_attr_shortform_to_leaf+0x104/0x240 [xfs]
 [<ffffffffa018c877>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
 [<ffffffffa018c929>] ? kmem_zone_zalloc+0x39/0x50 [xfs]
 [<ffffffffa0193306>] xfs_attr_set_int+0x406/0x4e0 [xfs]
 [<ffffffffa019394f>] xfs_attr_set+0x7f/0x90 [xfs]
 [<ffffffffa0188057>] xfs_xattr_set+0x47/0x60 [xfs]
 [<ffffffff8119d4fb>] generic_setxattr+0x6b/0x90
 [<ffffffff8119dd5b>] __vfs_setxattr_noperm+0x7b/0x1c0
 [<ffffffff812decce>] ? evm_inode_setxattr+0xe/0x10
 [<ffffffff8119df5c>] vfs_setxattr+0xbc/0xc0
 [<ffffffff8119e026>] setxattr+0xc6/0x120
 [<ffffffff811b8a62>] ? fsnotify+0x1c2/0x2a0
 [<ffffffff810a1e6c>] ? do_futex+0x7c/0x1b0
 [<ffffffff8119e43b>] sys_fsetxattr+0xbb/0xe0
 [<ffffffff81668d02>] system_call_fastpath+0x16/0x1b
Code: 90 90 90 90 90 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 13 66 0f 1f 84 00 00 00 00 00 f3 90 0f b7 07 <66> 39 d0 75 f6 5d c3 0f 1f 40 00 8b 17 55 31 c0 48 89 e5 89 d1
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01cc548>] xlog_state_get_iclog_space+0x58/0x2e0 [xfs]
 [<ffffffff810918a2>] ? up+0x32/0x50
 [<ffffffff8116655d>] ? kmem_cache_alloc+0x11d/0x140
 [<ffffffffa01ccb99>] xlog_write+0xe9/0x400 [xfs]
 [<ffffffffa018c877>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
 [<ffffffffa01ce40c>] xlog_cil_push+0x20c/0x380 [xfs]
 [<ffffffffa01ced2e>] xlog_cil_force_lsn+0x10e/0x120 [xfs]
 [<ffffffffa01bd97e>] ? xfs_iext_insert+0x7e/0x100 [xfs]
 [<ffffffffa019b662>] ? xfs_bmap_add_extent_hole_real+0x112/0xad0 [xfs]
 [<ffffffffa01cd098>] _xfs_log_force+0x68/0x2a0 [xfs]
 [<ffffffffa01cd2e8>] xfs_log_force+0x18/0x40 [xfs]
 [<ffffffffa01760b0>] xfs_buf_trylock+0xd0/0xe0 [xfs]
 [<ffffffffa017621b>] ? _xfs_buf_find+0x4b/0x240 [xfs]
 [<ffffffffa017628c>] _xfs_buf_find+0xbc/0x240 [xfs]
 [<ffffffffa0176694>] xfs_buf_get+0x34/0x1c0 [xfs]
 [<ffffffffa01d2507>] xfs_trans_get_buf+0x127/0x1a0 [xfs]
 [<ffffffffa01abce9>] xfs_da_do_buf+0x3d9/0x630 [xfs]
 [<ffffffffa01abfd1>] xfs_da_get_buf+0x21/0x30 [xfs]
 [<ffffffffa01949b7>] xfs_attr_leaf_create.isra.2+0x47/0x100 [xfs]
 [<ffffffffa0197264>] xfs_attr_shortform_to_leaf+0x104/0x240 [xfs]
 [<ffffffffa018c877>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
 [<ffffffffa018c929>] ? kmem_zone_zalloc+0x39/0x50 [xfs]
 [<ffffffffa0193306>] xfs_attr_set_int+0x406/0x4e0 [xfs]
 [<ffffffffa019394f>] xfs_attr_set+0x7f/0x90 [xfs]
 [<ffffffffa0188057>] xfs_xattr_set+0x47/0x60 [xfs]
 [<ffffffff8119d4fb>] generic_setxattr+0x6b/0x90
 [<ffffffff8119dd5b>] __vfs_setxattr_noperm+0x7b/0x1c0
 [<ffffffff812decce>] ? evm_inode_setxattr+0xe/0x10
 [<ffffffff8119df5c>] vfs_setxattr+0xbc/0xc0
 [<ffffffff8119e026>] setxattr+0xc6/0x120
 [<ffffffff811b8a62>] ? fsnotify+0x1c2/0x2a0
 [<ffffffff810a1e6c>] ? do_futex+0x7c/0x1b0
 [<ffffffff8119e43b>] sys_fsetxattr+0xbb/0xe0
 [<ffffffff81668d02>] system_call_fastpath+0x16/0x1b


BUG: soft lockup - CPU#9 stuck for 23s! [swift-object-se:4362]
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]
CPU 9
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]

Pid: 4362, comm: swift-object-se Tainted: G        WC   3.2.0-51-generic #77-Ubuntu Dell Inc. PowerEdge R720xd/0X6H47
RIP: 0010:[<ffffffff8103ebc5>]  [<ffffffff8103ebc5>] __ticket_spin_lock+0x25/0x30
RSP: 0018:ffff8803df863b68  EFLAGS: 00000293
RAX: 0000000000007c1c RBX: ffffffff811641cf RCX: ffff880418632708
RDX: 0000000000007c1f RSI: ffff880110e99700 RDI: ffff88082420fea8
RBP: ffff8803df863b68 R08: ffff8803df863ca0 R09: ffff8803df863cac
R10: 00000000000021c4 R11: 000000000000000a R12: ffff8803df863b50
R13: ffff88082420fe00 R14: ffff880808307a40 R15: ffff8803df863ae8
FS:  00007f3d6f7fe700(0000) GS:ffff88083fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3dbcd1b000 CR3: 00000004140bf000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swift-object-se (pid: 4362, threadinfo ffff8803df862000, task ffff880110e99700)
Stack:
 ffff8803df863b78 ffffffff816606be ffff8803df863c18 ffffffffa01cc548
 ffff8803df863cac ffff8803df863ca0 ffff8803df863c90 000022e4244506c0
 00000000000144c0 ffff880110e99700 ffff8803df863df5 000000000000000e
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01cc548>] xlog_state_get_iclog_space+0x58/0x2e0 [xfs]
 [<ffffffff8116655d>] ? kmem_cache_alloc+0x11d/0x140
 [<ffffffffa01ccb99>] xlog_write+0xe9/0x400 [xfs]
 [<ffffffffa018c877>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
 [<ffffffffa01ce40c>] xlog_cil_push+0x20c/0x380 [xfs]
 [<ffffffffa01ced2e>] xlog_cil_force_lsn+0x10e/0x120 [xfs]
 [<ffffffff8119e031>] ? setxattr+0xd1/0x120
 [<ffffffffa01cd367>] _xfs_log_force_lsn+0x57/0x2e0 [xfs]
 [<ffffffff8165f986>] ? down_read+0x16/0x2b
 [<ffffffffa017d116>] ? xfs_iunlock+0xe6/0x150 [xfs]
 [<ffffffffa0179123>] ? xfs_file_fsync+0x113/0x300 [xfs]
 [<ffffffffa017920c>] xfs_file_fsync+0x1fc/0x300 [xfs]
 [<ffffffff811a8c56>] do_fsync+0x56/0x80
 [<ffffffff811a8f80>] sys_fsync+0x10/0x20
 [<ffffffff81668d02>] system_call_fastpath+0x16/0x1b
Code: 90 90 90 90 90 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 13 66 0f 1f 84 00 00 00 00 00 f3 90 0f b7 07 <66> 39 d0 75 f6 5d c3 0f 1f 40 00 8b 17 55 31 c0 48 89 e5 89 d1
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01cc548>] xlog_state_get_iclog_space+0x58/0x2e0 [xfs]
 [<ffffffff8116655d>] ? kmem_cache_alloc+0x11d/0x140
 [<ffffffffa01ccb99>] xlog_write+0xe9/0x400 [xfs]
 [<ffffffffa018c877>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
 [<ffffffffa01ce40c>] xlog_cil_push+0x20c/0x380 [xfs]
 [<ffffffffa01ced2e>] xlog_cil_force_lsn+0x10e/0x120 [xfs]
 [<ffffffff8119e031>] ? setxattr+0xd1/0x120
 [<ffffffffa01cd367>] _xfs_log_force_lsn+0x57/0x2e0 [xfs]
 [<ffffffff8165f986>] ? down_read+0x16/0x2b
 [<ffffffffa017d116>] ? xfs_iunlock+0xe6/0x150 [xfs]
 [<ffffffffa0179123>] ? xfs_file_fsync+0x113/0x300 [xfs]
 [<ffffffffa017920c>] xfs_file_fsync+0x1fc/0x300 [xfs]
 [<ffffffff811a8c56>] do_fsync+0x56/0x80
 [<ffffffff811a8f80>] sys_fsync+0x10/0x20
 [<ffffffff81668d02>] system_call_fastpath+0x16/0x1b


BUG: soft lockup - CPU#28 stuck for 22s! [swift-object-se:4354]
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]
CPU 28
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]

Pid: 4354, comm: swift-object-se Tainted: G        WC   3.2.0-51-generic #77-Ubuntu Dell Inc. PowerEdge R720xd/0X6H47
RIP: 0010:[<ffffffff8103ebc5>]  [<ffffffff8103ebc5>] __ticket_spin_lock+0x25/0x30
RSP: 0018:ffff8802a0d95b68  EFLAGS: 00000293
RAX: 0000000000007c1c RBX: ffffffff811641cf RCX: ffff88080830a960
RDX: 0000000000007c1e RSI: ffff8801c6235c00 RDI: ffff88082420fea8
RBP: ffff8802a0d95b68 R08: ffff8802a0d95ca0 R09: ffff8802a0d95cac
R10: 0000000000002134 R11: 000000000000000a R12: ffff8802a0d95b50
R13: ffff88082420fe00 R14: ffff880424d676f8 R15: ffff8802a0d95ae8
FS:  00007f3d8dffb700(0000) GS:ffff88042fdc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3dbcd1b000 CR3: 00000004140bf000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swift-object-se (pid: 4354, threadinfo ffff8802a0d94000, task ffff8801c6235c00)
Stack:
 ffff8802a0d95b78 ffffffff816606be ffff8802a0d95c18 ffffffffa01cc548
 ffff8802a0d95cac ffff8802a0d95ca0 ffff8802a0d95c90 000022546322c000
 00000000000144c0 ffff8801c6235c00 ffff8802a0d95df5 000000000000000e
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01cc548>] xlog_state_get_iclog_space+0x58/0x2e0 [xfs]
 [<ffffffff8116655d>] ? kmem_cache_alloc+0x11d/0x140
 [<ffffffffa01ccb99>] xlog_write+0xe9/0x400 [xfs]
 [<ffffffffa018c877>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
 [<ffffffffa01ce40c>] xlog_cil_push+0x20c/0x380 [xfs]
 [<ffffffffa01ced2e>] xlog_cil_force_lsn+0x10e/0x120 [xfs]
 [<ffffffff8119e031>] ? setxattr+0xd1/0x120
 [<ffffffffa01cd367>] _xfs_log_force_lsn+0x57/0x2e0 [xfs]
 [<ffffffff8165f986>] ? down_read+0x16/0x2b
 [<ffffffffa017d116>] ? xfs_iunlock+0xe6/0x150 [xfs]
 [<ffffffffa0179123>] ? xfs_file_fsync+0x113/0x300 [xfs]
 [<ffffffffa017920c>] xfs_file_fsync+0x1fc/0x300 [xfs]
 [<ffffffff811a8c56>] do_fsync+0x56/0x80
 [<ffffffff811a8f80>] sys_fsync+0x10/0x20
 [<ffffffff81668d02>] system_call_fastpath+0x16/0x1b
Code: 90 90 90 90 90 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 13 66 0f 1f 84 00 00 00 00 00 f3 90 0f b7 07 <66> 39 d0 75 f6 5d c3 0f 1f 40 00 8b 17 55 31 c0 48 89 e5 89 d1
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01cc548>] xlog_state_get_iclog_space+0x58/0x2e0 [xfs]
 [<ffffffff8116655d>] ? kmem_cache_alloc+0x11d/0x140
 [<ffffffffa01ccb99>] xlog_write+0xe9/0x400 [xfs]
 [<ffffffffa018c877>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
 [<ffffffffa01ce40c>] xlog_cil_push+0x20c/0x380 [xfs]
 [<ffffffffa01ced2e>] xlog_cil_force_lsn+0x10e/0x120 [xfs]
 [<ffffffff8119e031>] ? setxattr+0xd1/0x120
 [<ffffffffa01cd367>] _xfs_log_force_lsn+0x57/0x2e0 [xfs]
 [<ffffffff8165f986>] ? down_read+0x16/0x2b
 [<ffffffffa017d116>] ? xfs_iunlock+0xe6/0x150 [xfs]
 [<ffffffffa0179123>] ? xfs_file_fsync+0x113/0x300 [xfs]
 [<ffffffffa017920c>] xfs_file_fsync+0x1fc/0x300 [xfs]
 [<ffffffff811a8c56>] do_fsync+0x56/0x80
 [<ffffffff811a8f80>] sys_fsync+0x10/0x20
 [<ffffffff81668d02>] system_call_fastpath+0x16/0x1b

BUG: soft lockup - CPU#30 stuck for 22s! [xfsaild/sdf1:2876]
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]
CPU 30
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]

Pid: 2876, comm: xfsaild/sdf1 Tainted: G        WC   3.2.0-51-generic #77-Ubuntu Dell Inc. PowerEdge R720xd/0X6H47
RIP: 0010:[<ffffffff8103ebc5>]  [<ffffffff8103ebc5>] __ticket_spin_lock+0x25/0x30
RSP: 0018:ffff88041116bc20  EFLAGS: 00000297
RAX: 00000000000007e5 RBX: 0000000000000000 RCX: 0000000000000231
RDX: 00000000000007e6 RSI: ffff88082420fea8 RDI: ffff880824b32e78
RBP: ffff88041116bc20 R08: 0000000000000001 R09: 0000000000000000
R10: ffff88041116ba24 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8807eeedad80 R14: 0003000100000000 R15: ffff88041116bb88
FS:  0000000000000000(0000) GS:ffff88042fde0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f3dbcd1b000 CR3: 0000000001c05000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process xfsaild/sdf1 (pid: 2876, threadinfo ffff88041116a000, task ffff880819d35c00)
Stack:
 ffff88041116bc30 ffffffff816606be ffff88041116bc50 ffffffffa01d13d4
 ffff88082420fe00 ffff88082420fe00 ffff88041116bc70 ffffffffa01cc3fe
 ffff88041116bcc0 ffff88042121c800 ffff88041116bca0 ffffffffa01cc4d3
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01d13d4>] xfs_ail_min_lsn+0x24/0x60 [xfs]
 [<ffffffffa01cc3fe>] xlog_assign_tail_lsn+0x1e/0x40 [xfs]
 [<ffffffffa01cc4d3>] xlog_state_release_iclog+0xb3/0xd0 [xfs]
 [<ffffffffa01cd156>] _xfs_log_force+0x126/0x2a0 [xfs]
 [<ffffffff810916d6>] ? down_trylock+0x36/0x50
 [<ffffffffa01cd2e8>] xfs_log_force+0x18/0x40 [xfs]
 [<ffffffffa01760b0>] xfs_buf_trylock+0xd0/0xe0 [xfs]
 [<ffffffffa01cf1c8>] xfs_buf_item_trylock+0x58/0xc0 [xfs]
 [<ffffffffa01d177a>] xfsaild_push+0x24a/0x680 [xfs]
 [<ffffffffa01d1c12>] xfsaild+0x62/0xc0 [xfs]
 [<ffffffffa01d1bb0>] ? xfsaild_push+0x680/0x680 [xfs]
 [<ffffffff8108b78c>] kthread+0x8c/0xa0
 [<ffffffff8166ae74>] kernel_thread_helper+0x4/0x10
 [<ffffffff8108b700>] ? flush_kthread_worker+0xa0/0xa0
 [<ffffffff8166ae70>] ? gs_change+0x13/0x13
Code: 90 90 90 90 90 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 13 66 0f 1f 84 00 00 00 00 00 f3 90 0f b7 07 <66> 39 d0 75 f6 5d c3 0f 1f 40 00 8b 17 55 31 c0 48 89 e5 89 d1
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01d13d4>] xfs_ail_min_lsn+0x24/0x60 [xfs]
 [<ffffffffa01cc3fe>] xlog_assign_tail_lsn+0x1e/0x40 [xfs]
 [<ffffffffa01cc4d3>] xlog_state_release_iclog+0xb3/0xd0 [xfs]
 [<ffffffffa01cd156>] _xfs_log_force+0x126/0x2a0 [xfs]
 [<ffffffff810916d6>] ? down_trylock+0x36/0x50
 [<ffffffffa01cd2e8>] xfs_log_force+0x18/0x40 [xfs]
 [<ffffffffa01760b0>] xfs_buf_trylock+0xd0/0xe0 [xfs]
 [<ffffffffa01cf1c8>] xfs_buf_item_trylock+0x58/0xc0 [xfs]
 [<ffffffffa01d177a>] xfsaild_push+0x24a/0x680 [xfs]
 [<ffffffffa01d1c12>] xfsaild+0x62/0xc0 [xfs]
 [<ffffffffa01d1bb0>] ? xfsaild_push+0x680/0x680 [xfs]
 [<ffffffff8108b78c>] kthread+0x8c/0xa0
 [<ffffffff8166ae74>] kernel_thread_helper+0x4/0x10
 [<ffffffff8108b700>] ? flush_kthread_worker+0xa0/0xa0
 [<ffffffff8166ae70>] ? gs_change+0x13/0x13


BUG: soft lockup - CPU#0 stuck for 22s! [kworker/0:3:27580]
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]
CPU 0
Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu xfs vesafb 8021q garp bonding joydev bridge stp shpchp dcdbas sb_edac mac_hid edac_core wmi acpi_power_meter lp mei(C) parport usbhid hid ixgbe mdio igb megaraid_sas dca [last unloaded: ipmi_si]

Pid: 27580, comm: kworker/0:3 Tainted: G        WC   3.2.0-51-generic #77-Ubuntu Dell Inc. PowerEdge R720xd/0X6H47
RIP: 0010:[<ffffffff8103ebc2>]  [<ffffffff8103ebc2>] __ticket_spin_lock+0x22/0x30
RSP: 0018:ffff8801aeae3d40  EFLAGS: 00000293
RAX: 00000000000007e5 RBX: ffff8801aeae3cd0 RCX: 0000000000000003
RDX: 00000000000007e7 RSI: ffff880823a117d0 RDI: ffff880824b32e78
RBP: ffff8801aeae3d40 R08: ffff8801aeae2000 R09: 0000000000000093
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000002
R13: ffff88042fc137c0 R14: ffff880425a37a00 R15: 000000000000014b
FS:  0000000000000000(0000) GS:ffff88042fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007effa8b52ef7 CR3: 0000000001c05000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:3 (pid: 27580, threadinfo ffff8801aeae2000, task ffff8800a5015c00)
Stack:
 ffff8801aeae3d50 ffffffff816606be ffff8801aeae3d80 ffffffffa01cfe1b
 ffff8806e3d3dc48 ffff8800339f1600 ffff880421b76940 ffff8801bbe53500
 ffff8801aeae3da0 ffffffffa01cef1c 0000000000000000 ffff880421b76940
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01cfe1b>] xfs_buf_iodone+0x2b/0x60 [xfs]
 [<ffffffffa01cef1c>] xfs_buf_do_callbacks+0x3c/0x50 [xfs]
 [<ffffffffa01cef96>] xfs_buf_iodone_callbacks+0x46/0x220 [xfs]
 [<ffffffffa0176843>] xfs_buf_iodone_work+0x23/0x50 [xfs]
 [<ffffffff81085e37>] process_one_work+0x127/0x470
 [<ffffffff81086f44>] worker_thread+0x164/0x370
 [<ffffffff81086de0>] ? manage_workers.isra.31+0x130/0x130
 [<ffffffff8108b78c>] kthread+0x8c/0xa0
 [<ffffffff8166ae74>] kernel_thread_helper+0x4/0x10
 [<ffffffff8108b700>] ? flush_kthread_worker+0xa0/0xa0
 [<ffffffff8166ae70>] ? gs_change+0x13/0x13
Code: 90 90 90 90 90 90 90 90 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 13 66 0f 1f 84 00 00 00 00 00 f3 90 <0f> b7 07 66 39 d0 75 f6 5d c3 0f 1f 40 00 8b 17 55 31 c0 48 89
Call Trace:
 [<ffffffff816606be>] _raw_spin_lock+0xe/0x20
 [<ffffffffa01cfe1b>] xfs_buf_iodone+0x2b/0x60 [xfs]
 [<ffffffffa01cef1c>] xfs_buf_do_callbacks+0x3c/0x50 [xfs]
 [<ffffffffa01cef96>] xfs_buf_iodone_callbacks+0x46/0x220 [xfs]
 [<ffffffffa0176843>] xfs_buf_iodone_work+0x23/0x50 [xfs]
 [<ffffffff81085e37>] process_one_work+0x127/0x470
 [<ffffffff81086f44>] worker_thread+0x164/0x370
 [<ffffffff81086de0>] ? manage_workers.isra.31+0x130/0x130
 [<ffffffff8108b78c>] kthread+0x8c/0xa0
 [<ffffffff8166ae74>] kernel_thread_helper+0x4/0x10
 [<ffffffff8108b700>] ? flush_kthread_worker+0xa0/0xa0
 [<ffffffff8166ae70>] ? gs_change+0x13/0x13

------=_Part_8186919_654588180.1412777666395
Content-Type: text/plain; name=soft_lockup.txt
Content-Disposition: attachment; filename=soft_lockup.txt
Content-Transfer-Encoding: base64

QlVHOiBzb2Z0IGxvY2t1cCAtIENQVSMyOCBzdHVjayBmb3IgMjJzISBbc3dpZnQtb2JqZWN0LXNl
OjQzNTRdDQpNb2R1bGVzIGxpbmtlZCBpbjogaXBtaV9zaSBtcHQyc2FzIHNjc2lfdHJhbnNwb3J0
X3NhcyByYWlkX2NsYXNzIG1wdGN0bCBtcHRiYXNlIGlwbWlfZGV2aW50ZiBpcG1pX21zZ2hhbmRs
ZXIgZGVsbF9yYnUgeGZzIHZlc2FmYiA4MDIxcSBnYXJwIGJvbmRpbmcgam95ZGV2IGJyaWRnZSBz
dHAgc2hwY2hwIGRjZGJhcyBzYl9lZGFjIG1hY19oaWQgZWRhY19jb3JlIHdtaSBhY3BpX3Bvd2Vy
X21ldGVyIGxwIG1laShDKSBwYXJwb3J0IHVzYmhpZCBoaWQgaXhnYmUgbWRpbyBpZ2IgbWVnYXJh
aWRfc2FzIGRjYSBbbGFzdCB1bmxvYWRlZDogaXBtaV9zaV0NCkNQVSAyOA0KTW9kdWxlcyBsaW5r
ZWQgaW46IGlwbWlfc2kgbXB0MnNhcyBzY3NpX3RyYW5zcG9ydF9zYXMgcmFpZF9jbGFzcyBtcHRj
dGwgbXB0YmFzZSBpcG1pX2RldmludGYgaXBtaV9tc2doYW5kbGVyIGRlbGxfcmJ1IHhmcyB2ZXNh
ZmIgODAyMXEgZ2FycCBib25kaW5nIGpveWRldiBicmlkZ2Ugc3RwIHNocGNocCBkY2RiYXMgc2Jf
ZWRhYyBtYWNfaGlkIGVkYWNfY29yZSB3bWkgYWNwaV9wb3dlcl9tZXRlciBscCBtZWkoQykgcGFy
cG9ydCB1c2JoaWQgaGlkIGl4Z2JlIG1kaW8gaWdiIG1lZ2FyYWlkX3NhcyBkY2EgW2xhc3QgdW5s
b2FkZWQ6IGlwbWlfc2ldDQoNClBpZDogNDM1NCwgY29tbTogc3dpZnQtb2JqZWN0LXNlIFRhaW50
ZWQ6IEcgICAgICAgIFdDICAgMy4yLjAtNTEtZ2VuZXJpYyAjNzctVWJ1bnR1IERlbGwgSW5jLiBQ
b3dlckVkZ2UgUjcyMHhkLzBYNkg0Nw0KUklQOiAwMDEwOls8ZmZmZmZmZmY4MTAzZWJjNT5dICBb
PGZmZmZmZmZmODEwM2ViYzU+XSBfX3RpY2tldF9zcGluX2xvY2srMHgyNS8weDMwDQpSU1A6IDAw
MTg6ZmZmZjg4MDJhMGQ5NWI2OCAgRUZMQUdTOiAwMDAwMDI5Mw0KUkFYOiAwMDAwMDAwMDAwMDA3
YzFjIFJCWDogZmZmZmZmZmY4MTE2NDFjZiBSQ1g6IGZmZmY4ODA4MDgzMGE5NjANClJEWDogMDAw
MDAwMDAwMDAwN2MxZSBSU0k6IGZmZmY4ODAxYzYyMzVjMDAgUkRJOiBmZmZmODgwODI0MjBmZWE4
DQpSQlA6IGZmZmY4ODAyYTBkOTViNjggUjA4OiBmZmZmODgwMmEwZDk1Y2EwIFIwOTogZmZmZjg4
MDJhMGQ5NWNhYw0KUjEwOiAwMDAwMDAwMDAwMDAyMTM0IFIxMTogMDAwMDAwMDAwMDAwMDAwYSBS
MTI6IGZmZmY4ODAyYTBkOTViNTANClIxMzogZmZmZjg4MDgyNDIwZmUwMCBSMTQ6IGZmZmY4ODA0
MjRkNjc2ZjggUjE1OiBmZmZmODgwMmEwZDk1YWU4DQpGUzogIDAwMDA3ZjNkOGRmZmI3MDAoMDAw
MCkgR1M6ZmZmZjg4MDQyZmRjMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwDQpDUzog
IDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzDQpDUjI6IDAwMDA3
ZjNkYmNkMWIwMDAgQ1IzOiAwMDAwMDAwNDE0MGJmMDAwIENSNDogMDAwMDAwMDAwMDA0MDZlMA0K
RFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAw
MDAwMDAwMDANCkRSMzogMDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZmZjBmZjAgRFI3
OiAwMDAwMDAwMDAwMDAwNDAwDQpQcm9jZXNzIHN3aWZ0LW9iamVjdC1zZSAocGlkOiA0MzU0LCB0
aHJlYWRpbmZvIGZmZmY4ODAyYTBkOTQwMDAsIHRhc2sgZmZmZjg4MDFjNjIzNWMwMCkNClN0YWNr
Og0KIGZmZmY4ODAyYTBkOTViNzggZmZmZmZmZmY4MTY2MDZiZSBmZmZmODgwMmEwZDk1YzE4IGZm
ZmZmZmZmYTAxY2M1NDgNCiBmZmZmODgwMmEwZDk1Y2FjIGZmZmY4ODAyYTBkOTVjYTAgZmZmZjg4
MDJhMGQ5NWM5MCAwMDAwMjI1NDYzMjJjMDAwDQogMDAwMDAwMDAwMDAxNDRjMCBmZmZmODgwMWM2
MjM1YzAwIGZmZmY4ODAyYTBkOTVkZjUgMDAwMDAwMDAwMDAwMDAwZQ0KQ2FsbCBUcmFjZToNCiBb
PGZmZmZmZmZmODE2NjA2YmU+XSBfcmF3X3NwaW5fbG9jaysweGUvMHgyMA0KIFs8ZmZmZmZmZmZh
MDFjYzU0OD5dIHhsb2dfc3RhdGVfZ2V0X2ljbG9nX3NwYWNlKzB4NTgvMHgyZTAgW3hmc10NCiBb
PGZmZmZmZmZmODExNjY1NWQ+XSA/IGttZW1fY2FjaGVfYWxsb2MrMHgxMWQvMHgxNDANCiBbPGZm
ZmZmZmZmYTAxY2NiOTk+XSB4bG9nX3dyaXRlKzB4ZTkvMHg0MDAgW3hmc10NCiBbPGZmZmZmZmZm
YTAxOGM4Nzc+XSA/IGttZW1fem9uZV9hbGxvYysweDY3LzB4ZTAgW3hmc10NCiBbPGZmZmZmZmZm
YTAxY2U0MGM+XSB4bG9nX2NpbF9wdXNoKzB4MjBjLzB4MzgwIFt4ZnNdDQogWzxmZmZmZmZmZmEw
MWNlZDJlPl0geGxvZ19jaWxfZm9yY2VfbHNuKzB4MTBlLzB4MTIwIFt4ZnNdDQogWzxmZmZmZmZm
ZjgxMTllMDMxPl0gPyBzZXR4YXR0cisweGQxLzB4MTIwDQogWzxmZmZmZmZmZmEwMWNkMzY3Pl0g
X3hmc19sb2dfZm9yY2VfbHNuKzB4NTcvMHgyZTAgW3hmc10NCiBbPGZmZmZmZmZmODE2NWY5ODY+
XSA/IGRvd25fcmVhZCsweDE2LzB4MmINCiBbPGZmZmZmZmZmYTAxN2QxMTY+XSA/IHhmc19pdW5s
b2NrKzB4ZTYvMHgxNTAgW3hmc10NCiBbPGZmZmZmZmZmYTAxNzkxMjM+XSA/IHhmc19maWxlX2Zz
eW5jKzB4MTEzLzB4MzAwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMTc5MjBjPl0geGZzX2ZpbGVfZnN5
bmMrMHgxZmMvMHgzMDAgW3hmc10NCiBbPGZmZmZmZmZmODExYThjNTY+XSBkb19mc3luYysweDU2
LzB4ODANCiBbPGZmZmZmZmZmODExYThmODA+XSBzeXNfZnN5bmMrMHgxMC8weDIwDQogWzxmZmZm
ZmZmZjgxNjY4ZDAyPl0gc3lzdGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8weDFiDQpDb2RlOiA5MCA5
MCA5MCA5MCA5MCA5MCA1NSBiOCAwMCAwMCAwMSAwMCA0OCA4OSBlNSBmMCAwZiBjMSAwNyA4OSBj
MiBjMSBlYSAxMCA2NiAzOSBjMiA3NCAxMyA2NiAwZiAxZiA4NCAwMCAwMCAwMCAwMCAwMCBmMyA5
MCAwZiBiNyAwNyA8NjY+IDM5IGQwIDc1IGY2IDVkIGMzIDBmIDFmIDQwIDAwIDhiIDE3IDU1IDMx
IGMwIDQ4IDg5IGU1IDg5IGQxDQpDYWxsIFRyYWNlOg0KIFs8ZmZmZmZmZmY4MTY2MDZiZT5dIF9y
YXdfc3Bpbl9sb2NrKzB4ZS8weDIwDQogWzxmZmZmZmZmZmEwMWNjNTQ4Pl0geGxvZ19zdGF0ZV9n
ZXRfaWNsb2dfc3BhY2UrMHg1OC8weDJlMCBbeGZzXQ0KIFs8ZmZmZmZmZmY4MTE2NjU1ZD5dID8g
a21lbV9jYWNoZV9hbGxvYysweDExZC8weDE0MA0KIFs8ZmZmZmZmZmZhMDFjY2I5OT5dIHhsb2df
d3JpdGUrMHhlOS8weDQwMCBbeGZzXQ0KIFs8ZmZmZmZmZmZhMDE4Yzg3Nz5dID8ga21lbV96b25l
X2FsbG9jKzB4NjcvMHhlMCBbeGZzXQ0KIFs8ZmZmZmZmZmZhMDFjZTQwYz5dIHhsb2dfY2lsX3B1
c2grMHgyMGMvMHgzODAgW3hmc10NCiBbPGZmZmZmZmZmYTAxY2VkMmU+XSB4bG9nX2NpbF9mb3Jj
ZV9sc24rMHgxMGUvMHgxMjAgW3hmc10NCiBbPGZmZmZmZmZmODExOWUwMzE+XSA/IHNldHhhdHRy
KzB4ZDEvMHgxMjANCiBbPGZmZmZmZmZmYTAxY2QzNjc+XSBfeGZzX2xvZ19mb3JjZV9sc24rMHg1
Ny8weDJlMCBbeGZzXQ0KIFs8ZmZmZmZmZmY4MTY1Zjk4Nj5dID8gZG93bl9yZWFkKzB4MTYvMHgy
Yg0KIFs8ZmZmZmZmZmZhMDE3ZDExNj5dID8geGZzX2l1bmxvY2srMHhlNi8weDE1MCBbeGZzXQ0K
IFs8ZmZmZmZmZmZhMDE3OTEyMz5dID8geGZzX2ZpbGVfZnN5bmMrMHgxMTMvMHgzMDAgW3hmc10N
CiBbPGZmZmZmZmZmYTAxNzkyMGM+XSB4ZnNfZmlsZV9mc3luYysweDFmYy8weDMwMCBbeGZzXQ0K
IFs8ZmZmZmZmZmY4MTFhOGM1Nj5dIGRvX2ZzeW5jKzB4NTYvMHg4MA0KIFs8ZmZmZmZmZmY4MTFh
OGY4MD5dIHN5c19mc3luYysweDEwLzB4MjANCiBbPGZmZmZmZmZmODE2NjhkMDI+XSBzeXN0ZW1f
Y2FsbF9mYXN0cGF0aCsweDE2LzB4MWINCg0KDQpCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzMwIHN0
dWNrIGZvciAyMnMhIFt4ZnNhaWxkL3NkZjE6Mjg3Nl0NCk1vZHVsZXMgbGlua2VkIGluOiBpcG1p
X3NpIG1wdDJzYXMgc2NzaV90cmFuc3BvcnRfc2FzIHJhaWRfY2xhc3MgbXB0Y3RsIG1wdGJhc2Ug
aXBtaV9kZXZpbnRmIGlwbWlfbXNnaGFuZGxlciBkZWxsX3JidSB4ZnMgdmVzYWZiIDgwMjFxIGdh
cnAgYm9uZGluZyBqb3lkZXYgYnJpZGdlIHN0cCBzaHBjaHAgZGNkYmFzIHNiX2VkYWMgbWFjX2hp
ZCBlZGFjX2NvcmUgd21pIGFjcGlfcG93ZXJfbWV0ZXIgbHAgbWVpKEMpIHBhcnBvcnQgdXNiaGlk
IGhpZCBpeGdiZSBtZGlvIGlnYiBtZWdhcmFpZF9zYXMgZGNhIFtsYXN0IHVubG9hZGVkOiBpcG1p
X3NpXQ0KQ1BVIDMwDQpNb2R1bGVzIGxpbmtlZCBpbjogaXBtaV9zaSBtcHQyc2FzIHNjc2lfdHJh
bnNwb3J0X3NhcyByYWlkX2NsYXNzIG1wdGN0bCBtcHRiYXNlIGlwbWlfZGV2aW50ZiBpcG1pX21z
Z2hhbmRsZXIgZGVsbF9yYnUgeGZzIHZlc2FmYiA4MDIxcSBnYXJwIGJvbmRpbmcgam95ZGV2IGJy
aWRnZSBzdHAgc2hwY2hwIGRjZGJhcyBzYl9lZGFjIG1hY19oaWQgZWRhY19jb3JlIHdtaSBhY3Bp
X3Bvd2VyX21ldGVyIGxwIG1laShDKSBwYXJwb3J0IHVzYmhpZCBoaWQgaXhnYmUgbWRpbyBpZ2Ig
bWVnYXJhaWRfc2FzIGRjYSBbbGFzdCB1bmxvYWRlZDogaXBtaV9zaV0NCg0KUGlkOiAyODc2LCBj
b21tOiB4ZnNhaWxkL3NkZjEgVGFpbnRlZDogRyAgICAgICAgV0MgICAzLjIuMC01MS1nZW5lcmlj
ICM3Ny1VYnVudHUgRGVsbCBJbmMuIFBvd2VyRWRnZSBSNzIweGQvMFg2SDQ3DQpSSVA6IDAwMTA6
WzxmZmZmZmZmZjgxMDNlYmM1Pl0gIFs8ZmZmZmZmZmY4MTAzZWJjNT5dIF9fdGlja2V0X3NwaW5f
bG9jaysweDI1LzB4MzANClJTUDogMDAxODpmZmZmODgwNDExMTZiYzIwICBFRkxBR1M6IDAwMDAw
Mjk3DQpSQVg6IDAwMDAwMDAwMDAwMDA3ZTUgUkJYOiAwMDAwMDAwMDAwMDAwMDAwIFJDWDogMDAw
MDAwMDAwMDAwMDIzMQ0KUkRYOiAwMDAwMDAwMDAwMDAwN2U2IFJTSTogZmZmZjg4MDgyNDIwZmVh
OCBSREk6IGZmZmY4ODA4MjRiMzJlNzgNClJCUDogZmZmZjg4MDQxMTE2YmMyMCBSMDg6IDAwMDAw
MDAwMDAwMDAwMDEgUjA5OiAwMDAwMDAwMDAwMDAwMDAwDQpSMTA6IGZmZmY4ODA0MTExNmJhMjQg
UjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjogMDAwMDAwMDAwMDAwMDAwMQ0KUjEzOiBmZmZmODgw
N2VlZWRhZDgwIFIxNDogMDAwMzAwMDEwMDAwMDAwMCBSMTU6IGZmZmY4ODA0MTExNmJiODgNCkZT
OiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwNDJmZGUwMDAwKDAwMDApIGtubEdT
OjAwMDAwMDAwMDAwMDAwMDANCkNTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAw
MDAwODAwNTAwM2INCkNSMjogMDAwMDdmM2RiY2QxYjAwMCBDUjM6IDAwMDAwMDAwMDFjMDUwMDAg
Q1I0OiAwMDAwMDAwMDAwMDQwNmUwDQpEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAw
MDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMA0KRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERS
NjogMDAwMDAwMDBmZmZmMGZmMCBEUjc6IDAwMDAwMDAwMDAwMDA0MDANClByb2Nlc3MgeGZzYWls
ZC9zZGYxIChwaWQ6IDI4NzYsIHRocmVhZGluZm8gZmZmZjg4MDQxMTE2YTAwMCwgdGFzayBmZmZm
ODgwODE5ZDM1YzAwKQ0KU3RhY2s6DQogZmZmZjg4MDQxMTE2YmMzMCBmZmZmZmZmZjgxNjYwNmJl
IGZmZmY4ODA0MTExNmJjNTAgZmZmZmZmZmZhMDFkMTNkNA0KIGZmZmY4ODA4MjQyMGZlMDAgZmZm
Zjg4MDgyNDIwZmUwMCBmZmZmODgwNDExMTZiYzcwIGZmZmZmZmZmYTAxY2MzZmUNCiBmZmZmODgw
NDExMTZiY2MwIGZmZmY4ODA0MjEyMWM4MDAgZmZmZjg4MDQxMTE2YmNhMCBmZmZmZmZmZmEwMWNj
NGQzDQpDYWxsIFRyYWNlOg0KIFs8ZmZmZmZmZmY4MTY2MDZiZT5dIF9yYXdfc3Bpbl9sb2NrKzB4
ZS8weDIwDQogWzxmZmZmZmZmZmEwMWQxM2Q0Pl0geGZzX2FpbF9taW5fbHNuKzB4MjQvMHg2MCBb
eGZzXQ0KIFs8ZmZmZmZmZmZhMDFjYzNmZT5dIHhsb2dfYXNzaWduX3RhaWxfbHNuKzB4MWUvMHg0
MCBbeGZzXQ0KIFs8ZmZmZmZmZmZhMDFjYzRkMz5dIHhsb2dfc3RhdGVfcmVsZWFzZV9pY2xvZysw
eGIzLzB4ZDAgW3hmc10NCiBbPGZmZmZmZmZmYTAxY2QxNTY+XSBfeGZzX2xvZ19mb3JjZSsweDEy
Ni8weDJhMCBbeGZzXQ0KIFs8ZmZmZmZmZmY4MTA5MTZkNj5dID8gZG93bl90cnlsb2NrKzB4MzYv
MHg1MA0KIFs8ZmZmZmZmZmZhMDFjZDJlOD5dIHhmc19sb2dfZm9yY2UrMHgxOC8weDQwIFt4ZnNd
DQogWzxmZmZmZmZmZmEwMTc2MGIwPl0geGZzX2J1Zl90cnlsb2NrKzB4ZDAvMHhlMCBbeGZzXQ0K
IFs8ZmZmZmZmZmZhMDFjZjFjOD5dIHhmc19idWZfaXRlbV90cnlsb2NrKzB4NTgvMHhjMCBbeGZz
XQ0KIFs8ZmZmZmZmZmZhMDFkMTc3YT5dIHhmc2FpbGRfcHVzaCsweDI0YS8weDY4MCBbeGZzXQ0K
IFs8ZmZmZmZmZmZhMDFkMWMxMj5dIHhmc2FpbGQrMHg2Mi8weGMwIFt4ZnNdDQogWzxmZmZmZmZm
ZmEwMWQxYmIwPl0gPyB4ZnNhaWxkX3B1c2grMHg2ODAvMHg2ODAgW3hmc10NCiBbPGZmZmZmZmZm
ODEwOGI3OGM+XSBrdGhyZWFkKzB4OGMvMHhhMA0KIFs8ZmZmZmZmZmY4MTY2YWU3ND5dIGtlcm5l
bF90aHJlYWRfaGVscGVyKzB4NC8weDEwDQogWzxmZmZmZmZmZjgxMDhiNzAwPl0gPyBmbHVzaF9r
dGhyZWFkX3dvcmtlcisweGEwLzB4YTANCiBbPGZmZmZmZmZmODE2NmFlNzA+XSA/IGdzX2NoYW5n
ZSsweDEzLzB4MTMNCkNvZGU6IDkwIDkwIDkwIDkwIDkwIDkwIDU1IGI4IDAwIDAwIDAxIDAwIDQ4
IDg5IGU1IGYwIDBmIGMxIDA3IDg5IGMyIGMxIGVhIDEwIDY2IDM5IGMyIDc0IDEzIDY2IDBmIDFm
IDg0IDAwIDAwIDAwIDAwIDAwIGYzIDkwIDBmIGI3IDA3IDw2Nj4gMzkgZDAgNzUgZjYgNWQgYzMg
MGYgMWYgNDAgMDAgOGIgMTcgNTUgMzEgYzAgNDggODkgZTUgODkgZDENCkNhbGwgVHJhY2U6DQog
WzxmZmZmZmZmZjgxNjYwNmJlPl0gX3Jhd19zcGluX2xvY2srMHhlLzB4MjANCiBbPGZmZmZmZmZm
YTAxZDEzZDQ+XSB4ZnNfYWlsX21pbl9sc24rMHgyNC8weDYwIFt4ZnNdDQogWzxmZmZmZmZmZmEw
MWNjM2ZlPl0geGxvZ19hc3NpZ25fdGFpbF9sc24rMHgxZS8weDQwIFt4ZnNdDQogWzxmZmZmZmZm
ZmEwMWNjNGQzPl0geGxvZ19zdGF0ZV9yZWxlYXNlX2ljbG9nKzB4YjMvMHhkMCBbeGZzXQ0KIFs8
ZmZmZmZmZmZhMDFjZDE1Nj5dIF94ZnNfbG9nX2ZvcmNlKzB4MTI2LzB4MmEwIFt4ZnNdDQogWzxm
ZmZmZmZmZjgxMDkxNmQ2Pl0gPyBkb3duX3RyeWxvY2srMHgzNi8weDUwDQogWzxmZmZmZmZmZmEw
MWNkMmU4Pl0geGZzX2xvZ19mb3JjZSsweDE4LzB4NDAgW3hmc10NCiBbPGZmZmZmZmZmYTAxNzYw
YjA+XSB4ZnNfYnVmX3RyeWxvY2srMHhkMC8weGUwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWNmMWM4
Pl0geGZzX2J1Zl9pdGVtX3RyeWxvY2srMHg1OC8weGMwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWQx
NzdhPl0geGZzYWlsZF9wdXNoKzB4MjRhLzB4NjgwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWQxYzEy
Pl0geGZzYWlsZCsweDYyLzB4YzAgW3hmc10NCiBbPGZmZmZmZmZmYTAxZDFiYjA+XSA/IHhmc2Fp
bGRfcHVzaCsweDY4MC8weDY4MCBbeGZzXQ0KIFs8ZmZmZmZmZmY4MTA4Yjc4Yz5dIGt0aHJlYWQr
MHg4Yy8weGEwDQogWzxmZmZmZmZmZjgxNjZhZTc0Pl0ga2VybmVsX3RocmVhZF9oZWxwZXIrMHg0
LzB4MTANCiBbPGZmZmZmZmZmODEwOGI3MDA+XSA/IGZsdXNoX2t0aHJlYWRfd29ya2VyKzB4YTAv
MHhhMA0KIFs8ZmZmZmZmZmY4MTY2YWU3MD5dID8gZ3NfY2hhbmdlKzB4MTMvMHgxMw0KDQoNCkJV
Rzogc29mdCBsb2NrdXAgLSBDUFUjMCBzdHVjayBmb3IgMjJzISBba3dvcmtlci8wOjM6Mjc1ODBd
DQpNb2R1bGVzIGxpbmtlZCBpbjogaXBtaV9zaSBtcHQyc2FzIHNjc2lfdHJhbnNwb3J0X3NhcyBy
YWlkX2NsYXNzIG1wdGN0bCBtcHRiYXNlIGlwbWlfZGV2aW50ZiBpcG1pX21zZ2hhbmRsZXIgZGVs
bF9yYnUgeGZzIHZlc2FmYiA4MDIxcSBnYXJwIGJvbmRpbmcgam95ZGV2IGJyaWRnZSBzdHAgc2hw
Y2hwIGRjZGJhcyBzYl9lZGFjIG1hY19oaWQgZWRhY19jb3JlIHdtaSBhY3BpX3Bvd2VyX21ldGVy
IGxwIG1laShDKSBwYXJwb3J0IHVzYmhpZCBoaWQgaXhnYmUgbWRpbyBpZ2IgbWVnYXJhaWRfc2Fz
IGRjYSBbbGFzdCB1bmxvYWRlZDogaXBtaV9zaV0NCkNQVSAwDQpNb2R1bGVzIGxpbmtlZCBpbjog
aXBtaV9zaSBtcHQyc2FzIHNjc2lfdHJhbnNwb3J0X3NhcyByYWlkX2NsYXNzIG1wdGN0bCBtcHRi
YXNlIGlwbWlfZGV2aW50ZiBpcG1pX21zZ2hhbmRsZXIgZGVsbF9yYnUgeGZzIHZlc2FmYiA4MDIx
cSBnYXJwIGJvbmRpbmcgam95ZGV2IGJyaWRnZSBzdHAgc2hwY2hwIGRjZGJhcyBzYl9lZGFjIG1h
Y19oaWQgZWRhY19jb3JlIHdtaSBhY3BpX3Bvd2VyX21ldGVyIGxwIG1laShDKSBwYXJwb3J0IHVz
YmhpZCBoaWQgaXhnYmUgbWRpbyBpZ2IgbWVnYXJhaWRfc2FzIGRjYSBbbGFzdCB1bmxvYWRlZDog
aXBtaV9zaV0NCg0KUGlkOiAyNzU4MCwgY29tbToga3dvcmtlci8wOjMgVGFpbnRlZDogRyAgICAg
ICAgV0MgICAzLjIuMC01MS1nZW5lcmljICM3Ny1VYnVudHUgRGVsbCBJbmMuIFBvd2VyRWRnZSBS
NzIweGQvMFg2SDQ3DQpSSVA6IDAwMTA6WzxmZmZmZmZmZjgxMDNlYmM1Pl0gIFs8ZmZmZmZmZmY4
MTAzZWJjNT5dIF9fdGlja2V0X3NwaW5fbG9jaysweDI1LzB4MzANClJTUDogMDAxODpmZmZmODgw
MWFlYWUzZDQwICBFRkxBR1M6IDAwMDAwMjkzDQpSQVg6IDAwMDAwMDAwMDAwMDA3ZTUgUkJYOiBm
ZmZmODgwMWFlYWUzY2QwIFJDWDogMDAwMDAwMDAwMDAwMDAwMw0KUkRYOiAwMDAwMDAwMDAwMDAw
N2U3IFJTSTogZmZmZjg4MDgyM2ExMTdkMCBSREk6IGZmZmY4ODA4MjRiMzJlNzgNClJCUDogZmZm
Zjg4MDFhZWFlM2Q0MCBSMDg6IGZmZmY4ODAxYWVhZTIwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDkz
DQpSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAwMDAwMDAwMDAwMDAxIFIxMjogMDAwMDAw
MDAwMDAwMDAwMg0KUjEzOiBmZmZmODgwNDJmYzEzN2MwIFIxNDogZmZmZjg4MDQyNWEzN2EwMCBS
MTU6IDAwMDAwMDAwMDAwMDAxNGINCkZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZm
ODgwNDJmYzAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDANCkNTOiAgMDAxMCBEUzog
MDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2INCkNSMjogMDAwMDdlZmZhOGI1MmVm
NyBDUjM6IDAwMDAwMDAwMDFjMDUwMDAgQ1I0OiAwMDAwMDAwMDAwMDQwNmYwDQpEUjA6IDAwMDAw
MDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMA0K
RFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBmZmZmMGZmMCBEUjc6IDAwMDAwMDAw
MDAwMDA0MDANClByb2Nlc3Mga3dvcmtlci8wOjMgKHBpZDogMjc1ODAsIHRocmVhZGluZm8gZmZm
Zjg4MDFhZWFlMjAwMCwgdGFzayBmZmZmODgwMGE1MDE1YzAwKQ0KU3RhY2s6DQogZmZmZjg4MDFh
ZWFlM2Q1MCBmZmZmZmZmZjgxNjYwNmJlIGZmZmY4ODAxYWVhZTNkODAgZmZmZmZmZmZhMDFjZmUx
Yg0KIGZmZmY4ODA2ZTNkM2RjNDggZmZmZjg4MDAzMzlmMTYwMCBmZmZmODgwNDIxYjc2OTQwIGZm
ZmY4ODAxYmJlNTM1MDANCiBmZmZmODgwMWFlYWUzZGEwIGZmZmZmZmZmYTAxY2VmMWMgMDAwMDAw
MDAwMDAwMDAwMCBmZmZmODgwNDIxYjc2OTQwDQpDYWxsIFRyYWNlOg0KIFs8ZmZmZmZmZmY4MTY2
MDZiZT5dIF9yYXdfc3Bpbl9sb2NrKzB4ZS8weDIwDQogWzxmZmZmZmZmZmEwMWNmZTFiPl0geGZz
X2J1Zl9pb2RvbmUrMHgyYi8weDYwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWNlZjFjPl0geGZzX2J1
Zl9kb19jYWxsYmFja3MrMHgzYy8weDUwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWNlZjk2Pl0geGZz
X2J1Zl9pb2RvbmVfY2FsbGJhY2tzKzB4NDYvMHgyMjAgW3hmc10NCiBbPGZmZmZmZmZmYTAxNzY4
NDM+XSB4ZnNfYnVmX2lvZG9uZV93b3JrKzB4MjMvMHg1MCBbeGZzXQ0KIFs8ZmZmZmZmZmY4MTA4
NWUzNz5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxMjcvMHg0NzANCiBbPGZmZmZmZmZmODEwODZmNDQ+
XSB3b3JrZXJfdGhyZWFkKzB4MTY0LzB4MzcwDQogWzxmZmZmZmZmZjgxMDg2ZGUwPl0gPyBtYW5h
Z2Vfd29ya2Vycy5pc3JhLjMxKzB4MTMwLzB4MTMwDQogWzxmZmZmZmZmZjgxMDhiNzhjPl0ga3Ro
cmVhZCsweDhjLzB4YTANCiBbPGZmZmZmZmZmODE2NmFlNzQ+XSBrZXJuZWxfdGhyZWFkX2hlbHBl
cisweDQvMHgxMA0KIFs8ZmZmZmZmZmY4MTA4YjcwMD5dID8gZmx1c2hfa3RocmVhZF93b3JrZXIr
MHhhMC8weGEwDQogWzxmZmZmZmZmZjgxNjZhZTcwPl0gPyBnc19jaGFuZ2UrMHgxMy8weDEzDQpD
b2RlOiA5MCA5MCA5MCA5MCA5MCA5MCA1NSBiOCAwMCAwMCAwMSAwMCA0OCA4OSBlNSBmMCAwZiBj
MSAwNyA4OSBjMiBjMSBlYSAxMCA2NiAzOSBjMiA3NCAxMyA2NiAwZiAxZiA4NCAwMCAwMCAwMCAw
MCAwMCBmMyA5MCAwZiBiNyAwNyA8NjY+IDM5IGQwIDc1IGY2IDVkIGMzIDBmIDFmIDQwIDAwIDhi
IDE3IDU1IDMxIGMwIDQ4IDg5IGU1IDg5IGQxDQpDYWxsIFRyYWNlOg0KIFs8ZmZmZmZmZmY4MTY2
MDZiZT5dIF9yYXdfc3Bpbl9sb2NrKzB4ZS8weDIwDQogWzxmZmZmZmZmZmEwMWNmZTFiPl0geGZz
X2J1Zl9pb2RvbmUrMHgyYi8weDYwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWNlZjFjPl0geGZzX2J1
Zl9kb19jYWxsYmFja3MrMHgzYy8weDUwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWNlZjk2Pl0geGZz
X2J1Zl9pb2RvbmVfY2FsbGJhY2tzKzB4NDYvMHgyMjAgW3hmc10NCiBbPGZmZmZmZmZmYTAxNzY4
NDM+XSB4ZnNfYnVmX2lvZG9uZV93b3JrKzB4MjMvMHg1MCBbeGZzXQ0KIFs8ZmZmZmZmZmY4MTA4
NWUzNz5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxMjcvMHg0NzANCiBbPGZmZmZmZmZmODEwODZmNDQ+
XSB3b3JrZXJfdGhyZWFkKzB4MTY0LzB4MzcwDQogWzxmZmZmZmZmZjgxMDg2ZGUwPl0gPyBtYW5h
Z2Vfd29ya2Vycy5pc3JhLjMxKzB4MTMwLzB4MTMwDQogWzxmZmZmZmZmZjgxMDhiNzhjPl0ga3Ro
cmVhZCsweDhjLzB4YTANCiBbPGZmZmZmZmZmODE2NmFlNzQ+XSBrZXJuZWxfdGhyZWFkX2hlbHBl
cisweDQvMHgxMA0KIFs8ZmZmZmZmZmY4MTA4YjcwMD5dID8gZmx1c2hfa3RocmVhZF93b3JrZXIr
MHhhMC8weGEwDQogWzxmZmZmZmZmZjgxNjZhZTcwPl0gPyBnc19jaGFuZ2UrMHgxMy8weDEzDQoN
Cg0KQlVHOiBzb2Z0IGxvY2t1cCAtIENQVSM3IHN0dWNrIGZvciAyM3MhIFtzd2lmdC1vYmplY3Qt
c2U6NDM0MF0NCk1vZHVsZXMgbGlua2VkIGluOiBpcG1pX3NpIG1wdDJzYXMgc2NzaV90cmFuc3Bv
cnRfc2FzIHJhaWRfY2xhc3MgbXB0Y3RsIG1wdGJhc2UgaXBtaV9kZXZpbnRmIGlwbWlfbXNnaGFu
ZGxlciBkZWxsX3JidSB4ZnMgdmVzYWZiIDgwMjFxIGdhcnAgYm9uZGluZyBqb3lkZXYgYnJpZGdl
IHN0cCBzaHBjaHAgZGNkYmFzIHNiX2VkYWMgbWFjX2hpZCBlZGFjX2NvcmUgd21pIGFjcGlfcG93
ZXJfbWV0ZXIgbHAgbWVpKEMpIHBhcnBvcnQgdXNiaGlkIGhpZCBpeGdiZSBtZGlvIGlnYiBtZWdh
cmFpZF9zYXMgZGNhIFtsYXN0IHVubG9hZGVkOiBpcG1pX3NpXQ0KQ1BVIDcNCk1vZHVsZXMgbGlu
a2VkIGluOiBpcG1pX3NpIG1wdDJzYXMgc2NzaV90cmFuc3BvcnRfc2FzIHJhaWRfY2xhc3MgbXB0
Y3RsIG1wdGJhc2UgaXBtaV9kZXZpbnRmIGlwbWlfbXNnaGFuZGxlciBkZWxsX3JidSB4ZnMgdmVz
YWZiIDgwMjFxIGdhcnAgYm9uZGluZyBqb3lkZXYgYnJpZGdlIHN0cCBzaHBjaHAgZGNkYmFzIHNi
X2VkYWMgbWFjX2hpZCBlZGFjX2NvcmUgd21pIGFjcGlfcG93ZXJfbWV0ZXIgbHAgbWVpKEMpIHBh
cnBvcnQgdXNiaGlkIGhpZCBpeGdiZSBtZGlvIGlnYiBtZWdhcmFpZF9zYXMgZGNhIFtsYXN0IHVu
bG9hZGVkOiBpcG1pX3NpXQ0KDQpQaWQ6IDQzNDAsIGNvbW06IHN3aWZ0LW9iamVjdC1zZSBUYWlu
dGVkOiBHICAgICAgICBXQyAgIDMuMi4wLTUxLWdlbmVyaWMgIzc3LVVidW50dSBEZWxsIEluYy4g
UG93ZXJFZGdlIFI3MjB4ZC8wWDZINDcNClJJUDogMDAxMDpbPGZmZmZmZmZmODEwM2ViYzU+XSAg
WzxmZmZmZmZmZjgxMDNlYmM1Pl0gX190aWNrZXRfc3Bpbl9sb2NrKzB4MjUvMHgzMA0KUlNQOiAw
MDE4OmZmZmY4ODAzMzYyYTE0OTggIEVGTEFHUzogMDAwMDAyOTcNClJBWDogMDAwMDAwMDAwMDAw
N2MxYyBSQlg6IDAwMDAwMDA3MDAwMDAwMDYgUkNYOiBmZmZmODgwNDE4NmE3Y2U4DQpSRFg6IDAw
MDAwMDAwMDAwMDdjMWQgUlNJOiBmZmZmODgwNDExMmM5NzAwIFJESTogZmZmZjg4MDgyNDIwZmVh
OA0KUkJQOiBmZmZmODgwMzM2MmExNDk4IFIwODogZmZmZjg4MDMzNjJhMTVkMCBSMDk6IGZmZmY4
ODAzMzYyYTE1ZGMNClIxMDogMDAwMDAwMDAwMDAwMTIxYyBSMTE6IDAwMDAwMDAwMDAwMDAwMDYg
UjEyOiBmZmZmZmZmZmEwMWE2NTg3DQpSMTM6IGZmZmY4ODAzMzYyYTE0MjggUjE0OiBmZmZmODgw
MzM2MmExNTQ0IFIxNTogMDAwMDAwMDAwMDAwMDAwMA0KRlM6ICAwMDAwN2YzZGIxZmZiNzAwKDAw
MDApIEdTOmZmZmY4ODA4M2ZjNjAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMA0KQ1M6
ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMw0KQ1IyOiAwMDAw
N2YzZGJjZDFiMDAwIENSMzogMDAwMDAwMDI5NTVmNjAwMCBDUjQ6IDAwMDAwMDAwMDAwNDA2ZTAN
CkRSMDogMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAwMDAw
MDAwMDAwMDAwDQpEUjM6IDAwMDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAwMGZmZmYwZmYwIERS
NzogMDAwMDAwMDAwMDAwMDQwMA0KUHJvY2VzcyBzd2lmdC1vYmplY3Qtc2UgKHBpZDogNDM0MCwg
dGhyZWFkaW5mbyBmZmZmODgwMzM2MmEwMDAwLCB0YXNrIGZmZmY4ODA0MTEyYzk3MDApDQpTdGFj
azoNCiBmZmZmODgwMzM2MmExNGE4IGZmZmZmZmZmODE2NjA2YmUgZmZmZjg4MDMzNjJhMTU0OCBm
ZmZmZmZmZmEwMWNjNTQ4DQogZmZmZjg4MDMzNjJhMTVkYyBmZmZmODgwMzM2MmExNWQwIGZmZmY4
ODAzMzYyYTE1YzAgMDAwMDEzMjQ4MTAzZWM1OQ0KIDAwMDAwMDAwMDAwMTQ0YzAgZmZmZjg4MDQx
MTJjOTcwMCAwMDAwMDAwMDAwMDAwMjg2IGZmZmY4ODA1NTYyNTNkNzgNCkNhbGwgVHJhY2U6DQog
WzxmZmZmZmZmZjgxNjYwNmJlPl0gX3Jhd19zcGluX2xvY2srMHhlLzB4MjANCiBbPGZmZmZmZmZm
YTAxY2M1NDg+XSB4bG9nX3N0YXRlX2dldF9pY2xvZ19zcGFjZSsweDU4LzB4MmUwIFt4ZnNdDQog
WzxmZmZmZmZmZjgxMDkxOGEyPl0gPyB1cCsweDMyLzB4NTANCiBbPGZmZmZmZmZmODExNjY1NWQ+
XSA/IGttZW1fY2FjaGVfYWxsb2MrMHgxMWQvMHgxNDANCiBbPGZmZmZmZmZmYTAxY2NiOTk+XSB4
bG9nX3dyaXRlKzB4ZTkvMHg0MDAgW3hmc10NCiBbPGZmZmZmZmZmYTAxOGM4Nzc+XSA/IGttZW1f
em9uZV9hbGxvYysweDY3LzB4ZTAgW3hmc10NCiBbPGZmZmZmZmZmYTAxY2U0MGM+XSB4bG9nX2Np
bF9wdXNoKzB4MjBjLzB4MzgwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWNlZDJlPl0geGxvZ19jaWxf
Zm9yY2VfbHNuKzB4MTBlLzB4MTIwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWJkOTdlPl0gPyB4ZnNf
aWV4dF9pbnNlcnQrMHg3ZS8weDEwMCBbeGZzXQ0KIFs8ZmZmZmZmZmZhMDE5YjY2Mj5dID8geGZz
X2JtYXBfYWRkX2V4dGVudF9ob2xlX3JlYWwrMHgxMTIvMHhhZDAgW3hmc10NCiBbPGZmZmZmZmZm
YTAxY2QwOTg+XSBfeGZzX2xvZ19mb3JjZSsweDY4LzB4MmEwIFt4ZnNdDQogWzxmZmZmZmZmZmEw
MWNkMmU4Pl0geGZzX2xvZ19mb3JjZSsweDE4LzB4NDAgW3hmc10NCiBbPGZmZmZmZmZmYTAxNzYw
YjA+XSB4ZnNfYnVmX3RyeWxvY2srMHhkMC8weGUwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMTc2MjFi
Pl0gPyBfeGZzX2J1Zl9maW5kKzB4NGIvMHgyNDAgW3hmc10NCiBbPGZmZmZmZmZmYTAxNzYyOGM+
XSBfeGZzX2J1Zl9maW5kKzB4YmMvMHgyNDAgW3hmc10NCiBbPGZmZmZmZmZmYTAxNzY2OTQ+XSB4
ZnNfYnVmX2dldCsweDM0LzB4MWMwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWQyNTA3Pl0geGZzX3Ry
YW5zX2dldF9idWYrMHgxMjcvMHgxYTAgW3hmc10NCiBbPGZmZmZmZmZmYTAxYWJjZTk+XSB4ZnNf
ZGFfZG9fYnVmKzB4M2Q5LzB4NjMwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWFiZmQxPl0geGZzX2Rh
X2dldF9idWYrMHgyMS8weDMwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMTk0OWI3Pl0geGZzX2F0dHJf
bGVhZl9jcmVhdGUuaXNyYS4yKzB4NDcvMHgxMDAgW3hmc10NCiBbPGZmZmZmZmZmYTAxOTcyNjQ+
XSB4ZnNfYXR0cl9zaG9ydGZvcm1fdG9fbGVhZisweDEwNC8weDI0MCBbeGZzXQ0KIFs8ZmZmZmZm
ZmZhMDE4Yzg3Nz5dID8ga21lbV96b25lX2FsbG9jKzB4NjcvMHhlMCBbeGZzXQ0KIFs8ZmZmZmZm
ZmZhMDE4YzkyOT5dID8ga21lbV96b25lX3phbGxvYysweDM5LzB4NTAgW3hmc10NCiBbPGZmZmZm
ZmZmYTAxOTMzMDY+XSB4ZnNfYXR0cl9zZXRfaW50KzB4NDA2LzB4NGUwIFt4ZnNdDQogWzxmZmZm
ZmZmZmEwMTkzOTRmPl0geGZzX2F0dHJfc2V0KzB4N2YvMHg5MCBbeGZzXQ0KIFs8ZmZmZmZmZmZh
MDE4ODA1Nz5dIHhmc194YXR0cl9zZXQrMHg0Ny8weDYwIFt4ZnNdDQogWzxmZmZmZmZmZjgxMTlk
NGZiPl0gZ2VuZXJpY19zZXR4YXR0cisweDZiLzB4OTANCiBbPGZmZmZmZmZmODExOWRkNWI+XSBf
X3Zmc19zZXR4YXR0cl9ub3Blcm0rMHg3Yi8weDFjMA0KIFs8ZmZmZmZmZmY4MTJkZWNjZT5dID8g
ZXZtX2lub2RlX3NldHhhdHRyKzB4ZS8weDEwDQogWzxmZmZmZmZmZjgxMTlkZjVjPl0gdmZzX3Nl
dHhhdHRyKzB4YmMvMHhjMA0KIFs8ZmZmZmZmZmY4MTE5ZTAyNj5dIHNldHhhdHRyKzB4YzYvMHgx
MjANCiBbPGZmZmZmZmZmODExYjhhNjI+XSA/IGZzbm90aWZ5KzB4MWMyLzB4MmEwDQogWzxmZmZm
ZmZmZjgxMGExZTZjPl0gPyBkb19mdXRleCsweDdjLzB4MWIwDQogWzxmZmZmZmZmZjgxMTllNDNi
Pl0gc3lzX2ZzZXR4YXR0cisweGJiLzB4ZTANCiBbPGZmZmZmZmZmODE2NjhkMDI+XSBzeXN0ZW1f
Y2FsbF9mYXN0cGF0aCsweDE2LzB4MWINCkNvZGU6IDkwIDkwIDkwIDkwIDkwIDkwIDU1IGI4IDAw
IDAwIDAxIDAwIDQ4IDg5IGU1IGYwIDBmIGMxIDA3IDg5IGMyIGMxIGVhIDEwIDY2IDM5IGMyIDc0
IDEzIDY2IDBmIDFmIDg0IDAwIDAwIDAwIDAwIDAwIGYzIDkwIDBmIGI3IDA3IDw2Nj4gMzkgZDAg
NzUgZjYgNWQgYzMgMGYgMWYgNDAgMDAgOGIgMTcgNTUgMzEgYzAgNDggODkgZTUgODkgZDENCkNh
bGwgVHJhY2U6DQogWzxmZmZmZmZmZjgxNjYwNmJlPl0gX3Jhd19zcGluX2xvY2srMHhlLzB4MjAN
CiBbPGZmZmZmZmZmYTAxY2M1NDg+XSB4bG9nX3N0YXRlX2dldF9pY2xvZ19zcGFjZSsweDU4LzB4
MmUwIFt4ZnNdDQogWzxmZmZmZmZmZjgxMDkxOGEyPl0gPyB1cCsweDMyLzB4NTANCiBbPGZmZmZm
ZmZmODExNjY1NWQ+XSA/IGttZW1fY2FjaGVfYWxsb2MrMHgxMWQvMHgxNDANCiBbPGZmZmZmZmZm
YTAxY2NiOTk+XSB4bG9nX3dyaXRlKzB4ZTkvMHg0MDAgW3hmc10NCiBbPGZmZmZmZmZmYTAxOGM4
Nzc+XSA/IGttZW1fem9uZV9hbGxvYysweDY3LzB4ZTAgW3hmc10NCiBbPGZmZmZmZmZmYTAxY2U0
MGM+XSB4bG9nX2NpbF9wdXNoKzB4MjBjLzB4MzgwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWNlZDJl
Pl0geGxvZ19jaWxfZm9yY2VfbHNuKzB4MTBlLzB4MTIwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWJk
OTdlPl0gPyB4ZnNfaWV4dF9pbnNlcnQrMHg3ZS8weDEwMCBbeGZzXQ0KIFs8ZmZmZmZmZmZhMDE5
YjY2Mj5dID8geGZzX2JtYXBfYWRkX2V4dGVudF9ob2xlX3JlYWwrMHgxMTIvMHhhZDAgW3hmc10N
CiBbPGZmZmZmZmZmYTAxY2QwOTg+XSBfeGZzX2xvZ19mb3JjZSsweDY4LzB4MmEwIFt4ZnNdDQog
WzxmZmZmZmZmZmEwMWNkMmU4Pl0geGZzX2xvZ19mb3JjZSsweDE4LzB4NDAgW3hmc10NCiBbPGZm
ZmZmZmZmYTAxNzYwYjA+XSB4ZnNfYnVmX3RyeWxvY2srMHhkMC8weGUwIFt4ZnNdDQogWzxmZmZm
ZmZmZmEwMTc2MjFiPl0gPyBfeGZzX2J1Zl9maW5kKzB4NGIvMHgyNDAgW3hmc10NCiBbPGZmZmZm
ZmZmYTAxNzYyOGM+XSBfeGZzX2J1Zl9maW5kKzB4YmMvMHgyNDAgW3hmc10NCiBbPGZmZmZmZmZm
YTAxNzY2OTQ+XSB4ZnNfYnVmX2dldCsweDM0LzB4MWMwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWQy
NTA3Pl0geGZzX3RyYW5zX2dldF9idWYrMHgxMjcvMHgxYTAgW3hmc10NCiBbPGZmZmZmZmZmYTAx
YWJjZTk+XSB4ZnNfZGFfZG9fYnVmKzB4M2Q5LzB4NjMwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWFi
ZmQxPl0geGZzX2RhX2dldF9idWYrMHgyMS8weDMwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMTk0OWI3
Pl0geGZzX2F0dHJfbGVhZl9jcmVhdGUuaXNyYS4yKzB4NDcvMHgxMDAgW3hmc10NCiBbPGZmZmZm
ZmZmYTAxOTcyNjQ+XSB4ZnNfYXR0cl9zaG9ydGZvcm1fdG9fbGVhZisweDEwNC8weDI0MCBbeGZz
XQ0KIFs8ZmZmZmZmZmZhMDE4Yzg3Nz5dID8ga21lbV96b25lX2FsbG9jKzB4NjcvMHhlMCBbeGZz
XQ0KIFs8ZmZmZmZmZmZhMDE4YzkyOT5dID8ga21lbV96b25lX3phbGxvYysweDM5LzB4NTAgW3hm
c10NCiBbPGZmZmZmZmZmYTAxOTMzMDY+XSB4ZnNfYXR0cl9zZXRfaW50KzB4NDA2LzB4NGUwIFt4
ZnNdDQogWzxmZmZmZmZmZmEwMTkzOTRmPl0geGZzX2F0dHJfc2V0KzB4N2YvMHg5MCBbeGZzXQ0K
IFs8ZmZmZmZmZmZhMDE4ODA1Nz5dIHhmc194YXR0cl9zZXQrMHg0Ny8weDYwIFt4ZnNdDQogWzxm
ZmZmZmZmZjgxMTlkNGZiPl0gZ2VuZXJpY19zZXR4YXR0cisweDZiLzB4OTANCiBbPGZmZmZmZmZm
ODExOWRkNWI+XSBfX3Zmc19zZXR4YXR0cl9ub3Blcm0rMHg3Yi8weDFjMA0KIFs8ZmZmZmZmZmY4
MTJkZWNjZT5dID8gZXZtX2lub2RlX3NldHhhdHRyKzB4ZS8weDEwDQogWzxmZmZmZmZmZjgxMTlk
ZjVjPl0gdmZzX3NldHhhdHRyKzB4YmMvMHhjMA0KIFs8ZmZmZmZmZmY4MTE5ZTAyNj5dIHNldHhh
dHRyKzB4YzYvMHgxMjANCiBbPGZmZmZmZmZmODExYjhhNjI+XSA/IGZzbm90aWZ5KzB4MWMyLzB4
MmEwDQogWzxmZmZmZmZmZjgxMGExZTZjPl0gPyBkb19mdXRleCsweDdjLzB4MWIwDQogWzxmZmZm
ZmZmZjgxMTllNDNiPl0gc3lzX2ZzZXR4YXR0cisweGJiLzB4ZTANCiBbPGZmZmZmZmZmODE2Njhk
MDI+XSBzeXN0ZW1fY2FsbF9mYXN0cGF0aCsweDE2LzB4MWINCg0KDQpCVUc6IHNvZnQgbG9ja3Vw
IC0gQ1BVIzkgc3R1Y2sgZm9yIDIzcyEgW3N3aWZ0LW9iamVjdC1zZTo0MzYyXQ0KTW9kdWxlcyBs
aW5rZWQgaW46IGlwbWlfc2kgbXB0MnNhcyBzY3NpX3RyYW5zcG9ydF9zYXMgcmFpZF9jbGFzcyBt
cHRjdGwgbXB0YmFzZSBpcG1pX2RldmludGYgaXBtaV9tc2doYW5kbGVyIGRlbGxfcmJ1IHhmcyB2
ZXNhZmIgODAyMXEgZ2FycCBib25kaW5nIGpveWRldiBicmlkZ2Ugc3RwIHNocGNocCBkY2RiYXMg
c2JfZWRhYyBtYWNfaGlkIGVkYWNfY29yZSB3bWkgYWNwaV9wb3dlcl9tZXRlciBscCBtZWkoQykg
cGFycG9ydCB1c2JoaWQgaGlkIGl4Z2JlIG1kaW8gaWdiIG1lZ2FyYWlkX3NhcyBkY2EgW2xhc3Qg
dW5sb2FkZWQ6IGlwbWlfc2ldDQpDUFUgOQ0KTW9kdWxlcyBsaW5rZWQgaW46IGlwbWlfc2kgbXB0
MnNhcyBzY3NpX3RyYW5zcG9ydF9zYXMgcmFpZF9jbGFzcyBtcHRjdGwgbXB0YmFzZSBpcG1pX2Rl
dmludGYgaXBtaV9tc2doYW5kbGVyIGRlbGxfcmJ1IHhmcyB2ZXNhZmIgODAyMXEgZ2FycCBib25k
aW5nIGpveWRldiBicmlkZ2Ugc3RwIHNocGNocCBkY2RiYXMgc2JfZWRhYyBtYWNfaGlkIGVkYWNf
Y29yZSB3bWkgYWNwaV9wb3dlcl9tZXRlciBscCBtZWkoQykgcGFycG9ydCB1c2JoaWQgaGlkIGl4
Z2JlIG1kaW8gaWdiIG1lZ2FyYWlkX3NhcyBkY2EgW2xhc3QgdW5sb2FkZWQ6IGlwbWlfc2ldDQoN
ClBpZDogNDM2MiwgY29tbTogc3dpZnQtb2JqZWN0LXNlIFRhaW50ZWQ6IEcgICAgICAgIFdDICAg
My4yLjAtNTEtZ2VuZXJpYyAjNzctVWJ1bnR1IERlbGwgSW5jLiBQb3dlckVkZ2UgUjcyMHhkLzBY
Nkg0Nw0KUklQOiAwMDEwOls8ZmZmZmZmZmY4MTAzZWJjNT5dICBbPGZmZmZmZmZmODEwM2ViYzU+
XSBfX3RpY2tldF9zcGluX2xvY2srMHgyNS8weDMwDQpSU1A6IDAwMTg6ZmZmZjg4MDNkZjg2M2I2
OCAgRUZMQUdTOiAwMDAwMDI5Mw0KUkFYOiAwMDAwMDAwMDAwMDA3YzFjIFJCWDogZmZmZmZmZmY4
MTE2NDFjZiBSQ1g6IGZmZmY4ODA0MTg2MzI3MDgNClJEWDogMDAwMDAwMDAwMDAwN2MxZiBSU0k6
IGZmZmY4ODAxMTBlOTk3MDAgUkRJOiBmZmZmODgwODI0MjBmZWE4DQpSQlA6IGZmZmY4ODAzZGY4
NjNiNjggUjA4OiBmZmZmODgwM2RmODYzY2EwIFIwOTogZmZmZjg4MDNkZjg2M2NhYw0KUjEwOiAw
MDAwMDAwMDAwMDAyMWM0IFIxMTogMDAwMDAwMDAwMDAwMDAwYSBSMTI6IGZmZmY4ODAzZGY4NjNi
NTANClIxMzogZmZmZjg4MDgyNDIwZmUwMCBSMTQ6IGZmZmY4ODA4MDgzMDdhNDAgUjE1OiBmZmZm
ODgwM2RmODYzYWU4DQpGUzogIDAwMDA3ZjNkNmY3ZmU3MDAoMDAwMCkgR1M6ZmZmZjg4MDgzZmM4
MDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwDQpDUzogIDAwMTAgRFM6IDAwMDAgRVM6
IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzDQpDUjI6IDAwMDA3ZjNkYmNkMWIwMDAgQ1IzOiAw
MDAwMDAwNDE0MGJmMDAwIENSNDogMDAwMDAwMDAwMDA0MDZlMA0KRFIwOiAwMDAwMDAwMDAwMDAw
MDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDANCkRSMzogMDAw
MDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZmZjBmZjAgRFI3OiAwMDAwMDAwMDAwMDAwNDAw
DQpQcm9jZXNzIHN3aWZ0LW9iamVjdC1zZSAocGlkOiA0MzYyLCB0aHJlYWRpbmZvIGZmZmY4ODAz
ZGY4NjIwMDAsIHRhc2sgZmZmZjg4MDExMGU5OTcwMCkNClN0YWNrOg0KIGZmZmY4ODAzZGY4NjNi
NzggZmZmZmZmZmY4MTY2MDZiZSBmZmZmODgwM2RmODYzYzE4IGZmZmZmZmZmYTAxY2M1NDgNCiBm
ZmZmODgwM2RmODYzY2FjIGZmZmY4ODAzZGY4NjNjYTAgZmZmZjg4MDNkZjg2M2M5MCAwMDAwMjJl
NDI0NDUwNmMwDQogMDAwMDAwMDAwMDAxNDRjMCBmZmZmODgwMTEwZTk5NzAwIGZmZmY4ODAzZGY4
NjNkZjUgMDAwMDAwMDAwMDAwMDAwZQ0KQ2FsbCBUcmFjZToNCiBbPGZmZmZmZmZmODE2NjA2YmU+
XSBfcmF3X3NwaW5fbG9jaysweGUvMHgyMA0KIFs8ZmZmZmZmZmZhMDFjYzU0OD5dIHhsb2dfc3Rh
dGVfZ2V0X2ljbG9nX3NwYWNlKzB4NTgvMHgyZTAgW3hmc10NCiBbPGZmZmZmZmZmODExNjY1NWQ+
XSA/IGttZW1fY2FjaGVfYWxsb2MrMHgxMWQvMHgxNDANCiBbPGZmZmZmZmZmYTAxY2NiOTk+XSB4
bG9nX3dyaXRlKzB4ZTkvMHg0MDAgW3hmc10NCiBbPGZmZmZmZmZmYTAxOGM4Nzc+XSA/IGttZW1f
em9uZV9hbGxvYysweDY3LzB4ZTAgW3hmc10NCiBbPGZmZmZmZmZmYTAxY2U0MGM+XSB4bG9nX2Np
bF9wdXNoKzB4MjBjLzB4MzgwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWNlZDJlPl0geGxvZ19jaWxf
Zm9yY2VfbHNuKzB4MTBlLzB4MTIwIFt4ZnNdDQogWzxmZmZmZmZmZjgxMTllMDMxPl0gPyBzZXR4
YXR0cisweGQxLzB4MTIwDQogWzxmZmZmZmZmZmEwMWNkMzY3Pl0gX3hmc19sb2dfZm9yY2VfbHNu
KzB4NTcvMHgyZTAgW3hmc10NCiBbPGZmZmZmZmZmODE2NWY5ODY+XSA/IGRvd25fcmVhZCsweDE2
LzB4MmINCiBbPGZmZmZmZmZmYTAxN2QxMTY+XSA/IHhmc19pdW5sb2NrKzB4ZTYvMHgxNTAgW3hm
c10NCiBbPGZmZmZmZmZmYTAxNzkxMjM+XSA/IHhmc19maWxlX2ZzeW5jKzB4MTEzLzB4MzAwIFt4
ZnNdDQogWzxmZmZmZmZmZmEwMTc5MjBjPl0geGZzX2ZpbGVfZnN5bmMrMHgxZmMvMHgzMDAgW3hm
c10NCiBbPGZmZmZmZmZmODExYThjNTY+XSBkb19mc3luYysweDU2LzB4ODANCiBbPGZmZmZmZmZm
ODExYThmODA+XSBzeXNfZnN5bmMrMHgxMC8weDIwDQogWzxmZmZmZmZmZjgxNjY4ZDAyPl0gc3lz
dGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8weDFiDQpDb2RlOiA5MCA5MCA5MCA5MCA5MCA5MCA1NSBi
OCAwMCAwMCAwMSAwMCA0OCA4OSBlNSBmMCAwZiBjMSAwNyA4OSBjMiBjMSBlYSAxMCA2NiAzOSBj
MiA3NCAxMyA2NiAwZiAxZiA4NCAwMCAwMCAwMCAwMCAwMCBmMyA5MCAwZiBiNyAwNyA8NjY+IDM5
IGQwIDc1IGY2IDVkIGMzIDBmIDFmIDQwIDAwIDhiIDE3IDU1IDMxIGMwIDQ4IDg5IGU1IDg5IGQx
DQpDYWxsIFRyYWNlOg0KIFs8ZmZmZmZmZmY4MTY2MDZiZT5dIF9yYXdfc3Bpbl9sb2NrKzB4ZS8w
eDIwDQogWzxmZmZmZmZmZmEwMWNjNTQ4Pl0geGxvZ19zdGF0ZV9nZXRfaWNsb2dfc3BhY2UrMHg1
OC8weDJlMCBbeGZzXQ0KIFs8ZmZmZmZmZmY4MTE2NjU1ZD5dID8ga21lbV9jYWNoZV9hbGxvYysw
eDExZC8weDE0MA0KIFs8ZmZmZmZmZmZhMDFjY2I5OT5dIHhsb2dfd3JpdGUrMHhlOS8weDQwMCBb
eGZzXQ0KIFs8ZmZmZmZmZmZhMDE4Yzg3Nz5dID8ga21lbV96b25lX2FsbG9jKzB4NjcvMHhlMCBb
eGZzXQ0KIFs8ZmZmZmZmZmZhMDFjZTQwYz5dIHhsb2dfY2lsX3B1c2grMHgyMGMvMHgzODAgW3hm
c10NCiBbPGZmZmZmZmZmYTAxY2VkMmU+XSB4bG9nX2NpbF9mb3JjZV9sc24rMHgxMGUvMHgxMjAg
W3hmc10NCiBbPGZmZmZmZmZmODExOWUwMzE+XSA/IHNldHhhdHRyKzB4ZDEvMHgxMjANCiBbPGZm
ZmZmZmZmYTAxY2QzNjc+XSBfeGZzX2xvZ19mb3JjZV9sc24rMHg1Ny8weDJlMCBbeGZzXQ0KIFs8
ZmZmZmZmZmY4MTY1Zjk4Nj5dID8gZG93bl9yZWFkKzB4MTYvMHgyYg0KIFs8ZmZmZmZmZmZhMDE3
ZDExNj5dID8geGZzX2l1bmxvY2srMHhlNi8weDE1MCBbeGZzXQ0KIFs8ZmZmZmZmZmZhMDE3OTEy
Mz5dID8geGZzX2ZpbGVfZnN5bmMrMHgxMTMvMHgzMDAgW3hmc10NCiBbPGZmZmZmZmZmYTAxNzky
MGM+XSB4ZnNfZmlsZV9mc3luYysweDFmYy8weDMwMCBbeGZzXQ0KIFs8ZmZmZmZmZmY4MTFhOGM1
Nj5dIGRvX2ZzeW5jKzB4NTYvMHg4MA0KIFs8ZmZmZmZmZmY4MTFhOGY4MD5dIHN5c19mc3luYysw
eDEwLzB4MjANCiBbPGZmZmZmZmZmODE2NjhkMDI+XSBzeXN0ZW1fY2FsbF9mYXN0cGF0aCsweDE2
LzB4MWINCg0KDQpCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzI4IHN0dWNrIGZvciAyMnMhIFtzd2lm
dC1vYmplY3Qtc2U6NDM1NF0NCk1vZHVsZXMgbGlua2VkIGluOiBpcG1pX3NpIG1wdDJzYXMgc2Nz
aV90cmFuc3BvcnRfc2FzIHJhaWRfY2xhc3MgbXB0Y3RsIG1wdGJhc2UgaXBtaV9kZXZpbnRmIGlw
bWlfbXNnaGFuZGxlciBkZWxsX3JidSB4ZnMgdmVzYWZiIDgwMjFxIGdhcnAgYm9uZGluZyBqb3lk
ZXYgYnJpZGdlIHN0cCBzaHBjaHAgZGNkYmFzIHNiX2VkYWMgbWFjX2hpZCBlZGFjX2NvcmUgd21p
IGFjcGlfcG93ZXJfbWV0ZXIgbHAgbWVpKEMpIHBhcnBvcnQgdXNiaGlkIGhpZCBpeGdiZSBtZGlv
IGlnYiBtZWdhcmFpZF9zYXMgZGNhIFtsYXN0IHVubG9hZGVkOiBpcG1pX3NpXQ0KQ1BVIDI4DQpN
b2R1bGVzIGxpbmtlZCBpbjogaXBtaV9zaSBtcHQyc2FzIHNjc2lfdHJhbnNwb3J0X3NhcyByYWlk
X2NsYXNzIG1wdGN0bCBtcHRiYXNlIGlwbWlfZGV2aW50ZiBpcG1pX21zZ2hhbmRsZXIgZGVsbF9y
YnUgeGZzIHZlc2FmYiA4MDIxcSBnYXJwIGJvbmRpbmcgam95ZGV2IGJyaWRnZSBzdHAgc2hwY2hw
IGRjZGJhcyBzYl9lZGFjIG1hY19oaWQgZWRhY19jb3JlIHdtaSBhY3BpX3Bvd2VyX21ldGVyIGxw
IG1laShDKSBwYXJwb3J0IHVzYmhpZCBoaWQgaXhnYmUgbWRpbyBpZ2IgbWVnYXJhaWRfc2FzIGRj
YSBbbGFzdCB1bmxvYWRlZDogaXBtaV9zaV0NCg0KUGlkOiA0MzU0LCBjb21tOiBzd2lmdC1vYmpl
Y3Qtc2UgVGFpbnRlZDogRyAgICAgICAgV0MgICAzLjIuMC01MS1nZW5lcmljICM3Ny1VYnVudHUg
RGVsbCBJbmMuIFBvd2VyRWRnZSBSNzIweGQvMFg2SDQ3DQpSSVA6IDAwMTA6WzxmZmZmZmZmZjgx
MDNlYmM1Pl0gIFs8ZmZmZmZmZmY4MTAzZWJjNT5dIF9fdGlja2V0X3NwaW5fbG9jaysweDI1LzB4
MzANClJTUDogMDAxODpmZmZmODgwMmEwZDk1YjY4ICBFRkxBR1M6IDAwMDAwMjkzDQpSQVg6IDAw
MDAwMDAwMDAwMDdjMWMgUkJYOiBmZmZmZmZmZjgxMTY0MWNmIFJDWDogZmZmZjg4MDgwODMwYTk2
MA0KUkRYOiAwMDAwMDAwMDAwMDA3YzFlIFJTSTogZmZmZjg4MDFjNjIzNWMwMCBSREk6IGZmZmY4
ODA4MjQyMGZlYTgNClJCUDogZmZmZjg4MDJhMGQ5NWI2OCBSMDg6IGZmZmY4ODAyYTBkOTVjYTAg
UjA5OiBmZmZmODgwMmEwZDk1Y2FjDQpSMTA6IDAwMDAwMDAwMDAwMDIxMzQgUjExOiAwMDAwMDAw
MDAwMDAwMDBhIFIxMjogZmZmZjg4MDJhMGQ5NWI1MA0KUjEzOiBmZmZmODgwODI0MjBmZTAwIFIx
NDogZmZmZjg4MDQyNGQ2NzZmOCBSMTU6IGZmZmY4ODAyYTBkOTVhZTgNCkZTOiAgMDAwMDdmM2Q4
ZGZmYjcwMCgwMDAwKSBHUzpmZmZmODgwNDJmZGMwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAw
MDAwMDANCkNTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMN
CkNSMjogMDAwMDdmM2RiY2QxYjAwMCBDUjM6IDAwMDAwMDA0MTQwYmYwMDAgQ1I0OiAwMDAwMDAw
MDAwMDQwNmUwDQpEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERS
MjogMDAwMDAwMDAwMDAwMDAwMA0KRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBm
ZmZmMGZmMCBEUjc6IDAwMDAwMDAwMDAwMDA0MDANClByb2Nlc3Mgc3dpZnQtb2JqZWN0LXNlIChw
aWQ6IDQzNTQsIHRocmVhZGluZm8gZmZmZjg4MDJhMGQ5NDAwMCwgdGFzayBmZmZmODgwMWM2MjM1
YzAwKQ0KU3RhY2s6DQogZmZmZjg4MDJhMGQ5NWI3OCBmZmZmZmZmZjgxNjYwNmJlIGZmZmY4ODAy
YTBkOTVjMTggZmZmZmZmZmZhMDFjYzU0OA0KIGZmZmY4ODAyYTBkOTVjYWMgZmZmZjg4MDJhMGQ5
NWNhMCBmZmZmODgwMmEwZDk1YzkwIDAwMDAyMjU0NjMyMmMwMDANCiAwMDAwMDAwMDAwMDE0NGMw
IGZmZmY4ODAxYzYyMzVjMDAgZmZmZjg4MDJhMGQ5NWRmNSAwMDAwMDAwMDAwMDAwMDBlDQpDYWxs
IFRyYWNlOg0KIFs8ZmZmZmZmZmY4MTY2MDZiZT5dIF9yYXdfc3Bpbl9sb2NrKzB4ZS8weDIwDQog
WzxmZmZmZmZmZmEwMWNjNTQ4Pl0geGxvZ19zdGF0ZV9nZXRfaWNsb2dfc3BhY2UrMHg1OC8weDJl
MCBbeGZzXQ0KIFs8ZmZmZmZmZmY4MTE2NjU1ZD5dID8ga21lbV9jYWNoZV9hbGxvYysweDExZC8w
eDE0MA0KIFs8ZmZmZmZmZmZhMDFjY2I5OT5dIHhsb2dfd3JpdGUrMHhlOS8weDQwMCBbeGZzXQ0K
IFs8ZmZmZmZmZmZhMDE4Yzg3Nz5dID8ga21lbV96b25lX2FsbG9jKzB4NjcvMHhlMCBbeGZzXQ0K
IFs8ZmZmZmZmZmZhMDFjZTQwYz5dIHhsb2dfY2lsX3B1c2grMHgyMGMvMHgzODAgW3hmc10NCiBb
PGZmZmZmZmZmYTAxY2VkMmU+XSB4bG9nX2NpbF9mb3JjZV9sc24rMHgxMGUvMHgxMjAgW3hmc10N
CiBbPGZmZmZmZmZmODExOWUwMzE+XSA/IHNldHhhdHRyKzB4ZDEvMHgxMjANCiBbPGZmZmZmZmZm
YTAxY2QzNjc+XSBfeGZzX2xvZ19mb3JjZV9sc24rMHg1Ny8weDJlMCBbeGZzXQ0KIFs8ZmZmZmZm
ZmY4MTY1Zjk4Nj5dID8gZG93bl9yZWFkKzB4MTYvMHgyYg0KIFs8ZmZmZmZmZmZhMDE3ZDExNj5d
ID8geGZzX2l1bmxvY2srMHhlNi8weDE1MCBbeGZzXQ0KIFs8ZmZmZmZmZmZhMDE3OTEyMz5dID8g
eGZzX2ZpbGVfZnN5bmMrMHgxMTMvMHgzMDAgW3hmc10NCiBbPGZmZmZmZmZmYTAxNzkyMGM+XSB4
ZnNfZmlsZV9mc3luYysweDFmYy8weDMwMCBbeGZzXQ0KIFs8ZmZmZmZmZmY4MTFhOGM1Nj5dIGRv
X2ZzeW5jKzB4NTYvMHg4MA0KIFs8ZmZmZmZmZmY4MTFhOGY4MD5dIHN5c19mc3luYysweDEwLzB4
MjANCiBbPGZmZmZmZmZmODE2NjhkMDI+XSBzeXN0ZW1fY2FsbF9mYXN0cGF0aCsweDE2LzB4MWIN
CkNvZGU6IDkwIDkwIDkwIDkwIDkwIDkwIDU1IGI4IDAwIDAwIDAxIDAwIDQ4IDg5IGU1IGYwIDBm
IGMxIDA3IDg5IGMyIGMxIGVhIDEwIDY2IDM5IGMyIDc0IDEzIDY2IDBmIDFmIDg0IDAwIDAwIDAw
IDAwIDAwIGYzIDkwIDBmIGI3IDA3IDw2Nj4gMzkgZDAgNzUgZjYgNWQgYzMgMGYgMWYgNDAgMDAg
OGIgMTcgNTUgMzEgYzAgNDggODkgZTUgODkgZDENCkNhbGwgVHJhY2U6DQogWzxmZmZmZmZmZjgx
NjYwNmJlPl0gX3Jhd19zcGluX2xvY2srMHhlLzB4MjANCiBbPGZmZmZmZmZmYTAxY2M1NDg+XSB4
bG9nX3N0YXRlX2dldF9pY2xvZ19zcGFjZSsweDU4LzB4MmUwIFt4ZnNdDQogWzxmZmZmZmZmZjgx
MTY2NTVkPl0gPyBrbWVtX2NhY2hlX2FsbG9jKzB4MTFkLzB4MTQwDQogWzxmZmZmZmZmZmEwMWNj
Yjk5Pl0geGxvZ193cml0ZSsweGU5LzB4NDAwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMThjODc3Pl0g
PyBrbWVtX3pvbmVfYWxsb2MrMHg2Ny8weGUwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWNlNDBjPl0g
eGxvZ19jaWxfcHVzaCsweDIwYy8weDM4MCBbeGZzXQ0KIFs8ZmZmZmZmZmZhMDFjZWQyZT5dIHhs
b2dfY2lsX2ZvcmNlX2xzbisweDEwZS8weDEyMCBbeGZzXQ0KIFs8ZmZmZmZmZmY4MTE5ZTAzMT5d
ID8gc2V0eGF0dHIrMHhkMS8weDEyMA0KIFs8ZmZmZmZmZmZhMDFjZDM2Nz5dIF94ZnNfbG9nX2Zv
cmNlX2xzbisweDU3LzB4MmUwIFt4ZnNdDQogWzxmZmZmZmZmZjgxNjVmOTg2Pl0gPyBkb3duX3Jl
YWQrMHgxNi8weDJiDQogWzxmZmZmZmZmZmEwMTdkMTE2Pl0gPyB4ZnNfaXVubG9jaysweGU2LzB4
MTUwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMTc5MTIzPl0gPyB4ZnNfZmlsZV9mc3luYysweDExMy8w
eDMwMCBbeGZzXQ0KIFs8ZmZmZmZmZmZhMDE3OTIwYz5dIHhmc19maWxlX2ZzeW5jKzB4MWZjLzB4
MzAwIFt4ZnNdDQogWzxmZmZmZmZmZjgxMWE4YzU2Pl0gZG9fZnN5bmMrMHg1Ni8weDgwDQogWzxm
ZmZmZmZmZjgxMWE4ZjgwPl0gc3lzX2ZzeW5jKzB4MTAvMHgyMA0KIFs8ZmZmZmZmZmY4MTY2OGQw
Mj5dIHN5c3RlbV9jYWxsX2Zhc3RwYXRoKzB4MTYvMHgxYg0KDQpCVUc6IHNvZnQgbG9ja3VwIC0g
Q1BVIzMwIHN0dWNrIGZvciAyMnMhIFt4ZnNhaWxkL3NkZjE6Mjg3Nl0NCk1vZHVsZXMgbGlua2Vk
IGluOiBpcG1pX3NpIG1wdDJzYXMgc2NzaV90cmFuc3BvcnRfc2FzIHJhaWRfY2xhc3MgbXB0Y3Rs
IG1wdGJhc2UgaXBtaV9kZXZpbnRmIGlwbWlfbXNnaGFuZGxlciBkZWxsX3JidSB4ZnMgdmVzYWZi
IDgwMjFxIGdhcnAgYm9uZGluZyBqb3lkZXYgYnJpZGdlIHN0cCBzaHBjaHAgZGNkYmFzIHNiX2Vk
YWMgbWFjX2hpZCBlZGFjX2NvcmUgd21pIGFjcGlfcG93ZXJfbWV0ZXIgbHAgbWVpKEMpIHBhcnBv
cnQgdXNiaGlkIGhpZCBpeGdiZSBtZGlvIGlnYiBtZWdhcmFpZF9zYXMgZGNhIFtsYXN0IHVubG9h
ZGVkOiBpcG1pX3NpXQ0KQ1BVIDMwDQpNb2R1bGVzIGxpbmtlZCBpbjogaXBtaV9zaSBtcHQyc2Fz
IHNjc2lfdHJhbnNwb3J0X3NhcyByYWlkX2NsYXNzIG1wdGN0bCBtcHRiYXNlIGlwbWlfZGV2aW50
ZiBpcG1pX21zZ2hhbmRsZXIgZGVsbF9yYnUgeGZzIHZlc2FmYiA4MDIxcSBnYXJwIGJvbmRpbmcg
am95ZGV2IGJyaWRnZSBzdHAgc2hwY2hwIGRjZGJhcyBzYl9lZGFjIG1hY19oaWQgZWRhY19jb3Jl
IHdtaSBhY3BpX3Bvd2VyX21ldGVyIGxwIG1laShDKSBwYXJwb3J0IHVzYmhpZCBoaWQgaXhnYmUg
bWRpbyBpZ2IgbWVnYXJhaWRfc2FzIGRjYSBbbGFzdCB1bmxvYWRlZDogaXBtaV9zaV0NCg0KUGlk
OiAyODc2LCBjb21tOiB4ZnNhaWxkL3NkZjEgVGFpbnRlZDogRyAgICAgICAgV0MgICAzLjIuMC01
MS1nZW5lcmljICM3Ny1VYnVudHUgRGVsbCBJbmMuIFBvd2VyRWRnZSBSNzIweGQvMFg2SDQ3DQpS
SVA6IDAwMTA6WzxmZmZmZmZmZjgxMDNlYmM1Pl0gIFs8ZmZmZmZmZmY4MTAzZWJjNT5dIF9fdGlj
a2V0X3NwaW5fbG9jaysweDI1LzB4MzANClJTUDogMDAxODpmZmZmODgwNDExMTZiYzIwICBFRkxB
R1M6IDAwMDAwMjk3DQpSQVg6IDAwMDAwMDAwMDAwMDA3ZTUgUkJYOiAwMDAwMDAwMDAwMDAwMDAw
IFJDWDogMDAwMDAwMDAwMDAwMDIzMQ0KUkRYOiAwMDAwMDAwMDAwMDAwN2U2IFJTSTogZmZmZjg4
MDgyNDIwZmVhOCBSREk6IGZmZmY4ODA4MjRiMzJlNzgNClJCUDogZmZmZjg4MDQxMTE2YmMyMCBS
MDg6IDAwMDAwMDAwMDAwMDAwMDEgUjA5OiAwMDAwMDAwMDAwMDAwMDAwDQpSMTA6IGZmZmY4ODA0
MTExNmJhMjQgUjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjogMDAwMDAwMDAwMDAwMDAwMQ0KUjEz
OiBmZmZmODgwN2VlZWRhZDgwIFIxNDogMDAwMzAwMDEwMDAwMDAwMCBSMTU6IGZmZmY4ODA0MTEx
NmJiODgNCkZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwNDJmZGUwMDAwKDAw
MDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDANCkNTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBD
UjA6IDAwMDAwMDAwODAwNTAwM2INCkNSMjogMDAwMDdmM2RiY2QxYjAwMCBDUjM6IDAwMDAwMDAw
MDFjMDUwMDAgQ1I0OiAwMDAwMDAwMDAwMDQwNmUwDQpEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIx
OiAwMDAwMDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMA0KRFIzOiAwMDAwMDAwMDAw
MDAwMDAwIERSNjogMDAwMDAwMDBmZmZmMGZmMCBEUjc6IDAwMDAwMDAwMDAwMDA0MDANClByb2Nl
c3MgeGZzYWlsZC9zZGYxIChwaWQ6IDI4NzYsIHRocmVhZGluZm8gZmZmZjg4MDQxMTE2YTAwMCwg
dGFzayBmZmZmODgwODE5ZDM1YzAwKQ0KU3RhY2s6DQogZmZmZjg4MDQxMTE2YmMzMCBmZmZmZmZm
ZjgxNjYwNmJlIGZmZmY4ODA0MTExNmJjNTAgZmZmZmZmZmZhMDFkMTNkNA0KIGZmZmY4ODA4MjQy
MGZlMDAgZmZmZjg4MDgyNDIwZmUwMCBmZmZmODgwNDExMTZiYzcwIGZmZmZmZmZmYTAxY2MzZmUN
CiBmZmZmODgwNDExMTZiY2MwIGZmZmY4ODA0MjEyMWM4MDAgZmZmZjg4MDQxMTE2YmNhMCBmZmZm
ZmZmZmEwMWNjNGQzDQpDYWxsIFRyYWNlOg0KIFs8ZmZmZmZmZmY4MTY2MDZiZT5dIF9yYXdfc3Bp
bl9sb2NrKzB4ZS8weDIwDQogWzxmZmZmZmZmZmEwMWQxM2Q0Pl0geGZzX2FpbF9taW5fbHNuKzB4
MjQvMHg2MCBbeGZzXQ0KIFs8ZmZmZmZmZmZhMDFjYzNmZT5dIHhsb2dfYXNzaWduX3RhaWxfbHNu
KzB4MWUvMHg0MCBbeGZzXQ0KIFs8ZmZmZmZmZmZhMDFjYzRkMz5dIHhsb2dfc3RhdGVfcmVsZWFz
ZV9pY2xvZysweGIzLzB4ZDAgW3hmc10NCiBbPGZmZmZmZmZmYTAxY2QxNTY+XSBfeGZzX2xvZ19m
b3JjZSsweDEyNi8weDJhMCBbeGZzXQ0KIFs8ZmZmZmZmZmY4MTA5MTZkNj5dID8gZG93bl90cnls
b2NrKzB4MzYvMHg1MA0KIFs8ZmZmZmZmZmZhMDFjZDJlOD5dIHhmc19sb2dfZm9yY2UrMHgxOC8w
eDQwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMTc2MGIwPl0geGZzX2J1Zl90cnlsb2NrKzB4ZDAvMHhl
MCBbeGZzXQ0KIFs8ZmZmZmZmZmZhMDFjZjFjOD5dIHhmc19idWZfaXRlbV90cnlsb2NrKzB4NTgv
MHhjMCBbeGZzXQ0KIFs8ZmZmZmZmZmZhMDFkMTc3YT5dIHhmc2FpbGRfcHVzaCsweDI0YS8weDY4
MCBbeGZzXQ0KIFs8ZmZmZmZmZmZhMDFkMWMxMj5dIHhmc2FpbGQrMHg2Mi8weGMwIFt4ZnNdDQog
WzxmZmZmZmZmZmEwMWQxYmIwPl0gPyB4ZnNhaWxkX3B1c2grMHg2ODAvMHg2ODAgW3hmc10NCiBb
PGZmZmZmZmZmODEwOGI3OGM+XSBrdGhyZWFkKzB4OGMvMHhhMA0KIFs8ZmZmZmZmZmY4MTY2YWU3
ND5dIGtlcm5lbF90aHJlYWRfaGVscGVyKzB4NC8weDEwDQogWzxmZmZmZmZmZjgxMDhiNzAwPl0g
PyBmbHVzaF9rdGhyZWFkX3dvcmtlcisweGEwLzB4YTANCiBbPGZmZmZmZmZmODE2NmFlNzA+XSA/
IGdzX2NoYW5nZSsweDEzLzB4MTMNCkNvZGU6IDkwIDkwIDkwIDkwIDkwIDkwIDU1IGI4IDAwIDAw
IDAxIDAwIDQ4IDg5IGU1IGYwIDBmIGMxIDA3IDg5IGMyIGMxIGVhIDEwIDY2IDM5IGMyIDc0IDEz
IDY2IDBmIDFmIDg0IDAwIDAwIDAwIDAwIDAwIGYzIDkwIDBmIGI3IDA3IDw2Nj4gMzkgZDAgNzUg
ZjYgNWQgYzMgMGYgMWYgNDAgMDAgOGIgMTcgNTUgMzEgYzAgNDggODkgZTUgODkgZDENCkNhbGwg
VHJhY2U6DQogWzxmZmZmZmZmZjgxNjYwNmJlPl0gX3Jhd19zcGluX2xvY2srMHhlLzB4MjANCiBb
PGZmZmZmZmZmYTAxZDEzZDQ+XSB4ZnNfYWlsX21pbl9sc24rMHgyNC8weDYwIFt4ZnNdDQogWzxm
ZmZmZmZmZmEwMWNjM2ZlPl0geGxvZ19hc3NpZ25fdGFpbF9sc24rMHgxZS8weDQwIFt4ZnNdDQog
WzxmZmZmZmZmZmEwMWNjNGQzPl0geGxvZ19zdGF0ZV9yZWxlYXNlX2ljbG9nKzB4YjMvMHhkMCBb
eGZzXQ0KIFs8ZmZmZmZmZmZhMDFjZDE1Nj5dIF94ZnNfbG9nX2ZvcmNlKzB4MTI2LzB4MmEwIFt4
ZnNdDQogWzxmZmZmZmZmZjgxMDkxNmQ2Pl0gPyBkb3duX3RyeWxvY2srMHgzNi8weDUwDQogWzxm
ZmZmZmZmZmEwMWNkMmU4Pl0geGZzX2xvZ19mb3JjZSsweDE4LzB4NDAgW3hmc10NCiBbPGZmZmZm
ZmZmYTAxNzYwYjA+XSB4ZnNfYnVmX3RyeWxvY2srMHhkMC8weGUwIFt4ZnNdDQogWzxmZmZmZmZm
ZmEwMWNmMWM4Pl0geGZzX2J1Zl9pdGVtX3RyeWxvY2srMHg1OC8weGMwIFt4ZnNdDQogWzxmZmZm
ZmZmZmEwMWQxNzdhPl0geGZzYWlsZF9wdXNoKzB4MjRhLzB4NjgwIFt4ZnNdDQogWzxmZmZmZmZm
ZmEwMWQxYzEyPl0geGZzYWlsZCsweDYyLzB4YzAgW3hmc10NCiBbPGZmZmZmZmZmYTAxZDFiYjA+
XSA/IHhmc2FpbGRfcHVzaCsweDY4MC8weDY4MCBbeGZzXQ0KIFs8ZmZmZmZmZmY4MTA4Yjc4Yz5d
IGt0aHJlYWQrMHg4Yy8weGEwDQogWzxmZmZmZmZmZjgxNjZhZTc0Pl0ga2VybmVsX3RocmVhZF9o
ZWxwZXIrMHg0LzB4MTANCiBbPGZmZmZmZmZmODEwOGI3MDA+XSA/IGZsdXNoX2t0aHJlYWRfd29y
a2VyKzB4YTAvMHhhMA0KIFs8ZmZmZmZmZmY4MTY2YWU3MD5dID8gZ3NfY2hhbmdlKzB4MTMvMHgx
Mw0KDQoNCkJVRzogc29mdCBsb2NrdXAgLSBDUFUjMCBzdHVjayBmb3IgMjJzISBba3dvcmtlci8w
OjM6Mjc1ODBdDQpNb2R1bGVzIGxpbmtlZCBpbjogaXBtaV9zaSBtcHQyc2FzIHNjc2lfdHJhbnNw
b3J0X3NhcyByYWlkX2NsYXNzIG1wdGN0bCBtcHRiYXNlIGlwbWlfZGV2aW50ZiBpcG1pX21zZ2hh
bmRsZXIgZGVsbF9yYnUgeGZzIHZlc2FmYiA4MDIxcSBnYXJwIGJvbmRpbmcgam95ZGV2IGJyaWRn
ZSBzdHAgc2hwY2hwIGRjZGJhcyBzYl9lZGFjIG1hY19oaWQgZWRhY19jb3JlIHdtaSBhY3BpX3Bv
d2VyX21ldGVyIGxwIG1laShDKSBwYXJwb3J0IHVzYmhpZCBoaWQgaXhnYmUgbWRpbyBpZ2IgbWVn
YXJhaWRfc2FzIGRjYSBbbGFzdCB1bmxvYWRlZDogaXBtaV9zaV0NCkNQVSAwDQpNb2R1bGVzIGxp
bmtlZCBpbjogaXBtaV9zaSBtcHQyc2FzIHNjc2lfdHJhbnNwb3J0X3NhcyByYWlkX2NsYXNzIG1w
dGN0bCBtcHRiYXNlIGlwbWlfZGV2aW50ZiBpcG1pX21zZ2hhbmRsZXIgZGVsbF9yYnUgeGZzIHZl
c2FmYiA4MDIxcSBnYXJwIGJvbmRpbmcgam95ZGV2IGJyaWRnZSBzdHAgc2hwY2hwIGRjZGJhcyBz
Yl9lZGFjIG1hY19oaWQgZWRhY19jb3JlIHdtaSBhY3BpX3Bvd2VyX21ldGVyIGxwIG1laShDKSBw
YXJwb3J0IHVzYmhpZCBoaWQgaXhnYmUgbWRpbyBpZ2IgbWVnYXJhaWRfc2FzIGRjYSBbbGFzdCB1
bmxvYWRlZDogaXBtaV9zaV0NCg0KUGlkOiAyNzU4MCwgY29tbToga3dvcmtlci8wOjMgVGFpbnRl
ZDogRyAgICAgICAgV0MgICAzLjIuMC01MS1nZW5lcmljICM3Ny1VYnVudHUgRGVsbCBJbmMuIFBv
d2VyRWRnZSBSNzIweGQvMFg2SDQ3DQpSSVA6IDAwMTA6WzxmZmZmZmZmZjgxMDNlYmMyPl0gIFs8
ZmZmZmZmZmY4MTAzZWJjMj5dIF9fdGlja2V0X3NwaW5fbG9jaysweDIyLzB4MzANClJTUDogMDAx
ODpmZmZmODgwMWFlYWUzZDQwICBFRkxBR1M6IDAwMDAwMjkzDQpSQVg6IDAwMDAwMDAwMDAwMDA3
ZTUgUkJYOiBmZmZmODgwMWFlYWUzY2QwIFJDWDogMDAwMDAwMDAwMDAwMDAwMw0KUkRYOiAwMDAw
MDAwMDAwMDAwN2U3IFJTSTogZmZmZjg4MDgyM2ExMTdkMCBSREk6IGZmZmY4ODA4MjRiMzJlNzgN
ClJCUDogZmZmZjg4MDFhZWFlM2Q0MCBSMDg6IGZmZmY4ODAxYWVhZTIwMDAgUjA5OiAwMDAwMDAw
MDAwMDAwMDkzDQpSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAwMDAwMDAwMDAwMDAxIFIx
MjogMDAwMDAwMDAwMDAwMDAwMg0KUjEzOiBmZmZmODgwNDJmYzEzN2MwIFIxNDogZmZmZjg4MDQy
NWEzN2EwMCBSMTU6IDAwMDAwMDAwMDAwMDAxNGINCkZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAw
KSBHUzpmZmZmODgwNDJmYzAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDANCkNTOiAg
MDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2INCkNSMjogMDAwMDdl
ZmZhOGI1MmVmNyBDUjM6IDAwMDAwMDAwMDFjMDUwMDAgQ1I0OiAwMDAwMDAwMDAwMDQwNmYwDQpE
UjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAw
MDAwMDAwMA0KRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBmZmZmMGZmMCBEUjc6
IDAwMDAwMDAwMDAwMDA0MDANClByb2Nlc3Mga3dvcmtlci8wOjMgKHBpZDogMjc1ODAsIHRocmVh
ZGluZm8gZmZmZjg4MDFhZWFlMjAwMCwgdGFzayBmZmZmODgwMGE1MDE1YzAwKQ0KU3RhY2s6DQog
ZmZmZjg4MDFhZWFlM2Q1MCBmZmZmZmZmZjgxNjYwNmJlIGZmZmY4ODAxYWVhZTNkODAgZmZmZmZm
ZmZhMDFjZmUxYg0KIGZmZmY4ODA2ZTNkM2RjNDggZmZmZjg4MDAzMzlmMTYwMCBmZmZmODgwNDIx
Yjc2OTQwIGZmZmY4ODAxYmJlNTM1MDANCiBmZmZmODgwMWFlYWUzZGEwIGZmZmZmZmZmYTAxY2Vm
MWMgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwNDIxYjc2OTQwDQpDYWxsIFRyYWNlOg0KIFs8ZmZm
ZmZmZmY4MTY2MDZiZT5dIF9yYXdfc3Bpbl9sb2NrKzB4ZS8weDIwDQogWzxmZmZmZmZmZmEwMWNm
ZTFiPl0geGZzX2J1Zl9pb2RvbmUrMHgyYi8weDYwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWNlZjFj
Pl0geGZzX2J1Zl9kb19jYWxsYmFja3MrMHgzYy8weDUwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWNl
Zjk2Pl0geGZzX2J1Zl9pb2RvbmVfY2FsbGJhY2tzKzB4NDYvMHgyMjAgW3hmc10NCiBbPGZmZmZm
ZmZmYTAxNzY4NDM+XSB4ZnNfYnVmX2lvZG9uZV93b3JrKzB4MjMvMHg1MCBbeGZzXQ0KIFs8ZmZm
ZmZmZmY4MTA4NWUzNz5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxMjcvMHg0NzANCiBbPGZmZmZmZmZm
ODEwODZmNDQ+XSB3b3JrZXJfdGhyZWFkKzB4MTY0LzB4MzcwDQogWzxmZmZmZmZmZjgxMDg2ZGUw
Pl0gPyBtYW5hZ2Vfd29ya2Vycy5pc3JhLjMxKzB4MTMwLzB4MTMwDQogWzxmZmZmZmZmZjgxMDhi
NzhjPl0ga3RocmVhZCsweDhjLzB4YTANCiBbPGZmZmZmZmZmODE2NmFlNzQ+XSBrZXJuZWxfdGhy
ZWFkX2hlbHBlcisweDQvMHgxMA0KIFs8ZmZmZmZmZmY4MTA4YjcwMD5dID8gZmx1c2hfa3RocmVh
ZF93b3JrZXIrMHhhMC8weGEwDQogWzxmZmZmZmZmZjgxNjZhZTcwPl0gPyBnc19jaGFuZ2UrMHgx
My8weDEzDQpDb2RlOiA5MCA5MCA5MCA5MCA5MCA5MCA5MCA5MCA5MCA1NSBiOCAwMCAwMCAwMSAw
MCA0OCA4OSBlNSBmMCAwZiBjMSAwNyA4OSBjMiBjMSBlYSAxMCA2NiAzOSBjMiA3NCAxMyA2NiAw
ZiAxZiA4NCAwMCAwMCAwMCAwMCAwMCBmMyA5MCA8MGY+IGI3IDA3IDY2IDM5IGQwIDc1IGY2IDVk
IGMzIDBmIDFmIDQwIDAwIDhiIDE3IDU1IDMxIGMwIDQ4IDg5DQpDYWxsIFRyYWNlOg0KIFs8ZmZm
ZmZmZmY4MTY2MDZiZT5dIF9yYXdfc3Bpbl9sb2NrKzB4ZS8weDIwDQogWzxmZmZmZmZmZmEwMWNm
ZTFiPl0geGZzX2J1Zl9pb2RvbmUrMHgyYi8weDYwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWNlZjFj
Pl0geGZzX2J1Zl9kb19jYWxsYmFja3MrMHgzYy8weDUwIFt4ZnNdDQogWzxmZmZmZmZmZmEwMWNl
Zjk2Pl0geGZzX2J1Zl9pb2RvbmVfY2FsbGJhY2tzKzB4NDYvMHgyMjAgW3hmc10NCiBbPGZmZmZm
ZmZmYTAxNzY4NDM+XSB4ZnNfYnVmX2lvZG9uZV93b3JrKzB4MjMvMHg1MCBbeGZzXQ0KIFs8ZmZm
ZmZmZmY4MTA4NWUzNz5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxMjcvMHg0NzANCiBbPGZmZmZmZmZm
ODEwODZmNDQ+XSB3b3JrZXJfdGhyZWFkKzB4MTY0LzB4MzcwDQogWzxmZmZmZmZmZjgxMDg2ZGUw
Pl0gPyBtYW5hZ2Vfd29ya2Vycy5pc3JhLjMxKzB4MTMwLzB4MTMwDQogWzxmZmZmZmZmZjgxMDhi
NzhjPl0ga3RocmVhZCsweDhjLzB4YTANCiBbPGZmZmZmZmZmODE2NmFlNzQ+XSBrZXJuZWxfdGhy
ZWFkX2hlbHBlcisweDQvMHgxMA0KIFs8ZmZmZmZmZmY4MTA4YjcwMD5dID8gZmx1c2hfa3RocmVh
ZF93b3JrZXIrMHhhMC8weGEwDQogWzxmZmZmZmZmZjgxNjZhZTcwPl0gPyBnc19jaGFuZ2UrMHgx
My8weDEzDQoNCg==
------=_Part_8186919_654588180.1412777666395
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_Part_8186919_654588180.1412777666395--
