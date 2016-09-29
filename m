Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17220 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754390AbcI2C2j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2016 22:28:39 -0400
Subject: [PATCH 2/3] xfs/130: don't modify files after failed mount
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 28 Sep 2016 19:28:34 -0700
Message-ID: <147511611421.12284.6952703843128702262.stgit@birch.djwong.org>
In-Reply-To: <147511610789.12284.10323409415801065382.stgit@birch.djwong.org>
References: <147511610789.12284.10323409415801065382.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

In xfs/130, we try to mount a filesystem with the expectation that it
will fail.  Therefore, it is inappropriate to try to write to the
mountpoint, since it could otherwise be writable.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/130     |    9 +++------
 tests/xfs/130.out |    1 -
 2 files changed, 3 insertions(+), 7 deletions(-)


diff --git a/tests/xfs/130 b/tests/xfs/130
index 554d078..48f6a84 100755
--- a/tests/xfs/130
+++ b/tests/xfs/130
@@ -79,12 +79,9 @@ seq 0 $((agcount - 1)) | while read ag; do
 done
 
 echo "+ mount image"
-_scratch_mount
-
-echo "+ reflink more"
-_cp_reflink "${SCRATCH_MNT}/file1" "${SCRATCH_MNT}/file4" 2> /dev/null && \
-	_fail "should not be able to reflink with busted refcount btree"
-umount "${SCRATCH_MNT}"
+_scratch_mount >> $seqres.full 2>&1 && \
+	echo "Should not be able to mount with broken refcountbt."
+_scratch_unmount >> $seqres.full 2>&1
 
 echo "+ repair fs"
 _disable_dmesg_check
diff --git a/tests/xfs/130.out b/tests/xfs/130.out
index 58d153b..a0eab98 100644
--- a/tests/xfs/130.out
+++ b/tests/xfs/130.out
@@ -5,7 +5,6 @@ QA output created by 130
 + check fs
 + corrupt image
 + mount image
-+ reflink more
 + repair fs
 + mount image (2)
 + chattr -R -i

