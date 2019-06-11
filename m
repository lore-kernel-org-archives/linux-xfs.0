Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41034 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405251AbfFKPj0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:39:26 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/2] generic/553: fix test description
Date: Tue, 11 Jun 2019 18:39:15 +0300
Message-Id: <20190611153916.13360-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

The test only checks copy to immutable file.
Note the kernel fix commit.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Changes from v1:
- Document kernel fix commit

 tests/generic/553 | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tests/generic/553 b/tests/generic/553
index 98ef77cc..58e0d5ef 100755
--- a/tests/generic/553
+++ b/tests/generic/553
@@ -4,7 +4,10 @@
 #
 # FS QA Test No. 553
 #
-# Check that we cannot copy_file_range() to/from an immutable file
+# Check that we cannot copy_file_range() to an immutable file
+#
+# This is a regression test for kernel commit:
+#   a31713517dac ("vfs: introduce generic_file_rw_checks()")
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-- 
2.17.1
