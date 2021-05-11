Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F819C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 07:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 480F961926
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 07:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhEKHlc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 03:41:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38315 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229917AbhEKHla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 03:41:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620718824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BZgYovHYVMprOpKlke7fnJ9US28+nvTueCAME8/fMeA=;
        b=N6zVsv7/ZOc03PNjPPIgikvYRYtXWVjNqNhKFW7/qQKRoRTqcFWoh/JZqer20J57iXgHEB
        ySm7Wr8UvUTtSNQ+XKlGOotQEiE5Jxe0VUaOJXfk8owsh2HdtsdE8XJcu/IfEK4v8iYcl3
        DSNoXfFSgzOyX/mPV2qDPZb1DJMnPhA=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-neBTPKENMq6Y-Ydj1QfBNA-1; Tue, 11 May 2021 03:40:22 -0400
X-MC-Unique: neBTPKENMq6Y-Ydj1QfBNA-1
Received: by mail-pf1-f200.google.com with SMTP id k7-20020aa788c70000b029028ead4f0f50so12421848pff.10
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 00:40:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BZgYovHYVMprOpKlke7fnJ9US28+nvTueCAME8/fMeA=;
        b=dQtXqdYU2BKIXWxDrdHMP4qRDgx/upOmDRdzpsRydZ5e5JQnCbfa2doZxGuMKlZrs9
         h4l4SA45H+QB6nxDpk/TslpMgLSM6CyTrXw/w+moN2KTzgiRHQnychdb7XNhDShnEa68
         e1XZvt+bYQKEGV85UJsPKB9uMHOsYUZeBZ8TCMZvGIW4fZDQ+/qxVwOMuw0o0AdGiLXh
         eI6oMTYvjfBiiCOOAedYxTZnF+jgYra3X+PA+k8jsFMGZwQe/U3Baorp6w/p9Qy2F1Xe
         t38mkEOS6Yt4+xpizZppOH917jtfTjGRZkEyNKRauvMFWBrn6HVOmj4uxWwu7hSmWA2q
         Q9Kg==
X-Gm-Message-State: AOAM532saOKbmrp2NxscceKznhm0q9d63R5NO8Nq2b2aQywGsH2ESbdo
        buM5d7viHTb5zt1B3awya/WEQVH0ZF0YCIWZoOra1nj4dLtcFwOnDwQNwb4l1ictCmJuPzxdzNk
        w76OHNsP588e8ooQcMpUFyIPkVEqmOLkZRGF2G/t0b3Mv+ypyV5WFmyEBc+7IDsRRsP5A1cWzXg
        ==
X-Received: by 2002:a05:6a00:c81:b029:2cb:6db9:dfa9 with SMTP id a1-20020a056a000c81b02902cb6db9dfa9mr305524pfv.8.1620718821305;
        Tue, 11 May 2021 00:40:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy77FF/Yv49Ara22BlO+Kk34GK8NOpLqC9GdbI9/yOgv96OKLxMF5ElsMKBGAbjAX6lZ+bVhQ==
X-Received: by 2002:a05:6a00:c81:b029:2cb:6db9:dfa9 with SMTP id a1-20020a056a000c81b02902cb6db9dfa9mr305491pfv.8.1620718820949;
        Tue, 11 May 2021 00:40:20 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y3sm10820865pfl.153.2021.05.11.00.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 00:40:20 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 2/3] xfs: basic functionality test for shrinking free space in the last AG
Date:   Tue, 11 May 2021 15:39:44 +0800
Message-Id: <20210511073945.906127-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210511073945.906127-1-hsiangkao@redhat.com>
References: <20210511073945.906127-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add basic test to make sure the functionality works as expected.

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

