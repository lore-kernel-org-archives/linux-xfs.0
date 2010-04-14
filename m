Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3EGTfWh083693 for <xfs@oss.sgi.com>; Wed, 14 Apr 2010 11:29:41 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 765491000729
	for <xfs@oss.sgi.com>; Wed, 14 Apr 2010 09:31:35 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 5NgZqyID86kdZ7cv for
	<xfs@oss.sgi.com>; Wed, 14 Apr 2010 09:31:35 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id EF5E19E8141
	for <xfs@oss.sgi.com>; Wed, 14 Apr 2010 11:31:34 -0500 (CDT)
Message-ID: <4BC5EDE6.7000001@sandeen.net>
Date: Wed, 14 Apr 2010 11:31:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: make sure $seq.full files don't land in /
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
To: xfs-oss <xfs@oss.sgi.com>

186 and 192, at least, were landing (part of) their $seq.full
files in /

Fix this by using $here/$seq.full where needed.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/186 b/186
index 94d399a..643f4b1 100755
--- a/186
+++ b/186
@@ -79,7 +79,7 @@ _rmv_eas()
 
 _filter_inode()
 {
-	tee -a $seq.full | \
+	tee -a $here/$seq.full | \
 		sed -e "s/core.forkoff/forkoff/g" | \
 		egrep '^u.sfdir2|^a.sfattr|forkoff' | \
 		egrep -v 'inumber|parent'
@@ -87,7 +87,7 @@ _filter_inode()
 
 _filter_version()
 {
-	tee -a $seq.full | tr ',' '\n' | grep ATTR
+	tee -a $here/$seq.full | tr ',' '\n' | grep ATTR
 }
 
 _print_inode()
diff --git a/192 b/192
index 0d0b294..d8301d5 100755
--- a/192
+++ b/192
@@ -68,7 +68,7 @@ time2=`_access_time $testfile | tee -a $seq.full`
 cd /
 umount $TEST_DIR
 _test_mount
-time3=`_access_time $testfile | tee -a $seq.full`
+time3=`_access_time $testfile | tee -a $here/$seq.full`
 
 delta1=`expr $time2 - $time1`
 delta2=`expr $time3 - $time1`


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
