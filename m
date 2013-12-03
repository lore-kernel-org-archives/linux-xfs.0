Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4047C29DF9
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 05:59:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1FEDB304075
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 03:59:43 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id OVg1jYsoZgGFvwwK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 03:59:42 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rB3Bxe00032240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 11:59:41 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB3BxewD002569
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 11:59:40 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB3BxeJD017891 for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 11:59:40 GMT
Message-ID: <529DC7A7.1050703@oracle.com>
Date: Tue, 03 Dec 2013 19:59:35 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 2/4] xfstests: refactor xfs/299 for crc feature pre-checkup
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Refactor xfs/299 to make use of those two crc related pre-checkup
routines, and remove the super block number from the golden output
file as it does not make sense IMO.  Also, filter out *EXPERIMENTAL*
string from mkfs.xfs output as those contents would be removed once
crc feature becomes stable.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 tests/xfs/299     | 14 ++++----------
 tests/xfs/299.out |  1 -
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/tests/xfs/299 b/tests/xfs/299
index d5e8c5e..e374131 100755
--- a/tests/xfs/299
+++ b/tests/xfs/299
@@ -54,6 +54,8 @@ chmod a+rwx $seqres.full	# arbitrary users will write here
 
 _require_scratch
 _require_xfs_quota
+_require_xfs_mkfs_crc
+_require_xfs_crc
 
 bsoft=100
 bhard=500
@@ -193,19 +195,11 @@ _exercise()
 
 }
 
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs_xfs -m crc=1 2>/dev/null | _filter_mkfs 2>$tmp.mkfs
 cat $tmp.mkfs >>$seqres.full
 # keep the blocksize and data size for dd later
 . $tmp.mkfs
 
-sb_ver=`$XFS_DB_PROG -r -c version $SCRATCH_DEV | awk -F= '{print $2}' | awk -F, '{print $1}' |cut -c3-`
-echo $sb_ver
-
-if [ $sb_ver -lt 5 ]
-then
-	_notrun "Can't run with older versions of superblock"
-fi
-
 cat >$tmp.projects <<EOF
 1:$SCRATCH_MNT
 EOF
@@ -228,7 +222,7 @@ echo "*** unmount"
 umount $SCRATCH_MNT
 
 
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs_xfs -m crc=1 2>/dev/null | _filter_mkfs 2>$tmp.mkfs
 cat $tmp.mkfs >>$seqres.full
 # keep the blocksize and data size for dd later
 . $tmp.mkfs
diff --git a/tests/xfs/299.out b/tests/xfs/299.out
index b2699b4..4185c98 100644
--- a/tests/xfs/299.out
+++ b/tests/xfs/299.out
@@ -5,7 +5,6 @@ data     = bsize=XXX blocks=XXX, imaxpct=PCT
 naming   =VERN bsize=XXX
 log      =LDEV bsize=XXX blocks=XXX
 realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-5
 *** user, group, and project
 
 *** report no quota settings
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
