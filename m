Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 080777F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 12:56:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D6C198F8052
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 10:56:40 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id HBksV4jCYktdEdCC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 10:56:40 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r9OHucrH005608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 17:56:39 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9OHucGm011055
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 17:56:38 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9OHucmB011040 for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 17:56:38 GMT
From: Guangyu Sun <guangyu.sun@oracle.com>
Subject: [PATCH] xfstest generic/280: wait for setquota to finish before umount
Date: Thu, 24 Oct 2013 10:56:21 -0700
Message-Id: <1382637381-4847-1-git-send-email-guangyu.sun@oracle.com>
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

While running xfstest 280, we occasionally got such error:

  setquota: Cannot set quota for user 0 from kernel on
  /dev/mapper/xfstests-disk1: No such device
  setquota: Cannot write quota for 0 on /dev/mapper/xfstests-disk1: No such
  device

setquota calls syscall quotactl, and the kernel will wait for the filesystem
to unfreeze and then performs command. Then kernel will double check if the
device is still mounted. If not, an ENODEV will be thrown.

While in the testcase, unfreeze and umount might be so close that the device
got umounted before quotactl is performed.

Reported-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>
---
 tests/generic/280 |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/generic/280 b/tests/generic/280
index 5491a6b..815a2c5 100755
--- a/tests/generic/280
+++ b/tests/generic/280
@@ -63,6 +63,7 @@ xfs_freeze -f $SCRATCH_MNT
 setquota -u root 1 2 3 4 $SCRATCH_MNT &
 sleep 1
 xfs_freeze -u $SCRATCH_MNT
+sleep 1
 umount $SCRATCH_DEV
 
 # Failure comes in the form of a deadlock.
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
