Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1ILIK9k238174 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 15:18:20 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102182121.p1ILL1Fx029087@stout.americas.sgi.com>
Date: Fri, 18 Feb 2011 15:21:01 -0600
Subject: [PATCH v3, 06/16] xfsprogs: metadump: replace repeated blocks
	with a loop
MIME-Version: 1.0
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

Each of the last five characters in the obfuscated name are
generated the same way.  Replace that repeated block of code
with an equivalent loop.

Signed-off-by: Alex Elder <aelder@sgi.com>

No significant changes in this version from the last one posted.

---
 db/metadump.c |   43 +++++++++----------------------------------
 1 file changed, 9 insertions(+), 34 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -501,41 +501,16 @@ generate_obfuscated_name(
 		newhash = rol32(newhash, 3) ^ hash;
 
 		high_bit = 0;
+		for (i = 5; i > 0; i--) {
+		    	int shift = (i - 1) * 7;
 
-		newp[namelen - 5] = ((newhash >> 28) & 0x7f) ^ high_bit;
-		if (is_invalid_char(newp[namelen - 5])) {
-			newp[namelen - 5] ^= 1;
-			high_bit = 0x80;
-		} else
-			high_bit = 0;
-
-		newp[namelen - 4] = ((newhash >> 21) & 0x7f) ^ high_bit;
-		if (is_invalid_char(newp[namelen - 4])) {
-			newp[namelen - 4] ^= 1;
-			high_bit = 0x80;
-		} else
-			high_bit = 0;
-
-		newp[namelen - 3] = ((newhash >> 14) & 0x7f) ^ high_bit;
-		if (is_invalid_char(newp[namelen - 3])) {
-			newp[namelen - 3] ^= 1;
-			high_bit = 0x80;
-		} else
-			high_bit = 0;
-
-		newp[namelen - 2] = ((newhash >> 7) & 0x7f) ^ high_bit;
-		if (is_invalid_char(newp[namelen - 2])) {
-			newp[namelen - 2] ^= 1;
-			high_bit = 0x80;
-		} else
-			high_bit = 0;
-
-		newp[namelen - 1] = ((newhash >> 0) & 0x7f) ^ high_bit;
-		if (is_invalid_char(newp[namelen - 1])) {
-			newp[namelen - 1] ^= 1;
-			high_bit = 0x80;
-		} else
-			high_bit = 0;
+			newp[namelen - i] = ((newhash >> shift) & 0x7f) ^ high_bit;
+			if (is_invalid_char(newp[namelen - i])) {
+				newp[namelen - i] ^= 1;
+				high_bit = 0x80;
+			} else
+				high_bit = 0;
+		}
 
 		/*
 		 * If we flipped a bit on the last byte, we need to

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
