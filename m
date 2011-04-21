Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LIpfNx170039 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 13:51:41 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH] xfstests: coalesce contiguous extents in extent map output
Date: Thu, 21 Apr 2011 13:55:03 -0500
Message-Id: <dd1c0747731332fed9637bc01d6c6de369a7fe6f.1303412098.git.aelder@sgi.com>
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
Cc: Alex Elder <aelder@sgi.com>

The specific set of extent sizes allocated to a file is not always
deterministic.  In particular, sometimes a range of unwritten blocks
is covered by a single extent, while in other cases it might be
represented by multiple consecutive unwritten extents.  This can
result in spurious errors being reported in tests that check file
extent maps.

Add a filter that finds adjacent extents in what gets produced for
fiemap and bmap output and coalesces them as if all consective
extents of the same time were really just one extent.  (Note that
as implemented here this applies to all extent types, not just
unwritten extents.)

Update the golden output for test 242 to reflect the change.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 242.out      |   18 +++++++-----------
 common.punch |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/242.out b/242.out
index 9ffa207..f785163 100644
--- a/242.out
+++ b/242.out
@@ -11,15 +11,13 @@ QA output created by 242
 0: [0..39]: unwritten
 	4. hole -> data
 0: [0..7]: hole
-1: [8..15]: unwritten
-2: [16..23]: unwritten
-3: [24..31]: data
-4: [32..39]: hole
+1: [8..23]: unwritten
+2: [24..31]: data
+3: [32..39]: hole
 	5. hole -> unwritten
 0: [0..7]: hole
-1: [8..15]: unwritten
-2: [16..31]: unwritten
-3: [32..39]: hole
+1: [8..31]: unwritten
+2: [32..39]: hole
 	6. data -> hole
 0: [0..7]: data
 1: [8..23]: unwritten
@@ -37,10 +35,8 @@ QA output created by 242
 2: [32..39]: hole
 	10. hole -> data -> hole
 0: [0..7]: hole
-1: [8..15]: unwritten
-2: [16..23]: unwritten
-3: [24..31]: unwritten
-4: [32..39]: hole
+1: [8..31]: unwritten
+2: [32..39]: hole
 	11. data -> hole -> data
 0: [0..7]: data
 1: [8..31]: unwritten
diff --git a/common.punch b/common.punch
index fb20d58..c967bd8 100644
--- a/common.punch
+++ b/common.punch
@@ -177,18 +177,62 @@ _test_punch() {
 	done
 }
 
+_coalesce_extents()
+{
+	awk -F: '
+	{
+		range = $2;
+		type = $3;
+
+		split(range, bounds, "[\\[ \\.\\]]");
+		low = bounds[3];
+		high = bounds[5];
+
+		if (type != prev_type) {
+			if (prev_type != "")
+				printf("%u]:%s\n", low - 1, prev_type);
+			printf("%u: [%u..", out_count++, low);
+			prev_type = type;
+		}
+	}
+	END {
+		if (prev_type != "")
+			printf("%u]:%s\n", high, prev_type);
+	}'
+}
+
 _filter_fiemap()
 {
-    awk --posix '$3 ~ /hole/ { print $1, $2, $3; next }
-		 $5 ~ /0x[[:digit:]]*8[[:digit:]]{2}/ { print $1, $2, "unwritten"; next }
-		 $5 ~ /0x[[:digit:]]+/ {print $1, $2, "data" }'
+	awk --posix '
+		$3 ~ /hole/ {
+			print $1, $2, $3;
+			next;
+		}
+		$5 ~ /0x[[:digit:]]*8[[:digit:]]{2}/ {
+			print $1, $2, "unwritten";
+			next;
+		}
+		$5 ~ /0x[[:digit:]]+/ {
+			print $1, $2, "data";
+		}' |
+	_coalesce_extents
 }
 
 _filter_bmap()
 {
-    awk '$3 ~ /hole/ { print $1, $2, $3; next }
-         $7 ~ /10000/ { print $1, $2, "unwritten"; next }
-         $7 ~ /00000/ {print $1, $2, "data" }'
+	awk '
+		$3 ~ /hole/ {
+			print $1, $2, $3;
+			next;
+		}
+		$7 ~ /10000/ {
+			print $1, $2, "unwritten";
+			next;
+		}
+		$7 ~ /00000/ {
+	    		print $1, $2, "data"
+		}' |
+	_coalesce_extents
 }
 
 die_now()
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
