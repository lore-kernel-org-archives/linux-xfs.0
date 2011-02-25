Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1PIB26S215358 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 12:11:02 -0600
Subject: [PATCH v4, 13/16] xfsprogs: metadump: move duplicate name handling
	into its own function
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110224021239.GA3166@dastard>
References: <201102182121.p1ILL2pI029171@stout.americas.sgi.com>
	<20110224021239.GA3166@dastard>
Date: Fri, 25 Feb 2011 12:13:48 -0600
Message-ID: <1298657628.1990.6987.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Move the handling of duplicate names into its own function.  As a
result, all names other than "lost+found" files (not just those that
get obfuscated) will be checked to avoid duplication.

This makes the local buffer newname[] in generate_obfuscated_name()
unnecessary, so just drop it and use the passed-in name.

Signed-off-by: Alex Elder <aelder@sgi.com>

Updates:
- A comment about handling of a leading '/' character is now modified
  to match the updated code, rather than being deleted altogether.
- Renamed handle_duplicates() to be handle_duplicate_name().

---
 db/metadump.c |   78
++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 31 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -552,6 +552,37 @@ obfuscate_name(
 	ASSERT(libxfs_da_hashname(name, name_len) == hash);
 }
 
+/*
+ * Look up the given name in the name table.  If it is already
+ * present, find an alternate and attempt to use that name instead.
+ *
+ * Returns 1 if the (possibly modified) name is not present in the
+ * name table.  Returns 0 otherwise.
+ */
+static int
+handle_duplicate_name(xfs_dahash_t hash, size_t name_len, uchar_t
*name)
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
 static void
 generate_obfuscated_name(
 	xfs_ino_t		ino,
@@ -559,8 +590,6 @@ generate_obfuscated_name(
 	uchar_t			*name)
 {
 	xfs_dahash_t		hash;
-	int			dup = 0;
-	uchar_t			newname[NAME_MAX];
 
 	/*
 	 * We don't obfuscate "lost+found" or any orphan files
@@ -572,48 +601,35 @@ generate_obfuscated_name(
 		return;
 
 	/*
-	 * If the name starts with a slash, just skip over it.  We
-	 * will copy our obfuscated name back into space following
-	 * the slash when we're done.  Our new name will not have
-	 * the '/', and that's the version we'll keep in our
-	 * duplicates table.  Note that the namelen value passed in
-	 * does not include the leading slash (if any).
+	 * If the name starts with a slash, just skip over it.  It
+	 * isn't included in the hash and we don't record it in the
+	 * name table.  Note that the namelen value passed in does
+	 * not count the leading slash (if one is present).
 	 */
 	if (*name == '/')
 	    	name++;
 
-	hash = libxfs_da_hashname(name, namelen);
-	do {
-		obfuscate_name(hash, namelen, newname);
+	/* Obfuscate the name (if possible) */
 
-		/*
-		 * Search the name table to be sure we don't produce
-		 * a name that's already been used.
-		 */
-		if (!nametable_find(hash, namelen, newname))
-			break;
-	} while (++dup < DUP_MAX);
+	hash = libxfs_da_hashname(name, namelen);
+	obfuscate_name(hash, namelen, name);
 
 	/*
-	 * Update the caller's copy with the obfuscated name.
-	 *
-	 * If we couldn't come up with one, just use the original
-	 * name without obfuscation.  Issue a warning if we managed
-	 * to previously create an obfuscated name that matches the
-	 * one we're working on now.
+	 * Make sure the name is not something already seen.  If we
+	 * fail to find a suitable alternate, we're dealing with a
+	 * very pathological situation, and we may end up creating
+	 * a duplicate name in the metadump, so issue a warning.
 	 */
-	if (dup < DUP_MAX)
-		memcpy(name, newname, namelen);
-	else if (nametable_find(hash, namelen, name))
+	if (!handle_duplicate_name(hash, namelen, name)) {
 		print_warning("duplicate name for inode %llu "
 				"in dir inode %llu\n",
 			(unsigned long long) ino,
 			(unsigned long long) cur_ino);
+		return;
+	}
+
+	/* Create an entry for the new name in the name table. */
 
-	/*
-	 * Create an entry for the name in the name table.  Use the
-	 * original name if we got too many dups.
-	 */
 	if (!nametable_add(hash, namelen, name))
 		print_warning("unable to record name for inode %llu "
 				"in dir inode %llu\n",


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
