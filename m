Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55296 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbeLRUfz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 15:35:55 -0500
Subject: [PATCH 1/5] xfs/111: fix golden output
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Dec 2018 12:35:50 -0800
Message-ID: <154516535027.31115.4827015654233888092.stgit@magnolia>
In-Reply-To: <154516534392.31115.7010578395334646479.stgit@magnolia>
References: <154516534392.31115.7010578395334646479.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In commit f4eee5126, this test was changed to run xfs_fsr to bulkstat
its way through the filesystem until it finds the corrupt inode.  The
golden output was changed to capture xfs_fsr's output, but neglects the
fact that when fsr's output is not a tty, all the status and error
messages are sent to syslog, not stdout.  Therefore, this test
consistently fails because it expects output of "$SCRATCH_MNT start
inode=0" but this never appears.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/111     |    2 +-
 tests/xfs/111.out |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)


diff --git a/tests/xfs/111 b/tests/xfs/111
index 2ef69f07..965eb625 100755
--- a/tests/xfs/111
+++ b/tests/xfs/111
@@ -58,7 +58,7 @@ _try_scratch_mount || _fail "Couldn't mount after itrash"
 
 echo Attempting bulkstat
 #src/bstat -q $SCRATCH_MNT
-$XFS_FSR_PROG $SCRATCH_MNT | _filter_scratch
+$XFS_FSR_PROG -g $SCRATCH_MNT | _filter_scratch
 
 # Fix up intentional corruption so test can pass
 _scratch_unmount
diff --git a/tests/xfs/111.out b/tests/xfs/111.out
index fd56c3c8..41fa48f8 100644
--- a/tests/xfs/111.out
+++ b/tests/xfs/111.out
@@ -10,4 +10,3 @@ Blat inode clusters
 Starting overwrite
 Overwrite complete
 Attempting bulkstat
-SCRATCH_MNT start inode=0
