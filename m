Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6BFAC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 11:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F8CE64EC4
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 11:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCOLU2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 07:20:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43099 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229987AbhCOLUL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 07:20:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615807211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=29wigrAXPnA/jZTxqtk0BX4SJcHmQEY8/Z9LzGkDorA=;
        b=E4IJGGSUpEgOwqqDlUGOvJMIitGDWZ/lXNkbvT53ItvSGfZTaOGDDrkQx93GwdfKyfPmKz
        /jiLIrP6+Zx/5u4CqxZPgK8eYojukiF1rNOUDSghBv2uGUYG1pO001XQvHJlkEK4pqNPW7
        UT3BLnKx+gEpwl8nRzM75MDUt4GVjk4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-V1FOD0tQNpSQ6Bmr33IcMw-1; Mon, 15 Mar 2021 07:20:09 -0400
X-MC-Unique: V1FOD0tQNpSQ6Bmr33IcMw-1
Received: by mail-pl1-f198.google.com with SMTP id t18so16338873plr.15
        for <linux-xfs@vger.kernel.org>; Mon, 15 Mar 2021 04:20:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=29wigrAXPnA/jZTxqtk0BX4SJcHmQEY8/Z9LzGkDorA=;
        b=UKjRc8PG7VRznM/nua9ST2ahsKUeZdE5bCMzYN5AUhrvdXWZpJrJ0ZZbp09x8ah/xw
         9KlecTGZ4gFJXpwzgTpmtzGDknFTflb5+dxITTEDopcpxa+/UPbv4V2Cc20WAZ5y/rtJ
         Lh83XE2LZpm5DaY2i+CHdADpZADPVxZJddgYb23i2iPvZjPIPdM2+F/yePDhUXAztWe2
         QuGlUuPeWFghzeRvF/XKfghmGWwLQJ4EM1brtiTK45LN4E1DFFRrMean664/fIF/iyo4
         KYw4EjkPj5GbSWY14SU6urIQoyQTYxn85yiPJeJkienN8vKjze6XDqMv/yoYpFunIBX3
         CUkg==
X-Gm-Message-State: AOAM533fmh6LU6yyoupL/V9IaS/QSaVuX8TO1NqHG98TKV42IAzuVhp5
        9Z20/LXqIWpataIEh5SRDZ+X4TFeWPLQvM0KpGy1m6FzeChXM44Yuby0lP33VWJk9kEgk+0MM00
        quMjywHwHYFv6m1Dd4Jm+qy/a10Zp92VceJ2lNb8LJIOV233BASU6PWK8UK7h8Zv2zO3mv7dOqA
        ==
X-Received: by 2002:a17:90b:94c:: with SMTP id dw12mr12341385pjb.119.1615807208443;
        Mon, 15 Mar 2021 04:20:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwQMxW+eDNgygwpp4EdmLeHwXfJjPI3m3Rmzt6tUtrGTNqteJDp1PgTkEV3y4LdbYKmhwljg==
X-Received: by 2002:a17:90b:94c:: with SMTP id dw12mr12341347pjb.119.1615807208106;
        Mon, 15 Mar 2021 04:20:08 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r23sm11058448pje.38.2021.03.15.04.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 04:20:07 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v3 2/3] xfs: basic functionality test for shrinking free space in the last AG
Date:   Mon, 15 Mar 2021 19:19:25 +0800
Message-Id: <20210315111926.837170-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315111926.837170-1-hsiangkao@redhat.com>
References: <20210315111926.837170-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add basic test to make sure the functionality works as expected.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 tests/xfs/990     | 70 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/990.out | 12 ++++++++
 tests/xfs/group   |  1 +
 3 files changed, 83 insertions(+)
 create mode 100755 tests/xfs/990
 create mode 100644 tests/xfs/990.out

diff --git a/tests/xfs/990 b/tests/xfs/990
new file mode 100755
index 00000000..3c79186e
--- /dev/null
+++ b/tests/xfs/990
@@ -0,0 +1,70 @@
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
+	_repair_scratch_fs >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	$XFS_INFO_PROG $SCRATCH_MNT 2>&1 | _filter_mkfs 2>$tmp.growfs >/dev/null
+	. $tmp.growfs
+	[ $ret -eq 0 -a $1 -eq $dblocks ]
+}
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_shrink
+
+rm -f $seqres.full
+echo "Format and mount"
+_scratch_mkfs -dsize="$((512 * 1024 * 1024))" -dagcount=3 2>&1 | \
+	tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
+. $tmp.mkfs
+t_dblocks=$dblocks
+_scratch_mount >> $seqres.full
+
+echo "Shrink fs (small size)"
+test_shrink $((t_dblocks-512*1024/dbsize)) || \
+	_fail "Shrink fs (small size) failure"
+
+echo "Shrink fs (half AG)"
+test_shrink $((t_dblocks-agsize/2)) || \
+	_fail "Shrink fs (half AG) failure"
+
+echo "Shrink fs (out-of-bound)"
+test_shrink $((t_dblocks-agsize-1)) && \
+	_fail "Shrink fs (out-of-bound) failure"
+[ $dblocks -ne $((t_dblocks-agsize/2)) ] && \
+	_fail "dblocks changed after shrinking failure"
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

