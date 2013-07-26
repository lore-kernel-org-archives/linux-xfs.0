Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5121D29E11
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 10:45:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D06C6AC003
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 08:45:36 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id SYp8RdpON8w8fqoB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 08:45:35 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id E9B1B7C0427
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 09:45:34 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: generic/314 filter out total from ls -l output
Date: Fri, 26 Jul 2013 11:45:32 -0400
Message-ID: <1374853532-19253-1-git-send-email-jbacik@fusionio.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

ls -l will show the nblocks for the directory, and this made it into the golden
output for 314.  The problem is nblocks is 0 for btrfs directories because we're
awesome, which makes us fail this test.  So filter out the "total blah" line of
ls -l so btrfs can pass this test too.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/generic/314     |    2 +-
 tests/generic/314.out |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tests/generic/314 b/tests/generic/314
index 2d34ea8..0dd98a3 100644
--- a/tests/generic/314
+++ b/tests/generic/314
@@ -62,7 +62,7 @@ su $qa_user -c "setfacl -m u:$qa_user:rwx,d:u:$qa_user:rwx $TEST_DIR/$seq-dir"
 su $qa_user -c "mkdir $TEST_DIR/$seq-dir/subdir2"
 
 # Both subdirs should have inherited sgid
-_ls_l $TEST_DIR/$seq-dir/ | _filter_test_dir | awk '{print $1,$NF}'
+_ls_l $TEST_DIR/$seq-dir/ | grep -v total | _filter_test_dir | awk '{print $1,$NF}'
 
 status=0
 exit
diff --git a/tests/generic/314.out b/tests/generic/314.out
index 180be80..b2db82b 100644
--- a/tests/generic/314.out
+++ b/tests/generic/314.out
@@ -1,4 +1,3 @@
 QA output created by 314
-total 4
 drwxr-sr-x subdir
 drwxrwsr-x+ subdir2
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
