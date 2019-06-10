Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45139 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388901AbfFJTpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 15:45:54 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] generic/553: fix test description
Date: Mon, 10 Jun 2019 22:45:45 +0300
Message-Id: <20190610194545.8146-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

The test only checks copy to immutable file

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/553 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/553 b/tests/generic/553
index efe25d84..117c0ad5 100755
--- a/tests/generic/553
+++ b/tests/generic/553
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 553
 #
-# Check that we cannot copy_file_range() to/from an immutable file
+# Check that we cannot copy_file_range() to an immutable file
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-- 
2.17.1
