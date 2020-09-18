Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94CBAC43465
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 03:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5383723730
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 03:30:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="irJgFIRc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgIRDa1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 23:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgIRDa1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 23:30:27 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D33BC061756;
        Thu, 17 Sep 2020 20:30:27 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l71so2634582pge.4;
        Thu, 17 Sep 2020 20:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X+BO0xYtoGHBxL8BfLbWyWU4SeZbFKS13VI/HSkqIhw=;
        b=irJgFIRcXV4MWZHHGqBNmF1wrUPBDy/NV8iqEAt+XttxvRJmdi1yfxfG75Xj+UuTOP
         qtHudGZ0KNWYZn2P5cGr5K5bofBhozolFrDjbqDS4PxxK9a9ruEJRSwn8tsFi7sgMzwh
         jUMaFt+HR09r9YTzMZJ6YoKIYJ5iUf5sGbQl3PVlqsF/GzeC0R3wCEqdr9bK0f1pW45r
         jDe+r4GA7ao2/naabu0TUcPfCp8DhlqrpmWT9GKnwEgcwFzepvJ3jTcv4rfigVFNPfYJ
         GXVS7WK+YWYZs38ybWQ87zwdRxt2a+/4ebaHuFFTD19qq39Q8cHz/gxXnOdBsfCn0nyX
         hMVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X+BO0xYtoGHBxL8BfLbWyWU4SeZbFKS13VI/HSkqIhw=;
        b=qSLGEjwXbYWe9jdRqkaX3i9+tfzD6Ie148ZX4zkx42EqyL7UBWZuAQ4oWBSLfIgHFu
         wShEEqlV3pSuqLHUvQn26+3lyF6Z8QB/EvnkP4r9nk5ot+bHlFufceXmea14DjqlzdZQ
         akEArw4l0ZlhgIKZ6PS8X6CgMS7rCb6uCkMyDEbEvnejnhzasavbtggQl6ljpRkGYTYZ
         kT8pnrGTg2EVw1WIT9OPQEx02prws1dU45QWDEqA0GJ7srkXQkP4rL72PM/TzDO5igDh
         Do5+ZkytG7lYu2xZ93d2/U5ztf6uIyebm60Q3fnGmGRMEO9uqCCaOyWBZkSJG8+G5Art
         n50w==
X-Gm-Message-State: AOAM533yA7l6FYXKBSFTwmdBjY5V5P8ow65evibc7txhvmGCM+iEosck
        29Teou9vfveg3pk+BO0ozYME/JxN7yY=
X-Google-Smtp-Source: ABdhPJwRr3UYtElKIZOZpbREKznaoubyGs9AJ6GSVplYjy8b+T0g6Y3Hx74cr8u4VDAMx+dtrWRDHQ==
X-Received: by 2002:a62:e90b:0:b029:13e:b622:3241 with SMTP id j11-20020a62e90b0000b029013eb6223241mr30135241pfh.12.1600399826748;
        Thu, 17 Sep 2020 20:30:26 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.164])
        by smtp.gmail.com with ESMTPSA id v21sm1111436pgl.39.2020.09.17.20.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 20:30:26 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, guaneryu@gmail.com,
        darrick.wong@oracle.com, zlang@redhat.com
Subject: [PATCH V3 2/2] xfs: Check if rt summary/bitmap buffers are logged with correct xfs_buf type
Date:   Fri, 18 Sep 2020 09:00:13 +0530
Message-Id: <20200918033013.10640-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918033013.10640-1-chandanrlinux@gmail.com>
References: <20200918033013.10640-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a test to check if growing a real-time device can end
up logging an xfs_buf with the "type" subfield of
bip->bli_formats->blf_flags set to XFS_BLFT_UNKNOWN_BUF. When this
occurs the following call trace is printed on the console,

XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
Call Trace:
 xfs_buf_item_format+0x632/0x680
 ? kmem_alloc_large+0x29/0x90
 ? kmem_alloc+0x70/0x120
 ? xfs_log_commit_cil+0x132/0x940
 xfs_log_commit_cil+0x26f/0x940
 ? xfs_buf_item_init+0x1ad/0x240
 ? xfs_growfs_rt_alloc+0x1fc/0x280
 __xfs_trans_commit+0xac/0x370
 xfs_growfs_rt_alloc+0x1fc/0x280
 xfs_growfs_rt+0x1a0/0x5e0
 xfs_file_ioctl+0x3fd/0xc70
 ? selinux_file_ioctl+0x174/0x220
 ksys_ioctl+0x87/0xc0
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x3e/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The kernel patch "xfs: Set xfs_buf type flag when growing summary/bitmap
files" is required to fix this issue.

Reviewed-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
Changelog:
V2 -> V3:
  1. Remove unnecessary invocation of _scratch_unmount at the end of the test.

V1 -> V2:
  1. Use _scratch_mkfs instead of invoking _mkfs_dev directly.
  2. Remove unnecessary comments introduced by "new" script.
  3. Add the new test under quick, growfs and realtime groups.
  
 tests/xfs/260     | 51 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/260.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 54 insertions(+)
 create mode 100755 tests/xfs/260
 create mode 100644 tests/xfs/260.out

diff --git a/tests/xfs/260 b/tests/xfs/260
new file mode 100755
index 00000000..1cafa368
--- /dev/null
+++ b/tests/xfs/260
@@ -0,0 +1,51 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 260
+#
+# Test to check if growing a real-time device can end up logging an xfs_buf with
+# the "type" subfield of bip->bli_formats->blf_flags set to
+# XFS_BLFT_UNKNOWN_BUF.
+#
+# This is a regression test for the kernel patch "xfs: Set xfs_buf type flag
+# when growing summary/bitmap files".
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_realtime
+
+_scratch_mkfs -r size=10M  >> $seqres.full
+
+_scratch_mount >> $seqres.full
+
+$XFS_GROWFS_PROG $SCRATCH_MNT >> $seqres.full
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/260.out b/tests/xfs/260.out
new file mode 100644
index 00000000..18ca517c
--- /dev/null
+++ b/tests/xfs/260.out
@@ -0,0 +1,2 @@
+QA output created by 260
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index b8374359..3b38a604 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -257,6 +257,7 @@
 257 auto quick clone
 258 auto quick clone
 259 auto quick
+260 auto quick growfs realtime
 261 auto quick quota
 262 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 263 auto quick quota
-- 
2.28.0

