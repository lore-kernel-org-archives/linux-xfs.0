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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB63C43603
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47018230F9
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392037AbhALHmQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 02:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387522AbhALHmQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 02:42:16 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0887C0617AA;
        Mon, 11 Jan 2021 23:41:11 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m5so1119399pjv.5;
        Mon, 11 Jan 2021 23:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cfGsCj6MkXBBxVARbxSja/PAQC29R0bS584DXGVe8lk=;
        b=SQsZBWrMsXPsn9bdBtcgA8Um5ZaBFRCXxAJbHTHqdMve7ZN0V6I7vOheAF6onIX+lK
         mLlRaP+koyOZUiEIJvwTNYBj/YcFsFZMDcE3D9tXueHmiRgGcAgZWdXPoQO1a/ZQMLG+
         3toIFYo2iQZqs9JWr7YQn07JrxNNAnnGyJhNcRKoK7buyASu7iFnZTID/za6vMdJu5kc
         LPe/masb7vcdbQWd3wUe6gyXGxGBlBy0j3PFSceIRe+tYnyIICJ+BmZPdmfWDDzJ9dJq
         6oyZAmMp6hqZoD2JOqjVCIKR4nZyQUcTJSsKY7TwPggHQSs9TwdEADSbu4GdMf9JSfvn
         ohMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cfGsCj6MkXBBxVARbxSja/PAQC29R0bS584DXGVe8lk=;
        b=NYNAStftYKG1ePzF0r5j52IL4qxc6akAi7S+fvtkBkyXwZzJsZIcrazTrxwmnWfYaF
         B8REkiQfs44secEz1WLsllvuN3CjmfaxqdCoHnYxA/Q3NzL1DoQBdLeyAXhqHs65nmIt
         VmyZzzvcpR5cUjheHmzIAAcBlpneXVtrGvpYY8FkgsAZh5VIUAc8V6l3I6bJeGmHf72U
         scwXtrfYE/RxyrZerHdDy8tFfjVdukTyd3j9xazVSkJVH7UnmGW8gm8y+okg3qmyUQjD
         ALNiBexFRrwWiHAbMnY4mRSnIfjQdMWpKcLG8k6Azqa4rvIcEDrT8Be6b0Boi90GIjR0
         7YeA==
X-Gm-Message-State: AOAM531xiIFsvW9QCmOlt6Fpiaih0GOzMu8r+nwtx81eMgz59n9tL1Wc
        YDGUlzkHKRc9jUzft7Db5zpou5mMsiY=
X-Google-Smtp-Source: ABdhPJxp3v1CeWqPBA9ogNx2zCpuP5gnt5cQAeVGKkHRSNoCG/WXKhwC3slaiH2xTG/Oee7AFJboSA==
X-Received: by 2002:a17:902:fe87:b029:da:5d3b:4a84 with SMTP id x7-20020a170902fe87b02900da5d3b4a84mr3994491plm.51.1610437271285;
        Mon, 11 Jan 2021 23:41:11 -0800 (PST)
Received: from localhost.localdomain ([122.171.39.105])
        by smtp.gmail.com with ESMTPSA id mj5sm1962340pjb.20.2021.01.11.23.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 23:41:10 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V3 10/11] xfs: Check for extent overflow when swapping extents
Date:   Tue, 12 Jan 2021 13:10:26 +0530
Message-Id: <20210112074027.10311-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112074027.10311-1-chandanrlinux@gmail.com>
References: <20210112074027.10311-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when swapping forks across two files.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/530     | 109 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/530.out |  13 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 123 insertions(+)
 create mode 100755 tests/xfs/530
 create mode 100644 tests/xfs/530.out

diff --git a/tests/xfs/530 b/tests/xfs/530
new file mode 100755
index 00000000..0986d8bf
--- /dev/null
+++ b/tests/xfs/530
@@ -0,0 +1,109 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 530
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# swapping forks between files
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
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "swapext"
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "* Swap extent forks"
+
+echo "Format and mount fs"
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_block_size $SCRATCH_MNT)
+
+srcfile=${SCRATCH_MNT}/srcfile
+donorfile=${SCRATCH_MNT}/donorfile
+
+echo "Create \$donorfile having an extent of length 67 blocks"
+$XFS_IO_PROG -f -s -c "pwrite -b $((17 * bsize)) 0 $((17 * bsize))" $donorfile \
+       >> $seqres.full
+
+# After the for loop the donor file will have the following extent layout
+# | 0-4 | 5 | 6 | 7 | 8 | 9 | 10 |
+echo "Fragment \$donorfile"
+for i in $(seq 5 10); do
+	start_offset=$((i * bsize))
+	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $donorfile >> $seqres.full
+done
+
+echo "Create \$srcfile having an extent of length 18 blocks"
+$XFS_IO_PROG -f -s -c "pwrite -b $((18 * bsize)) 0 $((18 * bsize))" $srcfile \
+       >> $seqres.full
+
+echo "Fragment \$srcfile"
+# After the for loop the src file will have the following extent layout
+# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7-10 |
+for i in $(seq 1 7); do
+	start_offset=$((i * bsize))
+	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $srcfile >> $seqres.full
+done
+
+echo "Collect \$donorfile's extent count"
+donor_nr_exts=$($XFS_IO_PROG -c 'stat' $donorfile | grep nextents)
+donor_nr_exts=${donor_nr_exts##fsxattr.nextents = }
+
+echo "Collect \$srcfile's extent count"
+src_nr_exts=$($XFS_IO_PROG -c 'stat' $srcfile | grep nextents)
+src_nr_exts=${src_nr_exts##fsxattr.nextents = }
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Swap \$srcfile's and \$donorfile's extent forks"
+$XFS_IO_PROG -f -c "swapext $donorfile" $srcfile >> $seqres.full 2>&1
+
+echo "Check for \$donorfile's extent count overflow"
+nextents=$($XFS_IO_PROG -c 'stat' $donorfile | grep nextents)
+nextents=${nextents##fsxattr.nextents = }
+
+if (( $nextents == $src_nr_exts )); then
+	echo "\$donorfile: Extent count overflow check failed"
+fi
+
+echo "Check for \$srcfile's extent count overflow"
+nextents=$($XFS_IO_PROG -c 'stat' $srcfile | grep nextents)
+nextents=${nextents##fsxattr.nextents = }
+
+if (( $nextents == $donor_nr_exts )); then
+	echo "\$srcfile: Extent count overflow check failed"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/530.out b/tests/xfs/530.out
new file mode 100644
index 00000000..9f55608b
--- /dev/null
+++ b/tests/xfs/530.out
@@ -0,0 +1,13 @@
+QA output created by 530
+* Swap extent forks
+Format and mount fs
+Create $donorfile having an extent of length 67 blocks
+Fragment $donorfile
+Create $srcfile having an extent of length 18 blocks
+Fragment $srcfile
+Collect $donorfile's extent count
+Collect $srcfile's extent count
+Inject reduce_max_iextents error tag
+Swap $srcfile's and $donorfile's extent forks
+Check for $donorfile's extent count overflow
+Check for $srcfile's extent count overflow
diff --git a/tests/xfs/group b/tests/xfs/group
index 96e40901..289a082d 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -527,6 +527,7 @@
 527 auto quick
 528 auto quick reflink
 529 auto quick reflink
+530 auto quick
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
-- 
2.29.2

