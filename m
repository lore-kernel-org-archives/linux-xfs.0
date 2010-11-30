Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAUKlOXa138349 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 14:47:25 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8EC514004DF
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 12:49:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yqcQC5Q6z5AKcqRC for
	<xfs@oss.sgi.com>; Tue, 30 Nov 2010 12:49:02 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAUKn0oC012511
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 15:49:00 -0500
Received: from localhost.localdomain (test1244.test.redhat.com [10.10.10.244])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id oAUKmxnN026097
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 15:49:00 -0500
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Xfstest 245: accept ENOTEMPTY as a valid error for the test
Date: Tue, 30 Nov 2010 15:39:25 -0500
Message-Id: <1291149565-31762-1-git-send-email-josef@redhat.com>
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

Testt 245 only checks to see if the rename returned EEXIST, but according to the
rename(2) manpage, ENOTEMPTY is also a valid result, which is in fact what Btrfs
returns.  So just filter the output for ENOTEMPTY so that either EEXIST or
ENOTEMPTY will pass the test.  It's not pretty I know, but I couldn't really
figure out a good way to get an either/or output to compare.  With this fix
Btrfs now passes 245.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 245 |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)
 mode change 100644 => 100755 245

diff --git a/245 b/245
old mode 100644
new mode 100755
index 9c1cd3a..02b3173
--- a/245
+++ b/245
@@ -48,6 +48,14 @@ _cleanup()
 	rm -rf $dir
 }
 
+# According to the rename(2) manpage you can get either EEXIST or ENOTEMPTY as an
+# error for trying to rename a non-empty directory, so just catch the error for
+# ENOTMEMPTY and replace it with the EEXIST output so that either result passes
+_filter_directory_not_empty()
+{
+	sed -e "s,Directory not empty,File exists,g"
+}
+ 
 trap "_cleanup ; exit \$status" 0 1 2 3 15
 
 
@@ -59,7 +67,7 @@ touch $dir/aa/1
 mkdir $dir/ab/aa
 touch $dir/ab/aa/2
 
-mv $dir/ab/aa/ $dir 2>&1 | _filter_test_dir
+mv $dir/ab/aa/ $dir 2>&1 | _filter_test_dir | _filter_directory_not_empty
 
 status=0
 exit $status
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
