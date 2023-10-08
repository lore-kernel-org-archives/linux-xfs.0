Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2B8E95A67
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Oct 2023 17:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjJHRfr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Oct 2023 13:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234257AbjJHRfq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Oct 2023 13:35:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2EEB9
        for <linux-xfs@vger.kernel.org>; Sun,  8 Oct 2023 10:35:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53541C433C8
        for <linux-xfs@vger.kernel.org>; Sun,  8 Oct 2023 17:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696786542;
        bh=VmhEFVLHtmDzj6jRGzYOcAHc82zOFN+BC+sywiYxDFQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NCyD4+JaA4Icyrj8IeULWVQjqYdwayrfWCy6Ke2dRi1DKKtga6lBTi+fnRgFIFel1
         dLlcZniNz6iJP6w4PWkeD1ruogvEWAeR2+4oOd9fGPiJt0wxUC6SbfFPuQXEjFXwyP
         TgR4LM/ffyswJBQjjo98AGwxLFupGIko2uXBYY0WdODfkeM55yh/N9SjGkeLDWvdRr
         rId6GP0Azzof5GTOJhJDVhCG3up3rOpsfjL187JEWJ1gppY3XpTY68yNHJhxkKuyXr
         BVcm8VykPvvC5TnYxIl5b1Nl8hz5Na3OpevLsT450ADTfeNtKZTYFMU8H+1iIyu0bl
         DH3Ft8JFAXTHA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2C2A5C53BCD; Sun,  8 Oct 2023 17:35:42 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Sun, 08 Oct 2023 17:35:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mironov.ivan@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217572-201763-aN3rOxy0ov@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217572-201763@https.bugzilla.kernel.org/>
References: <bug-217572-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217572

--- Comment #16 from Ivan Mironov (mironov.ivan@gmail.com) ---
It looks like this is still happening with 6.5.5, which includes cbc0285433=
1e
("XArray: Do not return sibling entries from xa_load()").

[    0.000000] Linux version 6.5.5-200.fc38.x86_64
(mockbuild@d4d01d62c9c942e59de1ef4aa94df5a2) (gcc (GCC) 13.2.1 20230728 (Red
Hat 13.2.1-1), GNU ld version 2.39-9.fc38) #1 SMP PREEMPT_DYNAMIC Sun Sep 24
15:52:44 UTC 2023
[    0.000000] Command line: BOOT_IMAGE=3D(md/boot)/vmlinuz-6.5.5-200.fc38.=
x86_64
root=3D/dev/mapper/vg--bmsolv-root ro
rd.md.uuid=3D216337a3:789c28b0:81fbad29:6f190e56 rd.lvm.lv=3Dvg-bmsolv/root
rd.md.uuid=3D252001b9:2095e731:f1dd5baa:8b672d56 clocksource=3Dtsc tsc=3Dre=
liable
amd_pstate=3Dactive rhgb quiet
...
[146990.211120] watchdog: BUG: soft lockup - CPU#20 stuck for 26s!
[solAcctHashVer:3040]
[146990.211140] Modules linked in: nft_masq nft_fib_inet nft_fib_ipv4
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reje=
ct
wireguard curve25519_x86_64 libcurve25519_generic ip6_udp_tunnel udp_tunnel
nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfki=
ll
tcp_bbr ip_set nf_tables nfnetlink tun nct6775 nct6775_core hwmon_vid ipmi_=
ssif
vfat fat intel_rapl_msr intel_rapl_common edac_mce_amd kvm_amd snd_hda_intel
snd_intel_dspcfg snd_intel_sdw_acpi kvm snd_hda_codec snd_hda_core snd_hwdep
snd_pcm snd_timer irqbypass snd acpi_ipmi cdc_ether rapl wmi_bmof usbnet
ipmi_si soundcore i2c_piix4 k10temp mii ipmi_devintf ipmi_msghandler joydev
fuse loop xfs raid1 igb dca ast i2c_algo_bit crct10dif_pclmul nvme crc32_pc=
lmul
crc32c_intel polyval_clmulni polyval_generic nvme_core ghash_clmulni_intel =
ccp
sha512_ssse3 wmi sp5100_tco nvme_common
[146990.211199] CPU: 20 PID: 3040 Comm: solAcctHashVer Not tainted
6.5.5-200.fc38.x86_64 #1
[146990.211201] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./X570D4U, BIOS P1.20 05/19/2021
[146990.211203] RIP: 0010:xas_load+0x11/0x50
[146990.211208] Code: 66 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90=
 90
90 90 90 90 90 90 f3 0f 1e fa 55 53 48 89 fb e8 22 ff ff ff 48 89 c2 <83> e=
2 03
48 83 fa 02 75 08 48 3d 00 10 00 00 77 07 5b 5d e9 77 77
[146990.211210] RSP: 0018:ffffa80983a7bbb0 EFLAGS: 00000297
[146990.211211] RAX: ffff95d60e099ff2 RBX: ffffa80983a7bbc8 RCX:
000000000000000c
[146990.211213] RDX: ffff95d60e099ff2 RSI: ffff95d4c5326da0 RDI:
ffffa80983a7bbc8
[146990.211214] RBP: 0000000000013e21 R08: 0000000000000000 R09:
0000000000002000
[146990.211215] R10: 0000000000000000 R11: ffff95d6a03d6538 R12:
0000000000013e21
[146990.211216] R13: ffff95e11e2d1400 R14: 0000000000013e20 R15:
ffffa80983a7be60
[146990.211217] FS:  00007fd0d7fff6c0(0000) GS:ffff95f47ef00000(0000)
knlGS:0000000000000000
[146990.211218] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[146990.211219] CR2: 00007fc0fbb12000 CR3: 000000010e2f2000 CR4:
0000000000750ee0
[146990.211221] PKRU: 55555554
[146990.211222] Call Trace:
[146990.211223]  <IRQ>
[146990.211227]  ? watchdog_timer_fn+0x1b8/0x220
[146990.211230]  ? __pfx_watchdog_timer_fn+0x10/0x10
[146990.211232]  ? __hrtimer_run_queues+0x112/0x2b0
[146990.211236]  ? hrtimer_interrupt+0xf8/0x230
[146990.211239]  ? __sysvec_apic_timer_interrupt+0x61/0x130
[146990.211242]  ? sysvec_apic_timer_interrupt+0x6d/0x90
[146990.211245]  </IRQ>
[146990.211245]  <TASK>
[146990.211246]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
[146990.211252]  ? xas_load+0x11/0x50
[146990.211254]  filemap_get_read_batch+0x16e/0x250
[146990.211258]  filemap_get_pages+0xa6/0x630
[146990.211263]  filemap_read+0xd9/0x350
[146990.211270]  xfs_file_buffered_read+0x52/0xd0 [xfs]
[146990.211353]  xfs_file_read_iter+0x77/0xe0 [xfs]
[146990.211423]  vfs_read+0x201/0x350
[146990.211429]  ksys_read+0x6f/0xf0
[146990.211433]  do_syscall_64+0x60/0x90
[146990.211437]  ? srso_alias_return_thunk+0x5/0x7f
[146990.211441]  ? exc_page_fault+0x7f/0x180
[146990.211444]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[146990.211448] RIP: 0033:0x7ffb383230ea
[146990.211465] Code: 55 48 89 e5 48 83 ec 20 48 89 55 e8 48 89 75 f0 89 7d=
 f8
e8 e8 79 f8 ff 48 8b 55 e8 48 8b 75 f0 41 89 c0 8b 7d f8 31 c0 0f 05 <48> 3=
d 00
f0 ff ff 77 2e 44 89 c7 48 89 45 f8 e8 42 7a f8 ff 48 8b
[146990.211467] RSP: 002b:00007fd0d7ff80b0 EFLAGS: 00000246 ORIG_RAX:
0000000000000000
[146990.211469] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007ffb383230ea
[146990.211471] RDX: 0000000000002000 RSI: 00007fd28b056000 RDI:
000000000000084c
[146990.211472] RBP: 00007fd0d7ff80d0 R08: 0000000000000000 R09:
00000000000000cd
[146990.211474] R10: 00000000d40f7fa1 R11: 0000000000000246 R12:
00007fd28b056000
[146990.211475] R13: 00007fd0d7ffc3e0 R14: 0000000000002000 R15:
0000000000002000
[146990.211480]  </TASK>
[147038.206219] watchdog: BUG: soft lockup - CPU#2 stuck for 27s!
[solAcctHashVer:3040]
[147038.206244] Modules linked in: nft_masq nft_fib_inet nft_fib_ipv4
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reje=
ct
wireguard curve25519_x86_64 libcurve25519_generic ip6_udp_tunnel udp_tunnel
nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfki=
ll
tcp_bbr ip_set nf_tables nfnetlink tun nct6775 nct6775_core hwmon_vid ipmi_=
ssif
vfat fat intel_rapl_msr intel_rapl_common edac_mce_amd kvm_amd snd_hda_intel
snd_intel_dspcfg snd_intel_sdw_acpi kvm snd_hda_codec snd_hda_core snd_hwdep
snd_pcm snd_timer irqbypass snd acpi_ipmi cdc_ether rapl wmi_bmof usbnet
ipmi_si soundcore i2c_piix4 k10temp mii ipmi_devintf ipmi_msghandler joydev
fuse loop xfs raid1 igb dca ast i2c_algo_bit crct10dif_pclmul nvme crc32_pc=
lmul
crc32c_intel polyval_clmulni polyval_generic nvme_core ghash_clmulni_intel =
ccp
sha512_ssse3 wmi sp5100_tco nvme_common
[147038.206306] CPU: 2 PID: 3040 Comm: solAcctHashVer Tainted: G           =
  L=20
   6.5.5-200.fc38.x86_64 #1
[147038.206309] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./X570D4U, BIOS P1.20 05/19/2021
[147038.206310] RIP: 0010:xas_load+0x45/0x50
[147038.206315] Code: 3d 00 10 00 00 77 07 5b 5d e9 77 77 02 00 0f b6 4b 10=
 48
8d 68 fe 38 48 fe 72 ec 48 89 ee 48 89 df e8 af fd ff ff 80 7d 00 00 <75> c=
7 eb
d9 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90
[147038.206317] RSP: 0018:ffffa80983a7bbe0 EFLAGS: 00000206
[147038.206318] RAX: ffff95f326a6f47a RBX: ffffa80983a7bc20 RCX:
0000000000000002
[147038.206320] RDX: 0000000000000013 RSI: ffff95d60e099ff0 RDI:
ffffa80983a7bc20
[147038.206321] RBP: ffff95d60e099ff0 R08: ffffffffffffffc0 R09:
0000000000000000
[147038.206322] R10: 0000000000000001 R11: 0000000000000002 R12:
0000000000013e20
[147038.206323] R13: ffffa80983a7bcb8 R14: ffff95d6a03d66b0 R15:
000000000000000d
[147038.206324] FS:  00007fd0d7fff6c0(0000) GS:ffff95f47ea80000(0000)
knlGS:0000000000000000
[147038.206326] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[147038.206327] CR2: 00007fc5390d8980 CR3: 000000010e2f2000 CR4:
0000000000750ee0
[147038.206328] PKRU: 55555554
[147038.206329] Call Trace:
[147038.206331]  <IRQ>
[147038.206335]  ? watchdog_timer_fn+0x1b8/0x220
[147038.206338]  ? __pfx_watchdog_timer_fn+0x10/0x10
[147038.206340]  ? __hrtimer_run_queues+0x112/0x2b0
[147038.206344]  ? hrtimer_interrupt+0xf8/0x230
[147038.206347]  ? __sysvec_apic_timer_interrupt+0x61/0x130
[147038.206350]  ? sysvec_apic_timer_interrupt+0x6d/0x90
[147038.206353]  </IRQ>
[147038.206353]  <TASK>
[147038.206354]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
[147038.206361]  ? xas_load+0x45/0x50
[147038.206363]  xas_find+0x162/0x1c0
[147038.206365]  find_lock_entries+0x84/0x270
[147038.206371]  truncate_inode_pages_range+0xd7/0x400
[147038.206379]  evict+0x1b0/0x1d0
[147038.206383]  do_unlinkat+0x177/0x320
[147038.206387]  __x64_sys_unlink+0x42/0x70
[147038.206390]  do_syscall_64+0x60/0x90
[147038.206393]  ? srso_alias_return_thunk+0x5/0x7f
[147038.206395]  ? ksys_write+0xd8/0xf0
[147038.206399]  ? srso_alias_return_thunk+0x5/0x7f
[147038.206401]  ? syscall_exit_to_user_mode+0x2b/0x40
[147038.206403]  ? srso_alias_return_thunk+0x5/0x7f
[147038.206405]  ? do_syscall_64+0x6c/0x90
[147038.206407]  ? srso_alias_return_thunk+0x5/0x7f
[147038.206409]  ? irqtime_account_irq+0x40/0xc0
[147038.206412]  ? srso_alias_return_thunk+0x5/0x7f
[147038.206414]  ? __irq_exit_rcu+0x4b/0xc0
[147038.206417]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[147038.206419] RIP: 0033:0x7ffb38324aab
[147038.206436] Code: f0 ff ff 73 01 c3 48 8b 0d 5a 13 0d 00 f7 d8 64 89 01=
 48
83 c8 ff c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 57 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 29 13 0d 00 f7 d8
[147038.206438] RSP: 002b:00007fd0d7ffb8e8 EFLAGS: 00000246 ORIG_RAX:
0000000000000057
[147038.206439] RAX: ffffffffffffffda RBX: 000000000000003f RCX:
00007ffb38324aab
[147038.206441] RDX: 000000000000003f RSI: 00007fd0d7ffb8f0 RDI:
00007fd0d7ffb8f0
[147038.206442] RBP: 00007fd0d7ffca40 R08: 0000000000000000 R09:
0000000000000030
[147038.206442] R10: fefefefefefefeff R11: 0000000000000246 R12:
00005642797b0f00
[147038.206443] R13: 00007fd0d7ffc3e0 R14: 000000000000084c R15:
0000000000000000
[147038.206447]  </TASK>
[147066.205694] watchdog: BUG: soft lockup - CPU#2 stuck for 53s!
[solAcctHashVer:3040]
[147066.205714] Modules linked in: nft_masq nft_fib_inet nft_fib_ipv4
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reje=
ct
wireguard curve25519_x86_64 libcurve25519_generic ip6_udp_tunnel udp_tunnel
nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfki=
ll
tcp_bbr ip_set nf_tables nfnetlink tun nct6775 nct6775_core hwmon_vid ipmi_=
ssif
vfat fat intel_rapl_msr intel_rapl_common edac_mce_amd kvm_amd snd_hda_intel
snd_intel_dspcfg snd_intel_sdw_acpi kvm snd_hda_codec snd_hda_core snd_hwdep
snd_pcm snd_timer irqbypass snd acpi_ipmi cdc_ether rapl wmi_bmof usbnet
ipmi_si soundcore i2c_piix4 k10temp mii ipmi_devintf ipmi_msghandler joydev
fuse loop xfs raid1 igb dca ast i2c_algo_bit crct10dif_pclmul nvme crc32_pc=
lmul
crc32c_intel polyval_clmulni polyval_generic nvme_core ghash_clmulni_intel =
ccp
sha512_ssse3 wmi sp5100_tco nvme_common
[147066.205773] CPU: 2 PID: 3040 Comm: solAcctHashVer Tainted: G           =
  L=20
   6.5.5-200.fc38.x86_64 #1
[147066.205775] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./X570D4U, BIOS P1.20 05/19/2021
[147066.205776] RIP: 0010:xas_load+0x45/0x50
[147066.205782] Code: 3d 00 10 00 00 77 07 5b 5d e9 77 77 02 00 0f b6 4b 10=
 48
8d 68 fe 38 48 fe 72 ec 48 89 ee 48 89 df e8 af fd ff ff 80 7d 00 00 <75> c=
7 eb
d9 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90
[147066.205783] RSP: 0018:ffffa80983a7bbe0 EFLAGS: 00000206
[147066.205785] RAX: ffff95d4c5326da2 RBX: ffffa80983a7bc20 RCX:
0000000000000002
[147066.205786] RDX: 0000000000000038 RSI: ffff95f326a6f478 RDI:
ffffa80983a7bc20
[147066.205787] RBP: ffff95f326a6f478 R08: ffffffffffffffc0 R09:
0000000000000000
[147066.205788] R10: 0000000000000001 R11: 0000000000000002 R12:
0000000000013e20
[147066.205789] R13: ffffa80983a7bcb8 R14: ffff95d6a03d66b0 R15:
000000000000000d
[147066.205790] FS:  00007fd0d7fff6c0(0000) GS:ffff95f47ea80000(0000)
knlGS:0000000000000000
[147066.205792] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[147066.205793] CR2: 00007fc5390d8980 CR3: 000000010e2f2000 CR4:
0000000000750ee0
[147066.205794] PKRU: 55555554
[147066.205795] Call Trace:
[147066.205797]  <IRQ>
[147066.205801]  ? watchdog_timer_fn+0x1b8/0x220
[147066.205804]  ? __pfx_watchdog_timer_fn+0x10/0x10
[147066.205806]  ? __hrtimer_run_queues+0x112/0x2b0
[147066.205811]  ? hrtimer_interrupt+0xf8/0x230
[147066.205813]  ? __sysvec_apic_timer_interrupt+0x61/0x130
[147066.205816]  ? sysvec_apic_timer_interrupt+0x6d/0x90
[147066.205819]  </IRQ>
[147066.205820]  <TASK>
[147066.205821]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
[147066.205827]  ? xas_load+0x45/0x50
[147066.205829]  xas_find+0x162/0x1c0
[147066.205832]  find_lock_entries+0x84/0x270
[147066.205837]  truncate_inode_pages_range+0xd7/0x400
[147066.205846]  evict+0x1b0/0x1d0
[147066.205849]  do_unlinkat+0x177/0x320
[147066.205854]  __x64_sys_unlink+0x42/0x70
[147066.205856]  do_syscall_64+0x60/0x90
[147066.205859]  ? srso_alias_return_thunk+0x5/0x7f
[147066.205862]  ? ksys_write+0xd8/0xf0
[147066.205866]  ? srso_alias_return_thunk+0x5/0x7f
[147066.205868]  ? syscall_exit_to_user_mode+0x2b/0x40
[147066.205870]  ? srso_alias_return_thunk+0x5/0x7f
[147066.205872]  ? do_syscall_64+0x6c/0x90
[147066.205874]  ? srso_alias_return_thunk+0x5/0x7f
[147066.205876]  ? irqtime_account_irq+0x40/0xc0
[147066.205879]  ? srso_alias_return_thunk+0x5/0x7f
[147066.205880]  ? __irq_exit_rcu+0x4b/0xc0
[147066.205884]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[147066.205887] RIP: 0033:0x7ffb38324aab
[147066.205903] Code: f0 ff ff 73 01 c3 48 8b 0d 5a 13 0d 00 f7 d8 64 89 01=
 48
83 c8 ff c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 57 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 29 13 0d 00 f7 d8
[147066.205905] RSP: 002b:00007fd0d7ffb8e8 EFLAGS: 00000246 ORIG_RAX:
0000000000000057
[147066.205907] RAX: ffffffffffffffda RBX: 000000000000003f RCX:
00007ffb38324aab
[147066.205908] RDX: 000000000000003f RSI: 00007fd0d7ffb8f0 RDI:
00007fd0d7ffb8f0
[147066.205909] RBP: 00007fd0d7ffca40 R08: 0000000000000000 R09:
0000000000000030
[147066.205910] R10: fefefefefefefeff R11: 0000000000000246 R12:
00005642797b0f00
[147066.205911] R13: 00007fd0d7ffc3e0 R14: 000000000000084c R15:
0000000000000000
[147066.205914]  </TASK>
[147070.806580] rcu: INFO: rcu_preempt self-detected stall on CPU
[147070.806586] rcu:    2-....: (59999 ticks this GP)
idle=3D35c4/1/0x4000000000000000 softirq=3D43126317/43126325 fqs=3D14456
[147070.806590] rcu:    (t=3D60001 jiffies g=3D64450853 q=3D40369 ncpus=3D3=
2)
[147070.806593] CPU: 2 PID: 3040 Comm: solAcctHashVer Tainted: G           =
  L=20
   6.5.5-200.fc38.x86_64 #1
[147070.806596] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./X570D4U, BIOS P1.20 05/19/2021
[147070.806597] RIP: 0010:xas_start+0x1e/0xc0
[147070.806603] Code: 90 90 90 90 90 90 90 90 90 90 90 90 48 8b 57 18 48 89=
 d0
83 e0 03 74 5c 48 81 fa 05 c0 ff ff 76 06 48 83 f8 02 74 46 48 8b 07 <48> 8=
b 57
08 48 8b 40 08 48 89 c1 83 e1 03 48 83 f9 02 75 08 48 3d
[147070.806604] RSP: 0018:ffffa80983a7bbd8 EFLAGS: 00000213
[147070.806607] RAX: ffff95d6a03d66b8 RBX: ffffa80983a7bc20 RCX:
0000000000000000
[147070.806608] RDX: 0000000000000003 RSI: 0000000000000003 RDI:
ffffa80983a7bc20
[147070.806609] RBP: fffffffffffffffe R08: ffffffffffffffc0 R09:
0000000000000000
[147070.806610] R10: 0000000000000001 R11: 0000000000000002 R12:
0000000000013e20
[147070.806611] R13: ffffa80983a7bcb8 R14: ffff95d6a03d66b0 R15:
000000000000000d
[147070.806612] FS:  00007fd0d7fff6c0(0000) GS:ffff95f47ea80000(0000)
knlGS:0000000000000000
[147070.806614] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[147070.806615] CR2: 00007fc5390d8980 CR3: 000000010e2f2000 CR4:
0000000000750ee0
[147070.806617] PKRU: 55555554
[147070.806618] Call Trace:
[147070.806619]  <IRQ>
[147070.806623]  ? rcu_dump_cpu_stacks+0xc4/0x100
[147070.806628]  ? rcu_sched_clock_irq+0x4f2/0x1170
[147070.806631]  ? srso_alias_return_thunk+0x5/0x7f
[147070.806634]  ? task_tick_fair+0x2fc/0x3f0
[147070.806637]  ? srso_alias_return_thunk+0x5/0x7f
[147070.806639]  ? srso_alias_return_thunk+0x5/0x7f
[147070.806641]  ? trigger_load_balance+0x73/0x390
[147070.806644]  ? srso_alias_return_thunk+0x5/0x7f
[147070.806647]  ? update_process_times+0x74/0xb0
[147070.806650]  ? tick_sched_handle+0x21/0x60
[147070.806653]  ? tick_sched_timer+0x6f/0x90
[147070.806654]  ? __pfx_tick_sched_timer+0x10/0x10
[147070.806656]  ? __hrtimer_run_queues+0x112/0x2b0
[147070.806660]  ? hrtimer_interrupt+0xf8/0x230
[147070.806662]  ? __sysvec_apic_timer_interrupt+0x61/0x130
[147070.806665]  ? sysvec_apic_timer_interrupt+0x6d/0x90
[147070.806668]  </IRQ>
[147070.806669]  <TASK>
[147070.806670]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
[147070.806675]  ? xas_start+0x1e/0xc0
[147070.806677]  ? srso_alias_return_thunk+0x5/0x7f
[147070.806680]  xas_load+0xe/0x50
[147070.806682]  xas_find+0x162/0x1c0
[147070.806684]  find_lock_entries+0x84/0x270
[147070.806689]  truncate_inode_pages_range+0xd7/0x400
[147070.806699]  evict+0x1b0/0x1d0
[147070.806703]  do_unlinkat+0x177/0x320
[147070.806708]  __x64_sys_unlink+0x42/0x70
[147070.806711]  do_syscall_64+0x60/0x90
[147070.806714]  ? srso_alias_return_thunk+0x5/0x7f
[147070.806716]  ? ksys_write+0xd8/0xf0
[147070.806719]  ? srso_alias_return_thunk+0x5/0x7f
[147070.806721]  ? syscall_exit_to_user_mode+0x2b/0x40
[147070.806724]  ? srso_alias_return_thunk+0x5/0x7f
[147070.806726]  ? do_syscall_64+0x6c/0x90
[147070.806728]  ? srso_alias_return_thunk+0x5/0x7f
[147070.806730]  ? irqtime_account_irq+0x40/0xc0
[147070.806732]  ? srso_alias_return_thunk+0x5/0x7f
[147070.806734]  ? __irq_exit_rcu+0x4b/0xc0
[147070.806738]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[147070.806740] RIP: 0033:0x7ffb38324aab
[147070.806756] Code: f0 ff ff 73 01 c3 48 8b 0d 5a 13 0d 00 f7 d8 64 89 01=
 48
83 c8 ff c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 57 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 29 13 0d 00 f7 d8
[147070.806758] RSP: 002b:00007fd0d7ffb8e8 EFLAGS: 00000246 ORIG_RAX:
0000000000000057
[147070.806760] RAX: ffffffffffffffda RBX: 000000000000003f RCX:
00007ffb38324aab
[147070.806761] RDX: 000000000000003f RSI: 00007fd0d7ffb8f0 RDI:
00007fd0d7ffb8f0
[147070.806762] RBP: 00007fd0d7ffca40 R08: 0000000000000000 R09:
0000000000000030
[147070.806763] R10: fefefefefefefeff R11: 0000000000000246 R12:
00005642797b0f00
[147070.806764] R13: 00007fd0d7ffc3e0 R14: 000000000000084c R15:
0000000000000000
[147070.806768]  </TASK>
[147098.205093] watchdog: BUG: soft lockup - CPU#2 stuck for 82s!
[solAcctHashVer:3040]
[147098.205113] Modules linked in: nft_masq nft_fib_inet nft_fib_ipv4
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reje=
ct
wireguard curve25519_x86_64 libcurve25519_generic ip6_udp_tunnel udp_tunnel
nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfki=
ll
tcp_bbr ip_set nf_tables nfnetlink tun nct6775 nct6775_core hwmon_vid ipmi_=
ssif
vfat fat intel_rapl_msr intel_rapl_common edac_mce_amd kvm_amd snd_hda_intel
snd_intel_dspcfg snd_intel_sdw_acpi kvm snd_hda_codec snd_hda_core snd_hwdep
snd_pcm snd_timer irqbypass snd acpi_ipmi cdc_ether rapl wmi_bmof usbnet
ipmi_si soundcore i2c_piix4 k10temp mii ipmi_devintf ipmi_msghandler joydev
fuse loop xfs raid1 igb dca ast i2c_algo_bit crct10dif_pclmul nvme crc32_pc=
lmul
crc32c_intel polyval_clmulni polyval_generic nvme_core ghash_clmulni_intel =
ccp
sha512_ssse3 wmi sp5100_tco nvme_common
[147098.205173] CPU: 2 PID: 3040 Comm: solAcctHashVer Tainted: G           =
  L=20
   6.5.5-200.fc38.x86_64 #1
[147098.205176] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./X570D4U, BIOS P1.20 05/19/2021
[147098.205177] RIP: 0010:xas_find+0xb3/0x1c0
[147098.205182] Code: b6 53 12 80 fa 40 0f 84 80 00 00 00 0f b6 c2 48 83 c0=
 04
48 8b 44 c6 08 48 89 c1 83 e1 03 48 83 f9 02 74 52 48 85 c0 74 11 5b <5d> 4=
1 5c
e9 c5 67 02 00 48 3d fd 00 00 00 77 ef 83 c2 01 4c 89 c0
[147098.205184] RSP: 0018:ffffa80983a7bc00 EFLAGS: 00000286
[147098.205186] RAX: ffffdf5ac1990000 RBX: fffffffffffffffe RCX:
0000000000000000
[147098.205187] RDX: 0000000000000020 RSI: ffff95d4c5326da0 RDI:
ffffa80983a7bc20
[147098.205188] RBP: fffffffffffffffe R08: ffffffffffffffc0 R09:
0000000000000000
[147098.205189] R10: 0000000000000001 R11: 0000000000000002 R12:
0000000000013e20
[147098.205191] R13: ffffa80983a7bcb8 R14: ffff95d6a03d66b0 R15:
000000000000000d
[147098.205192] FS:  00007fd0d7fff6c0(0000) GS:ffff95f47ea80000(0000)
knlGS:0000000000000000
[147098.205193] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[147098.205194] CR2: 00007fc5390d8980 CR3: 000000010e2f2000 CR4:
0000000000750ee0
[147098.205196] PKRU: 55555554
[147098.205197] Call Trace:
[147098.205198]  <IRQ>
[147098.205202]  ? watchdog_timer_fn+0x1b8/0x220
[147098.205205]  ? __pfx_watchdog_timer_fn+0x10/0x10
[147098.205207]  ? __hrtimer_run_queues+0x112/0x2b0
[147098.205211]  ? hrtimer_interrupt+0xf8/0x230
[147098.205214]  ? __sysvec_apic_timer_interrupt+0x61/0x130
[147098.205217]  ? sysvec_apic_timer_interrupt+0x6d/0x90
[147098.205220]  </IRQ>
[147098.205220]  <TASK>
[147098.205221]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
[147098.205227]  ? xas_find+0xb3/0x1c0
[147098.205230]  find_lock_entries+0x84/0x270
[147098.205235]  truncate_inode_pages_range+0xd7/0x400
[147098.205243]  evict+0x1b0/0x1d0
[147098.205248]  do_unlinkat+0x177/0x320
[147098.205252]  __x64_sys_unlink+0x42/0x70
[147098.205255]  do_syscall_64+0x60/0x90
[147098.205258]  ? srso_alias_return_thunk+0x5/0x7f
[147098.205261]  ? ksys_write+0xd8/0xf0
[147098.205264]  ? srso_alias_return_thunk+0x5/0x7f
[147098.205266]  ? syscall_exit_to_user_mode+0x2b/0x40
[147098.205268]  ? srso_alias_return_thunk+0x5/0x7f
[147098.205270]  ? do_syscall_64+0x6c/0x90
[147098.205272]  ? srso_alias_return_thunk+0x5/0x7f
[147098.205274]  ? irqtime_account_irq+0x40/0xc0
[147098.205276]  ? srso_alias_return_thunk+0x5/0x7f
[147098.205278]  ? __irq_exit_rcu+0x4b/0xc0
[147098.205282]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[147098.205284] RIP: 0033:0x7ffb38324aab
[147098.205302] Code: f0 ff ff 73 01 c3 48 8b 0d 5a 13 0d 00 f7 d8 64 89 01=
 48
83 c8 ff c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 57 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 29 13 0d 00 f7 d8
[147098.205304] RSP: 002b:00007fd0d7ffb8e8 EFLAGS: 00000246 ORIG_RAX:
0000000000000057
[147098.205306] RAX: ffffffffffffffda RBX: 000000000000003f RCX:
00007ffb38324aab
[147098.205307] RDX: 000000000000003f RSI: 00007fd0d7ffb8f0 RDI:
00007fd0d7ffb8f0
[147098.205308] RBP: 00007fd0d7ffca40 R08: 0000000000000000 R09:
0000000000000030
[147098.205309] R10: fefefefefefefeff R11: 0000000000000246 R12:
00005642797b0f00
[147098.205310] R13: 00007fd0d7ffc3e0 R14: 000000000000084c R15:
0000000000000000
[147098.205313]  </TASK>
[165201.884167] md: data-check of RAID array md126
[165207.917051] md: delaying data-check of md127 until md126 has finished (=
they
share one or more physical units)
[166552.662760] md: md126: data-check done.
[166552.664316] md: data-check of RAID array md127
[166562.948199] md: md127: data-check done.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
