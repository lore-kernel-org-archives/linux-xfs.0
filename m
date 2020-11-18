Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0604C56202
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Nov 2020 06:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5373F20867
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Nov 2020 06:04:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hWuYjbxl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgKRGDx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Nov 2020 01:03:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726300AbgKRGDx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Nov 2020 01:03:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605679431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=HzvyeujfFKLIvXuxNKNeGiQx+AAHm047ROdCac1kPl4=;
        b=hWuYjbxl18EFAHNWaCfRnxu9ug99xo9VbpbPtwW6W3Gs51YBNd9gbDcqKhrJ5IaZPyfx77
        UxMX/sArtJ8aFu/Apt1yBxYZFkQN7PqlVXpRuGigdmbh6ayEzFG/AMmvZrfhL0j51xll/r
        91imHH0FIEUOYnG/Yzi8LuRy+GqMv8Q=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-RiQrb8NSNBChqAnyyR5XRg-1; Wed, 18 Nov 2020 01:03:48 -0500
X-MC-Unique: RiQrb8NSNBChqAnyyR5XRg-1
Received: by mail-pl1-f199.google.com with SMTP id x3so640004plr.23
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 22:03:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HzvyeujfFKLIvXuxNKNeGiQx+AAHm047ROdCac1kPl4=;
        b=oWhAelu2w/3fPJsohdAoKEoMF25ov6/eBiQ1fbN/2hsgqjPpduTGGWMCFW/PdpgcIa
         Pj+M9RWcrnqJQw6TYgdv439Dm0RcK/xW5FHgv1WdL6XDa3jxoZaHZahk+kRP2fa2PiPG
         BYSRL+gyYUlSViV8oG3cdVt8eukdsGV2EF9B3uhUlq/8e+n4l5bn0PgZpRHzmxjRkehk
         vJxxqKJjkhbQIGOXGbcCCW9hxIwmddcori1ICGZld8UmonwaF2FFQDsMmgkdf4IAZ71P
         Sq9pIGThAW/rLn+TLecVR8ZwvXXFel8AQmWxqDIcbjNHHZFG+fyWsuejwrWqkCNtEfdc
         xJhA==
X-Gm-Message-State: AOAM532bWjJY1WnG9Djg2mm7lyasaI1rUkWxV+5WgZRHassXOBDSkRUo
        zu9RJYNE88E3xUTJVBpRPTjf6Rd1+XmApYzZSqPSOIyPKYOI594I3Eo8jHBS/ZaWDAY+Rm0LM79
        DnpZ4OmhRbMHRMSLX4XXI
X-Received: by 2002:a17:90b:180f:: with SMTP id lw15mr2571905pjb.119.1605679427694;
        Tue, 17 Nov 2020 22:03:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy1pTPkhex4msDlNl7bwW7S+jNuJmxsCwqwKFO14dR3Hl231xqo4X7s22G2Q7viVRsqktB0jQ==
X-Received: by 2002:a17:90b:180f:: with SMTP id lw15mr2571881pjb.119.1605679427395;
        Tue, 17 Nov 2020 22:03:47 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b1sm6321626pgg.74.2020.11.17.22.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 22:03:46 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH] generic: add test for XFS forkoff miscalcution on 32-bit platform
Date:   Wed, 18 Nov 2020 14:02:58 +0800
Message-Id: <20201118060258.1939824-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
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
I have no usable 32-bit test environment to run xfstests, that is
what I have checked:
 - checked this new script can pass on x86_64;
 - manually ran script commands on i386 buildroot with problematic
   kernel and the filesystem got stuck on getfattr command.

 tests/generic/618     | 56 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/618.out |  4 ++++
 tests/generic/group   |  1 +
 3 files changed, 61 insertions(+)
 create mode 100755 tests/generic/618
 create mode 100644 tests/generic/618.out

diff --git a/tests/generic/618 b/tests/generic/618
new file mode 100755
index 00000000..997c6f75
--- /dev/null
+++ b/tests/generic/618
@@ -0,0 +1,56 @@
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
+# xxxxxxxxxxxx ("xfs: fix forkoff miscalculation related to XFS_LITINO(mp)")
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
+_require_test
+_require_attrs user
+
+localfile="${TEST_DIR}/testfile"
+
+touch "${localfile}"
+"${SETFATTR_PROG}" -n user.0 -v "`seq 0 80`" "${localfile}"
+"${SETFATTR_PROG}" -n user.1 -v "`seq 0 80`" "${localfile}"
+
+# Make sure that changes are written to disk
+_test_cycle_mount
+
+# check getfattr result as well
+_getfattr --absolute-names -ebase64 -d $localfile | tail -n +2 | sort
+
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

