Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49572 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406524AbeKWEkI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 23:40:08 -0500
Subject: [PATCH 11/12] common/dump: disable copyrange
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Nov 2018 09:59:37 -0800
Message-ID: <154290957785.1218.10166123029263020778.stgit@magnolia>
In-Reply-To: <154290950237.1218.9937108728673485814.stgit@magnolia>
References: <154290950237.1218.9937108728673485814.stgit@magnolia>
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
