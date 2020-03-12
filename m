Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7031C2BB1D
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 22:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE3F620736
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 22:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584051402;
	bh=AyQkSMP0ichYhKQ2vucgo1PRYtr8vAHB5qXbFqpC64A=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Yxj9MbUD9YlheIqcm25bAnzxlwZgpAnHN0PNnp94wyUN9oMRBxj8IS05dZP83H+XP
	 ejMLJPSvbp3CQW4qu6NXQPuXPxQQnkjP9AUaG2HQ1AFJmjrTu4wBSXuMq9vtbTDR4N
	 cR9QOjUOvQRbsQEjZwCb5vb7Enq3ia5GBZmzLhHQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgCLWQm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 18:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbgCLWQl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Mar 2020 18:16:41 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F191B20637;
        Thu, 12 Mar 2020 22:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584051401;
        bh=AyQkSMP0ichYhKQ2vucgo1PRYtr8vAHB5qXbFqpC64A=;
        h=From:To:Cc:Subject:Date:From;
        b=FuuK7clcXSM9AnO5e9/mLk3A1Tgwi78PFKzWc/aLAQCqHv5IfoGxzEuiU+sSGfuQd
         YZ1YwksJEAdmuMuiVUptRZmB8wc/vLKSCcT69Sz+PrDkC9/HXzwDb41aW8I1XC8Ixc
         woNUU7VLN4uxDY7K8FL3eCikALyYchGsibyhFpCo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH] generic: test PF_MEMALLOC interfering with accounting file write
Date:   Thu, 12 Mar 2020 15:14:37 -0700
Message-Id: <20200312221437.141484-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
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

RFC for now since the commit is in xfs/for-next only, and I'm not sure
the commit ID is stable.

 common/config         |  1 +
 common/rc             | 11 ++++++++
 tests/generic/901     | 60 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/901.out |  2 ++
 tests/generic/group   |  1 +
 5 files changed, 75 insertions(+)
 create mode 100644 tests/generic/901
 create mode 100644 tests/generic/901.out

diff --git a/common/config b/common/config
index 1116cb995..8023273da 100644
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
index 454f5ccf5..0bc4b14f2 100644
--- a/common/rc
+++ b/common/rc
@@ -4168,6 +4168,17 @@ _check_xfs_scrub_does_unicode() {
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
+}
+
 init_rc
 
 ################################################################################
diff --git a/tests/generic/901 b/tests/generic/901
new file mode 100644
index 000000000..c59300f1b
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
index 000000000..b206bc11d
--- /dev/null
+++ b/tests/generic/901.out
@@ -0,0 +1,2 @@
+QA output created by 901
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index dc95b77b3..61a679793 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -595,3 +595,4 @@
 591 auto quick rw pipe splice
 592 auto quick encrypt
 593 auto quick encrypt
+901 auto quick
-- 
2.25.1

