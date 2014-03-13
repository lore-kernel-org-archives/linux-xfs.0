Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 625417F67
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 19:39:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 636B88F80A6
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 17:39:39 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 1RyR1o3tnxChvatI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Mar 2014 17:39:37 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s2D0dadD019564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 00:39:37 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s2D0dZat018715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 00:39:36 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s2D0dZmR019897 for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 00:39:35 GMT
Message-ID: <5320FE44.8050000@oracle.com>
Date: Thu, 13 Mar 2014 08:39:32 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v3] xfstests: shared/051: add filter to match the golden output
	for large acls
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

On old kernel we return EINVAL if hit the limits of maximum number of
ACLs but return E2BIG on new kernel, which cause the test failes on new
kernel as the output is mismatch to the goldens. This patch fix it by
updating the golden output with the new error message and replacing the
old error message with it via a filter.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---

V3->V2: filter out the old error message to the new and update golden output to match it
V2->V1: filter out the new error message to the old

 tests/shared/051     | 10 +++++++++-
 tests/shared/051.out |  2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tests/shared/051 b/tests/shared/051
index e957f86..934f353 100755
--- a/tests/shared/051
+++ b/tests/shared/051
@@ -318,6 +318,14 @@ chacl m:user1:rwx file1
 chacl a::rwx file1
 set +x
 
+# we return E2BIG if hit the max acl limits on new kernel, but EINVAL
+# on old kernel. So we need to filter out the error message in order
+# to make the updated golden output works for both old and new kernels.
+_filter_largeacl()
+{
+	sed -e "s/Invalid argument/Argument list too long/"
+}
+
 #-------------------------------------------------------
 
 echo ""
@@ -342,7 +350,7 @@ chacl $acl2 largeaclfile
 getfacl --numeric largeaclfile | _filter_aces
 
 echo "1 above xfs acl max"
-chacl $acl3 largeaclfile
+chacl $acl3 largeaclfile 2>&1 | _filter_largeacl
 getfacl --numeric largeaclfile | _filter_aces
 
 echo "use 16 aces"
diff --git a/tests/shared/051.out b/tests/shared/051.out
index a871082..354ec6a 100644
--- a/tests/shared/051.out
+++ b/tests/shared/051.out
@@ -280,7 +280,7 @@ mask::rwx
 other::rwx
 
 1 above xfs acl max
-chacl: cannot set access acl on "largeaclfile": Invalid argument
+chacl: cannot set access acl on "largeaclfile": Argument list too long
 # file: largeaclfile
 # owner: 0
 # group: 0
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
