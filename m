Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBUKehA5029316 for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 14:40:43 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 29853304053
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 12:42:48 -0800 (PST)
Subject: [PATCH 11/12] xfsprogs: fix up the nametable code in db/metadump.c
From: Alex Elder <aelder@sgi.com>
Date: Thu, 30 Dec 2010 14:42:47 -0600
Message-ID: <1293741767.2294.373.camel@doink>
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

The name table used to find duplicates in metadump.c is allocated
dynamically, but there's no real need to do so.  Just make it a BSS
global array and drop the initialization call.

Meanwhile, encapsulate the code that add entries to and look up
entries in the table into their own functions.  Use the lookup
function to detect a duplicate name in a case not previously
checked.

Change the naming scheme to use "nametable" as a prefix rather than
a suffix.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 db/metadump.c |  118 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 66 insertions(+), 52 deletions(-)

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
@@ -421,7 +452,6 @@ generate_obfuscated_name(
 	uchar_t			*name)
 {
 	xfs_dahash_t		hash;
-	name_ent_t		*p;
 	int			dup = 0;
 	uchar_t			newname[NAME_MAX];
 
@@ -519,38 +549,31 @@ generate_obfuscated_name(
 		 * Search the name table to be sure we don't produce
 		 * a name that's already been used.
 		 */
-		for (p = nametable[hash % NAME_TABLE_SIZE]; p; p = p->next) {
-			if (p->hash == hash && p->namelen == namelen &&
-					!memcmp(p->name, newname, namelen))
-				break;
-		}
-		if (p)
+		if (nametable_find(hash, namelen, newname))
 		    	dup++;
 		else
 		    	dup = 0;
 	} while (dup && dup < DUP_MAX);
 
-	/* Use the original name if we got too many dups. */
-
-	newp = dup ? name : newname;
-
-	/* Create an entry for the name in the name table */
-
-	p = malloc(sizeof(name_ent_t) + namelen);
-	if (p == NULL)
+	/*
+	 * Create an entry for the name in the name table.  Use the
+	 * original name if we got too many dups.
+	 */
+	if (! nametable_add(hash, namelen, dup ? name : newname))
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
-	if (newp != name)
-		memcpy(name, newp, namelen);
+	/*
+	 * Update the caller's copy with the obfuscated name.
+	 * Warn if we previously managed to create an obfuscated
+	 * name that matches the one we're working on.
+	 */
+	if (! dup)
+		memcpy(name, newname, namelen);
+	else if (nametable_find(hash, namelen, newname))
+		print_warning("duplicate name \"%s\" for inode %llu "
+				"in dir inode %llu\n",
+			name, (unsigned long long) ino,
+			(unsigned long long) cur_ino);
 }
 
 static void
@@ -1253,7 +1276,7 @@ process_inode(
 			break;
 		default: ;
 	}
-	clear_nametable();
+	nametable_clear();
 
 	/* copy extended attributes if they exist and forkoff is valid */
 	if (success && XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
@@ -1272,7 +1295,7 @@ process_inode(
 				success = process_btinode(dip, TYP_ATTR);
 				break;
 		}
-		clear_nametable();
+		nametable_clear();
 	}
 	return success;
 }
@@ -1675,12 +1698,6 @@ metadump_f(
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
@@ -1690,7 +1707,6 @@ metadump_f(
 	if (strcmp(argv[optind], "-") == 0) {
 		if (isatty(fileno(stdout))) {
 			print_warning("cannot write to a terminal");
-			free(nametable);
 			free(metablock);
 			return 0;
 		}
@@ -1699,7 +1715,6 @@ metadump_f(
 		outf = fopen(argv[optind], "wb");
 		if (outf == NULL) {
 			print_warning("cannot create dump file");
-			free(nametable);
 			free(metablock);
 			return 0;
 		}
@@ -1736,7 +1751,6 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 
-	free(nametable);
 	free(metablock);
 
 	return 0;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
