Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o68FL7UJ047923 for <xfs@oss.sgi.com>; Thu, 8 Jul 2010 10:21:07 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04E8715A087E
	for <xfs@oss.sgi.com>; Thu,  8 Jul 2010 08:23:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8HTaSWdTdXJ6bZZV for
	<xfs@oss.sgi.com>; Thu, 08 Jul 2010 08:23:59 -0700 (PDT)
Received: from int-mx04.intmail.prod.int.phx2.redhat.com
	(int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o68FNwYI028023
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 8 Jul 2010 11:23:58 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] Allow to specify unsupported file systems
Date: Thu,  8 Jul 2010 17:23:51 +0200
Message-Id: <1278602632-12425-1-git-send-email-lczerner@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: lczerner@redhat.com, esandeen@redhat.com

As an addition to checking for supported file systems it would be nice
to be able to specify unsupported file system. In combination with
"generic" fs it can be useful. This patch adds that feature. For example
to set ext3 as an unsupported fs add "!ext3" into list.

Also specify ext3 and ex4 as unsupported file systems in 213 and 214
since those fs does not support fallocate. There may be others though.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 213       |    2 +-
 214       |    2 +-
 common.rc |   22 +++++++++++++++++-----
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/213 b/213
index 9982dd4..3e90c0a 100755
--- a/213
+++ b/213
@@ -47,7 +47,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 # generic, but xfs_io's fallocate must work
-_supported_fs generic
+_supported_fs generic !ext3 !ext3
 # only Linux supports fallocate
 _supported_os Linux
 
diff --git a/214 b/214
index cef7626..c01ef30 100755
--- a/214
+++ b/214
@@ -45,7 +45,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
 # generic, but xfs_io's fallocate must work
-_supported_fs generic
+_supported_fs generic !ext3 !ext2
 # only Linux supports fallocate
 _supported_os Linux
 
diff --git a/common.rc b/common.rc
index 6bf1e12..f2f4cc3 100644
--- a/common.rc
+++ b/common.rc
@@ -656,15 +656,27 @@ _fail()
 #
 _supported_fs()
 {
+    supp=0
     for f
     do
-	if [ "$f" = "$FSTYP" -o "$f" = "generic" ]
-	then
-	    return
-	fi
+        if [ "$f" = \!"$FSTYP" ]
+        then
+            supp=0
+            break
+        fi
+
+        if [ "$f" = "$FSTYP" -o "$f" = "generic" ]
+        then
+            supp=1
+        fi
     done
 
-    _notrun "not suitable for this filesystem type: $FSTYP"
+    if [ $supp -eq 1 ]
+    then
+        return
+    else
+        _notrun "not suitable for this filesystem type: $FSTYP"
+    fi
 }
 
 # tests whether $FSTYP is one of the supported OSes for a test
-- 
1.7.1.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
