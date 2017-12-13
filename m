Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752953AbdLMAp2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Dec 2017 19:45:28 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 5/9] tests/xfs/group: add group for tests which require a logdev
Date: Tue, 12 Dec 2017 16:45:15 -0800
Message-Id: <20171213004519.29340-6-mcgrof@kernel.org>
In-Reply-To: <20171213004519.29340-1-mcgrof@kernel.org>
References: <20171213004519.29340-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

This should make it easy to run these separately or exclude them.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 tests/xfs/group | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/group b/tests/xfs/group
index d23006041ea2..cce98847de53 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -42,7 +42,7 @@
 042 fsr ioctl auto
 043 dump ioctl tape
 044 other auto
-045 other auto quick
+045 other auto quick logdev
 046 dump ioctl auto quick
 047 dump ioctl auto
 048 other auto quick
@@ -272,7 +272,7 @@
 272 auto quick rmap fsmap
 273 auto rmap fsmap
 274 auto quick rmap fsmap
-275 auto quick rmap fsmap
+275 auto quick rmap fsmap logdev
 276 auto quick rmap fsmap
 277 auto quick rmap fsmap
 278 repair auto
-- 
2.15.0

