Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33184 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751635AbdGUEkO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:14 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 06/15] tests: remove xfs/114 and xfs/115
Date: Thu, 20 Jul 2017 21:38:44 -0700
Message-Id: <20170721043853.364-7-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

These two IRIX and XFS-specific tests tested the "parent pointer"
feature which is not implemented by XFS on Linux.  Just remove them.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/xfs/114     | 340 --------------------------------------------------
 tests/xfs/114.out | 365 ------------------------------------------------------
 tests/xfs/115     | 257 --------------------------------------
 tests/xfs/115.out | 118 ------------------
 tests/xfs/group   |   2 -
 5 files changed, 1082 deletions(-)
 delete mode 100755 tests/xfs/114
 delete mode 100644 tests/xfs/114.out
 delete mode 100755 tests/xfs/115
 delete mode 100644 tests/xfs/115.out

diff --git a/tests/xfs/114 b/tests/xfs/114
deleted file mode 100755
index 24474f74..00000000
diff --git a/tests/xfs/114.out b/tests/xfs/114.out
deleted file mode 100644
index a36396e2..00000000
diff --git a/tests/xfs/115 b/tests/xfs/115
deleted file mode 100755
index cf17388d..00000000
diff --git a/tests/xfs/115.out b/tests/xfs/115.out
deleted file mode 100644
index 44d8e55e..00000000
diff --git a/tests/xfs/group b/tests/xfs/group
index ffdb0615..e7de18dd 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -111,8 +111,6 @@
 111 ioctl
 112 fuzzers
 113 fuzzers
-114 parent attr stress
-115 parent attr
 116 quota auto quick
 117 fuzzers
 118 auto quick fsr dangerous
-- 
2.13.3

