Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1ILILc5238208 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 15:18:21 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102182121.p1ILL2pI029171@stout.americas.sgi.com>
Date: Fri, 18 Feb 2011 15:21:02 -0600
Subject: [PATCH v3, 13/16] xfsprogs: metadump: move duplicate name
	handling into its own function
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

Move the handling of duplicate names into its own function.  As a
result, all names other than "lost+found" files (not just those that
get obfuscated) will be checked to avoid duplication.

This makes the local buffer newname[] in generate_obfuscated_name()
unnecessary, so just drop it and use the passed-in name.

Signed-off-by: Alex Elder <aelder@sgi.com>

This is a new change, not posted with this series previously.

---
 db/metadump.c |   95 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 49 insertions(+), 46 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -469,6 +469,37 @@ in_lost_found(
 }
 
 /*
+ * Look up the given name in the name table.  If it is already
+ * present, find an alternate and attempt to use that name instead.
+ *
+ * Returns 1 if the (possibly modified) name is not present in the
+ * name table.  Returns 0 otherwise.
+ */
+static int
+handle_duplicates(xfs_dahash_t hash, size_t name_len, uchar_t *name)
+{
+	int	dup = 0;
+
+	if (!nametable_find(hash, name_len, name))
+	    	return 1;	/* Not already in table */
+
+	/* Name is already in use.  Need to find an alternate. */
+
+	do {
+		obfuscate_name(hash, name_len, name);
+
+		/*
+		 * Search the name table to be sure we don't produce
+		 * a name that's already been used.
+		 */
+		if (!nametable_find(hash, name_len, name))
+			break;
+	} while (++dup < DUP_MAX);
+
+	return dup < DUP_MAX ? 1 : 0;
+}
+
+/*
  * Given a name and its hash value, massage the name in such a way
  * that the result is another name of equal length which shares the
  * same hash value.
@@ -549,9 +580,6 @@ generate_obfuscated_name(
 	uchar_t			*name)
 {
 	xfs_dahash_t		hash;
-	int			dup = 0;
-	uchar_t			newname[NAME_MAX];
-	uchar_t			*newp;
 
 	/*
 	 * We don't obfuscate "lost+found" or any orphan files
@@ -562,58 +590,33 @@ generate_obfuscated_name(
 	if (ino && in_lost_found(ino, namelen, name))
 		return;
 
-	/*
-	 * If the name starts with a slash, just skip over it.  We
-	 * will copy our obfuscated name back into space following
-	 * the slash when we're done.  Our new name will not have
-	 * the '/', and that's the version we'll keep in our
-	 * duplicates table.  Note that the namelen value passed in
-	 * does not include the leading slash (if any).
-	 */
 	if (*name == '/')
-	    	name++;
+	    	name++;		/* Skip over leading slash (if any). */
 
 	hash = libxfs_da_hashname(name, namelen);
-	do {
-		obfuscate_name(hash, namelen, newname);
-
-		/*
-		 * Search the name table to be sure we don't produce
-		 * a name that's already been used.
-		 */
-		if (!nametable_find(hash, namelen, newname))
-			break;
-	} while (++dup < DUP_MAX);
-
-	/* Use the original name if we got too many dups. */
-
-	newp = dup < DUP_MAX ? newname : name;
+	obfuscate_name(hash, namelen, name);
 
 	/*
-	 * Create an entry for the name in the name table.  Use the
-	 * original name if we got too many dups.
+	 * Make sure the name is not something already seen.  If
+	 * this fails we're dealing with a very pathological
+	 * situation, and we'll end up creating an entry with a
+	 * duplicate name, so issue a warning.
 	 */
-	if (!nametable_add(hash, namelen, newp))
+	if (!handle_duplicates(hash, namelen, name)) {
+		print_warning("duplicate name \"%s\" for inode %llu"
+				" in dir inode %llu\n",
+			name, (unsigned long long) ino,
+			(unsigned long long) cur_ino);
 		return;
+	}
 
-	/*
-	 * Update the caller's copy with the obfuscated name.
-	 *
-	 * If we couldn't come up with one, warn if we managed to
-	 * previously create an obfuscated name that matches the one
-	 * we're working on now.
-	 */
-	if (newp != name)
-		memcpy(name, newp, namelen);
-	else if (nametable_find(hash, namelen, name)) {
-		/* Ensure the name we report is NUL-terminated. */
-	    	memcpy(newname, name, namelen);
-	    	newname[namelen] = '\0';
-		print_warning("duplicate name \"%s\" for inode %llu "
-				"in dir inode %llu\n",
-			newname, (unsigned long long) ino,
+	/* Create an entry for the name in the name table. */
+
+	if (!nametable_add(hash, namelen, name))
+		print_warning("unable to record name \"%s\" "
+			"for inode %llu in dir inode %llu\n",
+			name, (unsigned long long) ino,
 			(unsigned long long) cur_ino);
-	}
 }
 
 static void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
