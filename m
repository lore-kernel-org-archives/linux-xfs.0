Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 18A037F3F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 05:06:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CD7838F8050
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 03:06:03 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id A9mPFAHU2uLkvMvn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 03:06:00 -0800 (PST)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp5-g21.free.fr (Postfix) with ESMTP id CD7E0D480A1
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 12:03:15 +0100 (CET)
Date: Fri, 9 Jan 2015 12:05:58 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Oops mounting a corrupted XFS filesystem (with the "kernel BUG"
	message)
Message-ID: <20150109120558.2610d8aa@harpe.intellique.com>
MIME-Version: 1.0
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
To: XFS mailing list <xfs@oss.sgi.com>

Foolowing up with the  tests on hardware Adaptec RAID with XFS, I got
this bug when running mount on a corrupted XFS volume:

------------[ cut here ]------------
kernel BUG at arch/x86/mm/pageattr.c:216!
invalid opcode: 0000 [#2] SMP 
Modules linked in: nfsv3 nfsv4 ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs bonding md_mod dm_mod nfsd lockd nfs_acl auth_rpcgss oid_registry sunrpc ipv6 fuse af_packet snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_midi snd_rawmidi snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device snd virtio_net virtio_balloon soundcore loop virtio_blk virtio_pci virtio_ring virtio ata_piix xhci_hcd uhci_hcd usb_storage joydev usbhid kvm_amd kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper mgag200 evdev ttm cryptd drm_kms_helper e1000e drm microcode pcspkr sp5100_tco i2c_algo_bit psmouse k10temp ptp fam15h_power pps_core ohci_pci i2c_piix4 ohci_hcd ehci_pci ehci_hcd i2c_core ses usbcore enclosure usb_common sg myri10ge acpi_cpufreq dca processor thermal_sys button ata_generic aacraid pata
 _atiixp 
 ahci libahci libata
CPU: 5 PID: 18084 Comm: mount Not tainted 3.17.7-storiq64-opteron #1
Hardware name: Supermicro H8SGL/H8SGL, BIOS 3.0a       05/07/2013
task: ffff88040e1ad7f0 ti: ffff880037ca8000 task.ti: ffff880037ca8000
RIP: 0010:[<ffffffff8104e96d>]  [<ffffffff8104e96d>] change_page_attr_set_clr+0x41d/0x420
RSP: 0018:ffff880037caa9a8  EFLAGS: 00010046
RAX: 0000000000000046 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880037caa9d8
RBP: 0000000000000000 R08: 8000000037e10163 R09: 0000000000037e10
R10: ffff8800db14e958 R11: ffff880037caa830 R12: 0000000000000200
R13: 0000000000000010 R14: 0000000000000000 R15: 0000000000000005
FS:  00007ffee71207e0(0000) GS:ffff88041eca0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000000db274000 CR4: 00000000000407e0
Stack:
 0000000000000004 ffffffff00000000 0000000000000000 0000000000000008
 0000000000000000 0000000037e10000 0000000000000000 0000000000000000
 0000000000000010 0000000000000000 0000000500000001 0000000000037e10
Call Trace:
 [<ffffffff8104eaed>] ? _set_pages_array+0xed/0x140
 [<ffffffffa06539f7>] ? ttm_set_pages_caching+0x47/0x80 [ttm]
 [<ffffffffa0653add>] ? ttm_alloc_new_pages.isra.5+0xad/0x170 [ttm]
 [<ffffffffa06544e6>] ? ttm_pool_populate+0x3c6/0x4c0 [ttm]
 [<ffffffffa0650caa>] ? ttm_bo_move_memcpy+0x45a/0x4f0 [ttm]
 [<ffffffff81123024>] ? __vmalloc_node_range+0x164/0x260
 [<ffffffffa064d3c0>] ? ttm_tt_init+0x60/0xa0 [ttm]
 [<ffffffffa064ebcf>] ? ttm_bo_handle_move_mem+0x25f/0x400 [ttm]
 [<ffffffffa064f5d8>] ? ttm_bo_mem_space+0xd8/0x350 [ttm]
 [<ffffffff8105c100>] ? walk_system_ram_range+0x70/0xc0
 [<ffffffffa064fa3d>] ? ttm_bo_validate+0x1ed/0x200 [ttm]
 [<ffffffff81121548>] ? free_vmap_area_noflush+0x28/0x60
 [<ffffffffa067190e>] ? mgag200_bo_push_sysram+0x6e/0xc0 [mgag200]
 [<ffffffffa066c8fc>] ? mga_crtc_do_set_base.isra.8.constprop.20+0x7c/0x400 [mgag200]
 [<ffffffff812dd730>] ? pci_bus_write_config_dword+0x70/0x90
 [<ffffffffa066e0d0>] ? mga_crtc_mode_set+0x1450/0x2560 [mgag200]
 [<ffffffff812589e0>] ? xfs_inode_item_committed+0x70/0x70
 [<ffffffff812589e0>] ? xfs_inode_item_committed+0x70/0x70
 [<ffffffff812589e0>] ? xfs_inode_item_committed+0x70/0x70
 [<ffffffff812b7196>] ? idr_mark_full+0x56/0x60
 [<ffffffff812b7aaf>] ? idr_alloc+0x7f/0xf0
 [<ffffffff812c1353>] ? delay_tsc+0x43/0x70
 [<ffffffffa0603941>] ? drm_crtc_helper_set_mode+0x2d1/0x500 [drm_kms_helper]
 [<ffffffffa06044b1>] ? drm_crtc_helper_set_config+0x801/0xa20 [drm_kms_helper]
 [<ffffffffa055b92f>] ? drm_mode_set_config_internal+0x5f/0xe0 [drm]
 [<ffffffffa060b802>] ? drm_fb_helper_pan_display+0x82/0xe0 [drm_kms_helper]
 [<ffffffff81310989>] ? fb_pan_display+0xb9/0x180
 [<ffffffff8130e881>] ? bit_update_start+0x21/0x50
 [<ffffffff8130e259>] ? fbcon_switch+0x389/0x530
 [<ffffffff8137587f>] ? redraw_screen+0x15f/0x230
 [<ffffffff8130ca02>] ? fbcon_blank+0x232/0x2e0
 [<ffffffff8109160a>] ? console_unlock+0x1da/0x440
 [<ffffffff81091d20>] ? vprintk_emit+0x2b0/0x4e0
 [<ffffffff8109fb03>] ? lock_timer_base.isra.36+0x33/0x70
 [<ffffffff8109f300>] ? internal_add_timer+0x30/0x70
 [<ffffffff810a1284>] ? mod_timer+0x114/0x1b0
 [<ffffffff81376396>] ? do_unblank_screen+0xa6/0x1c0
 [<ffffffff812c38c9>] ? bust_spinlocks+0x19/0x40
 [<ffffffff810164c2>] ? oops_end+0x12/0xa0
 [<ffffffff814cf5f6>] ? no_context+0x2e5/0x323
 [<ffffffff8104c06e>] ? __do_page_fault+0x3fe/0x490
 [<ffffffff814d75da>] ? schedule_timeout+0x14a/0x1c0
 [<ffffffff814d4b3f>] ? wait_for_completion+0xaf/0x120
 [<ffffffff81236a25>] ? xfs_buf_delwri_submit+0x25/0x80
 [<ffffffff8107ce60>] ? try_to_wake_up+0x2f0/0x2f0
 [<ffffffff8108b9dd>] ? up+0xd/0x40
 [<ffffffff814da3a8>] ? page_fault+0x28/0x30
 [<ffffffff81259ef6>] ? xlog_recover_free_trans+0x16/0xb0
 [<ffffffff8125e448>] ? xlog_recover_process_data+0x108/0x2a0
 [<ffffffff8125e741>] ? xlog_do_recovery_pass+0x161/0x5c0
 [<ffffffff8124e3d0>] ? xfs_parseargs+0xb80/0xb80
 [<ffffffff8124e3d0>] ? xfs_parseargs+0xb80/0xb80
 [<ffffffff8125ec18>] ? xlog_do_log_recovery+0x78/0xa0
 [<ffffffff8125ec5a>] ? xlog_do_recover+0x1a/0x100
 [<ffffffff8125f00b>] ? xlog_recover+0x7b/0xb0
 [<ffffffff81253486>] ? xfs_log_mount+0xe6/0x2b0
 [<ffffffff8124b642>] ? xfs_mountfs+0x442/0x780
 [<ffffffff8123a9e0>] ? xfs_filestream_get_ag+0x20/0x20
 [<ffffffff8124e697>] ? xfs_fs_fill_super+0x2c7/0x340
 [<ffffffff8113b996>] ? mount_bdev+0x1c6/0x210
 [<ffffffff8113c55a>] ? mount_fs+0x1a/0xd0
 [<ffffffff811553b4>] ? vfs_kern_mount+0x64/0x110
 [<ffffffff81157513>] ? do_mount+0x213/0xa80
 [<ffffffff810ef799>] ? __get_free_pages+0x9/0x50
 [<ffffffff81158078>] ? SyS_mount+0x98/0xf0
 [<ffffffff814d8569>] ? system_call_fastpath+0x16/0x1b
Code: 0c 24 44 8b 44 24 08 48 8b 4c 24 10 e9 9f fc ff ff 0f 0b 0f 0b be ba 00 00 00 48 c7 c7 13 b0 5d 81 e8 d8 8a 00 00 e9 21 ff ff ff <0f> 0b 90 41 56 45 31 c0 31 d2 41 b9 04 00 00 00 b9 18 00 00 00 
RIP  [<ffffffff8104e96d>] change_page_attr_set_clr+0x41d/0x420
 RSP <ffff880037caa9a8>
---[ end trace b6bd5ad538480248 ]---

Configuration: kernel 3.17.7, amd64 on Debian 7.7. The hardware is
unchanged from my previous tests ( Adaptec 71685, dual Opteron 6212).

The filesystem got corrupted while rebuilding the RAID and doing
read/write IO, as previously. There is first this error:

XFS (sda5): Metadata corruption detected at xfs_buf_iodone_work+0x8d/0xb0, block 0xe003be218
XFS (sda5): Unmount and run xfs_repair
XFS (sda5): First 64 bytes of corrupted metadata buffer:
ffff88040e339000: 8b 98 af af 25 4a 84 7a 51 6c 38 41 f7 2d 78 b5  ....%J.zQl8A.-x.
ffff88040e339010: 35 f3 af 8e 64 32 81 a4 6b 1d a4 0b 3c 8c d8 c3  5...d2..k...<...
ffff88040e339020: 23 ba 20 f7 c9 3a a1 fa d1 ea e3 27 03 46 dd 83  #. ..:.....'.F..
ffff88040e339030: cb f8 75 d3 a2 82 a7 b1 9f 7d 14 bb c8 2a 94 8d  ..u......}...*..
XFS (sda5): metadata I/O error: block 0xe003be218 ("xfs_trans_read_buf_map") error 117 numblks 8
XFS (sda5): Metadata corruption detected at xfs_inode_buf_verify+0x6c/0xb0, block 0x1001c26d50
XFS (sda5): Unmount and run xfs_repair
XFS (sda5): First 64 bytes of corrupted metadata buffer:
ffff880037d82000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
XFS (sda5): Metadata corruption detected at xfs_inode_buf_verify+0x6c/0xb0, block 0x1001c26d50
XFS (sda5): Unmount and run xfs_repair
XFS (sda5): First 64 bytes of corrupted metadata buffer:
ffff880037d82000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
XFS (sda5): Metadata corruption detected at xfs_inode_buf_verify+0x6c/0xb0, block 0x1001c26d50
XFS (sda5): Unmount and run xfs_repair
XFS (sda5): First 64 bytes of corrupted metadata buffer:
ffff880037d82000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
XFS (sda5): Metadata corruption detected at xfs_inode_buf_verify+0x6c/0xb0, block 0x1001c26d50
XFS (sda5): Unmount and run xfs_repair
XFS (sda5): First 64 bytes of corrupted metadata buffer:
ffff880037d82000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
XFS (sda5): Metadata corruption detected at xfs_inode_buf_verify+0x6c/0xb0, block 0x1001c26d50
XFS (sda5): Unmount and run xfs_repair
XFS (sda5): First 64 bytes of corrupted metadata buffer:
ffff880037d82000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff880037d82030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

It goes on a bot more then it becomes that:

XFS (sda5): metadata I/O error: block 0x1001c26d50 ("xfs_trans_read_buf_map") error 117 numblks 16
XFS (sda5): xfs_do_force_shutdown(0x1) called from line 382 of file fs/xfs/xfs_trans_buf.c.  Return address = 0xffffffff81260803
XFS (sda5): I/O Error Detected. Shutting down filesystem
XFS (sda5): Please umount the filesystem and rectify the problem(s)
XFS (sda5): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
XFS (sda5): xfs_log_force: error -5 returned.
XFS (sda5): xfs_log_force: error -5 returned.
XFS (sda5): xfs_log_force: error -5 returned.
XFS (sda5): xfs_log_force: error -5 returned.
XFS (sda5): xfs_log_force: error -5 returned.
XFS (sda5): xfs_log_force: error -5 returned.
XFS (sda5): xfs_log_force: error -5 returned.
XFS (sda5): xfs_log_force: error -5 returned.

It goes for a long time, then that follows when I unmount and try to
remount ( "structure needs cleaning") and dmesg says :

XFS (sda5): Mounting V4 Filesystem
XFS (sda5): Starting recovery (logdev: internal)
XFS (sda5): Metadata corruption detected at xfs_inode_buf_verify+0x6c/0xb0, block 0x1001c26d40
XFS (sda5): Unmount and run xfs_repair
XFS (sda5): First 64 bytes of corrupted metadata buffer:
ffffc90013c62000: 49 4e 81 ff 02 02 00 00 00 00 03 e8 00 00 03 e8  IN..............
ffffc90013c62010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 01  ................
ffffc90013c62020: 50 98 e3 98 1e 97 8a 07 4c 06 1c e5 00 00 00 00  P.......L.......
ffffc90013c62030: 54 ae c5 83 18 8f d6 8c 00 00 00 00 00 00 14 82  T...............
XFS (sda5): Metadata corruption detected at xfs_inode_buf_verify+0x6c/0xb0, block 0x1001c26d40
XFS (sda5): Unmount and run xfs_repair
XFS (sda5): First 64 bytes of corrupted metadata buffer:
ffffc90013c62000: 49 4e 81 ff 02 02 00 00 00 00 03 e8 00 00 03 e8  IN..............
ffffc90013c62010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 01  ................
ffffc90013c62020: 50 98 e3 98 1e 97 8a 07 4c 06 1c e5 00 00 00 00  P.......L.......
ffffc90013c62030: 54 ae c5 83 18 8f d6 8c 00 00 00 00 00 00 14 82  T...............
XFS (sda5): Metadata corruption detected at xfs_inode_buf_verify+0x6c/0xb0, block 0x1001c26d40
XFS (sda5): Unmount and run xfs_repair
XFS (sda5): First 64 bytes of corrupted metadata buffer:
ffffc90013c62000: 49 4e 81 ff 02 02 00 00 00 00 03 e8 00 00 03 e8  IN..............
ffffc90013c62010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 01  ................
ffffc90013c62020: 50 98 e3 98 1e 97 8a 07 4c 06 1c e5 00 00 00 00  P.......L.......
ffffc90013c62030: 54 ae c5 83 18 8f d6 8c 00 00 00 00 00 00 14 82  T...............
XFS (sda5): Metadata corruption detected at xfs_inode_buf_verify+0x6c/0xb0, block 0x1001c26d40
XFS (sda5): Unmount and run xfs_repair
XFS (sda5): First 64 bytes of corrupted metadata buffer:
ffffc90013c62000: 49 4e 81 ff 02 02 00 00 00 00 03 e8 00 00 03 e8  IN..............
ffffc90013c62010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 01  ................
ffffc90013c62020: 50 98 e3 98 1e 97 8a 07 4c 06 1c e5 00 00 00 00  P.......L.......
ffffc90013c62030: 54 ae c5 83 18 8f d6 8c 00 00 00 00 00 00 14 82  T...............
XFS (sda5): Metadata corruption detected at xfs_inode_buf_verify+0x6c/0xb0, block 0x1001c26d40

And finally ends with:

XFS (sda5): metadata I/O error: block 0x1001c26d40 ("xlog_recover_do..(read#2)") error 117 numblks 16
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff81259ef6>] xlog_recover_free_trans+0x16/0xb0
PGD 37da7067 PUD 3752c067 PMD 0 
Oops: 0000 [#1] SMP 
Modules linked in: nfsv3 nfsv4 ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs bonding md_mod dm_mod nfsd lockd nfs_acl auth_rpcgss oid_registry sunrpc ipv6 fuse af_packet snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_midi snd_rawmidi snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device snd virtio_net virtio_balloon soundcore loop virtio_blk virtio_pci virtio_ring virtio ata_piix xhci_hcd uhci_hcd usb_storage joydev usbhid kvm_amd kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper mgag200 evdev ttm cryptd drm_kms_helper e1000e drm microcode pcspkr sp5100_tco i2c_algo_bit psmouse k10temp ptp fam15h_power pps_core ohci_pci i2c_piix4 ohci_hcd ehci_pci ehci_hcd i2c_core ses usbcore enclosure usb_common sg myri10ge acpi_cpufreq dca processor thermal_sys button ata_generic aacraid pata
 _atiixp 
 ahci libahci libata
CPU: 5 PID: 18084 Comm: mount Not tainted 3.17.7-storiq64-opteron #1
Hardware name: Supermicro H8SGL/H8SGL, BIOS 3.0a       05/07/2013
task: ffff88040e1ad7f0 ti: ffff880037ca8000 task.ti: ffff880037ca8000
RIP: 0010:[<ffffffff81259ef6>]  [<ffffffff81259ef6>] xlog_recover_free_trans+0x16/0xb0
RSP: 0018:ffff880037cabb08  EFLAGS: 00010207
RAX: 00000000ffffff8b RBX: 0000000000000001 RCX: 0000000000000002
RDX: 00000000ffffff8b RSI: ffff88040c9105a0 RDI: ffff8800377b7f40
RBP: 0000000000000000 R08: ffff880037ca8000 R09: 0000000000000000
R10: ffffffff81723480 R11: 0000000000000001 R12: ffff880037cabc28
R13: ffff8800377b7f70 R14: ffff8800377b7f40 R15: ffff8800377b7f40
FS:  00007ffee71207e0(0000) GS:ffff88041eca0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000000db274000 CR4: 00000000000407e0
Stack:
 0000000000000001 ffffc90015c0bf1c ffff880037cabc28 00000000930b92d9
 ffffc90015c0bf10 ffffffff8125e448 ffff8804ffffff8b ffffc90015c0c000
 ffff880037cabbf8 ffff88020176cc00 ffff880403115000 0000000281259fbe
Call Trace:
 [<ffffffff8125e448>] ? xlog_recover_process_data+0x108/0x2a0
 [<ffffffff8125e741>] ? xlog_do_recovery_pass+0x161/0x5c0
 [<ffffffff8124e3d0>] ? xfs_parseargs+0xb80/0xb80
 [<ffffffff8124e3d0>] ? xfs_parseargs+0xb80/0xb80
 [<ffffffff8125ec18>] ? xlog_do_log_recovery+0x78/0xa0
 [<ffffffff8125ec5a>] ? xlog_do_recover+0x1a/0x100
 [<ffffffff8125f00b>] ? xlog_recover+0x7b/0xb0
 [<ffffffff81253486>] ? xfs_log_mount+0xe6/0x2b0
 [<ffffffff8124b642>] ? xfs_mountfs+0x442/0x780
 [<ffffffff8123a9e0>] ? xfs_filestream_get_ag+0x20/0x20
 [<ffffffff8124e697>] ? xfs_fs_fill_super+0x2c7/0x340
 [<ffffffff8113b996>] ? mount_bdev+0x1c6/0x210
 [<ffffffff8113c55a>] ? mount_fs+0x1a/0xd0
 [<ffffffff811553b4>] ? vfs_kern_mount+0x64/0x110
 [<ffffffff81157513>] ? do_mount+0x213/0xa80
 [<ffffffff810ef799>] ? __get_free_pages+0x9/0x50
 [<ffffffff81158078>] ? SyS_mount+0x98/0xf0
 [<ffffffff814d8569>] ? system_call_fastpath+0x16/0x1b
Code: 00 00 00 00 00 e9 bb a8 fd ff 66 66 2e 0f 1f 84 00 00 00 00 00 41 56 49 89 fe 41 55 4c 8d 6f 30 41 54 55 53 48 8b 6f 30 4c 39 ed <4c> 8b 65 00 74 76 0f 1f 40 00 48 8b 45 08 48 ba 00 01 10 00 00 
RIP  [<ffffffff81259ef6>] xlog_recover_free_trans+0x16/0xb0
 RSP <ffff880037cabb08>
CR2: 0000000000000000


-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
