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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4C5C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C871F22597
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbhARGWw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 01:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732105AbhARGWP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 01:22:15 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD4CC0613ED;
        Sun, 17 Jan 2021 22:21:02 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id l23so9088003pjg.1;
        Sun, 17 Jan 2021 22:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2CYE49v+RIGfn0VhLazHIy4EkPBRnVc7nREuOfR/ZBk=;
        b=R11hkxihYLhnxxBmvJbvCCbY4yFhGKcyMzVPRbqCI6KI+7eoA3bgi7JLwl7494wm3E
         WzM5Q2ACMIHhUShLGJNkBWFyzPGd/7J0J9B+fu50Xf1Gjl3ko9t3gUQzXxYkkcFt+lGF
         xnM4C0BqB11XqC6Ezx4gvPbBy1aL79p0/IrdtSIVmCLTNQBbgmoa9LC7gcxAk48+IS6v
         i2+p8f2ljHLnO+HGQS4OlbFjZXmFyP3sZTXgYm8c40c49laC70dd5V6Q+ZHX/vaIfNjo
         aBwmck4XcG5uviJ66YcB6UiETnGfgZyLhtXiPjbtvutDGH6hbWLuDNhCrO5lqcl0Y5jh
         cZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2CYE49v+RIGfn0VhLazHIy4EkPBRnVc7nREuOfR/ZBk=;
        b=TZ2PpoeTSDeSIv4GqDvxExhPyvzg8mAMm5oGxXIgMjG5riIHGrKYW11Cn9gWKVaqzu
         dzQQxNh6JDW05KheYUAAOKUz6g+wA2z7YhT9l0rtl4SlMoGqTW8PgDOkuLljL2TD1EnP
         6yQgd3Lc2iZmCvdyJqMyhciLWkSw/kD7W6x+l6SankKBhgvLuMHPceCoB/Gle4TDGNkv
         RBiQfzJ1OFOJ1OJxUAmgZGgTdIfJT7NWLQVLQv/rmTNeTiPYLfPVGv+287iOJhN8+GCx
         7mSdy2fCuGczB3pgWE9l69xzA5uV2iVoIDVKPfjF7ryKC8d2G646C8QV128fSYp4eqKI
         R25Q==
X-Gm-Message-State: AOAM531liH0E6M2R2vFhAedGVpeHQ68RcX0QWZb/Rx5j06YU780soJ9K
        Yf23D5KTPw39NCbrglkWZE8tOm4QsKk=
X-Google-Smtp-Source: ABdhPJw/Y4BFYXB7tZDC0pez4/KCnjjRSq64lypTi4t9nxVBKskfs+vpWozrlAo//h7j9Ig7gtlQbA==
X-Received: by 2002:a17:90b:287:: with SMTP id az7mr23731898pjb.70.1610950861902;
        Sun, 17 Jan 2021 22:21:01 -0800 (PST)
Received: from localhost.localdomain ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id t1sm14608423pfq.154.2021.01.17.22.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:21:01 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V4 08/11] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Mon, 18 Jan 2021 11:50:19 +0530
Message-Id: <20210118062022.15069-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118062022.15069-1-chandanrlinux@gmail.com>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when writing to/funshare-ing a shared extent.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/528     | 110 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/528.out |  12 +++++
 tests/xfs/group   |   1 +
 3 files changed, 123 insertions(+)
 create mode 100755 tests/xfs/528
 create mode 100644 tests/xfs/528.out

diff --git a/tests/xfs/528 b/tests/xfs/528
new file mode 100755
index 00000000..269d368d
--- /dev/null
+++ b/tests/xfs/528
@@ -0,0 +1,110 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 528
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# writing to a shared extent.
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
+. ./common/reflink
+. ./common/inject
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_scratch_reflink
+_require_xfs_debug
+_require_xfs_io_command "reflink"
+_require_xfs_io_command "funshare"
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "Format and mount fs"
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_block_size $SCRATCH_MNT)
+
+nr_blks=15
+
+srcfile=${SCRATCH_MNT}/srcfile
+dstfile=${SCRATCH_MNT}/dstfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Create a \$srcfile having an extent of length $nr_blks blocks"
+$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
+       -c fsync $srcfile  >> $seqres.full
+
+echo "* Write to shared extent"
+
+echo "Share the extent with \$dstfile"
+$XFS_IO_PROG -f -c "reflink $srcfile" $dstfile >> $seqres.full
+
+echo "Buffered write to every other block of \$dstfile's shared extent"
+for i in $(seq 1 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -f -s -c "pwrite $((i * bsize)) $bsize" $dstfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Verify \$dstfile's extent count"
+nextents=$($XFS_IO_PROG -c 'stat' $dstfile | grep nextents)
+nextents=${nextents##fsxattr.nextents = }
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm $dstfile
+
+echo "* Funshare shared extent"
+
+echo "Share the extent with \$dstfile"
+$XFS_IO_PROG -f -c "reflink $srcfile" $dstfile >> $seqres.full
+
+echo "Funshare every other block of \$dstfile's shared extent"
+for i in $(seq 1 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -f -s -c "funshare $((i * bsize)) $bsize" $dstfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Verify \$dstfile's extent count"
+nextents=$($XFS_IO_PROG -c 'stat' $dstfile | grep nextents)
+nextents=${nextents##fsxattr.nextents = }
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+# super_block->s_wb_err will have a newer seq value when compared to "/"'s
+# file->f_sb_err. Consume it here so that xfs_scrub can does not error out.
+$XFS_IO_PROG -c syncfs $SCRATCH_MNT >> $seqres.full 2>&1
+
+# success, all done
+status=0
+exit
+ 
diff --git a/tests/xfs/528.out b/tests/xfs/528.out
new file mode 100644
index 00000000..d0f2c878
--- /dev/null
+++ b/tests/xfs/528.out
@@ -0,0 +1,12 @@
+QA output created by 528
+Format and mount fs
+Inject reduce_max_iextents error tag
+Create a $srcfile having an extent of length 15 blocks
+* Write to shared extent
+Share the extent with $dstfile
+Buffered write to every other block of $dstfile's shared extent
+Verify $dstfile's extent count
+* Funshare shared extent
+Share the extent with $dstfile
+Funshare every other block of $dstfile's shared extent
+Verify $dstfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index 627813fe..c85aac6b 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -525,3 +525,4 @@
 525 auto quick attr
 526 auto quick dir hardlink symlink
 527 auto quick
+528 auto quick reflink
-- 
2.29.2

