Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B64277F3F
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 04:23:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1420BAC004
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 02:23:11 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4rJrKGFvuGLpFBdO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 02:23:10 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAMAN9J0028011
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 10:23:10 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAMAN8pZ003263
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 10:23:09 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAMAN8u6003259 for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 10:23:08 GMT
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Subject: [PATCH] xfstests: generic/285: use the canonical device name
Date: Fri, 22 Nov 2013 14:23:03 +0400
Message-Id: <1385115783-9409-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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
Cc: vasily.isaenko@oracle.com

In order to access something under /sys/fs/ext4 we
need to be sure that the device name is canonical
(It matters, for example, if we use LVM).

Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
---
 tests/generic/285 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tests/generic/285 b/tests/generic/285
index 8078b1c..be31852 100755
--- a/tests/generic/285
+++ b/tests/generic/285
@@ -48,7 +48,7 @@ BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
 
 # Disable extent zeroing for ext4 as that change where holes are created
 if [ "$FSTYP" = "ext4" ]; then
-	DEV=`basename $TEST_DEV`
+	DEV=$(basename $(readlink -f $TEST_DEV))
 	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
 fi
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
