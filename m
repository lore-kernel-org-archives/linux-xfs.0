Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:33663 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753405AbeEVXeO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 19:34:14 -0400
Received: by mail-pg0-f41.google.com with SMTP id e21-v6so3633015pgv.0
        for <linux-xfs@vger.kernel.org>; Tue, 22 May 2018 16:34:14 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v3 1/5] xfstests: create swap group
Date: Tue, 22 May 2018 16:33:56 -0700
Message-Id: <2c1b93f083744241dfcbb47a794c17b1440b92e5.1527031843.git.osandov@fb.com>
In-Reply-To: <cover.1527031843.git.osandov@fb.com>
References: <cover.1527031843.git.osandov@fb.com>
In-Reply-To: <cover.1527031843.git.osandov@fb.com>
References: <cover.1527031843.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Eryu Guan <guaneryu@gmail.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

I'm going to add a bunch of tests for swap files, so create a group for
them and add the existing tests.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 tests/generic/group | 4 ++--
 tests/xfs/group     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/generic/group b/tests/generic/group
index 4fc3e457..111e42e7 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -358,8 +358,8 @@
 353 auto quick clone
 354 auto
 355 auto quick
-356 auto quick clone
-357 auto quick clone
+356 auto quick clone swap
+357 auto quick clone swap
 358 auto quick clone
 359 auto quick clone
 360 auto quick metadata
diff --git a/tests/xfs/group b/tests/xfs/group
index 51326d95..e5fd1c6d 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -416,7 +416,7 @@
 416 dangerous_fuzzers dangerous_scrub dangerous_repair
 417 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 418 dangerous_fuzzers dangerous_scrub dangerous_repair
-419 auto quick
+419 auto quick swap
 420 auto quick clone dedupe
 421 auto quick clone dedupe
 422 dangerous_scrub dangerous_online_repair
-- 
2.17.0

