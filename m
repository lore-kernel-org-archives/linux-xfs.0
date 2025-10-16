Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A198A10E3
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 00:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760573444; cv=none; b=oZtibjgOAQHdtFwoVcBP7v0wXahpDbr9HrE0l8YUG6QELDMrx7+eicDf7LD8QrAZddhzFa8nB+mpb2WITEj75Z2Jkqw2EVVLVEfMISbOXcfUuwmFdYvA7vKl2P5pyKW0SX0ql4xQwmtDHaOYdtjHoz+898hHCsE3I8xpMuw9VYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760573444; c=relaxed/simple;
	bh=6YQYgOFzh+6KnBmhMCTG3QLgdWjpDixqvtZr3f8zBTM=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=aA7R85XVlqBxMnc5FcwgTXjKBeIfhBBQoMBwJPRrjrwGe1bAQqAEszQA6fwIp0BO2FcGttsIIUZ3QuyU2HfTD1HPF6/Sia6JQVVL5mHfj3ZbI3ekreX50oxbQWWxpONqp6a0gyf69WPmL1J+gXDXwfSJqNOU0sgP4e8VY72bOQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2M412a3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2M412a3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34D2BC4CEFE
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 00:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760573444;
	bh=6YQYgOFzh+6KnBmhMCTG3QLgdWjpDixqvtZr3f8zBTM=;
	h=From:To:Subject:Date:From;
	b=o2M412a3twVaXtzuHgVkfela9xUTEWvLMOhkXVSZSCQVqDZcv23aNQFjHrEIeFB5O
	 vG5wwf5ehiat2zVAqNzsjCl+TDoOK9llj5USX1GtJIO8Lze123TbbOTYrpHSReIX/e
	 cP7xxSpVgaSF0b22uODNWzUKbckj9rDJT+zswbsHTdKy9Y4kFBUmp4yrtJvj1LIM41
	 rHla6ow0NaE2MF2R+WyeMVNoNks1Bk6yB3f8LDt/1OGLceaFkTRJYlYD4cptpeaHgV
	 JdtnhX0MQoVVl4uIj5eLyUD+OeI+yxyrBdyeHz5JvPNff40swa6pxdWK2sjxQekop3
	 BEstm3N7qPkog==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 2AA93C41612; Thu, 16 Oct 2025 00:10:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 220669] New: Drive issues cause system and coredump and reboot
Date: Thu, 16 Oct 2025 00:10:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bshephar@bne-home.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-220669-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D220669

            Bug ID: 220669
           Summary: Drive issues cause system and coredump and reboot
           Product: File System
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: bshephar@bne-home.net
        Regression: No

We have a number of drives across our clusters that don't present as failin=
g,
but seem to have read errors that cause the system to coredump and reboot.
Failing drives is obviously not the fault of XFS, but my expectation would =
be
that it doesn't completely cause the system to hang and need to reboot.

Kernel Version:
$ uname -r
4.18.0-553.69.1.el8_10.x86_64




Ideally, I think XFS should be able to more gracefully handle this situatio=
n.

We can see the drive at /dev/sdv have issues here before the Call Trace and
coredump:

[  998.356008] sd 0:0:21:0: [sdv] tag#415 FAILED Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE cmd_age=3D3s
[  998.365528] sd 0:0:21:0: [sdv] tag#415 Sense Key : Medium Error [current]
[descriptor]
[  998.373544] sd 0:0:21:0: [sdv] tag#415 Add. Sense: Unrecovered read error
[  998.380347] sd 0:0:21:0: [sdv] tag#415 CDB: Read(16) 88 00 00 00 00 05 0=
1 1f
6d 90 00 00 00 08 00 00
[  998.389524] blk_update_request: critical medium error, dev sdv, sector
21493673360 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 0
[  998.404141] XFS (sdv): metadata I/O error in "xfs_da_read_buf+0xd3/0x120
[xfs]" at daddr 0x5011f6d90 len 8 error 61
[  998.414706] BUG: unable to handle kernel NULL pointer dereference at
0000000000000020
[  998.422554] PGD 1218fc067 P4D 1218fc067 PUD 1d0139067 PMD 0
[  998.428247] Oops: 0002 [#1] SMP NOPTI
[  998.431931] CPU: 72 PID: 4802 Comm: swift-object-au Kdump: loaded Not
tainted 4.18.0-553.69.1.el8_10.x86_64 #1
[  998.441958] Hardware name: Dell Inc. PowerEdge R740xd2/0VNGN1, BIOS 2.14=
.2
03/23/2022
[  998.449818] RIP: 0010:_raw_spin_lock_irqsave+0x1e/0x40
[  998.454975] Code: cf 80 0b 08 eb 88 90 90 90 90 90 90 0f 1f 44 00 00 53 =
9c
58 0f 1f 44 00 00 48 89 c3 fa 66 0f 1f 44 00 00 31 c0 ba 01 00 00 00 <f0> 0=
f b1
17 75 09 48 89 d8 5b c3 cc cc cc cc 89 c6 e8 1c 7b 73 ff
[  998.473799] RSP: 0018:ffff99455ccafbe0 EFLAGS: 00010046
[  998.479344] RAX: 0000000000000000 RBX: 0000000000000286 RCX:
0000000000000000
[  998.486695] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
0000000000000020
[  998.494044] RBP: 0000000000000000 R08: 0000000080000000 R09:
ffff8e3abffd5000
[  998.501360] R10: 0000000000000001 R11: ffff99455ccaf848 R12:
0000000000000000
[  998.508690] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
[  998.516004] FS:  00007f74aa03e740(0000) GS:ffff8e3941100000(0000)
knlGS:0000000000000000
[  998.524333] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  998.530270] CR2: 0000000000000020 CR3: 00000001cfbb6003 CR4:
00000000007706e0
[  998.537585] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  998.544901] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[  998.552224] PKRU: 55555554
[  998.555136] Call Trace:
[  998.557765]  ? __die_body+0x1a/0x60
[  998.561435]  ? no_context+0x1ba/0x3f0
[  998.565276]  ? __bad_area_nosemaphore+0x157/0x180
[  998.570202]  ? xfs_trans_read_buf_map+0x128/0x360 [xfs]
[  998.575693]  ? do_page_fault+0x37/0x12d
[  998.579713]  ? page_fault+0x1e/0x30
[  998.583390]  ? _raw_spin_lock_irqsave+0x1e/0x40
[  998.588113]  up+0x12/0x50
[  998.590913]  xfs_buf_unlock+0x15/0x70 [xfs]
[  998.595350]  xfs_trans_brelse+0xc6/0xe0 [xfs]
[  998.599960]  xfs_attr_leaf_get+0xb0/0xc0 [xfs]
[  998.604639]  xfs_attr_get+0x9e/0xc0 [xfs]
[  998.608888]  xfs_xattr_get+0x75/0xb0 [xfs]
[  998.613238]  __vfs_getxattr+0x54/0x70
[  998.617104]  vfs_getxattr+0x118/0x140
[  998.620959]  getxattr+0x187/0x1b0
[  998.624470]  ? cp_new_stat+0x150/0x190
[  998.628411]  ? do_vfs_ioctl+0xa4/0x690
[  998.632356]  ? __do_sys_newfstat+0x5e/0x70
[  998.636644]  ? syscall_trace_enter+0x1ff/0x2d0
[  998.641283]  __x64_sys_fgetxattr+0x5f/0xb0
[  998.645573]  do_syscall_64+0x5b/0x1a0
[  998.649429]  entry_SYSCALL_64_after_hwframe+0x66/0xcb
[  998.654672] RIP: 0033:0x7f74a88dc5fe
[  998.658434] Code: 48 8b 0d 8d 78 39 00 f7 d8 64 89 01 48 83 c8 ff c3 66 =
2e
0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 c1 00 00 00 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d 5a 78 39 00 f7 d8 64 89 01 48
[  998.677570] RSP: 002b:00007ffe2289a9f8 EFLAGS: 00000246 ORIG_RAX:
00000000000000c1
[  998.685351] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007f74a88dc5fe
[  998.692683] RDX: 0000000000000000 RSI: 00007f749538e7d0 RDI:
0000000000000003
[  998.700024] RBP: 00007ffe2289aa80 R08: 0000000000000000 R09:
00007f74a9f400d0
[  998.707357] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[  998.714680] R13: 0000000000000003 R14: 0000000000000000 R15:
0000000000000000
[  998.722013] Modules linked in: dm_mod tun xfs ipt_MASQUERADE
nf_conntrack_netlink xt_addrtype br_netfilter bridge stp llc tcp_diag inet_=
diag
overlay xt_multiport ip6t_REJECT nf_reject_ipv6 ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 xt_conntrack nft_counter nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 ip6_tables ip_tables nft_compat ip_set nf_tab=
les
libcrc32c nfnetlink dell_rbu vfat fat ipmi_ssif intel_rapl_msr
intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common
isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel irdma kvm i40e irqbypass crc32_pclmul ib_uverbs rapl
dell_smbios iTCO_wdt intel_cstate iTCO_vendor_support acpi_ipmi
dell_wmi_descriptor wmi_bmof mei_me dcdbas ib_core intel_uncore pcspkr mei
i2c_i801 ipmi_si lpc_ich wmi ipmi_devintf ipmi_msghandler ext4 mbcache jbd2
sd_mod sg mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt i2c_algo=
_bit
crct10dif_pclmul drm_shmem_helper ahci ice nvme
[  998.722079]  crc32c_intel libahci drm nvme_core ghash_clmulni_intel liba=
ta
megaraid_sas tg3 t10_pi fuse


crash> sys | grep -e CPUS -e LOAD -e RELEASE -e PANIC
        CPUS: 80
LOAD AVERAGE: 79.36, 197.55, 179.00
     RELEASE: 4.18.0-553.69.1.el8_10.x86_64
       PANIC: "BUG: unable to handle kernel NULL pointer dereference at
0000000000000020"

crash> set -p
    PID: 4802
COMMAND: "swift-object-au"
   TASK: ffff8e3ad2990000  [THREAD_INFO: ffff8e3ad2990000]
    CPU: 72
  STATE: TASK_RUNNING (PANIC)
crash> bt
PID: 4802     TASK: ffff8e3ad2990000  CPU: 72   COMMAND: "swift-object-au"
 #0 [ffff99455ccaf910] machine_kexec at ffffffff9b86de53
 #1 [ffff99455ccaf968] __crash_kexec at ffffffff9b9b9e1a
 #2 [ffff99455ccafa28] crash_kexec at ffffffff9b9bad51
 #3 [ffff99455ccafa40] oops_end at ffffffff9b82c131
 #4 [ffff99455ccafa60] no_context at ffffffff9b880da3
 #5 [ffff99455ccafab8] __bad_area_nosemaphore at ffffffff9b881107
 #6 [ffff99455ccafb00] do_page_fault at ffffffff9b881dc7
 #7 [ffff99455ccafb30] page_fault at ffffffff9c4011fe
    [exception RIP: _raw_spin_lock_irqsave+30]
    RIP: ffffffff9c2270be  RSP: ffff99455ccafbe0  RFLAGS: 00010046
    RAX: 0000000000000000  RBX: 0000000000000286  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: 0000000000000000  RDI: 0000000000000020
    RBP: 0000000000000000   R8: 0000000080000000   R9: ffff8e3abffd5000
    R10: 0000000000000001  R11: ffff99455ccaf848  R12: 0000000000000000
    R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #8 [ffff99455ccafbe8] up at ffffffff9c2230e2
 #9 [ffff99455ccafc00] xfs_buf_unlock at ffffffffc0d95455 [xfs]
#10 [ffff99455ccafc20] xfs_trans_brelse at ffffffffc0dcf3b6 [xfs]
#11 [ffff99455ccafc40] xfs_attr_leaf_get at ffffffffc0d49e80 [xfs]
#12 [ffff99455ccafc70] xfs_attr_get at ffffffffc0d4afae [xfs]
#13 [ffff99455ccafc90] xfs_xattr_get at ffffffffc0dbaa05 [xfs]
#14 [ffff99455ccafd40] __vfs_getxattr at ffffffff9bb9a064
#15 [ffff99455ccafd70] vfs_getxattr at ffffffff9bb9a5a8
#16 [ffff99455ccafdb8] getxattr at ffffffff9bb9aa07
#17 [ffff99455ccaff00] __x64_sys_fgetxattr at ffffffff9bb9b17f
#18 [ffff99455ccaff38] do_syscall_64 at ffffffff9b803cab
#19 [ffff99455ccaff50] entry_SYSCALL_64_after_hwframe at ffffffff9c40012e
    RIP: 00007f74a88dc5fe  RSP: 00007ffe2289a9f8  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: 0000000000000000  RCX: 00007f74a88dc5fe
    RDX: 0000000000000000  RSI: 00007f749538e7d0  RDI: 0000000000000003
    RBP: 00007ffe2289aa80   R8: 0000000000000000   R9: 00007f74a9f400d0
    R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000000000
    R13: 0000000000000003  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: 00000000000000c1  CS: 0033  SS: 002b

crash> dis _raw_spin_lock_irqsave+30
0xffffffff9c2270be <_raw_spin_lock_irqsave+30>: lock cmpxchg %edx,(%rdi)

RDI From the above=20
    [exception RIP: _raw_spin_lock_irqsave+30]
    RIP: ffffffff9c2270be  RSP: ffff99455ccafbe0  RFLAGS: 00010046
    RAX: 0000000000000000  RBX: 0000000000000286  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: 0000000000000000  RDI: 0000000000000020
    RBP: 0000000000000000   R8: 0000000080000000   R9: ffff8e3abffd5000
    R10: 0000000000000001  R11: ffff99455ccaf848  R12: 0000000000000000
    R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000000

Seems like that memory address would be incorrect for RDI?
https://www.kernel.org/doc/Documentation/x86/x86_64/mm.txt


The `vmcore` is quite large. But I can probably get any information that you
need to investigate further if required.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
