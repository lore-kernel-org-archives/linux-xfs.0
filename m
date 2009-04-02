Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n322mUi5116649 for <xfs@oss.sgi.com>; Wed, 1 Apr 2009 21:48:40 -0500
Received: from ns1.signalpunk.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E28EB13E9BFE
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2009 19:48:41 -0700 (PDT)
Received: from ns1.signalpunk.com (ns1.signalpunk.com [74.86.59.106]) by
	cuda.sgi.com with ESMTP id 8bnHERHSUDXD47Cl for
	<xfs@oss.sgi.com>; Wed, 01 Apr 2009 19:48:41 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by ns1.signalpunk.com (Postfix) with ESMTP id E96D358172800
	for <xfs@oss.sgi.com>; Thu,  2 Apr 2009 02:47:44 +0000 (GMT)
Date: Thu, 2 Apr 2009 02:47:44 +0000
From: Christopher Layne <clayne@anodized.com>
Subject: xfs_trans_log_inode: OOPS in 2.6.28.7
Message-ID: <20090402024744.GB23044@ns1.signalpunk.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

While I think I might be able to reproduce this it's not something I
particularly want to reproduce. The precursor was cancelling an
already running xfs_fsr, removing the .fsr_last, and immediately
restarting it (forcing a new cycle). Right after I received an OOPS and
all file system access was blocked necessitating a hard reboot and
xfs_repair.

-cl

[493260.254041] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[493260.254041] IP: [<ffffffff80315a1d>] xfs_trans_find_item+0x1/0xa
[493260.254041] PGD 63143067 PUD 41bf067 PMD 0
[493260.254041] Oops: 0000 [#1] SMP
[493260.254041] last sysfs file: /sys/devices/pci0000:00/0000:00:05.1/host2/target2:0:0/2:0:0:0/queue_depth
[493260.254286] CPU 0
[493260.254443] Modules linked in: hid_dell hid_pl hid_cypress hid_gyration hid_bright hid_sony hid_samsung hid_microsoft hid_monterey hid_ezkey hid_apple hid_a4tech hid_logitech hid_cherry hid_sunplus hid_petalynx hid_belkin hid_chicony usbhid hid usb_storage ohci_hcd ehci_hcd k8temp hwmon usbcore
[493260.255847] Pid: 4024, comm: xfs_fsr Not tainted 2.6.28.7 #3
[493260.255847] RIP: 0010:[<ffffffff80315a1d>]  [<ffffffff80315a1d>] xfs_trans_find_item+0x1/0xa
[493260.255847] RSP: 0018:ffff880002ec1b78  EFLAGS: 00010296
[493260.255847] RAX: 0000000000000008 RBX: ffff88006759d048 RCX: ffff88002ccf7c20
[493260.256085] RDX: 0000000000000005 RSI: 0000000000000000 RDI: ffff88006759d048
[493260.256398] RBP: ffff880002ec1ba8 R08: 0000000000000000 R09: ffff88002ccf7c50
[493260.256710] R10: ffa5a5a5a5a5a5a5 R11: 0000000204cb1be0 R12: ffff88002ccf7bc0
[493260.257025] R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000005
[493260.257342] FS:  00007f633b1f46f0(0000) GS:ffffffff80664040(0000) knlGS:0000000000000000
[493260.257659] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[493260.257821] CR2: 0000000000000018 CR3: 000000006183b000 CR4: 00000000000006e0
[493260.258138] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[493260.258455] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[493260.258771] Process xfs_fsr (pid: 4024, threadinfo ffff880002ec0000, task ffff880002e48740)
[493260.259090] Stack:
[493260.259247]  ffff880002ec1ba8 ffffffff8031586c ffff88002ccf7bc0 0000000000000000
[493260.259415]  ffff88002ccf7bc0 ffff88002ccf7c50 ffff880002ec1cd8 ffffffff802e8a8f
[493260.259735]  ffff880002ec1c9c 0000000000000000 ffff880000000000 0000000000000000
[493260.260209] Call Trace:
[493260.260367]  [<ffffffff8031586c>] ? xfs_trans_log_inode+0x22/0x4c
[493260.260531]  [<ffffffff802e8a8f>] xfs_bunmapi+0x738/0x782
[493260.260695]  [<ffffffff80303d77>] xfs_itruncate_finish+0x160/0x27b
[493260.260860]  [<ffffffff80319cda>] xfs_inactive+0x1e3/0x411
[493260.261023]  [<ffffffff8034007b>] ? __up_read+0x8f/0x98
[493260.263061]  [<ffffffff80323af5>] xfs_fs_clear_inode+0xbf/0x106
[493260.263061]  [<ffffffff8029cc44>] clear_inode+0x71/0xca
[493260.263061]  [<ffffffff8029d13b>] generic_delete_inode+0x8b/0xf3
[493260.263061]  [<ffffffff8029d1ba>] generic_drop_inode+0x17/0x169
[493260.263061]  [<ffffffff8029c2bf>] iput+0x61/0x65
[493260.263061]  [<ffffffff80299a93>] dentry_iput+0x8e/0x9e
[493260.263061]  [<ffffffff80299b70>] d_kill+0x34/0x54
[493260.263061]  [<ffffffff8029a360>] dput+0x130/0x13d
[493260.263061]  [<ffffffff8028cdeb>] __fput+0x16b/0x18f
[493260.263061]  [<ffffffff8028ce24>] fput+0x15/0x17
[493260.263061]  [<ffffffff8028a482>] filp_close+0x67/0x72
[493260.263061]  [<ffffffff8028a526>] sys_close+0x99/0xd2
[493260.263061]  [<ffffffff8020b34b>] system_call_fastpath+0x16/0x1b
[493260.263061] Code: 66 83 4b 64 04 48 8b 45 d0 4c 89 a0 a0 00 00 00 48 8b 45 d0 49 89 07 48 83 c4 28 44 89 e8 5b 41 5c 41 5d 41 5e 41 5f c9 c3 90 55 <48> 8b 46 18 48 89 e5 c9 c3 55 8a 56 0b 31 ff 41 ba 01 00 00 00
[493260.263061] RIP  [<ffffffff80315a1d>] xfs_trans_find_item+0x1/0xa
[493260.263061]  RSP <ffff880002ec1b78>
[493260.263061] CR2: 0000000000000018
[493260.263067] ---[ end trace 9923f588304d7b6d ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
