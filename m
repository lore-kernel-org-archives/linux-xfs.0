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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848C0C433E9
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46A8322EBE
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387521AbhALHmJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 02:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbhALHmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 02:42:09 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3364EC0617A4;
        Mon, 11 Jan 2021 23:41:00 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id y8so948205plp.8;
        Mon, 11 Jan 2021 23:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uf7wmL9C06Pm1NNR4aoRM356vneLUa/1yf8fzzPP1Ns=;
        b=d81GoICA7cNY5mbDx13yddOJvTrxLLIXBgJlpf5E8thwglzJMK76ypJdwi85m10GOg
         dzJUILU5CVgaYG0EkaElmEaiU/16356eeoLZhxVJh4RpA6pwJSiXdt+EwQSPxa/tN/sp
         JQA5i/wybF3FPZMVBXSHaDVx8Ty8f5iwaJxf0XG//FAtUs/Of2fCokHh3DBXjQcJhFvB
         HQMugcZYdx3SZTNbFUsMOov47UQrnwkxaZ3w6k0dDKOdl1c2eta/Q2Xb2RV/3epkhCWh
         Mgr5ArIjvlJlvyhAQTzJgoK0TMZ1IMtOQabWFD6uENNHx3RF55pHb+VvRBiTtkuwOKuY
         YCzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uf7wmL9C06Pm1NNR4aoRM356vneLUa/1yf8fzzPP1Ns=;
        b=H7PvMTDr0z8+cO4Fdgj7DKXNrxpCe8mkJrreUpWT/2shkncwjB66gAwLc0EHltIdos
         aG9YrkqALN0Wd1C7cQxOCBcuTzDZy2bQF5owjiEKc1DOxa8GTAJ3aQRaSvgwhZpMNtVs
         5s5waFkBGVbOR6bAj04WjmM4YrbZsjE58RWljF9N/QPMUsmsPb5+OZBP+6MJKwno8OZn
         C7rfmrzkgepAFFAFr8oy8ZanqNxAmVQM7BTdUCtEAXgp47e9QltEAUc85cMG+CCCyGgq
         EEAQDL/K97dovrcMjh8NzUiYNvircPCJZL/7KGrtmHvfsBCSMEoEBfm2NVb+gSJ6If1B
         ARDw==
X-Gm-Message-State: AOAM530HWSuxGRn/Q37ymc4A8RIKWm3DlR52+HUGTMqSXe0047xtGJFZ
        QTtDNAFofGP1BMQjI5UcHpCYc9T+1Qo=
X-Google-Smtp-Source: ABdhPJypjLYsJgGhyJ7ZhRXaByUOTcSabiuB0b44UxOAfVy5jAo2uk71JvhQttPR8h6OFvFZ2KrJJw==
X-Received: by 2002:a17:90a:db0d:: with SMTP id g13mr2011308pjv.76.1610437259527;
        Mon, 11 Jan 2021 23:40:59 -0800 (PST)
Received: from localhost.localdomain ([122.171.39.105])
        by smtp.gmail.com with ESMTPSA id mj5sm1962340pjb.20.2021.01.11.23.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 23:40:59 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V3 05/11] xfs: Check for extent overflow when adding/removing xattrs
Date:   Tue, 12 Jan 2021 13:10:21 +0530
Message-Id: <20210112074027.10311-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112074027.10311-1-chandanrlinux@gmail.com>
References: <20210112074027.10311-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when adding/removing xattrs.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/525     | 141 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/525.out |  18 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 160 insertions(+)
 create mode 100755 tests/xfs/525
 create mode 100644 tests/xfs/525.out

diff --git a/tests/xfs/525 b/tests/xfs/525
new file mode 100755
index 00000000..bdca846d
--- /dev/null
+++ b/tests/xfs/525
@@ -0,0 +1,141 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 525
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# Adding/removing xattrs.
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
+. ./common/attr
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
+_require_attrs
+_require_xfs_debug
+_require_test_program "punch-alternating"
+_require_xfs_io_error_injection "reduce_max_iextents"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+
+echo "Format and mount fs"
+_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_block_size $SCRATCH_MNT)
+
+attr_len=255
+
+testfile=$SCRATCH_MNT/testfile
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
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Inject bmap_alloc_minlen_extent error tag"
+_scratch_inject_error bmap_alloc_minlen_extent 1
+
+echo "* Set xattrs"
+
+echo "Create \$testfile"
+touch $testfile
+
+echo "Create xattrs"
+nr_attrs=$((bsize * 20 / attr_len))
+for i in $(seq 1 $nr_attrs); do
+	attr="$(printf "trusted.%0247d" $i)"
+	$SETFATTR_PROG -n "$attr" $testfile >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Verify \$testfile's naextent count"
+
+naextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep naextents)
+naextents=${naextents##fsxattr.naextents = }
+if (( $naextents > 10 )); then
+	echo "Extent count overflow check failed: naextents = $naextents"
+	exit 1
+fi
+
+echo "Remove \$testfile"
+rm $testfile
+
+echo "* Remove xattrs"
+
+echo "Create \$testfile"
+touch $testfile
+
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
+echo "Create initial xattr extents"
+
+naextents=0
+last=""
+start=1
+nr_attrs=$((bsize / attr_len))
+
+while (( $naextents < 4 )); do
+	end=$((start + nr_attrs - 1))
+
+	for i in $(seq $start $end); do
+		attr="$(printf "trusted.%0247d" $i)"
+		$SETFATTR_PROG -n $attr $testfile
+	done
+
+	start=$((end + 1))
+
+	naextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep naextents)
+	naextents=${naextents##fsxattr.naextents = }
+done
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Remove xattr to trigger -EFBIG"
+attr="$(printf "trusted.%0247d" 1)"
+$SETFATTR_PROG -x "$attr" $testfile >> $seqres.full 2>&1
+if [[ $? == 0 ]]; then
+	echo "Xattr removal succeeded; Should have failed "
+	exit 1
+fi
+
+rm $testfile && echo "Successfully removed \$testfile"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/525.out b/tests/xfs/525.out
new file mode 100644
index 00000000..74b152d9
--- /dev/null
+++ b/tests/xfs/525.out
@@ -0,0 +1,18 @@
+QA output created by 525
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Inject reduce_max_iextents error tag
+Inject bmap_alloc_minlen_extent error tag
+* Set xattrs
+Create $testfile
+Create xattrs
+Verify $testfile's naextent count
+Remove $testfile
+* Remove xattrs
+Create $testfile
+Disable reduce_max_iextents error tag
+Create initial xattr extents
+Inject reduce_max_iextents error tag
+Remove xattr to trigger -EFBIG
+Successfully removed $testfile
diff --git a/tests/xfs/group b/tests/xfs/group
index 7031cabf..bfaac6aa 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -522,6 +522,7 @@
 522 auto quick quota
 523 auto quick realtime growfs
 524 auto quick punch zero insert collapse
+525 auto quick attr
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
-- 
2.29.2

