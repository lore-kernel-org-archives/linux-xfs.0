Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752963AbdLMAp2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Dec 2017 19:45:28 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 7/9] tests/xfs/group: add realtimedev group
Date: Tue, 12 Dec 2017 16:45:17 -0800
Message-Id: <20171213004519.29340-8-mcgrof@kernel.org>
In-Reply-To: <20171213004519.29340-1-mcgrof@kernel.org>
References: <20171213004519.29340-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

This groups up tests which require an external realtime volume,
ie, SCRATCH_RTDEV. This requires CONFIG_XFS_RT and not all kernels
support this.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 tests/xfs/group | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/tests/xfs/group b/tests/xfs/group
index cce98847de53..656b65f5fe7a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -87,11 +87,11 @@
 087 fuzzers
 088 fuzzers
 089 fuzzers
-090 rw auto
+090 rw auto realtimedev
 091 fuzzers
 092 other auto quick
 093 fuzzers
-094 metadata dir ioctl auto
+094 metadata dir ioctl auto realtimedev
 095 log v2log auto
 096 mkfs v2log auto quick
 097 fuzzers
@@ -128,7 +128,7 @@
 128 auto quick clone fsr
 129 auto quick clone
 130 fuzzers clone
-131 auto quick clone
+131 auto quick clone realtimedev
 132 auto quick clone
 133 dangerous_fuzzers
 134 dangerous_fuzzers
@@ -273,7 +273,7 @@
 273 auto rmap fsmap
 274 auto quick rmap fsmap
 275 auto quick rmap fsmap logdev
-276 auto quick rmap fsmap
+276 auto quick rmap fsmap realtimedev
 277 auto quick rmap fsmap
 278 repair auto
 279 auto mkfs
@@ -331,16 +331,16 @@
 331 auto quick rmap clone
 332 auto quick rmap clone
 333 auto quick rmap
-334 auto quick rmap
-335 auto rmap
-336 auto rmap
-337 fuzzers rmap
-338 auto quick rmap
-339 auto quick rmap
-340 auto quick rmap
-341 auto quick rmap
-342 auto quick rmap
-343 auto quick rmap
+334 auto quick rmap realtimedev
+335 auto rmap realtimedev
+336 auto rmap realtimedev
+337 fuzzers rmap realtimedev
+338 auto quick rmap realtimedev
+339 auto quick rmap realtimedev
+340 auto quick rmap realtimedev
+341 auto quick rmap realtimedev
+342 auto quick rmap realtimedev
+343 auto quick rmap realtimedev
 344 auto quick clone
 345 auto quick clone
 346 auto quick clone
@@ -403,10 +403,10 @@
 403 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 404 dangerous_fuzzers dangerous_scrub dangerous_repair
 405 dangerous_fuzzers dangerous_scrub dangerous_online_repair
-406 dangerous_fuzzers dangerous_scrub dangerous_repair
+406 dangerous_fuzzers dangerous_scrub dangerous_repair realtimedev
 407 dangerous_fuzzers dangerous_scrub dangerous_online_repair
-408 dangerous_fuzzers dangerous_scrub dangerous_repair
-409 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+408 dangerous_fuzzers dangerous_scrub dangerous_repair realtimedev
+409 dangerous_fuzzers dangerous_scrub dangerous_online_repair realtimedev
 410 dangerous_fuzzers dangerous_scrub dangerous_repair
 411 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 412 dangerous_fuzzers dangerous_scrub dangerous_repair
@@ -416,7 +416,7 @@
 416 dangerous_fuzzers dangerous_scrub dangerous_repair
 417 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 418 dangerous_fuzzers dangerous_scrub dangerous_repair
-419 auto quick
+419 auto quick realtimedev
 420 auto quick clone dedupe
 421 auto quick clone dedupe
 422 dangerous_scrub dangerous_online_repair
-- 
2.15.0

