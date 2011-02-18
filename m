Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1ILILbk238192 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 15:18:21 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102182121.p1ILL2oE029134@stout.americas.sgi.com>
Date: Fri, 18 Feb 2011 15:21:01 -0600
Subject: [PATCH v3, 10/16] xfsprogs: metadump: encapsulate the nametable code
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

The name table used to find duplicates in metadump.c is allocated
dynamically, but there's no real need to do so.  Just make it a BSS
global array and drop the initialization call.

Meanwhile, encapsulate the code that adds entries to and looks up
entries in the table into their own functions.  Use the lookup
function to detect a duplicate name in a case not previously
checked.

Change the naming scheme to use "nametable" as a prefix rather than
a suffix.

Finally, now that it's easy to do so, issue a warning if we find
that we're falling back to not obfuscating the name, but that name
has already been used in the current directory.  (This can happen if
a obfuscated earlier happens to match a subsequently found "real"
name.)

Signed-off-by: Alex Elder <aelder@sgi.com>

The only change worth mentioning from the last version posted is
that the the name is copied into a local buffer to ensure it's
NUL-terminated before printing it, in the event a duplicate name is
found.

---
 db/metadump.c |  120 ++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 72 insertions(+), 48 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -346,30 +346,61 @@ typedef struct name_ent {
 
 #define NAME_TABLE_SIZE		4096
 
-static name_ent_t 		**nametable;
-
-static int
-create_nametable(void)
-{
-	nametable = calloc(NAME_TABLE_SIZE, sizeof(name_ent_t));
-	return nametable != NULL;
-}
+static struct name_ent 	*nametable[NAME_TABLE_SIZE];
 
 static void
-clear_nametable(void)
+nametable_clear(void)
 {
-	int			i;
-	name_ent_t		*p;
+	int		i;
+	name_ent_t	*ent;
 
 	for (i = 0; i < NAME_TABLE_SIZE; i++) {
-		while (nametable[i]) {
-			p = nametable[i];
-			nametable[i] = p->next;
-			free(p);
+		while ((ent = nametable[i])) {
+			nametable[i] = ent->next;
+			free(ent);
 		}
 	}
 }
 
+/*
+ * See if the given name is already in the name table.  If so,
+ * return a pointer to its entry, otherwise return a null pointer.
+ */
+static struct name_ent *
+nametable_find(xfs_dahash_t hash, int namelen, uchar_t *name)
+{
+	struct name_ent	*ent;
+
+	for (ent = nametable[hash % NAME_TABLE_SIZE]; ent; ent = ent->next) {
+		if (ent->hash == hash && ent->namelen == namelen &&
+				!memcmp(ent->name, name, namelen))
+			return ent;
+	}
+	return NULL;
+}
+
+/*
+ * Add the given name to the name table.  Returns a pointer to the
+ * name's new entry, or a null pointer if an error occurs.
+ */
+static struct name_ent *
+nametable_add(xfs_dahash_t hash, int namelen, uchar_t *name)
+{
+	struct name_ent	*ent;
+
+	ent = malloc(sizeof *ent + namelen);
+	if (!ent)
+		return NULL;
+
+	ent->namelen = namelen;
+	memcpy(ent->name, name, namelen);
+	ent->hash = hash;
+	ent->next = nametable[hash % NAME_TABLE_SIZE];
+
+	nametable[hash % NAME_TABLE_SIZE] = ent;
+
+	return ent;
+}
 
 #define is_invalid_char(c)	((c) == '/' || (c) == '\0')
 #define rol32(x,y)		(((x) << (y)) | ((x) >> (32 - (y))))
@@ -444,7 +475,6 @@ generate_obfuscated_name(
 	uchar_t			*name)
 {
 	xfs_dahash_t		hash;
-	name_ent_t		*p;
 	int			dup = 0;
 	uchar_t			newname[NAME_MAX];
 	uchar_t			*newp;
@@ -542,36 +572,39 @@ generate_obfuscated_name(
 		 * Search the name table to be sure we don't produce
 		 * a name that's already been used.
 		 */
-		for (p = nametable[hash % NAME_TABLE_SIZE]; p; p = p->next) {
-			if (p->hash == hash && p->namelen == namelen &&
-					!memcmp(p->name, newname, namelen)) {
-				dup++;
-				break;
-			}
-		}
-	} while (dup && dup < DUP_MAX);
+		if (!nametable_find(hash, namelen, newname))
+			break;
+	} while (++dup < DUP_MAX);
 
 	/* Use the original name if we got too many dups. */
 
 	newp = dup < DUP_MAX ? newname : name;
 
-	/* Create an entry for the name in the name table */
-
-	p = malloc(sizeof(name_ent_t) + namelen);
-	if (p == NULL)
+	/*
+	 * Create an entry for the name in the name table.  Use the
+	 * original name if we got too many dups.
+	 */
+	if (!nametable_add(hash, namelen, newp))
 		return;
 
-	p->namelen = namelen;
-	memcpy(p->name, newp, namelen);
-	p->hash = hash;
-	p->next = nametable[hash % NAME_TABLE_SIZE];
-
-	nametable[hash % NAME_TABLE_SIZE] = p;
-
-	/* Update the caller's copy with the obfuscated name */
-
+	/*
+	 * Update the caller's copy with the obfuscated name.
+	 *
+	 * If we couldn't come up with one, warn if we managed to
+	 * previously create an obfuscated name that matches the one
+	 * we're working on now.
+	 */
 	if (newp != name)
 		memcpy(name, newp, namelen);
+	else if (nametable_find(hash, namelen, name)) {
+		/* Ensure the name we report is NUL-terminated. */
+	    	memcpy(newname, name, namelen);
+	    	newname[namelen] = '\0';
+		print_warning("duplicate name \"%s\" for inode %llu "
+				"in dir inode %llu\n",
+			newname, (unsigned long long) ino,
+			(unsigned long long) cur_ino);
+	}
 }
 
 static void
@@ -1276,7 +1309,7 @@ process_inode(
 			break;
 		default: ;
 	}
-	clear_nametable();
+	nametable_clear();
 
 	/* copy extended attributes if they exist and forkoff is valid */
 	if (success && XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
@@ -1295,7 +1328,7 @@ process_inode(
 				success = process_btinode(dip, TYP_ATTR);
 				break;
 		}
-		clear_nametable();
+		nametable_clear();
 	}
 	return success;
 }
@@ -1698,12 +1731,6 @@ metadump_f(
 	metablock->mb_blocklog = BBSHIFT;
 	metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
 
-	if (!create_nametable()) {
-		print_warning("memory allocation failure");
-		free(metablock);
-		return 0;
-	}
-
 	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
 	block_buffer = (char *)metablock + BBSIZE;
 	num_indicies = (BBSIZE - sizeof(xfs_metablock_t)) / sizeof(__be64);
@@ -1713,7 +1740,6 @@ metadump_f(
 	if (strcmp(argv[optind], "-") == 0) {
 		if (isatty(fileno(stdout))) {
 			print_warning("cannot write to a terminal");
-			free(nametable);
 			free(metablock);
 			return 0;
 		}
@@ -1722,7 +1748,6 @@ metadump_f(
 		outf = fopen(argv[optind], "wb");
 		if (outf == NULL) {
 			print_warning("cannot create dump file");
-			free(nametable);
 			free(metablock);
 			return 0;
 		}
@@ -1759,7 +1784,6 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 
-	free(nametable);
 	free(metablock);
 
 	return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
