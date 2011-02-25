Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1PIAtAP215317 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 12:10:55 -0600
Subject: [PATCH v4, 01/16] xfsprogs: metadump: some names aren't all that
	special
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110224011837.GO3166@dastard>
References: <201102182121.p1ILL1T8029031@stout.americas.sgi.com>
	<20110224011837.GO3166@dastard>
Date: Fri, 25 Feb 2011 12:13:37 -0600
Message-ID: <1298657617.1990.6984.camel@doink>
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

Move the check for short names out of is_special_dirent() and into
generate_obfuscated_name().  That way the check is more directly
associated with the algorithm that requires it.

Similarly, move the check for inode == 0, since that case has to do
with storing extended attributes (not files) in the name table.

As a result, is_special_dirent() is really only focused on whether a
given file is in the lost+found directory.  Rename the function to
reflect its more specific purpose.

Signed-off-by: Alex Elder <aelder@sgi.com>

Updates (v3):
- The previous version did not properly skip the "lost+found"
  directory itself; this one does.
- Created a new definition representing the name of the orphanage
  directory.  Encapsulate recognizing that directory into a new
  macro, is_lost_found().
- Removed casts that eliminate a compile warning in calls to
  libxfs_da_hashname(); will do them separately later if needed.
Updates (v4):
- Renamed is_lost_found() to be is_orphanage_dir(), and turned
  it into an inline static function.
- Added parentheses around targets of the sizeof operation.
- Added a small bit of clarifying commentary in spots where
  it was suggested.

---
 db/metadump.c |   86
+++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 62 insertions(+), 24 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2007 Silicon Graphics, Inc.
+ * Copyright (c) 2007, 2011 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -377,40 +377,63 @@ random_filename_char(void)
 	return c;
 }
 
+#define	ORPHANAGE	"lost+found"
+#define	ORPHANAGE_LEN	(sizeof (ORPHANAGE) - 1)
+
+static inline int
+is_orphanage_dir(
+	struct xfs_mount	*mp,
+	xfs_ino_t		dir_ino,
+	size_t			name_len,
+	uchar_t			*name)
+{
+	return dir_ino == mp->m_sb.sb_rootino &&
+			name_len == ORPHANAGE_LEN &&
+			!memcmp(name, ORPHANAGE, ORPHANAGE_LEN);
+}
+
+/*
+ * Determine whether a name is one we shouldn't obfuscate because
+ * it's an orphan (or the "lost+found" directory itself).  Note
+ * "cur_ino" is the inode for the directory currently being
+ * processed.
+ *
+ * Returns 1 if the name should NOT be obfuscated or 0 otherwise.
+ */
 static int
-is_special_dirent(
+in_lost_found(
 	xfs_ino_t		ino,
 	int			namelen,
 	uchar_t			*name)
 {
 	static xfs_ino_t	orphanage_ino = 0;
-	char			s[32];
+	char			s[24];	/* 21 is enough (64 bits in decimal) */
 	int			slen;
 
-	/*
-	 * due to the XFS name hashing algorithm, we cannot obfuscate
-	 * names with 4 chars or less.
-	 */
-	if (namelen <= 4)
-		return 1;
+	/* Record the "lost+found" inode if we haven't done so already */
 
-	if (ino == 0)
+	ASSERT(ino != 0);
+	if (!orphanage_ino && is_orphanage_dir(mp, cur_ino, namelen, name))
+		orphanage_ino = ino;
+
+	/* We don't obfuscate the "lost+found" directory itself */
+
+	if (ino == orphanage_ino)
+	    	return 1;
+
+	/* Most files aren't in "lost+found" at all */
+
+	if (cur_ino != orphanage_ino)
 		return 0;
 
 	/*
-	 * don't obfuscate lost+found nor any inodes within lost+found with
-	 * the inode number
+	 * Within "lost+found", we don't obfuscate any file whose
+	 * name is the same as its inode number.  Any others are
+	 * stray files and can be obfuscated.
 	 */
-	if (cur_ino == mp->m_sb.sb_rootino && namelen == 10 &&
-			memcmp(name, "lost+found", 10) == 0) {
-		orphanage_ino = ino;
-		return 1;
-	}
-	if (cur_ino != orphanage_ino)
-		return 0;
+	slen = snprintf(s, sizeof (s), "%llu", (unsigned long long) ino);
 
-	slen = sprintf(s, "%lld", (long long)ino);
-	return (slen == namelen && memcmp(name, s, namelen) == 0);
+	return slen == namelen && !memcmp(name, s, namelen);
 }
 
 static void
@@ -426,13 +449,28 @@ generate_obfuscated_name(
 	xfs_dahash_t		newhash;
 	uchar_t			newname[NAME_MAX];
 
-	if (is_special_dirent(ino, namelen, name))
-		return;
+	/*
+	 * Our obfuscation algorithm requires at least 5-character
+	 * names, so don't bother if the name is too short.  We
+	 * work backward from a hash value to determine the last
+	 * five bytes in a name required to produce a new name
+	 * with the same hash.
+	 */
+	if (namelen < 5)
+	    	return;
 
-	hash = libxfs_da_hashname(name, namelen);
+	/*
+	 * We don't obfuscate "lost+found" or any orphan files
+	 * therein.  When the name table is used for extended
+	 * attributes, the inode number provided is 0, in which
+	 * case we don't need to make this check.
+	 */
+	if (ino && in_lost_found(ino, namelen, name))
+		return;
 
 	/* create a random name with the same hash value */
 
+	hash = libxfs_da_hashname(name, namelen);
 	do {
 		dup = 0;
 		newname[0] = '/';


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
