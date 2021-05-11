Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF21C43460
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 23:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 191B76188B
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 23:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhEKXeG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 19:34:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31245 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229994AbhEKXeF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 19:34:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620775978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hfCHImshba9IOoo/nBIHq5PDDEyhMTFYZzJFFaF5/XI=;
        b=QzUW0EL30+ezGu5uIalkQeUdP3lVGscoz01ZWszrfhKQEmWaScoHzc9Zq4yC/4ouO4n2m6
        s+4+TPW3dyyQTYFouhtzvaUbJRStH+Hu7LKvuH2I6mssi+i371eI4bOiDz24W6Ix9QFu9a
        X6bP7p8RONa992VtqyJB4EPxuLJsJDk=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-3RRdbFRiOF6Xans6O0NifA-1; Tue, 11 May 2021 19:32:57 -0400
X-MC-Unique: 3RRdbFRiOF6Xans6O0NifA-1
Received: by mail-pl1-f200.google.com with SMTP id f2-20020a1709031042b02900ef82a95ef4so148829plc.3
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 16:32:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hfCHImshba9IOoo/nBIHq5PDDEyhMTFYZzJFFaF5/XI=;
        b=YStR02s3x5slbmQmKxCWPINBjV5FFbg4W8q3QwDeyJzItZxirOwPLwGt5aZ/5hL1JQ
         WDxy8YpigKziZ410rexyOBAb+J226zxsFh91dwbMYPqMyQtLEQ34jht+7DPxiaR/D3P4
         /nPWvUG/+Zd3u0Dt4aZj8QPKOZQBo+M94czFsUD/J8aPTy7mKyywbt5Yha1e8bbuiCpF
         ZoJ6tBh856A72Th2Byi0OByVm1A1t6DEfjLdz3KHXEJt/aFjO2iYuXDs0yoKU70cRLKU
         wq+afWjvF5GqUg9s46+O0DEyWd7r7AhHOzIexo+qq7GruvXXqmC8uK2pnAd6uTAKiAN1
         TbBw==
X-Gm-Message-State: AOAM5327rng0AKQHUwcZvh5nWCUpGSfwARHn3kGhHG8Zs7OEQ4Vg3ktN
        mMr4IkTfPjcDXLfWaOdJcjXP5WklH2xuAfpCKkYSd8idbj3jZa8iLK2EPoJaxqA8hYIaaTRvCtn
        ajVkrnHyt6jXTTwJetmGYXfhkZl0raCN+T5bVWQV5lQXiUY75rfWdmmu7G1vLPIs7rWGZtcJt+w
        ==
X-Received: by 2002:a63:1d06:: with SMTP id d6mr32657813pgd.202.1620775975870;
        Tue, 11 May 2021 16:32:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfNy7iy4UrXyLd1lXYaA+H37XVetpD34r/bIBT+aJ2w69IB6SLNkXjvv11Mgp4LXS8JEM/MA==
X-Received: by 2002:a63:1d06:: with SMTP id d6mr32657785pgd.202.1620775975507;
        Tue, 11 May 2021 16:32:55 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s3sm15828393pgs.62.2021.05.11.16.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 16:32:55 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v6 2/3] xfs: basic functionality test for shrinking free space in the last AG
Date:   Wed, 12 May 2021 07:32:27 +0800
Message-Id: <20210511233228.1018269-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210511233228.1018269-1-hsiangkao@redhat.com>
References: <20210511233228.1018269-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add basic test to make sure the functionality works as expected.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 tests/xfs/990     | 73 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/990.out | 12 ++++++++
 tests/xfs/group   |  1 +
 3 files changed, 86 insertions(+)
 create mode 100755 tests/xfs/990
 create mode 100644 tests/xfs/990.out

diff --git a/tests/xfs/990 b/tests/xfs/990
new file mode 100755
index 00000000..ec2592f6
--- /dev/null
+++ b/tests/xfs/990
@@ -0,0 +1,73 @@
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
+test_shrink()
+{
+	$XFS_GROWFS_PROG -D"$1" $SCRATCH_MNT >> $seqres.full 2>&1
+	ret=$?
+
+	_scratch_unmount
+	_check_scratch_fs
+	_scratch_mount
+
+	$XFS_INFO_PROG $SCRATCH_MNT 2>&1 | _filter_mkfs 2>$tmp.growfs >/dev/null
+	. $tmp.growfs
+	[ $ret -eq 0 -a $1 -eq $dblocks ]
+}
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_scratch_shrink
+
+rm -f $seqres.full
+echo "Format and mount"
+
+# agcount = 1 is forbidden on purpose, and need to ensure shrinking to
+# 2 AGs isn't feasible yet. So agcount = 3 is the minimum number now.
+_scratch_mkfs -dsize="$((512 * 1024 * 1024))" -dagcount=3 2>&1 | \
+	tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
+. $tmp.mkfs
+t_dblocks=$dblocks
+_scratch_mount >> $seqres.full
+
+echo "Shrink fs (small size)"
+test_shrink $((t_dblocks-512*1024/dbsize)) || \
+	echo "Shrink fs (small size) failure"
+
+echo "Shrink fs (half AG)"
+test_shrink $((t_dblocks-agsize/2)) || \
+	echo "Shrink fs (half AG) failure"
+
+echo "Shrink fs (out-of-bound)"
+test_shrink $((t_dblocks-agsize-1)) && \
+	echo "Shrink fs (out-of-bound) failure"
+[ $dblocks -ne $((t_dblocks-agsize/2)) ] && \
+	echo "dblocks changed after shrinking failure"
+
+$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
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
index fe83f82d..472c8f9a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -520,3 +520,4 @@
 537 auto quick
 538 auto stress
 539 auto quick mount
+990 auto quick growfs shrinkfs
-- 
2.27.0

