Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A577C001DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 01:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjGZB4y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jul 2023 21:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbjGZB4w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2023 21:56:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666C72720;
        Tue, 25 Jul 2023 18:56:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB3186109A;
        Wed, 26 Jul 2023 01:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40582C433CB;
        Wed, 26 Jul 2023 01:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690336606;
        bh=C7bSDDAvloXNOs04vQTAwqgymqC1+pTfeFpLrt+iEHQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FaJj8+td29DjMieXM3g5cgFlRUlKsIlKEN3P0zT/R7qbzMI5bWpH5t0ltPWmgRVN6
         F/XmlCcXxtX8E5+2/ucBz18oJvhKcnPQMpMwOl9GWCvFlSpixYAiYqwbJiCcsAF3HY
         2LITCx1By/HeMeeb4SKyVO+zItSCHgfrqXvVkIc7Gqvdpkc6zXl/aIbst0sTcSirDg
         jfPNWvNgbtEqVNnk+pSH74AbY0+1KzZmoWLl1UrEcCMreBnd2Oxm0tF3t1GwGTxaKd
         ko8g6afx1RJ17Q1IGelb3sGfX+4nA4EtWIPxA0fKu7Egk4phZgtqocuaLa9Nhslfp4
         J0z5IKpagYybA==
Subject: [PATCH 1/2] check: add a -smoketest option
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     tytso@mit.edu, linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        guan@eryu.me
Date:   Tue, 25 Jul 2023 18:56:45 -0700
Message-ID: <169033660570.3222210.3010411210438664310.stgit@frogsfrogsfrogs>
In-Reply-To: <169033659987.3222210.11071346898413396128.stgit@frogsfrogsfrogs>
References: <169033659987.3222210.11071346898413396128.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a "-smoketest" parameter to check that will run generic
filesystem smoke testing for five minutes apiece.  Since there are only
five smoke tests, this is effectively a 16min super-quick test.

With gcov enabled, running these tests yields about ~75% coverage for
iomap and ~60% for xfs; or ~50% for ext4 and ~75% for ext4; and ~45% for
btrfs.  Coverage was about ~65% for the pagecache.

Cc: tytso@mit.edu
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 README              |    9 +++++++++
 check               |    6 +++++-
 doc/group-names.txt |    1 +
 tests/generic/475   |    2 +-
 tests/generic/476   |    2 +-
 tests/generic/521   |    2 +-
 tests/generic/522   |    2 +-
 tests/generic/642   |    2 +-
 8 files changed, 20 insertions(+), 6 deletions(-)


diff --git a/README b/README
index 9790334db1..d4ec73d10d 100644
--- a/README
+++ b/README
@@ -311,6 +311,15 @@ Running tests:
           The TEST and SCRATCH partitions should be pre-formatted
           with another base fs, where the overlay dirs will be created
 
+    - For infrequent filesystem developers who simply want to run a quick test
+      of the most commonly used filesystem functionality, use this command:
+
+          ./check -smoketest <other config options>
+
+      This configures fstests to run five tests to exercise the file I/O,
+      metadata, and crash recovery exercisers for four minutes apiece.  This
+      should complete in approximately 20 minutes.
+
 
     The check script tests the return value of each script, and
     compares the output against the expected output. If the output
diff --git a/check b/check
index 89e7e7bf20..c02e693642 100755
--- a/check
+++ b/check
@@ -68,6 +68,7 @@ check options
     -pvfs2		test PVFS2
     -tmpfs		test TMPFS
     -ubifs		test ubifs
+    -smoketest		run smoke tests for 4min each
     -l			line mode diff
     -udiff		show unified diff (default)
     -n			show me, do not run tests
@@ -290,7 +291,10 @@ while [ $# -gt 0 ]; do
 		FSTYP=overlay
 		export OVERLAY=true
 		;;
-
+	-smoketest)
+		test -z "$SOAK_DURATION" && SOAK_DURATION="4m"
+		GROUP_LIST="smoketest"
+		;;
 	-g)	group=$2 ; shift ;
 		GROUP_LIST="$GROUP_LIST ${group//,/ }"
 		;;
diff --git a/doc/group-names.txt b/doc/group-names.txt
index 1c35a39432..c3dcca3755 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -118,6 +118,7 @@ selftest		tests with fixed results, used to validate testing setup
 send			btrfs send/receive
 shrinkfs		decreasing the size of a filesystem
 shutdown		FS_IOC_SHUTDOWN ioctl
+smoketest		Simple smoke tests
 snapshot		btrfs snapshots
 soak			long running soak tests whose runtime can be controlled
                         directly by setting the SOAK_DURATION variable
diff --git a/tests/generic/475 b/tests/generic/475
index 0cbf5131c2..ce7fe013b1 100755
--- a/tests/generic/475
+++ b/tests/generic/475
@@ -12,7 +12,7 @@
 # testing efforts.
 #
 . ./common/preamble
-_begin_fstest shutdown auto log metadata eio recoveryloop
+_begin_fstest shutdown auto log metadata eio recoveryloop smoketest
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/generic/476 b/tests/generic/476
index 8e93b73457..b1ae4df4d4 100755
--- a/tests/generic/476
+++ b/tests/generic/476
@@ -8,7 +8,7 @@
 # bugs in the write path.
 #
 . ./common/preamble
-_begin_fstest auto rw long_rw stress soak
+_begin_fstest auto rw long_rw stress soak smoketest
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/generic/521 b/tests/generic/521
index 22dd31a8ec..0956e50171 100755
--- a/tests/generic/521
+++ b/tests/generic/521
@@ -7,7 +7,7 @@
 # Long-soak directio fsx test
 #
 . ./common/preamble
-_begin_fstest soak long_rw
+_begin_fstest soak long_rw smoketest
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/generic/522 b/tests/generic/522
index f0cbcb245c..0e4e6009ed 100755
--- a/tests/generic/522
+++ b/tests/generic/522
@@ -7,7 +7,7 @@
 # Long-soak buffered fsx test
 #
 . ./common/preamble
-_begin_fstest soak long_rw
+_begin_fstest soak long_rw smoketest
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/generic/642 b/tests/generic/642
index eba90903a3..e6a475a8b5 100755
--- a/tests/generic/642
+++ b/tests/generic/642
@@ -8,7 +8,7 @@
 # bugs in the xattr code.
 #
 . ./common/preamble
-_begin_fstest auto soak attr long_rw stress
+_begin_fstest auto soak attr long_rw stress smoketest
 
 _cleanup()
 {

