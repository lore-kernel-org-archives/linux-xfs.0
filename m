Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96ImTtO111090 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 13:48:29 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8AD14AC004
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 11:49:33 -0700 (PDT)
Subject: [PATCH 4/6] xfsprogs: eliminate a pointless loop
From: Alex Elder <aelder@sgi.com>
Date: Wed, 06 Oct 2010 13:49:31 -0500
Message-ID: <1286390971.1951.366.camel@doink>
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

Eliminate a now pointless loop.  Done as a separate patch to
make the effects of upcoming changes more clear.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 db/metadump.c |  129 ++++++++++++++++++++++++++++------------------------------
 1 file changed, 63 insertions(+), 66 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -443,80 +443,77 @@ generate_obfuscated_name(
 	if (*name == '/')
 	    	name++;
 	do {
+		uchar_t	high_bit;
+
 		dup = 0;
-		for (;;) {
-			uchar_t	high_bit;
 
-		    	/*
-			 * The beginning of the obfuscated name can
-			 * be pretty much anything, so fill it in
-			 * with random characters.
-			 */
-			newhash = 0;
-			for (i = 0; i < namelen - 5; i++) {
-				newp[i] = random_filename_char();
-				newhash = newp[i] ^ rol32(newhash, 7);
-			}
+		/*
+		 * The beginning of the obfuscated name can be
+		 * pretty much anything, so fill it in with random
+		 * characters.
+		 */
+		newhash = 0;
+		for (i = 0; i < namelen - 5; i++) {
+			newp[i] = random_filename_char();
+			newhash = newp[i] ^ rol32(newhash, 7);
+		}
 
-			/*
-			 * Compute which five bytes need to be used
-			 * at the end of the name so the hash of the
-			 * obfuscated is the same as the hash of the
-			 * original.  If any result in an invalid
-			 * character, flip a bit and arrange for a
-			 * corresponding bit in a neighboring byte
-			 * to be flipped as well.  For the last
-			 * byte, the "neighbor" to change is the
-			 * first byte we're computing here.
-			 */
-			newhash = rol32(newhash, 3) ^ hash;
+		/*
+		 * Compute which five bytes need to be used at the
+		 * end of the name so the hash of the obfuscated is
+		 * the same as the hash of the original.  If any
+		 * result in an invalid character, flip a bit and
+		 * arrange for a corresponding bit in a neighboring
+		 * byte to be flipped as well.  For the last byte,
+		 * the "neighbor" to change is the first byte we're
+		 * computing here.
+		 */
+		newhash = rol32(newhash, 3) ^ hash;
+
+		high_bit = 0;
 
+		newp[namelen - 5] = (newhash >> 28) & 0x7f ^ high_bit;
+		if (is_invalid_char(newp[namelen - 5])) {
+			newp[namelen - 5] ^= 1;
+			high_bit = 0x80;
+		} else
 			high_bit = 0;
 
-			newp[namelen - 5] = (newhash >> 28) & 0x7f ^ high_bit;
+		newp[namelen - 4] = (newhash >> 21) & 0x7f ^ high_bit;
+		if (is_invalid_char(newp[namelen - 4])) {
+			newp[namelen - 4] ^= 1;
+			high_bit = 0x80;
+		} else
+			high_bit = 0;
+
+		newp[namelen - 3] = (newhash >> 14) & 0x7f ^ high_bit;
+		if (is_invalid_char(newp[namelen - 3])) {
+			newp[namelen - 3] ^= 1;
+			high_bit = 0x80;
+		} else
+			high_bit = 0;
+
+		newp[namelen - 2] = (newhash >> 7) & 0x7f ^ high_bit;
+		if (is_invalid_char(newp[namelen - 2])) {
+			newp[namelen - 2] ^= 1;
+			high_bit = 0x80;
+		} else
+			high_bit = 0;
+
+		newp[namelen - 1] = (newhash >> 0) & 0x7f ^ high_bit;
+		if (is_invalid_char(newp[namelen - 1])) {
+			newp[namelen - 1] ^= 1;
+			high_bit = 0x80;
+		} else
+			high_bit = 0;
+
+		if (high_bit) {
+			newp[namelen - 5] ^= 0x10;
 			if (is_invalid_char(newp[namelen - 5])) {
-				newp[namelen - 5] ^= 1;
-				high_bit = 0x80;
-			} else
-				high_bit = 0;
-
-			newp[namelen - 4] = (newhash >> 21) & 0x7f ^ high_bit;
-			if (is_invalid_char(newp[namelen - 4])) {
-				newp[namelen - 4] ^= 1;
-				high_bit = 0x80;
-			} else
-				high_bit = 0;
-
-			newp[namelen - 3] = (newhash >> 14) & 0x7f ^ high_bit;
-			if (is_invalid_char(newp[namelen - 3])) {
-				newp[namelen - 3] ^= 1;
-				high_bit = 0x80;
-			} else
-				high_bit = 0;
-
-			newp[namelen - 2] = (newhash >> 7) & 0x7f ^ high_bit;
-			if (is_invalid_char(newp[namelen - 2])) {
-				newp[namelen - 2] ^= 1;
-				high_bit = 0x80;
-			} else
-				high_bit = 0;
-
-			newp[namelen - 1] = (newhash >> 0) & 0x7f ^ high_bit;
-			if (is_invalid_char(newp[namelen - 1])) {
-				newp[namelen - 1] ^= 1;
-				high_bit = 0x80;
-			} else
-				high_bit = 0;
-
-			if (high_bit) {
-			    	newp[namelen - 5] ^= 0x10;
-			    	if (is_invalid_char(newp[namelen - 5])) {
-					newp[namelen - 1] ^= 2;
-					newp[namelen - 5] ^= 0x20;
-					ASSERT(!is_invalid_char(newp[namelen - 1]));
-				}
+				newp[namelen - 1] ^= 2;
+				newp[namelen - 5] ^= 0x20;
+				ASSERT(!is_invalid_char(newp[namelen - 1]));
 			}
-			break;
 		}
 
 		ASSERT(libxfs_da_hashname(newname, namelen) == hash);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
