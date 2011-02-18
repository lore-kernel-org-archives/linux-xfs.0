Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1ILILsW238185 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 15:18:21 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102182121.p1ILL1fw029119@stout.americas.sgi.com>
Date: Fri, 18 Feb 2011 15:21:01 -0600
Subject: [PATCH v3, 09/16] xfsprogs: metadump: don't loop on too many dups
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

Don't just loop indefinitely when an obfuscated name comes up as a
duplicate.  Count the number of times we've found a duplicate and if
if it gets excessive despite choosing names at random, just give up
and use the original name without obfuscation.

Technically, a typical 5-character name has 255 other names that can
have the same hash value.  But the algorithm doesn't hit all
possible names (far from it) so duplicates are still possible.

Signed-off-by: Alex Elder <aelder@sgi.com>

The only change worth mentioning from the last version posted is
that the duplicate count is now updated inside the loop that
searches the name table.

---
 db/metadump.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -29,6 +29,14 @@
 
 #define DEFAULT_MAX_EXT_SIZE	1000
 
+/*
+ * It's possible that multiple files in a directory (or attributes
+ * in a file) produce the same obfuscated name.  If that happens, we
+ * try to create another one.  After several rounds of this though,
+ * we just give up and leave the original name as-is.
+ */
+#define	DUP_MAX		5	/* Max duplicates before we give up */
+
 /* copy all metadata structures to/from a file */
 
 static int	metadump_f(int argc, char **argv);
@@ -437,8 +445,9 @@ generate_obfuscated_name(
 {
 	xfs_dahash_t		hash;
 	name_ent_t		*p;
-	int			dup;
+	int			dup = 0;
 	uchar_t			newname[NAME_MAX];
+	uchar_t			*newp;
 
 	/*
 	 * Our obfuscation algorithm requires at least 5-character
@@ -471,19 +480,17 @@ generate_obfuscated_name(
 	do {
 		int		i;
 		xfs_dahash_t	newhash = 0;
-		uchar_t		*newp = &newname[0];
 		uchar_t		*first;
 		uchar_t		high_bit;
 		int		shift;
 
-		dup = 0;
-
 		/*
 		 * The beginning of the obfuscated name can be
 		 * pretty much anything, so fill it in with random
 		 * characters.  Accumulate its new hash value as we
 		 * go.
 		 */
+		newp = &newname[0];
 		for (i = 0; i < namelen - 5; i++) {
 			*newp = random_filename_char();
 			newhash = *newp ^ rol32(newhash, 7);
@@ -531,14 +538,22 @@ generate_obfuscated_name(
 
 		ASSERT(libxfs_da_hashname(newname, namelen) == hash);
 
+		/*
+		 * Search the name table to be sure we don't produce
+		 * a name that's already been used.
+		 */
 		for (p = nametable[hash % NAME_TABLE_SIZE]; p; p = p->next) {
 			if (p->hash == hash && p->namelen == namelen &&
 					!memcmp(p->name, newname, namelen)) {
-				dup = 1;
+				dup++;
 				break;
 			}
 		}
-	} while (dup);
+	} while (dup && dup < DUP_MAX);
+
+	/* Use the original name if we got too many dups. */
+
+	newp = dup < DUP_MAX ? newname : name;
 
 	/* Create an entry for the name in the name table */
 
@@ -547,7 +562,7 @@ generate_obfuscated_name(
 		return;
 
 	p->namelen = namelen;
-	memcpy(p->name, newname, namelen);
+	memcpy(p->name, newp, namelen);
 	p->hash = hash;
 	p->next = nametable[hash % NAME_TABLE_SIZE];
 
@@ -555,7 +570,8 @@ generate_obfuscated_name(
 
 	/* Update the caller's copy with the obfuscated name */
 
-	memcpy(name, newname, namelen);
+	if (newp != name)
+		memcpy(name, newp, namelen);
 }
 
 static void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
