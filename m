Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 23EE97F56
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 08:32:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 134F38F804B
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 06:32:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wyQREOC7Dsu8fqIL for
	<xfs@oss.sgi.com>; Fri, 28 Jun 2013 06:32:09 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5SDW8l2031189
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 09:32:09 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/3 v2] xfstests: Refactor code for obtaining test list
Date: Fri, 28 Jun 2013 15:31:59 +0200
Message-Id: <1372426320-19902-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1372426320-19902-1-git-send-email-lczerner@redhat.com>
References: <1372426320-19902-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

Put the code for obtaining the list of test into one place which makes
things more readable. It will also allow us to re-init the list in the
future if we need it.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 check | 97 ++++++++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 52 insertions(+), 45 deletions(-)

diff --git a/check b/check
index 71b179b..1fded37 100755
--- a/check
+++ b/check
@@ -154,45 +154,70 @@ _timestamp()
     echo -n " [$now]"
 }
 
-# Process command arguments first.
-while [ $# -gt 0 ]; do
-	case "$1" in
-	-\? | -h | --help) usage ;;
-
-	-udf)	FSTYP=udf ;;
-	-xfs)	FSTYP=xfs ;;
-	-nfs)	FSTYP=nfs ;;
+_prepare_test_list()
+{
+	# Tests specified on the command line
+	if [ -s $tmp.arglist ]; then
+		cat $tmp.arglist > $tmp.list
+	else
+		touch $tmp.list
+	fi
 
-	-g)	group=$2 ; shift ;
-		group_list=$(get_group_list $group)
-		if [ -z "$group_list" ]; then
+	# Specified groups to include
+	for group in $GROUP_LIST; do
+		list=$(get_group_list $group)
+		if [ -z "$list" ]; then
 		    echo "Group \"$group\" is empty or not defined?"
 		    exit 1
 		fi
 
-		[ ! -s $tmp.list ] && touch $tmp.list
-		for t in $group_list; do
+		for t in $list; do
 			grep -s "^$t\$" $tmp.list >/dev/null || \
 							echo "$t" >>$tmp.list
 		done
+	done
 
-		;;
-
-	-x)	xgroup=$2 ; shift ;
-
-		# Note: behaviour is dependent on command line ordering of
-		# -g and -x parameters. If there are no preceding -g commands,
-		# this works on all tests, otherwise just the tests specified by
-		# the early -g inclusions.
-		[ ! -s $tmp.list ] && get_all_tests
+	if [ ! $have_test_arg ] && [ -z "$GROUP_LIST" ]; then
+		# no test numbers, do everything
+		get_all_tests
+	fi
 
-		group_list=$(get_group_list $xgroup)
-		if [ -z "$group_list" ]; then
+	# Specified groups to exclude
+	for xgroup in $XGROUP_LIST; do
+		list=$(get_group_list $xgroup)
+		if [ -z "$list" ]; then
 		    echo "Group \"$xgroup\" is empty or not defined?"
 		    exit 1
 		fi
 
-		trim_test_list $group_list
+		trim_test_list $list
+	done
+
+	# sort the list of tests into numeric order
+	list=`sort -n $tmp.list | uniq`
+	rm -f $tmp.list $tmp.tmp $tmp.grep
+
+	if $randomize
+	then
+	    list=`echo $list | awk -f randomize.awk`
+	fi
+}
+
+# Process command arguments first.
+while [ $# -gt 0 ]; do
+	case "$1" in
+	-\? | -h | --help) usage ;;
+
+	-udf)	FSTYP=udf ;;
+	-xfs)	FSTYP=xfs ;;
+	-nfs)	FSTYP=nfs ;;
+
+	-g)	group=$2 ; shift ;
+		GROUP_LIST="$GROUP_LIST $group"
+		;;
+
+	-x)	xgroup=$2 ; shift ;
+		XGROUP_LIST="$XGROUP_LIST $xgroup"
 		;;
 
 	-X)	xfile=$2; shift ;
@@ -244,7 +269,7 @@ if $have_test_arg; then
 
 			if egrep "^$test_name" $group_file >/dev/null ; then
 				# in group file ... OK
-				echo $SRC_DIR/$1 >>$tmp.list
+				echo $SRC_DIR/$1 >>$tmp.arglist
 			else
 				# oops
 				echo "$1 - unknown test, ignored"
@@ -256,25 +281,7 @@ if $have_test_arg; then
 	done
 fi
 
-if [ -s $tmp.list ]; then
-    # found some valid test numbers ... this is good
-    :
-elif $have_test_arg; then
-	# had test numbers, but none in group file ... do nothing
-	touch $tmp.list
-else
-	# no test numbers, do everything
-	get_all_tests
-fi
-
-# sort the list of tests into numeric order
-list=`sort -n $tmp.list`
-rm -f $tmp.list $tmp.tmp $tmp.grep
-
-if $randomize
-then
-    list=`echo $list | awk -f randomize.awk`
-fi
+_prepare_test_list
 
 # we need common/rc
 if ! . ./common/rc
-- 
1.8.2.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
