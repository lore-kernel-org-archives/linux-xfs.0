Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9761C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Oct 2023 21:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjJ3VAX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 17:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbjJ3VAW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Oct 2023 17:00:22 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47818102
        for <linux-xfs@vger.kernel.org>; Mon, 30 Oct 2023 14:00:19 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6b497c8575aso5016202b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 30 Oct 2023 14:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1698699619; x=1699304419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VkqLsiO75F22f/osxi9L6166dfWADIgNNrDHsxZaCTg=;
        b=N87oWbU8L36Fo9eEKSraISt8Sa7X/ElpwupYqZQl7thPSlVcuhZimTqxuFgsb5eBAX
         orzTrlstxhSbSyYf1EovYDR22CUh1uy0rMaYSZxrW8L5E4lswyAeEODv7q0yn8kOCWbc
         oYTiWu3BJSzegZtrwJ9j9ky5yDRJ23eaLP/eUEGzWOQ/PxGr1zbu8FkzEpgbgRL29ICb
         mKmbKRSc4zXCfvNo40uxW4jqjfbAavcv7q/S0p/mMGSHaHtnZjGcN1gfkQAaFAz7n9r4
         sdOHfri/g3pjKGY2AiXmR0O4XIo+jRHyymve4xa5NngUMHJydbVS9+YVhYtCD6jV/nXR
         +0Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698699619; x=1699304419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VkqLsiO75F22f/osxi9L6166dfWADIgNNrDHsxZaCTg=;
        b=vxODcd/gMoj4pN6FldxhqCGdaIdBH1XB/JLs8+0Xw3mD1LXYlcJT5Uz6c2VYoJ7r4T
         W379mfVavew5ljKgHtEu8Kybe/O6q1ixbBXsc4hImpuyZVkU71qdCJjq2hGXfP+AOQb1
         RIYm3PK5UpUiX/i54yIxUrWJ2eXdhf7tCsTEvIAuceEZE+Vd6QkpjHop6/7gT8tgGPXo
         p8CaC72uw4wDLdBacg0om/Wov5v0dutw9rpQTW8ucNFMsFfKcaqvI4MDdB+NNrXnaKyu
         FGPV65pnT23Y7xQnwFRhI2Ax5LqDEeu9oDnnq27X9+YAPSNdEuMOKVa/QQ4gRgho5HWc
         S5yA==
X-Gm-Message-State: AOJu0YyJsc/Lav6Rh22NAFKy1F6uT+cZnllo726DNQBYURYLBgtDkbEk
        JtIk33J1kx9+wDcOWzzChcXTSw==
X-Google-Smtp-Source: AGHT+IEbZGog1VKPye4Q71ygqJUfOWQ6Bh67TMCXFae9acZltQHBSzYedU2eCWNo/auz6R81uitlew==
X-Received: by 2002:a05:6a00:15d4:b0:6be:2803:9c92 with SMTP id o20-20020a056a0015d400b006be28039c92mr13256581pfu.32.1698699618429;
        Mon, 30 Oct 2023 14:00:18 -0700 (PDT)
Received: from telecaster.thefacebook.com ([2620:10d:c090:500::4:49f])
        by smtp.gmail.com with ESMTPSA id n26-20020aa78a5a000000b0068ff0a633fdsm6307115pfa.131.2023.10.30.14.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 14:00:17 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     kernel-team@fb.com, "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH fstests v2] xfs: test refilling AGFL after lots of btree splits
Date:   Mon, 30 Oct 2023 14:00:15 -0700
Message-ID: <fe622bff22bca23648ed1154faeadce3ed51ad3b.1698699498.git.osandov@osandov.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <68cd85697855f686529829a2825b044913148caf.1698699188.git.osandov@fb.com>
References: <68cd85697855f686529829a2825b044913148caf.1698699188.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a regression test for patch "xfs: fix internal error from AGFL
exhaustion"), which is not yet merged. Without the fix, it will fail
with a "Structure needs cleaning" error.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
Changes since v1 [1]:

- Fixed to check whether mkfs.xfs supports -m rmapbt.
- Changed bare $XFS_DB calls to _scratch_xfs_db.
- Expanded comment about what happens without the fix.

I didn't add a check for whether everything ended up in AG 0, because it
wasn't clear to me what to do in that case. We could skip the test, but
it also doesn't hurt to run it anyways.

1: https://lore.kernel.org/linux-xfs/c7be2fe66a297316b934ddd3a1368b14f39a9f22.1698190540.git.osandov@osandov.com/

 tests/xfs/601     | 68 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/601.out |  2 ++
 2 files changed, 70 insertions(+)
 create mode 100755 tests/xfs/601
 create mode 100644 tests/xfs/601.out

diff --git a/tests/xfs/601 b/tests/xfs/601
new file mode 100755
index 00000000..68df6ac0
--- /dev/null
+++ b/tests/xfs/601
@@ -0,0 +1,68 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) Meta Platforms, Inc. and affiliates.
+#
+# FS QA Test 601
+#
+# Regression test for patch "xfs: fix internal error from AGFL exhaustion".
+#
+. ./common/preamble
+_begin_fstest auto prealloc punch
+
+. ./common/filter
+
+_supported_fs xfs
+_require_scratch
+_require_test_program punch-alternating
+_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: fix internal error from AGFL exhaustion"
+
+# Disable the rmapbt so we only need to worry about splitting the bnobt and
+# cntbt at the same time.
+opts=
+if $MKFS_XFS_PROG |& grep -q rmapbt; then
+	opts="-m rmapbt=0"
+fi
+_scratch_mkfs $opts | _filter_mkfs > /dev/null 2> "$tmp.mkfs"
+. "$tmp.mkfs"
+_scratch_mount
+
+alloc_block_len=$((_fs_has_crcs ? 56 : 16))
+allocbt_leaf_maxrecs=$(((dbsize - alloc_block_len) / 8))
+allocbt_node_maxrecs=$(((dbsize - alloc_block_len) / 12))
+
+# Create a big file with a size such that the punches below create the exact
+# free extents we want.
+num_holes=$((allocbt_leaf_maxrecs * allocbt_node_maxrecs - 1))
+$XFS_IO_PROG -c "falloc 0 $((9 * dbsize + num_holes * dbsize * 2))" -f "$SCRATCH_MNT/big"
+
+# Fill in any small free extents in AG 0. After this, there should be only one,
+# large free extent.
+_scratch_unmount
+mapfile -t gaps < <(_scratch_xfs_db -c 'agf 0' -c 'addr cntroot' -c btdump |
+	$SED_PROG -rn 's/^[0-9]+:\[[0-9]+,([0-9]+)\].*/\1/p' |
+	tac | tail -n +2)
+_scratch_mount
+for gap_i in "${!gaps[@]}"; do
+	gap=${gaps[$gap_i]}
+	$XFS_IO_PROG -c "falloc 0 $((gap * dbsize))" -f "$SCRATCH_MNT/gap$gap_i"
+done
+
+# Create enough free space records to make the bnobt and cntbt both full,
+# 2-level trees, plus one more record to make them split all the way to the
+# root and become 3-level trees. After this, there is a 7-block free extent in
+# the rightmost leaf of the cntbt, and all of the leaves of the cntbt other
+# than the rightmost two are full. Without the fix, the free list is also
+# empty.
+$XFS_IO_PROG -c "fpunch $dbsize $((7 * dbsize))" "$SCRATCH_MNT/big"
+"$here/src/punch-alternating" -o 9 "$SCRATCH_MNT/big"
+
+# Do an arbitrary operation that refills the free list. Without the fix, this
+# will allocate 6 blocks from the 7-block free extent in the rightmost leaf of
+# the cntbt, then try to insert the remaining 1 block free extent in the
+# leftmost leaf of the cntbt. But that leaf is full, so this tries to split the
+# leaf and fails because the free list is empty, returning EFSCORRUPTED.
+$XFS_IO_PROG -c "fpunch 0 $dbsize" "$SCRATCH_MNT/big"
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/xfs/601.out b/tests/xfs/601.out
new file mode 100644
index 00000000..0d70c3e5
--- /dev/null
+++ b/tests/xfs/601.out
@@ -0,0 +1,2 @@
+QA output created by 601
+Silence is golden
-- 
2.41.0

