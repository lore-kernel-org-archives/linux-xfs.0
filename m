Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D42FB7F59
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 09:04:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A128B304051
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 07:04:20 -0700 (PDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
	[209.85.212.173]) by cuda.sgi.com with ESMTP id
	0aXuIYfB6vLfCKjS (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 07:04:19 -0700 (PDT)
Received: by mail-wi0-f173.google.com with SMTP id ey16so615042wid.12
	for <xfs@oss.sgi.com>; Thu, 02 May 2013 07:04:17 -0700 (PDT)
From: ranto.boris@gmail.com
Subject: [PATCH 2/3] xfstests: Do not fail on non-existing tests/FSTYP
	directory
Date: Thu,  2 May 2013 16:03:58 +0200
Message-Id: <1367503439-12827-3-git-send-email-ranto.boris@gmail.com>
In-Reply-To: <1367503439-12827-1-git-send-email-ranto.boris@gmail.com>
References: <1367503439-12827-1-git-send-email-ranto.boris@gmail.com>
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
Cc: Boris Ranto <ranto.boris@gmail.com>

From: Boris Ranto <ranto.boris@gmail.com>

Currently, if a user runs ./check -n to get the list of tests to run on
a file system such as nfs or tmpfs, then the ./check script will fail
since there are no tests/nfs and tests/tmpfs subdirectories (and hence,
no group files and no specific tests for the directories). This patch
will conditionally add FSTYP to SRC_GROUPS and remove all further
additions of FSTYP to the variable.

Signed-off-by: Boris Ranto <ranto.boris@gmail.com>
---
 check |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/check b/check
index fc335ec..4af2dbd 100755
--- a/check
+++ b/check
@@ -64,7 +64,12 @@ fi
 export FSTYP
 
 SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
-SRC_GROUPS="generic shared"
+# Include FSTYP to SRC_GROUPS if a directory for it exists
+if [ -d $SRC_DIR/$d ]; then
+	SRC_GROUPS="generic shared $FSTYP"
+else
+	SRC_GROUPS="generic shared"
+fi
 export SRC_DIR="tests"
 export RESULT_BASE=${RESULT_BASE:="$here/results"}
 
@@ -97,7 +102,7 @@ get_group_list()
 {
 	grp=$1
 
-	for d in $SRC_GROUPS $FSTYP; do
+	for d in $SRC_GROUPS; do
 		l=$(sed -n < $SRC_DIR/$d/group \
 			-e 's/#.*//' \
 			-e 's/$/ /' \
@@ -113,7 +118,7 @@ get_group_list()
 get_all_tests()
 {
 	touch $tmp.list
-	for d in $SRC_GROUPS $FSTYP; do
+	for d in $SRC_GROUPS; do
 		ls $SRC_DIR/$d/* | \
 			grep -v "\..*" | \
 			grep -v group >> $tmp.list 2>/dev/null
@@ -198,7 +203,7 @@ while [ $# -gt 0 ]; do
 		;;
 
 	-X)	xfile=$2; shift ;
-		for d in $SRC_GROUPS $FSTYP; do
+		for d in $SRC_GROUPS; do
 			[ -f $SRC_DIR/$d/$xfile ] || continue
 			for f in `cat $SRC_DIR/$d/$xfile`; do
 				echo $d/$f >> $tmp.xlist
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
