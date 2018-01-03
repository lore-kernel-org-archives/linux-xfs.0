Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43669 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbeACSkm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 13:40:42 -0500
Subject: [PATCH 5/5] find-api-violations: fix a broken grep pattern
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 03 Jan 2018 10:40:38 -0800
Message-ID: <151500483813.7713.6158652834791382962.stgit@magnolia>
In-Reply-To: <151500479880.7713.6538509149156363572.stgit@magnolia>
References: <151500479880.7713.6538509149156363572.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

One of the grep patterns in find-api-violations is mistaken for a
(broken) range specifier when LC_ALL=C, so fix it to work properly.
This was found by wiring up the script to xfstests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/find-api-violations.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tools/find-api-violations.sh b/tools/find-api-violations.sh
index c2be4c5..3b976d3 100755
--- a/tools/find-api-violations.sh
+++ b/tools/find-api-violations.sh
@@ -10,7 +10,7 @@ tool_dirs="copy db estimate fsck fsr growfs io logprint mdrestore mkfs quota rep
 
 # Calls to xfs_* functions in libxfs/*.c without the libxfs_ prefix
 find_possible_api_calls() {
-	grep -rn '[[:space:],-(]xfs_[a-z_]*(' $tool_dirs | sed -e 's/^.*\(xfs_[a-z_]*\)(.*$/\1/g' | sort | uniq
+	grep -rn '[-[:space:],(]xfs_[a-z_]*(' $tool_dirs | sed -e 's/^.*\(xfs_[a-z_]*\)(.*$/\1/g' | sort | uniq
 }
 
 check_if_api_calls() {

