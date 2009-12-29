Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBTIVcL8176035 for <xfs@oss.sgi.com>; Tue, 29 Dec 2009 12:31:38 -0600
Received: from smtpout8.poczta.onet.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5163E1C2048E
	for <xfs@oss.sgi.com>; Tue, 29 Dec 2009 10:32:24 -0800 (PST)
Received: from smtpout8.poczta.onet.pl (smtpout8.poczta.onet.pl
	[213.180.147.168]) by cuda.sgi.com with ESMTP id
	765tra5g25GAGDx9 for <xfs@oss.sgi.com>;
	Tue, 29 Dec 2009 10:32:24 -0800 (PST)
Received: from ip-213-17-136-130.netia.com.pl ([213.17.136.130]:38430 "EHLO
	[192.168.0.102]" rhost-flags-OK-FAIL-OK-FAIL) by ps4.m5r2.onet
	with ESMTPSA id S134218252AbZL2ScXURtw- (ORCPT
	<rfc822;xfs@oss.sgi.com>); Tue, 29 Dec 2009 19:32:23 +0100
Message-ID: <4B3A47F8.2020100@poczta.onet.pl>
Date: Tue, 29 Dec 2009 19:18:32 +0100
From: aluno3 <aluno3@poczta.onet.pl>
MIME-Version: 1.0
Subject: Call trace with 2.6.27.39
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi
 
I have tested kernel 2.6.27.39 with fsstress, LVM, DD and snapshots and after a few hours I got call trace.I had 2 volumes and 10 snapshots for each volume.I created and deleted these snapshots from time to time and wrote to origin volumes with use DD from /dev/zero.Fsstress was run for 1 volume.


Filesystem "dm-41": xfs_log_force: error 5 returned.
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff802e99c3>] bdevname+0x3/0x20
PGD 0 
Oops: 0000 [1] SMP 
CPU 0 
Modules linked in: iscsi_scst scst_vdisk scst drbd twofish twofish_common serpent blowfish cast5 sha256_generic crypto_null iscsi_tcp libiscsi scsi_transport_iscsi bonding button thermal processor e1000e sg ftdi_sio usbserial nls_iso8859_1 nls_cp437 arcmsr uhci_hcd ohci_hcd ehci_hcd vfat fat aufs [last unloaded: ohci_hcd]
Pid: 404, comm: xfslogd/0 Not tainted 2.6.27.39 #65
RIP: 0010:[<ffffffff802e99c3>]  [<ffffffff802e99c3>] bdevname+0x3/0x20
RSP: 0000:ffff88021d957de8  EFLAGS: 00010286
RAX: ffff88021d957e00 RBX: ffff88007fbf6cc0 RCX: 0000000001770520
RDX: ffff88007fbf6cc0 RSI: ffff88021d957e00 RDI: 0000000000000000
RBP: ffff880207fe8800 R08: ffff88021d956000 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff803d5020 R12: 0000000001770520
R13: ffffffff8078cf02 R14: ffff88021d957e00 R15: 0000000000000005
FS:  0000000000000000(0000) GS:ffffffff80952080(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process xfslogd/0 (pid: 404, threadinfo ffff88021d956000, task ffff88021fafd890)
Stack:  ffffffff803e7526 ffff880028046970 ffffffff80817020 ffff88021d957e38
 00000000ffff8b92 ffff88021fafdac0 ffff88021fafd890 000000001d957eb8
 ffff880207fe8800 ffff88007fbf6cc0 ffff88021d937bc8 ffff88021d937bc8
Call Trace:
 [<ffffffff803e7526>] ? xfs_ioerror_alert+0x56/0xc0
 [<ffffffff803d5060>] ? xlog_recover_iodone+0x40/0x90
 [<ffffffff803eaa60>] ? xfs_buf_iodone_work+0x0/0x80
 [<ffffffff8024692a>] ? run_workqueue+0x5a/0x110
 [<ffffffff80246a7c>] ? worker_thread+0x9c/0xf0
 [<ffffffff8024a7b0>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff8024a7b0>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff802469e0>] ? worker_thread+0x0/0xf0
 [<ffffffff80249fcc>] ? kthread+0x6c/0xa0
 [<ffffffff8020d1c9>] ? child_rip+0xa/0x11
 [<ffffffff80249f60>] ? kthread+0x0/0xa0
 [<ffffffff8020d1bf>] ? child_rip+0x0/0x11


Code: 13 00 48 89 d8 5b c3 48 89 df 48 c7 c2 ea b5 7a 80 be 20 00 00 00 31 c0 e8 cb e7 13 00 48 89 d8 5b c3 66 66 90 66 66 90 48 89 f0 <8b> 37 48 8b bf 98 00 00 00 48 89 c2 81 e6 ff ff 0f 00 2b 77 04 
RIP  [<ffffffff802e99c3>] bdevname+0x3/0x20
 RSP <ffff88021d957de8>
CR2: 0000000000000000
---[ end trace e0541894570554ab ]---
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
