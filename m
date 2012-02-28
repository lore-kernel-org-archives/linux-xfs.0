Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1SHgTXb208082 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 11:42:31 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	S1bDAju5h26qyESr (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 09:42:25 -0800 (PST)
Date: Tue, 28 Feb 2012 12:42:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] repair: fix the variable-width nlink array
Message-ID: <20120228174223.GA6148@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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

It looks like we currently never grow the variable-width nlink array
if only the on-disk nlink size overflows 8 bits.  This leads to a major
mess in nlink counting, and eventually an assert in phase7.

Replace the indirect all mess with a union that allows doing proper
array arithmetics while we're at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/repair/incore.h b/repair/incore.h
index fdb7742..8a578b5 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -268,11 +268,17 @@ typedef struct parent_list  {
 #endif
 } parent_list_t;
 
+union ino_nlink {
+	__uint8_t	*un8;
+	__uint16_t	*un16;
+	__uint32_t	*un32;
+};
+
 typedef struct ino_ex_data  {
 	__uint64_t		ino_reached;	/* bit == 1 if reached */
 	__uint64_t		ino_processed;	/* reference checked bit mask */
 	parent_list_t		*parents;
-	__uint8_t		*counted_nlinks;/* counted nlinks in P6 */
+	union ino_nlink		counted_nlinks;/* counted nlinks in P6 */
 } ino_ex_data_t;
 
 typedef struct ino_tree_node  {
@@ -281,8 +287,8 @@ typedef struct ino_tree_node  {
 	xfs_inofree_t		ir_free;	/* inode free bit mask */
 	__uint64_t		ino_confirmed;	/* confirmed bitmask */
 	__uint64_t		ino_isa_dir;	/* bit == 1 if a directory */
-	struct nlink_ops	*nlinkops;	/* pointer to current nlink ops */
-	__uint8_t		*disk_nlinks;	/* on-disk nlinks, set in P3 */
+	__uint8_t		nlink_size;
+	union ino_nlink		disk_nlinks;	/* on-disk nlinks, set in P3 */
 	union  {
 		ino_ex_data_t	*ex_data;	/* phases 6,7 */
 		parent_list_t	*plist;		/* phases 2-5 */
@@ -292,16 +298,6 @@ typedef struct ino_tree_node  {
 #define INOS_PER_IREC	(sizeof(__uint64_t) * NBBY)
 #define	IREC_MASK(i)	((__uint64_t)1 << (i))
 
-typedef struct nlink_ops {
-	const int	nlink_size;
-	void		(*disk_nlink_set)(ino_tree_node_t *, int, __uint32_t);
-	__uint32_t	(*disk_nlink_get)(ino_tree_node_t *, int);
-	__uint32_t	(*counted_nlink_get)(ino_tree_node_t *, int);
-	__uint32_t	(*counted_nlink_inc)(ino_tree_node_t *, int);
-	__uint32_t	(*counted_nlink_dec)(ino_tree_node_t *, int);
-} nlink_ops_t;
-
-
 void		add_ino_ex_data(xfs_mount_t *mp);
 
 /*
@@ -460,29 +456,12 @@ static inline int is_inode_free(struct ino_tree_node *irec, int offset)
  * detected and drop_inode_ref() is called every time a link to
  * an inode that we've counted is removed.
  */
+void add_inode_ref(struct ino_tree_node *irec, int offset);
+void drop_inode_ref(struct ino_tree_node *irec, int offset);
+__uint32_t num_inode_references(struct ino_tree_node *irec, int offset);
 
-static inline void add_inode_ref(struct ino_tree_node *irec, int offset)
-{
-	ASSERT(irec->ino_un.ex_data != NULL);
-
-	irec->nlinkops->counted_nlink_inc(irec, offset);
-}
-
-static inline void drop_inode_ref(struct ino_tree_node *irec, int offset)
-{
-	ASSERT(irec->ino_un.ex_data != NULL);
-
-	if (irec->nlinkops->counted_nlink_dec(irec, offset) == 0)
-		irec->ino_un.ex_data->ino_reached &= ~IREC_MASK(offset);
-}
-
-static inline __uint32_t num_inode_references(struct ino_tree_node *irec,
-		int offset)
-{
-	ASSERT(irec->ino_un.ex_data != NULL);
-
-	return irec->nlinkops->counted_nlink_get(irec, offset);
-}
+void set_inode_disk_nlinks(struct ino_tree_node *irec, int offset, __uint32_t nlinks);
+__uint32_t get_inode_disk_nlinks(struct ino_tree_node *irec, int offset);
 
 static inline int is_inode_reached(struct ino_tree_node *irec, int offset)
 {
@@ -496,18 +475,6 @@ static inline void add_inode_reached(struct ino_tree_node *irec, int offset)
 	irec->ino_un.ex_data->ino_reached |= IREC_MASK(offset);
 }
 
-static inline void set_inode_disk_nlinks(struct ino_tree_node *irec, int offset,
-		__uint32_t nlinks)
-{
-	irec->nlinkops->disk_nlink_set(irec, offset, nlinks);
-}
-
-static inline __uint32_t get_inode_disk_nlinks(struct ino_tree_node *irec,
-		int offset)
-{
-	return irec->nlinkops->disk_nlink_get(irec, offset);
-}
-
 /*
  * set/get inode number of parent -- works for directory inodes only
  */
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index b933765..2a40727 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -37,189 +37,176 @@ static avltree_desc_t	**inode_uncertain_tree_ptrs;
 
 /* memory optimised nlink counting for all inodes */
 
-static void nlink_grow_8_to_16(ino_tree_node_t *irec);
-static void nlink_grow_16_to_32(ino_tree_node_t *irec);
-
-static void
-disk_nlink_32_set(ino_tree_node_t *irec, int ino_offset, __uint32_t nlinks)
+static void *
+alloc_nlink_array(__uint8_t nlink_size)
 {
-	((__uint32_t*)irec->disk_nlinks)[ino_offset] = nlinks;
-}
+	void *ptr;
 
-static __uint32_t
-disk_nlink_32_get(ino_tree_node_t *irec, int ino_offset)
-{
-	return ((__uint32_t*)irec->disk_nlinks)[ino_offset];
+	ptr = calloc(XFS_INODES_PER_CHUNK, nlink_size);
+	if (!ptr)
+		do_error(_("could not allocate nlink array\n"));
+	return ptr;
 }
 
-static __uint32_t
-counted_nlink_32_get(ino_tree_node_t *irec, int ino_offset)
+static void
+nlink_grow_8_to_16(ino_tree_node_t *irec)
 {
-	return ((__uint32_t*)irec->ino_un.ex_data->counted_nlinks)[ino_offset];
-}
+	__uint16_t	*new_nlinks;
+	int		i;
 
-static __uint32_t
-counted_nlink_32_inc(ino_tree_node_t *irec, int ino_offset)
-{
-	return ++(((__uint32_t*)irec->ino_un.ex_data->counted_nlinks)[ino_offset]);
-}
+	irec->nlink_size = sizeof(__uint16_t);
 
-static __uint32_t
-counted_nlink_32_dec(ino_tree_node_t *irec, int ino_offset)
-{
-	__uint32_t *nlinks = (__uint32_t*)irec->ino_un.ex_data->counted_nlinks;
+	new_nlinks = alloc_nlink_array(irec->nlink_size);
+	for (i = 0; i < XFS_INODES_PER_CHUNK; i++)
+		new_nlinks[i] = irec->disk_nlinks.un8[i];
+	free(irec->disk_nlinks.un8);
+	irec->disk_nlinks.un16 = new_nlinks;
 
-	ASSERT(nlinks[ino_offset] > 0);
-	return --(nlinks[ino_offset]);
+	if (full_ino_ex_data) {
+		new_nlinks = alloc_nlink_array(irec->nlink_size);
+		for (i = 0; i < XFS_INODES_PER_CHUNK; i++) {
+			new_nlinks[i] =
+				irec->ino_un.ex_data->counted_nlinks.un8[i];
+		}
+		free(irec->ino_un.ex_data->counted_nlinks.un8);
+		irec->ino_un.ex_data->counted_nlinks.un16 = new_nlinks;
+	}
 }
 
-
 static void
-disk_nlink_16_set(ino_tree_node_t *irec, int ino_offset, __uint32_t nlinks)
+nlink_grow_16_to_32(ino_tree_node_t *irec)
 {
-	if (nlinks >= 0x10000) {
-		nlink_grow_16_to_32(irec);
-		disk_nlink_32_set(irec, ino_offset, nlinks);
-	} else
-		((__uint16_t*)irec->disk_nlinks)[ino_offset] = nlinks;
-}
+	__uint32_t	*new_nlinks;
+	int		i;
 
-static __uint32_t
-disk_nlink_16_get(ino_tree_node_t *irec, int ino_offset)
-{
-	return ((__uint16_t*)irec->disk_nlinks)[ino_offset];
-}
+	irec->nlink_size = sizeof(__uint32_t);
 
-static __uint32_t
-counted_nlink_16_get(ino_tree_node_t *irec, int ino_offset)
-{
-	return ((__uint16_t*)irec->ino_un.ex_data->counted_nlinks)[ino_offset];
-}
+	new_nlinks = alloc_nlink_array(irec->nlink_size);
+	for (i = 0; i < XFS_INODES_PER_CHUNK; i++)
+		new_nlinks[i] = irec->disk_nlinks.un16[i];
+	free(irec->disk_nlinks.un16);
+	irec->disk_nlinks.un32 = new_nlinks;
 
-static __uint32_t
-counted_nlink_16_inc(ino_tree_node_t *irec, int ino_offset)
-{
-	__uint16_t *nlinks = (__uint16_t*)irec->ino_un.ex_data->counted_nlinks;
+	if (full_ino_ex_data) {
+		new_nlinks = alloc_nlink_array(irec->nlink_size);
 
-	if (nlinks[ino_offset] == 0xffff) {
-		nlink_grow_16_to_32(irec);
-		return counted_nlink_32_inc(irec, ino_offset);
+		for (i = 0; i < XFS_INODES_PER_CHUNK; i++) {
+			new_nlinks[i] =
+				irec->ino_un.ex_data->counted_nlinks.un16[i];
+		}
+		free(irec->ino_un.ex_data->counted_nlinks.un16);
+		irec->ino_un.ex_data->counted_nlinks.un32 = new_nlinks;
 	}
-	return ++(nlinks[ino_offset]);
 }
 
-static __uint32_t
-counted_nlink_16_dec(ino_tree_node_t *irec, int ino_offset)
+void add_inode_ref(struct ino_tree_node *irec, int ino_offset)
 {
-	__uint16_t *nlinks = (__uint16_t*)irec->ino_un.ex_data->counted_nlinks;
-
-	ASSERT(nlinks[ino_offset] > 0);
-	return --(nlinks[ino_offset]);
-}
-
+	ASSERT(irec->ino_un.ex_data != NULL);
 
-static void
-disk_nlink_8_set(ino_tree_node_t *irec, int ino_offset, __uint32_t nlinks)
-{
-	if (nlinks >= 0x100) {
+	switch (irec->nlink_size) {
+	case sizeof(__uint8_t):
+		if (irec->ino_un.ex_data->counted_nlinks.un8[ino_offset] < 0xff) {
+			irec->ino_un.ex_data->counted_nlinks.un8[ino_offset]++;
+			break;
+		}
 		nlink_grow_8_to_16(irec);
-		disk_nlink_16_set(irec, ino_offset, nlinks);
-	} else
-		irec->disk_nlinks[ino_offset] = nlinks;
+		/*FALLTHRU*/
+	case sizeof(__uint16_t):
+		if (irec->ino_un.ex_data->counted_nlinks.un16[ino_offset] < 0xffff) {
+			irec->ino_un.ex_data->counted_nlinks.un16[ino_offset]++;
+			break;
+		}
+		nlink_grow_16_to_32(irec);
+		/*FALLTHRU*/
+	case sizeof(__uint32_t):
+		irec->ino_un.ex_data->counted_nlinks.un32[ino_offset]++;
+		break;
+	default:
+		ASSERT(0);
+	}
 }
 
-static __uint32_t
-disk_nlink_8_get(ino_tree_node_t *irec, int ino_offset)
+void drop_inode_ref(struct ino_tree_node *irec, int ino_offset)
 {
-	return irec->disk_nlinks[ino_offset];
-}
+	__uint32_t	refs = 0;
 
-static __uint32_t
-counted_nlink_8_get(ino_tree_node_t *irec, int ino_offset)
-{
-	return irec->ino_un.ex_data->counted_nlinks[ino_offset];
-}
+	ASSERT(irec->ino_un.ex_data != NULL);
 
-static __uint32_t
-counted_nlink_8_inc(ino_tree_node_t *irec, int ino_offset)
-{
-	if (irec->ino_un.ex_data->counted_nlinks[ino_offset] == 0xff) {
-		nlink_grow_8_to_16(irec);
-		return counted_nlink_16_inc(irec, ino_offset);
+	switch (irec->nlink_size) {
+	case sizeof(__uint8_t):
+		ASSERT(irec->ino_un.ex_data->counted_nlinks.un8[ino_offset] > 0);
+		refs = --irec->ino_un.ex_data->counted_nlinks.un8[ino_offset];
+		break;
+	case sizeof(__uint16_t):
+		ASSERT(irec->ino_un.ex_data->counted_nlinks.un16[ino_offset] > 0);
+		refs = --irec->ino_un.ex_data->counted_nlinks.un16[ino_offset];
+		break;
+	case sizeof(__uint32_t):
+		ASSERT(irec->ino_un.ex_data->counted_nlinks.un32[ino_offset] > 0);
+		refs = --irec->ino_un.ex_data->counted_nlinks.un32[ino_offset];
+		break;
+	default:
+		ASSERT(0);
 	}
-	return ++(irec->ino_un.ex_data->counted_nlinks[ino_offset]);
-}
 
-static __uint32_t
-counted_nlink_8_dec(ino_tree_node_t *irec, int ino_offset)
-{
-	ASSERT(irec->ino_un.ex_data->counted_nlinks[ino_offset] > 0);
-	return --(irec->ino_un.ex_data->counted_nlinks[ino_offset]);
+	if (refs == 0)
+		irec->ino_un.ex_data->ino_reached &= ~IREC_MASK(ino_offset);
 }
 
-
-static nlink_ops_t nlinkops[] = {
-	{sizeof(__uint8_t) * XFS_INODES_PER_CHUNK,
-		disk_nlink_8_set, disk_nlink_8_get,
-		counted_nlink_8_get, counted_nlink_8_inc, counted_nlink_8_dec},
-	{sizeof(__uint16_t) * XFS_INODES_PER_CHUNK,
-		disk_nlink_16_set, disk_nlink_16_get,
-		counted_nlink_16_get, counted_nlink_16_inc, counted_nlink_16_dec},
-	{sizeof(__uint32_t) * XFS_INODES_PER_CHUNK,
-		disk_nlink_32_set, disk_nlink_32_get,
-		counted_nlink_32_get, counted_nlink_32_inc, counted_nlink_32_dec},
-};
-
-static void
-nlink_grow_8_to_16(ino_tree_node_t *irec)
+__uint32_t num_inode_references(struct ino_tree_node *irec, int ino_offset)
 {
-	__uint16_t	*new_nlinks;
-	int		i;
+	ASSERT(irec->ino_un.ex_data != NULL);
 
-	new_nlinks = malloc(sizeof(__uint16_t) * XFS_INODES_PER_CHUNK);
-	if (new_nlinks == NULL)
-		do_error(_("could not allocate expanded nlink array\n"));
-	for (i = 0; i < XFS_INODES_PER_CHUNK; i++)
-		new_nlinks[i] = irec->disk_nlinks[i];
-	free(irec->disk_nlinks);
-	irec->disk_nlinks = (__uint8_t*)new_nlinks;
-
-	if (full_ino_ex_data) {
-		new_nlinks = malloc(sizeof(__uint16_t) * XFS_INODES_PER_CHUNK);
-		if (new_nlinks == NULL)
-			do_error(_("could not allocate expanded nlink array\n"));
-		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)
-			new_nlinks[i] = irec->ino_un.ex_data->counted_nlinks[i];
-		free(irec->ino_un.ex_data->counted_nlinks);
-		irec->ino_un.ex_data->counted_nlinks = (__uint8_t*)new_nlinks;
+	switch (irec->nlink_size) {
+	case sizeof(__uint8_t):
+		return irec->ino_un.ex_data->counted_nlinks.un8[ino_offset];
+	case sizeof(__uint16_t):
+		return irec->ino_un.ex_data->counted_nlinks.un16[ino_offset];
+	case sizeof(__uint32_t):
+		return irec->ino_un.ex_data->counted_nlinks.un32[ino_offset];
+	default:
+		ASSERT(0);
 	}
-	irec->nlinkops = &nlinkops[1];
 }
 
-static void
-nlink_grow_16_to_32(ino_tree_node_t *irec)
+void set_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset,
+		__uint32_t nlinks)
 {
-	__uint32_t	*new_nlinks;
-	int		i;
-
-	new_nlinks = malloc(sizeof(__uint32_t) * XFS_INODES_PER_CHUNK);
-	if (new_nlinks == NULL)
-		do_error(_("could not allocate expanded nlink array\n"));
-	for (i = 0; i < XFS_INODES_PER_CHUNK; i++)
-		new_nlinks[i] = ((__int16_t*)&irec->disk_nlinks)[i];
-	free(irec->disk_nlinks);
-	irec->disk_nlinks = (__uint8_t*)new_nlinks;
+	switch (irec->nlink_size) {
+	case sizeof(__uint8_t):
+		if (nlinks < 0xff) {
+			irec->disk_nlinks.un8[ino_offset] = nlinks;
+			break;
+		}
+		nlink_grow_8_to_16(irec);
+		/*FALLTHRU*/
+	case sizeof(__uint16_t):
+		if (nlinks < 0xffff) {
+			irec->disk_nlinks.un16[ino_offset] = nlinks;
+			break;
+		}
+		nlink_grow_16_to_32(irec);
+		/*FALLTHRU*/
+	case sizeof(__uint32_t):
+		irec->disk_nlinks.un32[ino_offset] = nlinks;
+		break;
+	default:
+		ASSERT(0);
+	}
+}
 
-	if (full_ino_ex_data) {
-		new_nlinks = malloc(sizeof(__uint32_t) * XFS_INODES_PER_CHUNK);
-		if (new_nlinks == NULL)
-			do_error(_("could not allocate expanded nlink array\n"));
-		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)
-			new_nlinks[i] = ((__int16_t*)&irec->ino_un.ex_data->counted_nlinks)[i];
-		free(irec->ino_un.ex_data->counted_nlinks);
-		irec->ino_un.ex_data->counted_nlinks = (__uint8_t*)new_nlinks;
+__uint32_t get_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset)
+{
+	switch (irec->nlink_size) {
+	case sizeof(__uint8_t):
+		return irec->disk_nlinks.un8[ino_offset];
+	case sizeof(__uint16_t):
+		return irec->disk_nlinks.un16[ino_offset];
+	case sizeof(__uint32_t):
+		return irec->disk_nlinks.un32[ino_offset];
+	default:
+		ASSERT(0);
 	}
-	irec->nlinkops = &nlinkops[2];
 }
 
 /*
@@ -254,14 +241,30 @@ alloc_ino_node(
 	irec->ino_isa_dir = 0;
 	irec->ir_free = (xfs_inofree_t) - 1;
 	irec->ino_un.ex_data = NULL;
-	irec->nlinkops = &nlinkops[0];
-	irec->disk_nlinks = calloc(1, nlinkops[0].nlink_size);
-	if (!irec->disk_nlinks)
-		do_error(_("could not allocate nlink array\n"));
+	irec->nlink_size = sizeof(__uint8_t);
+	irec->disk_nlinks.un8 = alloc_nlink_array(irec->nlink_size);
 	return irec;
 }
 
 static void
+free_nlink_array(union ino_nlink nlinks, __uint8_t nlink_size)
+{
+	switch (nlink_size) {
+	case sizeof(__uint8_t):
+		free(nlinks.un8);
+		break;
+	case sizeof(__uint16_t):
+		free(nlinks.un16);
+		break;
+	case sizeof(__uint32_t):
+		free(nlinks.un32);
+		break;
+	default:
+		ASSERT(0);
+	}
+}
+
+static void
 free_ino_tree_node(
 	struct ino_tree_node	*irec)
 {
@@ -269,11 +272,12 @@ free_ino_tree_node(
 	irec->avl_node.avl_forw = NULL;
 	irec->avl_node.avl_back = NULL;
 
-	free(irec->disk_nlinks);
+	free_nlink_array(irec->disk_nlinks, irec->nlink_size);
 	if (irec->ino_un.ex_data != NULL)  {
 		if (full_ino_ex_data) {
 			free(irec->ino_un.ex_data->parents);
-			free(irec->ino_un.ex_data->counted_nlinks);
+			free_nlink_array(irec->ino_un.ex_data->counted_nlinks,
+					 irec->nlink_size);
 		}
 		free(irec->ino_un.ex_data);
 
@@ -707,10 +711,23 @@ alloc_ex_data(ino_tree_node_t *irec)
 		do_error(_("could not malloc inode extra data\n"));
 
 	irec->ino_un.ex_data->parents = ptbl;
-	irec->ino_un.ex_data->counted_nlinks = calloc(1, irec->nlinkops->nlink_size);
 
-	if (irec->ino_un.ex_data->counted_nlinks == NULL)
-		do_error(_("could not malloc inode extra data\n"));
+	switch (irec->nlink_size) {
+	case sizeof(__uint8_t):
+		irec->ino_un.ex_data->counted_nlinks.un8 =
+			alloc_nlink_array(irec->nlink_size);
+		break;
+	case sizeof(__uint16_t):
+		irec->ino_un.ex_data->counted_nlinks.un16 =
+			alloc_nlink_array(irec->nlink_size);
+		break;
+	case sizeof(__uint32_t):
+		irec->ino_un.ex_data->counted_nlinks.un32 =
+			alloc_nlink_array(irec->nlink_size);
+		break;
+	default:
+		ASSERT(0);
+	}
 }
 
 void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
