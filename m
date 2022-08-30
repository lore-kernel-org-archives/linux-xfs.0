Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2695EC0502E
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 04:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiH3Eo6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 00:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiH3Eo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 00:44:56 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84472DF75;
        Mon, 29 Aug 2022 21:44:52 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id m5so7621271qkk.1;
        Mon, 29 Aug 2022 21:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=/5yLKdqpVqPISZ3YvZdWaquYYZHMUDBBawb75HBnwUA=;
        b=HcOqz5D+uOV+j2xulew0dLUi4HHbnOIOWMebIwWujSaNF/amfjGLqDSCnZ0YcK5f/q
         Z2z+fE7LBe+Nn/PeEQbda3f5cVKPCJML5gyOENtVTeWxNqU+Kxzaum8b+/RksIX9zbNW
         IqzCmJ/EkQGgJ0T7IJJgQqRwzLroiaWbZN7sUA/6w+OlRPWTuS3HqBY5wRiMEEpf6TZ5
         BQhd42R9vH0oY+ffgB5hXocNbRcV0TXy7PdL8rqYqrWU4ripTu6j4K27OoV4mjBu8+m3
         7YQW7xAc7ItEeF9n5/74g0ifRXb4mHKhjMaf+4ySjAzwK6LIvejnEcAKtdMIQPqc6Fll
         qVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=/5yLKdqpVqPISZ3YvZdWaquYYZHMUDBBawb75HBnwUA=;
        b=E7DAbTa4fcKC3M/lk+XX34CQEJ6YYJzsPRscWYjMojbvjBflbgkkGRI4AX408I53Pn
         9VHWCq6Swvw6usBIiWkCkrQ3LmfgSUKfzIRuFiBP9/4GtyYJ2/GBckORLXMkRstvWGuK
         xmrBDmWQgRkgaopHdb/E3xiaC6pfrxDV3+dhwSCDmP0/z70czD6VBOWAjMpzBJpEOxJj
         g4BKOc2k+KqU7Op/TigX96u7d1RR6LlorKT1nRsSnAVO3n8VuvPyYaj62YXZRIrImsNk
         Q+LFhxitfkDW0nU+uTMCQwwt8k0kdmGmXMeMHygJGhBSB4QSSra20ByJE27MJzOVGlUK
         EpgA==
X-Gm-Message-State: ACgBeo1P2kAOvArX3iASllhmqek0w3i0SxY7rtUx10PSePRYdH/w7z71
        jEoV+NL7vJyTAcLSVf6+aUK5rHa+HZ4=
X-Google-Smtp-Source: AA6agR467YZ8CSwbSrS09xhV8qAe9FYkyckHhh5BJLV5SPgd7DduFcEfH4jcmfPCn2+A2EjRuGihsA==
X-Received: by 2002:a37:b346:0:b0:6be:8a5c:c3cd with SMTP id c67-20020a37b346000000b006be8a5cc3cdmr4185729qkf.403.1661834691751;
        Mon, 29 Aug 2022 21:44:51 -0700 (PDT)
Received: from xzhouw.hosts.qa.psi.rdu2.redhat.com ([66.187.232.127])
        by smtp.gmail.com with ESMTPSA id bj11-20020a05620a190b00b006b60d5a7205sm7478585qkb.51.2022.08.29.21.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 21:44:51 -0700 (PDT)
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 3/4] tests/xfs: remove single-AG options
Date:   Tue, 30 Aug 2022 12:44:32 +0800
Message-Id: <20220830044433.1719246-4-jencce.kernel@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220830044433.1719246-1-jencce.kernel@gmail.com>
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since this xfsprogs commit:
	6e0ed3d19c54 mkfs: stop allowing tiny filesystems
Single-AG xfs is not allowed.

Remove agcount=1 from mkfs options and xfs/202 entirely.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
 tests/xfs/179     |  2 +-
 tests/xfs/202     | 40 ----------------------------------------
 tests/xfs/202.out | 29 -----------------------------
 tests/xfs/520     |  2 +-
 4 files changed, 2 insertions(+), 71 deletions(-)
 delete mode 100755 tests/xfs/202
 delete mode 100644 tests/xfs/202.out

diff --git a/tests/xfs/179 b/tests/xfs/179
index ec0cb7e5..f0169717 100755
--- a/tests/xfs/179
+++ b/tests/xfs/179
@@ -22,7 +22,7 @@ _require_cp_reflink
 _require_test_program "punch-alternating"
 
 echo "Format and mount"
-_scratch_mkfs -d agcount=1 > $seqres.full 2>&1
+_scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
diff --git a/tests/xfs/202 b/tests/xfs/202
deleted file mode 100755
index 5075d3a1..00000000
--- a/tests/xfs/202
+++ /dev/null
@@ -1,40 +0,0 @@
-#! /bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2009 Christoph Hellwig.
-#
-# FS QA Test No. 202
-#
-# Test out the xfs_repair -o force_geometry option on single-AG filesystems.
-#
-. ./common/preamble
-_begin_fstest repair auto quick
-
-# Import common functions.
-. ./common/filter
-. ./common/repair
-
-# real QA test starts here
-_supported_fs xfs
-
-# single AG will cause default xfs_repair to fail. This test is actually
-# testing the special corner case option needed to repair a single AG fs.
-_require_scratch_nocheck
-
-#
-# The AG size is limited to 1TB (or even less with historic xfsprogs),
-# so chose a small enough filesystem to make sure we can actually create
-# a single AG filesystem.
-#
-echo "== Creating single-AG filesystem =="
-_scratch_mkfs_xfs -d agcount=1 -d size=$((1024*1024*1024)) >/dev/null 2>&1 \
- || _fail "!!! failed to make filesystem with single AG"
-
-echo "== Trying to repair it (should fail) =="
-_scratch_xfs_repair
-
-echo "== Trying to repair it with -o force_geometry =="
-_scratch_xfs_repair -o force_geometry 2>&1 | _filter_repair
-
-# success, all done
-echo "*** done"
-status=0
diff --git a/tests/xfs/202.out b/tests/xfs/202.out
deleted file mode 100644
index c2c5c881..00000000
--- a/tests/xfs/202.out
+++ /dev/null
@@ -1,29 +0,0 @@
-QA output created by 202
-== Creating single-AG filesystem ==
-== Trying to repair it (should fail) ==
-Phase 1 - find and verify superblock...
-Only one AG detected - cannot validate filesystem geometry.
-Use the -o force_geometry option to proceed.
-== Trying to repair it with -o force_geometry ==
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-        - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
-Phase 7 - verify and correct link counts...
-done
-*** done
diff --git a/tests/xfs/520 b/tests/xfs/520
index d9e252bd..de70db60 100755
--- a/tests/xfs/520
+++ b/tests/xfs/520
@@ -60,7 +60,7 @@ force_crafted_metadata() {
 }
 
 bigval=100000000
-fsdsopt="-d agcount=1,size=512m"
+fsdsopt="-d size=512m"
 
 force_crafted_metadata freeblks 0 "agf 0"
 force_crafted_metadata longest $bigval "agf 0"
-- 
2.31.1

