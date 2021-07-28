Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF05C4320A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1579460F9E
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhG1AK0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 20:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhG1AKZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 20:10:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0912960F23;
        Wed, 28 Jul 2021 00:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627431025;
        bh=VqXfVgtRpmQ4yb8btzpYDzNNhC0lR6JyVXHk+GSpb9o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Si3hwTwM9aMX3FN3QJrBjVh6V0AVvJ242/M3z/moiroioB8AMLdHiiiJM04GmVeJZ
         H4kq7DMjK/BFFkN2Yv+bvxsW/W62bjwo4xm7PBtuaKd5scdLwC5358iG4K9pjBtfQU
         f1ubJqzAZEvCXzSFTk9uGubZIQT5Oq3IXH6/rgKOLBDNsAWTFpCvCASQpvU0cr0pBK
         AlY/RUU/XXh5OL2k2P46aZ/sw9/Xsp5KugZHiKDjn38urhFue9dOHDCBxZGSK9BnIp
         ZlTVgwHZaY4OUtpRWl3ra/XH9DdduR3BxM98aAKIUglYMamzke1392bGmB4/E7TJAc
         bzX+xfn8wUs1w==
Subject: [PATCH 1/3] generic: test xattr operations only
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Jul 2021 17:10:24 -0700
Message-ID: <162743102476.3428896.4543035331031604848.stgit@magnolia>
In-Reply-To: <162743101932.3428896.8510279402246446036.stgit@magnolia>
References: <162743101932.3428896.8510279402246446036.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Exercise extended attribute operations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/724     |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/724.out |    2 ++
 2 files changed, 59 insertions(+)
 create mode 100755 tests/generic/724
 create mode 100644 tests/generic/724.out


diff --git a/tests/generic/724 b/tests/generic/724
new file mode 100755
index 00000000..b19f8f73
--- /dev/null
+++ b/tests/generic/724
@@ -0,0 +1,57 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 724
+#
+# Run an extended attributes fsstress run with multiple threads to shake out
+# bugs in the xattr code.
+#
+. ./common/preamble
+_begin_fstest soak attr long_rw stress
+
+_cleanup()
+{
+	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
+	cd /
+	rm -f $tmp.*
+}
+
+# Modify as appropriate.
+_supported_fs generic
+
+_require_scratch
+_require_command "$KILLALL_PROG" "killall"
+
+echo "Silence is golden."
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+nr_cpus=$((LOAD_FACTOR * 4))
+nr_ops=$((70000 * nr_cpus * TIME_FACTOR))
+
+args=('-z' '-S' 'c')
+
+# Do some directory tree modifications, but the bulk of this is geared towards
+# exercising the xattr code, especially attr_set which can do up to 10k values.
+for verb in unlink rmdir; do
+	args+=('-f' "${verb}=1")
+done
+for verb in creat mkdir; do
+	args+=('-f' "${verb}=2")
+done
+for verb in getfattr listfattr; do
+	args+=('-f' "${verb}=3")
+done
+for verb in attr_remove removefattr; do
+	args+=('-f' "${verb}=4")
+done
+args+=('-f' "setfattr=20")
+args+=('-f' "attr_set=60")	# sets larger xattrs
+
+$FSSTRESS_PROG "${args[@]}" $FSSTRESS_AVOID -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/724.out b/tests/generic/724.out
new file mode 100644
index 00000000..164cfffb
--- /dev/null
+++ b/tests/generic/724.out
@@ -0,0 +1,2 @@
+QA output created by 724
+Silence is golden.

