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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5EAC4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8914065220
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhCHPwB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhCHPvl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 10:51:41 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E45C06174A;
        Mon,  8 Mar 2021 07:51:41 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n9so5701874pgi.7;
        Mon, 08 Mar 2021 07:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zfuKK7VesCcqGVw893PpgWt/azwkJyfREfeco+A63ng=;
        b=I3a+xj6jxhd/jETS3d7NHRdIpsYoTGrKxZJBu/3me5TFR6ZR+C7+eKVdcljminsLQi
         SMWBp9OO3JFUgtbU9+ITZ2emtWPAFx6clsfjD266n+UTzu69OZK0azT2XsfhxcPjNd0H
         6MTKZPX7oZNeXAGSfUWODzA0bkiYzv2Q5zTGprd1b9wNPJhTvuaVrZ7fV2Ut8e1B/Evd
         1SiEJ84syHukDkWZbwM6Emjh5N0p0Z/cTEB0GBfOk9Wu1mjJPEXkvwnON8xCXzUJPZi2
         FNuucBvX/0sAIt40xWGQ08VYRYlOXNzDRZJh+1x/MBmoDXmmUKrWcMjkchEwmA3pvJ90
         R0Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zfuKK7VesCcqGVw893PpgWt/azwkJyfREfeco+A63ng=;
        b=mfyiLicyr4/zbAubIQ/ho5x4JqtLleiq2NmEWHiKZfrXGxIBLIYvgW0xKikcZbXtBk
         5k8H029l2QEhxFSX/ZCxIpsM+dSwhvDilsb/p+eDkoFj8znh58gYw3u2HCiaQ81coTgp
         bvnH3UYRbrInsWtWjcxZvzwkl0GL+dp7O/kknOSJ6pOhYOgmcGlwdD2MRn8tq7WgWUAj
         ox0I0aZdRGeTzQvT8ZhLaIFloePcz0uKKsukpxEmR8u7Vf/ktvD04+LaDhvxZbRRWSWu
         SmMVKpgnYFn506Bj+g5dWS2ohgWhD2FdQhmCV0hEffTZ00zqcmiQeqr8Cnrcmclw4VgR
         en2Q==
X-Gm-Message-State: AOAM532KKPr79wX4fbC1bx4Wu1CgyXlVS2pgeyrpKCPcR/eEdQXOstyI
        CG6VcE8Ni1NKiXHKXwRkFHx457fxIv8=
X-Google-Smtp-Source: ABdhPJwzjrguriiCmzh3HLeaWYXBq2CPR6FXbetjCOLLnVk3zNc0acuasefSMAo8d2N5x2hxYrMSZw==
X-Received: by 2002:a62:b606:0:b029:1ec:ecf1:cc5 with SMTP id j6-20020a62b6060000b02901ececf10cc5mr22038807pff.62.1615218701115;
        Mon, 08 Mar 2021 07:51:41 -0800 (PST)
Received: from localhost.localdomain ([122.182.238.13])
        by smtp.gmail.com with ESMTPSA id s4sm11086378pji.2.2021.03.08.07.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:51:40 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V5 09/13] xfs: Check for extent overflow when writing to unwritten extent
Date:   Mon,  8 Mar 2021 21:21:07 +0530
Message-Id: <20210308155111.53874-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308155111.53874-1-chandanrlinux@gmail.com>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when writing to an unwritten extent.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/533     | 84 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/533.out | 11 +++++++
 tests/xfs/group   |  1 +
 3 files changed, 96 insertions(+)
 create mode 100755 tests/xfs/533
 create mode 100644 tests/xfs/533.out

diff --git a/tests/xfs/533 b/tests/xfs/533
new file mode 100755
index 00000000..af7475f0
--- /dev/null
+++ b/tests/xfs/533
@@ -0,0 +1,84 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 533
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
+	nextents=$(xfs_get_fsxattr nextents $testfile)
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+		exit 1
+	fi
+
+	rm $testfile
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/533.out b/tests/xfs/533.out
new file mode 100644
index 00000000..5b93964a
--- /dev/null
+++ b/tests/xfs/533.out
@@ -0,0 +1,11 @@
+QA output created by 533
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
index 77abeefa..3ad47d07 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -530,3 +530,4 @@
 530 auto quick punch zero insert collapse
 531 auto quick attr
 532 auto quick dir hardlink symlink
+533 auto quick
-- 
2.29.2

