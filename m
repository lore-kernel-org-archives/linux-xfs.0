Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0LLa8K9094174 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 15:36:08 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 121A68F80EB
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 13:37:07 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [RFC] xfstests: define an INTENSITY level for testing
Date: Thu, 21 Jan 2010 15:36:07 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A69B2@cf--amer001e--3.americas.sgi.com>
From: "Alex Elder" <aelder@sgi.com>
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

I've often felt it would be nice if testing could be
done to a specified level of intensity.  That way,
for example, I could perform a full suite of tests
but have them just do very basic stuff, so that I
get coverage but without having to wait as long as
is required for a hard-core test.  Similarly, before
a release I'd like to run tests exhaustively, to
make sure things get really exercised.

Right now there is a "quick" group defined for xfstests,
but what I'm talking about is more of a parameter applied
to all tests so that certain functions could be lightly
tested that might not otherwise be covered by one of the
"quick" ones.  We might even be able to get rid of the
"quick" group.  And an inherently long-running test
might make itself not run if the intensity level was
not high enough.

So I propse we defined a global, set in common.rc, which
defines an integer 0 < INTENSITY <= 100, which would
define how hard each test should push.  INTENSITY of
100, would cause all tests would do their most exhaustive
and/or demanding exercises.  INTENSITY of 1 would do very
superficial testing.  Default might be 50.

Tests can simply ignore the INTENSITY value, and initially
that will be the case for most tests.  It may not even make
sense for a given test to have its activity scaled by this
setting.  Once we define it though, tests can be adapted
to make use of it where possible.

Below is a patch that shows how such feature might be
used for tests 104 and 109.

					-Alex

---
 104    |    2 +-
 109    |    2 +-
 common |   37 +++++++++++++++++++++++++++++++++++--
 3 files changed, 37 insertions(+), 4 deletions(-)

Index: b/104
===================================================================
--- a/104
+++ b/104
@@ -58,7 +58,7 @@ _fill_scratch()
 _stress_scratch()
 {
 	procs=3
-	nops=1000
+	nops=$(expr 20 \* "${INTENSITY}")	# Default 1000
 	# -w ensures that the only ops are ones which cause write I/O
 	$FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n $nops $FSSTRESS_AVOID > /dev/null &
 }
Index: b/109
===================================================================
--- a/109
+++ b/109
@@ -96,7 +96,7 @@ umount $SCRATCH_DEV 2>/dev/null
 _scratch_mount
 
 # see if faststart is possible (and requested)
-files=2000
+files=$(expr 40 \* "${INTENSITY}")	# Default 2000
 faststart=""
 if [ -n "$FASTSTART" -a -f $SCRATCH_MNT/f0 ]; then
 	faststart="-N"	# causes us to skip the mkfs step
Index: b/common
===================================================================
--- a/common
+++ b/common
@@ -42,6 +42,8 @@ sortme=false
 expunge=true
 have_test_arg=false
 randomize=false
+iflag=false
+export INTENSITY=50
 rm -f $tmp.list $tmp.tmp $tmp.sed
 
 # Autodetect fs type based on what's on $TEST_DEV
@@ -54,8 +56,26 @@ fi
 
 for r
 do
-
-    if $group
+    if $iflag
+    then
+	# make sure next arg is a number
+    	if [ $(expr match "$r" '[0-9]\+' = length "$r") = 1 ]
+	then
+	    # and it is in range
+	    if [ "$r" -gt 0 -a "$r" -le 100 ]
+	    then
+	    	INTENSITY=$r
+	    else
+		echo "Intensity \"$r\" is out of range (must be 1-100)"
+		exit 1
+	    fi
+	else
+	    echo "Intensity \"$r\" is not a (valid) number"
+	    exit 1
+	fi
+	iflag=false
+	continue
+    elif $group
     then
 	# arg after -g
 	group_list=`sed -n <group -e 's/$/ /' -e "/^[0-9][0-9][0-9].* $r /"'{
@@ -132,6 +152,7 @@ check options
     -q			quick [deprecated]
     -T			output timestamps
     -r 			randomize test order
+    -i <intensity>	set intensity level (1-100, default 50)
     
 testlist options
     -g group[,group...]	include tests from these groups
@@ -162,6 +183,12 @@ testlist options
 	    xpand=false
 	    ;;
 
+	-i)	# -i intensity ... set testing intensity
+	    shift
+	    iflag=true
+	    xpand=false
+	    ;;
+
 	-l)	# line mode for diff, was default before
 	    diff="diff"
 	    xpand=false
@@ -268,6 +295,12 @@ BEGIN	{ for (t='$start'; t<='$end'; t++)
 
 done
 
+if $iflag
+then
+    echo "No intensity value specified with -i"
+    exit 1
+fi
+
 if [ -s $tmp.list ]
 then
     # found some valid test numbers ... this is good

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
