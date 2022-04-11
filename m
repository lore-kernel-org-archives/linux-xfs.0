Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5370EC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 22:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350482AbiDKW53 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 18:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350074AbiDKW51 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 18:57:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5061F13EAA;
        Mon, 11 Apr 2022 15:55:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5979FCE17B8;
        Mon, 11 Apr 2022 22:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA71BC385A3;
        Mon, 11 Apr 2022 22:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649717708;
        bh=X8F60IHIegEjJhWat+AIV02D9fXmBimiM6+QjhcCB18=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eakN2IhxmFCosT4aHLMzI6HEzyNoygbR6r13wX/XsifTJb9mDtnzytAheEwIWv9mo
         NU7Ct60MLUsZQau7X+oOIhflGqjU5H6PsoZvwf9KDTGlNsO3wzY+pww0J9X2KaIt/Z
         LCgIkoUAbG/NRaoIf4Z2g9IFKsh9DUadd6fg1/0cMM7cksDt4tvIjEv5JziJ0wqOMf
         7goCNnLK5P8r3Ygx1pD29UWs2AUOKVJXD9rDfcEp8gvXLBD1RgSgCZOulWjIpuNwKE
         K1r55iUhkRPbQ8+h/Ub39nxujdNwAPSllLC0kuy2beRR/ATRWFETNqgMyhuB2S3UA9
         3W1gM+3EgCZnw==
Subject: [PATCH 2/3] xfs: test mkfs.xfs config file stack corruption issues
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 11 Apr 2022 15:55:08 -0700
Message-ID: <164971770833.170109.18299545219088346786.stgit@magnolia>
In-Reply-To: <164971769710.170109.8985299417765876269.stgit@magnolia>
References: <164971769710.170109.8985299417765876269.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new regression test for a stack corruption problem uncovered in
the mkfs config file parsing code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/831     |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/831.out |    2 ++
 2 files changed, 70 insertions(+)
 create mode 100755 tests/xfs/831
 create mode 100644 tests/xfs/831.out


diff --git a/tests/xfs/831 b/tests/xfs/831
new file mode 100755
index 00000000..a73f14ff
--- /dev/null
+++ b/tests/xfs/831
@@ -0,0 +1,68 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 831
+#
+# Regression test for xfsprogs commit:
+#
+# 99c78777 ("mkfs: prevent corruption of passed-in suboption string values")
+#
+. ./common/preamble
+_begin_fstest auto quick mkfs
+
+_cleanup()
+{
+	rm -f $TEST_DIR/fubar.img
+	cd /
+	rm -r -f $tmp.*
+}
+
+# Import common functions.
+# . ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_require_test
+_require_xfs_mkfs_cfgfile
+
+# Set up a configuration file with an exact block size and log stripe unit
+# so that mkfs won't complain about having to correct the log stripe unit
+# size that is implied by the provided data device stripe unit.
+cfgfile=$tmp.cfg
+cat << EOF >> $tmp.cfg
+[block]
+size=4096
+
+[data]
+su=2097152
+sw=1
+EOF
+
+# Some mkfs options store the user's value string for processing after certain
+# geometry parameters (e.g. the fs block size) have been settled.  This is how
+# the su= option can accept arguments such as "8b" to mean eight filesystem
+# blocks.
+#
+# Unfortunately, on Ubuntu 20.04, the libini parser uses an onstack char[]
+# array to store value that it parse, and it passes the address of this array
+# to the parse_cfgopt.  The getstr function returns its argument, which is
+# stored in the cli_params structure by the D_SU parsing code.  By the time we
+# get around to interpreting this string, of course, the stack array has long
+# since lost scope and is now full of garbage.  If we're lucky, the value will
+# cause a number interpretation failure.  If not, the fs is configured with
+# garbage geometry.
+#
+# Either way, set up a config file to exploit this vulnerability so that we
+# can prove that current mkfs works correctly.
+$XFS_IO_PROG -f -c "truncate 1g" $TEST_DIR/fubar.img
+options=(-c options=$cfgfile -l sunit=8 -f -N $TEST_DIR/fubar.img)
+$MKFS_XFS_PROG "${options[@]}" >> $seqres.full ||
+	echo "mkfs failed"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/831.out b/tests/xfs/831.out
new file mode 100644
index 00000000..abe137e3
--- /dev/null
+++ b/tests/xfs/831.out
@@ -0,0 +1,2 @@
+QA output created by 831
+Silence is golden

