Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52048 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfGXP4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 11:56:38 -0400
Date: Wed, 24 Jul 2019 08:56:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 6/3] xfs/033: filter out root inode nlink repair
Message-ID: <20190724155631.GG7084@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394156831.1850719.2997473679130010771.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

A couple of releases ago, xfs_repair was patched to set the root inode
link count correctly when messing around with lost inodes.  However, the
old xfs_repair remains in the golden output, so remove it and filter the
line so that we don't cause 'new' regressions on old software.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/033             |   12 ++++++++++--
 tests/xfs/033.out.crc     |    2 --
 tests/xfs/033.out.default |    2 --
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/tests/xfs/033 b/tests/xfs/033
index 75b44f38..0ce67a9c 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -91,9 +91,17 @@ src/feature -P $SCRATCH_DEV && \
 	_notrun "PQuota are enabled, test needs controlled sb recovery"
 _scratch_unmount
 
+# We fixed some bugs in xfs_repair that caused us to have to reset the inode
+# link counts on the root inode twice.  That wasn't related to what this test
+# is checking, so remove the nlink reset line from the golden output and filter
+# old xfsprogs to avoid introducing new regressions.
+filter_repair() {
+	sed -e '/resetting inode INO nlinks from 1 to 2/d'
+}
+
 # rootino, rbmino, and rsumino are now set (lets blow em away!)
-_check_root_inos 0
-_check_root_inos -1 | _filter_bad_ids
+_check_root_inos 0 | filter_repair
+_check_root_inos -1 | filter_repair | _filter_bad_ids
 
 # success, all done
 status=0
diff --git a/tests/xfs/033.out.crc b/tests/xfs/033.out.crc
index 2ab4c432..594060f0 100644
--- a/tests/xfs/033.out.crc
+++ b/tests/xfs/033.out.crc
@@ -30,7 +30,6 @@ reinitializing root directory
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
 Phase 7 - verify and correct link counts...
-resetting inode INO nlinks from 1 to 2
 done
 Corrupting rt bitmap inode - setting bits to 0
 Wrote X.XXKb (value 0x0)
@@ -125,7 +124,6 @@ reinitializing root directory
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
 Phase 7 - verify and correct link counts...
-resetting inode INO nlinks from 1 to 2
 done
 Corrupting rt bitmap inode - setting bits to -1
 Wrote X.XXKb (value 0xffffffff)
diff --git a/tests/xfs/033.out.default b/tests/xfs/033.out.default
index 68bc7810..be297e5a 100644
--- a/tests/xfs/033.out.default
+++ b/tests/xfs/033.out.default
@@ -29,7 +29,6 @@ reinitializing root directory
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
 Phase 7 - verify and correct link counts...
-resetting inode INO nlinks from 1 to 2
 done
 Corrupting rt bitmap inode - setting bits to 0
 Wrote X.XXKb (value 0x0)
@@ -122,7 +121,6 @@ reinitializing root directory
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
 Phase 7 - verify and correct link counts...
-resetting inode INO nlinks from 1 to 2
 done
 Corrupting rt bitmap inode - setting bits to -1
 Wrote X.XXKb (value 0xffffffff)
