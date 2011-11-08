Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8GdITU132787 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 10:39:18 -0600
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 682118F8033
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 08:39:15 -0800 (PST)
Date: Tue, 8 Nov 2011 10:39:32 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [BUG] assert in xfs_imap_to_bp, line 185
Message-ID: <20111108163932.GA22095@sgi.com>
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

Hi XFS Folks,

I am able to hit this assert consistently when running test 111 on recent
(commit 9e4c109a) oss xfs bits:

[ 1930.808669] XFS (sdb4): Corruption detected. Unmount and run xfs_repair
[ 1930.808676] XFS (sdb4): bad inode magic/vsn daddr 64 #8 (magic=5858)
[ 1930.815037] XFS: Assertion failed: 0, file: /root/xfs/fs/xfs/xfs_inode.c, line: 185
[ 1930.822727] ------------[ cut here ]------------
[ 1930.826688] kernel BUG at /root/xfs/fs/xfs/xfs_message.c:101!
[ 1930.826688] invalid opcode: 0000 [#1] SMP
[ 1930.826688] CPU 2
[ 1930.826688] Modules linked in: xfs exportfs af_packet microcode fuse loop dm_mod e1000 shpchp iTCO_wdt tpm_tis tpm sg sr_mod pci_hotplug cdrom serio_raw iTCO_vendor_support floppy intel_rng tpm_bios e752x_e
dac edac_core pcspkr i2c_i801 i2c_core container button uhci_hcd ehci_hcd usbcore sd_mod crc_t10dif edd ext3 mbcache jbd fan processor ide_pci_generic piix ide_core ata_generic ata_piix libata aic79xx scsi_tra
nsport_spi scsi_mod thermal thermal_sys hwmon
[ 1930.826688]
[ 1930.826688] Pid: 1894, comm: mount Not tainted 3.1.0-rc9-0.7-default+ #2 Supermicro X6DHR-8G/X6DHR-8GS/X6DHR-8G/X6DHR-8GS
[ 1930.826688] RIP: 0010:[<ffffffffa02e942d>]  [<ffffffffa02e942d>] assfail+0x1d/0x30 [xfs]
[ 1930.826688] RSP: 0018:ffff8801fd157b38  EFLAGS: 00010292
[ 1930.826688] RAX: 000000000000005d RBX: 0000000000000008 RCX: 00000000000016a1
[ 1930.826688] RDX: 000000000000b4a9 RSI: 0000000000000046 RDI: 0000000000000246
[ 1930.826688] RBP: ffff8801fd157b38 R08: 0000000000000005 R09: 0000000000000000
[ 1930.826688] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88021ed0a800
[ 1930.826688] R13: 0000000000000020 R14: ffff88021f4ca800 R15: 0000000000000000
[ 1930.826688] FS:  00007fe83ed507c0(0000) GS:ffff88022fd00000(0000) knlGS:0000000000000000
[ 1930.826688] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1930.826688] CR2: 00007f4bc6f92bd0 CR3: 00000001fd7ff000 CR4: 00000000000006e0
[ 1930.826688] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1930.826688] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1930.826688] Process mount (pid: 1894, threadinfo ffff8801fd156000, task ffff88020e10e200)
[ 1930.826688] Stack:
[ 1930.826688]  ffff8801fd157bb8 ffffffffa032d0a4 ffffffffa032fb7c ffff88020ec4ce00
[ 1930.826688]  0000000000000000 ffff8801fd157bd8 ffff8802027cb020 0000000000000000
[ 1930.826688]  ffff88021f4caa20 00000000000002d0 ffff88020ec4ce00 0000000000000000
[ 1930.826688] Call Trace:
[ 1930.826688]  [<ffffffffa032d0a4>] xfs_imap_to_bp+0x154/0x260 [xfs]
[ 1930.826688]  [<ffffffffa032fb7c>] ? xfs_iread+0x7c/0x220 [xfs]
[ 1930.826688]  [<ffffffffa032fb7c>] xfs_iread+0x7c/0x220 [xfs]
[ 1930.826688]  [<ffffffffa02e2970>] xfs_iget+0x1d0/0x5a0 [xfs]
[ 1930.826688]  [<ffffffffa033870a>] xfs_mountfs+0x37a/0x670 [xfs]
[ 1930.826688]  [<ffffffffa02ebd5f>] xfs_fs_fill_super+0x1bf/0x270 [xfs]
[ 1930.826688]  [<ffffffff8110e98e>] mount_bdev+0x17e/0x200
[ 1930.826688]  [<ffffffffa02ebba0>] ? xfs_parseargs+0xbd0/0xbd0 [xfs]
[ 1930.826688]  [<ffffffffa02e9e50>] xfs_fs_mount+0x10/0x20 [xfs]
[ 1930.826688]  [<ffffffff8110e098>] mount_fs+0x48/0x190
[ 1930.826688]  [<ffffffff811294b5>] vfs_kern_mount+0x65/0xc0
[ 1931.070470]  [<ffffffff8112958e>] do_kern_mount+0x4e/0x100
[ 1931.070470]  [<ffffffff8112a3d3>] do_mount+0x3c3/0x810
[ 1931.070470]  [<ffffffff810d254b>] ? strndup_user+0x5b/0x70
[ 1931.070470]  [<ffffffff8112a8d3>] sys_mount+0xb3/0xe0
[ 1931.070470]  [<ffffffff8139f0d2>] system_call_fastpath+0x16/0x1b
[ 1931.070470] Code: 00 00 00 48 89 45 c8 e8 72 fc ff ff c9 c3 55 41 89 d0 48 89 f1 48 89 fa 48 c7 c6 68 c6 35 a0 31 ff 48 89 e5 31 c0 e8 93 ff ff ff <0f> 0b eb fe 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
55 4c
[ 1931.070470] RIP  [<ffffffffa02e942d>] assfail+0x1d/0x30 [xfs]
[ 1931.070470]  RSP <ffff8801fd157b38>

Does this ring a bell for anyone?  I should mention that this is a machine
recently set up for this purpose, so there isn't a history of it working
correctly before... I will go back a release or two and try to reproduce
this.

THanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
