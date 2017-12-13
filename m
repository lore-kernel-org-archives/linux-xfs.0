Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753000AbdLMAp3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Dec 2017 19:45:29 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 9/9] tests/xfs/group: add injection group
Date: Tue, 12 Dec 2017 16:45:19 -0800
Message-Id: <20171213004519.29340-10-mcgrof@kernel.org>
In-Reply-To: <20171213004519.29340-1-mcgrof@kernel.org>
References: <20171213004519.29340-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

XFS error injection requires CONFIG_XFS_DEBUG and not all kernels
have this enabled.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 tests/xfs/group | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tests/xfs/group b/tests/xfs/group
index ebb1685e22eb..1df0ab32b71c 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -54,7 +54,7 @@
 054 auto quick
 055 dump ioctl remote tape
 056 dump ioctl auto quick
-057 auto log
+057 auto log injection
 058 auto quick fuzzers
 059 dump ioctl auto quick
 060 dump ioctl auto quick
@@ -138,7 +138,7 @@
 138 auto quick
 139 auto quick clone
 140 auto clone
-141 auto log metadata
+141 auto log metadata injection
 142 dmapi
 143 dmapi
 144 dmapi
@@ -193,7 +193,7 @@
 193 auto quick clone
 194 rw auto
 195 ioctl dump auto quick
-196 auto quick rw
+196 auto quick rw injection
 197 dir auto quick
 198 auto quick clone
 199 mount auto quick
@@ -315,7 +315,7 @@
 315 auto quick clone
 316 auto quick clone
 317 auto quick rmap
-318 auto quick rw
+318 auto quick rw injection
 319 auto quick clone
 320 auto quick clone
 321 auto quick clone
@@ -430,7 +430,7 @@
 430 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 431 auto quick dangerous
 432 auto quick dir metadata
-433 auto quick attr
+433 auto quick attr injection
 434 auto quick clone fsr
 435 auto quick clone
 436 auto quick clone fsr
-- 
2.15.0

