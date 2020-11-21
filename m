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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB083C71156
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B4E922269
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XA0cThDH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgKUIYE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Nov 2020 03:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgKUIYD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Nov 2020 03:24:03 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E046C0613CF;
        Sat, 21 Nov 2020 00:24:02 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id g7so10187171pfc.2;
        Sat, 21 Nov 2020 00:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eZ5mUiZxvU45oCmeB9macPQYL8ePYS3CM7WPraEjVoA=;
        b=XA0cThDHW6jjt5n5OFHGLF3fUWI0XxakyW+m6+KkEg2ejePJ+DgI/+RQcX1J2xGrZU
         VO9bNpUxHeFpZz34S60vtNq5S00dyNQZyaA7koijScOZmiwnQ+EDf02zSsYaqYcpC/5q
         ycQ5hSFDBI6vE2lLxF7CJaoI1jqdQP1VRmPWvdy0fHgLYcs1rFQvKBEm7py599dBhaSb
         g0J9WzPdo+lJID9HyMnIxzGMQ2EOSmHq9ogL7bMn1a8ovMlTPj9TS3RmOmscEL9s7A4o
         bWw+d1yVTPxsvfWPrqTYZFd0d6OhPeopIKaIk1EvEp8EjMbhh7up1QHCZKjfJWNFms2x
         DEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eZ5mUiZxvU45oCmeB9macPQYL8ePYS3CM7WPraEjVoA=;
        b=okDS/xV+idVLjf3cFTcqJ0DeHDypShatEqSBotHojtkLvH4YmjFxBxsLwcUevnIYBl
         vuQ6IQ2IShxe+3W9cKla1sADBFqLTK3O6CkB1U1TFgCiCCH9hGzfHqS55k88VVJnNItN
         SwfBRyOgEBybP/dPosCKxQ23NcVOJNUdO6GfPjqJFCTYxehFPeLwK6J4zn8nGHmsQ+Nh
         EdnbS5D4seLESo9cL9wlGLce9wNQAYeMj/Nvi9CzH3AWaUANjr0qln6mWe/wlFHVSA26
         4wjq7I6/O67e8NCC3uKGQiBtcInzomNgn9cn8ADWedf9cUGj5utN/fzUhr/gcfCdCxyC
         gxZA==
X-Gm-Message-State: AOAM531/tvWGAwZLpcyyzPkz1uPUfFGWvqOkIC0RM4DGpOFvwxMeRDOI
        5x4DuLB/FYimL6YB8s2HgqDre9lebY8=
X-Google-Smtp-Source: ABdhPJwsm6UbpWJMophK/bZHqyXafo+uOdJfrzC4+TkqtQyTGeLnl4aljgdeFib7VJOIaDoe43owFA==
X-Received: by 2002:a17:90a:a50b:: with SMTP id a11mr14249697pjq.170.1605947041813;
        Sat, 21 Nov 2020 00:24:01 -0800 (PST)
Received: from localhost.localdomain ([122.167.41.102])
        by smtp.gmail.com with ESMTPSA id e22sm6167148pfd.153.2020.11.21.00.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 00:24:01 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH V2 07/11] xfs: Check for extent overflow when writing to unwritten extent
Date:   Sat, 21 Nov 2020 13:53:28 +0530
Message-Id: <20201121082332.89739-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201121082332.89739-1-chandanrlinux@gmail.com>
References: <20201121082332.89739-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when writing to an unwritten extent.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/527     | 89 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/527.out | 11 ++++++
 tests/xfs/group   |  1 +
 3 files changed, 101 insertions(+)
 create mode 100755 tests/xfs/527
 create mode 100644 tests/xfs/527.out

diff --git a/tests/xfs/527 b/tests/xfs/527
new file mode 100755
index 00000000..175e7ede
--- /dev/null
+++ b/tests/xfs/527
@@ -0,0 +1,89 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 527
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# writing to an unwritten extent.
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
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_xfs_debug
+_require_xfs_io_command "falloc"
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "Format and mount fs"
+_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+
+testfile=${SCRATCH_MNT}/testfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+nr_blks=40
+
+for io in Buffered Direct; do
+	echo "* $io write to unwritten extent"
+
+	echo "Fallocate $nr_blks blocks"
+	$XFS_IO_PROG -f -c "falloc 0 $((nr_blks * bsize))" $testfile >> $seqres.full
+
+	if [[ $io == "Buffered" ]]; then
+		xfs_io_flag=""
+	else
+		xfs_io_flag="-d"
+	fi
+
+	echo "$io write to every other block of fallocated space"
+	for i in $(seq 1 2 $((nr_blks - 1))); do
+		$XFS_IO_PROG -f -s $xfs_io_flag -c "pwrite $((i * bsize)) $bsize" \
+		       $testfile >> $seqres.full 2>&1
+		[[ $? != 0 ]] && break
+	done
+
+	echo "Verify \$testfile's extent count"
+	nextents=$($XFS_IO_PROG -c 'stat' $testfile | grep nextents)
+	nextents=${nextents##fsxattr.nextents = }
+	if (( $nextents > 35 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+		exit 1
+	fi
+
+	rm $testfile
+done
+
+# super_block->s_wb_err will have a newer seq value when compared to "/"'s
+# file->f_sb_err. Consume it here so that xfs_scrub can does not error out.
+$XFS_IO_PROG -c syncfs $SCRATCH_MNT >> $seqres.full 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/527.out b/tests/xfs/527.out
new file mode 100644
index 00000000..d59e7047
--- /dev/null
+++ b/tests/xfs/527.out
@@ -0,0 +1,11 @@
+QA output created by 527
+Format and mount fs
+Inject reduce_max_iextents error tag
+* Buffered write to unwritten extent
+Fallocate 40 blocks
+Buffered write to every other block of fallocated space
+Verify $testfile's extent count
+* Direct write to unwritten extent
+Fallocate 40 blocks
+Direct write to every other block of fallocated space
+Verify $testfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index 0e98d623..c17bc140 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -524,6 +524,7 @@
 524 auto quick punch zero insert collapse
 525 auto quick attr
 526 auto quick dir hardlink symlink
+527 auto quick
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
-- 
2.29.2

