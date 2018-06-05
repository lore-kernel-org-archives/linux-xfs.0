Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47070 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbeFEQnM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 12:43:12 -0400
Subject: [PATCH 2/6] xfs/122: fix sb_fname[XFSLABEL_MAX] in test
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 05 Jun 2018 09:43:02 -0700
Message-ID: <152821698275.24976.1415491462214552908.stgit@magnolia>
In-Reply-To: <152821697018.24976.12939094615403004592.stgit@magnolia>
References: <152821697018.24976.12939094615403004592.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We recently redefined sb_fname's array length to use a symbolic constant
instead of a magic number, so update this test accordingly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index d8366701..0de99b6d 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -218,6 +218,7 @@ cat /usr/include/xfs/xfs*.h | indent |\
 awk '
    /typedef struct xfs_sb/ { structon = 1; next }
    structon && $2 ~ /^sb_/ { sub(/[;,]/,"",$2)
+                             sub(/XFSLABEL_MAX/,"12",$2)
                              printf("printf(\"offsetof(xfs_sb_t, %s) = \\%zu\\n\", offsetof(xfs_sb_t, %s));", $2, $2); next}
    structon && /}/ { structon = 0; next}
 '>>$cprog

