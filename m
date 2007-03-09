Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Mar 2007 22:19:58 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l296Jl6p014723
	for <xfs@oss.sgi.com>; Thu, 8 Mar 2007 22:19:49 -0800
Message-Id: <200703090619.RAA15327@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: [PATCH] New xfs_repair handling for inode nlink counts
Date: Fri, 9 Mar 2007 17:20:28 +1100
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_008F_01C7626F.3C00DD50"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, xfs-dev@sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_008F_01C7626F.3C00DD50
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

The attached patch has 3 parts to it:
 - optimised phase 7 (inode nlink count) speed
 - improved memory usage for inode nlink counts
 - memory usage tracking
 - other speed improvements

Overall, phase 7 is almost instant, and phases 6/7 use less 
memory than current versions of xfs_repair.


The optimised phase 7 involved the patches to:

  dino_chunks.c
      This stores the on-disk nlink count for inodes into the 
      inode tree that is created in phase 3.

  phase7.c
      This compares the on-disk nlink counts read in phase 3
      to the actual count it should be generated in phase 6.
      If they are different, creates a transaction and updates
      the inode on disk. No other disk I/O is generated.

  incore.h
      Added disk_nlinks to ino_tree_node_t structure and renamed
      nlinks to counted_nlinks in the backptrs_t structure.
      Also created set/get_inode_disk_nlinks inline functions.


Due to the massive increase in memory required to store these
counts for each inode in the filesystem, I have implemented 
memory optimisation using a dynamically sized elements for 
each inode cluster. Initially, they start at 8 bits each and
double in bits as required by inodes with large nlink counts.
This implementation uses an "nlinkops" function pointers
to keep CPU usage to a minimum. This is entirely implemented
in incore.h and incore_ino.c.



To measure memory used by various parts xfs_repair, I 
implemented memory tracking in global.h and global.c. Default
is not to compile this in, but can enabled by defining 
TRACK_MEMORY when compiling these two files.



Finally, a small enhancement was made in xfs_repair.c. For 
filesystems that fit within the libxfs block cache, phase 6
6 is now significantly faster by flushing dirty blocks to 
disk rather than purging them from memory and then re-reading
again them during phase 6. The flush is required as the 
libxfs block and inode cache is not unified.

------=_NextPart_000_008F_01C7626F.3C00DD50
Content-Type: application/octet-stream;
	name="improved_repair_nlink_handling.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="improved_repair_nlink_handling.patch"

Index: xfsprogs/repair/globals.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- xfsprogs.orig/repair/globals.c
+++ xfsprogs/repair/globals.c
@@ -20,3 +20,183 @@
=20
 #define EXTERN
 #include "globals.h"
+
+#ifdef TRACK_MEMORY
+
+#undef calloc
+#undef malloc
+#undef memalign
+#undef realloc
+#undef free
+
+/*
+ * Track by file name pointer and also by return pointer
+ */
+
+typedef struct func {
+	const char	*file;
+	int		line;
+	int64_t		acount;
+	int64_t		fcount;
+	int64_t		rcount;
+	int64_t		current;
+	int64_t		peak;
+} func_t;
+
+typedef struct entry {
+	struct entry	*next;
+	func_t		*fileline;
+	size_t		size;
+	void		*ptr;
+} entry_t;
+
+static int	caller_count =3D 0;
+static int	caller_size =3D 0;
+static func_t	*callers =3D NULL;
+
+static entry_t	*ptrhash[256];
+
+static
+void track_alloc(const char *file, int line, size_t size, void *p)
+{
+	int		i;
+	entry_t		*e;
+
+	/* find an existing func call from file/line */
+	for (i =3D 0; i < caller_count; i++) {
+		if ((callers[i].file =3D=3D file) && (callers[i].line =3D=3D line))
+			break;
+	}
+	if (i =3D=3D caller_count) {	/* add new func if not found */
+		if (caller_count =3D=3D caller_size) {
+			caller_size +=3D 64;
+			callers =3D realloc(callers, sizeof(func_t) * caller_size);
+		}
+		memset(&callers[i], 0, sizeof(func_t));
+		callers[i].file =3D file;
+		callers[i].line =3D line;
+		caller_count++;
+	}
+
+	e =3D malloc(sizeof(entry_t));
+	e->size =3D size;
+	e->ptr =3D p;
+	e->fileline =3D &callers[i];
+
+	callers[i].acount++;
+	callers[i].current +=3D size;
+	if (callers[i].current > callers[i].peak)
+		callers[i].peak =3D callers[i].current;
+
+	/* add pointer to hash list, very basic simple hash function */
+	i =3D (((size_t)p) >> 8) & 0xff;
+
+	e->next =3D ptrhash[i];
+	ptrhash[i] =3D e;
+}
+
+void *track_calloc(const char *file, int line, size_t num, size_t size)
+{
+	void *retval =3D calloc(num, size);
+
+	if (retval !=3D NULL)
+		track_alloc(file, line, num * size, retval);
+
+	return retval;
+}
+
+void *track_malloc(const char *file, int line, size_t size)
+{
+	void *retval =3D malloc(size);
+
+	if (retval !=3D NULL)
+		track_alloc(file, line, size, retval);
+
+	return retval;
+}
+
+void *track_memalign(const char *file, int line, size_t boundary, size_t s=
ize)
+{
+	void *retval =3D memalign(boundary, size);
+
+	if (retval !=3D NULL)
+		track_alloc(file, line, size, retval);
+
+	return retval;
+}
+
+void *track_realloc(const char *file, int line, void *ptr, size_t size)
+{
+	int		i;
+	entry_t		*e, *prev;
+	void 		*newptr =3D realloc(ptr, size);
+
+	if (ptr =3D=3D NULL && newptr !=3D NULL) {
+		track_alloc(file, line, size, newptr);
+		return newptr;
+	}
+
+	i =3D (((size_t)ptr) >> 8) & 0xff;
+
+	prev =3D NULL;
+	for (e =3D ptrhash[i]; e; e =3D e->next) {
+		if (e->ptr =3D=3D ptr)
+			break;
+		prev =3D e;
+	}
+	if (!e)
+		return newptr;
+
+	e->fileline->rcount++;
+	e->fileline->current =3D e->fileline->current + size - e->size;
+	if (e->fileline->current > e->fileline->peak)
+		e->fileline->peak =3D e->fileline->current;
+	e->size =3D size;
+	e->ptr =3D newptr;
+
+	return newptr;
+}
+
+void track_free(const char *file, int line, void *ptr)
+{
+	int		i;
+	entry_t	*e, *prev;
+
+	free(ptr);
+
+	/* find associated entry */
+	i =3D (((size_t)ptr) >> 8) & 0xff;
+
+	prev =3D NULL;
+	for (e =3D ptrhash[i]; e; e =3D e->next) {
+		if (e->ptr =3D=3D ptr)
+			break;
+		prev =3D e;
+	}
+	if (!e)
+		return;
+
+	e->fileline->fcount++;
+	e->fileline->current -=3D e->size;
+
+	if (prev)
+		prev->next =3D e->next;
+	else
+		ptrhash[i] =3D e->next;
+	free(e);
+}
+
+void print_memory_usage(void)
+{
+	int i;
+
+	printf("%20s:line \ta_cnt\tf_cnt\tr_cnt\tremain\tpeak\n", "file");
+	for (i =3D 0; i < caller_count; i++) {
+		printf("%20s:%-5d\t%lld\t%lld\t%lld\t%lld\t%lld\n",
+			callers[i].file, callers[i].line,
+			callers[i].acount, callers[i].fcount, callers[i].rcount,
+			callers[i].current, callers[i].peak);
+	}
+}
+
+#endif /* TRACK_MEMORY */
\ No newline at end of file
Index: xfsprogs/repair/globals.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- xfsprogs.orig/repair/globals.h
+++ xfsprogs/repair/globals.h
@@ -16,6 +16,16 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
=20
+#ifdef TRACK_MEMORY
+
+#define calloc(n,s)	track_calloc(__FILE__, __LINE__, (n), (s))
+#define malloc(s)	track_malloc(__FILE__, __LINE__, (s))
+#define memalign(b,s)	track_memalign(__FILE__, __LINE__, (b), (s))
+#define realloc(p,s)	track_realloc(__FILE__, __LINE__, (p), (s))
+#define free(p)		track_free(__FILE__, __LINE__, (p))
+
+#endif
+
 #ifndef _XFS_REPAIR_GLOBAL_H
 #define _XFS_REPAIR_GLOBAL_H
=20
@@ -23,6 +33,21 @@
 #define EXTERN extern
 #endif
=20
+#ifdef TRACK_MEMORY
+
+void print_memory_usage(void);
+void *track_calloc(const char *file, int line, size_t num, size_t size);
+void *track_malloc(const char *file, int line, size_t size);
+void *track_memalign(const char *file, int line, size_t boundary, size_t s=
ize);
+void *track_realloc(const char *file, int line, void *ptr, size_t size);
+void track_free(const char *file, int line, void *ptr);
+
+#else
+
+#define print_memory_usage()	do { } while(0)
+
+#endif
+
 /* useful macros */
=20
 #define rounddown(x, y) (((x)/(y))*(y))
Index: xfsprogs/repair/incore.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- xfsprogs.orig/repair/incore.h
+++ xfsprogs/repair/incore.h
@@ -328,6 +328,8 @@
=20
 typedef xfs_ino_t parent_entry_t;
=20
+struct nlink_ops;
+
 typedef struct parent_list  {
 	__uint64_t		pmask;
 	parent_entry_t		*pentries;
@@ -339,8 +341,8 @@
 typedef struct backptrs  {
 	__uint64_t		ino_reached;	/* bit =3D=3D 1 if reached */
 	__uint64_t		ino_processed;	/* reference checked bit mask */
-	__uint32_t		nlinks[XFS_INODES_PER_CHUNK];
 	parent_list_t		*parents;
+	__uint8_t		counted_nlinks[XFS_INODES_PER_CHUNK];
 } backptrs_t;
=20
 typedef struct ino_tree_node  {
@@ -349,12 +351,24 @@
 	xfs_inofree_t		ir_free;	/* inode free bit mask */
 	__uint64_t		ino_confirmed;	/* confirmed bitmask */
 	__uint64_t		ino_isa_dir;	/* bit =3D=3D 1 if a directory */
+	struct nlink_ops	*nlinkops;	/* pointer to current nlink ops */
+	__uint8_t		*disk_nlinks;	/* pointer to an array of nlinks */
 	union  {
 		backptrs_t	*backptrs;
 		parent_list_t	*plist;
 	} ino_un;
 } ino_tree_node_t;
=20
+typedef struct nlink_ops {
+	const int	nlink_size;
+	void		(*disk_nlink_set)(ino_tree_node_t *, int, __uint32_t);
+	__uint32_t	(*disk_nlink_get)(ino_tree_node_t *, int);
+	__uint32_t	(*counted_nlink_get)(ino_tree_node_t *, int);
+	__uint32_t	(*counted_nlink_inc)(ino_tree_node_t *, int);
+	__uint32_t	(*counted_nlink_dec)(ino_tree_node_t *, int);
+} nlink_ops_t;
+
+
 #define INOS_PER_IREC		(sizeof(__uint64_t) * NBBY)
 void				add_ino_backptrs(xfs_mount_t *mp);
=20
@@ -528,7 +542,7 @@
 {
 	ASSERT(ino_rec->ino_un.backptrs !=3D NULL);
=20
-	ino_rec->ino_un.backptrs->nlinks[ino_offset]++;
+	(*ino_rec->nlinkops->counted_nlink_inc)(ino_rec, ino_offset);
 	XFS_INO_RCHD_SET_RCHD(ino_rec, ino_offset);
=20
 	ASSERT(is_inode_reached(ino_rec, ino_offset));
@@ -539,16 +553,15 @@
 {
 	ASSERT(ino_rec->ino_un.backptrs !=3D NULL);
=20
-	ino_rec->ino_un.backptrs->nlinks[ino_offset]++;
+	(*ino_rec->nlinkops->counted_nlink_inc)(ino_rec, ino_offset);
 }
=20
 static inline void
 drop_inode_ref(ino_tree_node_t *ino_rec, int ino_offset)
 {
 	ASSERT(ino_rec->ino_un.backptrs !=3D NULL);
-	ASSERT(ino_rec->ino_un.backptrs->nlinks[ino_offset] > 0);
=20
-	if (--ino_rec->ino_un.backptrs->nlinks[ino_offset] =3D=3D 0)
+	if ((*ino_rec->nlinkops->counted_nlink_dec)(ino_rec, ino_offset) =3D=3D 0)
 		XFS_INO_RCHD_CLR_RCHD(ino_rec, ino_offset);
 }
=20
@@ -556,14 +569,28 @@
 is_inode_referenced(ino_tree_node_t *ino_rec, int ino_offset)
 {
 	ASSERT(ino_rec->ino_un.backptrs !=3D NULL);
-	return(ino_rec->ino_un.backptrs->nlinks[ino_offset] > 0);
+
+	return (*ino_rec->nlinkops->counted_nlink_get)(ino_rec, ino_offset) > 0;
 }
=20
 static inline __uint32_t
 num_inode_references(ino_tree_node_t *ino_rec, int ino_offset)
 {
 	ASSERT(ino_rec->ino_un.backptrs !=3D NULL);
-	return(ino_rec->ino_un.backptrs->nlinks[ino_offset]);
+
+	return (*ino_rec->nlinkops->counted_nlink_get)(ino_rec, ino_offset);
+}
+
+static inline void
+set_inode_disk_nlinks(ino_tree_node_t *ino_rec, int ino_offset, __uint32_t=
 nlinks)
+{
+	(*ino_rec->nlinkops->disk_nlink_set)(ino_rec, ino_offset, nlinks);
+}
+
+static inline __uint32_t
+get_inode_disk_nlinks(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	return (*ino_rec->nlinkops->disk_nlink_get)(ino_rec, ino_offset);
 }
=20
 /*
Index: xfsprogs/repair/incore_ino.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- xfsprogs.orig/repair/incore_ino.c
+++ xfsprogs/repair/incore_ino.c
@@ -50,6 +50,223 @@
=20
 static ino_flist_t ino_flist;	/* free list must be initialized before use =
*/
=20
+/* memory optimised nlink counting for all inodes */
+
+static void
+nlink_grow_8_to_16(ino_tree_node_t *ino_rec);
+static void
+nlink_grow_16_to_32(ino_tree_node_t *ino_rec);
+
+static void
+disk_nlink_32_set(ino_tree_node_t *ino_rec, int ino_offset, __uint32_t nli=
nks)
+{
+	((__uint32_t*)ino_rec->disk_nlinks)[ino_offset] =3D nlinks;
+}
+
+static __uint32_t
+disk_nlink_32_get(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	return ((__uint32_t*)ino_rec->disk_nlinks)[ino_offset];
+}
+
+static __uint32_t
+counted_nlink_32_get(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	__uint32_t *nlinks =3D (__uint32_t*)&ino_rec->ino_un.backptrs->counted_nl=
inks;
+
+	return nlinks[ino_offset];
+}
+
+static __uint32_t
+counted_nlink_32_inc(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	__uint32_t *nlinks =3D (__uint32_t*)&ino_rec->ino_un.backptrs->counted_nl=
inks;
+
+	return ++(nlinks[ino_offset]);
+}
+
+static __uint32_t
+counted_nlink_32_dec(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	__uint32_t *nlinks =3D (__uint32_t*)&ino_rec->ino_un.backptrs->counted_nl=
inks;
+
+	ASSERT(nlinks[ino_offset] > 0);
+	return --(nlinks[ino_offset]);
+}
+
+
+static void
+disk_nlink_16_set(ino_tree_node_t *ino_rec, int ino_offset, __uint32_t nli=
nks)
+{
+	if (nlinks >=3D 0x10000) {
+		nlink_grow_16_to_32(ino_rec);
+		disk_nlink_32_set(ino_rec, ino_offset, nlinks);
+	} else
+		((__uint16_t*)ino_rec->disk_nlinks)[ino_offset] =3D nlinks;
+}
+
+static __uint32_t
+disk_nlink_16_get(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	return ((__uint16_t*)ino_rec->disk_nlinks)[ino_offset];
+}
+
+static __uint32_t
+counted_nlink_16_get(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	__uint16_t *nlinks =3D (__uint16_t*)&ino_rec->ino_un.backptrs->counted_nl=
inks;
+
+	return nlinks[ino_offset];
+}
+
+static __uint32_t
+counted_nlink_grow_16_to_32(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	int 	i;
+	backptrs_t *grown =3D realloc(ino_rec->ino_un.backptrs,
+			offsetof(backptrs_t, counted_nlinks) +
+				sizeof(__uint32_t) * XFS_INODES_PER_CHUNK);
+	if (grown =3D=3D NULL)
+		do_error(_("couldn't allocate memory for backptrs\n"));
+
+	/* start from end working to start as we are overwriting the array */
+	for (i =3D XFS_INODES_PER_CHUNK-1; i >=3D 0; i--) {
+		((__uint32_t*)&grown->counted_nlinks)[i] =3D
+			((__uint16_t*)&grown->counted_nlinks)[i];
+	}
+	ino_rec->ino_un.backptrs =3D grown;
+	nlink_grow_16_to_32(ino_rec);
+	return ++((__uint32_t*)&grown->counted_nlinks)[ino_offset];
+}
+
+static __uint32_t
+counted_nlink_16_inc(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	__uint16_t *nlinks =3D (__uint16_t*)&ino_rec->ino_un.backptrs->counted_nl=
inks;
+
+	if (nlinks[ino_offset] =3D=3D 0xffff)
+		return counted_nlink_grow_16_to_32(ino_rec, ino_offset);
+	return ++(nlinks[ino_offset]);
+}
+
+static __uint32_t
+counted_nlink_16_dec(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	__uint16_t *nlinks =3D (__uint16_t*)&ino_rec->ino_un.backptrs->counted_nl=
inks;
+
+	ASSERT(nlinks[ino_offset] > 0);
+	return --(nlinks[ino_offset]);
+}
+
+
+static void
+disk_nlink_8_set(ino_tree_node_t *ino_rec, int ino_offset, __uint32_t nlin=
ks)
+{
+	ASSERT(full_backptrs =3D=3D 0);
+
+	if (nlinks >=3D 0x100) {
+		nlink_grow_8_to_16(ino_rec);
+		disk_nlink_16_set(ino_rec, ino_offset, nlinks);
+	} else
+		ino_rec->disk_nlinks[ino_offset] =3D nlinks;
+}
+
+static __uint32_t
+disk_nlink_8_get(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	return ino_rec->disk_nlinks[ino_offset];
+}
+
+static __uint32_t
+counted_nlink_8_get(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	return ino_rec->ino_un.backptrs->counted_nlinks[ino_offset];
+}
+
+static __uint32_t
+counted_nlink_grow_8_to_16(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	int 		i;
+	backptrs_t 	*grown =3D realloc(ino_rec->ino_un.backptrs,
+				offsetof(backptrs_t, counted_nlinks) +
+				sizeof(__uint16_t) * XFS_INODES_PER_CHUNK);
+	if (grown =3D=3D NULL)
+		do_error(_("couldn't allocate memory for backptrs\n"));
+
+	/*
+	 * start from end working to start as we are overwriting the array
+	 */
+	for (i =3D XFS_INODES_PER_CHUNK-1; i >=3D 0; i--) {
+		((__uint16_t*)&grown->counted_nlinks)[i] =3D
+			grown->counted_nlinks[i];
+	}
+	ino_rec->ino_un.backptrs =3D grown;
+	nlink_grow_8_to_16(ino_rec);
+	return ++((__uint16_t*)&grown->counted_nlinks)[ino_offset];
+}
+
+static __uint32_t
+counted_nlink_8_inc(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	if (ino_rec->ino_un.backptrs->counted_nlinks[ino_offset] =3D=3D 0xff)
+		return counted_nlink_grow_8_to_16(ino_rec, ino_offset);
+	return ++(ino_rec->ino_un.backptrs->counted_nlinks[ino_offset]);
+}
+
+static __uint32_t
+counted_nlink_8_dec(ino_tree_node_t *ino_rec, int ino_offset)
+{
+	ASSERT(ino_rec->ino_un.backptrs->counted_nlinks[ino_offset] > 0);
+	return --(ino_rec->ino_un.backptrs->counted_nlinks[ino_offset]);
+}
+
+
+static nlink_ops_t nlinkops[] =3D {
+	{sizeof(__uint8_t) * XFS_INODES_PER_CHUNK,
+		disk_nlink_8_set, disk_nlink_8_get,
+		counted_nlink_8_get, counted_nlink_8_inc, counted_nlink_8_dec},
+	{sizeof(__uint16_t) * XFS_INODES_PER_CHUNK,
+		disk_nlink_16_set, disk_nlink_16_get,
+		counted_nlink_16_get, counted_nlink_16_inc, counted_nlink_16_dec},
+	{sizeof(__uint32_t) * XFS_INODES_PER_CHUNK,
+		disk_nlink_32_set, disk_nlink_32_get,
+		counted_nlink_32_get, counted_nlink_32_inc, counted_nlink_32_dec},
+};
+
+static void
+nlink_grow_8_to_16(ino_tree_node_t *ino_rec)
+{
+	__uint16_t	*new_nlinks;
+	int		i;
+
+	new_nlinks =3D malloc(sizeof(__uint16_t) * XFS_INODES_PER_CHUNK);
+	if (new_nlinks =3D=3D NULL)
+		do_error(_("could not allocate expanded nlink array\n"));
+	for (i =3D 0; i < XFS_INODES_PER_CHUNK; i++)
+		new_nlinks[i] =3D ino_rec->disk_nlinks[i];
+	free(ino_rec->disk_nlinks);
+	ino_rec->disk_nlinks =3D (__uint8_t*)new_nlinks;
+
+	ino_rec->nlinkops =3D &nlinkops[1];
+}
+
+static void
+nlink_grow_16_to_32(ino_tree_node_t *ino_rec)
+{
+	__uint32_t	*new_nlinks;
+	int		i;
+
+	new_nlinks =3D malloc(sizeof(__uint32_t) * XFS_INODES_PER_CHUNK);
+	if (new_nlinks =3D=3D NULL)
+		do_error(_("could not allocate expanded nlink array\n"));
+	for (i =3D 0; i < XFS_INODES_PER_CHUNK; i++)
+		new_nlinks[i] =3D ((__int16_t*)&ino_rec->disk_nlinks)[i];
+	free(ino_rec->disk_nlinks);
+	ino_rec->disk_nlinks =3D (__uint8_t*)new_nlinks;
+
+	ino_rec->nlinkops =3D &nlinkops[2];
+}
+
 /*
  * next is the uncertain inode list -- a sorted (in ascending order)
  * list of inode records sorted on the starting inode number.  There
@@ -104,6 +321,10 @@
 	new->ino_isa_dir =3D 0;
 	new->ir_free =3D (xfs_inofree_t) - 1;
 	new->ino_un.backptrs =3D NULL;
+	new->nlinkops =3D &nlinkops[0];
+	new->disk_nlinks =3D calloc(sizeof(__uint8_t), XFS_INODES_PER_CHUNK);
+	if (new->disk_nlinks =3D=3D NULL)
+		do_error(_("inode nlink array malloc failed\n"));
=20
 	return(new);
 }
@@ -131,6 +352,8 @@
 	ino_flist.list =3D ino_rec;
 	ino_flist.cnt++;
=20
+	free(ino_rec->disk_nlinks);
+
 	if (ino_rec->ino_un.backptrs !=3D NULL)  {
 		if (full_backptrs && ino_rec->ino_un.backptrs->parents !=3D NULL)
 			free(ino_rec->ino_un.backptrs->parents);
@@ -555,73 +778,39 @@
 	return(0LL);
 }
=20
-backptrs_t *
-get_backptr(void)
+void
+alloc_backptr(ino_tree_node_t *irec)
 {
-	backptrs_t *ptr;
-
-	if ((ptr =3D malloc(sizeof(backptrs_t))) =3D=3D NULL)
+	int		size;
+	backptrs_t 	*ptr;
+	parent_list_t 	*tmp;
+
+	tmp =3D irec->ino_un.plist;
+	size =3D offsetof(backptrs_t, counted_nlinks) +
+			irec->nlinkops->nlink_size;
+	irec->ino_un.backptrs =3D (backptrs_t *)malloc(size);
+	if (irec->ino_un.backptrs =3D=3D NULL)
 		do_error(_("could not malloc back pointer table\n"));
=20
-	bzero(ptr, sizeof(backptrs_t));
-
-	return(ptr);
+	memset(irec->ino_un.backptrs, 0, size);
+	irec->ino_un.backptrs->parents =3D tmp;
 }
=20
 void
 add_ino_backptrs(xfs_mount_t *mp)
 {
-#ifdef XR_BCKPTR_DBG
-	xfs_ino_t ino;
-	int j, k;
-#endif /* XR_BCKPTR_DBG */
 	ino_tree_node_t *ino_rec;
-	parent_list_t *tmp;
 	xfs_agnumber_t i;
=20
 	for (i =3D 0; i < mp->m_sb.sb_agcount; i++)  {
 		ino_rec =3D findfirst_inode_rec(i);
=20
 		while (ino_rec !=3D NULL)  {
-			tmp =3D ino_rec->ino_un.plist;
-			ino_rec->ino_un.backptrs =3D get_backptr();
-			ino_rec->ino_un.backptrs->parents =3D tmp;
-
-#ifdef XR_BCKPTR_DBG
-			if (tmp !=3D NULL)  {
-				k =3D 0;
-				for (j =3D 0; j < XFS_INODES_PER_CHUNK; j++)  {
-					ino =3D XFS_AGINO_TO_INO(mp, i,
-						ino_rec->ino_startnum + j);
-					if (ino =3D=3D 25165846)  {
-						do_warn("THERE 1 !!!\n");
-					}
-					if (tmp->pentries[j] !=3D 0)  {
-						k++;
-						do_warn(
-						"inode %llu - parent %llu\n",
-							ino,
-							tmp->pentries[j]);
-						if (ino =3D=3D 25165846)  {
-							do_warn("THERE!!!\n");
-						}
-					}
-				}
-
-				if (k !=3D tmp->cnt)  {
-					do_warn(
-					"ERROR - count =3D %d, counted %d\n",
-						tmp->cnt, k);
-				}
-			}
-#endif /* XR_BCKPTR_DBG */
+			alloc_backptr(ino_rec);
 			ino_rec =3D next_ino_rec(ino_rec);
 		}
 	}
-
 	full_backptrs =3D 1;
-
-	return;
 }
=20
 static __psunsigned_t
Index: xfsprogs/repair/xfs_repair.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- xfsprogs.orig/repair/xfs_repair.c
+++ xfsprogs/repair/xfs_repair.c
@@ -277,7 +277,7 @@
 		case 't':
 			report_interval =3D (int) strtol(optarg, 0, 0);
 			break;
-=09=09=09
+
 		case '?':
 			usage();
 		}
@@ -563,7 +563,7 @@
=20
 	/* XXX: nathans - something in phase4 ain't playing by */
 	/* the buffer cache rules.. why doesn't IRIX hit this? */
-	libxfs_bcache_purge();
+	libxfs_bcache_flush();
=20
 	if (no_modify)
 		printf(_("No modify flag set, skipping phase 5\n"));
@@ -576,6 +576,8 @@
 		phase6(mp);
 		timestamp(PHASE_END, 6, NULL);
=20
+		libxfs_bcache_flush();
+
 		phase7(mp);
 		timestamp(PHASE_END, 7, NULL);
 	} else  {
@@ -640,6 +642,9 @@
 	if (do_parallel && report_interval)
 		stop_progress_rpt();
=20
+	if (verbose > 1)
+		print_memory_usage();
+
 	if (no_modify)  {
 		do_log(
 	_("No modify flag set, skipping filesystem flush and exiting.\n"));
Index: xfsprogs/repair/dino_chunks.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- xfsprogs.orig/repair/dino_chunks.c
+++ xfsprogs/repair/dino_chunks.c
@@ -779,6 +779,13 @@
 					do_warn(_("would correct imap\n"));
 			}
 			set_inode_used(ino_rec, irec_offset);
+			/*
+			 * store on-disk nlink count for comparing in phase 7
+			 */
+			set_inode_disk_nlinks(ino_rec, irec_offset,
+				dino->di_core.di_version > XFS_DINODE_VERSION_1
+					? be32_to_cpu(dino->di_core.di_nlink)
+					: be16_to_cpu(dino->di_core.di_onlink));
 		} else  {
 			set_inode_free(ino_rec, irec_offset);
 		}
Index: xfsprogs/repair/phase7.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- xfsprogs.orig/repair/phase7.c
+++ xfsprogs/repair/phase7.c
@@ -30,91 +30,110 @@
 #include "threads.h"
=20
 /* dinoc is a pointer to the IN-CORE dinode core */
-void
-set_nlinks(xfs_dinode_core_t	*dinoc,
-		xfs_ino_t	ino,
-		__uint32_t	nrefs,
-		int		*dirty)
+static void
+set_nlinks(
+	xfs_dinode_core_t	*dinoc,
+	xfs_ino_t		ino,
+	__uint32_t		nrefs,
+	int			*dirty)
 {
-	if (!no_modify)  {
-		if (dinoc->di_nlink !=3D nrefs)  {
-			*dirty =3D 1;
-			do_warn(
-		_("resetting inode %llu nlinks from %d to %d\n"),
-				ino, dinoc->di_nlink, nrefs);
+	if (dinoc->di_nlink =3D=3D nrefs)
+		return;
=20
-			if (nrefs > XFS_MAXLINK_1)  {
-				ASSERT(fs_inode_nlink);
-				do_warn(
+	if (!no_modify) {
+		*dirty =3D 1;
+		do_warn(_("resetting inode %llu nlinks from %d to %d\n"),
+			ino, dinoc->di_nlink, nrefs);
+
+		if (nrefs > XFS_MAXLINK_1)  {
+			ASSERT(fs_inode_nlink);
+			do_warn(
 _("nlinks %d will overflow v1 ino, ino %llu will be converted to version 2=
\n"),
-					nrefs, ino);
+				nrefs, ino);
=20
-			}
-			dinoc->di_nlink =3D nrefs;
 		}
+		dinoc->di_nlink =3D nrefs;
 	} else  {
-		if (dinoc->di_nlink !=3D nrefs)
+		do_warn(_("would have reset inode %llu nlinks from %d to %d\n"),
+			ino, dinoc->di_nlink, nrefs);
+	}
+}
+
+static void
+update_inode_nlinks(
+	xfs_mount_t 		*mp,
+	xfs_ino_t		ino,
+	__uint32_t		nlinks)
+{
+	xfs_trans_t		*tp;
+	xfs_inode_t		*ip;
+	int			error;
+	int			dirty;
+
+	tp =3D libxfs_trans_alloc(mp, XFS_TRANS_REMOVE);
+
+	error =3D libxfs_trans_reserve(tp, (no_modify ? 0 : 10),
+			XFS_REMOVE_LOG_RES(mp), 0, XFS_TRANS_PERM_LOG_RES,
+			XFS_REMOVE_LOG_COUNT);
+
+	ASSERT(error =3D=3D 0);
+
+	error =3D libxfs_trans_iget(mp, tp, ino, 0, 0, &ip);
+
+	if (error)  {
+		if (!no_modify)
+			do_error(_("couldn't map inode %llu, err =3D %d\n"),
+				ino, error);
+		else  {
 			do_warn(
-			_("would have reset inode %llu nlinks from %d to %d\n"),
-				ino, dinoc->di_nlink, nrefs);
+	_("couldn't map inode %llu, err =3D %d, can't compare link counts\n"),
+				ino, error);
+			return;
+		}
+	}
+
+	dirty =3D 0;
+
+	/*
+	 * compare and set links for all inodes
+	 * but the lost+found inode.  we keep
+	 * that correct as we go.
+	 */
+	if (ino !=3D orphanage_ino)
+		set_nlinks(&ip->i_d, ino, nlinks, &dirty);
+
+	if (!dirty)  {
+		libxfs_trans_iput(tp, ip, 0);
+		libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
+	} else  {
+		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		/*
+		 * no need to do a bmap finish since
+		 * we're not allocating anything
+		 */
+		ASSERT(error =3D=3D 0);
+		error =3D libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES |
+				XFS_TRANS_SYNC, NULL);
+
+		ASSERT(error =3D=3D 0);
 	}
 }
=20
-void
+static void
 phase7_alt_function(xfs_mount_t *mp, xfs_agnumber_t agno)
 {
-	register ino_tree_node_t *irec;
+	ino_tree_node_t 	*irec;
 	int			j;
-	int			chunk_dirty;
-	int			inode_dirty;
-	xfs_ino_t		ino;
 	__uint32_t		nrefs;
-	xfs_agblock_t		agbno;
-	xfs_dinode_t		*dip;
-	ino_tree_node_t 	*ino_ra;
-	xfs_buf_t		*bp;
-
-	if (verbose)
-		do_log(_("        - agno =3D %d\n"), agno);
-
-	ino_ra =3D prefetch_inode_chunks(mp, agno, NULL);
=20
 	/*
-	 * read on-disk inodes in chunks. then,
-	 * look at each on-disk inode 1 at a time.
-	 * if the number of links is bad, reset it.
+	 * using the nlink values memorised during phase3/4, compare to the
+	 * nlink counted in phase 6, and if different, update on-disk.
 	 */
=20
 	irec =3D findfirst_inode_rec(agno);
=20
 	while (irec !=3D NULL)  {
-
-		if (ino_ra && (irec->ino_startnum >=3D ino_ra->ino_startnum))
-			ino_ra =3D prefetch_inode_chunks(mp, agno, ino_ra);
-
-		agbno =3D XFS_AGINO_TO_AGBNO(mp, irec->ino_startnum);
-		bp =3D libxfs_readbuf(mp->m_dev,
-				XFS_AGB_TO_DADDR(mp, agno, agbno),
-				XFS_FSB_TO_BB(mp, XFS_IALLOC_BLOCKS(mp)), 0);
-		if (bp =3D=3D NULL) {
-			if (!no_modify) {
-				do_error(
-	_("cannot read inode %llu, disk block %lld, cnt %d\n"),
-				XFS_AGINO_TO_INO(mp, agno, irec->ino_startnum),
-				XFS_AGB_TO_DADDR(mp, agno, agbno),
-				(int)XFS_FSB_TO_BB(mp, XFS_IALLOC_BLOCKS(mp)));
-				/* NOT REACHED */
-			}
-			do_warn(
-	_("cannot read inode %llu, disk block %lld, cnt %d\n"),
-				XFS_AGINO_TO_INO(mp, agno, irec->ino_startnum),
-				XFS_AGB_TO_DADDR(mp, agno, agbno),
-				(int)XFS_FSB_TO_BB(mp, XFS_IALLOC_BLOCKS(mp)));
-
-			irec =3D next_ino_rec(irec);
-			continue;	/* while */
-		}
-		chunk_dirty =3D 0;
 		for (j =3D 0; j < XFS_INODES_PER_CHUNK; j++)  {
 			assert(is_inode_confirmed(irec, j));
=20
@@ -122,110 +141,27 @@
 				continue;
=20
 			assert(no_modify || is_inode_reached(irec, j));
-			assert(no_modify ||
-					is_inode_referenced(irec, j));
+			assert(no_modify || is_inode_referenced(irec, j));
=20
 			nrefs =3D num_inode_references(irec, j);
=20
-			ino =3D XFS_AGINO_TO_INO(mp, agno,
-				irec->ino_startnum + j);
-
-			dip =3D (xfs_dinode_t *)(XFS_BUF_PTR(bp) +
-					(j << mp->m_sb.sb_inodelog));
-=09=09=09
-			inode_dirty =3D 0;
-
-			/* Swap the fields we care about to native format */
-			dip->di_core.di_magic =3D INT_GET(dip->di_core.di_magic,=20
-							ARCH_CONVERT);
-			dip->di_core.di_onlink =3D INT_GET(dip->di_core.di_onlink,=20
-							ARCH_CONVERT);
-			if (INT_GET(dip->di_core.di_version, ARCH_CONVERT) =3D=3D
-					XFS_DINODE_VERSION_1)=20
-				dip->di_core.di_nlink =3D dip->di_core.di_onlink;
-			else=20
-				dip->di_core.di_nlink =3D=20
-						INT_GET(dip->di_core.di_nlink,=20
-							ARCH_CONVERT);
-
-			if (dip->di_core.di_magic !=3D XFS_DINODE_MAGIC) {
-				if (!no_modify) {
-					do_error(
-	_("ino: %llu, bad d_inode magic saw: (0x%x) expecting (0x%x)\n"),
-				ino, dip->di_core.di_magic, XFS_DINODE_MAGIC);
-					/* NOT REACHED */
-				}
-				do_warn(
-	_("ino: %llu, bad d_inode magic saw: (0x%x) expecting (0x%x)\n"),
-				ino, dip->di_core.di_magic, XFS_DINODE_MAGIC);
-				continue;
-			}
-			/*
-			 * compare and set links for all inodes
-			 * but the lost+found inode.  we keep
-			 * that correct as we go.
-			 */
-			if (dip->di_core.di_nlink !=3D nrefs) {
-				if (ino !=3D orphanage_ino) {
-					set_nlinks(&dip->di_core, ino,
-							nrefs, &inode_dirty);
-				}
-			}
-
-			/* Swap the fields back */
-			dip->di_core.di_magic =3D INT_GET(dip->di_core.di_magic,=20
-					ARCH_CONVERT);
-			if (inode_dirty && INT_GET(dip->di_core.di_version,=20
-					ARCH_CONVERT) =3D=3D XFS_DINODE_VERSION_1) {
-				if (!XFS_SB_VERSION_HASNLINK(&mp->m_sb)) {
-					ASSERT(dip->di_core.di_nlink <=3D=20
-							XFS_MAXLINK_1);
-					INT_SET(dip->di_core.di_onlink,=20
-							ARCH_CONVERT,
-							dip->di_core.di_nlink);
-					dip->di_core.di_nlink =3D=20
-						INT_GET(dip->di_core.di_nlink,=20
-							ARCH_CONVERT);
-				} else {
-					/* superblock support v2 nlinks */
-					INT_SET(dip->di_core.di_version,=20
-						ARCH_CONVERT, XFS_DINODE_VERSION_2);
-					dip->di_core.di_nlink =3D=20
-						INT_GET(dip->di_core.di_nlink,=20
-							ARCH_CONVERT);
-					dip->di_core.di_onlink =3D 0;
-					memset(&(dip->di_core.di_pad[0]), 0,
-						sizeof(dip->di_core.di_pad));
-				}=09
-			} else {
-				dip->di_core.di_nlink =3D=20
-						INT_GET(dip->di_core.di_nlink,=20
-							ARCH_CONVERT);
-				dip->di_core.di_onlink =3D=20
-						INT_GET(dip->di_core.di_onlink,=20
-							ARCH_CONVERT);
-			}
-			chunk_dirty |=3D inode_dirty;
+ 			if (get_inode_disk_nlinks(irec, j) !=3D nrefs)
+ 				update_inode_nlinks(mp, XFS_AGINO_TO_INO(mp,
+ 						agno, irec->ino_startnum + j),
+ 						nrefs);
 		}
-
-		if (chunk_dirty)
-			libxfs_writebuf(bp, 0);
-		else
-			libxfs_putbuf(bp);
-
 		irec =3D next_ino_rec(irec);
 		PROG_RPT_INC(prog_rpt_done[agno], XFS_INODES_PER_CHUNK);
 	}
 }
=20
-void
+static void
 phase7_alt(xfs_mount_t *mp)
 {
 	int		i;
=20
 	set_progress_msg(no_modify ? PROGRESS_FMT_VRFY_LINK : PROGRESS_FMT_CORR_L=
INK,
 		(__uint64_t) mp->m_sb.sb_icount);
-	libxfs_bcache_purge();
=20
 	for (i =3D 0; i < glob_agcount; i++)  {
 		queue_work(phase7_alt_function, mp, i);
@@ -238,13 +174,8 @@
 phase7(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
-	xfs_inode_t		*ip;
-	xfs_trans_t		*tp;
 	int			i;
 	int			j;
-	int			error;
-	int			dirty;
-	xfs_ino_t		ino;
 	__uint32_t		nrefs;
=20
 	if (!no_modify)
@@ -252,25 +183,14 @@
 	else
 		do_log(_("Phase 7 - verify link counts...\n"));
=20
-
 	if (do_prefetch) {
 		phase7_alt(mp);
 		return;
 	}
=20
-	tp =3D libxfs_trans_alloc(mp, XFS_TRANS_REMOVE);
-
-	error =3D libxfs_trans_reserve(tp, (no_modify ? 0 : 10),
-			XFS_REMOVE_LOG_RES(mp), 0, XFS_TRANS_PERM_LOG_RES,
-			XFS_REMOVE_LOG_COUNT);
-
-	ASSERT(error =3D=3D 0);
-
 	/*
-	 * for each ag, look at each inode 1 at a time using the
-	 * sim code.  if the number of links is bad, reset it,
-	 * log the inode core, commit the transaction, and
-	 * allocate a new transaction
+	 * for each ag, look at each inode 1 at a time. If the number of
+	 * links is bad, reset it, log the inode core, commit the transaction
 	 */
 	for (i =3D 0; i < glob_agcount; i++)  {
 		irec =3D findfirst_inode_rec(i);
@@ -288,69 +208,13 @@
=20
 				nrefs =3D num_inode_references(irec, j);
=20
-				ino =3D XFS_AGINO_TO_INO(mp, i,
-					irec->ino_startnum + j);
-
-				error =3D libxfs_trans_iget(mp, tp, ino, 0, 0, &ip);
-
-				if (error)  {
-					if (!no_modify)
-						do_error(
-				_("couldn't map inode %llu, err =3D %d\n"),
-							ino, error);
-					else  {
-						do_warn(
-	_("couldn't map inode %llu, err =3D %d, can't compare link counts\n"),
-							ino, error);
-						continue;
-					}
-				}
-
-				dirty =3D 0;
-
-				/*
-				 * compare and set links for all inodes
-				 * but the lost+found inode.  we keep
-				 * that correct as we go.
-				 */
-				if (ino !=3D orphanage_ino)
-					set_nlinks(&ip->i_d, ino, nrefs,
-							&dirty);
-
-				if (!dirty)  {
-					libxfs_trans_iput(tp, ip, 0);
-				} else  {
-					libxfs_trans_log_inode(tp, ip,
-							XFS_ILOG_CORE);
-					/*
-					 * no need to do a bmap finish since
-					 * we're not allocating anything
-					 */
-					ASSERT(error =3D=3D 0);
-					error =3D libxfs_trans_commit(tp,
-						XFS_TRANS_RELEASE_LOG_RES|
-						XFS_TRANS_SYNC, NULL);
-
-					ASSERT(error =3D=3D 0);
-
-					tp =3D libxfs_trans_alloc(mp,
-							XFS_TRANS_REMOVE);
-
-					error =3D libxfs_trans_reserve(tp,
-						(no_modify ? 0 : 10),
-						XFS_REMOVE_LOG_RES(mp),
-						0, XFS_TRANS_PERM_LOG_RES,
-						XFS_REMOVE_LOG_COUNT);
-					ASSERT(error =3D=3D 0);
-				}
+				if (get_inode_disk_nlinks(irec, j) !=3D nrefs)
+					update_inode_nlinks(mp,
+						XFS_AGINO_TO_INO(mp, i,
+							irec->ino_startnum + j),
+						nrefs);
 			}
 			irec =3D next_ino_rec(irec);
 		}
 	}
-
-	/*
-	 * always have one unfinished transaction coming out
-	 * of the loop.  cancel it.
-	 */
-	libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
 }

------=_NextPart_000_008F_01C7626F.3C00DD50--
