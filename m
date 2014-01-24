Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA90F7FA8
	for <xfs@oss.sgi.com>; Fri, 24 Jan 2014 13:37:06 -0600 (CST)
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35560AC00A
	for <xfs@oss.sgi.com>; Fri, 24 Jan 2014 11:37:03 -0800 (PST)
Date: Fri, 24 Jan 2014 13:37:02 -0600
From: Ben Myers <bpm@sgi.com>
Subject: assert in xfs_log_commit_cil
Message-ID: <20140124193702.GM26064@sgi.com>
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

Hi Folks,

I hit this assertion on one of my test boxes today:

[1167966.151275] XFS: Assertion failed: !list_empty(&cil->xc_cil), file: /root/xfs/fs/xfs/xfs_log_cil.c, line: 636
[1167966.162659] ------------[ cut here ]------------
[1167966.168021] kernel BUG at /root/xfs/fs/xfs/xfs_message.c:107!
[1167966.168026] invalid opcode: 0000 [#4] SMP
[1167966.168081] Modules linked in: xfs(OF) ext2(F) dm_flakey(F) crc32c(F) libcrc32c(F) autofs4(F) cpufreq_conservative(F) cpufreq_userspace(F) cpufreq_powersave(F) microcode(F) fuse(F) loop(F) dm_mod(F) joydev(F) hid_generic(F) usbhid(F) hid(F) ehci_pci(F) ehci_hcd(F) iTCO_wdt(F) iTCO_vendor_support(F) ipv6(F) usbcore(F) sg(F) igb(F) isci(F) sr_mod(F) pcspkr(F) mptctl(F) cdrom(F) libsas(F) usb_common(F) ioatdma(F) ptp(F) i2c_i801(F) lpc_ich(F) mfd_core(F) pps_core(F) dca(F) rtc_cmos(F) acpi_cpufreq(F) wmi(F) button(F) mgag200(F) ttm(F) drm_kms_helper(F) drm(F) i2c_algo_bit(F) sysimgblt(F) sysfillrect(F) i2c_core(F) syscopyarea(F) sd_mod(F) crc_t10dif(F) crct10dif_common(F) mpt2sas(F) raid_class(F) scsi_dh_emc(F) scsi_dh_rdac(F) scsi_dh_alua(F) scsi_dh_hp_sw(F) scsi_dh(F) thermal(F) sata_nv(F) processor(F) piix(F) mptsas(F) mptscsih(F) scsi_transport_sas(F) mptbase(F) megaraid_sas(F) ide_generic(F) ide_core(F) fan(F) thermal_sys(F) hwmon(F) ext3(F) jbd(F) mbcache(F) edd(F) at
 a_piix(F) ahci(F) libahci(F) libata(F) scsi_mod(F) [last unloaded: scsi_debug]
[1167966.168102] CPU: 10 PID: 13005 Comm: kworker/10:3 Tainted: GF     D   IO 3.13.0-rc2-0.9-default #28
[1167966.168103] Hardware name: SGI.COM SUMMIT/S2600GZ, BIOS SE5C600.86B.01.06.0002.110120121539 11/01/2012
[1167966.168139] Workqueue: xfs-data/sdb1 xfs_end_io [xfs]
[1167966.168141] task: ffff88065a0f0450 ti: ffff88009f2a8000 task.ti: ffff88009f2a8000
[1167966.168174] RIP: 0010:[<ffffffffa06cd39d>]  [<ffffffffa06cd39d>] assfail+0x1d/0x30 [xfs]
[1167966.168176] RSP: 0018:ffff88009f2a9ce8  EFLAGS: 00010292
[1167966.168177] RAX: 0000000000000061 RBX: ffff88070085f180 RCX: 0000000000000000
[1167966.168179] RDX: ffff88083f68ed68 RSI: ffff88083f68d248 RDI: ffff88083f68d248
[1167966.168180] RBP: ffff88009f2a9ce8 R08: 00000000000226fb R09: 000000000000000a
[1167966.168182] R10: 00000000000226fb R11: 0000000000000006 R12: 0000000000000000
[1167966.168183] R13: ffff88070085f180 R14: ffff880829c21000 R15: ffff88067f367400
[1167966.168186] FS:  0000000000000000(0000) GS:ffff88083f680000(0000) knlGS:0000000000000000
[1167966.168187] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1167966.168189] CR2: 00007fd326883160 CR3: 00000003623a0000 CR4: 00000000000407e0
[1167966.168190] Stack:
[1167966.168196]  ffff88009f2a9d38 ffffffffa072c3f0 ffff88009f2a9d38 ffff88009f2a9d58
[1167966.168200]  ffff88070085f1c0 ffff88073d3d71c0 0000000000000000 0000000000000000
[1167966.168205]  ffff880829c21000 0000000000000041 ffff88009f2a9d88 ffffffffa06d585c
[1167966.168206] Call Trace:
[1167966.168248]  [<ffffffffa072c3f0>] xfs_log_commit_cil+0x170/0x180 [xfs]
[1167966.168281]  [<ffffffffa06d585c>] xfs_trans_commit+0x15c/0x2a0 [xfs]
[1167966.168305]  [<ffffffffa06b404b>] xfs_setfilesize+0x12b/0x130 [xfs]
[1167966.168327]  [<ffffffffa06b4775>] xfs_end_io+0x75/0xf0 [xfs]
[1167966.168338]  [<ffffffff81065d6c>] process_one_work+0x17c/0x3d0
[1167966.168343]  [<ffffffff8106715b>] worker_thread+0x12b/0x410
[1167966.168349]  [<ffffffff81067030>] ? manage_workers+0x1a0/0x1a0
[1167966.168356]  [<ffffffff8106cbdb>] kthread+0xdb/0xf0
[1167966.168361]  [<ffffffff8106cb00>] ? kthread_freezable_should_stop+0x70/0x70
[1167966.168369]  [<ffffffff814c4c3c>] ret_from_fork+0x7c/0xb0
[1167966.168374]  [<ffffffff8106cb00>] ? kthread_freezable_should_stop+0x70/0x70
[1167966.168401] Code: 00 00 00 48 89 45 c8 e8 42 fc ff ff c9 c3 55 41 89 d0 48 89 f1 48 89 fa 48 c7 c6 58 4e 75 a0 31 ff 48 89 e5 31 c0 e8 93 ff ff ff <0f> 0b eb fe 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b
[1167966.168430] RIP  [<ffffffffa06cd39d>] assfail+0x1d/0x30 [xfs]
[1167966.168431]  RSP <ffff88009f2a9ce8>
[1167966.218543] ---[ end trace c4c3ac02d344970e ]---

That machine was running xfs/109 at the time, at commit bf3964c1.

-Ben 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
