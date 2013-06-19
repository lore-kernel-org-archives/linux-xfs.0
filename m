Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E17247F3F
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 17:49:20 -0500 (CDT)
Date: Wed, 19 Jun 2013 17:49:16 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [RFC PATCH 3/3] xfstests: upload test results
Message-ID: <20130619224916.GW20932@sgi.com>
References: <1371596399.22504.38.camel@chandra-dt.ibm.com>
	<20130618233426.GD29338@dastard>
	<1371675639.22504.63.camel@chandra-dt.ibm.com>
	<20130619223750.GT20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130619223750.GT20932@sgi.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

Set the ARCHIVE_URL environment variable to upload test results to a
central location:

export ARCHIVE_URL=ftp://anonymous:joe_at_xyz.com@ftp.xyz.com/xfstests/results

---
 check     |   14 ++++++++++++++
 common.rc |   24 ++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

Index: xfstests/check
===================================================================
--- xfstests.orig/check
+++ xfstests/check
@@ -28,6 +28,7 @@ n_bad=0
 bad=""
 notrun=""
 interrupt=true
+start_time=`date "+%s"`
 diff="diff -u"
 showme=false
 have_test_arg=false
@@ -312,6 +313,7 @@ END	{ if (NR > 0) {
 	}' \
 	    | sort -n >$tmp.out
 	    mv $tmp.out $check.time
+	    _archive $check.time $start_time
 	fi
 
 	echo "" >>/tmp/check.log
@@ -343,6 +345,7 @@ END	{ if (NR > 0) {
 	fi
 	needwrap=false
         cat /tmp/check.log >> $check.log
+	_archive /tmp/check.log $start_time
 	rm -f /tmp/check.log
     fi
 
@@ -368,6 +371,7 @@ rm -f $check.full
 
 _full_source_details > /tmp/check.desc
 cat /tmp/check.desc
+_archive /tmp/check.desc $start_time
 
 # print out our test configuration
 echo "FSTYP         -- `_full_fstyp_details`"
@@ -453,6 +457,8 @@ do
 	rm -f core $seqres.notrun
 
 	start=`_wallclock`
+	echo "$seq $start" > $tmp.start
+	_archive $tmp.start $start_time
 	$timestamp && echo -n "	["`date "+%T"`"]"
 	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
 	$LOGGER_PROG "run xfstest $seqnum"
@@ -460,6 +466,8 @@ do
 	sts=$?
 	$timestamp && _timestamp
 	stop=`_wallclock`
+	echo "$seq $stop" > $tmp.stop
+	_archive $tmp.stop $start_time
 
 	_fix_malloc <$tmp.rawout >$tmp.out
 	rm -f $tmp.rawout
@@ -468,6 +476,7 @@ do
 	then
 	    echo -n " [dumped core]"
 	    mv core $RESULT_BASE/$seqnum.core
+	    _archive $RESULT_BASE/$seqnum.core $start_time
 	    err=true
 	fi
 
@@ -476,6 +485,7 @@ do
 	    $timestamp || echo -n " [not run] "
 	    $timestamp && echo " [not run]" && echo -n "	$seqnum -- "
 	    cat $seqres.notrun
+            _archive $seqres.notrun $start_time
 	    notrun="$notrun $seqnum"
 	else
 	    if [ $sts -ne 0 ]
@@ -501,6 +511,8 @@ do
 		else
 		    echo " - output mismatch (see $seqres.out.bad)"
 		    mv $tmp.out $seqres.out.bad
+		    _archive $seqres.out $start_time
+		    _archive $seqres.out.bad $start_time
 		    $diff $seq.out $seqres.out.bad | {
 		        if test "$DIFF_LENGTH" -le 0; then
 				cat
@@ -515,7 +527,7 @@ do
 		fi
 	    fi
 	fi
-
+        rm -f $tmp.$seq.start $tmp.seq.stop
     fi
 
     # come here for each test, except when $showme is true
Index: xfstests/common/rc
===================================================================
--- xfstests.orig/common/rc
+++ xfstests/common/rc
@@ -1738,6 +1738,27 @@ _full_platform_details()
      echo "$os/$platform $host $kernel"
 }
 
+_archive()
+{
+    if [ -z "$ARCHIVE_URL" ]; then
+        return;
+    fi
+
+    file=$1
+    subdir=$2
+    args=$3
+
+    if [ ! -e $file ]; then
+        _fail "archive: $file does not exist"
+    fi
+
+    desc=$(cat /proc/version | awk '{print $3}')
+
+    url=$ARCHIVE_URL/`hostname -f`/$desc/$subdir
+    curl $args --ftp-create-dirs --silent --upload-file \
+         $file $url/`basename $file`
+}
+
 _full_source_details()
 {
     if [ -z $SRCDIRS ]; then
@@ -1775,6 +1796,7 @@ _full_source_details()
                 echo -e "\t\tmd5sum:\t\t$md5_checksum"
                 echo -e "\t\tX-Patchwork-Id:\t${patchworkid##* }"
                 echo -e "\t\tMessage-Id:\t${messageid##* }"
+                _archive $dir/patches/$p $start_time/$dir/patches
             done
         fi
     done

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
