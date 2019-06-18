Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38140 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731068AbfFRVHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 17:07:13 -0400
Subject: [PATCH 1/4] dump: _cleanup_dump should only check the scratch fs if
 the test required it
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Jun 2019 14:07:08 -0700
Message-ID: <156089202883.345809.17656192140244878661.stgit@magnolia>
In-Reply-To: <156089201978.345809.17444450351199726553.stgit@magnolia>
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

_cleanup_dump always tries to check the scratch fs, even if the caller
didn't actually _require_scratch.  If a previous test wrote garbage to
the scratch device then the dump test will fail here when repair
stumbles over the garbage.

This was observed by running xfs/016 and xfs/036 in succession.  xfs/016
writes 0xc6 to the scratch device and tries to format a small log.  If
the log is too small the format fails and the test will _notrun.  The
subsequent xfs/036 will _notrun and then _cleanup_dump if no tape device
is set, at which point we try to check the scratch device and logprint
aborts due to the abnormal log size (0xc6c6c6c6).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/dump |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/dump b/common/dump
index 7c4c9cd8..2b8e0893 100644
--- a/common/dump
+++ b/common/dump
@@ -250,7 +250,7 @@ _cleanup_dump()
 	mv $dir.$seq $dir
     done
 
-    if [ $status -ne $NOTRUNSTS ]; then
+    if [ -f ${RESULT_DIR}/require_scratch ] && [ $status -ne $NOTRUNSTS ]; then
 	# Sleep added to stop _check_scratch_fs from complaining that the
 	# scratch_dev is still busy
 	sleep 10
