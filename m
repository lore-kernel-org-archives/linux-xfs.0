Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Sep 2006 06:18:32 -0700 (PDT)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.239])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k85DILDW015668
	for <xfs@oss.sgi.com>; Tue, 5 Sep 2006 06:18:22 -0700
Received: by wx-out-0506.google.com with SMTP id h29so2182627wxd
        for <xfs@oss.sgi.com>; Tue, 05 Sep 2006 06:17:47 -0700 (PDT)
Message-ID: <2260b150609050427p3123cb85q5af484d8b907e6ac@mail.gmail.com>
Date: Tue, 5 Sep 2006 21:27:04 +1000
From: "Chris Seufert" <seufert@gmail.com>
Subject: Kernel Ooops
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I have had this one before, and i had assumed it had been fixed.

System seems very stable running ext3, so i dont 'think' its hardware
related, but i am begining to wonder.

Unable to handle kernel NULL pointer dereference at 00000000000000a8 RIP:
 [<ffffffff8031dd16>] xfs_btree_init_cursor+0x48/0x1bd
PGD 2cdb5067 PUD 2cd95067 PMD 0
Oops: 0000 [1] SMP
last sysfs file: /devices/pci0000:00/0000:00:08.0/host4/target4:0:0/4:0:0:0/type
CPU 0
Modules linked in: ipv6 thermal fan button processor ac battery
parport_pc parport floppy pcspkr k8_edac edac_mc generic amd74xx
ehci_hcd ohci_hcd i2c_nforce2 i2c_core ide_scsi tg3 e100 mii psmouse
ide_generic ide_disk ide_cd ide_core rtc unix
Pid: 3986, comm: proftpd Not tainted 2.6.18-rc2-mm1 #4
RIP: 0010:[<ffffffff8031dd16>]  [<ffffffff8031dd16>]
xfs_btree_init_cursor+0x48/0x1bd
RSP: 0018:ffff81002cd37a38  EFLAGS: 00010293
RAX: ffff81002c99fb00 RBX: 0000000000000000 RCX: ffff81002c99fb00
RDX: 0000001000020250 RSI: 0000000000000250 RDI: ffff81002c99fbc0
RBP: ffff81003e2ab800 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff81002c846718
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000002
FS:  00002af412fbf6d0(0000) GS:ffffffff8060c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000000a8 CR3: 000000002cd6f000 CR4: 00000000000006e0
Process proftpd (pid: 3986, threadinfo ffff81002cd36000, task ffff81003d5947a0)
Stack:  ffff81003e2ab800 0000000000000000 ffff81002c846718 0000000000000001
 ffff81002c846718 0000000000000001 0000000000000482 ffffffff80306f3b
 0000000000000000 ffff81003ee08f40 0000000200000000 0000000000000000
Call Trace:
 [<ffffffff80306f3b>] xfs_free_ag_extent+0x4e/0x67f
 [<ffffffff8025449d>] cache_alloc_refill+0xdb/0x1f6
 [<ffffffff8025bec9>] __down_read+0x12/0x9a
 [<ffffffff80308995>] xfs_free_extent+0xb5/0xd3
 [<ffffffff80344338>] xfs_trans_get_efd+0x21/0x29
 [<ffffffff803156f8>] xfs_bmap_finish+0xf0/0x169
 [<ffffffff80341949>] xfs_rename+0x89e/0xa98
 [<ffffffff803535fb>] xfs_vn_rename+0x2c/0x6f
 [<ffffffff8020da8d>] link_path_walk+0xd3/0xe5
 [<ffffffff8021ef6c>] __up_read+0x13/0xa9
 [<ffffffff8032f8eb>] xfs_iunlock+0x57/0x79
 [<ffffffff8021ef6c>] __up_read+0x13/0xa9
 [<ffffffff8032f8eb>] xfs_iunlock+0x57/0x79
 [<ffffffff80226ba5>] vfs_rename+0x252/0x3a5
 [<ffffffff80231f88>] sys_renameat+0x180/0x1f9
 [<ffffffff80220425>] sys_newstat+0x19/0x31
 [<ffffffff80254f36>] system_call+0x7e/0x83


Code: 49 8b 95 a8 00 00 00 89 d8 8b 44 82 1c 0f c8 e9 85 00 00 00
RIP  [<ffffffff8031dd16>] xfs_btree_init_cursor+0x48/0x1bd
 RSP <ffff81002cd37a38>
CR2: 00000000000000a8
