Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o59EGWRt068446 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 09:16:32 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B0F70AC009
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 14:54:23 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.3/8.14.2) with ESMTP id o6ULsN6t008916
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 16:54:23 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.3/8.14.3/Submit) id o6ULsNdm008915
	for xfs@oss.sgi.com; Fri, 30 Jul 2010 16:54:23 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201007302154.o6ULsNdm008915@stout.americas.sgi.com>
Date: Fri, 30 Jul 2010 16:54:23 -0500
Subject: [PATCH] xfstests: have getfacl(1) report numeric id's
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This patch arranges for calls to getfacl(1) to be given the "-n"
flag, which requests that user and group id's be listed numerically
rather than using names.  The affected test output files are also
updated to indicate the effect of the change.

This eliminates some spurious output differences I was seeing, due
to the presence of NIS in my test environment.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 051     |   10 +++++-----
 051.out |   20 ++++++++++----------
 067     |    8 ++++----
 067.out |   16 ++++++++--------
 4 files changed, 27 insertions(+), 27 deletions(-)

Index: b/051
===================================================================
--- a/051
+++ b/051
@@ -343,23 +343,23 @@ acl5=`_create_n_aces 17` # 1 over A.G. l
 
 echo "1 below xfs acl max"
 chacl $acl1 largeaclfile
-getfacl largeaclfile | _filter_aces
+getfacl -n largeaclfile | _filter_aces
 
 echo "xfs acl max"
 chacl $acl2 largeaclfile
-getfacl largeaclfile | _filter_aces
+getfacl -n largeaclfile | _filter_aces
 
 echo "1 above xfs acl max"
 chacl $acl3 largeaclfile
-getfacl largeaclfile | _filter_aces
+getfacl -n largeaclfile | _filter_aces
 
 echo "use 16 aces"
 chacl $acl4 largeaclfile
-getfacl largeaclfile | _filter_aces
+getfacl -n largeaclfile | _filter_aces
 
 echo "use 17 aces"
 chacl $acl5 largeaclfile
-getfacl largeaclfile | _filter_aces
+getfacl -n largeaclfile | _filter_aces
 
 #-------------------------------------------------------
 
Index: b/051.out
===================================================================
--- a/051.out
+++ b/051.out
@@ -222,8 +222,8 @@ chacl: a::rwx - Invalid argument
 === Test out large ACLs  ===
 1 below xfs acl max
 # file: largeaclfile
-# owner: root
-# group: root
+# owner: 0
+# group: 0
 user::rwx
 user:1:rwx
 user:2:rwx
@@ -251,8 +251,8 @@ other::rwx
 
 xfs acl max
 # file: largeaclfile
-# owner: root
-# group: root
+# owner: 0
+# group: 0
 user::rwx
 user:1:rwx
 user:2:rwx
@@ -282,8 +282,8 @@ other::rwx
 1 above xfs acl max
 chacl: cannot set access acl on "largeaclfile": Invalid argument
 # file: largeaclfile
-# owner: root
-# group: root
+# owner: 0
+# group: 0
 user::rwx
 user:1:rwx
 user:2:rwx
@@ -312,8 +312,8 @@ other::rwx
 
 use 16 aces
 # file: largeaclfile
-# owner: root
-# group: root
+# owner: 0
+# group: 0
 user::rwx
 user:1:rwx
 user:2:rwx
@@ -333,8 +333,8 @@ other::rwx
 
 use 17 aces
 # file: largeaclfile
-# owner: root
-# group: root
+# owner: 0
+# group: 0
 user::rwx
 user:1:rwx
 user:2:rwx
Index: b/067
===================================================================
--- a/067
+++ b/067
@@ -72,19 +72,19 @@ acl21=`_create_n_aces 21`
 
 echo "try 20 aces for access acl"
 chacl $acl20 largeacldir
-getfacl largeacldir | _filter_aces
+getfacl -n largeacldir | _filter_aces
 
 echo "try 20 aces for default acl"
 chacl -d $acl20 largeacldir
-getfacl largeacldir | _filter_aces
+getfacl -n largeacldir | _filter_aces
 
 echo "try 21 aces for access acl"
 chacl $acl21 largeacldir
-getfacl largeacldir | _filter_aces
+getfacl -n largeacldir | _filter_aces
 
 echo "try 21 aces for default acl"
 chacl -d $acl21 largeacldir
-getfacl largeacldir | _filter_aces
+getfacl -n largeacldir | _filter_aces
 
 # success, all done
 status=0
Index: b/067.out
===================================================================
--- a/067.out
+++ b/067.out
@@ -3,8 +3,8 @@ QA output created by 067
 === Test out large ACLs  ===
 try 20 aces for access acl
 # file: largeacldir
-# owner: root
-# group: root
+# owner: 0
+# group: 0
 user::rwx
 user:1:rwx
 user:2:rwx
@@ -28,8 +28,8 @@ other::rwx
 
 try 20 aces for default acl
 # file: largeacldir
-# owner: root
-# group: root
+# owner: 0
+# group: 0
 user::rwx
 user:1:rwx
 user:2:rwx
@@ -73,8 +73,8 @@ default:other::rwx
 
 try 21 aces for access acl
 # file: largeacldir
-# owner: root
-# group: root
+# owner: 0
+# group: 0
 user::rwx
 user:1:rwx
 user:2:rwx
@@ -119,8 +119,8 @@ default:other::rwx
 
 try 21 aces for default acl
 # file: largeacldir
-# owner: root
-# group: root
+# owner: 0
+# group: 0
 user::rwx
 user:1:rwx
 user:2:rwx

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
