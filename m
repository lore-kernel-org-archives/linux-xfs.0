Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9SdVS006898 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:40 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ztjNlYdT8Cb0FvHf for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:38 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKMr-0001BG-GO
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:25 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMr-0005W5-CI
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/18] xfstests: make exclude groups aware of multiple
	subdirectories
Date: Thu, 26 Jul 2012 19:28:09 +1000
Message-Id: <1343294892-20991-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1343294892-20991-1-git-send-email-david@fromorbit.com>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now that there are no tests in the top level directory, the exlude
group functionality no longer works (-x group) as it cannot find
tests to build an initial list of tests. Rework the the exclude
group implementation to operate correctly on the new test locations.

Also, swtich from sed to grep for exclusion because sed has problems
distnguishing the '/' in path names from regex control...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 check |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/check b/check
index b65b060..44659bb 100755
--- a/check
+++ b/check
@@ -90,6 +90,19 @@ get_group_list()
 	echo $grpl
 }
 
+# find all tests, excluding files that are test metadata such as group files.
+# This assumes that tests are defined purely by alphanumeric filenames with no
+# ".xyz" extensions in the name.
+get_all_tests()
+{
+	touch $tmp.list
+	for d in $SRC_GROUPS $FSTYP; do
+		ls $SRC_DIR/$d/* | \
+			grep -v "\..*" | \
+			grep -v group >> $tmp.list 2>/dev/null
+	done
+}
+
 _wallclock()
 {
     date "+%H %M %S" | $AWK_PROG '{ print $1*3600 + $2*60 + $3 }'
@@ -104,7 +117,7 @@ _timestamp()
 # start the initialisation work now
 _setenvironment
 
-rm -f $tmp.list $tmp.tmp $tmp.sed $here/$iam.out
+rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out
 
 # Autodetect fs type based on what's on $TEST_DEV
 if [ "$HOSTOS" == "Linux" ]; then
@@ -144,27 +157,33 @@ while [ $# -gt 0 ]; do
 		;;
 
 	-x)	xgroup=$2 ; shift ;
-		[ ! -s $tmp.list ] &&  ls $SUPPORTED_TESTS >$tmp.list 2>/dev/null
+
+		# Note: behaviour is dependent on command line ordering of
+		# -g and -x parameters. If there are no preceding -g commands,
+		# this works on all tests, otherwise just the tests specified by
+		# the early -g inclusions.
+		[ ! -s $tmp.list ] && get_all_tests
+
 		group_list=$(get_group_list $xgroup)
 		if [ -z "$group_list" ]; then
 		    echo "Group \"$xgroup\" is empty or not defined?"
 		    exit 1
 		fi
 
-		rm -f $tmp.sed
+		rm -f $tmp.grep
 		numsed=0
 		for t in $group_list
 		do
 		    if [ $numsed -gt 100 ]; then
-			sed -f $tmp.sed <$tmp.list >$tmp.tmp
+			grep -v -f $tmp.grep <$tmp.list >$tmp.tmp
 			mv $tmp.tmp $tmp.list
 			numsed=0
-			rm -f $tmp.sed
+			rm -f $tmp.grep
 		    fi
-		    echo "/^$t\$/d" >>$tmp.sed
+		    echo "^$t\$" >>$tmp.grep
 		    numsed=`expr $numsed + 1`
 		done
-		sed -f $tmp.sed <$tmp.list >$tmp.tmp
+		grep -v -f $tmp.grep <$tmp.list >$tmp.tmp
 		mv $tmp.tmp $tmp.list
 		;;
 
@@ -233,7 +252,7 @@ fi
 
 # sort the list of tests into numeric order
 list=`sort -n $tmp.list`
-rm -f $tmp.list $tmp.tmp $tmp.sed
+rm -f $tmp.list $tmp.tmp $tmp.grep
 
 if $randomize
 then
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
