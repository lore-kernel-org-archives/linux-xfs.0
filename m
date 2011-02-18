Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1ILIKwh238175 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 15:18:20 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102182121.p1ILL1AZ029097@stout.americas.sgi.com>
Date: Fri, 18 Feb 2011 15:21:01 -0600
Subject: [PATCH v3, 07/16] xfsprogs: metadump: use pointers in
	generate_obfuscated_name()
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

Switch from using array references to using pointers to refer to the
pathname characters as they get generated.  Also limit the scope of
a few automatic variables.

Signed-off-by: Alex Elder <aelder@sgi.com>

The only update since the last post version is the addition of an
ASSERT() in the loop generating the last 5 bytes.

---
 db/metadump.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -437,11 +437,8 @@ generate_obfuscated_name(
 {
 	xfs_dahash_t		hash;
 	name_ent_t		*p;
-	int			i;
 	int			dup;
-	xfs_dahash_t		newhash;
 	uchar_t			newname[NAME_MAX];
-	uchar_t			*newp = &newname[0];
 
 	/*
 	 * Our obfuscation algorithm requires at least 5-character
@@ -472,7 +469,12 @@ generate_obfuscated_name(
 
 	hash = libxfs_da_hashname(name, namelen);
 	do {
-		uchar_t	high_bit;
+		int		i;
+		xfs_dahash_t	newhash = 0;
+		uchar_t		*newp = &newname[0];
+		uchar_t		*first;
+		uchar_t		high_bit;
+		int		shift;
 
 		dup = 0;
 
@@ -482,10 +484,10 @@ generate_obfuscated_name(
 		 * characters.  Accumulate its new hash value as we
 		 * go.
 		 */
-		newhash = 0;
 		for (i = 0; i < namelen - 5; i++) {
-			newp[i] = random_filename_char();
-			newhash = newp[i] ^ rol32(newhash, 7);
+			*newp = random_filename_char();
+			newhash = *newp ^ rol32(newhash, 7);
+			newp++;
 		}
 
 		/*
@@ -500,16 +502,17 @@ generate_obfuscated_name(
 		 */
 		newhash = rol32(newhash, 3) ^ hash;
 
+		first = newp;
 		high_bit = 0;
-		for (i = 5; i > 0; i--) {
-		    	int shift = (i - 1) * 7;
-
-			newp[namelen - i] = ((newhash >> shift) & 0x7f) ^ high_bit;
-			if (is_invalid_char(newp[namelen - i])) {
-				newp[namelen - i] ^= 1;
+		for (shift = 28; shift >= 0; shift -= 7) {
+			*newp = (newhash >> shift & 0x7f) ^ high_bit;
+			if (is_invalid_char(*newp)) {
+				*newp ^= 1;
 				high_bit = 0x80;
 			} else
 				high_bit = 0;
+			ASSERT(!is_invalid_char(*newp));
+			newp++;
 		}
 
 		/*
@@ -522,15 +525,15 @@ generate_obfuscated_name(
 		 * worry about it becoming invalid as a result.
 		 */
 		if (high_bit) {
-			newp[namelen - 5] ^= 0x10;
-			ASSERT(!is_invalid_char(newp[namelen - 5]));
+			*first ^= 0x10;
+			ASSERT(!is_invalid_char(*first));
 		}
 
 		ASSERT(libxfs_da_hashname(newname, namelen) == hash);
 
 		for (p = nametable[hash % NAME_TABLE_SIZE]; p; p = p->next) {
 			if (p->hash == hash && p->namelen == namelen &&
-					memcmp(p->name, newname, namelen) == 0){
+					!memcmp(p->name, newname, namelen)) {
 				dup = 1;
 				break;
 			}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
