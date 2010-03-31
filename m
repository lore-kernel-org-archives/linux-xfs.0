Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2VJ5Fc9049851 for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 14:05:15 -0500
Received: from smtp-out.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0684727FD8B
	for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 12:07:01 -0700 (PDT)
Received: from smtp-out.google.com (smtp-out.google.com [216.239.44.51]) by
	cuda.sgi.com with ESMTP id xgPiZ44lViHWhqyH for
	<xfs@oss.sgi.com>; Wed, 31 Mar 2010 12:07:01 -0700 (PDT)
Received: from hpaq7.eem.corp.google.com (hpaq7.eem.corp.google.com
	[10.3.21.7]) by smtp-out.google.com with ESMTP id o2VJ708e030351
	for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 12:07:00 -0700
From: Akshay Lal <akshaylal@google.com>
Subject: [PATCH] xfstests: made test 215 backwards compatible with older
	version of bash.
Date: Wed, 31 Mar 2010 12:06:33 -0700
Message-Id: <1270062393-5233-1-git-send-email-akshaylal@google.com>
In-Reply-To: <Fix for test 215>
References: <Fix for test 215>
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
Cc: Akshay Lal <akshaylal@google.com>

Test 215 fails on older versions of bash (2.x), mainly due to the use of
'let' for arithemetic operations. Changed to 'expr'.

Signed-off-by: Akshay Lal <akshaylal@google.com>

On branch fix-test-215
Changes to be committed:
diff --git a/215 b/215
index c61f7a5..08aa212 100644
--- a/215
+++ b/215
@@ -68,8 +68,9 @@ $XFS_IO_PROG -F -f            \
 mtime2=`stat --printf="%Y" $testfile`
 ctime2=`stat --printf="%Z" $testfile`

-let mtime_diff=$mtime2-$mtime1
-let ctime_diff=$ctime2-$ctime1
+# Allow support for older bash versions.
+mtime_diff=`expr $mtime2 - $mtime1`
+ctime_diff=`expr $ctime2 - $ctime1`

 if [ "$mtime_diff" -eq "0" ]; then
    echo "FAIL: mtime not update after mapped write"
---
 215 |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/215 b/215
index c61f7a5..24424c2 100644
--- a/215
+++ b/215
@@ -68,8 +68,9 @@ $XFS_IO_PROG -F -f 		\
 mtime2=`stat --printf="%Y" $testfile`
 ctime2=`stat --printf="%Z" $testfile`
 
-let mtime_diff=$mtime2-$mtime1
-let ctime_diff=$ctime2-$ctime1
+# Allow support for older bash versions.
+mtime_diff=`expr $mtime2 - $mtime1`
+ctime_diff=`expr $ctime2 - $ctime1`
 
 if [ "$mtime_diff" -eq "0" ]; then
    echo "FAIL: mtime not update after mapped write"
-- 
1.7.0.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
