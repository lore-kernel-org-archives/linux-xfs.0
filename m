Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF1D57F3F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 09:42:28 -0600 (CST)
Message-ID: <54AFF6E0.3050303@sgi.com>
Date: Fri, 09 Jan 2015 09:42:24 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Oops mounting a corrupted XFS filesystem (with the "kernel BUG"
	message)
References: <20150109120558.2610d8aa@harpe.intellique.com>
In-Reply-To: <20150109120558.2610d8aa@harpe.intellique.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: XFS mailing list <xfs@oss.sgi.com>


> And finally ends with:
>
> XFS (sda5): metadata I/O error: block 0x1001c26d40 ("xlog_recover_do..(read#2)") error 117 numblks 16
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: [<ffffffff81259ef6>] xlog_recover_free_trans+0x16/0xb0
> PGD 37da7067 PUD 3752c067 PMD 0
> Oops: 0000 [#1] SMP
> Modules linked in: nfsv3 nfsv4 ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs bonding md_mod dm_mod nfsd lockd nfs_acl auth_rpcgss oid_registry sunrpc ipv6 fuse af_packet snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_midi snd_rawmidi snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device snd virtio_net virtio_balloon soundcore loop virtio_blk virtio_pci virtio_ring virtio ata_piix xhci_hcd uhci_hcd usb_storage joydev usbhid kvm_amd kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper mgag200 evdev ttm cryptd drm_kms_helper e1000e drm microcode pcspkr sp5100_tco i2c_algo_bit psmouse k10temp ptp fam15h_power pps_core ohci_pci i2c_piix4 ohci_hcd ehci_pci ehci_hcd i2c_core ses usbcore enclosure usb_common sg myri10ge acpi_cpufreq dca processor thermal_sys button ata_generic aacraid pa
ta
>   _atiixp
>   ahci libahci libata
> CPU: 5 PID: 18084 Comm: mount Not tainted 3.17.7-storiq64-opteron #1
> Hardware name: Supermicro H8SGL/H8SGL, BIOS 3.0a       05/07/2013
> task: ffff88040e1ad7f0 ti: ffff880037ca8000 task.ti: ffff880037ca8000
> RIP: 0010:[<ffffffff81259ef6>]  [<ffffffff81259ef6>] xlog_recover_free_trans+0x16/0xb0
> RSP: 0018:ffff880037cabb08  EFLAGS: 00010207
> RAX: 00000000ffffff8b RBX: 0000000000000001 RCX: 0000000000000002
> RDX: 00000000ffffff8b RSI: ffff88040c9105a0 RDI: ffff8800377b7f40
> RBP: 0000000000000000 R08: ffff880037ca8000 R09: 0000000000000000
> R10: ffffffff81723480 R11: 0000000000000001 R12: ffff880037cabc28
> R13: ffff8800377b7f70 R14: ffff8800377b7f40 R15: ffff8800377b7f40
> FS:  00007ffee71207e0(0000) GS:ffff88041eca0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 00000000db274000 CR4: 00000000000407e0
> Stack:
>   0000000000000001 ffffc90015c0bf1c ffff880037cabc28 00000000930b92d9
>   ffffc90015c0bf10 ffffffff8125e448 ffff8804ffffff8b ffffc90015c0c000
>   ffff880037cabbf8 ffff88020176cc00 ffff880403115000 0000000281259fbe
> Call Trace:
>   [<ffffffff8125e448>] ? xlog_recover_process_data+0x108/0x2a0
>   [<ffffffff8125e741>] ? xlog_do_recovery_pass+0x161/0x5c0
>   [<ffffffff8124e3d0>] ? xfs_parseargs+0xb80/0xb80
>   [<ffffffff8124e3d0>] ? xfs_parseargs+0xb80/0xb80
>   [<ffffffff8125ec18>] ? xlog_do_log_recovery+0x78/0xa0
>   [<ffffffff8125ec5a>] ? xlog_do_recover+0x1a/0x100
>   [<ffffffff8125f00b>] ? xlog_recover+0x7b/0xb0
>   [<ffffffff81253486>] ? xfs_log_mount+0xe6/0x2b0
>   [<ffffffff8124b642>] ? xfs_mountfs+0x442/0x780
>   [<ffffffff8123a9e0>] ? xfs_filestream_get_ag+0x20/0x20
>   [<ffffffff8124e697>] ? xfs_fs_fill_super+0x2c7/0x340
>   [<ffffffff8113b996>] ? mount_bdev+0x1c6/0x210
>   [<ffffffff8113c55a>] ? mount_fs+0x1a/0xd0
>   [<ffffffff811553b4>] ? vfs_kern_mount+0x64/0x110
>   [<ffffffff81157513>] ? do_mount+0x213/0xa80
>   [<ffffffff810ef799>] ? __get_free_pages+0x9/0x50
>   [<ffffffff81158078>] ? SyS_mount+0x98/0xf0
>   [<ffffffff814d8569>] ? system_call_fastpath+0x16/0x1b
> Code: 00 00 00 00 00 e9 bb a8 fd ff 66 66 2e 0f 1f 84 00 00 00 00 00 41 56 49 89 fe 41 55 4c 8d 6f 30 41 54 55 53 48 8b 6f 30 4c 39 ed<4c>  8b 65 00 74 76 0f 1f 40 00 48 8b 45 08 48 ba 00 01 10 00 00
> RIP  [<ffffffff81259ef6>] xlog_recover_free_trans+0x16/0xb0
>   RSP<ffff880037cabb08>
> CR2: 0000000000000000

The double free oops part of this bug was my fault and fixed as part of 
a log recovery reorganization:

commit 88b863db97a18a04c90ebd57d84e1b7863114dcb
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 29 09:45:32 2014 +1000

     xfs: fix double free in xlog_recover_commit_trans

     When an error occurs during buffer submission in
     xlog_recover_commit_trans(), we free the trans structure twice. Fix
     it by only freeing the structure in the caller regardless of the
     success or failure of the function.

The original corrupted metadata is probably caused by your RAID.

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
