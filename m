Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1ILIKtx238176 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 15:18:20 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102182121.p1ILL1lX029072@stout.americas.sgi.com>
Date: Fri, 18 Feb 2011 15:21:01 -0600
Subject: [PATCH v3, 05/16] xfsprogs: metadump: eliminate a pointless loop
	in generate_obfuscated_name()
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

Eliminate a now pointless loop.  Done as a separate patch to make
the effects of upcoming changes more clear.

Signed-off-by: Alex Elder <aelder@sgi.com>

No significant changes in this version from the last one posted.

---
 db/metadump.c |  144 ++++++++++++++++++++++++++++------------------------------
 1 file changed, 70 insertions(+), 74 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -472,87 +472,83 @@ generate_obfuscated_name(
 
 	hash = libxfs_da_hashname(name, namelen);
 	do {
+		uchar_t	high_bit;
+
 		dup = 0;
-		for (;;) {
-			uchar_t	high_bit;
 
-		    	/*
-			 * The beginning of the obfuscated name can
-			 * be pretty much anything, so fill it in
-			 * with random characters.  Accumulate its
-			 * new hash value as we go.
-			 */
-			newhash = 0;
-			for (i = 0; i < namelen - 5; i++) {
-				newp[i] = random_filename_char();
-				newhash = newp[i] ^ rol32(newhash, 7);
-			}
+		/*
+		 * The beginning of the obfuscated name can be
+		 * pretty much anything, so fill it in with random
+		 * characters.  Accumulate its new hash value as we
+		 * go.
+		 */
+		newhash = 0;
+		for (i = 0; i < namelen - 5; i++) {
+			newp[i] = random_filename_char();
+			newhash = newp[i] ^ rol32(newhash, 7);
+		}
 
-			/*
-			 * Compute which five bytes need to be used
-			 * at the end of the name so the hash of the
-			 * obfuscated name is the same as the hash
-			 * of the original.  If any result in an
-			 * invalid character, flip a bit and arrange
-			 * for a corresponding bit in a neighboring
-			 * byte to be flipped as well.  For the last
-			 * byte, the "neighbor" to change is the
-			 * first byte we're computing here.
-			 */
-			newhash = rol32(newhash, 3) ^ hash;
+		/*
+		 * Compute which five bytes need to be used at the
+		 * end of the name so the hash of the obfuscated
+		 * name is the same as the hash of the original.  If
+		 * any result in an invalid character, flip a bit
+		 * and arrange for a corresponding bit in a
+		 * neighboring byte to be flipped as well.  For the
+		 * last byte, the "neighbor" to change is the first
+		 * byte we're computing here.
+		 */
+		newhash = rol32(newhash, 3) ^ hash;
+
+		high_bit = 0;
+
+		newp[namelen - 5] = ((newhash >> 28) & 0x7f) ^ high_bit;
+		if (is_invalid_char(newp[namelen - 5])) {
+			newp[namelen - 5] ^= 1;
+			high_bit = 0x80;
+		} else
+			high_bit = 0;
 
+		newp[namelen - 4] = ((newhash >> 21) & 0x7f) ^ high_bit;
+		if (is_invalid_char(newp[namelen - 4])) {
+			newp[namelen - 4] ^= 1;
+			high_bit = 0x80;
+		} else
 			high_bit = 0;
 
-			newp[namelen - 5] = ((newhash >> 28) & 0x7f) ^ high_bit;
-			if (is_invalid_char(newp[namelen - 5])) {
-				newp[namelen - 5] ^= 1;
-				high_bit = 0x80;
-			} else
-				high_bit = 0;
-
-			newp[namelen - 4] = ((newhash >> 21) & 0x7f) ^ high_bit;
-			if (is_invalid_char(newp[namelen - 4])) {
-				newp[namelen - 4] ^= 1;
-				high_bit = 0x80;
-			} else
-				high_bit = 0;
-
-			newp[namelen - 3] = ((newhash >> 14) & 0x7f) ^ high_bit;
-			if (is_invalid_char(newp[namelen - 3])) {
-				newp[namelen - 3] ^= 1;
-				high_bit = 0x80;
-			} else
-				high_bit = 0;
-
-			newp[namelen - 2] = ((newhash >> 7) & 0x7f) ^ high_bit;
-			if (is_invalid_char(newp[namelen - 2])) {
-				newp[namelen - 2] ^= 1;
-				high_bit = 0x80;
-			} else
-				high_bit = 0;
-
-			newp[namelen - 1] = ((newhash >> 0) & 0x7f) ^ high_bit;
-			if (is_invalid_char(newp[namelen - 1])) {
-				newp[namelen - 1] ^= 1;
-				high_bit = 0x80;
-			} else
-				high_bit = 0;
+		newp[namelen - 3] = ((newhash >> 14) & 0x7f) ^ high_bit;
+		if (is_invalid_char(newp[namelen - 3])) {
+			newp[namelen - 3] ^= 1;
+			high_bit = 0x80;
+		} else
+			high_bit = 0;
 
-			/*
-			 * If we flipped a bit on the last byte, we
-			 * need to fix up the first one we computed.
-			 *
-			 * That first byte had 0's in its upper four
-			 * bits (it's the result of shifting a
-			 * 32-bit unsigned value Right by 28 bits),
-			 * so we don't need to worry about it
-			 * becoming invalid as a result.
-			 */
-			if (high_bit) {
-			    	newp[namelen - 5] ^= 0x10;
-				ASSERT(!is_invalid_char(newp[namelen - 5]));
-			}
-			break;
+		newp[namelen - 2] = ((newhash >> 7) & 0x7f) ^ high_bit;
+		if (is_invalid_char(newp[namelen - 2])) {
+			newp[namelen - 2] ^= 1;
+			high_bit = 0x80;
+		} else
+			high_bit = 0;
+
+		newp[namelen - 1] = ((newhash >> 0) & 0x7f) ^ high_bit;
+		if (is_invalid_char(newp[namelen - 1])) {
+			newp[namelen - 1] ^= 1;
+			high_bit = 0x80;
+		} else
+			high_bit = 0;
+
+		/*
+		 * If we flipped a bit on the last byte, we need to
+		 * fix up the first one we computed.
+		 *
+		 * That first byte had 0's in its upper four bits
+		 * (it's the result of shifting a 32-bit unsigned
+		 * value Right by 28 bits), so we don't need to
+		 * worry about it becoming invalid as a result.
+		 */
+		if (high_bit) {
+			newp[namelen - 5] ^= 0x10;
+			ASSERT(!is_invalid_char(newp[namelen - 5]));
 		}
 
 		ASSERT(libxfs_da_hashname(newname, namelen) == hash);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
