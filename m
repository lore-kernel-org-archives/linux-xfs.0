Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755650AbdLOUlV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Dec 2017 15:41:21 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH] tests/xfs/040: document purpose
Date: Fri, 15 Dec 2017 12:41:18 -0800
Message-Id: <20171215204118.17740-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

Getting xfs/040 to "pass" takes a bit of effort, however the effort
to require updating xfsprogs is purely an xfsprogs maintainer task
only. There no functional gain by users of xfs or a QA team to get
this test to pass. This is not trivial from the current description
so document this.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 tests/xfs/040 | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tests/xfs/040 b/tests/xfs/040
index fadb888cbfaf..a0abc42f3720 100755
--- a/tests/xfs/040
+++ b/tests/xfs/040
@@ -3,6 +3,11 @@
 #
 # compare-libxfs test
 #
+# The purpose of this test is only to nag the maintainer of xfsprogs to try to
+# keep xfsprogs's libxfs files in sync with the latest kernel's libxfs. There
+# is no functional need for anyone to actually run this test to confirm
+# proper XFS functionalilty, this is an xfsprogs maintainer test.
+#
 #-----------------------------------------------------------------------
 # Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
 #
-- 
2.15.0

