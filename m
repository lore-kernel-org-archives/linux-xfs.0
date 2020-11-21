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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE64C63777
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC08122264
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OH6L9yRn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgKUIYL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Nov 2020 03:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbgKUIYK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Nov 2020 03:24:10 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7D9C0613CF;
        Sat, 21 Nov 2020 00:24:09 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id v5so6137153pff.10;
        Sat, 21 Nov 2020 00:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YLh6ge7d2BSDsnjLgHAlHNx2zVNQlO/eEK4I0Z84xXc=;
        b=OH6L9yRnYQpQ+C5A7REsQjGXD+5MjSpQZojUcXV8Q+N1dO7R5R3qlt25ql7eCbdg7k
         XxGPU/tRmt1hTDSQrRiUL5z+/L7tOajvI5IExMtXJjQiScMwj7sM/mnayYt8DgiskHmy
         v4AnDWwC6N1+uLbbKhkZlRKyqzAvtd7cT5dzaZkJWe1MSzEhhu1H3Rt7a4Z15CAbwuAP
         93b3kURRVaSCVYbJVUD0+c03IXMDsCtlkLAxVoiiZjvvKk8G9xRgfdIBIw8ufcGcoQ3Z
         Jntd1wIz56ARwdizLHJOU0OHmtUfdriMSia27psjUL6YY/ZYYM2LWkh/LwtuLXNSRBup
         OEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YLh6ge7d2BSDsnjLgHAlHNx2zVNQlO/eEK4I0Z84xXc=;
        b=O3jdHIO4BtM481unpU46z1qJilBdX+lJVlfnt3t42CBaYalC5AmWBDM0obBDUHN4wU
         qROokm5QLzTFu1e75kO6BzIK6a8brO3nOcCH1DGSySISbg9ZkQKlQ2EBQ+BpO4cAUqTS
         r2neaLXbb3OiK0CKgOvqiXSX0AaP3xglDhm3JhzZOBPU8oGnYrvLJquzNIPzaJVO3JVc
         Tt5CCYVhL6gLlFTOQYg6UjNPpLX7B+lXMdXd833FdO3yUpI+ypTkwZosZFLVZZATQdIG
         vgNjQ8DywK/tGeZsQYZjnD4PBuyn1oAHRQ4Ljuj7VHl13fFWWm+1FKA1LTk7/gvgOvd+
         KNkg==
X-Gm-Message-State: AOAM531HlmzzYo9nYNtKN4J1qVDXohvhqUAqBVpYOZOx2ukDvJP2tVaP
        Xn40HRp41HD9OcMGePGHLcPs2Me6RS8=
X-Google-Smtp-Source: ABdhPJw3pTB/TiyBiOb9yVV+26hqQDF6Hyj46ry3e6TVJwovczlkHVeyhCDtrqNlTkA5Le6ub3n9zA==
X-Received: by 2002:a17:90b:89:: with SMTP id bb9mr14557442pjb.53.1605947049276;
        Sat, 21 Nov 2020 00:24:09 -0800 (PST)
Received: from localhost.localdomain ([122.167.41.102])
        by smtp.gmail.com with ESMTPSA id e22sm6167148pfd.153.2020.11.21.00.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 00:24:08 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH V2 10/11] xfs: Check for extent overflow when swapping extents
Date:   Sat, 21 Nov 2020 13:53:31 +0530
Message-Id: <20201121082332.89739-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201121082332.89739-1-chandanrlinux@gmail.com>
References: <20201121082332.89739-1-chandanrlinux@gmail.com>
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
index 00000000..d4137324
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
+$XFS_IO_PROG -f -s -c "pwrite -b $((67 * bsize)) 0 $((67 * bsize))" $donorfile \
+       >> $seqres.full
+
+# After the for loop the donor file will have the following extent layout
+# | 0-4 | 5 | 6 | 7 | ... | 34 | 35 |
+echo "Fragment \$donorfile"
+for i in $(seq 5 35); do
+	start_offset=$((i * bsize))
+	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $donorfile >> $seqres.full
+done
+
+echo "Create \$srcfile having an extent of length 67 blocks"
+$XFS_IO_PROG -f -s -c "pwrite -b $((67 * bsize)) 0 $((67 * bsize))" $srcfile \
+       >> $seqres.full
+
+echo "Fragment \$srcfile"
+# After the for loop the src file will have the following extent layout
+# | 0 | 1 | 2 | ... | 29 | 30 | 31-35 |
+for i in $(seq 1 31); do
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
index 00000000..2fc6bf00
--- /dev/null
+++ b/tests/xfs/530.out
@@ -0,0 +1,13 @@
+QA output created by 530
+* Swap extent forks
+Format and mount fs
+Create $donorfile having an extent of length 67 blocks
+Fragment $donorfile
+Create $srcfile having an extent of length 67 blocks
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

