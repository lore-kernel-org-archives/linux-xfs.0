Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 295BA7F61
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 17:56:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B8B98AC001
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 15:56:15 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	SfJkBBDs2ioRycxi for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 15:56:13 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WA6tU-0005p7-U8
	for xfs@oss.sgi.com; Mon, 03 Feb 2014 10:56:09 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WA6tU-0003NI-TF
	for xfs@oss.sgi.com; Mon, 03 Feb 2014 10:56:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] generic: inconsistent initial state for test_generic_punch
Date: Mon,  3 Feb 2014 10:56:05 +1100
Message-Id: <1391385365-12790-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1391385365-12790-1-git-send-email-david@fromorbit.com>
References: <1391385365-12790-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The first test may start with the file from the previous test, and
that is in an unknown state. Hence always remove the test file
before the first test so that it doesn't have extents inside the
test range as it is supposed to be testing into a hole.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/punch          | 7 ++++---
 tests/generic/255.out | 8 ++------
 tests/generic/316.out | 8 ++------
 tests/xfs/252.out     | 8 ++------
 4 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/common/punch b/common/punch
index 4ed8406..49715a7 100644
--- a/common/punch
+++ b/common/punch
@@ -318,10 +318,11 @@ _test_generic_punch()
 	filter_cmd=$5
 	testfile=$6
 
+	# initial test state must be defined, otherwise the first test can fail
+	# due ot stale file state left from previous tests.
+	rm -f $testfile
+
 	echo "	1. into a hole"
-	if [ "$remove_testfile" ]; then
-		rm -f $testfile
-	fi
 	$XFS_IO_PROG -f -c "truncate 20k" \
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
diff --git a/tests/generic/255.out b/tests/generic/255.out
index cb9fdca..217ef3e 100644
--- a/tests/generic/255.out
+++ b/tests/generic/255.out
@@ -158,9 +158,7 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
 	1. into a hole
-0: [0..7]: extent
-1: [8..39]: hole
-5a58e46082be047d0f13bee7974015b9
+daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: extent
 1: [8..23]: hole
@@ -242,9 +240,7 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
 	1. into a hole
-0: [0..7]: extent
-1: [8..39]: hole
-5a58e46082be047d0f13bee7974015b9
+daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: extent
 1: [8..23]: hole
diff --git a/tests/generic/316.out b/tests/generic/316.out
index 222e601..383f0d1 100644
--- a/tests/generic/316.out
+++ b/tests/generic/316.out
@@ -86,9 +86,7 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
 	1. into a hole
-0: [0..7]: extent
-1: [8..39]: hole
-5a58e46082be047d0f13bee7974015b9
+daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: extent
 1: [8..23]: hole
@@ -135,9 +133,7 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
 	1. into a hole
-0: [0..7]: extent
-1: [8..39]: hole
-5a58e46082be047d0f13bee7974015b9
+daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: extent
 1: [8..23]: hole
diff --git a/tests/xfs/252.out b/tests/xfs/252.out
index 539c8a4..47d9a4c 100644
--- a/tests/xfs/252.out
+++ b/tests/xfs/252.out
@@ -158,9 +158,7 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
 	1. into a hole
-0: [0..7]: data
-1: [8..39]: hole
-5a58e46082be047d0f13bee7974015b9
+daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: data
 1: [8..23]: hole
@@ -242,9 +240,7 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
 	1. into a hole
-0: [0..7]: data
-1: [8..39]: hole
-5a58e46082be047d0f13bee7974015b9
+daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: data
 1: [8..23]: hole
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
