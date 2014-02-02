Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DEC7F7FD1
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 17:56:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A0CBA8F8033
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 15:56:18 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VGxtiHk7NGYUWf3h for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 15:56:16 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WA6tU-0005p6-TU
	for xfs@oss.sgi.com; Mon, 03 Feb 2014 10:56:08 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WA6tU-0003ND-Sd
	for xfs@oss.sgi.com; Mon, 03 Feb 2014 10:56:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] generic: _test_generic_punch not blocksize clean
Date: Mon,  3 Feb 2014 10:56:04 +1100
Message-Id: <1391385365-12790-4-git-send-email-david@fromorbit.com>
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

Test 17 of _test_generic_punch uses the filesystem block size to do
a sub-single block punch. The result of this is a files of
different sizes and md5sums when the filesystem block size changes.
However the only difference in file contents if the length of the
file - the zeroed region is always in the same place. Hence we can
use hexdump rather than md5sum to check the output remains
consistent and the hole remains in the correct place despite the
changing block sizes.

Fix up all the golden output for all the tests that use this
function, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/punch          | 12 +++++++++---
 tests/generic/255.out | 28 ++++++++++++++++++++++++----
 tests/generic/316.out | 28 ++++++++++++++++++++++++----
 tests/xfs/242.out     |  7 ++++++-
 tests/xfs/252.out     | 28 ++++++++++++++++++++++++----
 5 files changed, 87 insertions(+), 16 deletions(-)

diff --git a/common/punch b/common/punch
index a49638c..4ed8406 100644
--- a/common/punch
+++ b/common/punch
@@ -516,6 +516,12 @@ _test_generic_punch()
 	rm -f $testfile.2
 	_md5_checksum $testfile
 
+	# different file sizes mean we can't use md5sum to check the hole is
+	# valid. Hence use hexdump to dump the contents and chop off the last
+	# line of output that indicates the file size. We also have to fudge
+	# the extent size as that will change with file size, too - that's what
+	# the sed line noise does - it will always result in an output of [0..7]
+	# so it matches 4k block size...
 	echo "	17. data -> hole in single block file"
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
@@ -524,8 +530,8 @@ _test_generic_punch()
 	$XFS_IO_PROG -f -c "truncate $block_size" \
 		-c "pwrite 0 $block_size" $sync_cmd \
 		-c "$zero_cmd 128 128" \
-		-c "$map_cmd -v" $testfile | $filter_cmd
+		-c "$map_cmd -v" $testfile | $filter_cmd | \
+			 sed -e "s/\.\.[0-9]*\]/..7\]/"
 	[ $? -ne 0 ] && die_now
-	_md5_checksum $testfile
-
+	od -x $testfile | head -n -1
 }
diff --git a/tests/generic/255.out b/tests/generic/255.out
index 2ce882b..cb9fdca 100644
--- a/tests/generic/255.out
+++ b/tests/generic/255.out
@@ -72,7 +72,12 @@ eecb7aa303d121835de05028751d301c
 eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: extent
-13535fd4d496bf0b74bb2335aa4d1b31
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
 	1. into a hole
 daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
@@ -146,7 +151,12 @@ eecb7aa303d121835de05028751d301c
 eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: extent
-13535fd4d496bf0b74bb2335aa4d1b31
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
 	1. into a hole
 0: [0..7]: extent
 1: [8..39]: hole
@@ -225,7 +235,12 @@ eecb7aa303d121835de05028751d301c
 eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: extent
-13535fd4d496bf0b74bb2335aa4d1b31
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
 	1. into a hole
 0: [0..7]: extent
 1: [8..39]: hole
@@ -304,4 +319,9 @@ eecb7aa303d121835de05028751d301c
 eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: extent
-13535fd4d496bf0b74bb2335aa4d1b31
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
diff --git a/tests/generic/316.out b/tests/generic/316.out
index 4bb11ec..222e601 100644
--- a/tests/generic/316.out
+++ b/tests/generic/316.out
@@ -36,7 +36,12 @@ eecb7aa303d121835de05028751d301c
 eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: extent
-13535fd4d496bf0b74bb2335aa4d1b31
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
 	1. into a hole
 daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
@@ -74,7 +79,12 @@ eecb7aa303d121835de05028751d301c
 eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: extent
-13535fd4d496bf0b74bb2335aa4d1b31
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
 	1. into a hole
 0: [0..7]: extent
 1: [8..39]: hole
@@ -118,7 +128,12 @@ eecb7aa303d121835de05028751d301c
 eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: extent
-13535fd4d496bf0b74bb2335aa4d1b31
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
 	1. into a hole
 0: [0..7]: extent
 1: [8..39]: hole
@@ -162,4 +177,9 @@ eecb7aa303d121835de05028751d301c
 eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: extent
-13535fd4d496bf0b74bb2335aa4d1b31
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
diff --git a/tests/xfs/242.out b/tests/xfs/242.out
index 72026a3..a516c23 100644
--- a/tests/xfs/242.out
+++ b/tests/xfs/242.out
@@ -74,4 +74,9 @@ eecb7aa303d121835de05028751d301c
 eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: data
-13535fd4d496bf0b74bb2335aa4d1b31
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
diff --git a/tests/xfs/252.out b/tests/xfs/252.out
index 3caf9d6..539c8a4 100644
--- a/tests/xfs/252.out
+++ b/tests/xfs/252.out
@@ -72,7 +72,12 @@ eecb7aa303d121835de05028751d301c
 eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: data
-13535fd4d496bf0b74bb2335aa4d1b31
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
 	1. into a hole
 daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
@@ -146,7 +151,12 @@ eecb7aa303d121835de05028751d301c
 eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: data
-13535fd4d496bf0b74bb2335aa4d1b31
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
 	1. into a hole
 0: [0..7]: data
 1: [8..39]: hole
@@ -225,7 +235,12 @@ eecb7aa303d121835de05028751d301c
 eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: data
-13535fd4d496bf0b74bb2335aa4d1b31
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
 	1. into a hole
 0: [0..7]: data
 1: [8..39]: hole
@@ -304,4 +319,9 @@ eecb7aa303d121835de05028751d301c
 eecb7aa303d121835de05028751d301c
 	17. data -> hole in single block file
 0: [0..7]: data
-13535fd4d496bf0b74bb2335aa4d1b31
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0000200 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
