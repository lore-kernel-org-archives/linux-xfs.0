Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47858 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731734AbfHFHIH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 03:08:07 -0400
Date: Tue, 6 Aug 2019 00:08:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS segementation fault with new linux 4.19.63
Message-ID: <20190806070806.GA13112@infradead.org>
References: <e0ca189e-2f96-6599-40ce-a4fc8866d8d1@nekoboi.moe>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e0ca189e-2f96-6599-40ce-a4fc8866d8d1@nekoboi.moe>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kinky Nekoboi <kinky_nekoboi@nekoboi.moe>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org

[adding the linux-xfs list]

On Wed, Jul 31, 2019 at 03:01:33PM +0200, Kinky Nekoboi wrote:
> I am not subscribed, so if you want to contact me do Direkt Email.
> 
> kern output:
> 
> 
> ul 31 13:51:53 lain kernel: [   71.660736] XFS: Assertion failed:
> xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
> pag->pagf_freeblks + pag->pagf_flcount, file:
> fs/xfs/libxfs/xfs_ag_resv.c, line: 319
> Jul 31 13:51:53 lain kernel: [   71.681711] ------------[ cut here
> ]------------
> Jul 31 13:51:53 lain kernel: [   71.686416] kernel BUG at
> fs/xfs/xfs_message.c:102!
> Jul 31 13:51:53 lain kernel: [   71.691431] invalid opcode: 0000 [#1]
> SMP NOPTI
> Jul 31 13:51:53 lain kernel: [   71.696047] CPU: 2 PID: 1322 Comm: mount
> Not tainted 4.19.63-custom #1
> Jul 31 13:51:53 lain kernel: [   71.702730] Hardware name: ASUS
> KGPE-D16/KGPE-D16, BIOS 4.10-108-gc19161538c 07/29/2019
> Jul 31 13:51:53 lain kernel: [   71.711028] RIP: 0010:assfail+0x25/0x36
> [xfs]
> Jul 31 13:51:53 lain kernel: [   71.715475] Code: d4 e8 0f 0b c3 0f 1f
> 44 00 00 48 89 f1 41 89 d0 48 c7 c6 80 62 fb c0 48 89 fa 31 ff e8 72 f9
> ff ff 80 3d 2e cb 08 00 00 74 02 <0f> 0b 48 c7 c7 b0 62 fb c0 e8 74 11
> d4 e8 0f 0b c3 48 8b b3 a8 01
> Jul 31 13:51:53 lain kernel: [   71.734532] RSP: 0018:ffffb3a584117cb8
> EFLAGS: 00010202
> Jul 31 13:51:53 lain kernel: [   71.739849] RAX: 0000000000000000 RBX:
> ffffa0259fc22a00 RCX: 0000000000000000
> Jul 31 13:51:53 lain kernel: [   71.747135] RDX: 00000000ffffffc0 RSI:
> 000000000000000a RDI: ffffffffc0fa971b
> Jul 31 13:51:53 lain kernel: [   71.754407] RBP: 0000000000000000 R08:
> 0000000000000000 R09: 0000000000000000
> Jul 31 13:51:53 lain kernel: [   71.761633] R10: 000000000000000a R11:
> f000000000000000 R12: ffffa0259c157000
> Jul 31 13:51:53 lain kernel: [   71.768861] R13: 0000000000000008 R14:
> ffffa0259c157000 R15: 0000000000000000
> Jul 31 13:51:53 lain kernel: [   71.776110] FS:  00007f169d61f100(0000)
> GS:ffffa025a7c80000(0000) knlGS:0000000000000000
> Jul 31 13:51:53 lain kernel: [   71.784330] CS:  0010 DS: 0000 ES: 0000
> CR0: 0000000080050033
> Jul 31 13:51:53 lain kernel: [   71.790198] CR2: 00007fa8c52fc441 CR3:
> 000000042453c000 CR4: 00000000000406e0
> Jul 31 13:51:53 lain kernel: [   71.797446] Call Trace:
> Jul 31 13:51:53 lain kernel: [   71.800040] 
> xfs_ag_resv_init+0x1bd/0x1d0 [xfs]
> Jul 31 13:51:53 lain kernel: [   71.804717] 
> xfs_fs_reserve_ag_blocks+0x3e/0xb0 [xfs]
> Jul 31 13:51:53 lain kernel: [   71.809937]  xfs_mountfs+0x5b3/0x920 [xfs]
> Jul 31 13:51:53 lain kernel: [   71.814212] 
> xfs_fs_fill_super+0x44d/0x620 [xfs]
> Jul 31 13:51:53 lain kernel: [   71.818997]  ?
> xfs_test_remount_options+0x60/0x60 [xfs]
> Jul 31 13:51:53 lain kernel: [   71.824320]  mount_bdev+0x177/0x1b0
> Jul 31 13:51:53 lain kernel: [   71.827868]  mount_fs+0x3e/0x145
> Jul 31 13:51:53 lain kernel: [   71.831178] 
> vfs_kern_mount.part.35+0x54/0x120
> Jul 31 13:51:53 lain kernel: [   71.835728]  do_mount+0x20e/0xcc0
> Jul 31 13:51:53 lain kernel: [   71.839098]  ? _copy_from_user+0x37/0x60
> Jul 31 13:51:53 lain kernel: [   71.843097]  ? memdup_user+0x4b/0x70
> Jul 31 13:51:53 lain kernel: [   71.846751]  ksys_mount+0xb6/0xd0
> Jul 31 13:51:53 lain kernel: [   71.850137]  __x64_sys_mount+0x21/0x30
> Jul 31 13:51:53 lain kernel: [   71.853983]  do_syscall_64+0x55/0xf0
> Jul 31 13:51:53 lain kernel: [   71.857621] 
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> Jul 31 13:51:53 lain kernel: [   71.862727] RIP: 0033:0x7f169d2b1fea
> Jul 31 13:51:53 lain kernel: [   71.866362] Code: 48 8b 0d a9 0e 0c 00
> f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
> 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d
> 76 0e 0c 00 f7 d8 64 89 01 48
> Jul 31 13:51:53 lain kernel: [   71.885417] RSP: 002b:00007ffe6c4dd048
> EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> Jul 31 13:51:53 lain kernel: [   71.895075] RAX: ffffffffffffffda RBX:
> 000055e2f3093a40 RCX: 00007f169d2b1fea
> Jul 31 13:51:53 lain kernel: [   71.904309] RDX: 000055e2f309b220 RSI:
> 000055e2f3093c70 RDI: 000055e2f3093c50
> Jul 31 13:51:53 lain kernel: [   71.913532] RBP: 00007f169d6061c4 R08:
> 0000000000000000 R09: 00007f169d2f3400
> Jul 31 13:51:53 lain kernel: [   71.922730] R10: 0000000000000000 R11:
> 0000000000000246 R12: 0000000000000000
> Jul 31 13:51:53 lain kernel: [   71.931950] R13: 0000000000000000 R14:
> 000055e2f3093c50 R15: 000055e2f309b220
> Jul 31 13:51:53 lain kernel: [   71.941107] Modules linked in: dm_crypt
> twofish_generic twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64
> twofish_common xts algif_skcipher af_alg dm_mod tun devlink
> cpufreq_userspace cpufreq_powersave cpufreq_conservative binfmt_misc xfs
> amd64_edac_mod edac_mce_amd kvm_amd ccp rng_core kvm irqbypass
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc snd_hda_intel ast
> snd_hda_codec ttm snd_hda_core evdev snd_pcsp snd_hwdep drm_kms_helper
> snd_pcm snd_timer aesni_intel aes_x86_64 drm crypto_simd snd cryptd
> serio_raw i2c_algo_bit fam15h_power k10temp glue_helper soundcore sg
> sp5100_tco pcc_cpufreq button acpi_cpufreq nft_counter nft_ct
> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables_set nf_tables
> nfnetlink ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 fscrypto
> raid10 raid1 raid0 multipath
> Jul 31 13:51:53 lain kernel: [   72.027825]  linear raid456
> async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq
> libcrc32c crc32c_generic md_mod sd_mod ohci_pci ata_generic ahci
> firewire_ohci xhci_pci libahci ohci_hcd ehci_pci pata_atiixp xhci_hcd
> firewire_core ehci_hcd crc_itu_t libata psmouse crc32c_intel i2c_piix4
> usbcore scsi_mod e1000e
> Jul 31 13:51:53 lain kernel: [   72.064151] ---[ end trace
> a6475ff3d1350cc4 ]---
> Jul 31 13:51:53 lain kernel: [   72.071244] RIP: 0010:assfail+0x25/0x36
> [xfs]
> Jul 31 13:51:53 lain kernel: [   72.077951] Code: d4 e8 0f 0b c3 0f 1f
> 44 00 00 48 89 f1 41 89 d0 48 c7 c6 80 62 fb c0 48 89 fa 31 ff e8 72 f9
> ff ff 80 3d 2e cb 08 00 00 74 02 <0f> 0b 48 c7 c7 b0 62 fb c0 e8 74 11
> d4 e8 0f 0b c3 48 8b b3 a8 01
> Jul 31 13:51:53 lain kernel: [   72.101469] RSP: 0018:ffffb3a584117cb8
> EFLAGS: 00010202
> Jul 31 13:51:53 lain kernel: [   72.109081] RAX: 0000000000000000 RBX:
> ffffa0259fc22a00 RCX: 0000000000000000
> Jul 31 13:51:53 lain kernel: [   72.118620] RDX: 00000000ffffffc0 RSI:
> 000000000000000a RDI: ffffffffc0fa971b
> Jul 31 13:51:53 lain kernel: [   72.128206] RBP: 0000000000000000 R08:
> 0000000000000000 R09: 0000000000000000
> Jul 31 13:51:53 lain kernel: [   72.137789] R10: 000000000000000a R11:
> f000000000000000 R12: ffffa0259c157000
> Jul 31 13:51:53 lain kernel: [   72.147332] R13: 0000000000000008 R14:
> ffffa0259c157000 R15: 0000000000000000
> Jul 31 13:51:53 lain kernel: [   72.156892] FS:  00007f169d61f100(0000)
> GS:ffffa025a7c80000(0000) knlGS:0000000000000000
> Jul 31 13:51:53 lain kernel: [   72.167382] CS:  0010 DS: 0000 ES: 0000
> CR0: 0000000080050033
> Jul 31 13:51:53 lain kernel: [   72.175498] CR2: 00007fa8c52fc441 CR3:
> 000000042453c000 CR4: 00000000000406e0
> 
---end quoted text---
