Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:37897 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751611AbdGUEkN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:13 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 05/15] tests: remove udf/101
Date: Thu, 20 Jul 2017 21:38:43 -0700
Message-Id: <20170721043853.364-6-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

This IRIX and UDF-specific test essentially just created a UDF
filesystem with a specific size.  This isn't really useful because there
already are many generic tests that do _scratch_mkfs_sized.  So just
delete the test rather than trying to port it to Linux.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/udf/101     | 62 -------------------------------------------------------
 tests/udf/101.out | 19 -----------------
 tests/udf/group   |  1 -
 3 files changed, 82 deletions(-)
 delete mode 100755 tests/udf/101
 delete mode 100644 tests/udf/101.out

diff --git a/tests/udf/101 b/tests/udf/101
deleted file mode 100755
index 9609c072..00000000
diff --git a/tests/udf/101.out b/tests/udf/101.out
deleted file mode 100644
index 1ca59a8c..00000000
diff --git a/tests/udf/group b/tests/udf/group
index f4372e09..6680da44 100644
--- a/tests/udf/group
+++ b/tests/udf/group
@@ -3,5 +3,4 @@
 # - do not start group names with a digit
 # - comment line before each group is "new" description
 #
-101 udf
 102 udf
-- 
2.13.3

