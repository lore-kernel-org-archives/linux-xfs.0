Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6196EC433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 312F7619B3
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhCWEUa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhCWEUM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:20:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E68516198E;
        Tue, 23 Mar 2021 04:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616473212;
        bh=tRC13KnW6gVz+tG0e7295KnDi/f6AV6qIEH0fcVUMEk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uTxoeDDIAhgWiuL4m4+ASJpkC4nn45KK+Hvi2hN0vdtJfrPNXuMomSm2k+xcJEJHW
         Kahy5Fk9VBluPU9n06rVpayW0v9gPBzwPi8Jl1XZzb5ZcWtHO3dEKqeLbL/UsAsGPh
         g5cxZc4JbfvshlsN/M2xXJ7JxM9oInQICVvG8aAcktPJHl7axuZmIQZNTCSQoKa4Pu
         +zA1HpEfhbSILspx74XVunSdpJT6HTag0ukbX3ws+DG9zrviqs5UzMxZocdgebkdaA
         lHY6x3WWxzePkfR/i99Z6rtuTKzI53s54FktnnRolkt2JjSrfZCeEU5/q8TT0AyCi3
         ikIIU3/8HykGQ==
Subject: [PATCH 2/3] common/rc: refactor _require_{ext2,tmpfs} helpers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 22 Mar 2021 21:20:11 -0700
Message-ID: <161647321164.3430465.14482552330781743925.stgit@magnolia>
In-Reply-To: <161647320063.3430465.17720673716578854275.stgit@magnolia>
References: <161647320063.3430465.17720673716578854275.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Combine these two helpers into a single generic function so that we can
use it in the next patch to test a regression when running overlayfs
atop xfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |   23 +++++------------------
 tests/overlay/025 |    2 +-
 tests/overlay/106 |    2 +-
 tests/overlay/107 |    2 +-
 tests/overlay/108 |    2 +-
 tests/overlay/109 |    2 +-
 tests/xfs/049     |    2 +-
 7 files changed, 11 insertions(+), 24 deletions(-)


diff --git a/common/rc b/common/rc
index 6d1757da..434cd583 100644
--- a/common/rc
+++ b/common/rc
@@ -1766,26 +1766,13 @@ _require_loop()
     fi
 }
 
-# this test requires ext2 filesystem support
+# this test requires kernel support for a secondary filesystem
 #
-_require_ext2()
+_require_extra_fs()
 {
-    modprobe ext2 >/dev/null 2>&1
-    if grep ext2 /proc/filesystems >/dev/null 2>&1
-    then
-	:
-    else
-	_notrun "This test requires ext2 filesystem support"
-    fi
-}
-
-# this test requires tmpfs filesystem support
-#
-_require_tmpfs()
-{
-	modprobe tmpfs >/dev/null 2>&1
-	grep -q tmpfs /proc/filesystems ||
-		_notrun "this test requires tmpfs support"
+	modprobe "$1" >/dev/null 2>&1
+	grep -q -w "$1" /proc/filesystems ||
+		_notrun "this test requires $1 support"
 }
 
 # this test requires that (large) loopback device files are not in use
diff --git a/tests/overlay/025 b/tests/overlay/025
index 979bd98e..c5f328c8 100755
--- a/tests/overlay/025
+++ b/tests/overlay/025
@@ -42,7 +42,7 @@ rm -f $seqres.full
 # Modify as appropriate.
 _supported_fs overlay
 _require_user
-_require_tmpfs
+_require_extra_fs tmpfs
 
 # create a tmpfs in $TEST_DIR
 tmpfsdir=$TEST_DIR/tmpfs
diff --git a/tests/overlay/106 b/tests/overlay/106
index 28e9a819..0b3e0c98 100755
--- a/tests/overlay/106
+++ b/tests/overlay/106
@@ -27,7 +27,7 @@ rm -f $seqres.full
 # real QA test starts here
 
 _supported_fs overlay
-_require_tmpfs
+_require_extra_fs tmpfs
 _require_test
 _require_scratch
 _require_unionmount_testsuite
diff --git a/tests/overlay/107 b/tests/overlay/107
index 733a5556..89fde9de 100755
--- a/tests/overlay/107
+++ b/tests/overlay/107
@@ -27,7 +27,7 @@ rm -f $seqres.full
 # real QA test starts here
 
 _supported_fs overlay
-_require_tmpfs
+_require_extra_fs tmpfs
 _require_test
 _require_scratch
 _require_unionmount_testsuite
diff --git a/tests/overlay/108 b/tests/overlay/108
index e757e0e4..ae367a5c 100755
--- a/tests/overlay/108
+++ b/tests/overlay/108
@@ -27,7 +27,7 @@ rm -f $seqres.full
 # real QA test starts here
 
 _supported_fs overlay
-_require_tmpfs
+_require_extra_fs tmpfs
 _require_test
 _require_scratch
 _require_unionmount_testsuite
diff --git a/tests/overlay/109 b/tests/overlay/109
index d49080be..df036616 100755
--- a/tests/overlay/109
+++ b/tests/overlay/109
@@ -27,7 +27,7 @@ rm -f $seqres.full
 # real QA test starts here
 
 _supported_fs overlay
-_require_tmpfs
+_require_extra_fs tmpfs
 _require_test
 _require_scratch
 _require_unionmount_testsuite
diff --git a/tests/xfs/049 b/tests/xfs/049
index 67739265..16bc788d 100755
--- a/tests/xfs/049
+++ b/tests/xfs/049
@@ -46,7 +46,7 @@ _require_nonexternal
 _require_scratch_nocheck
 _require_no_large_scratch_dev
 _require_loop
-_require_ext2
+_require_extra_fs ext2
 
 rm -f $seqres.full
 

