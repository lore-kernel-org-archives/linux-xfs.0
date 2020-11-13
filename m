Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 179A9C63697
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 11:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD84D22254
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 11:30:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="opaNPkM8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgKML26 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 06:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgKML1u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 06:27:50 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5458C0617A7;
        Fri, 13 Nov 2020 03:27:48 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id e21so6840377pgr.11;
        Fri, 13 Nov 2020 03:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ag0ThtAmmIS0jZbX6kt+1QfXYKyDbhQi52bVA0ddi/U=;
        b=opaNPkM8jCXyu4MR+WZbDanu1VtFi3lBK3Sdgf9jfSxW8msKChmKpXPtuPIgr39FYN
         0B193QfkjIf/aM5I4CccV1Z9zxLUfBfh+CYr/cMiw6gI6kQMjobfyZvtZ1h1KCyuPPW7
         GzkOzW5EMOrBWAV7FSSx6tG8JjqTnV2+qZ+E6bteRnH5HAiSsZyza0JIOJkT9DJLc4tn
         ey/x6Y4XajKvfOCa/05hNy8NTT/pUvb8/TRlZn40G/aH2SdfqNwvTvIKA6isYUATQymx
         uH2kBn+PRbU5oykjnh4jzCGulEL9KCP2lgS0YFvRcDeZypsqlZCdxOAekhgr/+OOH4TE
         qXOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ag0ThtAmmIS0jZbX6kt+1QfXYKyDbhQi52bVA0ddi/U=;
        b=bw4AsEReB8tV1dsYkyifTVQl7NSh3ZJ/xlhC9G+a7d39QmB0G4WWQizo+Xe0XY82MF
         mCcjaPaSOZA9rDsHuJXghZTSXEXpjoeNqImcjwJsH/t4/XXLfsqRZLwxc5LlPa3BEo4/
         C/HFimyvmgGr3Ya3HjE2mR3EAyo9RtacHT8LABczoavdgFLzVU25g0+JQpjByBj3UIMi
         UdhpFX7PLhlfNz6T2xktOyMsnKSlgri4ClHhKBem0e/fVaq/2B/2YHhsm5BoghrPg2rC
         q85nmkELF9d4v4XEDTRpAjqA+xmmN8cztXF+zMsO03JIXZIjrz1qbnujvoH91ZQWMXc/
         ZTUA==
X-Gm-Message-State: AOAM532xuXr1l/gd7opo1aXqC2+0CCfm8TSFWqNRexCXngphQmBn00ZW
        Gjg94h93QXLYYfNTqOsKFreF1hhwv0I=
X-Google-Smtp-Source: ABdhPJwM82fkOnLldKAM5R0HP/zE+hB7E75joHAyIw7yXF3jazROKhheNZ3EPL8jNJA7uHmNR06QEg==
X-Received: by 2002:a17:90b:4683:: with SMTP id ir3mr2512765pjb.212.1605266868012;
        Fri, 13 Nov 2020 03:27:48 -0800 (PST)
Received: from localhost.localdomain ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id w131sm9410857pfd.14.2020.11.13.03.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 03:27:47 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH 07/11] xfs: Check for extent overflow when writing to unwritten extent
Date:   Fri, 13 Nov 2020 16:56:59 +0530
Message-Id: <20201113112704.28798-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113112704.28798-1-chandanrlinux@gmail.com>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when writing to an unwritten extent.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/527     | 125 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/527.out |  13 +++++
 tests/xfs/group   |   1 +
 3 files changed, 139 insertions(+)
 create mode 100755 tests/xfs/527
 create mode 100644 tests/xfs/527.out

diff --git a/tests/xfs/527 b/tests/xfs/527
new file mode 100755
index 00000000..f040aee4
--- /dev/null
+++ b/tests/xfs/527
@@ -0,0 +1,125 @@
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
+buffered_write_to_unwritten_extent()
+{
+	echo "* Buffered write to unwritten extent"
+
+	echo "Format and mount fs"
+	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	bsize=$(_get_block_size $SCRATCH_MNT)
+
+	testfile=${SCRATCH_MNT}/testfile
+
+	nr_blks=15
+
+	echo "Fallocate $nr_blks blocks"
+	xfs_io -f -c "falloc 0 $((nr_blks * bsize))" $testfile >> $seqres.full
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c "inject reduce_max_iextents" $SCRATCH_MNT
+
+	echo "Buffered write to every other block of fallocated space"
+	for i in $(seq 1 2 $((nr_blks - 1))); do
+		xfs_io -f -c "pwrite $((i * bsize)) $bsize" -c fsync $testfile \
+		       >> $seqres.full 2>&1
+		[[ $? != 0 ]] && break
+	done
+
+	testino=$(stat -c "%i" $testfile)
+
+	_scratch_unmount >> $seqres.full
+
+	echo "Verify \$testfile's extent count"
+
+	nextents=$(_scratch_get_iext_count $testino data || \
+			_fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+	fi
+}
+
+direct_write_to_unwritten_extent()
+{
+	echo "* Direct I/O write to unwritten extent"
+
+	echo "Format and mount fs"
+	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	bsize=$(_get_block_size $SCRATCH_MNT)
+
+	testfile=${SCRATCH_MNT}/testfile
+
+	nr_blks=15
+
+	echo "Fallocate $nr_blks blocks"
+	xfs_io -f -c "falloc 0 $((nr_blks * bsize))" $testfile >> $seqres.full
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c "inject reduce_max_iextents" $SCRATCH_MNT
+
+	echo "Direct I/O write to every other block of fallocated space"
+	for i in $(seq 1 2 $((nr_blks - 1))); do
+		xfs_io -f -d -c "pwrite $((i * bsize)) $bsize" $testfile \
+		       >> $seqres.full 2>&1
+		[[ $? != 0 ]] && break
+	done
+
+	testino=$(stat -c "%i" $testfile)
+
+	_scratch_unmount >> $seqres.full
+
+	echo "Verify \$testfile's extent count"
+
+	nextents=$(_scratch_get_iext_count $testino data || \
+			_fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+	fi
+}
+
+buffered_write_to_unwritten_extent
+direct_write_to_unwritten_extent
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/527.out b/tests/xfs/527.out
new file mode 100644
index 00000000..6aa5e9ed
--- /dev/null
+++ b/tests/xfs/527.out
@@ -0,0 +1,13 @@
+QA output created by 527
+* Buffered write to unwritten extent
+Format and mount fs
+Fallocate 15 blocks
+Inject reduce_max_iextents error tag
+Buffered write to every other block of fallocated space
+Verify $testfile's extent count
+* Direct I/O write to unwritten extent
+Format and mount fs
+Fallocate 15 blocks
+Inject reduce_max_iextents error tag
+Direct I/O write to every other block of fallocated space
+Verify $testfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index d089797b..627813fe 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -524,3 +524,4 @@
 524 auto quick punch zero insert collapse
 525 auto quick attr
 526 auto quick dir hardlink symlink
+527 auto quick
-- 
2.28.0

