Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C43EB64DD
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 01:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjGSBK7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 21:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjGSBK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 21:10:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32141722;
        Tue, 18 Jul 2023 18:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F074615F8;
        Wed, 19 Jul 2023 01:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B574BC433C7;
        Wed, 19 Jul 2023 01:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689729056;
        bh=jWLSdXIxDyCLfoUTBxK1nwBmW7tLXWO/Kns6/Id/97U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=msgG057YVvoNtJimBROBH/JUWJSJ0b0lPcR9/enGyzRFCKkW8h6KAFb0ESW4cM2F9
         h4yN1apk0c3ePlobD9gId18f8j/1nIgyeLJU/r3iUib1xg8ZVNMNGGCIQ+MAU12Xg1
         l/QL/vwwMR2j5a12UgVs/vPUCVP0aJ/Ce55mNUs8MQHQz/oG7ZdIONeDSTrYsf2o21
         sGxYCBv98AM1zGmSVaqVYbNeu1lnjErBnkSQ633Hl8Id7c11HtcQUA6xhS36jwPCJP
         rVh6wYz/fmZ6AWH7wkKHUCWKB3BMR0oT6Ef0F+FFny0xS2IzGH5r7E2S8apiMIKU6X
         R+InPIJpT6z0w==
Subject: [PATCH 1/2] check: add a -smoketest option
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     tytso@mit.edu, linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        guan@eryu.me
Date:   Tue, 18 Jul 2023 18:10:56 -0700
Message-ID: <168972905626.1698606.12419796694170752316.stgit@frogsfrogsfrogs>
In-Reply-To: <168972905065.1698606.6829635791058054610.stgit@frogsfrogsfrogs>
References: <168972905065.1698606.6829635791058054610.stgit@frogsfrogsfrogs>
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
 check               |    6 +++++-
 doc/group-names.txt |    1 +
 tests/generic/475   |    2 +-
 tests/generic/476   |    2 +-
 tests/generic/521   |    2 +-
 tests/generic/522   |    2 +-
 tests/generic/642   |    2 +-
 7 files changed, 11 insertions(+), 6 deletions(-)


diff --git a/check b/check
index 89e7e7bf20..97c7c4c7d1 100755
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
+		SOAK_DURATION="4m"
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

