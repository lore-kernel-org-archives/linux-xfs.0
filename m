Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6HNr00t065376 for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 18:53:00 -0500
Received: from e9.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9CCF52AA10
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 16:52:59 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id IDLUA59IzKQE3EhY for
	<xfs@oss.sgi.com>; Sun, 17 Jul 2011 16:52:59 -0700 (PDT)
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6HNKoPf018054
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 19:20:50 -0400
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP
	id p6HNpfL7075334
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 17:51:41 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6HNpfcG027714
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 17:51:41 -0600
From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/2 v8] XFS TESTS: ENOSPC Punch Hole: Move su routines in 123
	to common.rc
Date: Sun, 17 Jul 2011 16:52:45 -0700
Message-Id: <1310946766-30217-2-git-send-email-achender@linux.vnet.ibm.com>
In-Reply-To: <1310946766-30217-1-git-send-email-achender@linux.vnet.ibm.com>
References: <1310946766-30217-1-git-send-email-achender@linux.vnet.ibm.com>
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
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: Allison Henderson <achender@linux.vnet.ibm.com>

This patch moves the su routines in test 123 to common.rc
so that they can also be used in the new test 255

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100755 100755 27c1e66... ee1194d... M	123
:100644 100644 680631d... 9d68574... M	common.rc
 123       |   24 ------------------------
 common.rc |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/123 b/123
index 27c1e66..ee1194d 100755
--- a/123
+++ b/123
@@ -42,30 +42,6 @@ _cleanup()
     _cleanup_testdir
 }
 
-
-_filter_user_do()
-{
-        perl -ne "
-s,.*Permission\sdenied.*,Permission denied,;
-s,.*no\saccess\sto\stty.*,,;
-s,.*no\sjob\scontrol\sin\sthis\sshell.*,,;
-s,^\s*$,,;
-        print;"
-}
-
-
-
-
-_user_do()
-{
-    if [ "$HOSTOS" == "IRIX" ]
-	then
-	echo $1 | /bin/bash "su $qa_user 2>&1" | _filter_user_do
-    else
-	echo $1 | su $qa_user 2>&1 | _filter_user_do
-    fi
-}
-
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
diff --git a/common.rc b/common.rc
index 680631d..9d68574 100644
--- a/common.rc
+++ b/common.rc
@@ -867,6 +867,26 @@ _require_user()
     [ "$?" == "0" ] || _notrun "$qa_user user not defined."
 }
 
+_filter_user_do()
+{
+        perl -ne "
+s,.*Permission\sdenied.*,Permission denied,;
+s,.*no\saccess\sto\stty.*,,;
+s,.*no\sjob\scontrol\sin\sthis\sshell.*,,;
+s,^\s*$,,;
+        print;"
+}
+
+_user_do()
+{
+    if [ "$HOSTOS" == "IRIX" ]
+	then
+	echo $1 | /bin/bash "su $qa_user 2>&1" | _filter_user_do
+    else
+	echo $1 | su $qa_user 2>&1 | _filter_user_do
+    fi  
+}
+
 # check that xfs_io, glibc, kernel, and filesystem all (!) support
 # fallocate
 #
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
