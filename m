Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47884 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755351AbcKWCLA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 21:11:00 -0500
Subject: [PATCH 1/3] generic/182: retain existing btrfs behavior when len ==
 0
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 22 Nov 2016 18:10:54 -0800
Message-ID: <147986705412.27133.3961713804630246198.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Since btrfs doesn't interpret len=0 as "go to EOF", test for that instead.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/182     |    3 ++-
 tests/generic/182.out |    2 --
 2 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/tests/generic/182 b/tests/generic/182
index f484399..dacb989 100755
--- a/tests/generic/182
+++ b/tests/generic/182
@@ -1,7 +1,8 @@
 #! /bin/bash
 # FS QA Test No. 182
 #
-# Test the convention that dedupe with length == 0 means "to the end of fileA"
+# Test the convention that dedupe with length == 0 doesn't mean "to the end of
+# fileA"
 #   - Create a file.
 #   - Try to dedupe "zero" bytes (which means dedupe to EOF).
 #   - Check that the dedupe happened.
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

