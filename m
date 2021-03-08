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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F327EC43332
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5EF965225
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhCHPwA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhCHPvh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 10:51:37 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EBAC06174A;
        Mon,  8 Mar 2021 07:51:37 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y67so7487068pfb.2;
        Mon, 08 Mar 2021 07:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MoDGt/puC7EasHZqr7Mk0ROfRwgl6CKozyZM4S00kYM=;
        b=PQZHt66DgfXOWMSaY3wD2ikpWXJm90zjRWAgNlQWTP7LDhp3xPH2f+l1LZ51v/z3Cn
         h1lHKWdu6tnm2HorMbFNBSgBzfprDIrzf/oujUoPyjcs3/U06LX7pWW3Ua0KGU0Zpb+z
         f2dfzA9nw9W7HpZdiH2t944ynQOtMzJtRRKvR7hjqWVBk8b2SCc5+nC9iXsOGZ0joAyE
         0xz/lsCDGNbOV40VJdSJFN1A39kSvYeeIN5oGSXDoZOD3ACEFQ/8eHCOX52/9NNolLVO
         HolJ9hcT7JUnAkBVuTvTHvXuRFnUXAv4AZJJfNGTkK8e0WnGe9B4xfHlQzaAZRX90CGk
         Gnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MoDGt/puC7EasHZqr7Mk0ROfRwgl6CKozyZM4S00kYM=;
        b=Qz83y4y+LkzRiEaS1GAlK/KZwiu5MYpMQ1WmWLWaB4Vkax0Kj19pD54nfntpWT+Fjq
         gKHPSLBiq+amvhcoQDPdr5Du0LBtT33CWEXzouaaHxvcBGa7DkLDQNbwMgvrV0vw7Aht
         jIjCxe/tDYKmZY7J8vss3v6ePmqmTb/DHZSSRTT23JKevh4wTJ1RGMJ/E2cSYBj3M/5U
         MhjYfbXW9+7s8Ya01aaSieCX6LgORQxYuYU0vULm3jEo3XmI6kQ0L05mvNnxImp/cCYm
         PlUx8b4wBCBOAwnk7BVrWM5Cv5fNk/ujJgtvncSvvQLUw56RUlGHDvo62m9CpMrbTZsk
         +9Pg==
X-Gm-Message-State: AOAM5306cpBIcxS2FXYKqzPBk+jkoSh15AyEnVNNk33qkzLHMuHINtAr
        GUbUxlgam1F03QiUyAyl26RZeLFVhKU=
X-Google-Smtp-Source: ABdhPJxtyxIY7iq2G8rMRdPPC7MBApGNIVpH3E28cFDuwxoY6N/6yF/OJvSeeNpMfkUDyCxZ5LjMdg==
X-Received: by 2002:aa7:9824:0:b029:1ef:2104:c72d with SMTP id q4-20020aa798240000b02901ef2104c72dmr20284365pfl.20.1615218697107;
        Mon, 08 Mar 2021 07:51:37 -0800 (PST)
Received: from localhost.localdomain ([122.182.238.13])
        by smtp.gmail.com with ESMTPSA id s4sm11086378pji.2.2021.03.08.07.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:51:36 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V5 07/13] xfs: Check for extent overflow when adding/removing xattrs
Date:   Mon,  8 Mar 2021 21:21:05 +0530
Message-Id: <20210308155111.53874-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308155111.53874-1-chandanrlinux@gmail.com>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when adding/removing xattrs.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/531     | 139 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/531.out |  18 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 158 insertions(+)
 create mode 100755 tests/xfs/531
 create mode 100644 tests/xfs/531.out

diff --git a/tests/xfs/531 b/tests/xfs/531
new file mode 100755
index 00000000..a487318f
--- /dev/null
+++ b/tests/xfs/531
@@ -0,0 +1,139 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 531
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# adding/removing xattrs.
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
+naextents=$(xfs_get_fsxattr naextents $testfile)
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
+	naextents=$(xfs_get_fsxattr naextents $testfile)
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
diff --git a/tests/xfs/531.out b/tests/xfs/531.out
new file mode 100644
index 00000000..7b699b7a
--- /dev/null
+++ b/tests/xfs/531.out
@@ -0,0 +1,18 @@
+QA output created by 531
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
index 463d810d..7e284841 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -528,3 +528,4 @@
 528 auto quick quota
 529 auto quick realtime growfs
 530 auto quick punch zero insert collapse
+531 auto quick attr
-- 
2.29.2

