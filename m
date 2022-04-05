Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1252C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Apr 2022 04:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiDEEvU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 00:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiDEEvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 00:51:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B548D5F8C
        for <linux-xfs@vger.kernel.org>; Mon,  4 Apr 2022 21:49:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67508B81B93
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 04:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A0B7C34113
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 04:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649134140;
        bh=PLKwMig2LY8N93t8YZ+NWQjckprmg5c22Ooh+/pHURI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gq2C8c2WP0/1vt3P+9FLNAp3uBoyyFt2bFOUqnIDPJYfurQBzJChhsrDF7O48P0BK
         RJVyn2AO86TY+hKGddM5ZtLCaqN+GtDfokJrw88BhXyMVBz881HyQIsdiSpfsNm90r
         KqRNT49PkPrwfre15UO/ThIkhiz4KTSHlQOItmb6XkN3m43+C8Pz7cpkGYy5SLi9nP
         8+jVDwXhDBNW0i/5FVGbq3TDM69tSucQR8VX1Kb8Gbzjcmb3nILpJbuBbF0zmbG9FX
         W9qeoa2VRSvXawLTcIpxrFTwCtbyCH38g/aHOJQbmVzwzxUZUwTprw7VONERH6ZE24
         Go6MdgYg0LjrA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E85E9C05FD5; Tue,  5 Apr 2022 04:48:59 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215804] [xfstests generic/670] Unable to handle kernel paging
 request at virtual address fffffbffff000008
Date:   Tue, 05 Apr 2022 04:48:59 +0000
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
Message-ID: <bug-215804-201763-M5B5LsSnTW@https.bugzilla.kernel.org/>
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

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
It's not 64k dir bsize related, just find another same panic on XFS with "-m
crc=3D1,finobt=3D1,reflink=3D1,rmapbt=3D1,bigtime=3D1,inobtcount=3D1 -b siz=
e=3D1024". Hmmm...
"maybe rmapbt and -b size=3D1024 is related???". And other same condition i=
s 2
panic jobs are all on aarch64 machine.

[36463.624185] run fstests generic/670 at 2022-04-03 15:46:45=20
[36465.162010] XFS (nvme0n1p3): Mounting V5 Filesystem=20
[36465.177275] XFS (nvme0n1p3): Ending clean mount=20
[36465.214655] XFS (nvme0n1p3): Unmounting Filesystem=20
[36465.852627] XFS (nvme0n1p3): Mounting V5 Filesystem=20
[36465.869171] XFS (nvme0n1p3): Ending clean mount=20
[36466.599985] XFS (nvme0n1p3): Unmounting Filesystem=20
[36467.052055] XFS (nvme0n1p3): Mounting V5 Filesystem=20
[36467.068257] XFS (nvme0n1p3): Ending clean mount=20
[36471.061110] Unable to handle kernel paging request at virtual address
fffffbfffe000008=20
[36471.069061] KASAN: maybe wild-memory-access in range
[0x0003dffff0000040-0x0003dffff0000047]=20
[36471.078001] Mem abort info:=20
[36471.080788]   ESR =3D 0x96000006=20
[36471.083852]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits=20
[36471.089155]   SET =3D 0, FnV =3D 0=20
[36471.092206]   EA =3D 0, S1PTW =3D 0=20
[36471.095338]   FSC =3D 0x06: level 2 translation fault=20
[36471.100205] Data abort info:=20
[36471.103083]   ISV =3D 0, ISS =3D 0x00000006=20
[36471.106908]   CM =3D 0, WnR =3D 0=20
[36471.109867] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D000008064712b0=
00=20
[36471.116572] [fffffbfffe000008] pgd=3D00000806488b1003, p4d=3D00000806488=
b1003,
pud=3D00000806488b2003, pmd=3D0000000000000000=20
[36471.127190] Internal error: Oops: 96000006 [#1] SMP=20
[36471.132059] Modules linked in: overlay dm_zero dm_log_writes dm_thin_pool
dm_persistent_data dm_bio_prison sg dm_snapshot dm_bufio ext4 mbcache jbd2 =
loop
dm_flakey dm_mod arm_spe_pmu rfkill mlx5_ib ast acpi_ipmi ib_uverbs
drm_vram_helper drm_ttm_helper ipmi_ssif ttm drm_kms_helper ib_core fb_sys_=
fops
syscopyarea sysfillrect sysimgblt ipmi_devintf arm_dmc620_pmu arm_cmn
ipmi_msghandler arm_dsu_pmu cppc_cpufreq sunrpc vfat fat drm fuse xfs libcr=
c32c
mlx5_core crct10dif_ce ghash_ce sha2_ce sha256_arm64 sha1_ce sbsa_gwdt nvme=
 igb
mlxfw nvme_core tls i2c_algo_bit psample pci_hyperv_intf
i2c_designware_platform i2c_designware_core xgene_hwmon [last unloaded:
scsi_debug]=20
[36471.190920] CPU: 34 PID: 559440 Comm: xfs_io Kdump: loaded Tainted: G=20=
=20=20=20=20=20=20
W         5.17.0+ #1=20
[36471.199781] Hardware name: GIGABYTE R272-P30-JG/MP32-AR0-JG, BIOS F16f (=
SCP:
1.06.20210615) 07/01/2021=20
[36471.209075] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)=20
[36471.216025] pc : __split_huge_pmd+0x1d8/0x34c=20
[36471.220375] lr : __split_huge_pmd+0x174/0x34c=20
[36471.224720] sp : ffff8000648f6fe0=20
[36471.228023] x29: ffff8000648f6fe0 x28: 0000000000000000 x27:
ffff080113ae1f00=20
[36471.235150] x26: 0000000000000000 x25: 0000000000000000 x24:
fffffc200a6cd800=20
[36471.242276] x23: 1ffff0000c91ee0a x22: ffff08070c7959c8 x21:
ffff080771475b88=20
[36471.249402] x20: ffff8000648f7080 x19: fffffbfffe000000 x18:
0000000000000000=20
[36471.256529] x17: 0000000000000000 x16: ffffde5c81d07e30 x15:
0000fffff07a68c0=20
[36471.263654] x14: 00000000f2040000 x13: 0000000000000000 x12:
ffff70000c91eded=20
[36471.270781] x11: 1ffff0000c91edec x10: ffff70000c91edec x9 :
dfff800000000000=20
[36471.277907] x8 : ffff8000648f6f63 x7 : 0000000000000001 x6 :
0000000000000003=20
[36471.285032] x5 : ffff8000648f6f60 x4 : ffff70000c91edec x3 :
1fffe106cbc34401=20
[36471.292158] x2 : 1fffff7fffc00001 x1 : 0000000000000000 x0 :
fffffbfffe000008=20
[36471.299284] Call trace:=20
[36471.301719]  __split_huge_pmd+0x1d8/0x34c=20
[36471.305718]  split_huge_pmd_address+0x10c/0x1a0=20
[36471.310238]  try_to_unmap_one+0xb64/0x125c=20
[36471.314326]  rmap_walk_file+0x1dc/0x4b0=20
[36471.318151]  try_to_unmap+0x134/0x16c=20
[36471.321803]  split_huge_page_to_list+0x5ec/0xcbc=20
[36471.326409]  truncate_inode_partial_folio+0x194/0x2ec=20
[36471.331451]  truncate_inode_pages_range+0x2e8/0x870=20
[36471.336318]  truncate_pagecache_range+0xa0/0xc0=20
[36471.340837]  xfs_flush_unmap_range+0xc8/0x10c [xfs]=20
[36471.345850]  xfs_reflink_remap_prep+0x2f4/0x3ac [xfs]=20
[36471.351025]  xfs_file_remap_range+0x170/0x770 [xfs]=20
[36471.356025]  do_clone_file_range+0x198/0x5e0=20
[36471.360286]  vfs_clone_file_range+0xa8/0x63c=20
[36471.364545]  ioctl_file_clone+0x5c/0xc0=20
[36471.368372]  do_vfs_ioctl+0x10d4/0x1684=20
[36471.372197]  __arm64_sys_ioctl+0xcc/0x18c=20
[36471.376196]  invoke_syscall.constprop.0+0x74/0x1e0=20
[36471.380978]  el0_svc_common.constprop.0+0x224/0x2c0=20
[36471.385845]  do_el0_svc+0xa4/0xf0=20
[36471.389150]  el0_svc+0x5c/0x160=20
[36471.392281]  el0t_64_sync_handler+0x9c/0x120=20
[36471.396540]  el0t_64_sync+0x174/0x178=20
[36471.400193] Code: 91002260 d343fc02 38e16841 35000b41 (f9400660)=20=20
[36471.406279] SMP: stopping secondary CPUs=20
[36471.411145] Starting crashdump kernel...=20
[36471.415057] Bye!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
