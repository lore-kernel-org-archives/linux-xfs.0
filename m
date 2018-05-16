Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:41263 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbeEPUi4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 16:38:56 -0400
Received: by mail-pg0-f45.google.com with SMTP id w4-v6so782352pgq.8
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 13:38:56 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 1/5] xfstests: create swap group
Date: Wed, 16 May 2018 13:38:45 -0700
Message-Id: <9e23fd02a4ba79d04d3dde6bfeba60691535e086.1526503000.git.osandov@fb.com>
In-Reply-To: <cover.1526503000.git.osandov@fb.com>
References: <cover.1526503000.git.osandov@fb.com>
In-Reply-To: <cover.1526503000.git.osandov@fb.com>
References: <cover.1526503000.git.osandov@fb.com>
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
index dc637c96..cded10f8 100644
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
index c2e6677e..dff8b99f 100644
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

