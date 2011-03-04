Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24KJLv4186879 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 14:19:22 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103042022.p24KMAss008218@stout.americas.sgi.com>
Date: Fri, 04 Mar 2011 14:22:10 -0600
Subject: [PATCH] xfstests: make 127 and 134 clean up after themselves
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Tests 127 and 134 leave temp files around when they complete.
Fix (or enable) their cleanup functions to remedy this.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 127 |    1 +
 134 |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: b/127
===================================================================
--- a/127
+++ b/127
@@ -38,6 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 1
 
 _cleanup()
 {
+    rm -f $tmp.output
     _cleanup_testdir
 }
 
Index: b/134
===================================================================
--- a/134
+++ b/134
@@ -43,8 +43,7 @@ _cleanup()
 	umount $SCRATCH_MNT 2>/dev/null
 	rm -f $tmp.*
 }
-#trap "_cleanup; exit \$status" 0 1 2 3 15
-
+trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 _supported_fs xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
