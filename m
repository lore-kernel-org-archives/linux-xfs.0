Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6207C43381
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 13:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88C4A64FA7
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 13:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhCLNYL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Mar 2021 08:24:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhCLNXw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Mar 2021 08:23:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615555431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Obz55tqwk+13dV5VeG0fLI6CXBu/1A0GASoXYW+Q3I=;
        b=ADVXPtGkaV+DdDwf+DvPf+fAr/vuY3WRZdg3pmD89CMNC5ArYF1AL4L5GZAYcEO+yi5c4U
        wUeigaWExEog8+cEwbcHdQdNHSA0e2F/Y7nbDjw0lvYAp4Gt4bCIALeqYYiXIF4ZB/sdCN
        u2l2RM4joCiGnmu7mQeXbqd0Wx28poA=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-VXj0vfqIPN2CRxfrRSRXhw-1; Fri, 12 Mar 2021 08:23:50 -0500
X-MC-Unique: VXj0vfqIPN2CRxfrRSRXhw-1
Received: by mail-pg1-f200.google.com with SMTP id q36so9094866pgb.23
        for <linux-xfs@vger.kernel.org>; Fri, 12 Mar 2021 05:23:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Obz55tqwk+13dV5VeG0fLI6CXBu/1A0GASoXYW+Q3I=;
        b=qEQ6IAnDseY6dambxNNXPlYFCQMEIV+Tgd/IxlNFWT1eP+yZ1WoNAWMGwIIClZBAHo
         6b2jF7pDsrtr4CiJpPxC2ey3soUB9EOVT4o7GTali9+iOXZTwOxPoKi1+FKl2Ef58bCb
         Gfp56SuVZ+MaTWbXzBSxROErBNUWFFcGndSXN5BZ98lwkLwNnctEb5pb7K7Lb9P4F3e3
         PP+i+K0jrDbxJkrXNGDwI099pGcjMTON4sAs2v4czr+oLIaHs9Z/1ka6fx4b3SuS/J/Y
         Qvx47RcRRkWLjh2IqwYBiVpVzfA6Q1m0O205tkquFpMWubUNNc/sOQruGyHE31AxI6HC
         3HKw==
X-Gm-Message-State: AOAM5300XA/W7ikr+OoHekiu1YTGpoumlABmf2UzUiTWuMu3gt+Xm/hC
        SmJJuHVK2Giyo6a/PkkuppU0x0GQF9zuPtUgfbdZNyaTnDUbKIY1IG/1y2UpMmJpm7bU7oAxxuB
        34M9evp9fucXiIEc/Jl8DKXdoWG2A1HBsFE3dLPtnvfQDyy+hxtAIVe1OdKTwW+Qyv2Pp0ZtzrA
        ==
X-Received: by 2002:a17:90a:9b18:: with SMTP id f24mr13648530pjp.96.1615555428791;
        Fri, 12 Mar 2021 05:23:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzWTPI2f6eF9Idun13MHaXgf5V6OeknSj0OiUzHCyxU8ULg84ZrD2NYcKTPILfIrsn1ss/LRQ==
X-Received: by 2002:a17:90a:9b18:: with SMTP id f24mr13648517pjp.96.1615555428437;
        Fri, 12 Mar 2021 05:23:48 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j17sm5428234pfn.70.2021.03.12.05.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 05:23:48 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v2 2/3] xfs: basic functionality test for shrinking free space in the last AG
Date:   Fri, 12 Mar 2021 21:22:59 +0800
Message-Id: <20210312132300.259226-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312132300.259226-1-hsiangkao@redhat.com>
References: <20210312132300.259226-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add basic test to make sure the functionality works as expected.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 tests/xfs/990     | 59 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/990.out | 12 ++++++++++
 tests/xfs/group   |  1 +
 3 files changed, 72 insertions(+)
 create mode 100755 tests/xfs/990
 create mode 100644 tests/xfs/990.out

diff --git a/tests/xfs/990 b/tests/xfs/990
new file mode 100755
index 00000000..551c4784
--- /dev/null
+++ b/tests/xfs/990
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 990
+#
+# XFS shrinkfs basic functionality test
+#
+# This test attempts to shrink with a small size (512K), half AG size and
+# an out-of-bound size (agsize + 1) to observe if it works as expected.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_shrink
+
+rm -f $seqres.full
+echo "Format and mount"
+size="$((512 * 1024 * 1024))"
+_scratch_mkfs -dsize=$size -dagcount=3 2>&1 | \
+	tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
+. $tmp.mkfs
+_scratch_mount >> $seqres.full 2>&1
+
+echo "Shrink fs (small size)"
+$XFS_GROWFS_PROG -D $((dblocks-512*1024/dbsize)) $SCRATCH_MNT \
+	>> $seqres.full 2>&1 || echo failure
+_scratch_cycle_mount
+
+echo "Shrink fs (half AG)"
+$XFS_GROWFS_PROG -D $((dblocks-agsize/2)) $SCRATCH_MNT \
+	>> $seqres.full 2>&1 || echo failure
+_scratch_cycle_mount
+
+echo "Shrink fs (out-of-bound)"
+$XFS_GROWFS_PROG -D $((dblocks-agsize-1)) $SCRATCH_MNT \
+	>> $seqres.full 2>&1 && echo failure
+_scratch_cycle_mount
+
+$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
+
+_scratch_unmount
+echo "*** done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/990.out b/tests/xfs/990.out
new file mode 100644
index 00000000..812f89ef
--- /dev/null
+++ b/tests/xfs/990.out
@@ -0,0 +1,12 @@
+QA output created by 990
+Format and mount
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+Shrink fs (small size)
+Shrink fs (half AG)
+Shrink fs (out-of-bound)
+*** done
diff --git a/tests/xfs/group b/tests/xfs/group
index e861cec9..a7981b67 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -525,3 +525,4 @@
 525 auto quick mkfs
 526 auto quick mkfs
 527 auto quick quota
+990 auto quick growfs
-- 
2.27.0

