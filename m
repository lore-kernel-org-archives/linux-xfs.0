Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4385CC43217
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 044DC22E01
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392035AbhALHmQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 02:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392022AbhALHmQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 02:42:16 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200B6C0617AB;
        Mon, 11 Jan 2021 23:41:14 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id c22so864308pgg.13;
        Mon, 11 Jan 2021 23:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vV7ogy9DCpvjr84rlrd0TpasCPPF/5GUSbpu487OVVk=;
        b=s8vZsOvVMKerawLCPqQGs2PlCzjQM4VeX7lm8dRY+bIDAQocei8ze6hTLJBcP1sXaM
         ezyAdpbUTPAXI7p6dysejWYbjzGBS2IUSB1c4H0AzDYCS3iJM5p5Ps8wQ9b7ISTOPVSH
         QSFPpKM9OlAF06yjXzoR4ClYXsCl296Vgt0/Mmg3iGhk+zz/2cvRlbRyo5wja+0Adcsu
         FtpyI3HapKACh0WMUyZEuyt679XJckt7DC5uGxicA30mDovNoB824DRAQoMLPfC7yo/F
         VfQeAhRz82982uMPc22upG4Ff0N2tEMNt4GnoQA+JUL89vUgDgdwQwFAwl3TPTJdqQfe
         rU0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vV7ogy9DCpvjr84rlrd0TpasCPPF/5GUSbpu487OVVk=;
        b=Q4S/cVbsRQYzndasMFwDz6SWPaIsr9BV/OfNiLYFqnb5LwVDbSAVveVIkbXix/6XkO
         9VpbTzwldhgUeHm9g53vJ67SmQbP0+8MelPTWJzHT5wk1rLysQixjUDUK2Aov8llNbHR
         YhZY2/gRPN1t5rVVo+N7AvPBpuIhvPDe02c/0bA2BwAeAGbrBZ/bx1ZcA2gY/EuChZ6S
         rxHyTvoPmRPPk33EHiGu4NPQlvYz6aVOkHPy2Mws4SmFazDEjNEvca9fDhRUQTeceoK3
         GejXgJIac6X5tc64Fac7lAwgcsg/IudWBlfUPeoBxIB6r9DSiF6OfFU2MsrRwNERHsuz
         xRGA==
X-Gm-Message-State: AOAM5316U/N7U6NXWpe3rWHxB6nuAnL4HO/ohnSCMSKVR703JXd7p62O
        YBQfduLtJ6oIYtbllM2vJ44ESKcLHkc=
X-Google-Smtp-Source: ABdhPJz7thilcvEEvy2xSDKmiVgmLPlgrLkjq4WN1RVuFPMjtTyl4kiR0Dq+ekbmD5e1eIOf5tKn7g==
X-Received: by 2002:a63:101e:: with SMTP id f30mr3582264pgl.95.1610437273577;
        Mon, 11 Jan 2021 23:41:13 -0800 (PST)
Received: from localhost.localdomain ([122.171.39.105])
        by smtp.gmail.com with ESMTPSA id mj5sm1962340pjb.20.2021.01.11.23.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 23:41:13 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V3 11/11] xfs: Stress test with bmap_alloc_minlen_extent error tag enabled
Date:   Tue, 12 Jan 2021 13:10:27 +0530
Message-Id: <20210112074027.10311-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112074027.10311-1-chandanrlinux@gmail.com>
References: <20210112074027.10311-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a stress test that executes fsstress with
bmap_alloc_minlen_extent error tag enabled.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/531     | 84 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/531.out |  7 ++++
 tests/xfs/group   |  1 +
 3 files changed, 92 insertions(+)
 create mode 100755 tests/xfs/531
 create mode 100644 tests/xfs/531.out

diff --git a/tests/xfs/531 b/tests/xfs/531
new file mode 100755
index 00000000..fd92c3ea
--- /dev/null
+++ b/tests/xfs/531
@@ -0,0 +1,84 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 531
+#
+# Execute fsstress with bmap_alloc_minlen_extent error tag enabled.
+#
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
+. ./common/inject
+. ./common/populate
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_xfs_debug
+_require_test_program "punch-alternating"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+
+echo "Format and mount fs"
+_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+
+echo "Consume free space"
+fillerdir=$SCRATCH_MNT/fillerdir
+nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
+nr_free_blks=$((nr_free_blks * 90 / 100))
+
+_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 >> $seqres.full 2>&1
+
+echo "Create fragmented filesystem"
+for dentry in $(ls -1 $fillerdir/); do
+	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
+done
+
+echo "Inject bmap_alloc_minlen_extent error tag"
+_scratch_inject_error bmap_alloc_minlen_extent 1
+
+echo "Scale fsstress args"
+args=$(_scale_fsstress_args -p $((LOAD_FACTOR * 75)) -n $((TIME_FACTOR * 1000)))
+
+echo "Execute fsstress in background"
+$FSSTRESS_PROG -d $SCRATCH_MNT $args \
+		 -f bulkstat=0 \
+		 -f bulkstat1=0 \
+		 -f fiemap=0 \
+		 -f getattr=0 \
+		 -f getdents=0 \
+		 -f getfattr=0 \
+		 -f listfattr=0 \
+		 -f mread=0 \
+		 -f read=0 \
+		 -f readlink=0 \
+		 -f readv=0 \
+		 -f stat=0 \
+		 -f aread=0 \
+		 -f dread=0 > /dev/null 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/531.out b/tests/xfs/531.out
new file mode 100644
index 00000000..67f40654
--- /dev/null
+++ b/tests/xfs/531.out
@@ -0,0 +1,7 @@
+QA output created by 531
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Inject bmap_alloc_minlen_extent error tag
+Scale fsstress args
+Execute fsstress in background
diff --git a/tests/xfs/group b/tests/xfs/group
index 289a082d..f09c742b 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -528,6 +528,7 @@
 528 auto quick reflink
 529 auto quick reflink
 530 auto quick
+531 auto stress
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
-- 
2.29.2

