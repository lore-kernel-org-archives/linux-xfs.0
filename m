Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B249C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 14:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbiBPOzt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 09:55:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiBPOzp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Feb 2022 09:55:45 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A629E1F6B8A;
        Wed, 16 Feb 2022 06:55:31 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id x3so2315961qvd.8;
        Wed, 16 Feb 2022 06:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yJ4BKoDTgpBeh9Yya190I1Dqz9YT3SLMArUe9t7BrEg=;
        b=JSQgXF8ZAt4V84HAckwAZv9Qrc+7c65S8ggyalVlczRsN7fgG/BgLpxlb7hNwpDE/z
         /7WAl3HEDXuE8iCm8hzsMltXsIZUeqXLLZMLK5SujMTFqRcXQD8Imoh8TqXKJ4kCIt5b
         Nh0QRBoMQZpubyCNmxDB/GcANAETBAbgcTbXxbP9K3lpaBpz5TfTD1OMnNYGl1TA2ihB
         9M1bhP8eO1pDMIKyQsysQtJcY2e/pzApKjuNZUw0JC+HYwyPW/p+zSlWmoSj5opMwUBs
         +IEck4pLG178gYIqYhkM/tvasbClK++od8ZMPQ40o5eHys8wC6ixjTmqkY9vabxiyEPF
         M93w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yJ4BKoDTgpBeh9Yya190I1Dqz9YT3SLMArUe9t7BrEg=;
        b=Dyk6+ivM7G0udsVUucbntEjnB371fmyuSlP3WFmk0BfpRfy4iPJxEmtiUb+H9hWfqR
         i1iIX3q0UJXSdiERMiVgf2coRUd6mSWDMadYkhEfSTwACDJch2W0Vz03fvlsAZX29yPA
         0+ws0P/8eXS+USl/Q2DIbvo8rJnRg+wKIDoRjM+4lJHePktKCxLnxz8obII08DoHon96
         IoOUkkuyTuQBThRXlebRnZ5NUNmN7Rjpm9xrEfyI1w9Xig6nPqM3HdRzXmtLNp9Ga3Fq
         zBU7vJhKnaIBn97cJOEtsAD2ne2bOWBF/K9UtkNllK7+X6DIfwPhlT6nTcDYlEsIZKvZ
         VGoQ==
X-Gm-Message-State: AOAM533xeX19deLo3RdDmJqik+SpwWl7VlkoNlcGB8id/9GyuSRIlYX2
        jNnckahegMlr4e6f6bYlks9lKVgjrA==
X-Google-Smtp-Source: ABdhPJyc/n0OGgUMfkcq8Wu2gJnrPfli9jVP4dS6sDNijwx8HMXjW1I9ldQGuQQ0wI+OJXcNGnSPSw==
X-Received: by 2002:ad4:4341:0:b0:42c:4b82:c16b with SMTP id q1-20020ad44341000000b0042c4b82c16bmr2038591qvs.73.1645023330646;
        Wed, 16 Feb 2022 06:55:30 -0800 (PST)
Received: from localhost (209-6-122-159.s2973.c3-0.arl-cbr1.sbo-arl.ma.cable.rcncustomer.com. [209.6.122.159])
        by smtp.gmail.com with UTF8SMTPSA id w19sm16451212qkp.6.2022.02.16.06.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 06:55:30 -0800 (PST)
From:   Masayoshi Mizuma <msys.mizuma@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Masayoshi Mizuma <msys.mizuma@gmail.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: test xfsdump with bind-mounted filesystem
Date:   Wed, 16 Feb 2022 09:55:20 -0500
Message-Id: <20220216145520.33677-1-msys.mizuma@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

commit 25195eb ("xfsdump: handle bind mount target") introduced
a bug of xfsdump which doesn't store the files to the dump file
correctly when the root inode number is changed.

The commit 25195eb is reverted, and commit 0717c1c ("xfsdump: intercept
bind mount targets") which is in xfsdump v3.1.10 fixes the bug to reject
the filesystem if it's bind-mounted.

Test that xfsdump can reject the bind-mounted filesystem.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 tests/xfs/544     | 45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/544.out |  2 ++
 2 files changed, 47 insertions(+)
 create mode 100755 tests/xfs/544
 create mode 100644 tests/xfs/544.out

diff --git a/tests/xfs/544 b/tests/xfs/544
new file mode 100755
index 00000000..11b9713e
--- /dev/null
+++ b/tests/xfs/544
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Fujitsu Limited. All Rights Reserved.
+#
+# FS QA Test 544
+#
+# Regression test for commit:
+# 0717c1c ("xfsdump: intercept bind mount targets")
+
+. ./common/preamble
+_begin_fstest auto dump
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -r -f $tmp.*
+	$UMOUNT_PROG $TEST_DIR/dest 2> /dev/null
+	rmdir $TEST_DIR/src 2> /dev/null
+	rmdir $TEST_DIR/dest 2> /dev/null
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/dump
+
+# real QA test starts here
+
+_supported_fs xfs
+
+# Setup
+mkdir $TEST_DIR/src
+mkdir $TEST_DIR/dest
+
+# Test
+echo "*** dump with bind-mounted test ***" >> $seqres.full
+
+$MOUNT_PROG --bind $TEST_DIR/src $TEST_DIR/dest || _fail "Bind mount failed"
+
+$XFSDUMP_PROG -L session -M test -f $tmp.dump $TEST_DIR/dest \
+	>> $seqres.full 2>&1 && echo "dump with bind-mounted should be failed, but passed."
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/xfs/544.out b/tests/xfs/544.out
new file mode 100644
index 00000000..fc7ebff3
--- /dev/null
+++ b/tests/xfs/544.out
@@ -0,0 +1,2 @@
+QA output created by 544
+Silence is golden
-- 
2.31.1

