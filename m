Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46EFC43333
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA14C65275
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCIEkM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:40:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229872AbhCIEkJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:40:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684B86523B;
        Tue,  9 Mar 2021 04:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264809;
        bh=won8P26HD3UWLjx3SPmMJ0Gn5xM9EYpQhFiLLUgkBGQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p9e0tImGdK0aoTQgmKIq43PpNocxVXDYHp0bCWusyjLbM5fsXUWT8DR7h4B9JLUKR
         AwiP2wgXUCnnNTYtPdiLlsLw0gLndbCdKClFUF04UbFUTKhY6owIG3TxO3QCUPuSwW
         DlAfrOZA5gZKuUmCF4kEsIe4xuBGvYg56VeuqbFRnh5V9o7vuu0V6cNgAd8cKu2GZZ
         T0CpExWxdmrJ+UIH8ltbGc9urRN5IJmYMrPbpMTQxZ98ZjBgi/T1HpT7QRECDfAkHn
         5WazVlRQfxKgk0rd8yKJ8icgHWwyW0YLVMXIfIBmkeMGmMsQ7MEODZs041oi0maFqK
         Kuv9MAZfqYUsg==
Subject: [PATCH 01/10] xfs: test regression in xfs_bmap_validate_extent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:40:09 -0800
Message-ID: <161526480925.1214319.17395174541667296356.stgit@magnolia>
In-Reply-To: <161526480371.1214319.3263690953532787783.stgit@magnolia>
References: <161526480371.1214319.3263690953532787783.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test to make sure that we can have realtime files
with xattr blocks and not trip the verifiers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/758     |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/758.out |    2 ++
 tests/xfs/group   |    1 +
 3 files changed, 62 insertions(+)
 create mode 100755 tests/xfs/758
 create mode 100644 tests/xfs/758.out


diff --git a/tests/xfs/758 b/tests/xfs/758
new file mode 100755
index 00000000..a247701e
--- /dev/null
+++ b/tests/xfs/758
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 758
+#
+# This is a regression test for commit d0c20d38af13 "xfs: fix
+# xfs_bmap_validate_extent_raw when checking attr fork of rt files", which
+# fixes the bmap record validator so that it will not check the attr fork
+# extent mappings of a realtime file against the size of the realtime volume.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
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
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_realtime
+
+rm -f $seqres.full
+
+# Format filesystem with very tiny realtime volume
+_scratch_mkfs -r size=256k > $seqres.full
+_scratch_mount >> $seqres.full
+
+# Create a realtime file
+$XFS_IO_PROG -f -R -c 'pwrite 0 64k' -c stat $SCRATCH_MNT/v >> $seqres.full
+
+# Add enough xattr data to force creation of xattr blocks at a higher address
+# on the data device than the size of the realtime volume
+for i in `seq 0 16`; do
+	$ATTR_PROG -s user.test$i $SCRATCH_MNT/v < $SCRATCH_MNT/v >> $seqres.full
+done
+
+# Force flushing extent maps to disk to trip the verifier
+_scratch_cycle_mount
+
+# Now let that unmount
+echo Silence is golden.
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/758.out b/tests/xfs/758.out
new file mode 100644
index 00000000..6d219f8e
--- /dev/null
+++ b/tests/xfs/758.out
@@ -0,0 +1,2 @@
+QA output created by 758
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 754fc7be..4dd9901f 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -500,4 +500,5 @@
 525 auto quick mkfs
 526 auto quick mkfs
 527 auto quick quota
+758 auto quick rw attr realtime
 763 auto quick rw realtime

