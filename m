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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE41C432C3
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8413922DFA
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391993AbhALHmN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 02:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391988AbhALHmN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 02:42:13 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81ABCC0617A9;
        Mon, 11 Jan 2021 23:41:09 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d4so142848plh.5;
        Mon, 11 Jan 2021 23:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i+DjE1xlEGRuZgveocTfgsgzOpdaBbBaWwg71VYt1cU=;
        b=XYA1shr41n4lYlHAk4YlodFDXvtHdMDJZGuYQ2FHYmeoYu3XtniQW9PaVzFF5lM67p
         IgjxTYJmWCJ9eI0VYHcL5jwKfANSSKjLEJ88mZrqJVKgfnQa7GwoCK6f7ihvdxujvY0z
         11w8eX7MWwnycFZLAqLXzJwICSmdBqYFl+/SjqMNqU4DPFmoeFv8Gvw4G3q90Lat3HS6
         iBSHv2NQCvVCJYEu6r5I9JgcJdHCT7gBDhiL5qcMqYmJOdFkO4zGr0Z7rE1p0wYBvzyj
         Yld8ZJVrrhUOAXp46G6BvpfFWbllab8tQ6Qshezgo2ydHNQcdIwwTD8nDy00kinIP2fk
         yhuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i+DjE1xlEGRuZgveocTfgsgzOpdaBbBaWwg71VYt1cU=;
        b=G4v8n8IALp0DoMjHQZCRhwIxIdYs9sN/TEqhQQaW2DUWRIV7y+z8t1mTWlMIk+Fgt0
         3cWMVay33j1ETHreWOpuxEOHuEotVFZGg/FjeX8P+q0C5oQS9lXshYpYcWKJwzu23Mst
         pQrCOmmvnKPPJCeNmRxyUxqho+ykJ5dy04qVwMi0KYpete7d+BhdW9C/WWi5S9fg0i5F
         P1yjNQ/5WmYItHvQ0YKxclyYFT0L61uIFgqW21rrYnzaGhGGSMwiAVtAM4rsBtWesyJ5
         hXIYVWSQsURXOpVcgCBgj1KaLDESzbqo/IN7KDoASiIYmbGrMY0gL8FRUUz/9A4QGrm3
         bg/g==
X-Gm-Message-State: AOAM5329V57PW6wOcoHgDpisySv4gyUhV0y/Duim8V/7Ydf/sND2iRxS
        yysdi5yiHLybaA8a7n49tSrdn2pe2g0=
X-Google-Smtp-Source: ABdhPJyGmy0oab9b05z49ZGFDiG8zLz59AxJ4lQLknYlpzRXPoE+ZLwbLjaw0UyFdkiJWioXRmKrAg==
X-Received: by 2002:a17:903:22c9:b029:dc:9b7f:bd13 with SMTP id y9-20020a17090322c9b02900dc9b7fbd13mr3891642plg.67.1610437268922;
        Mon, 11 Jan 2021 23:41:08 -0800 (PST)
Received: from localhost.localdomain ([122.171.39.105])
        by smtp.gmail.com with ESMTPSA id mj5sm1962340pjb.20.2021.01.11.23.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 23:41:08 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V3 09/11] xfs: Check for extent overflow when remapping an extent
Date:   Tue, 12 Jan 2021 13:10:25 +0530
Message-Id: <20210112074027.10311-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112074027.10311-1-chandanrlinux@gmail.com>
References: <20210112074027.10311-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when remapping extents from one file's inode fork to another.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/529     | 82 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/529.out |  8 +++++
 tests/xfs/group   |  1 +
 3 files changed, 91 insertions(+)
 create mode 100755 tests/xfs/529
 create mode 100644 tests/xfs/529.out

diff --git a/tests/xfs/529 b/tests/xfs/529
new file mode 100755
index 00000000..f6a5922f
--- /dev/null
+++ b/tests/xfs/529
@@ -0,0 +1,82 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 529
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# remapping extents from one file's inode fork to another.
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
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "* Reflink remap extents"
+
+echo "Format and mount fs"
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_block_size $SCRATCH_MNT)
+
+srcfile=${SCRATCH_MNT}/srcfile
+dstfile=${SCRATCH_MNT}/dstfile
+
+nr_blks=15
+
+echo "Create \$srcfile having an extent of length $nr_blks blocks"
+$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
+       -c fsync $srcfile >> $seqres.full
+
+echo "Create \$dstfile having an extent of length $nr_blks blocks"
+$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
+       -c fsync $dstfile >> $seqres.full
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Reflink every other block from \$srcfile into \$dstfile"
+for i in $(seq 1 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -f -c "reflink $srcfile $((i * bsize)) $((i * bsize)) $bsize" \
+	       $dstfile >> $seqres.full 2>&1
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
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/529.out b/tests/xfs/529.out
new file mode 100644
index 00000000..687a8bd2
--- /dev/null
+++ b/tests/xfs/529.out
@@ -0,0 +1,8 @@
+QA output created by 529
+* Reflink remap extents
+Format and mount fs
+Create $srcfile having an extent of length 15 blocks
+Create $dstfile having an extent of length 15 blocks
+Inject reduce_max_iextents error tag
+Reflink every other block from $srcfile into $dstfile
+Verify $dstfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index ea892308..96e40901 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -526,6 +526,7 @@
 526 auto quick dir hardlink symlink
 527 auto quick
 528 auto quick reflink
+529 auto quick reflink
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
-- 
2.29.2

