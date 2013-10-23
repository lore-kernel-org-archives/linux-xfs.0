Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8B7EC7F37
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 06:58:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7BA863040AA
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 04:58:58 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id cJ0bMOGHD7qkT3aY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 23 Oct 2013 04:58:57 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r9NBwucv014010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 11:58:57 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9NBwtDr013332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 11:58:56 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9NBwtaJ011786 for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 11:58:55 GMT
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Subject: [PATCH 1/2] xfstests: implemented _no_of_online_cpus() function
Date: Wed, 23 Oct 2013 15:58:43 +0400
Message-Id: <1382529524-2184-2-git-send-email-stanislav.kholmanskikh@oracle.com>
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

Its purpose is to get a number of online cpus.

Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
---
 common/rc |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/common/rc b/common/rc
index 77e96c4..ff2f7fe 100644
--- a/common/rc
+++ b/common/rc
@@ -2145,6 +2145,25 @@ _scale_fsstress_args()
     echo $args
 }
 
+_no_of_online_cpus()
+{
+	count=0
+
+	for i in `cat /sys/devices/system/cpu/online | $SED_PROG 's/,/ /g'`; do
+		count=$(( $count + 1 ))
+
+		lnumber=`echo $i | cut -d '-' -f 1`
+		rnumber=`echo $i | cut -d '-' -f 2`
+
+		while [ $lnumber -lt $rnumber ]; do
+			lnumber=$(( $lnumber + 1 ))
+			count=$(( $count + 1 ))
+		done
+	done
+
+	echo $count
+}
+
 run_check()
 {
 	echo "# $@" >> $seqres.full 2>&1
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
