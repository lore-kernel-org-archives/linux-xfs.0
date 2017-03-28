Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754732AbdC1IrB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Mar 2017 04:47:01 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v9 2/2] xfs/068: update golden output due to new operations in fsstress
Date: Tue, 28 Mar 2017 16:46:35 +0800
Message-Id: <1490690795-4527-2-git-send-email-zlang@redhat.com>
In-Reply-To: <1490690795-4527-1-git-send-email-zlang@redhat.com>
References: <1490690795-4527-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

xfs/068 use a fixed seed (-s) and number of operations (-n) to run
fsstress, to get fixed number of files and directories. But new
operations of fsstress will break this "fixed number". So update
it, after fsstress get new operations.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 tests/xfs/068     | 2 --
 tests/xfs/068.out | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tests/xfs/068 b/tests/xfs/068
index 4dac95e..7151e28 100755
--- a/tests/xfs/068
+++ b/tests/xfs/068
@@ -43,8 +43,6 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
 _supported_fs xfs
 _supported_os Linux
 
-# need to ensure new fsstress operations don't perturb expected output
-FSSTRESS_AVOID="-f insert=0 $FSSTRESS_AVOID"
 _create_dumpdir_stress_num 4096
 _do_dump_restore
 
diff --git a/tests/xfs/068.out b/tests/xfs/068.out
index 2196eee..b20604f 100644
--- a/tests/xfs/068.out
+++ b/tests/xfs/068.out
@@ -22,7 +22,7 @@ xfsrestore: session id: ID
 xfsrestore: media ID: ID
 xfsrestore: searching media for directory dump
 xfsrestore: reading directories
-xfsrestore: 495 directories and 1593 entries processed
+xfsrestore: 474 directories and 1592 entries processed
 xfsrestore: directory post-processing
 xfsrestore: restoring non-directory files
 xfsrestore: restore complete: SECS seconds elapsed
-- 
2.7.4

