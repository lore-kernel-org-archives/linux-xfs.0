Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD82E7F50
	for <xfs@oss.sgi.com>; Sat,  5 Oct 2013 21:40:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 84C108F8035
	for <xfs@oss.sgi.com>; Sat,  5 Oct 2013 19:40:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FYkVK102O1UjiLv5 for <xfs@oss.sgi.com>;
	Sat, 05 Oct 2013 19:40:03 -0700 (PDT)
Message-ID: <5250CD80.9090708@sandeen.net>
Date: Sat, 05 Oct 2013 21:40:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V3] xfstests: restrict 259 device sizes to multiples of 512
References: <5250CA13.8040006@redhat.com> <5250CC9B.50807@sandeen.net>
In-Reply-To: <5250CC9B.50807@sandeen.net>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Test 259 tries to make a loop device size which is 1 byte less
than 4T; losetup now warns that this makes little sense, and
the warning breaks the test output:

    +losetup: /mnt/test/259.image: warning: file does not fit into a 512-byte sector the end of the file will be ignored.

The RH QE testcase did originally use loopback, so did
not in effect test anything other than 512-multiple boundaries.

Just drop the non-512-byte-multiple cases, they produce
devices exactly the same size as their 512-byte-multiple
neighbors.

(FWIW, this is a regression test for the bug that
d943b11 mkfs: get size of device properly
fixed.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2, sorry, sent wrong version that still had a 1025 "del"
value.

V3, .out file too, cripes.  No more saturday night patches,
sorry.

diff --git a/tests/xfs/259 b/tests/xfs/259
index 59eeaca..b8bd69a 100755
--- a/tests/xfs/259
+++ b/tests/xfs/259
@@ -48,7 +48,7 @@ testfile=$TEST_DIR/259.image
 
 # Test various sizes slightly less than 4 TB
 four_TB=$(_math "2^42")
-for del in 1 512 1024 1025 2048 4096; do
+for del in 512 1024 2048 4096; do
 	ddseek=$(_math "$four_TB - $del")
 	echo "Trying to make (4 TB - $del) B long xfs fs image"
 	rm -f "$testfile"
diff --git a/tests/xfs/259.out b/tests/xfs/259.out
index 263bb1b..6e0be9a 100644
--- a/tests/xfs/259.out
+++ b/tests/xfs/259.out
@@ -1,7 +1,5 @@
 QA output created by 259
-Trying to make (4 TB - 1) B long xfs fs image
 Trying to make (4 TB - 512) B long xfs fs image
 Trying to make (4 TB - 1024) B long xfs fs image
-Trying to make (4 TB - 1025) B long xfs fs image
 Trying to make (4 TB - 2048) B long xfs fs image
 Trying to make (4 TB - 4096) B long xfs fs image


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
