Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752011AbeBXCPQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Feb 2018 21:15:16 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH] xfs_scrub: make interpreter explicit to python3
Date: Fri, 23 Feb 2018 18:15:12 -0800
Message-Id: <20180224021512.23819-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

Using #!/usr/bin/env makes some package dependency tools
such as rpm complain given that it cannot verify package
dependencies. Making it explicit resolves this lint rant.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 scrub/xfs_scrub_all.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index fff05da3ea7a..80f07d5c8b02 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -1,4 +1,4 @@
-#!/usr/bin/env python3
+#!/usr/bin/python3
 
 # Run online scrubbers in parallel, but avoid thrashing.
 #
-- 
2.16.2

