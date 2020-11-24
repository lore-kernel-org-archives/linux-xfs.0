Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDC6C56201
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 10:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 916A92076B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 10:12:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GuW4vhDT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbgKXKMg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 05:12:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49545 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729105AbgKXKMg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 05:12:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606212754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=uUIi15RMx8EvnLvWg5cw4u9Z/jLS/aWC1Z3Hr59g+kI=;
        b=GuW4vhDTLNbA+lLk89nZsWmc0Pyx5XIlbqqoNfslEdejSSkzYXVxxMkWMF8YluqjCDVcF6
        GHzAnUnn4rlB/K1FNWfzs/4g6DE4FoK+jrmgKUdfc016tY04wAXonIIqJ6tSOj6GfuxT3g
        /IMHY2eAoHwWwOorjNfelHnm0D+hXeE=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-mf4HssVKNvCjDWsbXW9_7Q-1; Tue, 24 Nov 2020 05:12:32 -0500
X-MC-Unique: mf4HssVKNvCjDWsbXW9_7Q-1
Received: by mail-pg1-f198.google.com with SMTP id 1so6623222pgq.11
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 02:12:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uUIi15RMx8EvnLvWg5cw4u9Z/jLS/aWC1Z3Hr59g+kI=;
        b=nbWQPy0q2mVZNmY/stbTwDKucTS1t9tucgeuSAAhKGKp0t3JPC7IJH/0xL/5r9OOCC
         jS1dChOGVIGEJJWdM5wTE3BUJjBgTHWnQ+RiPfViajK/DAEq07ADG9IYTahzLGtsOYnp
         Rib3K3MJcxHVem3qpuiSLKeNFWQf7hxqeE2pgCU0wnIQrBFY9KXmRHjwizFB7P427lU5
         X2zTIrnP/y2mBmKXdC07dx5mbcal5Yy4fAahijgu3Ovrzxz5BX1QJs3SEOi7zJGElkjo
         yMNQXpWSjbpnJmiYCGQfNI4KXbHVTq56mxom/Bbvm46tE5hGAFi8E+Z4f0parSzInPhx
         RnUw==
X-Gm-Message-State: AOAM5300c5E37eAhHWheAEXza2za+L4tZwTIJEnn6668kpwVdG+tAR1C
        qjJ6CrvpZxX6RJFELpLoLzK9eOCNzKVcJxWkQtripdLYZCFu+iZkNp3kLJqVMon61i1zz96AOdW
        iupwjc7cMc5auoPOVJ/PX
X-Received: by 2002:a17:902:ee09:b029:d5:288d:fce4 with SMTP id z9-20020a170902ee09b02900d5288dfce4mr3338461plb.45.1606212751043;
        Tue, 24 Nov 2020 02:12:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzPa6Qswv1BdRBD2/eF6udc56Cqo3NAIxfn+5vebz80eUz23qvVRb/PF3r1eZXU9rOi4ppWZw==
X-Received: by 2002:a17:902:ee09:b029:d5:288d:fce4 with SMTP id z9-20020a170902ee09b02900d5288dfce4mr3338451plb.45.1606212750777;
        Tue, 24 Nov 2020 02:12:30 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a25sm14683207pfg.138.2020.11.24.02.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 02:12:30 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3] generic: add test for XFS forkoff miscalcution on 32-bit platform
Date:   Tue, 24 Nov 2020 18:11:45 +0800
Message-Id: <20201124101145.3230728-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201123082047.2991878-1-hsiangkao@redhat.com>
References: <20201123082047.2991878-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is a regression that recent XFS_LITINO(mp) update causes
xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0.

Therefore, one result is
  "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"

Add a regression test in fstests generic to look after that since
the testcase itself isn't xfs-specific.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
changes since v2:
 - "_require_no_xfs_bug_on_assert" to avoid crashing the system (Darrick);
 - refine a commit for more details (Darrick)

 tests/generic/618     | 75 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/618.out |  4 +++
 tests/generic/group   |  1 +
 3 files changed, 80 insertions(+)
 create mode 100755 tests/generic/618
 create mode 100644 tests/generic/618.out

diff --git a/tests/generic/618 b/tests/generic/618
new file mode 100755
index 00000000..f1c1605e
--- /dev/null
+++ b/tests/generic/618
@@ -0,0 +1,75 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat, Inc. All Rights Reserved.
+#
+# FS QA Test 618
+#
+# Verify that forkoff can be returned as 0 properly if it isn't
+# able to fit inline for XFS.
+# However, this test is fs-neutral and can be done quickly so
+# leave it in generic
+# This test verifies the problem fixed in kernel with commit
+# ada49d64fb35 ("xfs: fix forkoff miscalculation related to XFS_LITINO(mp)")
+
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
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs generic
+_require_scratch
+_require_attrs user
+
+if [ $FSTYP = "xfs" ]; then
+	# avoid crashing the system if possible
+	_require_no_xfs_bug_on_assert
+
+	# Use fixed inode size 512, so both v4 and v5 can be tested,
+	# and also make sure the issue can be triggered if the default
+	# inode size is changed later.
+	MKFS_OPTIONS="$MKFS_OPTIONS -i size=512"
+fi
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount
+
+localfile="${SCRATCH_MNT}/testfile"
+touch $localfile
+
+# value cannot exceed XFS_ATTR_SF_ENTSIZE_MAX (256) or it will turn into leaf
+# form directly; the following combination can trigger the issue for both v4
+# (XFS_LITINO = 412) & v5 (XFS_LITINO = 336) fses, in details the 2nd setattr
+# causes an integer underflow that is incorrectly typecast, leading to the
+# assert triggering.
+"${SETFATTR_PROG}" -n user.0 -v "`seq 0 80`" "${localfile}"
+"${SETFATTR_PROG}" -n user.1 -v "`seq 0 80`" "${localfile}"
+
+# Make sure that changes are written to disk
+_scratch_cycle_mount
+
+# getfattr won't succeed with the expected result if fails
+_getfattr --absolute-names -ebase64 -d $localfile | tail -n +2 | sort
+
+_scratch_unmount
+status=0
+exit
diff --git a/tests/generic/618.out b/tests/generic/618.out
new file mode 100644
index 00000000..848fdc58
--- /dev/null
+++ b/tests/generic/618.out
@@ -0,0 +1,4 @@
+QA output created by 618
+
+user.0=0sMAoxCjIKMwo0CjUKNgo3CjgKOQoxMAoxMQoxMgoxMwoxNAoxNQoxNgoxNwoxOAoxOQoyMAoyMQoyMgoyMwoyNAoyNQoyNgoyNwoyOAoyOQozMAozMQozMgozMwozNAozNQozNgozNwozOAozOQo0MAo0MQo0Mgo0Mwo0NAo0NQo0Ngo0Nwo0OAo0OQo1MAo1MQo1Mgo1Mwo1NAo1NQo1Ngo1Nwo1OAo1OQo2MAo2MQo2Mgo2Mwo2NAo2NQo2Ngo2Nwo2OAo2OQo3MAo3MQo3Mgo3Mwo3NAo3NQo3Ngo3Nwo3OAo3OQo4MA==
+user.1=0sMAoxCjIKMwo0CjUKNgo3CjgKOQoxMAoxMQoxMgoxMwoxNAoxNQoxNgoxNwoxOAoxOQoyMAoyMQoyMgoyMwoyNAoyNQoyNgoyNwoyOAoyOQozMAozMQozMgozMwozNAozNQozNgozNwozOAozOQo0MAo0MQo0Mgo0Mwo0NAo0NQo0Ngo0Nwo0OAo0OQo1MAo1MQo1Mgo1Mwo1NAo1NQo1Ngo1Nwo1OAo1OQo2MAo2MQo2Mgo2Mwo2NAo2NQo2Ngo2Nwo2OAo2OQo3MAo3MQo3Mgo3Mwo3NAo3NQo3Ngo3Nwo3OAo3OQo4MA==
diff --git a/tests/generic/group b/tests/generic/group
index 94e860b8..eca9d619 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -620,3 +620,4 @@
 615 auto rw
 616 auto rw io_uring stress
 617 auto rw io_uring stress
+618 auto quick attr
-- 
2.18.4

