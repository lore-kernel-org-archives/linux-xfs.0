Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 134857FA1
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 09:13:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0D750304067
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 07:13:30 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id LcUqCo1XHGKHaoWA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Jul 2014 07:13:26 -0700 (PDT)
Message-ID: <53C7DA01.7060703@oracle.com>
Date: Thu, 17 Jul 2014 22:13:21 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfs/007: add project quota Q_XQUOTARM test
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
To: fstests@vger.kernel.org
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Add test for project quota Q_XQUOTARM operations, update the
golden output file to match the new test output.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 tests/xfs/007     | 24 ++++++++++++++++++++++++
 tests/xfs/007.out |  9 +++++++++
 2 files changed, 33 insertions(+)

diff --git a/tests/xfs/007 b/tests/xfs/007
index 8cc5bf3..04c20e3 100755
--- a/tests/xfs/007
+++ b/tests/xfs/007
@@ -74,6 +74,30 @@ echo "*** Usage after quotarm ***"
 xfs_db -c "inode $UQUOTINO" -c "p core.nblocks" $SCRATCH_DEV
 xfs_db -c "inode $GQUOTINO" -c "p core.nblocks" $SCRATCH_DEV
 
+_qmount_option "uquota,pquota"
+_qmount
+
+echo "*** umount"
+umount $SCRATCH_MNT
+
+UQUOTINO=`xfs_db -c "sb 0" -c "p" $SCRATCH_DEV | grep uquotino | awk '{print $NF}'`
+PQUOTINO=`xfs_db -c "sb 0" -c "p" $SCRATCH_DEV | grep gquotino | awk '{print $NF}'`
+
+echo "*** Usage before quotarm ***"
+xfs_db -c "inode $UQUOTINO" -c "p core.nblocks" $SCRATCH_DEV
+xfs_db -c "inode $PQUOTINO" -c "p core.nblocks" $SCRATCH_DEV
+
+_qmount
+echo "*** turn off user and project quotas"
+xfs_quota -x -c 'off -up' $SCRATCH_MNT
+xfs_quota -x -c "remove -up" $SCRATCH_MNT
+echo "*** umount"
+umount $SCRATCH_MNT
+
+echo "*** Usage after quotarm ***"
+xfs_db -c "inode $UQUOTINO" -c "p core.nblocks" $SCRATCH_DEV
+xfs_db -c "inode $PQUOTINO" -c "p core.nblocks" $SCRATCH_DEV
+
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/007.out b/tests/xfs/007.out
index 0fc17ae..7c5bff5 100644
--- a/tests/xfs/007.out
+++ b/tests/xfs/007.out
@@ -8,3 +8,12 @@ core.nblocks = 1
 *** Usage after quotarm ***
 core.nblocks = 0
 core.nblocks = 0
+*** umount
+*** Usage before quotarm ***
+core.nblocks = 1
+core.nblocks = 1
+*** turn off user and project quotas
+*** umount
+*** Usage after quotarm ***
+core.nblocks = 0
+core.nblocks = 0
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
