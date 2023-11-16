Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217CEC5AE5B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344553AbjKPC3A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344555AbjKPC26 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:58 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC04618D;
        Wed, 15 Nov 2023 18:28:53 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1cc2575dfc7so2930905ad.1;
        Wed, 15 Nov 2023 18:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101733; x=1700706533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pPaczwKrAEj4PkbPm0Oczsi4qtUlUw4N63n1gSSfkA4=;
        b=T75NA4CNJgiNRf4G+/L/lr3iy6yLnZb6p7o0iPafgh9Q+aYyRpMdWWkqjJGeM0Fwok
         8khq4SZzv8PIneQh854I9z87PXnX7HyyLbIQZl9+UxYhEB/ExctrpFtbA+fxN06wrbEc
         8FHCVbRpcDGqOK/vECLnAI6bemfI2UOHq+gEedcp7+nvH88G3ixkmHHl9JYO3vL1cvYE
         uiVW6l1c2O2NP+WTWThYVG+vRzzUq83VpcSWOfEYoA6S/jZlMiLMyIolVHVqDWh/9NwJ
         UIfp6MULI9rzRvU1u1zphc9cvYReTDiweElcrC6P0owWsIMcLAW15MvLHcxie/a1Jprg
         1Z9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101733; x=1700706533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pPaczwKrAEj4PkbPm0Oczsi4qtUlUw4N63n1gSSfkA4=;
        b=OO5gSgigo2QekE6Pv1WTqhJJcXRafNj6X7RMGhd8Nwt/7/dAXoKVxJFvz+DxuXb/lC
         HVDVgohY6Z70eyltmTMMwfcAy2Khg/L42enuceWNg57txDtchjEMB1dbgz+l8Qx9omZj
         mwKO9npkLwp1ie73M2F9p7K6iw4COOkRlNmkn/P5550UhmJojWa1zP5dIS/lEpaXiWQ3
         lMBxJFYUBcQqYwmyzPsuQmkAuCk/iCFK31SCS1L7PfPLUzxSZHCLUHriwTZFFm0IG5Kn
         gnITbMSkY2vHHDzTm/gdFi6QhRLdfsWtO+9YCzrDDgXBmKpwAU67FCAI0uKSuhn2S7RE
         +UPA==
X-Gm-Message-State: AOJu0YwOLLcnRplCG3b3s8y5hTq7guNLOwkGb7rhz/wel9sZdelBnnt2
        w0FL5hOUKWHjJgUUSIjOh8hEDPjWYV9Q6g==
X-Google-Smtp-Source: AGHT+IHbq8O17Ow+J7xZNErLnfOlhCp8mU2feIQOkaKuWi0sx4+PAYhifDLmBbEKdJtABksTR7XNbw==
X-Received: by 2002:a17:903:2283:b0:1cc:3c2d:128c with SMTP id b3-20020a170903228300b001cc3c2d128cmr7534867plh.44.1700101733004;
        Wed, 15 Nov 2023 18:28:53 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:52 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        Guo Xuenan <guoxuenan@huawei.com>,
        Hou Tao <houtao1@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 15/17] xfs: fix exception caused by unexpected illegal bestcount in leaf dir
Date:   Wed, 15 Nov 2023 18:28:31 -0800
Message-ID: <20231116022833.121551-15-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231116022833.121551-1-leah.rumancik@gmail.com>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Guo Xuenan <guoxuenan@huawei.com>

[ Upstream commit 13cf24e00665c9751951a422756d975812b71173 ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2_leaf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index d9b66306a9a7..cb9e950a911d 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -146,6 +146,8 @@ xfs_dir3_leaf_check_int(
 	xfs_dir2_leaf_tail_t		*ltp;
 	int				stale;
 	int				i;
+	bool				isleaf1 = (hdr->magic == XFS_DIR2_LEAF1_MAGIC ||
+						   hdr->magic == XFS_DIR3_LEAF1_MAGIC);
 
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
 
@@ -158,8 +160,7 @@ xfs_dir3_leaf_check_int(
 		return __this_address;
 
 	/* Leaves and bests don't overlap in leaf format. */
-	if ((hdr->magic == XFS_DIR2_LEAF1_MAGIC ||
-	     hdr->magic == XFS_DIR3_LEAF1_MAGIC) &&
+	if (isleaf1 &&
 	    (char *)&hdr->ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
 		return __this_address;
 
@@ -175,6 +176,10 @@ xfs_dir3_leaf_check_int(
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
-- 
2.43.0.rc0.421.g78406f8d94-goog

