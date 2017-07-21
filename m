Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33180 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751460AbdGUEkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:12 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 04/15] tests: remove udf/098
Date: Thu, 20 Jul 2017 21:38:42 -0700
Message-Id: <20170721043853.364-5-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

udf/098 was an IRIX and UDF-specific test which tested xattrs.  But the
Linux UDF driver doesn't support xattrs, and even if it did there are
already generic xattr tests --- including now generic/097 which is
basically the same test.  So just delete udf/098.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/udf/098     |  274 ---------
 tests/udf/098.out | 1594 -----------------------------------------------------
 tests/udf/group   |    1 -
 3 files changed, 1869 deletions(-)
 delete mode 100755 tests/udf/098
 delete mode 100644 tests/udf/098.out

diff --git a/tests/udf/098 b/tests/udf/098
deleted file mode 100755
index 09792a76..00000000
diff --git a/tests/udf/098.out b/tests/udf/098.out
deleted file mode 100644
index 63772a0a..00000000
diff --git a/tests/udf/group b/tests/udf/group
index 24f682cc..f4372e09 100644
--- a/tests/udf/group
+++ b/tests/udf/group
@@ -3,6 +3,5 @@
 # - do not start group names with a digit
 # - comment line before each group is "new" description
 #
-098 udf auto
 101 udf
 102 udf
-- 
2.13.3

