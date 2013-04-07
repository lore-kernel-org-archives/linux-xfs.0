Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 02C767F5D
	for <xfs@oss.sgi.com>; Sun,  7 Apr 2013 05:39:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8C737AC001
	for <xfs@oss.sgi.com>; Sun,  7 Apr 2013 03:39:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3wd2Bs3lO33Il9Su for
	<xfs@oss.sgi.com>; Sun, 07 Apr 2013 03:39:21 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r37AdLsS020731
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 7 Apr 2013 06:39:21 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 3/3] xfstests generic 310: fix common file path and other
	cleanups
Date: Sun,  7 Apr 2013 18:39:07 +0800
Message-Id: <1365331147-15179-3-git-send-email-eguan@redhat.com>
In-Reply-To: <1365331147-15179-1-git-send-email-eguan@redhat.com>
References: <1365331147-15179-1-git-send-email-eguan@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eryu Guan <eguan@redhat.com>

1. add one space between # and test description
2. remove creator/owner info
3. fix common/rc and common/filter path so they can be sourced correctly
4. no need to remove $seq.full cause it's not used(or if verbose output
   is needed, $seqres.full should be used)

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/310 | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/tests/generic/310 b/tests/generic/310
index ef51422..35baa23 100644
--- a/tests/generic/310
+++ b/tests/generic/310
@@ -1,8 +1,8 @@
 #! /bin/bash
 # FS QA Test No. 310
 #
-#Check if there are two threads,one keeps calling read() or lseek(), and
-#the other calling readdir(), both on the same directory fd.
+# Check if there are two threads,one keeps calling read() or lseek(), and
+# the other calling readdir(), both on the same directory fd.
 #
 # Based on a testcase from Li Zefan <lizefan@huawei.com>.
 #
@@ -25,10 +25,9 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=zhaohongjiang@huawei.com
 
 seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 status=1	# failure is the default!
@@ -40,8 +39,8 @@ _cleanup()
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
-. ./common.rc
-. ./common.filter
+. ./common/rc
+. ./common/filter
 
 # real QA test starts here
 _supported_fs generic
@@ -71,6 +70,5 @@ _test_lseek
 
 # success, all done
 echo "*** done"
-rm -f $seq.full
 status=0
 exit
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
