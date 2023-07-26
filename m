Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A64C41513
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 20:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjGZUDg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 16:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjGZUDf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 16:03:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6AC26AE;
        Wed, 26 Jul 2023 13:03:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 918A361C9A;
        Wed, 26 Jul 2023 20:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC89C433C8;
        Wed, 26 Jul 2023 20:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690401812;
        bh=tTGZyVE7Fxwe20XQWb0Q6NTaOY7dMk1gosTaLl20W+s=;
        h=From:To:Cc:Subject:Date:From;
        b=LYZDLEqBHHCs/qtJ+TtfD3vaZw9ymaECIn9/7TUS4Cu2LfxrRaQrJZHmpLjseKbXy
         jsPgCp/73eOyvH7TzYj+gmDSXckku5fftlpDb8TVegeANxCrDJeVl/8d8Zi1Wh9dYZ
         0h7GL96hL6FU+SsrXG92gUNW0zoGXSvXeguQX/BoEJCYflitpEgm9O1vA/1V1m/7Jz
         iXK5RBMQnF8izsdrF/DfKGg7/T1mcxWPIJz3G+uBjxGG0d/mnzm6qWqilDuAOJKWT2
         MySbUgJ1qOWibZmeS406lZF5C8oXxO4aYumwWT13tYILAzw7/SokdUbs6dPC0H4XGl
         seng6xY1qadIg==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     djwong@kernel.org, tytso@mit.edu, linux-xfs@vger.kernel.org
Subject: [PATCH] fstests: provides smoketest template
Date:   Thu, 27 Jul 2023 04:03:27 +0800
Message-Id: <20230726200327.239085-1-zlang@kernel.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Darrick suggests that fstests can provide a simple smoketest, by running
several generic filesystem smoke testing for five minutes apiece. Since
there are only five smoke tests, this is effectively a 16min super-quick
test.

With gcov enabled, running these tests yields about ~75% coverage for
iomap and ~60% for xfs; or ~50% for ext4 and ~75% for ext4; and ~45% for
btrfs.  Coverage was about ~65% for the pagecache.

To implement that, this patch add a new "-t" option to ./check, and a
new directory "template" under xfstests/, then we can have smoketest
template, also can have more other testing templates.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Zorro Lang <zlang@kernel.org>
---

Hi,

This patch uses another way to achieve the smoketest requirement[1]. When
I reviewed the patch from Darrick [2], I thought "smoketest" might not be
the last one requirement likes that. I don't want to give each kind of
tests a separated option. But we might can leave a hook for more fs-devel
who have good testing templates for fstests.

Although we have test groups, but those group names are too complex for
the users who not always use fstests. So I'm thinking about providing
some simple templates to run fstests, these templates base on test groups
and some fstests global parameters, help users to know what kind of
test they can do.

Feel free to discuss, and if most of you prefer the original patch [2],
I'll also think about merging the original one :)

Thanks,
Zorro

[1]
https://lore.kernel.org/fstests/20230726145441.lbzzokwigrztimyq@zlang-mailbox/T/#mabc0de98699f1b877c87caccb13809c9283c0606
[2]
https://lore.kernel.org/fstests/169033660570.3222210.3010411210438664310.stgit@frogsfrogsfrogs/T/#u


 check               |  8 ++++++++
 doc/group-names.txt |  1 +
 templates/smoketest | 16 ++++++++++++++++
 tests/generic/475   |  2 +-
 tests/generic/476   |  2 +-
 tests/generic/521   |  2 +-
 tests/generic/522   |  2 +-
 tests/generic/642   |  2 +-
 8 files changed, 30 insertions(+), 5 deletions(-)
 create mode 100644 templates/smoketest

diff --git a/check b/check
index 89e7e7bf..7100aae4 100755
--- a/check
+++ b/check
@@ -335,6 +335,14 @@ while [ $# -gt 0 ]; do
 		;;
 	-i)	iterations=$2; shift ;;
 	-I) 	iterations=$2; istop=true; shift ;;
+	-t)
+		source templates/$2
+		if [ $? -ne 0 ];then
+			echo "Cannot import the templates/$2"
+			exit 1
+		fi
+		shift
+		;;
 	-T)	timestamp=true ;;
 	-d)	DUMP_OUTPUT=true ;;
 	-b)	brief_test_summary=true;;
diff --git a/doc/group-names.txt b/doc/group-names.txt
index 1c35a394..c3dcca37 100644
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
diff --git a/templates/smoketest b/templates/smoketest
new file mode 100644
index 00000000..40a0104b
--- /dev/null
+++ b/templates/smoketest
@@ -0,0 +1,16 @@
+##/bin/bash
+# For infrequent filesystem developers who simply want to run a quick test
+# of the most commonly used filesystem functionality, use this command:
+#
+#     ./check -t smoketest <other config options>
+#
+# This template helps fstests to run several tests to exercise the file I/O,
+# metadata, and crash recovery exercisers for four minutes apiece.  This
+# should complete in approximately 20 minutes.
+
+echo "**********************"
+echo "* A Quick Smoke Test *"
+echo "**********************"
+
+[ -z "$SOAK_DURATION" ] && SOAK_DURATION="4m"
+GROUP_LIST="smoketest"
diff --git a/tests/generic/475 b/tests/generic/475
index 0cbf5131..ce7fe013 100755
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
index 8e93b734..b1ae4df4 100755
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
index 22dd31a8..0956e501 100755
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
index f0cbcb24..0e4e6009 100755
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
index eba90903..e6a475a8 100755
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
-- 
2.40.1

