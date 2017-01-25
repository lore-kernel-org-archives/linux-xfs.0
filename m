Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49657 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751232AbdAYF3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 00:29:30 -0500
Date: Tue, 24 Jan 2017 21:28:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] tools/find-api-violations: fix missing dirs in the
 directory list
Message-ID: <20170125052852.GK9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, chandan@linux.vnet.ibm.com

Fix a stupid typo in the original commit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/find-api-violations.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/find-api-violations.sh b/tools/find-api-violations.sh
index 7937749..c2be4c5 100755
--- a/tools/find-api-violations.sh
+++ b/tools/find-api-violations.sh
@@ -6,7 +6,7 @@
 
 # NOTE: This script doesn't look for API violations in function parameters.
 
-tool_dirs="copy db estimate fs fsck fsr growfs io mdrestore mkfs quota repair rtcp"
+tool_dirs="copy db estimate fsck fsr growfs io logprint mdrestore mkfs quota repair rtcp"
 
 # Calls to xfs_* functions in libxfs/*.c without the libxfs_ prefix
 find_possible_api_calls() {
