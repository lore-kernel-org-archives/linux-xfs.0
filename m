Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51443C388F7
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 064302224C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:05:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NAiR9KTG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgKMMFO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 07:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgKML1n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 06:27:43 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC55BC061A47;
        Fri, 13 Nov 2020 03:27:38 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id v12so7350759pfm.13;
        Fri, 13 Nov 2020 03:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tDNJv2hKsH0A5GF/u9+v/0f2U4xIn/WtS6Vk2OEsrlw=;
        b=NAiR9KTGTOTNFhUGoNYjOTjcd+fnGj4UGePcd/1luvGey+tw3s2HsyFDcl6dLJwGpn
         ymRHwvQmC95OB+gK81PAfZSlCTEswiFgSh+AUhgdbzWR97lRXB5lvzP9sWAuu84kk8Q5
         eehXeO/IZBb5bSzGEgysH94qwTKM6d8k4SVjT4LyhLmmgtss+Q2YqXK955lrI3l7yXlQ
         TGoiMlBPtVDqBvFt/jqtLn4syu+8q77uNc1FBS9Zl7+gaGeAdQibcBf4Z9saNhdwKdjO
         X+QNXrvTZB4C9fr2exkVfy1QQMAFz0AHkkFjqf9ushwuVDnmzbOfSmmRID2m2YuqTBGb
         DZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tDNJv2hKsH0A5GF/u9+v/0f2U4xIn/WtS6Vk2OEsrlw=;
        b=gRO+zK7w21cTSPbr/TDuH5JoxgQQZUpY3pSQdSfk/e2bTj3QWj/iND+kfzSOM6AxV6
         gaKXIxeudwj2ESywmANUyfuXjimf0pNIwKGrMCbu+DUyYvOmj6zoPbTa+dHciWtwxeDQ
         9RJsc2roFi/BPo/z8PvNm69rsm+RrmNUXoz+qcOcMO+nTHdvG1tDyY62X9CGbpr6qi+G
         tTAhtgP5G1QvJF8LMvWcFFe/PBdtoESbd2/X5vlrW+/4U0jLSlJz5cnotIe0o8lECJhN
         yMKHdzaIco6oq9XdtpdUlpZDq/b2Uct76xL3Nog37povOEB8KJ9X7s8mjJKUdKPkwiiS
         jcyw==
X-Gm-Message-State: AOAM531QUYXQHEq8RT6ciDo9WlviBl1YUxUJ5HETTqerjC/AWqOG2AEi
        FGFg8ZaJy5AOgrA3ZAVk/fMwsTavaeI=
X-Google-Smtp-Source: ABdhPJxX0SVG2TKANFVjVB5vPi8NfGu7EJGrd7CoKnlvdNqmGBDh83HUcia3+4P4mq+GfasE9Wh99A==
X-Received: by 2002:a05:6a00:4a:b029:18b:3748:8931 with SMTP id i10-20020a056a00004ab029018b37488931mr1587838pfk.61.1605266857945;
        Fri, 13 Nov 2020 03:27:37 -0800 (PST)
Received: from localhost.localdomain ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id w131sm9410857pfd.14.2020.11.13.03.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 03:27:37 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH 03/11] xfs: Check for extent overflow when trivally adding a new extent
Date:   Fri, 13 Nov 2020 16:56:55 +0530
Message-Id: <20201113112704.28798-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113112704.28798-1-chandanrlinux@gmail.com>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Verify that XFS does not cause inode fork's extent count to overflow
when adding a single extent while there's no possibility of splitting an
existing mapping (limited to realtime files only).

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/523     | 176 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/523.out |  18 +++++
 tests/xfs/group   |   1 +
 3 files changed, 195 insertions(+)
 create mode 100755 tests/xfs/523
 create mode 100644 tests/xfs/523.out

diff --git a/tests/xfs/523 b/tests/xfs/523
new file mode 100755
index 00000000..4f5b3584
--- /dev/null
+++ b/tests/xfs/523
@@ -0,0 +1,176 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 523
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# adding a single extent while there's no possibility of splitting an existing
+# mapping (limited to realtime files only).
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
+	_scratch_unmount >> $seqres.full 2>&1
+	test -e "$rtdev" && losetup -d $rtdev >> $seqres.full 2>&1
+	rm -f $tmp.* $TEST_DIR/$seq.rtvol
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
+_require_test
+_require_xfs_debug
+_require_test_program "punch-alternating"
+_require_xfs_io_error_injection "reduce_max_iextents"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+_require_scratch_nocheck
+
+grow_rtinodes()
+{
+	echo "* Test extending rt inodes"
+
+	_scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
+	. $tmp.mkfs
+
+	echo "Create fake rt volume"
+	nr_bitmap_blks=25
+	nr_bits=$((nr_bitmap_blks * dbsize * 8))
+	rtextsz=$dbsize
+	rtdevsz=$((nr_bits * rtextsz))
+	truncate -s $rtdevsz $TEST_DIR/$seq.rtvol
+	rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
+
+	echo "Format and mount rt volume"
+	export USE_EXTERNAL=yes
+	export SCRATCH_RTDEV=$rtdev
+	_scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
+		      -r size=2M,extsize=${rtextsz} >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+
+	echo "Consume free space"
+	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
+	sync
+
+	echo "Create fragmented filesystem"
+	$here/src/punch-alternating $testfile >> $seqres.full
+	sync
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "Inject bmap_alloc_minlen_extent error tag"
+	xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
+
+	echo "Grow realtime volume"
+	xfs_growfs -r $SCRATCH_MNT >> $seqres.full 2>&1
+	if [[ $? == 0 ]]; then
+		echo "Growfs succeeded; should have failed."
+		exit 1
+	fi
+
+	_scratch_unmount >> $seqres.full
+
+	echo "Verify rbmino's and rsumino's extent count"
+	for rtino in rbmino rsumino; do
+		ino=$(_scratch_xfs_db -c sb -c "print $rtino")
+		ino=${ino##${rtino} = }
+		echo "$rtino = $ino" >> $seqres.full
+
+		nextents=$(_scratch_get_iext_count $ino data || \
+				_fail "Unable to obtain inode fork's extent count")
+		if (( $nextents > 10 )); then
+			echo "Extent count overflow check failed: nextents = $nextents"
+			exit 1
+		fi
+	done
+
+	echo "Check filesystem"
+	_check_xfs_filesystem $SCRATCH_DEV none $rtdev
+
+	losetup -d $rtdev
+	rm -f $TEST_DIR/$seq.rtvol
+
+	export USE_EXTERNAL=""
+	export SCRATCH_RTDEV=""
+}
+
+rtfile_extend()
+{
+	echo "* Test extending an rt file"
+
+	_scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
+	. $tmp.mkfs
+
+	echo "Create fake rt volume"
+	nr_blks=$((15 * 2))
+	rtextsz=$dbsize
+	rtdevsz=$((2 * nr_blks * rtextsz))
+	truncate -s $rtdevsz $TEST_DIR/$seq.rtvol
+	rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
+
+	echo "Format and mount rt volume"
+	export USE_EXTERNAL=yes
+	export SCRATCH_RTDEV=$rtdev
+	_scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
+		      -r size=$rtdevsz >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "Create fragmented file on rt volume"
+	testfile=$SCRATCH_MNT/testfile
+	for i in $(seq 0 2 $((nr_blks - 1))); do
+		xfs_io -Rf -c "pwrite $((i * dbsize)) $dbsize" -c fsync \
+		       $testfile >> $seqres.full 2>&1
+		[[ $? != 0 ]] && break
+	done
+
+	testino=$(stat -c "%i" $testfile)
+
+	_scratch_unmount >> $seqres.full
+
+	echo "Verify \$testfile's extent count"
+	nextents=$(_scratch_get_iext_count $testino data || \
+			_fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+		exit 1
+	fi
+
+	echo "Check filesystem"
+	_check_xfs_filesystem $SCRATCH_DEV none $rtdev
+
+	losetup -d $rtdev
+	rm -f $TEST_DIR/$seq.rtvol
+
+	export USE_EXTERNAL=""
+	export SCRATCH_RTDEV=""
+}
+
+grow_rtinodes
+rtfile_extend
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/523.out b/tests/xfs/523.out
new file mode 100644
index 00000000..16b4e0ad
--- /dev/null
+++ b/tests/xfs/523.out
@@ -0,0 +1,18 @@
+QA output created by 523
+* Test extending rt inodes
+Create fake rt volume
+Format and mount rt volume
+Consume free space
+Create fragmented filesystem
+Inject reduce_max_iextents error tag
+Inject bmap_alloc_minlen_extent error tag
+Grow realtime volume
+Verify rbmino's and rsumino's extent count
+Check filesystem
+* Test extending an rt file
+Create fake rt volume
+Format and mount rt volume
+Inject reduce_max_iextents error tag
+Create fragmented file on rt volume
+Verify $testfile's extent count
+Check filesystem
diff --git a/tests/xfs/group b/tests/xfs/group
index 1831f0b5..018c70ef 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -520,3 +520,4 @@
 520 auto quick reflink
 521 auto quick realtime growfs
 522 auto quick quota
+523 auto quick realtime growfs
-- 
2.28.0

