Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7VE0GSP191250 for <xfs@oss.sgi.com>; Fri, 31 Aug 2012 09:00:16 -0500
Message-ID: <5040C3A0.2050107@sgi.com>
Date: Fri, 31 Aug 2012 09:01:04 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2 00/13] xfs: remove the xfssyncd mess
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1346328017-2795-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/30/12 07:00, Dave Chinner wrote:
> Version 2 of the patchset I described here:
>
> http://oss.sgi.com/archives/xfs/2012-06/msg00064.html
>
> This version has run through xfstests completely once, so it's
> less likely to let smoke out....
>
> Version 2:
> - fix writeback_inodes_sb_if_idle call in xfs_create()
> - refreshed patch 13 before sending.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

I wanted to get a fast look at your patch series. I am getting the 
following ASSERT on xfstest 179 when running the series with the latest 
OSS soruces.The ASSERT appears to start at patch number 3. Sorry these 
boxes won't kdump the top of tree kernels:

[17474.545964] XFS: Assertion failed: atomic_read(&bp->b_hold) > 0, 
file: /root/xfs/fs/xfs/xfs_buf.c, line: 896
[17474.555828] ------------[ cut here ]------------
[17474.559784] kernel BUG at /root/xfs/fs/xfs/xfs_message.c:100!
[17474.559784] invalid opcode: 0000 [#1] SMP
[17474.559784] Modules linked in: xfs(O) autofs4 binfmt_misc mperf fuse 
loop dm_mod qla2xxx ib_mthca ipv6 i5k_amb scsi_transport_fc ib_mad 
e1000e i2c_i801 i5000_edac scsi_tgt i2c_core ioatdma shpchp edac_core 
pci_hotplug sg lpc_ich mfd_core ib_core pcspkr dca microcode rtc_cmos 
button uhci_hcd ehci_hcd sd_mod crc_t10dif usbcore usb_common 
scsi_dh_emc scsi_dh_rdac scsi_dh_alua scsi_dh_hp_sw scsi_dh thermal 
sata_nv processor mptsas mptscsih scsi_transport_sas mptbase 
megaraid_sas fan thermal_sys hwmon ext3 jbd mbcache edd ata_piix ahci 
libahci libata scsi_mod [last unloaded: xfs]
[17474.559784] CPU 0
[17474.559784] Pid: 26427, comm: umount Tainted: G           O 
3.6.0-rc1+ #1 SGI.COM AltixXE210/S5000PAL0
[17474.559784] RIP: 0010:[<ffffffffa05c544d>]  [<ffffffffa05c544d>] 
assfail+0x1d/0x30 [xfs]
[17474.559784] RSP: 0018:ffff8808379238a8  EFLAGS: 00010296
[17474.559784] RAX: 0000000000000060 RBX: ffff8807f8c0a564 RCX: 
0000000000000082
[17474.559784] RDX: 0000000000004a61 RSI: 0000000000000086 RDI: 
0000000000000246
[17474.559784] RBP: ffff8808379238a8 R08: 0000000000000811 R09: 
ffffffff818ba780
[17474.559784] R10: 0000000000000811 R11: 0000000000000006 R12: 
ffff8807f8c0a540
[17474.559784] R13: ffffffffa05b5b86 R14: ffff88083a8810c0 R15: 
0000000000000000
[17474.559784] FS:  00007fc12646d740(0000) GS:ffff88085fc00000(0000) 
knlGS:0000000000000000
[17474.559784] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[17474.559784] CR2: 00007fc125b29570 CR3: 000000085be2c000 CR4: 
00000000000007f0
[17474.559784] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[17474.559784] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[17474.559784] Process umount (pid: 26427, threadinfo ffff880837922000, 
task ffff88083d278600)
[17474.559784] Stack:
[17474.559784]  ffff8808379238d8 ffffffffa05b4ed4 ffff8807f8c0a540 
ffff8807f8c0a540
[17474.559784]  ffffffffa061e939 0000000000000000 ffff8808379238f8 
ffffffffa05b5b86
[17474.559784]  ffff880837a436d0 ffff8807f8c0a540 ffff880837923928 
ffffffffa05b5c26
[17474.559784] Call Trace:
[17474.559784]  [<ffffffffa05b4ed4>] xfs_buf_rele+0xa4/0x1b0 [xfs]
[17474.559784]  [<ffffffffa061e939>] ? 
xfs_buf_iodone_callbacks+0x59/0x230 [xfs]
[17474.559784]  [<ffffffffa05b5b86>] xfs_buf_iodone_work+0x46/0x50 [xfs]
[17474.559784]  [<ffffffffa05b5c26>] xfs_buf_ioend+0x96/0x120 [xfs]
[17474.559784]  [<ffffffffa05b5b61>] ? xfs_buf_iodone_work+0x21/0x50 [xfs]
[17474.559784]  [<ffffffffa061e939>] xfs_buf_iodone_callbacks+0x59/0x230 
[xfs]
[17474.559784]  [<ffffffffa061f7e9>] ? xfs_buf_item_unpin+0x289/0x2d0 [xfs]
[17474.559784]  [<ffffffffa05b5b61>] xfs_buf_iodone_work+0x21/0x50 [xfs]
[17474.559784]  [<ffffffffa05b5c26>] xfs_buf_ioend+0x96/0x120 [xfs]
[17474.559784]  [<ffffffffa061f7e9>] xfs_buf_item_unpin+0x289/0x2d0 [xfs]
[17474.559784]  [<ffffffffa0617c33>] 
xfs_trans_committed_bulk+0x213/0x300 [xfs]
[17474.559784]  [<ffffffffa061bd33>] ? 
xlog_state_get_iclog_space+0x293/0x350 [xfs]
[17474.559784]  [<ffffffff8107f9e8>] ? idle_balance+0xe8/0x150
[17474.559784]  [<ffffffffa061c9d5>] ? xlog_write+0x165/0x5d0 [xfs]
[17474.559784]  [<ffffffffa061dde6>] xlog_cil_committed+0x36/0x130 [xfs]
[17474.559784]  [<ffffffffa061e1e8>] xlog_cil_push+0x308/0x430 [xfs]
[17474.559784]  [<ffffffff81110522>] ? pagevec_lookup_tag+0x22/0x30
[17474.559784]  [<ffffffff8105dbb9>] ? start_flush_work+0x29/0x100
[17474.559784]  [<ffffffffa061e466>] xlog_cil_force_lsn+0x146/0x1b0 [xfs]
[17474.559784]  [<ffffffff81433a82>] ? wait_for_common+0xd2/0x190
[17474.559784]  [<ffffffff81178285>] ? iput_final+0x145/0x1e0
[17474.559784]  [<ffffffffa061c1e4>] _xfs_log_force+0x64/0x280 [xfs]
[17474.559784]  [<ffffffff811863fe>] ? sync_inodes_sb+0x9e/0xd0
[17474.559784]  [<ffffffffa061c454>] xfs_log_force+0x54/0x80 [xfs]
[17474.559784]  [<ffffffffa05c65dd>] xfs_fs_sync_fs+0x2d/0x50 [xfs]
[17474.559784]  [<ffffffff8118c00b>] __sync_filesystem+0x2b/0x50
[17474.559784]  [<ffffffff8118c073>] sync_filesystem+0x43/0x60
[17474.559784]  [<ffffffff81160846>] generic_shutdown_super+0x36/0xe0
[17474.559784]  [<ffffffff8116091c>] kill_block_super+0x2c/0x80
[17474.559784]  [<ffffffff81160e78>] deactivate_locked_super+0x38/0x90
[17474.559784]  [<ffffffff81161951>] deactivate_super+0x61/0x70
[17474.559784]  [<ffffffff8117c659>] mntput_no_expire+0x149/0x1b0
[17474.559784]  [<ffffffff8117d10e>] sys_umount+0x6e/0xd0
[17474.559784]  [<ffffffff8143d479>] system_call_fastpath+0x16/0x1b
[17474.559784] Code: 00 00 00 48 89 45 c8 e8 72 fc ff ff c9 c3 55 41 89 
d0 48 89 f1 48 89 fa 48 c7 c6 58 b0 63 a0 31 ff 48 89 e5 31 c0 e8 93 ff 
ff ff <0f> 0b eb fe 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 4c
[17474.559784] RIP  [<ffffffffa05c544d>] assfail+0x1d/0x30 [xfs]
[17474.559784]  RSP <ffff8808379238a8>

I got this ASSERT when I ran it on the 8/27 OSS sources:

[188646.952426] XFS: Assertion failed: atomic_read(&iclog->ic_refcnt) == 
0, file:
  /root/xfs/fs/xfs/xfs_log.c, line: 2590
[188646.963050] ------------[ cut here ]------------
[188646.967020] kernel BUG at /root/xfs/fs/xfs/xfs_message.c:100!
[188646.967020] invalid opcode: 0000 [#1] SMP
[188646.967020] Modules linked in: xfs(O) autofs4 binfmt_misc mperf fuse 
loop dm_
mod qla2xxx i5k_amb i5000_edac ipv6 scsi_transport_fc scsi_tgt e1000e 
edac_core i
b_mthca shpchp sg ioatdma pci_hotplug lpc_ich mfd_core microcode ib_mad 
ib_core d
ca pcspkr i2c_i801 i2c_core button rtc_cmos uhci_hcd ehci_hcd sd_mod 
crc_t10dif u
sbcore usb_common scsi_dh_emc scsi_dh_rdac scsi_dh_alua scsi_dh_hp_sw 
scsi_dh the
rmal sata_nv processor mptsas mptscsih scsi_transport_sas mptbase 
megaraid_sas fa
n thermal_sys hwmon ext3 jbd mbcache edd ata_piix ahci libahci libata 
scsi_mod [l
ast unloaded: xfs]
[188646.967020] CPU 2
[188646.967020] Pid: 356, comm: kworker/2:1H Tainted: G           O 
3.6.0-rc1+ #1
  SGI.COM AltixXE210/S5000PAL0
[188646.967020] RIP: 0010:[<ffffffffa0188e2d>]  [<ffffffffa0188e2d>] 
assfail+0x1d
/0x30 [xfs]
[188646.967020] RSP: 0018:ffff8808396a5d90  EFLAGS: 00010286
[188646.967020] RAX: 0000000000000068 RBX: ffff88083b4efdc0 RCX: 
0000000000000086
[188646.967020] RDX: 0000000000000b04 RSI: 0000000000000082 RDI: 
0000000000000246
[188646.967020] RBP: ffff8808396a5d90 R08: 0000000000002291 R09: 
ffffffff818ba780
[188646.967020] R10: 0000000000002291 R11: 0000000000000006 R12: 
ffff88053ff99800
[188646.967020] R13: ffff88053ff99928 R14: 0000000000000002 R15: 
ffff88085fc8d730
[188646.967020] FS:  0000000000000000(0000) GS:ffff88085fc80000(0000) 
knlGS:00000
00000000000
[188646.967020] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[188646.967020] CR2: ffffffffff600400 CR3: 0000000838497000 CR4: 
00000000000007e0
[188646.967020] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[188646.967020] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[188646.967020] Process kworker/2:1H (pid: 356, threadinfo 
ffff8808396a4000, task
  ffff88083a9aa1c0)
[188646.967020] Stack:
[188646.967020]  ffff8808396a5dc0 ffffffffa01dd2bf 0000000000000002 
ffff88083ae67
980
[188646.967020]  ffff88083b4efdc0 ffff88085fc8d400 ffff8808396a5df0 
ffffffffa01dd
bde
[188646.967020]  ffff88085fc8d400 ffff88083ae67980 ffff88083ae67a18 
ffff88083a5e3
240
[188646.967020] Call Trace:
[188646.967020]  [<ffffffffa01dd2bf>] xlog_state_done_syncing+0x7f/0x110 
[xfs]
[188646.967020]  [<ffffffffa01ddbde>] xlog_iodone+0x7e/0x100 [xfs]
[188646.967020]  [<ffffffffa0179b51>] xfs_buf_iodone_work+0x21/0x50 [xfs]
[188646.967020]  [<ffffffff8105d6b3>] process_one_work+0x1d3/0x370
[188646.967020]  [<ffffffffa0179b30>] ? xfs_bioerror_relse+0x80/0x80 [xfs]
[188646.967020]  [<ffffffff810603e3>] worker_thread+0x133/0x390
[188646.967020]  [<ffffffff810602b0>] ? manage_workers+0x70/0x70
[188646.967020]  [<ffffffff810651ce>] kthread+0x9e/0xb0
[188646.967020]  [<ffffffff8143e504>] kernel_thread_helper+0x4/0x10
[188646.967020]  [<ffffffff81065130>] ? 
kthread_freezable_should_stop+0x70/0x70
[188646.967020]  [<ffffffff8143e500>] ? gs_change+0x13/0x13
[188646.967020] Code: 00 00 00 48 89 45 c8 e8 72 fc ff ff c9 c3 55 41 89 
d0 48 89
  f1 48 89 fa 48 c7 c6 58 ef 1f a0 31 ff 48 89 e5 31 c0 e8 93 ff ff ff 
<0f> 0b eb
fe 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 4c
[188646.967020] RIP  [<ffffffffa0188e2d>] assfail+0x1d/0x30 [xfs]
[188646.967020]  RSP <ffff8808396a5d90

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
