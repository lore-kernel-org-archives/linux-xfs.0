Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EE1AB7F87
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 09:33:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD6AC304062
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 07:33:03 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Tr2vclOiprrxqDgQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Jan 2014 07:33:02 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s0MFX1wB025574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 15:33:02 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s0MFX09u006218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 15:33:01 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id
	s0MFX0fF015065 for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 15:33:00 GMT
From: Koen De Wit <koen.de.wit@oracle.com>
Subject: [PATCH] xfstests: define $seqres in btrfs/026-029
Date: Wed, 22 Jan 2014 16:32:18 +0100
Message-Id: <1390404738-387-1-git-send-email-koen.de.wit@oracle.com>
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
Cc: Koen De Wit <koen.de.wit@oracle.com>

I forgot to define $seqres in btrfs/026-029. As a result, a file named
.full was created in the current working directory. Fix it.
---
 tests/btrfs/026 |    1 +
 tests/btrfs/027 |    1 +
 tests/btrfs/028 |    1 +
 tests/btrfs/029 |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tests/btrfs/026 b/tests/btrfs/026
index bf6f528..6c54590 100644
--- a/tests/btrfs/026
+++ b/tests/btrfs/026
@@ -26,6 +26,7 @@
 #
 
 seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
diff --git a/tests/btrfs/027 b/tests/btrfs/027
index d76bb0f..b2dff1c 100644
--- a/tests/btrfs/027
+++ b/tests/btrfs/027
@@ -26,6 +26,7 @@
 #-----------------------------------------------------------------------
 
 seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
diff --git a/tests/btrfs/028 b/tests/btrfs/028
index 06d2faf..f17f102 100644
--- a/tests/btrfs/028
+++ b/tests/btrfs/028
@@ -24,6 +24,7 @@
 #-----------------------------------------------------------------------
 
 seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
diff --git a/tests/btrfs/029 b/tests/btrfs/029
index 1fd2a93..b93b6df 100644
--- a/tests/btrfs/029
+++ b/tests/btrfs/029
@@ -29,6 +29,7 @@
 #-----------------------------------------------------------------------
 
 seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
