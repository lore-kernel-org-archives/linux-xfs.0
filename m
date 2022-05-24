Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F45C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 19:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241238AbiEXTxG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 15:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241219AbiEXTxF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 15:53:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5BE7A441;
        Tue, 24 May 2022 12:53:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12AE061704;
        Tue, 24 May 2022 19:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C47AC34119;
        Tue, 24 May 2022 19:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653421978;
        bh=anM/MKvvssBJ4CAKrgH2XrvjIu1QfxHnfZA54B74EQ4=;
        h=Date:From:To:Cc:Subject:From;
        b=sIWw7e0COLNezOrreM/K/vtd3HMajoooViIGC/QogkKh6j4YjWNgAOX2I32ZAgTIE
         jmBcB92i3gJrA6ZseFs3t4HxLAXGMgGpJqZNTgEEE7fAz9b044fZIVt/1bOe23NVj5
         XLLg6uh0pQ8GCPKS1vuxbBwipOFUJWjTo2FfkHPH5Zbs8/dQwFN77Tk7m3p4TLEPx/
         832uu3eQlwv8qh0qNl6R+W7+kHQHzUBpcPNQqMpEjFEAAsCm1f2HvpB31n2BtjnWJJ
         7pJKNm3DT3neBZJk53R2OjeslD0Lb/eyfnxh0eeEC0P1yxhjxRr2kikdQtRGL0N4ff
         +99OBvMAXSWLQ==
Date:   Tue, 24 May 2022 12:52:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>, Eryu Guan <guaneryu@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: test mkfs.xfs sizing of internal logs that
Message-ID: <Yo03mZ12X1nLGihK@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test that exercises the mkfs.xfs code that creates
log sizes that are very close to the AG size when stripe units are in
play and/or when the log is forced to be in AG 0.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/843     |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/843.out |    2 ++
 2 files changed, 58 insertions(+)
 create mode 100755 tests/xfs/843
 create mode 100644 tests/xfs/843.out

diff --git a/tests/xfs/843 b/tests/xfs/843
new file mode 100755
index 00000000..3384b1aa
--- /dev/null
+++ b/tests/xfs/843
@@ -0,0 +1,56 @@
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
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $testfile
+}
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_require_test
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
+		test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m
+	done
+done
+
+# log so large it pushes the root dir into AG 1
+test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0
+
+# log end rounded beyond EOAG due to stripe unit
+test_format "log end beyond eoag" -d agcount=3200,size=6366g -d su=256k,sw=4
+
+echo Silence is golden
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
