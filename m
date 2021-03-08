Return-Path: <SRS0=7MVS=IG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E62C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 07:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16D3064EEF
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 07:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbhCHHcB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 02:32:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231990AbhCHHbk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 02:31:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A366D65163
        for <linux-xfs@vger.kernel.org>; Mon,  8 Mar 2021 07:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615188699;
        bh=kLWkFD2VfzPAQZ76SKGIf/sO9yJE5TGoybJtlNfbYyk=;
        h=From:To:Subject:Date:From;
        b=VQUjrH4UUzAQdUx8wyxlY0aFxZFhXtNZEaLYGuyU5u7ukElKBA2dtEdlkCr4olXL2
         UjbMhtmq0t1PaWHhwdSVPSdHDVrSQGCPRNZkBRl2WTzXDMW92rcis2X4qSps4CvcV9
         8at0C+zxbtCWRvqLAjMzIsPPVlNeUrt33ZcnmnMiVNfncwqZ2Jvd8FK7c8wq2Wf2BD
         bRBrrJttNDW2ro+/yLlml3ilsVgv5/6ZLjbKs5gkgfLvaJclRl9H2ahpMsXWFdrkoF
         85tKD1QWbvnhW5vxbrHp5m//dqeA8suqpdBqsIwgVvBLfyQ57inb3eCcbCRlW7j6MS
         yHWoY4LVAgwpQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 212123] New: kernel BUG at mm/filemap.c:1499, invalid opcode:
 0000
Date:   Mon, 08 Mar 2021 07:31:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tm@dev-zero.ch
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-212123-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212123

            Bug ID: 212123
           Summary: kernel BUG at mm/filemap.c:1499, invalid opcode: 0000
           Product: File System
           Version: 2.5
    Kernel Version: 5.11.1-2.g39e04be
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: tm@dev-zero.ch
        Regression: No

Unfortunately I didn't have the chance yet to test this with something else
than XFS, but we see this across several hosts with different Intel SSDs (S=
ATA
and NVMe, gets triggered faster on NVMe) and AMD CPUs, different mount opti=
ons
(discard or periodic trim) and at least since Kernel 5.7.

This makes the corresponding user space process hang and finally a hard res=
et
of the machine is needed. What seems to trigger the issue more rapidly (bes=
ides
a faster drive) is the fill state (usually >90%) of the filesystem and/or t=
he
load on the machine (those are HPC-esque nodes).

The following stacktrace also contains an error "Bad page state in process",
this is not always the case.

2021-02-26T11:49:29.803049+01:00 tcopt11 kernel: [156009.300579] ----------=
--[
cut here ]------------
2021-02-26T11:49:29.803063+01:00 tcopt11 kernel: [156009.300584] kernel BUG=
 at
mm/filemap.c:1499!
2021-02-26T11:49:29.803065+01:00 tcopt11 kernel: [156009.300591] invalid
opcode: 0000 [#1] SMP NOPTI
2021-02-26T11:49:29.803066+01:00 tcopt11 kernel: [156009.305213] CPU: 51 PI=
D:
832 Comm: kworker/51:1 Not tainted 5.11.1-2.g39e04be-default #1 openSUSE
Tumbleweed (unreleased)
2021-02-26T11:49:29.803067+01:00 tcopt11 kernel: [156009.316246] Hardware n=
ame:
GIGABYTE R181-Z91-00/MZ91-FS0-00, BIOS F23a 08/14/2020
2021-02-26T11:49:29.803069+01:00 tcopt11 kernel: [156009.323812] Workqueue:
xfs-conv/nvme0n1p1 xfs_end_io [xfs]
2021-02-26T11:49:29.803069+01:00 tcopt11 kernel: [156009.329486] RIP:
0010:end_page_writeback+0xbb/0xc0
2021-02-26T11:49:29.803070+01:00 tcopt11 kernel: [156009.334365] Code: 34 8=
3 e0
07 83 f8 04 75 e8 48 8b 45 08 8b 40 68 83 e8 01 83 f8 01 77 d9 48 89 ef 5d =
e9
fe e4 00 00 48 89 ef 5d e9 45 e4 00 00 <0f> 0b 0f 1f 00 0f 1f 44 00 00 41 5=
4 55
48 89 fd 53 89 d3 40 84 f6
2021-02-26T11:49:29.803071+01:00 tcopt11 kernel: [156009.353203] RSP:
0018:ffffbf67cf38fd80 EFLAGS: 00010246
2021-02-26T11:49:29.803073+01:00 tcopt11 kernel: [156009.358519] RAX:
0000000000000000 RBX: 000000000000001d RCX: 0000000000000005
2021-02-26T11:49:29.803074+01:00 tcopt11 kernel: [156009.365739] RDX:
0000000000000000 RSI: ffff9b3893433130 RDI: 0000000000000000
2021-02-26T11:49:29.803074+01:00 tcopt11 kernel: [156009.372959] RBP:
fffff9a5643ea1c0 R08: 0000000000006000 R09: 0000000000000001
2021-02-26T11:49:29.803075+01:00 tcopt11 kernel: [156009.380177] R10:
ffff9b3e2ff6a000 R11: 0000000000000020 R12: 0000000000000000
2021-02-26T11:49:29.803095+01:00 tcopt11 kernel: [156009.387398] R13:
0000000000008000 R14: ffff9b0f0294b240 R15: fffff9a5643ea1c0
2021-02-26T11:49:29.803096+01:00 tcopt11 kernel: [156009.394617] FS:=20
0000000000000000(0000) GS:ffff9b160f040000(0000) knlGS:0000000000000000
2021-02-26T11:49:29.803098+01:00 tcopt11 kernel: [156009.402789] CS:  0010 =
DS:
0000 ES: 0000 CR0: 0000000080050033
2021-02-26T11:49:29.803099+01:00 tcopt11 kernel: [156009.408622] CR2:
0000558ea6c00870 CR3: 000000183b5b6000 CR4: 00000000003506e0
2021-02-26T11:49:29.803099+01:00 tcopt11 kernel: [156009.415841] Call Trace:
2021-02-26T11:49:29.803100+01:00 tcopt11 kernel: [156009.418383]=20
iomap_finish_ioend+0x127/0x250
2021-02-26T11:49:29.803101+01:00 tcopt11 kernel: [156009.422654]=20
iomap_finish_ioends+0x41/0x90
2021-02-26T11:49:29.803101+01:00 tcopt11 kernel: [156009.426842]=20
xfs_end_ioend+0x6d/0x110 [xfs]
2021-02-26T11:49:29.803102+01:00 tcopt11 kernel: [156009.431193]=20
xfs_end_io+0xac/0xe0 [xfs]
2021-02-26T11:49:29.803103+01:00 tcopt11 kernel: [156009.435195]=20
process_one_work+0x1df/0x370
2021-02-26T11:49:29.803104+01:00 tcopt11 kernel: [156009.439293]=20
worker_thread+0x50/0x400
2021-02-26T11:49:29.803105+01:00 tcopt11 kernel: [156009.443047]  ?
process_one_work+0x370/0x370
2021-02-26T11:49:29.803106+01:00 tcopt11 kernel: [156009.447320]=20
kthread+0x11b/0x140
2021-02-26T11:49:29.803107+01:00 tcopt11 kernel: [156009.450638]  ?
__kthread_bind_mask+0x60/0x60
2021-02-26T11:49:29.803107+01:00 tcopt11 kernel: [156009.454999]=20
ret_from_fork+0x22/0x30
2021-02-26T11:49:29.803108+01:00 tcopt11 kernel: [156009.458665] Modules li=
nked
in: joydev st sr_mod cdrom rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver n=
fs
lockd grace sunrpc nfs_ssc fscache fuse af_packet xt_tcpudp ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip_set
nfnetlink ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_=
raw
ip6table_security iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_=
ipv4
iptable_mangle iptable_raw iptable_security ebtable_filter ebtables iscsi_i=
bft
iscsi_boot_sysfs ip6table_filter ip6_tables rfkill iptable_filter ip_tables
x_tables bpfilter dmi_sysfs msr ipmi_ssif i40iw ib_uverbs intel_rapl_msr
ib_core intel_rapl_common amd64_edac_mod edac_mce_amd xfs nls_iso8859_1
nls_cp437 kvm_amd vfat fat kvm nvme irqbypass acpi_ipmi crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel aesni_intel igb ipmi_si crypto_simd sp5100=
_tco
cryptd glue_helper i40e pcspkr efi_pstore nvme_core ipmi_devintf k10temp
i2c_piix4 dca ccp ipmi_msghandler tiny_power_button button
2021-02-26T11:49:29.803109+01:00 tcopt11 kernel: [156009.458745]  acpi_cpuf=
req
btrfs blake2b_generic libcrc32c xor ast i2c_algo_bit drm_vram_helper raid6_=
pq
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec rc_core
drm_ttm_helper xhci_pci ttm xhci_pci_renesas crc32c_intel xhci_hcd drm usbc=
ore
sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua efivarfs
2021-02-26T11:49:29.803116+01:00 tcopt11 kernel: [156009.574325] ---[ end t=
race
bd7bd5d623d48cd8 ]---
2021-02-26T11:49:29.944226+01:00 tcopt11 kernel: [156009.710597] RIP:
0010:end_page_writeback+0xbb/0xc0
2021-02-26T11:49:29.944229+01:00 tcopt11 kernel: [156009.710604] Code: 34 8=
3 e0
07 83 f8 04 75 e8 48 8b 45 08 8b 40 68 83 e8 01 83 f8 01 77 d9 48 89 ef 5d =
e9
fe e4 00 00 48 89 ef 5d e9 45 e4 00 00 <0f> 0b 0f 1f 00 0f 1f 44 00 00 41 5=
4 55
48 89 fd 53 89 d3 40 84 f6
2021-02-26T11:49:29.968386+01:00 tcopt11 kernel: [156009.734336] RSP:
0018:ffffbf67cf38fd80 EFLAGS: 00010246
2021-02-26T11:49:29.968388+01:00 tcopt11 kernel: [156009.734340] RAX:
0000000000000000 RBX: 000000000000001d RCX: 0000000000000005
2021-02-26T11:49:29.982842+01:00 tcopt11 kernel: [156009.746884] RDX:
0000000000000000 RSI: ffff9b3893433130 RDI: 0000000000000000
2021-02-26T11:49:29.982845+01:00 tcopt11 kernel: [156009.746888] RBP:
fffff9a5643ea1c0 R08: 0000000000006000 R09: 0000000000000001
2021-02-26T11:49:29.982846+01:00 tcopt11 kernel: [156009.746890] R10:
ffff9b3e2ff6a000 R11: 0000000000000020 R12: 0000000000000000
2021-02-26T11:49:30.004527+01:00 tcopt11 kernel: [156009.768566] R13:
0000000000008000 R14: ffff9b0f0294b240 R15: fffff9a5643ea1c0
2021-02-26T11:49:30.004528+01:00 tcopt11 kernel: [156009.768569] FS:=20
0000000000000000(0000) GS:ffff9b160f040000(0000) knlGS:0000000000000000
2021-02-26T11:49:30.013210+01:00 tcopt11 kernel: [156009.783977] CS:  0010 =
DS:
0000 ES: 0000 CR0: 0000000080050033
2021-02-26T11:49:30.013212+01:00 tcopt11 kernel: [156009.783980] CR2:
0000558ea6c00870 CR3: 000000183b5b6000 CR4: 00000000003506e0
2021-02-26T11:49:32.035969+01:00 tcopt11 kernel: [156011.521366] BUG: Bad p=
age
state in process cp2k.ssmp  pfn:290fa87
2021-02-26T11:49:32.035989+01:00 tcopt11 kernel: [156011.527556]
page:000000000121bb86 refcount:1 mapcount:0 mapping:0000000000000000 index:=
0x1
pfn:0x290fa87
2021-02-26T11:49:32.035991+01:00 tcopt11 kernel: [156011.537118] flags:
0x2affff800000000()
2021-02-26T11:49:32.035992+01:00 tcopt11 kernel: [156011.540959] raw:
02affff800000000 dead000000000100 dead000000000122 0000000000000000
2021-02-26T11:49:32.035993+01:00 tcopt11 kernel: [156011.548785] raw:
0000000000000001 0000000000000000 00000001ffffffff 0000000000000000
2021-02-26T11:49:32.035995+01:00 tcopt11 kernel: [156011.556610] page dumped
because: nonzero _refcount
2021-02-26T11:49:32.035996+01:00 tcopt11 kernel: [156011.561488] Modules li=
nked
in: joydev st sr_mod cdrom rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver n=
fs
lockd grace sunrpc nfs_ssc fscache fuse af_packet xt_tcpudp ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip_set
nfnetlink ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_=
raw
ip6table_security iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_=
ipv4
iptable_mangle iptable_raw iptable_security ebtable_filter ebtables iscsi_i=
bft
iscsi_boot_sysfs ip6table_filter ip6_tables rfkill iptable_filter ip_tables
x_tables bpfilter dmi_sysfs msr ipmi_ssif i40iw ib_uverbs intel_rapl_msr
ib_core intel_rapl_common amd64_edac_mod edac_mce_amd xfs nls_iso8859_1
nls_cp437 kvm_amd vfat fat kvm nvme irqbypass acpi_ipmi crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel aesni_intel igb ipmi_si crypto_simd sp5100=
_tco
cryptd glue_helper i40e pcspkr efi_pstore nvme_core ipmi_devintf k10temp
i2c_piix4 dca ccp ipmi_msghandler tiny_power_button button
2021-02-26T11:49:32.036009+01:00 tcopt11 kernel: [156011.561566]  acpi_cpuf=
req
btrfs blake2b_generic libcrc32c xor ast i2c_algo_bit drm_vram_helper raid6_=
pq
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec rc_core
drm_ttm_helper xhci_pci ttm xhci_pci_renesas crc32c_intel xhci_hcd drm usbc=
ore
sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua efivarfs
2021-02-26T11:49:32.036013+01:00 tcopt11 kernel: [156011.677099] CPU: 56 PI=
D:
89417 Comm: cp2k.ssmp Tainted: G      D           5.11.1-2.g39e04be-default=
 #1
openSUSE Tumbleweed (unreleased)
2021-02-26T11:49:32.036015+01:00 tcopt11 kernel: [156011.689437] Hardware n=
ame:
GIGABYTE R181-Z91-00/MZ91-FS0-00, BIOS F23a 08/14/2020
2021-02-26T11:49:32.036016+01:00 tcopt11 kernel: [156011.697002] Call Trace:
2021-02-26T11:49:32.036018+01:00 tcopt11 kernel: [156011.699545]=20
dump_stack+0x6b/0x83
2021-02-26T11:49:32.036019+01:00 tcopt11 kernel: [156011.702956]=20
bad_page.cold+0x9b/0xa0
2021-02-26T11:49:32.036020+01:00 tcopt11 kernel: [156011.706623]=20
get_page_from_freelist+0x74b/0x1380
2021-02-26T11:49:32.036021+01:00 tcopt11 kernel: [156011.711331]=20
__alloc_pages_nodemask+0x161/0x310
2021-02-26T11:49:32.036023+01:00 tcopt11 kernel: [156011.715947]=20
alloc_pages_vma+0x80/0x260
2021-02-26T11:49:32.036024+01:00 tcopt11 kernel: [156011.719873]=20
handle_mm_fault+0xef9/0x1960
2021-02-26T11:49:32.036025+01:00 tcopt11 kernel: [156011.723974]  ?
schedule+0x46/0xb0
2021-02-26T11:49:32.036028+01:00 tcopt11 kernel: [156011.727380]=20
do_user_addr_fault+0x19f/0x480
2021-02-26T11:49:32.036029+01:00 tcopt11 kernel: [156011.731653]=20
exc_page_fault+0x5d/0x120
2021-02-26T11:49:32.036031+01:00 tcopt11 kernel: [156011.735490]  ?
asm_exc_page_fault+0x8/0x30
2021-02-26T11:49:32.036034+01:00 tcopt11 kernel: [156011.739677]=20
asm_exc_page_fault+0x1e/0x30
2021-02-26T11:49:32.036036+01:00 tcopt11 kernel: [156011.743777] RIP:
0033:0xc9b9d8
2021-02-26T11:49:32.036039+01:00 tcopt11 kernel: [156011.746923] Code: b0 0=
8 20
00 00 49 8d 90 08 22 08 00 4d 8d 24 08 4d 89 f7 48 89 55 a0 49 89 c6 4d 01 =
ec
0f 1f 44 00 00 4f 8d 8c 3d f8 dd f7 ff <43> c7 84 3c f8 fd f7 ff 01 00 00 0=
0 48
89 d8 49 8d 79 08 49 c7 01
2021-02-26T11:49:32.036041+01:00 tcopt11 kernel: [156011.765756] RSP:
002b:00007ffe41c5df80 EFLAGS: 00010287
2021-02-26T11:49:32.036043+01:00 tcopt11 kernel: [156011.771069] RAX:
0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
2021-02-26T11:49:32.036045+01:00 tcopt11 kernel: [156011.778289] RDX:
000000000a5386b0 RSI: 0000000000000000 RDI: 000000000a53a6c0
2021-02-26T11:49:32.036047+01:00 tcopt11 kernel: [156011.785507] RBP:
00007ffe41c5e000 R08: 00007f9291c55b00 R09: 00007f92785bd140
2021-02-26T11:49:32.036050+01:00 tcopt11 kernel: [156011.792727] R10:
ffffffffffff0c08 R11: 0000000000000070 R12: 00007f9278571010
2021-02-26T11:49:32.036053+01:00 tcopt11 kernel: [156011.799946] R13:
00007f9278571010 R14: 00007f9291c55f30 R15: 00000000000ce338
2021-02-26T11:50:18.309353+01:00 tcopt11 kernel: [156058.072317] BUG: workq=
ueue
lockup - pool cpus=3D51 node=3D0 flags=3D0x0 nice=3D0 stuck for 48s!
2021-02-26T11:50:18.309380+01:00 tcopt11 kernel: [156058.080446] Showing bu=
sy
workqueues and worker pools:
2021-02-26T11:50:18.319118+01:00 tcopt11 kernel: [156058.085750] workqueue
mm_percpu_wq: flags=3D0x8
2021-02-26T11:50:18.330121+01:00 tcopt11 kernel: [156058.090215]   pwq 102:
cpus=3D51 node=3D0 flags=3D0x0 nice=3D0 active=3D1/256 refcnt=3D2
2021-02-26T11:50:18.330126+01:00 tcopt11 kernel: [156058.097355]     pendin=
g:
vmstat_update
2021-02-26T11:50:18.347571+01:00 tcopt11 kernel: [156058.101828] workqueue
xfs-conv/nvme0n1p1: flags=3D0xc
2021-02-26T11:50:18.347576+01:00 tcopt11 kernel: [156058.106805]   pwq 102:
cpus=3D51 node=3D0 flags=3D0x0 nice=3D0 active=3D1/256 refcnt=3D2
2021-02-26T11:50:18.347577+01:00 tcopt11 kernel: [156058.113940]     in-fli=
ght:
832:xfs_end_io [xfs]
2021-02-26T11:50:18.355454+01:00 tcopt11 kernel: [156058.118877] pool 102:
cpus=3D51 node=3D0 flags=3D0x0 nice=3D0 hung=3D48s workers=3D2 idle: 330
[...]

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
