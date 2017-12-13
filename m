Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752977AbdLMAp3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Dec 2017 19:45:29 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 8/9] tests/xfs/group: add group for tests which require mkfs v4_5
Date: Tue, 12 Dec 2017 16:45:18 -0800
Message-Id: <20171213004519.29340-9-mcgrof@kernel.org>
In-Reply-To: <20171213004519.29340-1-mcgrof@kernel.org>
References: <20171213004519.29340-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

This lets us skip these tests on newer systems.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 tests/xfs/group | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/group b/tests/xfs/group
index 656b65f5fe7a..ebb1685e22eb 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -93,7 +93,7 @@
 093 fuzzers
 094 metadata dir ioctl auto realtimedev
 095 log v2log auto
-096 mkfs v2log auto quick
+096 mkfs v2log auto quick mkfs_4_5
 097 fuzzers
 098 fuzzers
 099 fuzzers
-- 
2.15.0

