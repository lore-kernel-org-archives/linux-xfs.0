Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F64C56202
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Nov 2020 08:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4AFC20888
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Nov 2020 08:21:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gAORvJsI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgKWIVk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Nov 2020 03:21:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47793 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725320AbgKWIVk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Nov 2020 03:21:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606119698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=QUQiy85GJjP0eouI6Gu5Tczh5zKuKGXXxvT492WzoOU=;
        b=gAORvJsIVb5VtTr/XuyUDP14xNdxvuswi5rSJMdRKJ9R1s+w/+XZkM/USFswnJDrYzvDuL
        G13RMxwAZjuDCXWW1YwZ0Fqm4Hj76FG+PxuedhhOrZEtsq3n6VAqphxLkl7rZnLnWuSDFE
        p8bI1x/wrt+lhMqbBXJcy9DH1x5KxSI=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-QIjRHdbeMOi96R_eCM_JDA-1; Mon, 23 Nov 2020 03:21:36 -0500
X-MC-Unique: QIjRHdbeMOi96R_eCM_JDA-1
Received: by mail-pf1-f199.google.com with SMTP id 185so6618585pfw.18
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2020 00:21:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QUQiy85GJjP0eouI6Gu5Tczh5zKuKGXXxvT492WzoOU=;
        b=daQMnYg0iq+OaRL0v8tz8ZbMEibzPoBnGnrN3zFFuKW8eZ8VfSuaZQOJutRl1J02B3
         3vM2TH3CaQ1E+1I2ll3xQdEuxjfD8q2oyNqak6wN3lM30oOg+ri0ITH9TfKfDds2hN9F
         YMk7eo7mx09RIyVM/m8IHFiePVGxZ3Ir4tT3dhWd5L5OYUtZO/Z1CgET+dllFB/bzF9U
         ELC1WhoQkSTRT7pb6/IkvvScbCiZVE/KGAWsIzwALj1Zc76w6nW4FCgpn6QZb0HJc4sk
         MgMFgZ1s5+IxB529O1A+mi1fhPxIzAnSKoHXTJS5z5yGcBY+UCuSoPuwBj5mMQeLeVve
         zCbg==
X-Gm-Message-State: AOAM532AGzcFY9V4lyxlOIq5WNAXbW0272mUeibj2RBpB0psnVmy6JT5
        h9azujuZRJJSjzNwxgmsGqO2nvryhunGN1eEX31GWrTQpItGNngwgPFUvIIEF0bIYI07W0CRN24
        htZfjR0M1LEAie9CbpyIN
X-Received: by 2002:a17:90a:7ac2:: with SMTP id b2mr24250018pjl.226.1606119695248;
        Mon, 23 Nov 2020 00:21:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkjMSUcDsM4b0Yz/qnejvRBIYjSUKk1CzuqVfpchCSkv1OTX84MXzlKAXKA8tBHpBW9jtIMQ==
X-Received: by 2002:a17:90a:7ac2:: with SMTP id b2mr24250002pjl.226.1606119695028;
        Mon, 23 Nov 2020 00:21:35 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k4sm5802840pfg.174.2020.11.23.00.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 00:21:34 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v2] generic: add test for XFS forkoff miscalcution on 32-bit platform
Date:   Mon, 23 Nov 2020 16:20:47 +0800
Message-Id: <20201123082047.2991878-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201118060258.1939824-1-hsiangkao@redhat.com>
References: <20201118060258.1939824-1-hsiangkao@redhat.com>
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
changes since v1:
 - update commit id since the fix has been upstreamed (Eryu);
 - switch to use scratch_mkfs instead since fixed inode size is
   prefered to keep XFS_LITINO value can trigger the issue for
   v4 (412) and v5 (336); and no need to use TEST_DIR
   "rm localfile" way
 - refine some inlined comments.

 tests/generic/618     | 67 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/618.out |  4 +++
 tests/generic/group   |  1 +
 3 files changed, 72 insertions(+)
 create mode 100755 tests/generic/618
 create mode 100644 tests/generic/618.out

diff --git a/tests/generic/618 b/tests/generic/618
new file mode 100755
index 00000000..bdaa3874
--- /dev/null
+++ b/tests/generic/618
@@ -0,0 +1,67 @@
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
+# Use fixed inode size 512, so both v4 and v5 can be tested,
+# and also make sure the issue can be triggered if the default
+# inode size is changed later.
+[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -i size=512"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount
+
+localfile="${SCRATCH_MNT}/testfile"
+touch $localfile
+
+# value cannot exceed XFS_ATTR_SF_ENTSIZE_MAX (256) or it will turn into
+# leaf form directly; the following combination can trigger the issue for
+# both v4 (XFS_LITINO = 412) & v5 (XFS_LITINO = 336) fses.
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

