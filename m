Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 101FC7F73
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 03:35:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D598A304043
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 01:35:03 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 1GQgctuFpytHInDf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Nov 2013 01:35:02 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAB9Z16L018984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 09:35:02 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAB9Z0Dr019482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 09:35:01 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAB9Z0em026689 for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 09:35:00 GMT
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Subject: [PATCH] xfstests: generic/273: use src/feature -o
Date: Mon, 11 Nov 2013 13:34:54 +0400
Message-Id: <1384162494-17002-1-git-send-email-stanislav.kholmanskikh@oracle.com>
In-Reply-To: <20131024010929.GR2797@dastard>
References: <20131024010929.GR2797@dastard>
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

Due to partially committed series (fd080d64b6e9677cb9d0a15dc7e308b6ca0e273f)
generic/273 test uses '_no_of_online_cpus' function which is not defined.

Now it's safe to switch it to 'src/feature -o'.

Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
---
 tests/generic/273 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tests/generic/273 b/tests/generic/273
index c028438..ab04dfa 100755
--- a/tests/generic/273
+++ b/tests/generic/273
@@ -47,7 +47,7 @@ count=2
 
 _threads_set()
 {
-	_cpu_num=`_no_of_online_cpus`
+	_cpu_num=`$here/src/feature -o`
 	threads=$(($_cpu_num * 50))
 	if [ $threads -gt 200 ]
 	then
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
