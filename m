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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E277C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3438165092
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhCIFCa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhCIFCF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 00:02:05 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A915C06174A;
        Mon,  8 Mar 2021 21:02:05 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id a4so7952414pgc.11;
        Mon, 08 Mar 2021 21:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jmnH2NVxLNb//OdJ5YGhMoZtosSzwhyj1eElOhU5wIY=;
        b=onhOpIbx0CfXDoxOUkSPLds2ZIGihgI8X6SJQcR1BSDcnWTfCY9XMqTeCsCu3TMSTo
         a5dQtBydYnuMxDf9lI3noAD66W7ybNnwSgqPDm/w9gOqT4TQaGixRNgDWkPd4JRFMlS3
         RAqIfhd5t8hJL7hxKwJPnV7V7bWOlsh/sB2bkRtrxcWJePFLHIkAWS1BRVqAg8MvHJD4
         0ayLUPGLhzYgGLHSLiatv6hRE5bGdVg9OHi8pKVu/ds8FGGLih/VnVWg7pygAaiqjdT3
         qqMZrldIPdKo9R+Q6/H6VGA1iQhb0ymqVD4kb1abuo20CLcyPzlq/F3pFMl+Yni+Ym73
         9/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jmnH2NVxLNb//OdJ5YGhMoZtosSzwhyj1eElOhU5wIY=;
        b=RwlRwIoGCt8fOYX1rybFV8UiiXdt+yFW6KYfsu/L6pEIyoEx7Lkk1LITtF9DkkVLzV
         azyFKbH8kThR6IgKPGhv4evVtEpCd4NY8n29H6UQzYdAfadUtX3zLdQKPEfIJJEjuxeH
         TGswVdO8hHu6CWfkmNmuUiiRG7W02hl/5x5gGTueJv/30ucLeqMul+65GQPk5M5D5XpU
         H6qzD61TWactEpPnwkJSK+jXdGTmBLFun5VPkShwdZR1a5Yq8nW1lhYtPvpZB9feky+U
         DwOCy45AdhRv1o7QaHU+Xnlq+N5enQYmx/95+lZFTUKASAtlVQlScU47sT0GJ0clJ4FQ
         YrMw==
X-Gm-Message-State: AOAM530vjw8+IKD2Mh3RE1dpFYgJNpkbrveH2SSyrUxGjxxVaXxwhY2E
        lY8vuYWK5Pmfv9Kv0KLnAaLit+3do7o=
X-Google-Smtp-Source: ABdhPJy5k21A4gDJzvnO4f5B8gNB39i9UlHXHlr+UTO8tzQHbKiki7PiMX1BDual+wDefLr6AVu4RQ==
X-Received: by 2002:a63:e44a:: with SMTP id i10mr22964629pgk.404.1615266124486;
        Mon, 08 Mar 2021 21:02:04 -0800 (PST)
Received: from localhost.localdomain ([122.179.125.254])
        by smtp.gmail.com with ESMTPSA id a21sm5849577pfh.31.2021.03.08.21.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 21:02:04 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V6 12/13] xfs: Check for extent overflow when swapping extents
Date:   Tue,  9 Mar 2021 10:31:23 +0530
Message-Id: <20210309050124.23797-13-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309050124.23797-1-chandanrlinux@gmail.com>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when swapping forks across two files.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/536     | 105 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/536.out |  13 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 119 insertions(+)
 create mode 100755 tests/xfs/536
 create mode 100644 tests/xfs/536.out

diff --git a/tests/xfs/536 b/tests/xfs/536
new file mode 100755
index 00000000..9bb4094a
--- /dev/null
+++ b/tests/xfs/536
@@ -0,0 +1,105 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 536
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
+donor_nr_exts=$(_xfs_get_fsxattr nextents $donorfile)
+
+echo "Collect \$srcfile's extent count"
+src_nr_exts=$(_xfs_get_fsxattr nextents $srcfile)
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Swap \$srcfile's and \$donorfile's extent forks"
+$XFS_IO_PROG -f -c "swapext $donorfile" $srcfile >> $seqres.full 2>&1
+
+echo "Check for \$donorfile's extent count overflow"
+nextents=$(_xfs_get_fsxattr nextents $donorfile)
+
+if (( $nextents == $src_nr_exts )); then
+	echo "\$donorfile: Extent count overflow check failed"
+fi
+
+echo "Check for \$srcfile's extent count overflow"
+nextents=$(_xfs_get_fsxattr nextents $srcfile)
+
+if (( $nextents == $donor_nr_exts )); then
+	echo "\$srcfile: Extent count overflow check failed"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/536.out b/tests/xfs/536.out
new file mode 100644
index 00000000..f550aa1e
--- /dev/null
+++ b/tests/xfs/536.out
@@ -0,0 +1,13 @@
+QA output created by 536
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
index aed06494..ba674a58 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -533,3 +533,4 @@
 533 auto quick
 534 auto quick reflink
 535 auto quick reflink
+536 auto quick
-- 
2.29.2

