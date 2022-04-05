Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275CAC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Apr 2022 04:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiDEEsp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 00:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiDEEr6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 00:47:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813BC2DD74
        for <linux-xfs@vger.kernel.org>; Mon,  4 Apr 2022 21:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F40961462
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 04:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EF05C34113
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 04:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649133876;
        bh=znWQr5cmsCr9GnrPGgE+ljZ5Ct7eMKk7SbljTk9BZLU=;
        h=From:To:Subject:Date:From;
        b=XOwZMqGJFXv0KneX0dXJqc2pRn/rCeACpy+WXJ+rprdNLZvMxTWJItNzDa9AIzDrq
         kM5Od6K8SHUO/9c4DZwWJbo2COMkMAZL1OxlfKRuS2XKdj2oxp+yK7z7ZkqRyulB7h
         d/9sHFzwkcjK/4udiH8tD+eYmkQ3jd0YXJ+5bzYsGZEeGVL70wIeg9HLtNF9R6/OUL
         yaQl3FMtJ52VBT2xjm6t9Pirqveqyp6nxeq134JMUfrMi5c2Q0lAbTfhSJcROzMIKe
         Mb76/YRTPV6Ctt4TRayMk7MagwXqAB/hKMhzaj0v7ueu/DFSVr4Db6TlNPDjjSOeEb
         NP1piP7nFpiiw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5BB9BCAC6E2; Tue,  5 Apr 2022 04:44:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215804] New: [xfstests generic/670] Unable to handle kernel
 paging request at virtual address fffffbffff000008
Date:   Tue, 05 Apr 2022 04:44:35 +0000
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
Message-ID: <bug-215804-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215804

            Bug ID: 215804
           Summary: [xfstests generic/670] Unable to handle kernel paging
                    request at virtual address fffffbffff000008
           Product: File System
           Version: 2.5
    Kernel Version: xfs-5.18-merge-4
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

xfstests generic/670 hit a panic[1] on 64k directory block size XFS (mkfs.x=
fs
-n size=3D65536 -m rmapbt=3D1 -b size=3D1024):

The kernel version is linux 5.17+ (nearly 5.18-rc1, contains latest
xfs-5.18-merge-4)
The linux kernel HEAD is (nearly 5.18-rc1, but not):

commit be2d3ecedd9911fbfd7e55cc9ceac5f8b79ae4cf
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Apr 2 12:57:17 2022 -0700

    Merge tag 'perf-tools-for-v5.18-2022-04-02' of
git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux

[1]
[37277.345917] run fstests generic/670 at 2022-04-03 17:02:54=20
[37278.883000] XFS (vda3): Mounting V5 Filesystem=20
[37278.891732] XFS (vda3): Ending clean mount=20
[37278.920425] XFS (vda3): Unmounting Filesystem=20
[37279.399805] XFS (vda3): Mounting V5 Filesystem=20
[37279.407734] XFS (vda3): Ending clean mount=20
[37280.068575] XFS (vda3): Unmounting Filesystem=20
[37280.399733] XFS (vda3): Mounting V5 Filesystem=20
[37280.410122] XFS (vda3): Ending clean mount=20
[37285.232165] Unable to handle kernel paging request at virtual address
fffffbffff000008=20
[37285.232776] KASAN: maybe wild-memory-access in range
[0x0003dffff8000040-0x0003dffff8000047]=20
[37285.233332] Mem abort info:=20
[37285.233520]   ESR =3D 0x96000006=20
[37285.233725]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits=20
[37285.234077]   SET =3D 0, FnV =3D 0=20
[37285.234281]   EA =3D 0, S1PTW =3D 0=20
[37285.234544]   FSC =3D 0x06: level 2 translation fault=20
[37285.234871] Data abort info:=20
[37285.235065]   ISV =3D 0, ISS =3D 0x00000006=20
[37285.235319]   CM =3D 0, WnR =3D 0=20
[37285.235517] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D00000004574eb0=
00=20
[37285.235953] [fffffbffff000008] pgd=3D0000000458c71003, p4d=3D0000000458c=
71003,
pud=3D0000000458c72003, pmd=3D0000000000000000=20
[37285.236651] Internal error: Oops: 96000006 [#1] SMP=20
[37285.236971] Modules linked in: overlay dm_zero dm_log_writes dm_thin_pool
dm_persistent_data dm_bio_prison sg dm_snapshot dm_bufio ext4 mbcache jbd2 =
loop
dm_flakey dm_mod tls rfkill sunrpc vfat fat drm fuse xfs libcrc32c crct10di=
f_ce
ghash_ce virtio_blk sha2_ce sha256_arm64 sha1_ce virtio_console virtio_net
net_failover failover virtio_mmio [last unloaded: scsi_debug]=20
[37285.239187] CPU: 3 PID: 3302514 Comm: xfs_io Kdump: loaded Tainted: G=20=
=20=20=20=20=20=20
W         5.17.0+ #1=20
[37285.239810] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/20=
15=20
[37285.240292] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)=20
[37285.240783] pc : __split_huge_pmd+0x1d8/0x34c=20
[37285.241097] lr : __split_huge_pmd+0x174/0x34c=20
[37285.241407] sp : ffff800023a56fe0=20
[37285.241642] x29: ffff800023a56fe0 x28: 0000000000000000 x27:
ffff0001c54d4060=20
[37285.242145] x26: 0000000000000000 x25: 0000000000000000 x24:
fffffc00056cf000=20
[37285.242661] x23: 1ffff0000474ae0a x22: ffff0007104fe630 x21:
ffff00014fab66b0=20
[37285.243175] x20: ffff800023a57080 x19: fffffbffff000000 x18:
0000000000000000=20
[37285.243689] x17: 0000000000000000 x16: ffffb109a2ec7e30 x15:
0000ffffd9035c10=20
[37285.244202] x14: 00000000f2040000 x13: 0000000000000000 x12:
ffff70000474aded=20
[37285.244715] x11: 1ffff0000474adec x10: ffff70000474adec x9 :
dfff800000000000=20
[37285.245230] x8 : ffff800023a56f63 x7 : 0000000000000001 x6 :
0000000000000003=20
[37285.245745] x5 : ffff800023a56f60 x4 : ffff70000474adec x3 :
1fffe000cd086e01=20
[37285.246257] x2 : 1fffff7fffe00001 x1 : 0000000000000000 x0 :
fffffbffff000008=20
[37285.246770] Call trace:=20
[37285.246952]  __split_huge_pmd+0x1d8/0x34c=20
[37285.247246]  split_huge_pmd_address+0x10c/0x1a0=20
[37285.247577]  try_to_unmap_one+0xb64/0x125c=20
[37285.247878]  rmap_walk_file+0x1dc/0x4b0=20
[37285.248159]  try_to_unmap+0x134/0x16c=20
[37285.248427]  split_huge_page_to_list+0x5ec/0xcbc=20
[37285.248763]  truncate_inode_partial_folio+0x194/0x2ec=20
[37285.249128]  truncate_inode_pages_range+0x2e8/0x870=20
[37285.249483]  truncate_pagecache_range+0xa0/0xc0=20
[37285.249812]  xfs_flush_unmap_range+0xc8/0x10c [xfs]=20
[37285.250316]  xfs_reflink_remap_prep+0x2f4/0x3ac [xfs]=20
[37285.250822]  xfs_file_remap_range+0x170/0x770 [xfs]=20
[37285.251314]  do_clone_file_range+0x198/0x5e0=20
[37285.251629]  vfs_clone_file_range+0xa8/0x63c=20
[37285.251942]  ioctl_file_clone+0x5c/0xc0=20
[37285.252232]  do_vfs_ioctl+0x10d4/0x1684=20
[37285.252517]  __arm64_sys_ioctl+0xcc/0x18c=20
[37285.252813]  invoke_syscall.constprop.0+0x74/0x1e0=20
[37285.253166]  el0_svc_common.constprop.0+0x224/0x2c0=20
[37285.253525]  do_el0_svc+0xa4/0xf0=20
[37285.253769]  el0_svc+0x5c/0x160=20
[37285.254002]  el0t_64_sync_handler+0x9c/0x120=20
[37285.254312]  el0t_64_sync+0x174/0x178=20
[37285.254584] Code: 91002260 d343fc02 38e16841 35000b41 (f9400660)=20=20
[37285.255026] SMP: stopping secondary CPUs=20
[37285.292297] Starting crashdump kernel...=20
[37285.292706] Bye!=20
[    0.000000] Booting Linux on physical CPU 0x0000000003 [0x413fd0c1]

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
