Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5582FC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 08:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376782AbiDTIkP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 04:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376778AbiDTIkO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 04:40:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53D9329C9B
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 01:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650443848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v2NoSVN63TT707mkcF5bFPXcuOQ+x5KpSiqBnEzmmpo=;
        b=eyXIQ1Evdqbu0e3VStYCTg0kAADIQuH+80skBt5Mq8j8XJ7BorjNN1sR+OEYEB8Sz2JBcp
        Bb5Co8p0AucLnSNxPT3LDjnTP8oHwccSdV1I+Ea2AvREU5du1yqNNpWzrQ6hXN3K6RXBPK
        3AA/jojmv8o/LxfkKFkG0Epua0d6AnA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-gp_6cBH7PzyjS_neEaiiUg-1; Wed, 20 Apr 2022 04:37:27 -0400
X-MC-Unique: gp_6cBH7PzyjS_neEaiiUg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B702D1C04B5B;
        Wed, 20 Apr 2022 08:37:26 +0000 (UTC)
Received: from zlang-laptop.redhat.com (ovpn-12-143.pek2.redhat.com [10.72.12.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AAA640D1B98;
        Wed, 20 Apr 2022 08:37:24 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] fstests: test xfs swapext log replay
Date:   Wed, 20 Apr 2022 16:36:53 +0800
Message-Id: <20220420083653.1031631-5-zlang@redhat.com>
In-Reply-To: <20220420083653.1031631-1-zlang@redhat.com>
References: <20220420083653.1031631-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If an inode had been in btree format and had a data fork owner change
logged (XFS_ILOG_DOWNER), after changing the format to non-btree, will
hit an ASSERT in xfs_recover_inode_owner_change() which enforces that
if XFS_ILOG_[AD]OWNER is set.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

3+ years past, this test is still failed on latest upstream linux kernel,
as we talked below:
https://patchwork.kernel.org/project/fstests/patch/20181223141721.5318-1-zlang@redhat.com/

I think it's time to bring it back to talk again. If it's a case issue, I'll fix.
If it's a bug, means this case is good to merge.

Thanks,
Zorro

 tests/xfs/999     | 58 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |  2 ++
 2 files changed, 60 insertions(+)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 00000000..b1d58671
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat Inc.  All Rights Reserved.
+#
+# FS QA Test 999
+#
+# If an inode had been in btree format and had a data fork owner change
+# logged, after changing the format to non-btree, will hit an ASSERT or
+# fs corruption.
+# This case trys to cover: dc1baa715bbf ("xfs: do not log/recover swapext
+# extent owner changes for deleted inodes")
+#
+. ./common/preamble
+_begin_fstest auto quick fsr
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch
+_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
+. $tmp.mkfs
+
+_scratch_mount
+localfile=$SCRATCH_MNT/fragfile
+
+# Try to create a file with 1024 * (3 blocks + 1 hole):
+# +----------+--------+-------+----------+--------+
+# | 3 blocks | 1 hole |  ...  | 3 blocks | 1 hole |
+# +----------+--------+-------+----------+--------+
+#
+# The number of extents we can get maybe more or less than 1024, this method
+# just to get a btree inode format.
+filesize=$((dbsize * 1024 * 4))
+for i in `seq $filesize -$dbsize 0`; do
+	if [ $((i % (3 * dbsize))) -eq 0 ]; then
+		continue
+	fi
+	$XFS_IO_PROG -f -d -c "pwrite $i $dbsize" $localfile >> $seqres.full
+done
+
+# Make a data fork owner change log
+$XFS_FSR_PROG -v -d $localfile >> $seqres.full 2>&1
+
+# Truncate the file to 0, and change the inode format to extent, then shutdown
+# the fs to keep the XFS_ILOG_DOWNER flag
+$XFS_IO_PROG -t -x -c "pwrite 0 $dbsize" \
+	     -c "fsync" \
+	     -c "shutdown" $localfile >> $seqres.full
+
+# Cycle mount, to replay the log
+_scratch_cycle_mount
+
+echo "Silence is golden"
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
new file mode 100644
index 00000000..3b276ca8
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden
-- 
2.31.1

