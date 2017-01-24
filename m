Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44222 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdAXRWP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 12:22:15 -0500
Date: Tue, 24 Jan 2017 09:22:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] tools/find-api-violations: fix fs -> fsr in the directory
 list
Message-ID: <20170124172210.GC9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

Fix a stupid typo in the original commit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/find-api-violations.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/find-api-violations.sh b/tools/find-api-violations.sh
index 7937749..b4b8de5 100755
--- a/tools/find-api-violations.sh
+++ b/tools/find-api-violations.sh
@@ -6,7 +6,7 @@
 
 # NOTE: This script doesn't look for API violations in function parameters.
 
-tool_dirs="copy db estimate fs fsck fsr growfs io mdrestore mkfs quota repair rtcp"
+tool_dirs="copy db estimate fsr fsck fsr growfs io mdrestore mkfs quota repair rtcp"
 
 # Calls to xfs_* functions in libxfs/*.c without the libxfs_ prefix
 find_possible_api_calls() {
