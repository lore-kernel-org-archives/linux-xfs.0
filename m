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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13EAFC4332B
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D26FB22DFA
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbhALHmM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 02:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387522AbhALHmL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 02:42:11 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B73C0617A6;
        Mon, 11 Jan 2021 23:41:04 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id j1so963952pld.3;
        Mon, 11 Jan 2021 23:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vfcHfUVSSoz92RXngnOC7EatAp4YfY5+S3rf8SFIR2A=;
        b=iU4vZ5sfkA+BbSFuJKI53TCJHJOnn5Vjmc1/qQvEMjeKIRawhqslQ3uHS2hREjUqNB
         XBVShY9qkKlodUpPFdWk3ta8KSe7g15A1qjdXel/+zbcYusasOnjmsR+E5vHE1WRytiX
         +BRpTFsRuvGBcBKtN7CNjylJmZ2wZzmSdb1J5fyVObSbPuhgOIZbaHZ55yqLE8x4TIVh
         38OrbO8yMSOKd/gju0+qUfqQ41J5tYMFY3HGxEtn8YpJHKq0Upw1UvlEnjWHhyeMFMBA
         mUixGAw573nuZdki2t/20BGuhMDEFSXTNu+jCyUc26Msv9JVUjeL9Ce4clA8IRUr0BZq
         ceoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vfcHfUVSSoz92RXngnOC7EatAp4YfY5+S3rf8SFIR2A=;
        b=awNBviaplwnlAkhYEpFc/k3aUaR89VohbXexHyhmKQGKkQnGRsGxqPxPe73mvbj69E
         S6NZbYrJnR3fwAjI/tKkz36K6IRYP4JaM8nRwWPNYiBLqlopeKGbBQmRWepQ7Dwddl1f
         rhbpZXLGUqe7DTPAcJNp18hZ8KmaeecGHsqjuZlqpf0nblCj3mUQYdLUTOC/gBBhhbvS
         xVDDRe/poJkzLWLcyWQEzRtsTrlLvavzbh0kOq19qAPj7tZaBIRMOufbp2v76UXBpbmn
         hcaIYSVSrFJFRYuVzEgcQhoZr+qh4P1NsLAl3NUwboKZl1cEJ+jSlbDh3KUmf7gXCan/
         B0Aw==
X-Gm-Message-State: AOAM530mZEP/MntL4Nb1xmmArPIkc5aYhSab2gHD9VVbujXdH6qttqLS
        2iXXQXyZDaedjiydmzcFfD5bKFBUtPw=
X-Google-Smtp-Source: ABdhPJx9n90fsIe9F2vkkqBJun7C0dvuoGv7ZVjuAbDjMchLY4mCz8dmEtq8VLjhvMfpFJZKr16cog==
X-Received: by 2002:a17:90a:cb0b:: with SMTP id z11mr3148560pjt.101.1610437264230;
        Mon, 11 Jan 2021 23:41:04 -0800 (PST)
Received: from localhost.localdomain ([122.171.39.105])
        by smtp.gmail.com with ESMTPSA id mj5sm1962340pjb.20.2021.01.11.23.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 23:41:03 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V3 07/11] xfs: Check for extent overflow when writing to unwritten extent
Date:   Tue, 12 Jan 2021 13:10:23 +0530
Message-Id: <20210112074027.10311-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112074027.10311-1-chandanrlinux@gmail.com>
References: <20210112074027.10311-1-chandanrlinux@gmail.com>
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
index 00000000..cd67bce4
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
+nr_blks=15
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
+	if (( $nextents > 10 )); then
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
index 00000000..3597ad92
--- /dev/null
+++ b/tests/xfs/527.out
@@ -0,0 +1,11 @@
+QA output created by 527
+Format and mount fs
+Inject reduce_max_iextents error tag
+* Buffered write to unwritten extent
+Fallocate 15 blocks
+Buffered write to every other block of fallocated space
+Verify $testfile's extent count
+* Direct write to unwritten extent
+Fallocate 15 blocks
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

