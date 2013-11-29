Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0B48529E12
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 01:03:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C44FD304043
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 23:03:36 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 6gOO4rhcEle1VvMX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 23:03:35 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAT73YU5007624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 07:03:35 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAT73XZn027845
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 07:03:34 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAT73XDD016156 for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 07:03:33 GMT
Message-ID: <52983C41.8000004@oracle.com>
Date: Fri, 29 Nov 2013 15:03:29 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 1/3] xfstests: introduce _require_xfs_crc_sb pre-checkup
	routine
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

Introduce _require_xfs_crc_sb to rc.  We can use it in pre-checkup
procedures to verify if the XFS test environment is configured with
CRC enabled or not for some particular test cases.

Introduce a new helper _xfs_sb_version to get XFS super block version
to make the test case more flexiable if possible. e.g, if that is
v5 super block, the tests behavior might be different to old v4 sb.

Refactor xfs/299 to use it.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 common/rc     | 19 +++++++++++++++++++
 tests/xfs/299 |  9 +--------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/common/rc b/common/rc
index f73414b..9f45279 100644
--- a/common/rc
+++ b/common/rc
@@ -1579,6 +1579,25 @@ _check_xfs_filesystem()
     return 0
 }
 
+# Get XFS super block version
+_xfs_sb_version()
+{
+	sb_version=`$XFS_DB_PROG -r -c version $SCRATCH_DEV | \
+		    awk -F= '{print $2}' | awk -F, '{print $1}' | \
+		    cut -c3-`
+	echo $sb_version
+}
+
+# This test requires XFS crc-enabled (v5) super block support
+_require_xfs_crc_sb()
+{
+	version=`_xfs_sb_version`
+	if [ $version -lt 5 ]
+	then
+		_notrun "Can't run with older versions of superblock"
+	fi
+}
+
 # Filter the knowen errors the UDF Verifier reports.
 _udf_test_known_error_filter()
 {
diff --git a/tests/xfs/299 b/tests/xfs/299
index d5e8c5e..3c42908 100755
--- a/tests/xfs/299
+++ b/tests/xfs/299
@@ -54,6 +54,7 @@ chmod a+rwx $seqres.full	# arbitrary users will write here
 
 _require_scratch
 _require_xfs_quota
+_require_xfs_crc_sb
 
 bsoft=100
 bhard=500
@@ -198,14 +199,6 @@ cat $tmp.mkfs >>$seqres.full
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
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
