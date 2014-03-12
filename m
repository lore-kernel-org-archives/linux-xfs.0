Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A350F7F3F
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 21:03:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A61F530406A
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 19:03:13 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id F34FhOdrgRN5FqBc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Mar 2014 19:03:10 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s2C23849007587
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 02:03:09 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s2C2379w022588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 02:03:08 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s2C237EE002707 for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 02:03:07 GMT
Message-ID: <531FC057.70804@oracle.com>
Date: Wed, 12 Mar 2014 10:03:03 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfstests: shared/051: add filter to match the golden output
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
ACLs but return E2BIG on new kernel, which cause the current test fails
on new kernel as the output is mismatch to the goldens. In order to make
the current golden output works for both old and new kernels, this patch
filter the new error message out to match the olds.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
V2: make the filter as a local function as per Dave's comments

 tests/shared/051 | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tests/shared/051 b/tests/shared/051
index e957f86..adbe427 100755
--- a/tests/shared/051
+++ b/tests/shared/051
@@ -318,6 +318,14 @@ chacl m:user1:rwx file1
 chacl a::rwx file1
 set +x
 
+# we return E2BIG if hit the max acl limits on new kernel, but EINVAL
+# on old kernel. So we need to filter the error message out in order
+# to make the current golden output works for both old and new kernels.
+_filter_largeacl()
+{
+	sed -e "s/Argument list too long/Invalid argument/"
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
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
