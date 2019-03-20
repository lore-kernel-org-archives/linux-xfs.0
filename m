Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46708 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726123AbfCTOUf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Mar 2019 10:20:35 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2KE9CKn113670
        for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2019 10:20:33 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2rbnnbpe75-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2019 10:20:33 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 20 Mar 2019 14:20:31 -0000
From: Chandan Rajendra <chandan@linux.ibm.com>
Subject: [PATCH] _require_prjquota: Disable tests only when using realtime fs
Date: Wed, 20 Mar 2019 19:51:12 +0530
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <20190320142112.31239-1-chandan@linux.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.ibm.com>, guaneryu@gmail.com, linux-xfs@vger.kernel.org

$USE_EXTERNAL needs to be set when using external log devices. In such a
setup, tests which have "_require_prjquota
$SCRATCH_DEV" (e.g. generic/383)  incorrectly end up being marked as
"not run" since the test "[ "$USE_EXTERNAL" = yes -a ! -z "$_dev" ]"
evaluates to true.

This commit fixes the bug by marking the test as "not run" only when
$USE_EXTERNAL is set and one of $TEST_RTDEV or $SCRATCH_RTDEV is set.

Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
---
 common/quota | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/common/quota b/common/quota
index 9309e786..cb627f19 100644
--- a/common/quota
+++ b/common/quota
@@ -86,8 +86,9 @@ _require_prjquota()
     fi
     src/feature -P $_dev
     [ $? -ne 0 ] && _notrun "Installed kernel does not support project quotas"
-    if [ "$USE_EXTERNAL" = yes -a ! -z "$_dev" ]; then
-	_notrun "Project quotas not supported on realtime filesystem"
+    if [ "$USE_EXTERNAL" = yes -a \
+		 \( ! -z "$TEST_RTDEV" \-o ! -z "$SCRATCH_RTDEV" \) ]; then
+        _notrun "Project quotas not supported on realtime filesystem"
     fi
 }
 
-- 
2.19.1
