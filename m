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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 524D4C8300A
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0728522269
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eJz71FEU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbgKUIYF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Nov 2020 03:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgKUIYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Nov 2020 03:24:05 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1773BC0613CF;
        Sat, 21 Nov 2020 00:24:05 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 131so10172429pfb.9;
        Sat, 21 Nov 2020 00:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XZZ3HlCYDDFUFUzMpYwLb+U2F98R55JlsxdvagAGOQ8=;
        b=eJz71FEUJuqiTfexPCqkAtnFFTScoPJNynE1ueEanKotpj8T1lJPTFBrCqtFnZ9TPQ
         Up6lyh0406AL/B2PuYNGc5uOIT4vW33lWzNThufoiyRlTuW/u82WlDH6jM6DEJljRCnF
         pN2BEMUKAjph4ZDZbUkO9rQzBcUMUapA15RaU3TL4tGlwYAD3tOLcEETs0bBg19LgWEq
         RL7hyMTOn4Svwamrt7477MyHXvWCz6g6atjCt+Bx2O5yuYoGd0/wnyLqVbsgTrQssmRg
         0BllXdvec9w+VIeVPeKFotyGUszash//wSyO/exUWvt8t0uDzvcpj5wkVSD29olkV5wi
         8ngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XZZ3HlCYDDFUFUzMpYwLb+U2F98R55JlsxdvagAGOQ8=;
        b=j9meFe9pp2xHAS6rrcLeWjlMXlRRRsH5QL+TmaG1bCNLr5sLpNC0LlmZLIw17dFkhm
         lxALWPzGs2PxXg0VhsRheNjKxXnW+I3NsuRaLO0O4lMUZX6kEbtTWW9HxZ9dqM6UIgMw
         MH6x8iLN3QlTQjmEfdiLd6S290FCel4a9wr6K7U4i17xU0fOL2yGP+mDiLKvcraS88yo
         JdrCmx3srZqH5a9wcS2VGXZ2i6HG/Byyr7izwRal8MEYywMXjrq4r9aLV5/H4owWiHai
         FtE4XgOAVLHLHjUOFQ//MuA0cTJHtwvebBYLNVGULiNgCjcyvU3RDWJF9oq5jYrR65rG
         CSGg==
X-Gm-Message-State: AOAM530aaokWvxPAC3h976lVWbIX+AO1uYdlm38BqOkBukvTGFC5N0i2
        Hv1HLtnoLeTZvYKdOj8KEvjZGRsuYqU=
X-Google-Smtp-Source: ABdhPJw2TYLSgiEK9QTkKzSVHenGa0d1m1erkdX8nQDbBgaaE8KNvlFeZKVjBAeFZ8ecv0CFxzHqng==
X-Received: by 2002:a63:550e:: with SMTP id j14mr8743141pgb.44.1605947044305;
        Sat, 21 Nov 2020 00:24:04 -0800 (PST)
Received: from localhost.localdomain ([122.167.41.102])
        by smtp.gmail.com with ESMTPSA id e22sm6167148pfd.153.2020.11.21.00.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 00:24:03 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH V2 08/11] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Sat, 21 Nov 2020 13:53:29 +0530
Message-Id: <20201121082332.89739-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201121082332.89739-1-chandanrlinux@gmail.com>
References: <20201121082332.89739-1-chandanrlinux@gmail.com>
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
index 00000000..d73b2b27
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
+nr_blks=40
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
+if (( $nextents > 35 )); then
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
+if (( $nextents > 35 )); then
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
index 00000000..33c8512c
--- /dev/null
+++ b/tests/xfs/528.out
@@ -0,0 +1,12 @@
+QA output created by 528
+Format and mount fs
+Inject reduce_max_iextents error tag
+Create a $srcfile having an extent of length 40 blocks
+* Write to shared extent
+Share the extent with $dstfile
+Buffered write to every other block of $dstfile's shared extent
+Verify $dstfile's extent count
+* Funshare shared extent
+Share the extent with $dstfile
+Funshare every other block of $dstfile's shared extent
+Verify $dstfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index c17bc140..ea892308 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -525,6 +525,7 @@
 525 auto quick attr
 526 auto quick dir hardlink symlink
 527 auto quick
+528 auto quick reflink
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
-- 
2.29.2

