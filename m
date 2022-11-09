Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B39C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiKICG0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiKICG0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:06:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A88663E1
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:06:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 722C3B81619
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206D9C433D6;
        Wed,  9 Nov 2022 02:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959582;
        bh=6dvSY4PFc5h4MgbCwlc8+JGMaNB7m6hJcI6ZZpacklE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FdlVOoyQ4WuLPaBQ8HITnS/+iwo5ADM8BtC+WDfrja/ZIqYKptMAlusgQLTMAKsth
         EPB/5c04rohDREoMqq1maLIUsq+mooKfwuE/4TEBdyASav0R9otLJgVfstP/CBwaix
         Pf3X9keG7DXljjY05vxJsh5A7LRiK7sDEpHpxTBK14SfgUgimp2BTNMd3mJOokRrRZ
         IRzfP55QK45mV5Cf96rGEmOJ9wfJT5yNaA9NfSsmo/+m8x9PRdgu5ITHRe8lTcf9do
         S/kNTp9gbn9WkF33GzkswQAx3MvDD6Tm/AETE0tNZy2Y3LgKFirfo4MObuPuzNXnln
         TQWHCTJrW1/tw==
Subject: [PATCH 07/24] xfs: fix exception caused by unexpected illegal
 bestcount in leaf dir
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Hou Tao <houtao1@huawei.com>, Guo Xuenan <guoxuenan@huawei.com>,
        linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:06:21 -0800
Message-ID: <166795958175.3761583.2285127671315785716.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Guo Xuenan <guoxuenan@huawei.com>

Source kernel commit: 0cb227895e6f8369c1a2b9110e291a35223b8de1

For leaf dir, In most cases, there should be as many bestfree slots
as the dir data blocks that can fit under i_size (except for [1]).

Root cause is we don't examin the number bestfree slots, when the slots
number less than dir data blocks, if we need to allocate new dir data
block and update the bestfree array, we will use the dir block number as
index to assign bestfree array, while we did not check the leaf buf
boundary which may cause UAF or other memory access problem. This issue
can also triggered with test cases xfs/473 from fstests.

According to Dave Chinner & Darrick's suggestion, adding buffer verifier
to detect this abnormal situation in time.
Simplify the testcase for fstest xfs/554 [1]

The error log is shown as follows:
==================================================================
BUG: KASAN: use-after-free in xfs_dir2_leaf_addname+0x1995/0x1ac0
Write of size 2 at addr ffff88810168b000 by task touch/1552
CPU: 5 PID: 1552 Comm: touch Not tainted 6.0.0-rc3+ #101
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
<TASK>
dump_stack_lvl+0x4d/0x66
print_report.cold+0xf6/0x691
kasan_report+0xa8/0x120
xfs_dir2_leaf_addname+0x1995/0x1ac0
xfs_dir_createname+0x58c/0x7f0
xfs_create+0x7af/0x1010
xfs_generic_create+0x270/0x5e0
path_openat+0x270b/0x3450
do_filp_open+0x1cf/0x2b0
do_sys_openat2+0x46b/0x7a0
do_sys_open+0xb7/0x130
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fe4d9e9312b
Code: 25 00 00 41 00 3d 00 00 41 00 74 4b 64 8b 04 25 18 00 00 00 85 c0
75 67 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00
f0 ff ff 0f 87 91 00 00 00 48 8b 4c 24 28 64 48 33 0c 25
RSP: 002b:00007ffda4c16c20 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe4d9e9312b
RDX: 0000000000000941 RSI: 00007ffda4c17f33 RDI: 00000000ffffff9c
RBP: 00007ffda4c17f33 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000941
R13: 00007fe4d9f631a4 R14: 00007ffda4c17f33 R15: 0000000000000000
</TASK>

The buggy address belongs to the physical page:
page:ffffea000405a2c0 refcount:0 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x10168b
flags: 0x2fffff80000000(node=0|zone=2|lastcpupid=0x1fffff)
raw: 002fffff80000000 ffffea0004057788 ffffea000402dbc8 0000000000000000
raw: 0000000000000000 0000000000170000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
ffff88810168af00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
ffff88810168af80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88810168b000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
^
ffff88810168b080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ffff88810168b100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================
Disabling lock debugging due to kernel taint
00000000: 58 44 44 33 5b 53 35 c2 00 00 00 00 00 00 00 78
XDD3[S5........x
XFS (sdb): Internal error xfs_dir2_data_use_free at line 1200 of file
fs/xfs/libxfs/xfs_dir2_data.c.  Caller
xfs_dir2_data_use_free+0x28a/0xeb0
CPU: 5 PID: 1552 Comm: touch Tainted: G    B              6.0.0-rc3+
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
<TASK>
dump_stack_lvl+0x4d/0x66
xfs_corruption_error+0x132/0x150
xfs_dir2_data_use_free+0x198/0xeb0
xfs_dir2_leaf_addname+0xa59/0x1ac0
xfs_dir_createname+0x58c/0x7f0
xfs_create+0x7af/0x1010
xfs_generic_create+0x270/0x5e0
path_openat+0x270b/0x3450
do_filp_open+0x1cf/0x2b0
do_sys_openat2+0x46b/0x7a0
do_sys_open+0xb7/0x130
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fe4d9e9312b
Code: 25 00 00 41 00 3d 00 00 41 00 74 4b 64 8b 04 25 18 00 00 00 85 c0
75 67 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00
f0 ff ff 0f 87 91 00 00 00 48 8b 4c 24 28 64 48 33 0c 25
RSP: 002b:00007ffda4c16c20 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe4d9e9312b
RDX: 0000000000000941 RSI: 00007ffda4c17f46 RDI: 00000000ffffff9c
RBP: 00007ffda4c17f46 R08: 0000000000000000 R09: 0000000000000001
R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000941
R13: 00007fe4d9f631a4 R14: 00007ffda4c17f46 R15: 0000000000000000
</TASK>
XFS (sdb): Corruption detected. Unmount and run xfs_repair

[1] https://lore.kernel.org/all/20220928095355.2074025-1-guoxuenan@huawei.com/
Reviewed-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2_leaf.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 8827c96c18..5da66006cb 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -144,6 +144,8 @@ xfs_dir3_leaf_check_int(
 	xfs_dir2_leaf_tail_t		*ltp;
 	int				stale;
 	int				i;
+	bool				isleaf1 = (hdr->magic == XFS_DIR2_LEAF1_MAGIC ||
+						   hdr->magic == XFS_DIR3_LEAF1_MAGIC);
 
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
 
@@ -156,8 +158,7 @@ xfs_dir3_leaf_check_int(
 		return __this_address;
 
 	/* Leaves and bests don't overlap in leaf format. */
-	if ((hdr->magic == XFS_DIR2_LEAF1_MAGIC ||
-	     hdr->magic == XFS_DIR3_LEAF1_MAGIC) &&
+	if (isleaf1 &&
 	    (char *)&hdr->ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
 		return __this_address;
 
@@ -173,6 +174,10 @@ xfs_dir3_leaf_check_int(
 		}
 		if (hdr->ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			stale++;
+		if (isleaf1 && xfs_dir2_dataptr_to_db(geo,
+				be32_to_cpu(hdr->ents[i].address)) >=
+				be32_to_cpu(ltp->bestcount))
+			return __this_address;
 	}
 	if (hdr->stale != stale)
 		return __this_address;

