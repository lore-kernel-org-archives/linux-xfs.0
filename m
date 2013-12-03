Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C51C29E10
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 05:59:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE6F08F8068
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 03:59:29 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id GgBEgNf3VR1zunhE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 03:59:28 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rB3BxRMu032014
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 11:59:28 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB3BxQB7001800
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 11:59:26 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB3BxPkm017152 for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 11:59:26 GMT
Message-ID: <529DC799.1080709@oracle.com>
Date: Tue, 03 Dec 2013 19:59:21 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 1/4] xfstests: common/rc, introduce two pre-checkup routines
	for xfs crc specified testing
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

Introduce two pre-checkup routines _require_xfs_mkfs_crc as well
as _require_xfs_crc to verify if mkfs.xfs and kernel are have crc
feature or not.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 common/rc | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/common/rc b/common/rc
index 5f61d57..82b58f2 100644
--- a/common/rc
+++ b/common/rc
@@ -1113,6 +1113,23 @@ _require_projid32bit()
 	   || _notrun "mkfs.xfs doesn't have projid32bit feature"
 }
 
+# this test requires the crc feature to be available in mkfs.xfs
+#
+_require_xfs_mkfs_crc()
+{
+	_scratch_mkfs_xfs -f -m crc=1 >/dev/null 2>&1 \
+	   || _notrun "mkfs.xfs doesn't have crc feature"
+}
+
+# this test requires the xfs kernel support crc feature
+#
+_require_xfs_crc()
+{
+	_scratch_mount >/dev/null 2>&1 \
+	   || _notrun "Kernel doesn't support crc feature"
+	umount $SCRATCH_MNT
+}
+
 # this test requires that external log/realtime devices are not in use
 #
 _require_nonexternal()
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
