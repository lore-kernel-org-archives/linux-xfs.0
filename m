Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8168EC6FD1F
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Mar 2023 11:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjCSLL2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Mar 2023 07:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCSLL1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Mar 2023 07:11:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8AA18AA8
        for <linux-xfs@vger.kernel.org>; Sun, 19 Mar 2023 04:11:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA73C60FB3
        for <linux-xfs@vger.kernel.org>; Sun, 19 Mar 2023 11:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36DC6C433AA
        for <linux-xfs@vger.kernel.org>; Sun, 19 Mar 2023 11:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679224285;
        bh=CTbwAmU8YfOG3Q1LKkb8Zf9llEGk976TBmFa4UKb8Xo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iMPBgOPVoTUXChora2bqcLlDLsbhT1IMlMC2hWYIDcCtYi0SNJpd8uu11vbWwb1SB
         feFjlhS3AxzPASFOMDi8WG1R6ehPXEchuA0EvX4Zf1BgugywnXVGtXOWm1Iaycv9to
         IVHmwfC5AKsSx6RMLQTitl04IB0rMLv28pwmbYdWoyHqgpBL6PPWrh7tjho47n2q78
         qdYFbX4CiiM7rr2gR1q9zaJZrersU9Fs0SwehBOxMzrF5K4lct9eUmDOeYl9pPt0DH
         wKlMcU2SnQ3FHKRDEYYj0zu1/54eCvRhU/D6ArwxxIFRsgPlK01t21Xuv3MnEj3Zjb
         HtqkBcegNpZPQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 271C4C43144; Sun, 19 Mar 2023 11:11:25 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217138] [xfstests] XFS: Assertion failed:
 xfs_bmap_validate_extent(ip, whichfork, &rec) == NULL, file:
 fs/xfs/libxfs/xfs_inode_fork.c, line: 557
Date:   Sun, 19 Mar 2023 11:11:24 +0000
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
Message-ID: <bug-217138-201763-4M6ru6jGf1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217138-201763@https.bugzilla.kernel.org/>
References: <bug-217138-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217138

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
Still can reproduce this issue on linux v6.3-rc2+. Besides pmem device, I h=
it
this issue on 64k pagesize aarch64 [1] machine too.


[1]
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/aarch64 ampere-mtsnow-altramax-49 6.3.0-rc2+ #1 SMP
PREEMPT_DYNAMIC Sat Mar 18 04:48:48 EDT 2023
MKFS_OPTIONS  -- -f -b size=3D65536 -m
crc=3D1,finobt=3D1,reflink=3D1,rmapbt=3D0,bigtime=3D1,inobtcount=3D1 /dev/n=
vme0n1p4
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/nvme0n1p4
/mnt/xfstests/scratch

generic/650       _check_xfs_filesystem: filesystem on /dev/nvme0n1p5 has d=
irty
log
(see /var/lib/xfstests/results//generic/650.full for details)
./common/xfs: line 715: 514331 Segmentation fault      (core dumped)
$XFS_REPAIR_PROG -n $extra_options $extra_log_options $extra_rt_options $de=
vice
> $tmp.repair 2>&1
_check_xfs_filesystem: filesystem on /dev/nvme0n1p5 is inconsistent (r)
(see /var/lib/xfstests/results//generic/650.full for details)
_check_dmesg: something found in dmesg (see
/var/lib/xfstests/results//generic/650.dmesg)
- output mismatch (see /var/lib/xfstests/results//generic/650.out.bad)
    --- tests/generic/650.out   2023-03-18 05:05:09.431268800 -0400
    +++ /var/lib/xfstests/results//generic/650.out.bad  2023-03-18
09:26:13.099142159 -0400
    @@ -1,2 +1,259 @@
     QA output created by 650
     Silence is golden.
    +fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output
error)
    +fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output
error)
    +fsstress: check_cwd stat64() returned -1 with errno: 5 (Input/output
error)
    +fsstress: check_cwd failure
    +fsstress: check_cwd failure
    ...
    (Run 'diff -u /var/lib/xfstests/tests/generic/650.out
/var/lib/xfstests/results//generic/650.out.bad'  to see the entire diff)
Ran: generic/650
Failures: generic/650
Failed 1 of 1 tests



[16046.257289] XFS: Assertion failed: xfs_bmap_validate_extent(ip, whichfor=
k,
&rec) =3D=3D NULL, file: fs/xfs/libxfs/xfs_inode_fork.c, line: 557=20
[16046.269683] ------------[ cut here ]------------=20
[16046.274289] WARNING: CPU: 109 PID: 514058 at fs/xfs/xfs_message.c:104
assfail+0x6c/0x90 [xfs]=20
[16046.282946] Modules linked in: overlay dm_zero dm_log_writes dm_thin_pool
dm_persistent_data dm_bio_prison sg dm_snapshot dm_bufio ext4 mbcache jbd2 =
loop
dm_flakey dm_mod tls rfkill sunrpc vfat fat ast acpi_ipmi drm_shmem_helper
ipmi_ssif drm_kms_helper arm_spe_pmu syscopyarea sysfillrect sysimgblt
ipmi_devintf ipmi_msghandler arm_dmc620_pmu arm_cmn cppc_cpufreq arm_dsu_pmu
drm fuse xfs libcrc32c crct10dif_ce nvme ghash_ce nvme_core sha2_ce
sha256_arm64 sha1_ce sbsa_gwdt nvme_common igb i2c_designware_platform
i2c_algo_bit i2c_designware_core xgene_hwmon [last unloaded: scsi_debug]=20
[16046.334506] CPU: 109 PID: 514058 Comm: kworker/u256:10 Kdump: loaded
Tainted: G        W I        6.3.0-rc2+ #1=20
[16046.344582] Hardware name: GIGABYTE R152-P31-00/MP32-AR1-00, BIOS F31n (=
SCP:
2.10.20220810) 09/30/2022=20
[16046.353876] Workqueue: writeback wb_workfn (flush-259:0)=20
[16046.359181] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)=20
[16046.366131] pc : assfail+0x6c/0x90 [xfs]=20
[16046.370182] lr : assfail+0x38/0x90 [xfs]=20
[16046.374233] sp : ffff80005206e550=20
[16046.377535] x29: ffff80005206e550 x28: ffffad52485aae74 x27:
0000000000000000=20
[16046.384663] x26: ffff080524799ac0 x25: 0000000000000050 x24:
ffff08070f1101d8=20
[16046.391790] x23: ffff80005206e630 x22: ffffad527672f9e0 x21:
ffff080524799b00=20
[16046.398917] x20: dfff800000000000 x19: ffff80005206e650 x18:
ffff80005206e4e8=20
[16046.406043] x17: 26202c6b726f6668 x16: ffffad52735e1340 x15:
28746e657478655f=20
[16046.413170] x14: 65746164696c6176 x13: 0000000000000001 x12:
ffff70000a40dc2b=20
[16046.420297] x11: 1ffff0000a40dc2a x10: ffff70000a40dc2a x9 :
ffffad52729aab58=20
[16046.427423] x8 : 0000000041b58ab3 x7 : 00000000f1f1f1f1 x6 :
00000000ffffffc0=20
[16046.434550] x5 : 0000000000000021 x4 : 00000000ffffffca x3 :
1ffff5aa490ee736=20
[16046.441677] x2 : 0000000000000000 x1 : 0000000000000004 x0 :
0000000000000000=20
[16046.448803] Call trace:=20
[16046.451238]  assfail+0x6c/0x90 [xfs]=20
[16046.454942]  xfs_iextents_copy+0x480/0x670 [xfs]=20
[16046.459688]  xfs_inode_item_format_data_fork+0x544/0x9b0 [xfs]=20
[16046.465649]  xfs_inode_item_format+0x614/0x970 [xfs]=20
[16046.470741]  xlog_cil_insert_format_items.constprop.0+0x1f8/0x478 [xfs]=
=20
[16046.477483]  xlog_cil_insert_items+0xd4/0xee0 [xfs]=20
[16046.482488]  xlog_cil_commit+0xa4/0x600 [xfs]=20
[16046.486973]  __xfs_trans_commit+0x7e8/0xe18 [xfs]=20
[16046.491804]  xfs_trans_commit+0x18/0x28 [xfs]=20
[16046.496288]  xfs_bmapi_convert_delalloc+0x848/0xa68 [xfs]=20
[16046.501815]  xfs_map_blocks+0x4a0/0xfb0 [xfs]=20
[16046.506300]  iomap_writepage_map+0x258/0xb20=20
[16046.510560]  iomap_do_writepage+0x308/0x698=20
[16046.514733]  write_cache_pages+0x35c/0xac0=20
[16046.518819]  iomap_writepages+0x4c/0xc0=20
[16046.522644]  xfs_vm_writepages+0x124/0x198 [xfs]=20
[16046.527389]  do_writepages+0x148/0x4e0=20
[16046.531127]  __writeback_single_inode+0x140/0xc50=20
[16046.535821]  writeback_sb_inodes+0x3c8/0xbe8=20
[16046.540079]  wb_writeback+0x2bc/0xc08=20
[16046.543731]  wb_do_writeback+0x220/0x928=20
[16046.547643]  wb_workfn+0x13c/0x630=20
[16046.551034]  process_one_work+0x798/0x1660=20
[16046.555120]  worker_thread+0x3cc/0xc38=20
[16046.558859]  kthread+0x238/0x2a0=20
[16046.562077]  ret_from_fork+0x10/0x20=20
[16046.565642] irq event stamp: 0=20
[16046.568685] hardirqs last  enabled at (0): [<0000000000000000>] 0x0=20
[16046.574941] hardirqs last disabled at (0): [<ffffad5272816968>]
copy_process+0x1118/0x3fe8=20
[16046.583193] softirqs last  enabled at (0): [<ffffad527281699c>]
copy_process+0x114c/0x3fe8=20
[16046.591445] softirqs last disabled at (0): [<0000000000000000>] 0x0=20
[16046.597700] ---[ end trace 0000000000000000 ]---=20
[16046.603400] XFS: Assertion failed: xfs_bmap_validate_extent(ip, whichfor=
k,
&rec) =3D=3D NULL, file: fs/xfs/libxfs/xfs_inode_fork.c, line: 557=20
[16046.615925] ------------[ cut here ]------------=20


Thanks,
Zorro

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
