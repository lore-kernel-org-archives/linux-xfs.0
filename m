Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED6CC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 30 May 2022 07:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiE3HTe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 May 2022 03:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiE3HT1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 May 2022 03:19:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E516B6FD03
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 00:19:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 904D7B8094C
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 07:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E336C3411E
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 07:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653895159;
        bh=0JM1kxWDld59XP0IdYXUADqI6hOd7PmdK7p4ct5UAAQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jl3ivpPvm2zCGKAeHq+6jo2HFm/wy2h96w4IzMzLEQhXTPGdFTihcxmWHLBJ0Jj25
         6mF2I2zmk5EX0enLDQ2OzeTq8CtFFDpn4dojgF5gI2lkiXjcYTWPBwGViJCbGy1Ecg
         Au/8k501EC7lqngIHvA//Z4s+GLrlVMUJVC5iIuH50jY3wDtgEd7OUWJ82KX8Rx5//
         IoIz2u8g6S/2BoCjrw+qsL+U8OM9mpGncbYvrGqLaCLVenAwXOxdSUJbVPUDiJNeDj
         vuOKZOdP2QOuJM7T0P6j0tcvkUfdI+tbZLtcZ+wtXn8w+ZT5MfSknOXzzw+fSfN6wL
         NMQ2Gp6KbaqTA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0A05DCC13AD; Mon, 30 May 2022 07:19:19 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216047] [generic/623 DAX with XFS] kernel BUG at
 mm/page_table_check.c:51!
Date:   Mon, 30 May 2022 07:19:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216047-201763-oScwqvYUUE@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216047-201763@https.bugzilla.kernel.org/>
References: <bug-216047-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216047

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
I just tried the lastest mainline upstream linux, it's 100% reproducible for
me. And it's not only reproducible on xfs, ext4 with DAX can reproduce it
too[1]. So it might be a common bug from mm?

[1]
[  291.434410] run fstests generic/623 at 2022-05-30 15:14:32
[  291.768382] systemd[1]: Started fstests-generic-623.scope - /usr/bin/bas=
h -c
test -w /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; ex=
ec
./tests/generic/623.
[  294.406254] EXT4-fs (pmem0p2): mounted filesystem with ordered data mode.
Quota mode: none.
[  294.442928] EXT4-fs (pmem0p2): shut down requested (1)
[  294.443089] Aborting journal on device pmem0p2-8.
[  294.477893] EXT4-fs (pmem0p2): unmounting filesystem.
[  294.479943] systemd[1]: mnt-scratch.mount: Deactivated successfully.
[  294.960374] EXT4-fs (pmem0p2): mounted filesystem with ordered data mode.
Quota mode: none.
[  295.043716] ------------[ cut here ]------------
[  295.043722] kernel BUG at mm/page_table_check.c:51!
[  295.043736] invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
[  295.112220] CPU: 23 PID: 1936 Comm: xfs_io Tainted: G S        I=20=20=
=20=20=20=20
5.18.0-mainline+ #2
[  295.149570] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 08/02/2014
[  295.180088] RIP: 0010:page_table_check_set.part.0+0x184/0x300
[  295.208336] Code: 48 8b 04 24 80 38 00 0f 85 2b 01 00 00 48 83 c3 01 4c =
03
3d 5e e9 5a 03 4c 39 eb 0f 84 05 01 00 00 4d 85 ff 0f 85 53 ff ff ff <0f> 0=
b f7
c3 ff 0f 00 00 0f 85 f5 fe ff ff=20
be 08 00 00 00 48 89 df
[  295.293142] RSP: 0000:ffffc9000d50f708 EFLAGS: 00010246
[  295.316834] RAX: dffffc0000000000 RBX: ffffea00092180c0 RCX:
ffffffff85a98a25
[  295.349059] RDX: 1ffffd400124301b RSI: 0000000000000001 RDI:
ffffea00092180d8
[  295.381191] RBP: ffffea00092180c0 R08: 0000000000000000 R09:
ffff88801bfa7607
[  295.413394] R10: ffffed10037f4ec0 R11: 0000000000000005 R12:
0000000000000000
[  295.445718] R13: 0000000000000001 R14: ffff88801bfa7600 R15:
0000000000000000
[  295.477844] FS:  00007f590a83f740(0000) GS:ffff888085000000(0000)
knlGS:0000000000000000
[  295.518073] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  295.547270] CR2: 00007f590aac1000 CR3: 0000000049404003 CR4:
00000000001706e0
[  295.581391] Call Trace:
[  295.602075]  __page_table_check_pte_set+0x28f/0x350
[  295.624144]  ? __page_table_check_pte_clear+0x2b0/0x2b0
[  295.647669]  ? percpu_ref_put_many.constprop.0+0x1a0/0x1a0
[  295.672391]  ? __get_locked_pte+0x1b8/0x2e0
[  295.691432]  insert_pfn+0x22d/0x340
[  295.707093]  ? vm_map_pages_zero+0x10/0x10
[  295.725738]  ? pfn_modify_allowed+0x64/0x2b0
[  295.745392]  ? track_pfn_remap+0x1d0/0x1d0
[  295.764201]  __vm_insert_mixed+0x17f/0x1e0
[  295.782965]  ? vmf_insert_pfn+0x60/0x60
[  295.800382]  ? __dax_invalidate_entry+0x1c0/0x1c0
[  295.822137]  ? dax_direct_access+0x111/0x1b0
[  295.841356]  dax_fault_iter+0x100f/0x1bf0
[  295.859436]  ? grab_mapping_entry+0x4e0/0x4e0
[  295.879076]  ? iomap_iter+0xa02/0x10a0
[  295.895964]  dax_iomap_pte_fault+0x3f4/0xb80
[  295.915252]  ? dax_writeback_mapping_range+0xeb0/0xeb0
[  295.938698]  ? __ext4_journal_start_sb+0x345/0x460
[  295.960264]  ext4_dax_huge_fault+0x44f/0x940
[  295.979436]  ? ext4_file_open+0xa50/0xa50
[  295.998477]  ? var_wake_function+0x260/0x260
[  296.020138]  __do_fault+0xf8/0x4e0
[  296.037077]  do_fault+0x778/0xee0
[  296.053492]  ? restore_exclusive_pte+0x5d0/0x5d0
[  296.076166]  __handle_mm_fault+0xf82/0x26d0
[  296.095032]  ? vm_iomap_memory+0x140/0x140
[  296.113504]  ? count_memcg_events.constprop.0+0x40/0x50
[  296.137317]  handle_mm_fault+0x20e/0x750
[  296.154958]  do_user_addr_fault+0x345/0xd70
[  296.173803]  ? rcu_read_lock_sched_held+0x3c/0x70
[  296.194972]  exc_page_fault+0x65/0x100
[  296.213635]  asm_exc_page_fault+0x27/0x30
[  296.232854] RIP: 0033:0x55d4406da88e
[  296.249860] Code: c0 0f 84 e1 00 00 00 48 8b 05 8e c2 02 00 48 2b 58 10 =
49
8d 14 1c 45 85 f6 75 55 4d 85 e4 0f 8e c7 fe ff ff 48 8b 00 44 89 ee <44> 8=
8 2c
18 48 8d 43 01 49 83 fc 01 0f 8e=20
af fe ff ff 48 8b 0d 59
[  296.334980] RSP: 002b:00007fff29d58370 EFLAGS: 00010206
[  296.358575] RAX: 00007f590aac1000 RBX: 0000000000000000 RCX:
0000000000001000
[  296.390927] RDX: 0000000000001000 RSI: 0000000000000058 RDI:
0000000000000000
[  296.423124] RBP: 000055d441b093e0 R08: 1999999999999999 R09:
0000000000000000
[  296.455428] R10: 00007f590a9ebac0 R11: 00007f590a9ec3c0 R12:
0000000000001000
[  296.489563] R13: 0000000000000058 R14: 0000000000000000 R15:
0000000000000200
[  296.524615]  </TASK>
[  296.535495] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6
nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
nft_chain_nat nf_nat nf_conntrack nf_defrag_ip
v6 iTCO_wdt intel_rapl_msr intel_pmc_bxt nf_defrag_ipv4 iTCO_vendor_support
intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp ip_set core=
temp
kvm_intel kvm irqbypass nf_tables rfkill rapl intel_cstate nfnetlink qrtr
intel_uncore dax_pmem pcspkr sunrpc lpc_ich hpilo pktcdvd ipmi_ssif acpi_ip=
mi
tg3 ioatdma ipmi_si acpi_power_meter dca fuse zram xfs nd_pmem nd_btt crct
10dif_pclmul crc32_pclmul nd_e820 crc32c_intel libnvdimm ghash_clmulni_intel
hpsa serio_raw mgag200 hpwdt scsi_transport_sas ata_generic pata_acpi
scsi_dh_rdac scsi_dh_emc scsi_dh_alua dm_mul
tipath ipmi_devintf ipmi_msghandler
[  296.859756] ---[ end trace 0000000000000000 ]---
[  296.897217] RIP: 0010:page_table_check_set.part.0+0x184/0x300
[  296.897228] Code: 48 8b 04 24 80 38 00 0f 85 2b 01 00 00 48 83 c3 01 4c =
03
3d 5e e9 5a 03 4c 39 eb 0f 84 05 01 00 00 4d 85 ff 0f 85 53 ff ff ff <0f> 0=
b f7
c3 ff 0f 00 00 0f 85 f5 fe ff ff=20
be 08 00 00 00 48 89 df
[  296.897233] RSP: 0000:ffffc9000d50f708 EFLAGS: 00010246
[  296.897238] RAX: dffffc0000000000 RBX: ffffea00092180c0 RCX:
ffffffff85a98a25
[  296.897241] RDX: 1ffffd400124301b RSI: 0000000000000001 RDI:
ffffea00092180d8
[  296.897244] RBP: ffffea00092180c0 R08: 0000000000000000 R09:
ffff88801bfa7607
[  296.897247] R10: ffffed10037f4ec0 R11: 0000000000000005 R12:
0000000000000000
[  296.897249] R13: 0000000000000001 R14: ffff88801bfa7600 R15:
0000000000000000
[  296.897253] FS:  00007f590a83f740(0000) GS:ffff888085000000(0000)
knlGS:0000000000000000
[  296.897256] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  296.897260] CR2: 00007f590aac1000 CR3: 0000000049404003 CR4:
00000000001706e0
[  296.897264] note: xfs_io[1936] exited with preempt_count 1

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
