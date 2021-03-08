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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1CAC1550C
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 342BD65225
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhCHPwE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhCHPvt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 10:51:49 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AA6C06174A;
        Mon,  8 Mar 2021 07:51:49 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id i14so3246765pjz.4;
        Mon, 08 Mar 2021 07:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y0Z+s7Fjcy2Im2UyVPHCdibGR473jRuqO1r2vb39Jps=;
        b=kmwh4hScomO48Ui0naYsF5TzL9y4isxsbvPGTXf4/HUQFj2Kj4otuAIBdrGXz55YCc
         63TEOqB44ifmVlJA4v1ic/lewkfQqavAg87ZmR8H9Dp6t3Dg2KgHIAm+GyVfbMV+PN1t
         WoXAxA9oV5P219iBrThB3vloqh9rs3awkiAOmfqGH1GNEiurkNSMfsroV15WKCuELop3
         0izC+pKJBBcVHsJIZGxjwFZ2uw9se41tmDhhcPRo7cVbAY0RAhstHSvChfvLt4Eq2mFk
         onNKLp/RfZ5+NqaAdT4Nj3WGxucGvA1m0JPfSP9aSpZcKaeANnVFR27eYWIyfYn3uzi2
         UFkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y0Z+s7Fjcy2Im2UyVPHCdibGR473jRuqO1r2vb39Jps=;
        b=FHRgiqFzNXS5L8tGSkM6MGn/lL9O0TKQGQQ2646U0aKNf37VeKmWn1FCxyNEaN/Ca9
         D3Xazx9fdrL4+QHhTBFwobuSg3hHD1USNq1AMdWx1w8pQKnX5l4cZdDLOXfsBvAo6SBV
         lPJgr9bh55/0ehcBLqXwftJzGobhh1Cibfemg2UaIn7Dbv++Lyec7k9HHuz5POmiyrhW
         Z0nL1ZokdNxkCl2CMNE2OpdlyNXc7IEpsnWwToPJg4ZyDjqR/KlQytntKKWKmWGPyZej
         f5FjVYlCNoElgbaaDaRYHJLlEN8nkNwZz8RwPuK1HNRuipnSASvbBqgiNfQW715PB53H
         z9zw==
X-Gm-Message-State: AOAM5320aTaUZUlIW1ECdBUSWGRiynssMkqnZDv9409Q3GDdl8l7uj2O
        ZPjZRXNoxFnofG51aGbXVAQhwubWwC8=
X-Google-Smtp-Source: ABdhPJwJnoc0z0XgrK5Bq5d3gRq+HN/V/MNwluJZOoLbHNaHPSxiBT9tsujfmiBnEKYDT/whSPIbRg==
X-Received: by 2002:a17:902:6b87:b029:dc:3402:18af with SMTP id p7-20020a1709026b87b02900dc340218afmr21922840plk.29.1615218708849;
        Mon, 08 Mar 2021 07:51:48 -0800 (PST)
Received: from localhost.localdomain ([122.182.238.13])
        by smtp.gmail.com with ESMTPSA id s4sm11086378pji.2.2021.03.08.07.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:51:48 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V5 13/13] xfs: Stress test with bmap_alloc_minlen_extent error tag enabled
Date:   Mon,  8 Mar 2021 21:21:11 +0530
Message-Id: <20210308155111.53874-14-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308155111.53874-1-chandanrlinux@gmail.com>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a stress test that executes fsstress with
bmap_alloc_minlen_extent error tag enabled.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/537     | 84 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/537.out |  7 ++++
 tests/xfs/group   |  1 +
 3 files changed, 92 insertions(+)
 create mode 100755 tests/xfs/537
 create mode 100644 tests/xfs/537.out

diff --git a/tests/xfs/537 b/tests/xfs/537
new file mode 100755
index 00000000..77fa60d9
--- /dev/null
+++ b/tests/xfs/537
@@ -0,0 +1,84 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 537
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
diff --git a/tests/xfs/537.out b/tests/xfs/537.out
new file mode 100644
index 00000000..19633a07
--- /dev/null
+++ b/tests/xfs/537.out
@@ -0,0 +1,7 @@
+QA output created by 537
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Inject bmap_alloc_minlen_extent error tag
+Scale fsstress args
+Execute fsstress in background
diff --git a/tests/xfs/group b/tests/xfs/group
index ba674a58..5c827727 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -534,3 +534,4 @@
 534 auto quick reflink
 535 auto quick reflink
 536 auto quick
+537 auto stress
-- 
2.29.2

