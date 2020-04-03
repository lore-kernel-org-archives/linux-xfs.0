Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EBDC2BA16
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 03:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9308C207FF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 03:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585884860;
	bh=+iJub638N4FDV5fzWnFJ0138Z1h34HJuxGJnd8LMwv8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=IRqWY++m51tb667p89x/9+xv/2sz8Uo7Nw9b3DEgzOCA94KrhD6nm8//Zp2p3q7nC
	 bBcGILB+O+OUQkK1T5E18MNuITrk3LdlX6XEyAuXbQtXFlPPEI/dDTu4eFFPDYRr90
	 8UBKxPKhN0mjOmE8QomOkW/lC5wmxVlr33ZNAUEk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390368AbgDCDeT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 23:34:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388951AbgDCDeT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Apr 2020 23:34:19 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD60120675;
        Fri,  3 Apr 2020 03:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585884858;
        bh=+iJub638N4FDV5fzWnFJ0138Z1h34HJuxGJnd8LMwv8=;
        h=From:To:Cc:Subject:Date:From;
        b=wayCpx2HmiJfCWjFIuUaDCLsR5SV+eaV9TaRzlBq6k+GT0nnUD4xi4ZJxBIPCA9av
         0tUmtIA4/dfcfkMPqZ0kbhmBs6ys7aaWgbNhwoKSvfx8TRMT/w/2pFp/elvOPC+kRf
         HFioM+m0oxewqhrK0/fYMPvpQBNGgd5c72y+FyLo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] generic: test PF_MEMALLOC interfering with accounting file write
Date:   Thu,  2 Apr 2020 20:33:55 -0700
Message-Id: <20200403033355.140984-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a regression test for the bug fixed by commit 10a98cb16d80 ("xfs:
clear PF_MEMALLOC before exiting xfsaild thread").

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

Changed since v1:
    - Fix _require_bsd_process_accounting() to not leave process
      accounting enabled.
    - Removed RFC tag since the kernel fix is now in mainline.
   

 common/config         |  1 +
 common/rc             | 12 +++++++++
 tests/generic/901     | 60 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/901.out |  2 ++
 tests/generic/group   |  1 +
 5 files changed, 76 insertions(+)
 create mode 100644 tests/generic/901
 create mode 100644 tests/generic/901.out

diff --git a/common/config b/common/config
index 1116cb99..8023273d 100644
--- a/common/config
+++ b/common/config
@@ -220,6 +220,7 @@ export DUPEREMOVE_PROG="$(type -P duperemove)"
 export CC_PROG="$(type -P cc)"
 export FSVERITY_PROG="$(type -P fsverity)"
 export OPENSSL_PROG="$(type -P openssl)"
+export ACCTON_PROG="$(type -P accton)"
 
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
diff --git a/common/rc b/common/rc
index 454f5ccf..7d6ea90c 100644
--- a/common/rc
+++ b/common/rc
@@ -4168,6 +4168,18 @@ _check_xfs_scrub_does_unicode() {
 	return 0
 }
 
+# Require the 'accton' userspace tool and CONFIG_BSD_PROCESS_ACCT=y.
+_require_bsd_process_accounting()
+{
+	_require_command "$ACCTON_PROG" accton
+	$ACCTON_PROG on &> $tmp.test_accton
+	cat $tmp.test_accton >> $seqres.full
+	if grep 'Function not implemented' $tmp.test_accton; then
+		_notrun "BSD process accounting support unavailable"
+	fi
+	$ACCTON_PROG off >> $seqres.full
+}
+
 init_rc
 
 ################################################################################
diff --git a/tests/generic/901 b/tests/generic/901
new file mode 100644
index 00000000..c59300f1
--- /dev/null
+++ b/tests/generic/901
@@ -0,0 +1,60 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2020 Google LLC
+#
+# FS QA Test No. 901
+#
+# Regression test for the bug fixed by commit 10a98cb16d80 ("xfs: clear
+# PF_MEMALLOC before exiting xfsaild thread").  If the bug exists, a kernel
+# WARNING should be triggered.  See the commit message for details.
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
+	$ACCTON_PROG off >> $seqres.full
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_bsd_process_accounting
+_require_chattr S
+_require_test
+_require_scratch
+
+# To trigger the bug we must unmount a filesystem while BSD process accounting
+# is enabled.  The accounting file must also be located on a different
+# filesystem and have the sync flag set.
+
+accounting_file=$TEST_DIR/$seq
+
+rm -f $accounting_file
+touch $accounting_file
+$CHATTR_PROG +S $accounting_file
+
+_scratch_mkfs &>> $seqres.full
+$ACCTON_PROG $accounting_file >> $seqres.full
+_scratch_mount
+_scratch_unmount
+$ACCTON_PROG off >> $seqres.full
+
+echo "Silence is golden"
+
+status=0
+exit
diff --git a/tests/generic/901.out b/tests/generic/901.out
new file mode 100644
index 00000000..b206bc11
--- /dev/null
+++ b/tests/generic/901.out
@@ -0,0 +1,2 @@
+QA output created by 901
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index dc95b77b..61a67979 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -595,3 +595,4 @@
 591 auto quick rw pipe splice
 592 auto quick encrypt
 593 auto quick encrypt
+901 auto quick
-- 
2.26.0

