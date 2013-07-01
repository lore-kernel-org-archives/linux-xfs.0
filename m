Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88A1B7F56
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 05:37:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 780F4304032
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 03:37:11 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id JHiODFeG9JhbAS7Z (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Jul 2013 03:37:10 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r61AUnba007196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 1 Jul 2013 10:30:50 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r61Ab8vG017479
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 1 Jul 2013 10:37:09 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r61Ab8gh017470 for <xfs@oss.sgi.com>; Mon, 1 Jul 2013 10:37:08 GMT
Message-ID: <51D15BDF.9000805@oracle.com>
Date: Mon, 01 Jul 2013 18:37:19 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: clean up remake related matters from README
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

Cleanup 'remake' related matters from the README file as the
remake utility has already been removed by:

commit 609d17c4eb911891fae3c0081c2cd1caa613c0de

	xfstests: remove remake script

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 README |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/README b/README
index d4d4f31..b264a07 100644
--- a/README
+++ b/README
@@ -203,9 +203,6 @@ Verified output:
     - variable directory contents
     - imprecise numbers, especially sizes and times
 
-    Use the "remake" script to recreate the verified output for one
-    or more tests.
-
 Pass/failure:
 
     The script "check" may be used to run one or more tests.
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
