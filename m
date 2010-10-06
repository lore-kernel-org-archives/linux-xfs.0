Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96ImcVw111116 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 13:48:38 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DFDF1AC004
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 11:49:42 -0700 (PDT)
Subject: [PATCH 5/6] xfsprogs: replace repeated blocks with a loop
From: Alex Elder <aelder@sgi.com>
Date: Wed, 06 Oct 2010 13:49:41 -0500
Message-ID: <1286390981.1951.367.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

Replace a repeated block of code with an equivalent loop.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 db/metadump.c |   43 +++++++++----------------------------------
 1 file changed, 9 insertions(+), 34 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -471,41 +471,16 @@ generate_obfuscated_name(
 		newhash = rol32(newhash, 3) ^ hash;
 
 		high_bit = 0;
+		for (i = 5; i > 0; i--) {
+		    	int shift = (i - 1) * 7;
 
-		newp[namelen - 5] = (newhash >> 28) & 0x7f ^ high_bit;
-		if (is_invalid_char(newp[namelen - 5])) {
-			newp[namelen - 5] ^= 1;
-			high_bit = 0x80;
-		} else
-			high_bit = 0;
-
-		newp[namelen - 4] = (newhash >> 21) & 0x7f ^ high_bit;
-		if (is_invalid_char(newp[namelen - 4])) {
-			newp[namelen - 4] ^= 1;
-			high_bit = 0x80;
-		} else
-			high_bit = 0;
-
-		newp[namelen - 3] = (newhash >> 14) & 0x7f ^ high_bit;
-		if (is_invalid_char(newp[namelen - 3])) {
-			newp[namelen - 3] ^= 1;
-			high_bit = 0x80;
-		} else
-			high_bit = 0;
-
-		newp[namelen - 2] = (newhash >> 7) & 0x7f ^ high_bit;
-		if (is_invalid_char(newp[namelen - 2])) {
-			newp[namelen - 2] ^= 1;
-			high_bit = 0x80;
-		} else
-			high_bit = 0;
-
-		newp[namelen - 1] = (newhash >> 0) & 0x7f ^ high_bit;
-		if (is_invalid_char(newp[namelen - 1])) {
-			newp[namelen - 1] ^= 1;
-			high_bit = 0x80;
-		} else
-			high_bit = 0;
+			newp[namelen - i] = (newhash >> shift) & 0x7f ^ high_bit;
+			if (is_invalid_char(newp[namelen - i])) {
+				newp[namelen - i] ^= 1;
+				high_bit = 0x80;
+			} else
+				high_bit = 0;
+		}
 
 		if (high_bit) {
 			newp[namelen - 5] ^= 0x10;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
