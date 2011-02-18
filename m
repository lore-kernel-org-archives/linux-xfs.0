Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1ILIMrh238241 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 15:18:22 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102182121.p1ILL2XC029147@stout.americas.sgi.com>
Date: Fri, 18 Feb 2011 15:21:02 -0600
Subject: [PATCH v3, 11/16] xfsprogs: metadump: move obfuscation algorithm
	into its own function
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

Pull the name obfuscation algorithm into a separate function.
This separates it from the checking for duplicates and recording
of names that are found to be acceptable.

Signed-off-by: Alex Elder <aelder@sgi.com>

This is a new change, not posted with this series previously.

---
 db/metadump.c |  146 +++++++++++++++++++++++++++++++---------------------------
 1 file changed, 80 insertions(+), 66 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -468,6 +468,85 @@ in_lost_found(
 	return slen == namelen && !memcmp(name, s, namelen);
 }
 
+/*
+ * Given a name and its hash value, massage the name in such a way
+ * that the result is another name of equal length which shares the
+ * same hash value.
+ */
+static void
+obfuscate_name(
+	xfs_dahash_t	hash,
+	size_t		name_len,
+	uchar_t		*name)
+{
+	uchar_t		newname[NAME_MAX];
+	uchar_t		*newp = newname;
+	int		i;
+	xfs_dahash_t	new_hash = 0;
+	uchar_t		*first;
+	uchar_t		high_bit;
+	int		shift;
+
+	/*
+	 * Our obfuscation algorithm requires at least 5-character
+	 * names, so don't bother if the name is too short.
+	 */
+	if (name_len < 5)
+	    	return;
+
+	/*
+	 * The beginning of the obfuscated name can be pretty much
+	 * anything, so fill it in with random characters.
+	 * Accumulate its new hash value as we go.
+	 */
+	for (i = 0; i < name_len - 5; i++) {
+		*newp = random_filename_char();
+		new_hash = *newp ^ rol32(new_hash, 7);
+		newp++;
+	}
+
+	/*
+	 * Compute which five bytes need to be used at the end of
+	 * the name so the hash of the obfuscated name is the same
+	 * as the hash of the original.  If any result in an invalid
+	 * character, flip a bit and arrange for a corresponding bit
+	 * in a neighboring byte to be flipped as well.  For the
+	 * last byte, the "neighbor" to change is the first byte
+	 * we're computing here.
+	 */
+	new_hash = rol32(new_hash, 3) ^ hash;
+
+	first = newp;
+	high_bit = 0;
+	for (shift = 28; shift >= 0; shift -= 7) {
+		*newp = (new_hash >> shift & 0x7f) ^ high_bit;
+		if (is_invalid_char(*newp)) {
+			*newp ^= 1;
+			high_bit = 0x80;
+		} else
+			high_bit = 0;
+		ASSERT(!is_invalid_char(*newp));
+		newp++;
+	}
+
+	/*
+	 * If we flipped a bit on the last byte, we need to fix up
+	 * the matching bit in the first byte.  The result will
+	 * be a valid character, because we know that first byte
+	 * has 0's in its upper four bits (it was produced by a
+	 * 28-bit right-shift of a 32-bit unsigned value).
+	 */
+	if (high_bit) {
+		*first ^= 0x10;
+		ASSERT(!is_invalid_char(*first));
+	}
+	ASSERT(libxfs_da_hashname(newname, name_len) == hash);
+
+	/* Copy the fully obfuscated name back to the caller's buffer */
+
+	memcpy(name, newname, name_len);
+}
+
 static void
 generate_obfuscated_name(
 	xfs_ino_t		ino,
@@ -480,13 +559,6 @@ generate_obfuscated_name(
 	uchar_t			*newp;
 
 	/*
-	 * Our obfuscation algorithm requires at least 5-character
-	 * names, so don't bother if the name is too short.
-	 */
-	if (namelen < 5)
-	    	return;
-
-	/*
 	 * We don't obfuscate "lost+found" or any orphan files
 	 * therein.  When the name table is used for extended
 	 * attributes, the inode number provided is 0, in which
@@ -508,65 +580,7 @@ generate_obfuscated_name(
 
 	hash = libxfs_da_hashname(name, namelen);
 	do {
-		int		i;
-		xfs_dahash_t	newhash = 0;
-		uchar_t		*first;
-		uchar_t		high_bit;
-		int		shift;
-
-		/*
-		 * The beginning of the obfuscated name can be
-		 * pretty much anything, so fill it in with random
-		 * characters.  Accumulate its new hash value as we
-		 * go.
-		 */
-		newp = &newname[0];
-		for (i = 0; i < namelen - 5; i++) {
-			*newp = random_filename_char();
-			newhash = *newp ^ rol32(newhash, 7);
-			newp++;
-		}
-
-		/*
-		 * Compute which five bytes need to be used at the
-		 * end of the name so the hash of the obfuscated
-		 * name is the same as the hash of the original.  If
-		 * any result in an invalid character, flip a bit
-		 * and arrange for a corresponding bit in a
-		 * neighboring byte to be flipped as well.  For the
-		 * last byte, the "neighbor" to change is the first
-		 * byte we're computing here.
-		 */
-		newhash = rol32(newhash, 3) ^ hash;
-
-		first = newp;
-		high_bit = 0;
-		for (shift = 28; shift >= 0; shift -= 7) {
-			*newp = (newhash >> shift & 0x7f) ^ high_bit;
-			if (is_invalid_char(*newp)) {
-				*newp ^= 1;
-				high_bit = 0x80;
-			} else
-				high_bit = 0;
-			ASSERT(!is_invalid_char(*newp));
-			newp++;
-		}
-
-		/*
-		 * If we flipped a bit on the last byte, we need to
-		 * fix up the first one we computed.
-		 *
-		 * That first byte had 0's in its upper four bits
-		 * (it's the result of shifting a 32-bit unsigned
-		 * value Right by 28 bits), so we don't need to
-		 * worry about it becoming invalid as a result.
-		 */
-		if (high_bit) {
-			*first ^= 0x10;
-			ASSERT(!is_invalid_char(*first));
-		}
-
-		ASSERT(libxfs_da_hashname(newname, namelen) == hash);
+		obfuscate_name(hash, namelen, newname);
 
 		/*
 		 * Search the name table to be sure we don't produce

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
