Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBUKdIoO029025 for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 14:39:18 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BDD16304039
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 12:41:23 -0800 (PST)
Subject: [PATCH 07/12] xfsprogs: use pointers in generate_obfuscated_name()
From: Alex Elder <aelder@sgi.com>
Date: Thu, 30 Dec 2010 14:41:23 -0600
Message-ID: <1293741683.2294.366.camel@doink>
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

Switch from using array references to using pointers to
refer to the pathname characters as they get generated.
Also limit the scope of a few automatic variables.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 db/metadump.c |   42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -415,11 +415,8 @@ generate_obfuscated_name(
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
@@ -450,7 +447,12 @@ generate_obfuscated_name(
 	if (*name == '/')
 	    	name++;
 	do {
-		uchar_t	high_bit;
+		int		i;
+		xfs_dahash_t	newhash = 0;
+		uchar_t		*newp = &newname[0];
+		uchar_t		*first;
+		uchar_t		high_bit;
+		int		shift;
 
 		dup = 0;
 
@@ -460,10 +462,10 @@ generate_obfuscated_name(
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
@@ -478,16 +480,16 @@ generate_obfuscated_name(
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
+			newp++;
 		}
 
 		/*
@@ -497,12 +499,12 @@ generate_obfuscated_name(
 		 * we flip one more bit in both bytes.
 		 */
 		if (high_bit) {
-			newp[namelen - 5] ^= 0x10;
-			if (is_invalid_char(newp[namelen - 5])) {
-				newp[namelen - 1] ^= 2;
-				newp[namelen - 5] ^= 0x20;
-				ASSERT(!is_invalid_char(newp[namelen - 1]));
-				ASSERT(!is_invalid_char(newp[namelen - 5]));
+			*first ^= 0x10;
+			if (is_invalid_char(*first)) {
+				*--newp ^= 2;
+				*first ^= 0x20;
+				ASSERT(!is_invalid_char(*newp));
+				ASSERT(!is_invalid_char(*first));
 			}
 		}
 
@@ -510,7 +512,7 @@ generate_obfuscated_name(
 
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
