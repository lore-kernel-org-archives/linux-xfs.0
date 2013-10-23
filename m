Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 976497F37
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 06:58:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 872D18F8054
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 04:58:59 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id t0WxTbquxEibndze (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 23 Oct 2013 04:58:58 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r9NBwvfs016602
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 11:58:58 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9NBwueL013382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 11:58:57 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9NBwuUx011842 for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 11:58:56 GMT
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Subject: [PATCH 2/2] xfstests: generic/273: do not use /proc/cpuinfo
Date: Wed, 23 Oct 2013 15:58:44 +0400
Message-Id: <1382529524-2184-3-git-send-email-stanislav.kholmanskikh@oracle.com>
In-Reply-To: <1382529524-2184-1-git-send-email-stanislav.kholmanskikh@oracle.com>
References: <1382529524-2184-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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

The content of /proc/cpuinfo file is platform-dependent.
So we can not use it reliably to check a number of available cpus.
It would be better to use sysfs interface, as _no_of_online_cpus() does.

Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
---
 tests/generic/273 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tests/generic/273 b/tests/generic/273
index d149808..c028438 100755
--- a/tests/generic/273
+++ b/tests/generic/273
@@ -47,7 +47,7 @@ count=2
 
 _threads_set()
 {
-	_cpu_num=`cat /proc/cpuinfo | grep "processor" | wc -l`
+	_cpu_num=`_no_of_online_cpus`
 	threads=$(($_cpu_num * 50))
 	if [ $threads -gt 200 ]
 	then
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
