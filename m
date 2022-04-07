Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56747C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 02:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238490AbiDGCUY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 22:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238208AbiDGCUU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 22:20:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7074D55BED
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 19:18:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9C00B825B2
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 02:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E573C385AB
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 02:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649297899;
        bh=/cGRJ2Zt6yozJcfQjs+3O70+t/BEO9M0M/uiDMHdaQA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cp00NoaTFdd55tS7ZwyWFIHvB2gtjhy12lzuHwwjMzviHaxSs8Hl2BBb1DUdwVcYA
         6/jyhZ6eL/i5/QBWUz1DEY4nrpf9a3YQxOmxkZRCqs8as42nmCLbAarnymYAoS8Z+/
         Op/3gNUXbIZwSRmFp6XFz60TcY+iNXoqS78Ba2QrAljvuU57sTb6+nnggKX5WuLSb0
         seXCcvEoRLUvjKsU1HH8eoMSy2I3Hf3DppytaGQlWN/SWZbhgqo5xNxDVnOJDN9rwQ
         TdCCz1L7A2dgCFH5lIrYPfEfK/WmG9MqrYLgjf8R9Xz/X1aPADFOybw4t2ZVRbV+51
         gGl0ZxduqiZcA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 68BFCC05FCE; Thu,  7 Apr 2022 02:18:19 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215804] [xfstests generic/670] Unable to handle kernel paging
 request at virtual address fffffbffff000008
Date:   Thu, 07 Apr 2022 02:18:18 +0000
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
Message-ID: <bug-215804-201763-9PWNuogprJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215804-201763@https.bugzilla.kernel.org/>
References: <bug-215804-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215804

--- Comment #10 from Zorro Lang (zlang@redhat.com) ---
(In reply to Matthew Wilcox from comment #9)
> Created attachment 300704 [details]
> Proposed fix
>=20
> Please test on arm64; generic/670 passes on x86-64 with this patch, but t=
hen
> it passed before.

Hi Matthew,

The reproducer (of this bug) test passed on aarch64 with this patch. But I =
just
hit another panic on x86_64 as below[1], by doing regression test(run trini=
ty).

As it's not reproducible 100%, so I'm trying to reproduce it without your
patch. If you think it's another issue, not a regression from your patch, I=
'll
report another bug to track it.

Thanks,
Zorro

[1]
[  361.335242] futex_wake_op: trinity-c9 tries to shift op by -354; fix this
program=20
[  367.675001] futex_wake_op: trinity-c19 tries to shift op by -608; fix th=
is
program=20
[  383.028587] page:00000000b6110ce7 refcount:6 mapcount:0
mapping:00000000fd87c1f3 index:0x174 pfn:0x8d6c00=20
[  383.039316] head:00000000b6110ce7 order:9 compound_mapcount:0
compound_pincount:0=20
[  383.047703] aops:xfs_address_space_operations [xfs] ino:a6 dentry
name:"trinity-testfile2"=20
[  383.057131] flags:
0x57ffffc0012005(locked|uptodate|private|head|node=3D1|zone=3D2|lastcpupid=
=3D0x1fffff)=20
[  383.067258] raw: 0057ffffc0012005 0000000000000000 dead000000000122
ffff888136653410=20
[  383.075925] raw: 0000000000000174 ffff88810bee5900 00000006ffffffff
0000000000000000=20
[  383.084589] page dumped because: VM_BUG_ON_FOLIO(folio_nr_pages(old) !=3D
nr_pages)=20
[  383.092987] ------------[ cut here ]------------=20
[  383.098154] kernel BUG at mm/memcontrol.c:6857!=20
[  383.103235] invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI=20
[  383.109456] CPU: 16 PID: 22651 Comm: trinity-c14 Kdump: loaded Not taint=
ed
5.18.0-rc1+ #1=20
[  383.118586] Hardware name: Dell Inc. PowerEdge R430/0CN7X8, BIOS 2.8.0
05/23/2018=20
[  383.126938] RIP: 0010:mem_cgroup_migrate+0x21f/0x300=20
[  383.132483] Code: 48 89 ef e8 73 78 e7 ff 0f 0b 48 c7 c6 20 0a d8 94 48 =
89
ef e8 62 78 e7 ff 0f 0b 48 c7 c6 80 0a d8 94 48 89 ef e8 51 78 e7 ff <0f> 0=
b e8
9a 2b ba ff 89 de 4c 89 ef e8 c0 3c ff ff 48 89 ea 48 b8=20
[  383.153442] RSP: 0018:ffffc90023f1f6f8 EFLAGS: 00010282=20
[  383.159275] RAX: 0000000000000045 RBX: 0000000000000200 RCX:
0000000000000000=20
[  383.167239] RDX: 0000000000000001 RSI: ffffffff94ea1540 RDI:
fffff520047e3ecf=20
[  383.175202] RBP: ffffea00235b0000 R08: 0000000000000045 R09:
ffff8888091fda47=20
[  383.183165] R10: ffffed110123fb48 R11: 0000000000000001 R12:
ffffea0005f59b00=20
[  383.191130] R13: 0000000000000000 R14: ffffea00235b0034 R15:
ffff88810bee5900=20
[  383.199094] FS:  00007fda9afb2740(0000) GS:ffff888809000000(0000)
knlGS:0000000000000000=20
[  383.208123] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[  383.214535] CR2: 00007fda9a36c07c CR3: 0000000182c78001 CR4:
00000000003706e0=20
[  383.222498] DR0: 00007fda9aecd000 DR1: 00007fda9aece000 DR2:
0000000000000000=20
[  383.230461] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
00000000000f0602=20
[  383.238424] Call Trace:=20
[  383.241151]  <TASK>=20
[  383.243490]  iomap_migrate_page+0xdc/0x490=20
[  383.248068]  move_to_new_page+0x1fa/0xdf0=20
[  383.252545]  ? remove_migration_ptes+0xf0/0xf0=20
[  383.257497]  ? try_to_migrate+0x13d/0x260=20
[  383.261975]  ? try_to_unmap+0x150/0x150=20
[  383.266248]  ? try_to_unmap_one+0x1cd0/0x1cd0=20
[  383.271110]  ? anon_vma_ctor+0xe0/0xe0=20
[  383.275294]  ? page_get_anon_vma+0x240/0x240=20
[  383.280064]  __unmap_and_move+0xc38/0x1090=20
[  383.284638]  ? unmap_and_move_huge_page+0x1210/0x1210=20
[  383.290278]  ? __lock_release+0x4bd/0x9f0=20
[  383.294759]  ? alloc_migration_target+0x267/0x8d0=20
[  383.300015]  unmap_and_move+0xd6/0xe50=20
[  383.304209]  ? migrate_page+0x250/0x250=20
[  383.308496]  migrate_pages+0x6c5/0x12a0=20
[  383.312778]  ? migrate_page+0x250/0x250=20
[  383.317063]  ? buffer_migrate_page_norefs+0x10/0x10=20
[  383.322510]  ? sched_clock_cpu+0x15/0x1b0=20
[  383.326991]  move_pages_and_store_status.isra.0+0xe9/0x1b0=20
[  383.333117]  ? migrate_pages+0x12a0/0x12a0=20
[  383.337692]  ? __might_fault+0xb8/0x160=20
[  383.341979]  do_pages_move+0x343/0x450=20
[  383.346166]  ? move_pages_and_store_status.isra.0+0x1b0/0x1b0=20
[  383.352587]  ? find_mm_struct+0x353/0x5c0=20
[  383.357065]  kernel_move_pages+0x13c/0x1e0=20
[  383.361641]  ? do_pages_move+0x450/0x450=20
[  383.366024]  ? ktime_get_coarse_real_ts64+0x128/0x160=20
[  383.371666]  ? lockdep_hardirqs_on+0x79/0x100=20
[  383.376530]  ? ktime_get_coarse_real_ts64+0x128/0x160=20
[  383.382176]  __x64_sys_move_pages+0xdc/0x1b0=20
[  383.386951]  ? syscall_trace_enter.constprop.0+0x179/0x250=20
[  383.393081]  do_syscall_64+0x3b/0x90=20
[  383.397064]  entry_SYSCALL_64_after_hwframe+0x44/0xae=20
[  383.402706] RIP: 0033:0x7fda9ac43dfd=20
[  383.406698] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89
f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d fb 5f 1b 00 f7 d8 64 89 01 48=20
[  383.427647] RSP: 002b:00007ffde3a9cb48 EFLAGS: 00000246 ORIG_RAX:
0000000000000117=20
[  383.436092] RAX: ffffffffffffffda RBX: 0000000000000002 RCX:
00007fda9ac43dfd=20
[  383.444057] RDX: 00000000022b0760 RSI: 0000000000000038 RDI:
0000000000000000=20
[  383.452020] RBP: 00007fda9af49000 R08: 00000000022ac6f0 R09:
0000000000000000=20
[  383.459983] R10: 00000000022ac600 R11: 0000000000000246 R12:
0000000000000117=20
[  383.467946] R13: 00007fda9afb26c0 R14: 00007fda9af49058 R15:
00007fda9af49000=20
[  383.475917]  </TASK>=20
[  383.478355] Modules linked in: 8021q garp mrp bridge stp llc vsock_loopb=
ack
vmw_vsock_virtio_transport_common ieee802154_socket ieee802154
vmw_vsock_vmci_transport vsock vmw_vmci mpls_router ip_tunnel af_key qrtr h=
idp
bnep rfcomm bluetooth can_bcm can_raw can pptp gre l2tp_ppp l2tp_netlink
l2tp_core pppoe pppox ppp_generic slhc crypto_user ib_core nfnetlink
scsi_transport_iscsi atm sctp ip6_udp_tunnel udp_tunnel tls iTCO_wdt
iTCO_vendor_support intel_rapl_msr dell_wmi_descriptor video dcdbas
intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common sb_e=
dac
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm mgag200
i2c_algo_bit drm_shmem_helper drm_kms_helper irqbypass rapl intel_cstate
intel_uncore syscopyarea rfkill sysfillrect mei_me sysimgblt joydev fb_sys_=
fops
pcspkr ipmi_ssif mxm_wmi mei lpc_ich ipmi_si ipmi_devintf ipmi_msghandler
acpi_power_meter sunrpc drm fuse xfs libcrc32c sd_mod t10_pi
crc64_rocksoft_generic crc64_rocksoft crc64 sg crct10dif_pclmul=20
[  383.478527]  crc32_pclmul crc32c_intel ahci ghash_clmulni_intel libahci
libata tg3 megaraid_sas wmi=20
[  383.585790] ---[ end trace 0000000000000000 ]---=20
[  383.611622] RIP: 0010:mem_cgroup_migrate+0x21f/0x300=20
[  383.617187] Code: 48 89 ef e8 73 78 e7 ff 0f 0b 48 c7 c6 20 0a d8 94 48 =
89
ef e8 62 78 e7 ff 0f 0b 48 c7 c6 80 0a d8 94 48 89 ef e8 51 78 e7 ff <0f> 0=
b e8
9a 2b ba ff 89 de 4c 89 ef e8 c0 3c ff ff 48 89 ea 48 b8=20
[  383.638159] RSP: 0018:ffffc90023f1f6f8 EFLAGS: 00010282=20
[  383.644005] RAX: 0000000000000045 RBX: 0000000000000200 RCX:
0000000000000000=20
[  383.651983] RDX: 0000000000000001 RSI: ffffffff94ea1540 RDI:
fffff520047e3ecf=20
[  383.659955] RBP: ffffea00235b0000 R08: 0000000000000045 R09:
ffff8888091fda47=20
[  383.667927] R10: ffffed110123fb48 R11: 0000000000000001 R12:
ffffea0005f59b00=20
[  383.675901] R13: 0000000000000000 R14: ffffea00235b0034 R15:
ffff88810bee5900=20
[  383.683875] FS:  00007fda9afb2740(0000) GS:ffff888809000000(0000)
knlGS:0000000000000000=20
[  383.692917] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[  383.699331] CR2: 00007fda9a36c07c CR3: 0000000182c78001 CR4:
00000000003706e0=20
[  383.707303] DR0: 00007fda9aecd000 DR1: 00007fda9aece000 DR2:
0000000000000000=20
[  383.715281] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
00000000000f0602=20
[  385.747373] trinity-main (14692) used greatest stack depth: 20912 bytes =
left

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
