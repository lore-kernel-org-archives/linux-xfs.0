Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752954AbdLMAp2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Dec 2017 19:45:28 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 6/9] tests/ext4/group: add group for tests which require a logdev
Date: Tue, 12 Dec 2017 16:45:16 -0800
Message-Id: <20171213004519.29340-7-mcgrof@kernel.org>
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
 tests/ext4/group | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/ext4/group b/tests/ext4/group
index 257bb646f312..6fa2f06432f3 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -31,7 +31,7 @@
 026 auto quick attr
 027 auto quick fsmap
 028 auto quick fsmap
-029 auto quick fsmap
+029 auto quick fsmap logdev
 271 auto rw quick
 301 aio auto ioctl rw stress defrag
 302 aio auto ioctl rw stress defrag
-- 
2.15.0

