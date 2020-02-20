Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E39BCC7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 03:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8D1421D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 03:26:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T9xy3Ivz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgBTD0j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 22:26:39 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34756 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727208AbgBTD0j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 22:26:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582169198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rVvfopNaIeKssHtje9fuGElfnCY5XVisxcjC1/+PV54=;
        b=T9xy3IvztMeOPglivGC3u4FE1xVngFKOesjBUl3CT9WLIJJpukYM27y561e/FAyh917yiJ
        U295IRtZCvHgY0nlNgoW97ST5dmiy3Dw44V8V34TDW5e4W1jjWRJ5SZwSonz8StO/fnH2i
        ugp4qSbcmdvLiokFAB7r6xU1o5sWfPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-KZT_qsbTN4mbGLBNLCtGwQ-1; Wed, 19 Feb 2020 22:26:30 -0500
X-MC-Unique: KZT_qsbTN4mbGLBNLCtGwQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA2DB13E2;
        Thu, 20 Feb 2020 03:26:29 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ABBA91001B0B;
        Thu, 20 Feb 2020 03:26:29 +0000 (UTC)
To:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: test that default grace periods init on first mount
Message-ID: <7c6b4646-d7c5-cc03-9c90-c17daa22071d@redhat.com>
Date:   Wed, 19 Feb 2020 21:26:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There's currently a bug in how default grace periods get set up
before the very first quotacheck runs; we try to read the quota
inodes before they are populated, and so the grace periods remain
empty.  The /next/ mount fills them in.  This is a regression test
for that bug.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/xfs/995 b/tests/xfs/995
new file mode 100755
index 00000000..477855b8
--- /dev/null
+++ b/tests/xfs/995
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 995
+#
+# Regression test xfs flaw which did not report proper quota default
+# grace periods until the 2nd mount of a new filesystem with quota.
+#
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
+. ./common/quota
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_quota
+
+_scratch_mkfs >$seqres.full 2>&1
+_qmount_option "usrquota"
+_qmount
+
+xfs_quota -x -c "state -u" $SCRATCH_MNT | grep "grace time"
+_scratch_unmount
+_qmount
+xfs_quota -x -c "state -u" $SCRATCH_MNT | grep "grace time"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/995.out b/tests/xfs/995.out
new file mode 100644
index 00000000..d10017d1
--- /dev/null
+++ b/tests/xfs/995.out
@@ -0,0 +1,7 @@
+QA output created by 995
+Blocks grace time: [7 days]
+Inodes grace time: [7 days]
+Realtime Blocks grace time: [7 days]
+Blocks grace time: [7 days]
+Inodes grace time: [7 days]
+Realtime Blocks grace time: [7 days]
diff --git a/tests/xfs/group b/tests/xfs/group
index 0cbd0647..235a2715 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -511,3 +511,4 @@
 511 auto quick quota
 512 auto quick acl attr
 513 auto mount
+995 auto quota quick

