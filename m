Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 12 Sep 2008 03:15:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8CAFRR9015192
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 03:15:33 -0700
Received: from smtp5-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8DA38D1814
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 03:16:55 -0700 (PDT)
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35]) by cuda.sgi.com with ESMTP id ljaU7RqJlAm6BZ3H for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 03:16:55 -0700 (PDT)
Received: from smtp5-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp5-g19.free.fr (Postfix) with ESMTP id 943C71C73C6
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 12:16:54 +0200 (CEST)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
	by smtp5-g19.free.fr (Postfix) with ESMTP id 61E6F1C7343
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 12:16:53 +0200 (CEST)
Date: Fri, 12 Sep 2008 12:16:55 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: What happened to my XFS?
Message-ID: <20080912121655.7430a630@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hi everyone. I've met what looks like an XFS bug that I'd like to share
with you :

Unable to handle kernel paging request at ffff910002ac0540 RIP: 
 [<ffffffff8038a0bb>] xfs_is_delayed_page+0x3b/0x80
PGD 0 
Oops: 0000 [1] SMP 
CPU 3 
Modules linked in: bonding md_mod ipv6 fan ac battery dm_snapshot
dm_mirror dm_mod af_packet sg loop usbhid uhci_hcd usb_storage e1000
thermal i2c_nforce2 8250_pnp 8250 shpchp k8temp forcedeth ehci_hcd rtc
serial_core pci_hotplug pcspkr ohci_hcd button processor i2c_core
usbcore evdev 3w_9xxx sata_nv libata Pid: 7462, comm: pdflush Not
tainted 2.6.24.7-storiq64-opteron #1 RIP: 0010:[<ffffffff8038a0bb>]
[<ffffffff8038a0bb>] xfs_is_delayed_page+0x3b/0x80 RSP:
0000:ffff81036df1b9b8  EFLAGS: 00010287 RAX: 0000000000000223 RBX:
ffff81041ce64c88 RCX: 0000000000000001 RDX: ffff910002ac0540 RSI:
0000000000000004 RDI: ffff810002ac0540 RBP: 00000000000a611f R08:
ffff81036df1bbe8 R09: ffff81036df1be80 R10: ffff81041ce0aa88 R11:
0000000000000000 R12: ffff8102507fc0c0 R13: 0000000000000000 R14:
ffff81036df1bbb0 R15: ffff81036df1bbe8 FS:  00002b3c80536640(0000)
GS:ffff81041811f640(0000) knlGS:00000000f57bebb0 CS:  0010 DS: 0018 ES:
0018 CR0: 000000008005003b CR2: ffff910002ac0540 CR3: 0000000415ec6000
CR4: 00000000000006a0 DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400 Process pdflush (pid: 7462, threadinfo
ffff81036df1a000, task ffff810417113040) Stack:  ffffffff8038a234
0000000000001000 ffff81036df1be80 ffff810002ac05a8 00000000a611f000
0000000c507fc1e8 0000000100000000 0000000100000000 00000000a611e000
00000000a611f000 00000000000a6120 ffff81036df1bac0 Call Trace:
[<ffffffff8038a234>] xfs_convert_page+0xb4/0x3c0 [<ffffffff8038a622>]
xfs_cluster_write+0xe2/0x150 [<ffffffff8038adbb>]
xfs_page_state_convert+0x55b/0x660 [<ffffffff8038afff>]
xfs_vm_writepage+0x6f/0x120 [<ffffffff802706ba>] __writepage+0xa/0x30
[<ffffffff80270c94>] write_cache_pages+0x224/0x360 [<ffffffff802706b0>]
__writepage+0x0/0x30 [<ffffffff80270e20>] do_writepages+0x20/0x40
[<ffffffff802b4237>] __writeback_single_inode+0xa7/0x370
[<ffffffff8038bbbe>] xfs_buf_rele+0x2e/0xd0
[<ffffffff88147425>] :dm_mod:dm_table_any_congested+0x15/0x80
[<ffffffff8037d8ec>] xfs_trans_first_ail+0x1c/0x40 [<ffffffff802b4908>]
sync_sb_inodes+0x1f8/0x2f0 [<ffffffff802b4df0>]
writeback_inodes+0xa0/0xe0 [<ffffffff80271846>] wb_kupdate+0xa6/0x120
 [<ffffffff80271ce0>] pdflush+0x0/0x220
 [<ffffffff80271ce0>] pdflush+0x0/0x220
 [<ffffffff80271e20>] pdflush+0x140/0x220
 [<ffffffff802717a0>] wb_kupdate+0x0/0x120
 [<ffffffff8024fa6b>] kthread+0x4b/0x80
 [<ffffffff8020ca38>] child_rip+0xa/0x12
 [<ffffffff8024fa20>] kthread+0x0/0x80
 [<ffffffff8020ca2e>] child_rip+0x0/0x12


Code: 8b 02 f6 c4 40 75 e8 8b 02 f6 c4 02 74 14 48 8b 52 08 31 c9 
RIP  [<ffffffff8038a0bb>] xfs_is_delayed_page+0x3b/0x80
 RSP <ffff81036df1b9b8>
CR2: ffff910002ac0540
---[ end trace e8e52ecc06b16af5 ]---

This is a 39TB XFS filesystem, that I use for a PVFS2 cluster. I'm
running the following hardware configuration :

3 identical servers with 2 Opteron dual core, running Linux 2.6.24.7 in
64 bits mode, SMP and NUMA (debian etch), 4GB RAM, 48 1TB Seagate
drives, in 2 striped (LVM2) RAID-6 arrays.

The crash occured  while testing the PVFS2 cluster ( multiple parallel
writing workers), so the storage layering goes as :

 dd->pvfs2-client (vfs module)->pvfs2-server->XFS->LVM2->hardware RAID.

Everything was perfectly fine after a reboot of the faulty server. I
had to use magic sysrq to sync disks and force reboot, though...

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
