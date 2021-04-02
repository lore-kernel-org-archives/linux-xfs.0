Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7610BC433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 448C86112E
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbhDBJus (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:50:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59592 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234316AbhDBJur (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:50:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617357046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eZmCo68pLsRQMxydSQmBF2SVLlLDb6V2Qpmq+6Mw1Gk=;
        b=YWmDCecTyWHfilP+EiGMI2qdgp3fCBc7mjrNN1h1z/c7ggg1eknkO/MpESvkZRyMjkMtYe
        HACp6qui8wJQswf6HQgu7rv+MOCdELtElYip3mdvSPZ/DfyQ9sSprgw5uzRSsltkgozFK/
        xkPp5rXwt5bfF0six+VPLRouuoTfbfY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-85KpJa-hPBeLhuoesMyVSQ-1; Fri, 02 Apr 2021 05:50:44 -0400
X-MC-Unique: 85KpJa-hPBeLhuoesMyVSQ-1
Received: by mail-pf1-f200.google.com with SMTP id a6so5061518pfv.9
        for <linux-xfs@vger.kernel.org>; Fri, 02 Apr 2021 02:50:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eZmCo68pLsRQMxydSQmBF2SVLlLDb6V2Qpmq+6Mw1Gk=;
        b=aYHoACwe7k46d2noJmWrbzzh3EcJi2gUTID0zWmckTLc1SoInrhazAoV3GR8DSND5K
         eZ7fSBxop98wA7y5cGWPUGdxjuhbgcdWOD+x0hXkQEJlw23Kg/Zjm78gOsmq0uXP+st2
         VKDRJR0LJaOVnTyCMOKhd0/MqxMrioy0/FQ1CmNFq/0ZrYPZzBZNBHPBN2ZMJCs6uMSl
         mV/l/w8TAhQa4laGdvVv3PnUetOML97vfFS8q8JGuaPd4kDnAl94giXqnqaledtyxc1B
         9dme5k6Y6npCNSu5PGaJazHU9rHwR2grc0WNMJIJwJKyseZw3OZf2wIHwjM/dP0Qch7i
         vMSw==
X-Gm-Message-State: AOAM531URMr0/B9Y3y++xU298Ai4M6pn0IjAFlfGHzAj+MF4bYv2Mdaa
        Idyd7Rhd/M8TRsrqxUoGgsapo2BSpHFqjFEJiZbpEgAgZPtB1j7iOEAQRCbSIeEZhXklEMH9D++
        AqLe4/9+zWWc3pAGZtzVPLAEiDjgW6KTmRN2w36fxHwZdlz+7MP00xcvHJ1UnxG+70vMpdDQr7A
        ==
X-Received: by 2002:a05:6a00:1350:b029:227:7a8b:99c9 with SMTP id k16-20020a056a001350b02902277a8b99c9mr11496142pfu.73.1617357043568;
        Fri, 02 Apr 2021 02:50:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6gLwpYivSKA/oUqSJXpW10nEvuW6C9UeJ14UDcYopNJBAc/UckrVppG/ZjjAnvGaFwxn3yg==
X-Received: by 2002:a05:6a00:1350:b029:227:7a8b:99c9 with SMTP id k16-20020a056a001350b02902277a8b99c9mr11496113pfu.73.1617357043225;
        Fri, 02 Apr 2021 02:50:43 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l124sm7730354pfl.195.2021.04.02.02.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 02:50:42 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 2/3] xfs: basic functionality test for shrinking free space in the last AG
Date:   Fri,  2 Apr 2021 17:49:36 +0800
Message-Id: <20210402094937.4072606-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210402094937.4072606-1-hsiangkao@redhat.com>
References: <20210402094937.4072606-1-hsiangkao@redhat.com>
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
index 00000000..322b09e1
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
+# 2 AGs isn't fensible yet. So agcount = 3 is the minimum number now.
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

