Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E36207F50
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 09:19:34 -0600 (CST)
Date: Fri, 22 Feb 2013 09:19:31 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/9] xfs: metadata CRCs, kernel, first batch
Message-ID: <20130222151931.GU22182@sgi.com>
References: <1358774760-21841-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1358774760-21841-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave,

Dunno if you've seen this one:

BUG: unable to handle kernel NULL pointer dereference at 00000000000000d0
[601393.932814] IP: [<ffffffffa06e5dcc>] xfs_dquot_buf_verify+0x1c/0xb0 [xfs]
[601393.932814] PGD 1f226d067 PUD 1ec0ae067 PMD 0
[601393.932814] Oops: 0000 [#1] SMP
[601393.932814] Modules linked in: xfs(O) autofs4 binfmt_misc ipmi_devintf ipmi_si ipmi_msghandler nfsv3 nfs_acl iptable_filter ip_tables x_tables nfs fscache dns_resolver lockd sunrpc af_packet
 rdma_ucm rdma_cm iw_cm ib_addr ib_ipoib ib_cm ipv6 ib_uverbs ib_umad iw_cxgb3 cxgb3 mdio mlx4_en mlx4_ib ib_sa mlx4_core fuse ext2 loop dm_mod i5k_amb e1000e i5000_edac edac_core mptfc ib_mthca
 ioatdma tpm_tis scsi_transport_fc tpm ib_mad ib_core scsi_tgt tpm_bios shpchp pci_hotplug i2c_i801 iTCO_wdt iTCO_vendor_support lpc_ich ehci_pci dca button serio_raw sg pcspkr i2c_core mfd_core
 microcode container uhci_hcd ehci_hcd sd_mod crc_t10dif usbcore usb_common ext3 jbd mbcache piix edd exportfs crc32c libcrc32c fan thermal processor thermal_sys hwmon ide_generic ide_core sata_
nv megaraid_sas mptsas mptscsih mptbase scsi_transport_sas ata_piix ahci libahci libata scsi_mod [last unloaded: xfs]
[601393.932814] CPU 2
[601393.932814] Pid: 1693, comm: mount Tainted: G           O 3.8.0-rc1-0.7-default+ #1 SGI.COM AltixXE310/X7DGT-INF
[601393.932814] RIP: 0010:[<ffffffffa06e5dcc>]  [<ffffffffa06e5dcc>] xfs_dquot_buf_verify+0x1c/0xb0 [xfs]
[601393.932814] RSP: 0018:ffff8801eb2d3848  EFLAGS: 00010286
[601393.932814] RAX: 0000000000000000 RBX: ffff8801d7e54b00 RCX: ffff8801d7e54b78
[601393.932814] RDX: 0000000000100022 RSI: ffff8801d7e54b00 RDI: ffff8802245a5800
[601393.932814] RBP: ffff8801eb2d3868 R08: ffff880222a20800 R09: 0000000108f4fdca
[601393.932814] R10: 0000000108f4fdca R11: 0000000108f4fdca R12: ffff8802245a5800
[601393.932814] R13: ffff8802245a5800 R14: ffff880180c4c000 R15: ffff8801eb2d3a58
[601393.932814] FS:  00007fe59eccc7e0(0000) GS:ffff88022fd00000(0000) knlGS:0000000000000000
[601393.932814] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[601393.932814] CR2: 00000000000000d0 CR3: 00000001d6fa6000 CR4: 00000000000007e0
[601393.932814] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[601393.932814] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[601393.932814] Process mount (pid: 1693, threadinfo ffff8801eb2d2000, task ffff8801ec3862c0)
[601393.932814] Stack:
[601393.932814]  ffff8801d7e54b00 ffff8802245a5800 ffff8801eb2d39e0 ffff8801eb2d3a08
[601393.932814]  ffff8801eb2d3898 ffffffffa06e7b89 ffff8801eb2d3898 ffffffff811db523
[601393.932814]  0000000000000001 ffff8801eb2d3998 ffff8801eb2d3948 ffffffffa0676058
[601393.932814] Call Trace:
[601393.932814]  [<ffffffffa06e7b89>] xfs_dquot_buf_write_verify+0x29/0x90 [xfs]
[601393.932814]  [<ffffffff811db523>] ? blk_finish_plug+0x13/0x50
[601393.932814]  [<ffffffffa0676058>] _xfs_buf_ioapply+0x68/0x360 [xfs]
[601393.932814]  [<ffffffff810696b0>] ? try_to_wake_up+0x2b0/0x2b0
[601393.932814]  [<ffffffffa0677b23>] xfs_buf_iorequest+0x53/0x70 [xfs]
[601393.932814]  [<ffffffffa0677e25>] xfs_bdstrat_cb+0x35/0x60 [xfs]
[601393.932814]  [<ffffffffa0677f98>] __xfs_buf_delwri_submit+0x148/0x1c0 [xfs]
[601393.932814]  [<ffffffffa067803b>] xfs_buf_delwri_submit+0x2b/0x90 [xfs]
[601393.932814]  [<ffffffffa06d1de1>] xlog_recover_commit_trans+0x111/0x120 [xfs]
[601393.932814]  [<ffffffffa06d1ff1>] xlog_recover_process_data+0x201/0x2b0 [xfs]
[601393.932814]  [<ffffffffa06d257c>] xlog_do_recovery_pass+0x4dc/0x760 [xfs]
[601393.932814]  [<ffffffff8103e3b5>] ? console_unlock+0x265/0x3a0
[601393.932814]  [<ffffffffa06d289c>] xlog_do_log_recovery+0x9c/0x110 [xfs]
[601393.932814]  [<ffffffffa06d2933>] xlog_do_recover+0x23/0x1e0 [xfs]
[601393.932814]  [<ffffffffa06d3660>] xlog_recover+0x70/0x90 [xfs]
[601393.932814]  [<ffffffffa06dd6a4>] xfs_log_mount+0x174/0x1a0 [xfs]
[601393.932814]  [<ffffffffa06d68cb>] xfs_mountfs+0x36b/0x6d0 [xfs]
[601393.932814]  [<ffffffffa068983e>] xfs_fs_fill_super+0x28e/0x310 [xfs]
[601393.932814]  [<ffffffff8111f6f9>] mount_bdev+0x179/0x200
[601393.932814]  [<ffffffffa06895b0>] ? xfs_parseargs+0xbd0/0xbd0 [xfs]
[601393.932814]  [<ffffffffa0687aa0>] xfs_fs_mount+0x10/0x20 [xfs]
[601393.932814]  [<ffffffff8111ec78>] mount_fs+0x48/0x190
[601393.932814]  [<ffffffff8113acc4>] vfs_kern_mount+0x74/0x100
[601393.932814]  [<ffffffff8113c0ef>] do_mount+0x3af/0xa70
[601393.932814]  [<ffffffff81139dbe>] ? copy_mount_options+0x11e/0x190
[601393.932814]  [<ffffffff8113c864>] sys_mount+0xb4/0xe0
[601393.932814]  [<ffffffff813ee769>] system_call_fastpath+0x16/0x1b
[601393.932814] Code: 01 00 00 e8 37 f5 cf e0 e9 69 ff ff ff 66 90 55 48 89 e5 41 56 41 55 49 89 fd 41 54 53 48 8b 87 90 01 00 00 4c 8b b6 98 00 00 00 <8b> 90 d0 00 00 00 85 d2 74 62 45 31 e4 31 db 31 c9 eb 34 90 41
[601393.932814] RIP  [<ffffffffa06e5dcc>] xfs_dquot_buf_verify+0x1c/0xb0 [xfs]
[601393.932814]  RSP <ffff8801eb2d3848>
[601393.932814] CR2: 00000000000000d0

Crashed during test 087

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
