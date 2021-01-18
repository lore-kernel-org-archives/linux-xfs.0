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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C37C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D586F22581
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732328AbhARGWc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 01:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732262AbhARGWX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 01:22:23 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A56C061794;
        Sun, 17 Jan 2021 22:21:09 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id t6so8084163plq.1;
        Sun, 17 Jan 2021 22:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AGBhOkzc7abONTpUtgMEjxirIhOapL82Xzhyg1JPP1A=;
        b=GLokwA88TdhpVog/ezxJvyH90S9sQPOJ5I0BdKpXgBwwgq/b8W0REafwp+PS6RE3L1
         8VnOD1wDT1fn7IDMSjf7b35J5Y6wfjmkBrZweFMY1oMrVIGEKzE+JNlySiKf5TiXX5MP
         qEXznRFke1lSYzRWZ3wUewDJTCW3YAGuG7WPdQ5TcbhR5f3vj+0ClyCt9K1vJx5ZlHgs
         xKyk2fwMS0gFqIpJW6gAkXYi+YbcNww4AaA9zWFE/lyrlFJO3S7/DcpfJ+QQTO36Bh4j
         YUScdA13eG+6jQsFs6CIh3SrJFiDkfCeOV+SrFT5mkOVMeVFfCak8nh2/AukumC/Tv5B
         /ZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AGBhOkzc7abONTpUtgMEjxirIhOapL82Xzhyg1JPP1A=;
        b=iFn9VOZuTG8aLpp7hBpTNfahvjAOliKZP+2apQ9q27XyaQ3tIT8lIGuvbdOjMiQvAS
         QFUbRNbiNuG4vU39S/ChHBdxrQEJGuFzSCAORKo0Xoipk8ndVKICgLfD+1tKCJl3sdOF
         qDi3R6hdOit8JAp1tNLtEplq5zg/e562H2ktczvHXk8f1XcPucod0B2fU2jtd/0vf8sQ
         jLMmT4XKWJ9QgXO50egBRX28Oc8l/vpZED65MKkYzE33NmQexcwjBM9t8/Byv/+XADcC
         j/aDwEukiiWMxGSFaK+3hgsD5XcGwf9+3Fn+D7r1HSlvKMJ809+k8NBjYBbvOeEiaXVw
         eEvw==
X-Gm-Message-State: AOAM531c3HV72SpcJfCfXocAIFD6YxeRU3JZ67gov3xqm70goVXY6dUE
        slTAyVf7AbqjogVzQRwjxuZ+41FShg0=
X-Google-Smtp-Source: ABdhPJzoi8sBcRNyLJ5p/V4vdIHKmpIvfEFvejHWc3xfxzNIQ0XbPOvNcDX+nRtHhGpLDPnYV/fsQg==
X-Received: by 2002:a17:90a:a60d:: with SMTP id c13mr25067886pjq.11.1610950868686;
        Sun, 17 Jan 2021 22:21:08 -0800 (PST)
Received: from localhost.localdomain ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id t1sm14608423pfq.154.2021.01.17.22.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:21:08 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V4 11/11] xfs: Stress test with bmap_alloc_minlen_extent error tag enabled
Date:   Mon, 18 Jan 2021 11:50:22 +0530
Message-Id: <20210118062022.15069-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118062022.15069-1-chandanrlinux@gmail.com>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
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
index 81a15582..f4cb5af6 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -528,3 +528,4 @@
 528 auto quick reflink
 529 auto quick reflink
 530 auto quick
+531 auto stress
-- 
2.29.2

