Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBUKbvev028852 for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 14:37:57 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9B6E58F80D2
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 12:39:59 -0800 (PST)
Subject: [PATCH 01/12] xfsprogs: some things aren't all that special
From: Alex Elder <aelder@sgi.com>
Date: Thu, 30 Dec 2010 14:39:59 -0600
Message-ID: <1293741599.2294.342.camel@doink>
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

Move the check for short file names out of is_special_dirent() and
into generate_obfuscated_name().  That way the check is more
directly associated with the algorithm that requires it.

Similarly, move the check for inode == 0, since that case has to do
with storing extended attributes (not files) in the name table.

As a result, is_special_dirent() is really only focused on whether a
given file is in the lost+found directory.

Rename is_special_dirent() to reflect its more specific purpose.

And use a cast to elminate a compile warning in calls to
libxfs_da_hashname().

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 db/metadump.c |   51 +++++++++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2007 Silicon Graphics, Inc.
+ * Copyright (c) 2007,2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -377,8 +377,15 @@ random_filename_char(void)
 	return c;
 }
 
+/*
+ * We won't obfuscate "lost+found" nor any inodes within it.
+ *
+ * Record the "lost+found" directory's inode number when it's found.
+ * While processing that directory, any file whose name matches
+ * its inode number is left as-is (no obfuscation).
+ */
 static int
-is_special_dirent(
+in_lost_found(
 	xfs_ino_t		ino,
 	int			namelen,
 	uchar_t			*name)
@@ -387,22 +394,8 @@ is_special_dirent(
 	char			s[32];
 	int			slen;
 
-	/*
-	 * due to the XFS name hashing algorithm, we cannot obfuscate
-	 * names with 4 chars or less.
-	 */
-	if (namelen <= 4)
-		return 1;
-
-	if (ino == 0)
-		return 0;
-
-	/*
-	 * don't obfuscate lost+found nor any inodes within lost+found with
-	 * the inode number
-	 */
-	if (cur_ino == mp->m_sb.sb_rootino && namelen == 10 &&
-			memcmp(name, "lost+found", 10) == 0) {
+	if (!orphanage_ino && cur_ino == mp->m_sb.sb_rootino &&
+			namelen == 10 && !memcmp(name, "lost+found", 10)) {
 		orphanage_ino = ino;
 		return 1;
 	}
@@ -410,7 +403,8 @@ is_special_dirent(
 		return 0;
 
 	slen = sprintf(s, "%lld", (long long)ino);
-	return (slen == namelen && memcmp(name, s, namelen) == 0);
+
+	return slen == namelen && !memcmp(name, s, namelen);
 }
 
 static void
@@ -426,10 +420,23 @@ generate_obfuscated_name(
 	xfs_dahash_t		newhash;
 	uchar_t			newname[NAME_MAX];
 
-	if (is_special_dirent(ino, namelen, name))
+	/*
+	 * Our obfuscation algorithm requires at least 5-character
+	 * names, so don't bother if the name is too short.
+	 */
+	if (namelen < 5)
+	    	return;
+
+	/*
+	 * We don't obfuscate "lost+found" or any of the files
+	 * therein.  When the name table is used for extended
+	 * attributes, the inode number provided is 0, in which
+	 * case we don't need to make this check.
+	 */
+	if (ino && in_lost_found(ino, namelen, name))
 		return;
 
-	hash = libxfs_da_hashname(name, namelen);
+	hash = libxfs_da_hashname((char *) name, namelen);
 
 	/* create a random name with the same hash value */
 
@@ -468,7 +475,7 @@ generate_obfuscated_name(
 			break;
 		}
 
-		ASSERT(libxfs_da_hashname(newname, namelen) == hash);
+		ASSERT(libxfs_da_hashname((char *) newname, namelen) == hash);
 
 		for (p = nametable[hash % NAME_TABLE_SIZE]; p; p = p->next) {
 			if (p->hash == hash && p->namelen == namelen &&


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
