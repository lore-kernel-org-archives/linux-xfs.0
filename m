Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE76C433E6
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 18:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CED564EE8
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 18:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbhBEQmR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Feb 2021 11:42:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233403AbhBEQjB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Feb 2021 11:39:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 26D9264E4D
        for <linux-xfs@vger.kernel.org>; Fri,  5 Feb 2021 18:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612548999;
        bh=4foBKt5sU8fDivc+Cfg87g39SNYfHCv6CZK5lnW2hqc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=HcS55apspRNFcyHHqMmVvezKMxz5E+ntYV0dMLo74sqhvFijPvG3SaFiwNQR4b0x/
         e70boH8IgpeaNoCaGkJABG1sLo7ZzYfmYDF9zAsWd5kzVTcQQOMqkmhB5cdV4oHGC1
         xXJXbZVOr3jv0DldGhEVMxPMvA5JKQ6sk8j2ixplSyDWX8YceCrkkKD0V5REpB4pEf
         vTjaxNfYncITKUdH4ywBnb8lEx1dD41u5UUJBVZP8JYziOdEdDb4XP+98B7qnPwd1j
         B5i3S+dT0/fs+WbVESBMHT80EORSmQAc6t61ulhDailIvBRyYnud0Kn3tka5QTYxBn
         XBoM2GginJGrg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211577] [generic/475] WARNING: CPU: 1 PID: 11596 at
 fs/iomap/buffered-io.c:79 iomap_page_release+0x220/0x290
Date:   Fri, 05 Feb 2021 18:16:38 +0000
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
Message-ID: <bug-211577-201763-lWupaBgZSS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211577-201763@https.bugzilla.kernel.org/>
References: <bug-211577-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211577

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
Follow willy's suggestion, add a dump_page after the warning, then get:
[  190.776418] ------------[ cut here ]------------
[  190.776433] WARNING: CPU: 21 PID: 4522 at fs/iomap/buffered-io.c:79
iomap_page_release+0x220/0x2a0
[  190.776444] Modules linked in: dm_mod bonding rfkill sunrpc uio_pdrv_gen=
irq
pseries_rng uio drm fuse drm_panel_orientation_quirks ip_tables xfs libcrc3=
2c
sd_mod t10_pi ibmvscsi ibmveth scs
i_transport_srp xts vmx_crypto
[  190.776496] CPU: 21 PID: 4522 Comm: umount Not tainted 5.11.0-rc6+ #5
[  190.776504] NIP:  c0000000006a0f20 LR: c0000000006a0df4 CTR:
c0000000006a1240
[  190.776511] REGS: c00000002543b590 TRAP: 0700   Not tainted  (5.11.0-rc6=
+)
[  190.776517] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR:
44004882  XER: 20040123
[  190.776550] CFAR: c0000000006a0e2c IRQMASK: 0=20
               GPR00: c000000000475028 c00000002543b830 c000000002127000
0000000000000010=20
               GPR04: 0000000000000000 0000000000000010 0000000000000000
ffffffffffffffff=20
               GPR08: ffffffffffff0000 0000000000000000 0000000000000000
0000000000000000=20
               GPR12: c0000000006a1240 c00000001ec71200 0000000000000000
00007fffc61db2a4=20
               GPR16: 000000000ee6b280 00007fffc61db210 0000000000000000
0000000000000000=20
               GPR20: 0000000000000000 0000000000000000 0000000000000000
c0000000012c4a40=20
               GPR24: 0000000000000000 0000000000000001 ffffffffffffffff
c0000000225c22c0=20
               GPR28: c00000002543b9c0 c00000000b92aaa0 0000000000000001
c00c000000134880=20
[  190.776653] NIP [c0000000006a0f20] iomap_page_release+0x220/0x2a0
[  190.776661] LR [c0000000006a0df4] iomap_page_release+0xf4/0x2a0
[  190.776667] Call Trace:
[  190.776672] [c00000002543b830] [c0000000006a1494]
iomap_invalidatepage+0x254/0x2c0 (unreliable)=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[  190.776683] [c00000002543b880] [c000000000475028]
truncate_cleanup_page+0xa8/0x1d0
[  190.776694] [c00000002543b8b0] [c000000000475e7c]
truncate_inode_pages_range+0x22c/0x9d0
[  190.776703] [c00000002543bac0] [c0000000005e2818] evict+0x218/0x230
[  190.776713] [c00000002543bb00] [c0000000005e28c0] dispose_list+0x90/0xe0
[  190.776722] [c00000002543bb40] [c0000000005e2ab4] evict_inodes+0x1a4/0x2=
70
[  190.776731] [c00000002543bbe0] [c0000000005b1af0]
generic_shutdown_super+0x70/0x170
[  190.776740] [c00000002543bc60] [c0000000005b1f08] kill_block_super+0x38/=
0xb0
[  190.776750] [c00000002543bc90] [c0000000005b3380]
deactivate_locked_super+0x80/0x140
[  190.776759] [c00000002543bcd0] [c0000000005ee64c] cleanup_mnt+0x15c/0x240
[  190.776768] [c00000002543bd20] [c00000000019a3a4] task_work_run+0xb4/0x1=
20
[  190.776778] [c00000002543bd70] [c000000000024ca4]
do_notify_resume+0x164/0x170
[  190.776788] [c00000002543bda0] [c00000000003b51c]
syscall_exit_prepare+0x24c/0x390
[  190.776797] [c00000002543be10] [c00000000000d380]
system_call_vectored_common+0x100/0x26c
[  190.776806] Instruction dump:
[  190.776812] 4bf01109 60000000 2c3e0000 e8610028 4082fea0 4bdce3d5 600000=
00
4bfffe94
[  190.776833] 3869ffff 60000000 4bfffe50 60420000 <0fe00000> 3c82ff1b 7fe3=
fb78
38844860
[  190.776854] irq event stamp: 4768
[  190.776859] hardirqs last  enabled at (4767): [<c000000000542b04>]
__slab_free+0x414/0x610
[  190.776868] hardirqs last disabled at (4768): [<c0000000000098f4>]
program_check_common_virt+0x304/0x360=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
[  190.776876] softirqs last  enabled at (4626): [<c00000000060889c>]
wb_queue_work+0x11c/0x300=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[  190.776884] softirqs last disabled at (4622): [<c000000000608824>]
wb_queue_work+0xa4/0x300
[  190.776892] ---[ end trace 9bf99780f0602898 ]---
[  190.776897] page:00000000b70f92be refcount:2 mapcount:0
mapping:0000000084261c98 index:0xa pfn:0x4d22=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[  190.776907] aops:xfs_address_space_operations [xfs] ino:458aa
[  190.776962] flags: 0x13ffff800000013(locked|referenced|lru)
[  190.776970] raw: 013ffff800000013 c00c0000000d6e48 c00c000000136088
c0000000225c22c0
[  190.776978] raw: 000000000000000a 0000000000000000 00000002ffffffff
c0000000160bb000
[  190.776984] page dumped because: iomap_page_release:PageUptodate
[  190.776989] pages's memcg:c0000000160bb000
[  190.849634] XFS (dm-0): Unmounting Filesystem

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
