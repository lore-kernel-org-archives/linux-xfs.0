Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8300B7F37
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 19:30:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 68A698F806F
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 17:30:19 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	h1EOlVLqQmadShOI for <xfs@oss.sgi.com>;
	Mon, 20 Jan 2014 17:30:16 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W5QAP-0006ar-5C
	for xfs@oss.sgi.com; Tue, 21 Jan 2014 12:30:13 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W5QAP-0002IF-3v
	for xfs@oss.sgi.com; Tue, 21 Jan 2014 12:30:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs_repair: add support for validating dirent ftype field
Date: Tue, 21 Jan 2014 12:30:13 +1100
Message-Id: <1390267813-8781-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Add code to track the filetype of an inode from phase 3 when all the
inodes are scanned throught to phase 6 when the directory structure
is validated and corrected.

Add code to phase 6 shortform and long form directory entry
validation to read the ftype from the dirent, lookup the inode
record and check they are the same. If they aren't and we are in
no-modify mode, issue a warning such as:

Phase 6 - check inode connectivity...
        - traversing filesystem ...
would fix ftype mismatch (5/1) in directory/child inode 64/68
        - traversal finished ...
        - moving disconnected inodes to lost+found ...

If we are fixing the problem:

Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
fixing ftype mismatch (5/1) in directory/child inode 64/68
        - traversal finished ...
        - moving disconnected inodes to lost+found ...

Note that this is from a leaf form directory entry that was
intentionally corrupted with xfs_db like so:

xfs_db> inode 64
xfs_db> a u3.bmx[0].startblock
xfs_db> p
....
du[3].inumber = 68
du[3].namelen = 11
du[3].name = "syscalltest"
du[3].filetype = 1
du[3].tag = 0x70
....
xfs_db> write du[3].filetype 5
du[3].filetype = 5
xfs_db> quit

Shortform directory entry repair was tested in a similar fashion.

Further, track the ftype in the directory hash table that is build,
so if the directory is rebuild from scratch it has the necessary
ftype information to rebuild the directory correctly. Further, if we
detect a ftype mismatch, update the entry in the hash so that later
directory errors that lead to it being rebuilt use the corrected
ftype field, not the bad one.

Note that this code pulls in some kernel side code that is currently
in kernel private locations (xfs_mode_to_ftype table), so there'll
be some kernel/userspace sync work needed to bring these back into
line.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_dir2.h   |  3 ++
 libxfs/xfs_dir2.c    | 16 +++++++++
 repair/dino_chunks.c | 11 +++++++
 repair/incore.h      | 27 ++++++++++++++-
 repair/incore_ino.c  | 29 ++++++++++++++---
 repair/phase6.c      | 92 ++++++++++++++++++++++++++++++++++++++++++++++++----
 repair/scan.c        |  4 +--
 7 files changed, 168 insertions(+), 14 deletions(-)

diff --git a/include/xfs_dir2.h b/include/xfs_dir2.h
index 9910401..3900130 100644
--- a/include/xfs_dir2.h
+++ b/include/xfs_dir2.h
@@ -57,6 +57,9 @@ extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, uint resblks);
 
+#define S_SHIFT 12
+extern const unsigned char xfs_mode_to_ftype[];
+
 /*
  * Direct call from the bmap code, bypassing the generic directory layer.
  */
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 96a3c1d..4c8c836 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -20,6 +20,22 @@
 
 struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
 
+/*
+ * @mode, if set, indicates that the type field needs to be set up.
+ * This uses the transformation from file mode to DT_* as defined in linux/fs.h
+ * for file type specification. This will be propagated into the directory
+ * structure if appropriate for the given operation and filesystem config.
+ */
+const unsigned char xfs_mode_to_ftype[S_IFMT >> S_SHIFT] = {
+	[0]			= XFS_DIR3_FT_UNKNOWN,
+	[S_IFREG >> S_SHIFT]	= XFS_DIR3_FT_REG_FILE,
+	[S_IFDIR >> S_SHIFT]	= XFS_DIR3_FT_DIR,
+	[S_IFCHR >> S_SHIFT]	= XFS_DIR3_FT_CHRDEV,
+	[S_IFBLK >> S_SHIFT]	= XFS_DIR3_FT_BLKDEV,
+	[S_IFIFO >> S_SHIFT]	= XFS_DIR3_FT_FIFO,
+	[S_IFSOCK >> S_SHIFT]	= XFS_DIR3_FT_SOCK,
+	[S_IFLNK >> S_SHIFT]	= XFS_DIR3_FT_SYMLINK,
+};
 
 /*
  * ASCII case-insensitive (ie. A-Z) support for directories that was
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index d3c2236..65281e4 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -788,6 +788,8 @@ process_inode_chunk(
 		 * we do now, this is where to start.
 		 */
 		if (is_used)  {
+			__uint16_t	di_mode;
+
 			if (is_inode_free(ino_rec, irec_offset))  {
 				if (verbose || no_modify)  {
 					do_warn(
@@ -803,6 +805,15 @@ process_inode_chunk(
 			set_inode_used(ino_rec, irec_offset);
 
 			/*
+			 * store the on-disk file type for comparing in
+			 * phase 6.
+			 */
+			di_mode = be16_to_cpu(dino->di_mode);
+			di_mode = (di_mode & S_IFMT) >> S_SHIFT;
+			set_inode_ftype(ino_rec, irec_offset,
+					xfs_mode_to_ftype[di_mode]);
+
+			/*
 			 * store on-disk nlink count for comparing in phase 7
 			 */
 			set_inode_disk_nlinks(ino_rec, irec_offset,
diff --git a/repair/incore.h b/repair/incore.h
index 38caa6d..5419884 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -293,6 +293,7 @@ typedef struct ino_tree_node  {
 		ino_ex_data_t	*ex_data;	/* phases 6,7 */
 		parent_list_t	*plist;		/* phases 2-5 */
 	} ino_un;
+	__uint8_t		*ftypes;	/* phases 3,6 */
 } ino_tree_node_t;
 
 #define INOS_PER_IREC	(sizeof(__uint64_t) * NBBY)
@@ -359,7 +360,8 @@ ino_tree_node_t		*find_uncertain_inode_rec(xfs_agnumber_t agno,
 						xfs_agino_t ino);
 void			add_inode_uncertain(xfs_mount_t *mp,
 						xfs_ino_t ino, int free);
-void			add_aginode_uncertain(xfs_agnumber_t agno,
+void			add_aginode_uncertain(struct xfs_mount *mp,
+						xfs_agnumber_t agno,
 						xfs_agino_t agino, int free);
 void			get_uncertain_inode_rec(struct xfs_mount *mp,
 						xfs_agnumber_t agno,
@@ -476,6 +478,29 @@ static inline void add_inode_reached(struct ino_tree_node *irec, int offset)
 }
 
 /*
+ * get/set inode filetype. Only used if the superblock feature bit is set
+ * which allocates irec->ftypes.
+ */
+static inline void
+set_inode_ftype(struct ino_tree_node *irec,
+	int		ino_offset,
+	__uint8_t	ftype)
+{
+	if (irec->ftypes)
+		irec->ftypes[ino_offset] = ftype;
+}
+
+static inline __uint8_t
+get_inode_ftype(
+	struct ino_tree_node *irec,
+	int		ino_offset)
+{
+	if (!irec->ftypes)
+		return XFS_DIR3_FT_UNKNOWN;
+	return irec->ftypes[ino_offset];
+}
+
+/*
  * set/get inode number of parent -- works for directory inodes only
  */
 void		set_inode_parent(ino_tree_node_t *irec, int ino_offset,
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 735737a..9200075 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -211,6 +211,21 @@ __uint32_t get_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset)
 	return 0;
 }
 
+static __uint8_t *
+alloc_ftypes_array(
+	struct xfs_mount *mp)
+{
+	__uint8_t	*ptr;
+
+	if (!xfs_sb_version_hasftype(&mp->m_sb))
+		return NULL;
+
+	ptr = calloc(XFS_INODES_PER_CHUNK, sizeof(*ptr));
+	if (!ptr)
+		do_error(_("could not allocate ftypes array\n"));
+	return ptr;
+}
+
 /*
  * Next is the uncertain inode list -- a sorted (in ascending order)
  * list of inode records sorted on the starting inode number.  There
@@ -226,6 +241,7 @@ __uint32_t get_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset)
  */
 static struct ino_tree_node *
 alloc_ino_node(
+	struct xfs_mount	*mp,
 	xfs_agino_t		starting_ino)
 {
 	struct ino_tree_node 	*irec;
@@ -245,6 +261,7 @@ alloc_ino_node(
 	irec->ino_un.ex_data = NULL;
 	irec->nlink_size = sizeof(__uint8_t);
 	irec->disk_nlinks.un8 = alloc_nlink_array(irec->nlink_size);
+	irec->ftypes = alloc_ftypes_array(mp);
 	return irec;
 }
 
@@ -303,7 +320,11 @@ static ino_tree_node_t **last_rec;
  * free is set to 1 if the inode is thought to be free, 0 if used
  */
 void
-add_aginode_uncertain(xfs_agnumber_t agno, xfs_agino_t ino, int free)
+add_aginode_uncertain(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		ino,
+	int			free)
 {
 	ino_tree_node_t		*ino_rec;
 	xfs_agino_t		s_ino;
@@ -334,7 +355,7 @@ add_aginode_uncertain(xfs_agnumber_t agno, xfs_agino_t ino, int free)
 	ino_rec = (ino_tree_node_t *)
 		avl_findrange(inode_uncertain_tree_ptrs[agno], s_ino);
 	if (!ino_rec) {
-		ino_rec = alloc_ino_node(s_ino);
+		ino_rec = alloc_ino_node(mp, s_ino);
 
 		if (!avl_insert(inode_uncertain_tree_ptrs[agno],
 				&ino_rec->avl_node))
@@ -360,7 +381,7 @@ add_aginode_uncertain(xfs_agnumber_t agno, xfs_agino_t ino, int free)
 void
 add_inode_uncertain(xfs_mount_t *mp, xfs_ino_t ino, int free)
 {
-	add_aginode_uncertain(XFS_INO_TO_AGNO(mp, ino),
+	add_aginode_uncertain(mp, XFS_INO_TO_AGNO(mp, ino),
 				XFS_INO_TO_AGINO(mp, ino), free);
 }
 
@@ -432,7 +453,7 @@ add_inode(
 {
 	struct ino_tree_node	*irec;
 
-	irec = alloc_ino_node(agino);
+	irec = alloc_ino_node(mp, agino);
 	if (!avl_insert(inode_tree_ptrs[agno],	&irec->avl_node))
 		do_warn(_("add_inode - duplicate inode range\n"));
 	return irec;
diff --git a/repair/phase6.c b/repair/phase6.c
index d2d4a44..ea608a1 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -134,7 +134,8 @@ dir_hash_add(
 	__uint32_t		addr,
 	xfs_ino_t		inum,
 	int			namelen,
-	unsigned char		*name)
+	unsigned char		*name,
+	__uint8_t		ftype)
 {
 	xfs_dahash_t		hash = 0;
 	int			byaddr;
@@ -148,6 +149,7 @@ dir_hash_add(
 
 	xname.name = name;
 	xname.len = namelen;
+	xname.type = ftype;
 
 	junk = name[0] == '/';
 	byaddr = DIR_HASH_FUNC(hashtab, addr);
@@ -312,6 +314,23 @@ dir_hash_see(
 	return DIR_HASH_CK_NODATA;
 }
 
+static void
+dir_hash_update_ftype(
+	dir_hash_tab_t		*hashtab,
+	xfs_dir2_dataptr_t	addr,
+	__uint8_t		ftype)
+{
+	int			i;
+	dir_hash_ent_t		*p;
+
+	i = DIR_HASH_FUNC(hashtab, addr);
+	for (p = hashtab->byaddr[i]; p; p = p->nextbyaddr) {
+		if (p->address != addr)
+			continue;
+		p->name.type = ftype;
+	}
+}
+
 /*
  * checks to make sure leafs match a data entry, and that the stale
  * count is valid.
@@ -1685,11 +1704,12 @@ longform_dir2_entry_check_data(
 			if (!orphanage_ino)
 				orphanage_ino = inum;
 		}
+
 		/*
 		 * check for duplicate names in directory.
 		 */
 		if (!dir_hash_add(mp, hashtab, addr, inum, dep->namelen,
-							dep->name)) {
+				dep->name, xfs_dir3_dirent_get_ftype(mp, dep))) {
 			nbad++;
 			if (entry_junked(
 	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
@@ -1763,6 +1783,35 @@ longform_dir2_entry_check_data(
 		 */
 		if (no_modify && verify_inum(mp, inum))
 			continue;
+
+		/* validate ftype field if supported */
+		if (xfs_sb_version_hasftype(&mp->m_sb)) {
+			__uint8_t dir_ftype;
+			__uint8_t ino_ftype;
+
+			dir_ftype = xfs_dir3_dirent_get_ftype(mp, dep);
+			ino_ftype = get_inode_ftype(irec, ino_offset);
+
+			if (dir_ftype != ino_ftype) {
+				if (no_modify) {
+					do_warn(
+	_("would fix ftype mismatch (%d/%d) in directory/child inode %" PRIu64 "/%" PRIu64 "\n"),
+						dir_ftype, ino_ftype,
+						ip->i_ino, inum);
+				} else {
+					do_warn(
+	_("fixing ftype mismatch (%d/%d) in directory/child inode %" PRIu64 "/%" PRIu64 "\n"),
+						dir_ftype, ino_ftype,
+						ip->i_ino, inum);
+					xfs_dir3_dirent_put_ftype(mp, dep,
+								ino_ftype);
+					libxfs_dir2_data_log_entry(tp, bp, dep);
+					dir_hash_update_ftype(hashtab, addr,
+							      ino_ftype);
+				}
+			}
+		}
+
 		/*
 		 * check easy case first, regular inode, just bump
 		 * the link count and continue
@@ -2381,7 +2430,8 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 		 */
 		if (!dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
 				(sfep - xfs_dir2_sf_firstentry(sfp)),
-				lino, sfep->namelen, sfep->name)) {
+				lino, sfep->namelen, sfep->name,
+				xfs_dir3_sfe_get_ftype(mp, sfp, sfep))) {
 			do_warn(
 _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 				fname, lino, ino);
@@ -2403,11 +2453,11 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 			 * the .. in the child, blow out the entry
 			 */
 			if (is_inode_reached(irec, ino_offset))  {
-				junkit = 1;
 				do_warn(
 	_("entry \"%s\" in directory inode %" PRIu64
 	  " references already connected inode %" PRIu64 ".\n"),
 					fname, ino, lino);
+				goto do_junkit;
 			} else if (parent == ino)  {
 				add_inode_reached(irec, ino_offset);
 				add_inode_ref(current_irec, current_ino_offset);
@@ -2423,12 +2473,41 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 				add_dotdot_update(XFS_INO_TO_AGNO(mp, lino),
 							irec, ino_offset);
 			} else  {
-				junkit = 1;
 				do_warn(
 	_("entry \"%s\" in directory inode %" PRIu64
 	  " not consistent with .. value (%" PRIu64
 	  ") in inode %" PRIu64 ",\n"),
 					fname, ino, parent, lino);
+				goto do_junkit;
+			}
+		}
+
+		/* validate ftype field if supported */
+		if (xfs_sb_version_hasftype(&mp->m_sb)) {
+			__uint8_t dir_ftype;
+			__uint8_t ino_ftype;
+
+			dir_ftype = xfs_dir3_sfe_get_ftype(mp, sfp, sfep);
+			ino_ftype = get_inode_ftype(irec, ino_offset);
+
+			if (dir_ftype != ino_ftype) {
+				if (no_modify) {
+					do_warn(
+	_("would fix ftype mismatch (%d/%d) in directory/child inode %" PRIu64 "/%" PRIu64 "\n"),
+						dir_ftype, ino_ftype,
+						ino, lino);
+				} else {
+					do_warn(
+	_("fixing ftype mismatch (%d/%d) in directory/child inode %" PRIu64 "/%" PRIu64 "\n"),
+						dir_ftype, ino_ftype,
+						ino, lino);
+					xfs_dir3_sfe_put_ftype(mp, sfp, sfep,
+								ino_ftype);
+					dir_hash_update_ftype(hashtab,
+			(xfs_dir2_dataptr_t)(sfep - xfs_dir2_sf_firstentry(sfp)),
+							      ino_ftype);
+					*ino_dirty = 1;
+				}
 			}
 		}
 
@@ -2518,8 +2597,7 @@ do_junkit:
 	/*
 	 * sync up sizes if required
 	 */
-	if (*ino_dirty)  {
-		ASSERT(bytes_deleted > 0);
+	if (*ino_dirty && bytes_deleted > 0)  {
 		ASSERT(!no_modify);
 		libxfs_idata_realloc(ip, -bytes_deleted, XFS_DATA_FORK);
 		ip->i_d.di_size -= bytes_deleted;
diff --git a/repair/scan.c b/repair/scan.c
index 49ed194..73b4581 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -866,9 +866,9 @@ _("inode rec for ino %" PRIu64 " (%d/%d) overlaps existing rec (start %d/%d)\n")
 		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
 			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
 				nfree++;
-				add_aginode_uncertain(agno, ino + j, 1);
+				add_aginode_uncertain(mp, agno, ino + j, 1);
 			} else  {
-				add_aginode_uncertain(agno, ino + j, 0);
+				add_aginode_uncertain(mp, agno, ino + j, 0);
 			}
 		}
 	}
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
