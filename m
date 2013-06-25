Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 63A1C7F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 14:34:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E50CAAC00A
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 12:34:29 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id DXzW1OW56mQfUC5B (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Jun 2013 12:34:28 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r5PJS8N1019670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 19:28:09 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r5PJYQDB016539
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 19:34:27 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r5PJYPeP014439 for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 19:34:26 GMT
Date: Tue, 25 Jun 2013 15:34:23 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH] xfstests: fix README, FSTYP options
Message-ID: <20130625153423.513e4074@oracle.com>
Mime-Version: 1.0
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
To: xfs@oss.sgi.com

commit cbcc88fb changed test selection to use shell globs, so fixup the
examples given in the README file.

add options for FSTYPs supported by _scratch_mkfs().

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 README | 5 +++--
 check  | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/README b/README
index d4d4f31..af4e4a5 100644
--- a/README
+++ b/README
@@ -81,9 +81,10 @@ Running tests:
 
     - cd xfstests
     - By default the tests suite will run xfs tests:
-    - ./check 001 002 003 ... or you can explicitly run a filesystem: 
+    - ./check '*/001' '*/002' '*/003'
+    - ./check '*/06?'
+    - You can explicitly specify a filesystem (btrfs, ext4, nfs, udf, xfs): 
       ./check -xfs [test(s)]
-    - You can run a range of tests: ./check 067-078
     - Groups of tests maybe ran by: ./check -g [group(s)]
       See the 'group' file for details on groups
     - for udf tests: ./check -udf [test(s)]
diff --git a/check b/check
index ff8fbcf..a677727 100755
--- a/check
+++ b/check
@@ -159,9 +159,11 @@ while [ $# -gt 0 ]; do
 	case "$1" in
 	-\? | -h | --help) usage ;;
 
+	-btrfs)	FSTYP=btrfs ;;
+	-ext4)	FSTYP=ext4 ;;
+	-nfs)	FSTYP=nfs ;;
 	-udf)	FSTYP=udf ;;
 	-xfs)	FSTYP=xfs ;;
-	-nfs)	FSTYP=nfs ;;
 
 	-g)	group=$2 ; shift ;
 		group_list=$(get_group_list $group)
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
