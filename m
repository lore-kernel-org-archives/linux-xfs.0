Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BCCFC6379D
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D9672225B
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BtaJfDqO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbgKUIYO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Nov 2020 03:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbgKUIYN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Nov 2020 03:24:13 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC49C0613CF;
        Sat, 21 Nov 2020 00:24:12 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id 18so6151148pli.13;
        Sat, 21 Nov 2020 00:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FZgARtFP3MafucsdIxRriBvkxf7XoFVmTv9PLFeynHY=;
        b=BtaJfDqOtZiJYyaUxTulMy1/OYKrqs7vthgS3xU9AWEfuPyWzsXO8LUfNNJFR7Xywj
         E2fDQEKHlWWyQVyIWJzLfQU7jDY/ytNhhV286VXXoaY7UQAFfZKWzL2lFABMQgutFQoX
         5cNFSYpqHvfld2f4wxSw4KPwU/7QULl1nf9U0me+5za7B4W1CQIf73VamPd4SVBRgU2Q
         d2fq9lda16XMeHUH+QwpaemmzdrJuKeKSuXBgfEqmCDq6qw2WvILzX3D/no/e+x6R65F
         sn47NuWnGPRwKj1sZtmCfzVClJZG48Mz40lsZjBjwjKokmXw1QSlO3UFnob9sUfPYt2k
         0rJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FZgARtFP3MafucsdIxRriBvkxf7XoFVmTv9PLFeynHY=;
        b=qALF7eUVLWv0VX7od64FSML3C1Rbpm4Wpx/FsZcACSNQg1s0PrFBSg/ROK0n9yLGVn
         Xpq1zvODupRWP+KFbxuuAJxJEjxwL8W7iSIgGG9mkJxbEfX1uNjf9XSpkchtFmRSxJ5R
         pdFpQbGf10t0uTRQPQHe9JE9MU1dzdjnBNGUmyvji/eNKJCrosjubb2zQXJRvgUuphHu
         MBBqjvWLtUFUhOkYICJgVtQOclrsT30+nP092vdpxXUEkb/N8byQZnaDXfGRJngXsv0f
         AfCm7DDL+vHLqMvrw18PmyafEYh9DqjQyQPNyjk29jBjufysTJ5Tnsd2RyUMJyAjlApY
         oNrw==
X-Gm-Message-State: AOAM533QdIFVBBN/A6fugMfnwuznr9Kts0vBQkLOLvubVdY44+IAzzwI
        y5wSqumR8gbVYl+oKJDkwnfQfkAi8h4=
X-Google-Smtp-Source: ABdhPJyck96xRpxghgCuwFMrJzEey0Raijd0xeJHBxMF+/0PFKWEYebz27qZWutZNrMzaVL0EZRV8w==
X-Received: by 2002:a17:902:864c:b029:d8:b3b1:b91c with SMTP id y12-20020a170902864cb02900d8b3b1b91cmr17657160plt.79.1605947051699;
        Sat, 21 Nov 2020 00:24:11 -0800 (PST)
Received: from localhost.localdomain ([122.167.41.102])
        by smtp.gmail.com with ESMTPSA id e22sm6167148pfd.153.2020.11.21.00.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 00:24:11 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH V2 11/11] xfs: Stress test with with bmap_alloc_minlen_extent error tag enabled
Date:   Sat, 21 Nov 2020 13:53:32 +0530
Message-Id: <20201121082332.89739-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201121082332.89739-1-chandanrlinux@gmail.com>
References: <20201121082332.89739-1-chandanrlinux@gmail.com>
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
index 00000000..983524b4
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
+args=$(_scale_fsstress_args -p 75 -n 10000)
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

