Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6CDC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiF1UZB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbiF1UYS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:24:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B3ABE3;
        Tue, 28 Jun 2022 13:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E2E6B8203F;
        Tue, 28 Jun 2022 20:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC574C3411D;
        Tue, 28 Jun 2022 20:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656447695;
        bh=tkf4ZBYvddxs2azDnfnVIQXTaEIc3EGZsrX2KCbOF4s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=maEj+S8igmiGAzmAUb7jlS0KLi0mDmCgZCgh0fEe9AaO/RxXddacy1KNGniJDhL1e
         mVWD4/uOTpksrPOjfRegKII8GhrSIMIi7dyxDS8CKGAk4JzdUG2hIITczZMOTS4wTp
         vV9iMN9JZhn24/g5v1vLddQgAQM/hRvpsUocKjoBrPGtpwWQtybNPlo4lQgy2dPX2G
         9GE78MT52tkdMhcBGMqCOtNW+qtNDiLEUgHFnuKayzecNnHTI8rr8k2cUdPgiZ+ugb
         PpD0Hq4wD45l7T3tzltdKr1woFC4ygz4jmC7FVTiDJSh6ZyIu2A5IqiAh6UN8Xp9b0
         4BbF1iqmP4tpg==
Subject: [PATCH 3/9] xfs: test mkfs.xfs sizing of internal logs that
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Jun 2022 13:21:34 -0700
Message-ID: <165644769450.1045534.8663346508633304230.stgit@magnolia>
In-Reply-To: <165644767753.1045534.18231838177395571946.stgit@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test that exercises the mkfs.xfs code that creates
log sizes that are very close to the AG size when stripe units are in
play and/or when the log is forced to be in AG 0.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/843     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/843.out |    2 ++
 2 files changed, 53 insertions(+)
 create mode 100755 tests/xfs/843
 create mode 100644 tests/xfs/843.out


diff --git a/tests/xfs/843 b/tests/xfs/843
new file mode 100755
index 00000000..5bb4bfb4
--- /dev/null
+++ b/tests/xfs/843
@@ -0,0 +1,51 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 843
+#
+# Now that we've increased the default log size calculation, test mkfs with
+# various stripe units and filesystem sizes to see if we can provoke mkfs into
+# breaking.
+#
+. ./common/preamble
+_begin_fstest auto mkfs
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_require_test
+echo Silence is golden
+
+testfile=$TEST_DIR/a
+rm -f $testfile
+
+test_format() {
+	local tag="$1"
+	shift
+
+	echo "$tag" >> $seqres.full
+	$MKFS_XFS_PROG $@ -d file,name=$testfile &>> $seqres.full
+	local res=$?
+	test $res -eq 0 || echo "$tag FAIL $res" | tee -a $seqres.full
+}
+
+# First we try various small filesystems and stripe sizes.
+for M in `seq 298 302` `seq 490 520`; do
+	for S in `seq 32 4 64`; do
+		test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m -N
+	done
+done
+
+# Log so large it pushes the root dir into AG 1.  We can't use -N for the mkfs
+# because this check only occurs after the root directory has been allocated,
+# which mkfs -N doesn't do.
+test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0 -N
+
+# log end rounded beyond EOAG due to stripe unit
+test_format "log end beyond eoag" -d agcount=3200,size=6366g -d su=256k,sw=4 -N
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/843.out b/tests/xfs/843.out
new file mode 100644
index 00000000..87c13504
--- /dev/null
+++ b/tests/xfs/843.out
@@ -0,0 +1,2 @@
+QA output created by 843
+Silence is golden

