Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33806 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbeKUI3M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 03:29:12 -0500
Subject: [PATCH 10/10] common/dump: disable copyrange
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Nov 2018 13:57:51 -0800
Message-ID: <154275107150.8611.15972158351495348017.stgit@magnolia>
In-Reply-To: <154275100143.8611.10235098565750994724.stgit@magnolia>
References: <154275100143.8611.10235098565750994724.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In _create_dumpdir_stress_num, disable copyrange in fsstress so that we
dump exactly the same set of files and directories no matter how the xfs
is configured.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/dump |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/common/dump b/common/dump
index c45b8a5a..4d1a1607 100644
--- a/common/dump
+++ b/common/dump
@@ -307,6 +307,9 @@ _create_dumpdir_stress_num()
     if $FSSTRESS_PROG | grep -q deduperange; then
         FSSTRESS_AVOID="-f deduperange=0 $FSSTRESS_AVOID"
     fi
+    if $FSSTRESS_PROG | grep -q copyrange; then
+        FSSTRESS_AVOID="-f copyrange=0 $FSSTRESS_AVOID"
+    fi
 
     echo ""
     echo "-----------------------------------------------"
