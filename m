Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33250 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751665AbdGUEkP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:15 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 07/15] tests: remove xfs/057 and xfs/058
Date: Thu, 20 Jul 2017 21:38:45 -0700
Message-Id: <20170721043853.364-8-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

These two IRIX and XFS-specific tests were just placeholders which
didn't actually test anything.  It also seems they were meant to use the
acl_get and acl_test programs, but those weren't even being compiled.
Get rid of all this unused stuff.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/acl_get.c     | 148 ------------------------------
 src/acl_test.c    | 264 ------------------------------------------------------
 tests/xfs/057     |  47 ----------
 tests/xfs/057.out |  34 -------
 tests/xfs/058     |  46 ----------
 tests/xfs/058.out | 243 -------------------------------------------------
 tests/xfs/group   |   2 -
 7 files changed, 784 deletions(-)
 delete mode 100644 src/acl_get.c
 delete mode 100644 src/acl_test.c
 delete mode 100755 tests/xfs/057
 delete mode 100644 tests/xfs/057.out
 delete mode 100755 tests/xfs/058
 delete mode 100644 tests/xfs/058.out

diff --git a/src/acl_get.c b/src/acl_get.c
deleted file mode 100644
index 3701dd02..00000000
diff --git a/src/acl_test.c b/src/acl_test.c
deleted file mode 100644
index a060b6c9..00000000
diff --git a/tests/xfs/057 b/tests/xfs/057
deleted file mode 100755
index a3fe9c36..00000000
diff --git a/tests/xfs/057.out b/tests/xfs/057.out
deleted file mode 100644
index 7e38ab37..00000000
diff --git a/tests/xfs/058 b/tests/xfs/058
deleted file mode 100755
index 89c441aa..00000000
diff --git a/tests/xfs/058.out b/tests/xfs/058.out
deleted file mode 100644
index 58a426b5..00000000
diff --git a/tests/xfs/group b/tests/xfs/group
index e7de18dd..fd634275 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -54,8 +54,6 @@
 054 auto quick
 055 dump ioctl remote tape
 056 dump ioctl auto quick
-057 acl auto
-058 acl auto
 059 dump ioctl auto quick
 060 dump ioctl auto quick
 061 dump ioctl auto quick
-- 
2.13.3

