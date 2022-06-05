Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5791FC433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jun 2022 06:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349279AbiFEGcQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jun 2022 02:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbiFEGcP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jun 2022 02:32:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7211562C3
        for <linux-xfs@vger.kernel.org>; Sat,  4 Jun 2022 23:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 123D460C34
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 06:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70454C341C0
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 06:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654410730;
        bh=owbbKLJBafZWuCmZMW6ZK7DpV0sUp+/F/F0O9Qcq5t4=;
        h=From:To:Subject:Date:From;
        b=HWfMhyuIQxK+mAWsPhfR1wCREjK5thkbVX5clMG2w4mr5D+P+vREdpGqxDbuWSOSq
         vQe2RIQrl/UdZZVmZ1nNTdut6VUhL3XQY2uNeW5PZ7w1ml3z149P7+PHiS2Q/jIcLp
         HMJCQoJFNiVJEhQ+AwNJc194kcoxOJJlKYQCTKZU79LByVPUccHh0F7VQ8gWaG1LD8
         kinuMaBglNHLdm/wsyKqOslcqTjkS5FvG66ZLTgCi9KwXd4AkSdHAvxfxELIqHki2E
         rj7xYZQn4JdcIpsnCBQNLRmu+cEghxo+7545mwX59YHiiLru7KFwe8QBDApVNC03Ai
         IxuQLeTHt3ZrA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5D4D8C05FD2; Sun,  5 Jun 2022 06:32:10 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216074] New: [xfstests generic/388] BUG: Bad page state in
 process fsstress  pfn:220bb5
Date:   Sun, 05 Jun 2022 06:32:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216074-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216074

            Bug ID: 216074
           Summary: [xfstests generic/388] BUG: Bad page state in process
                    fsstress  pfn:220bb5
           Product: File System
           Version: 2.5
    Kernel Version: 5.19-rc0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

xfstests generic/388 hit "Bad page state in process fsstress  pfn:220bb5"[1]
sometimes, on upstream linux HEAD=3D032dcf09e ("Merge tag
'gpio-fixes-for-v5.19-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/brgl/linux")


FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 dell-xxxxxx-xx 5.18.0+ #1 SMP PREEMPT_DYNAMIC=
 Sat
Jun 4 06:29:21 EDT 2022
MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,reflink=3D1,rmapbt=3D1,bigtime=3D=
1,inobtcount=3D1
-b size=3D1024 /dev/sda2
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/sda2
/mnt/xfstests/scratch

generic/388     _check_dmesg: something found in dmesg (see
/var/lib/xfstests/results//generic/388.dmesg)

Ran: generic/388
Failures: generic/388
Failed 1 of 1 tests

[1]
[36225.415439] XFS (sda2): Mounting V5 Filesystem
[36225.945201] XFS (sda2): Starting recovery (logdev: internal)
[36229.330366] XFS (sda2): Ending recovery (logdev: internal)
[36231.431469] XFS (sda2): User initiated shutdown received.
[36231.433679] XFS (sda2): Log I/O Error (0x6) detected at
xfs_fs_goingdown+0xd5/0x170 [xfs] (fs/xfs/xfs_fsops.c:483).  Shutting down
filesystem.
[36231.433836] XFS (sda2): Please unmount the filesystem and rectify the
problem(s)
[36231.927867] XFS (sda2): Unmounting Filesystem
[36232.261330] XFS (sda2): Mounting V5 Filesystem
[36232.748466] XFS (sda2): Starting recovery (logdev: internal)
[36235.979364] XFS (sda2): Ending recovery (logdev: internal)
[36238.060228] XFS (sda2): User initiated shutdown received.
[36238.060426] XFS (sda2): Log I/O Error (0x6) detected at
xfs_fs_goingdown+0xd5/0x170 [xfs] (fs/xfs/xfs_fsops.c:483).  Shutting down
filesystem.
[36238.060657] XFS (sda2): Please unmount the filesystem and rectify the
problem(s)
[36238.060736] BUG: Bad page state in process fsstress  pfn:220bb5
[36238.060744] page:00000000abaf6098 refcount:0 mapcount:0
mapping:0000000000000000 index:0x2c9 pfn:0x220bb5
[36238.060753] flags:
0x17ffffc0040001(locked|reclaim|node=3D0|zone=3D2|lastcpupid=3D0x1fffff)
[36238.060764] raw: 0017ffffc0040001 dead000000000100 dead000000000122
0000000000000000
[36238.060769] raw: 00000000000002c9 0000000000000000 00000000ffffffff
0000000000000000
[36238.060772] page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
[36238.060775] Modules linked in: dm_thin_pool dm_persistent_data dm_bio_pr=
ison
dm_snapshot dm_bufio ext4 mbcache jbd2 loop dm_flakey dm_mod tls intel_rapl=
_msr
intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common
isst_if_common skx_edac nfit x86_pkg_temp_thermal rfkill intel_powerclamp
coretemp kvm_intel kvm iTCO_wdt mgag200 i2c_algo_bit iTCO_vendor_support
drm_shmem_helper drm_kms_helper syscopyarea irqbypass mei_me mei sysfillrect
dell_smbios ipmi_ssif rapl sysimgblt i2c_i801 intel_cstate fb_sys_fops dcdb=
as
dell_wmi_descriptor intel_uncore wmi_bmof pcspkr intel_pch_thermal lpc_ich
i2c_smbus acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter
sunrpc drm fuse xfs libcrc32c sd_mod t10_pi crc64_rocksoft_generic
crc64_rocksoft crc64 sr_mod cdrom sg crct10dif_pclmul crc32_pclmul crc32c_i=
ntel
ghash_clmulni_intel ahci libahci megaraid_sas tg3 libata wmi [last unloaded:
scsi_debug]
[36238.060927] CPU: 2 PID: 1568560 Comm: fsstress Kdump: loaded Tainted: G=
=20=20=20=20=20
  W I       5.18.0+ #1
[36238.060934] Hardware name: Dell Inc. PowerEdge R740/0DY2X0, BIOS 2.12.2
07/09/2021
[36238.060937] Call Trace:
[36238.060940]  <TASK>
[36238.060953]  dump_stack_lvl+0x57/0x7d
[36238.060970]  bad_page.cold+0xc0/0xe1
[36238.060984]  free_pcp_prepare+0x750/0xbb0
[36238.061019]  free_unref_page+0x4a/0x670
[36238.061045]  read_pages+0x5dd/0xc60
[36238.061077]  ? readahead_expand+0x5f0/0x5f0
[36238.061138]  filemap_get_pages+0x564/0x9a0
[36238.061177]  ? filemap_add_folio+0x140/0x140
[36238.061238]  filemap_read+0x2a4/0x9b0
[36238.061294]  ? filemap_get_pages+0x9a0/0x9a0
[36238.061299]  ? __down_read_trylock+0x16e/0x360
[36238.061342]  ? xfs_ilock+0x1bc/0x4b0 [xfs]
[36238.061639]  ? xfs_ilock+0x1bc/0x4b0 [xfs]
[36238.061930]  xfs_file_buffered_read+0x16f/0x390 [xfs]
[36238.062192]  xfs_file_read_iter+0x274/0x560 [xfs]
[36238.062457]  generic_file_splice_read+0x2e5/0x4b0
[36238.062479]  ? do_splice_direct+0x270/0x270
[36238.062507]  ? selinux_file_permission+0x320/0x420
[36238.062546]  ? do_splice_to+0x118/0x230
[36238.062569]  splice_file_to_pipe+0xd7/0xf0
[36238.062590]  do_splice+0x813/0xc90
[36238.062623]  ? splice_file_to_pipe+0xf0/0xf0
[36238.062643]  ? __might_fault+0xb8/0x160
[36238.062675]  __do_splice+0x102/0x1d0
[36238.062694]  ? do_splice+0xc90/0xc90
[36238.062705]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370
[36238.062714]  ? ktime_get_coarse_real_ts64+0x128/0x160
[36238.062724]  ? lockdep_hardirqs_on+0x79/0x100
[36238.062751]  __x64_sys_splice+0x151/0x210
[36238.062775]  do_syscall_64+0x59/0x80
[36238.062785]  ? do_syscall_64+0x69/0x80
[36238.062793]  ? lockdep_hardirqs_on+0x79/0x100
[36238.062804]  ? do_syscall_64+0x69/0x80
[36238.062813]  ? do_syscall_64+0x69/0x80
[36238.062820]  ? do_syscall_64+0x69/0x80
[36238.062825]  ? lockdep_hardirqs_on+0x79/0x100
[36238.062836]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[36238.062842] RIP: 0033:0x7f8367f4eaca
[36238.062849] Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f =
1e
fa 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 13 01 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 7e c3 0f 1f 44 00 00 41 54 48 83 ec 30 44 89
[36238.062854] RSP: 002b:00007fff63decb58 EFLAGS: 00000246 ORIG_RAX:
0000000000000113
[36238.062861] RAX: ffffffffffffffda RBX: 000000000000f2a5 RCX:
00007f8367f4eaca
[36238.062865] RDX: 0000000000000006 RSI: 00007fff63decb98 RDI:
0000000000000003
[36238.062869] RBP: 0000000000000004 R08: 00000000000017b8 R09:
0000000000000000
[36238.062872] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[36238.062875] R13: 0000000000000003 R14: 00000000000017b8 R15:
000000000000f2a5
[36238.062930]  </TASK>
[36238.062967] Disabling lock debugging due to kernel taint
[36238.062978] BUG: Bad page state in process fsstress  pfn:220bb6
[36238.062982] page:00000000ccd6dabf refcount:0 mapcount:0
mapping:0000000000000000 index:0x2ca pfn:0x220bb6
[36238.062988] flags:
0x17ffffc0000001(locked|node=3D0|zone=3D2|lastcpupid=3D0x1fffff)
[36238.062996] raw: 0017ffffc0000001 dead000000000100 dead000000000122
0000000000000000
[36238.063001] raw: 00000000000002ca 0000000000000000 00000000ffffffff
0000000000000000
[36238.063003] page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
[36238.063006] Modules linked in: dm_thin_pool dm_persistent_data dm_bio_pr=
ison
dm_snapshot dm_bufio ext4 mbcache jbd2 loop dm_flakey dm_mod tls intel_rapl=
_msr
intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common
isst_if_common skx_edac nfit x86_pkg_temp_thermal rfkill intel_powerclamp
coretemp kvm_intel kvm iTCO_wdt mgag200 i2c_algo_bit iTCO_vendor_support
drm_shmem_helper drm_kms_helper syscopyarea irqbypass mei_me mei sysfillrect
dell_smbios ipmi_ssif rapl sysimgblt i2c_i801 intel_cstate fb_sys_fops dcdb=
as
dell_wmi_descriptor intel_uncore wmi_bmof pcspkr intel_pch_thermal lpc_ich
i2c_smbus acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter
sunrpc drm fuse xfs libcrc32c sd_mod t10_pi crc64_rocksoft_generic
crc64_rocksoft crc64 sr_mod cdrom sg crct10dif_pclmul crc32_pclmul crc32c_i=
ntel
ghash_clmulni_intel ahci libahci megaraid_sas tg3 libata wmi [last unloaded:
scsi_debug]
[36238.063128] CPU: 2 PID: 1568560 Comm: fsstress Kdump: loaded Tainted: G =
   B
  W I       5.18.0+ #1
[36238.063134] Hardware name: Dell Inc. PowerEdge R740/0DY2X0, BIOS 2.12.2
07/09/2021
[36238.063137] Call Trace:
[36238.063139]  <TASK>
[36238.063143]  dump_stack_lvl+0x57/0x7d
[36238.063152]  bad_page.cold+0xc0/0xe1
[36238.063159]  free_pcp_prepare+0x750/0xbb0
[36238.063171]  free_unref_page+0x4a/0x670
[36238.063181]  read_pages+0x5dd/0xc60
[36238.063191]  ? readahead_expand+0x5f0/0x5f0
[36238.063207]  filemap_get_pages+0x564/0x9a0
[36238.063220]  ? filemap_add_folio+0x140/0x140
[36238.063236]  filemap_read+0x2a4/0x9b0
[36238.063252]  ? filemap_get_pages+0x9a0/0x9a0
[36238.063257]  ? __down_read_trylock+0x16e/0x360
[36238.063271]  ? xfs_ilock+0x1bc/0x4b0 [xfs]
[36238.063532]  ? xfs_ilock+0x1bc/0x4b0 [xfs]
[36238.063803]  xfs_file_buffered_read+0x16f/0x390 [xfs]
[36238.064055]  xfs_file_read_iter+0x274/0x560 [xfs]
[36238.064308]  generic_file_splice_read+0x2e5/0x4b0
[36238.064319]  ? do_splice_direct+0x270/0x270
[36238.064330]  ? selinux_file_permission+0x320/0x420
[36238.064342]  ? do_splice_to+0x118/0x230
[36238.064351]  splice_file_to_pipe+0xd7/0xf0
[36238.064361]  do_splice+0x813/0xc90
[36238.064371]  ? splice_file_to_pipe+0xf0/0xf0
[36238.064379]  ? __might_fault+0xb8/0x160
[36238.064390]  __do_splice+0x102/0x1d0
[36238.064399]  ? do_splice+0xc90/0xc90
[36238.064406]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370
[36238.064412]  ? ktime_get_coarse_real_ts64+0x128/0x160
[36238.064419]  ? lockdep_hardirqs_on+0x79/0x100
[36238.064430]  __x64_sys_splice+0x151/0x210
[36238.064438]  do_syscall_64+0x59/0x80
[36238.064444]  ? do_syscall_64+0x69/0x80
[36238.064450]  ? lockdep_hardirqs_on+0x79/0x100
[36238.064456]  ? do_syscall_64+0x69/0x80
[36238.064462]  ? do_syscall_64+0x69/0x80
[36238.064467]  ? do_syscall_64+0x69/0x80
[36238.064472]  ? lockdep_hardirqs_on+0x79/0x100
[36238.064479]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[36238.064484] RIP: 0033:0x7f8367f4eaca
[36238.064489] Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f =
1e
fa 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 13 01 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 7e c3 0f 1f 44 00 00 41 54 48 83 ec 30 44 89
[36238.064494] RSP: 002b:00007fff63decb58 EFLAGS: 00000246 ORIG_RAX:
0000000000000113
[36238.064499] RAX: ffffffffffffffda RBX: 000000000000f2a5 RCX:
00007f8367f4eaca
[36238.064503] RDX: 0000000000000006 RSI: 00007fff63decb98 RDI:
0000000000000003
[36238.064507] RBP: 0000000000000004 R08: 00000000000017b8 R09:
0000000000000000
[36238.064509] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[36238.064512] R13: 0000000000000003 R14: 00000000000017b8 R15:
000000000000f2a5
[36238.064525]  </TASK>
[36238.064546] BUG: Bad page state in process fsstress  pfn:1314fa

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
