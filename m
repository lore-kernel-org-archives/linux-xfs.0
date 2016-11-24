Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:17306 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbcKXBwh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2016 20:52:37 -0500
Date: Wed, 23 Nov 2016 17:51:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 1/3] generic/182: retain existing btrfs behavior when len
 == 0
Message-ID: <20161124015115.GB30324@birch.djwong.org>
References: <147986705412.27133.3961713804630246198.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147986705412.27133.3961713804630246198.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Since btrfs has always interpreted src_length=0 as "return 0 having
taken no action", test for that instead.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/182     |    6 +++---
 tests/generic/182.out |    2 --
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/tests/generic/182 b/tests/generic/182
index f484399..7fafec0 100755
--- a/tests/generic/182
+++ b/tests/generic/182
@@ -1,10 +1,10 @@
 #! /bin/bash
 # FS QA Test No. 182
 #
-# Test the convention that dedupe with length == 0 means "to the end of fileA"
+# Test the convention that dedupe with length == 0 always returns success.
 #   - Create a file.
-#   - Try to dedupe "zero" bytes (which means dedupe to EOF).
-#   - Check that the dedupe happened.
+#   - Try to dedupe "zero" bytes.
+#   - Check that the dedupe happened and nothing changed.
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
diff --git a/tests/generic/182.out b/tests/generic/182.out
index 049a3ee..9841b76 100644
--- a/tests/generic/182.out
+++ b/tests/generic/182.out
@@ -1,12 +1,10 @@
 QA output created by 182
 Create the original files
-dedupe: Extents did not match.
 f4820540fc0ac02750739896fe028d56  TEST_DIR/test-182/file1
 69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-182/file2
 69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-182/file2.chk
 Compare against check files
 Make the original file almost dedup-able
-dedupe: Extents did not match.
 f4820540fc0ac02750739896fe028d56  TEST_DIR/test-182/file1
 158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-182/file2
 158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-182/file2.chk
