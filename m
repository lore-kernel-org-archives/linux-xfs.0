Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E1B87F37
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 17:46:19 -0500 (CDT)
Date: Wed, 19 Jun 2013 17:46:15 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [RFC PATCH 2/3] xfstests: use an intermediate check.log file
Message-ID: <20130619224615.GV20932@sgi.com>
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

Use an intermediate check.log file for each test run so that it can be
uploaded to a central location by a subsequent patch in this series.
The intermediate file is appended to $RESULTS_DIR/check.log a the end of
each run.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 check |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

Index: xfstests.new2/check
===================================================================
--- xfstests.new2.orig/check
+++ xfstests.new2/check
@@ -314,11 +314,11 @@ END	{ if (NR > 0) {
 	    mv $tmp.out $check.time
 	fi
 
-	echo "" >>$check.log
-	date >>$check.log
-	cat /tmp/check.desc >>$check.log
-	echo $list | fmt | sed -e 's/^/    /' -e "s;$SRC_DIR/;;g" >>$check.log
-	$interrupt && echo "Interrupted!" >>$check.log
+	echo "" >>/tmp/check.log
+	date >>/tmp/check.log
+	cat /tmp/check.desc >>/tmp/check.log
+	echo $list | fmt | sed -e 's/^/    /' -e "s;$SRC_DIR/;;g" >>/tmp/check.log
+	$interrupt && echo "Interrupted!" >>/tmp/check.log
         
         if [ ! -z "$n_try" -a $n_try != 0 ]
 	then
@@ -328,20 +328,22 @@ END	{ if (NR > 0) {
 	if [ ! -z "$notrun" ]
 	then
 	    echo "Not run:$notrun"
-	    echo "Not run:$notrun" >>$check.log
+	    echo "Not run:$notrun" >>/tmp/check.log
 	fi
 
         if [ ! -z "$n_bad" -a $n_bad != 0 ]
 	then
 	    echo "Failures:$bad"
 	    echo "Failed $n_bad of $n_try tests"
-	    echo "Failures:$bad" | fmt >>$check.log
-	    echo "Failed $n_bad of $n_try tests" >>$check.log
+	    echo "Failures:$bad" | fmt >>/tmp/check.log
+	    echo "Failed $n_bad of $n_try tests" >>/tmp/check.log
 	else
 	    echo "Passed all $n_try tests"
-	    echo "Passed all $n_try tests" >>$check.log
+	    echo "Passed all $n_try tests" >>/tmp/check.log
 	fi
 	needwrap=false
+        cat /tmp/check.log >> $check.log
+	rm -f /tmp/check.log
     fi
 
     rm -f /tmp/*.rawout /tmp/*.out /tmp/*.err /tmp/*.time

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
