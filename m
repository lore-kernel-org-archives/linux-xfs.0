Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E5C3029E04
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 04:24:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 827C4AC006
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 02:24:14 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id dP3ZFJHSv1ZOWwxw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 02:24:11 -0700 (PDT)
Received: from smtpout2.drei.com ([109.126.64.2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z6bU2-0001zW-NM
	for xfs@oss.sgi.com; Sun, 21 Jun 2015 09:24:11 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/8] xfsprogs: remove __psint_t and __psunsigned_t
Date: Sun, 21 Jun 2015 11:21:58 +0200
Message-Id: <1434878524-18176-3-git-send-email-hch@lst.de>
In-Reply-To: <1434878524-18176-1-git-send-email-hch@lst.de>
References: <1434878524-18176-1-git-send-email-hch@lst.de>
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

Replace them with the standards conform intptr_t and uintptr_t.  Note
that many uses look rather questionable cargo-cult avoidance of pointer
arithmetics, but let's leave that for now and look at it separately.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/bit.c                   |  8 ++++----
 db/check.c                 |  6 +++---
 db/field.c                 |  8 ++++----
 db/field.h                 |  6 +++---
 include/platform_defs.h.in | 36 ------------------------------------
 logprint/log_misc.c        |  2 +-
 m4/package_types.m4        | 28 ----------------------------
 repair/agheader.c          |  2 +-
 repair/attr_repair.c       |  6 +++---
 repair/avl.c               | 36 ++++++++++++++++++------------------
 repair/avl.h               | 18 +++++++++---------
 repair/dir2.c              | 16 ++++++++--------
 repair/incore_ext.c        | 20 ++++++++++----------
 repair/incore_ino.c        |  8 ++++----
 repair/phase6.c            | 30 +++++++++++++++---------------
 15 files changed, 83 insertions(+), 147 deletions(-)

diff --git a/db/bit.c b/db/bit.c
index e8adab3..87ee63a 100644
--- a/db/bit.c
+++ b/db/bit.c
@@ -79,24 +79,24 @@ getbitval(
 	p = (char *)obj + byteize(bitoff);
 	bit = bitoffs(bitoff);
 	signext = (flags & BVSIGNED) != 0;
-	z4 = ((__psint_t)p & 0xf) == 0 && bit == 0;
+	z4 = ((intptr_t)p & 0xf) == 0 && bit == 0;
 	if (nbits == 64 && z4)
 		return be64_to_cpu(*(__be64 *)p);
-	z3 = ((__psint_t)p & 0x7) == 0 && bit == 0;
+	z3 = ((intptr_t)p & 0x7) == 0 && bit == 0;
 	if (nbits == 32 && z3) {
 		if (signext)
 			return (__s32)be32_to_cpu(*(__be32 *)p);
 		else
 			return (__u32)be32_to_cpu(*(__be32 *)p);
 	}
-	z2 = ((__psint_t)p & 0x3) == 0 && bit == 0;
+	z2 = ((intptr_t)p & 0x3) == 0 && bit == 0;
 	if (nbits == 16 && z2) {
 		if (signext)
 			return (__s16)be16_to_cpu(*(__be16 *)p);
 		else
 			return (__u16)be16_to_cpu(*(__be16 *)p);
 	}
-	z1 = ((__psint_t)p & 0x1) == 0 && bit == 0;
+	z1 = ((intptr_t)p & 0x1) == 0 && bit == 0;
 	if (nbits == 8 && z1) {
 		if (signext)
 			return *(__s8 *)p;
diff --git a/db/check.c b/db/check.c
index 1822905..50c785a 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3436,8 +3436,8 @@ process_sf_dir_v2(
 	sfe = xfs_dir2_sf_firstentry(sf);
 	offset = M_DIROPS(mp)->data_first_offset;
 	for (i = sf->count - 1, i8 = 0; i >= 0; i--) {
-		if ((__psint_t)sfe + M_DIROPS(mp)->sf_entsize(sf, sfe->namelen) -
-		    (__psint_t)sf > be64_to_cpu(dip->di_size)) {
+		if ((intptr_t)sfe + M_DIROPS(mp)->sf_entsize(sf, sfe->namelen) -
+		    (intptr_t)sf > be64_to_cpu(dip->di_size)) {
 			if (!sflag)
 				dbprintf(_("dir %llu bad size in entry at %d\n"),
 					id->ino,
@@ -3478,7 +3478,7 @@ process_sf_dir_v2(
 			M_DIROPS(mp)->sf_entsize(sf, sfe->namelen);
 		sfe = M_DIROPS(mp)->sf_nextentry(sf, sfe);
 	}
-	if (i < 0 && (__psint_t)sfe - (__psint_t)sf != 
+	if (i < 0 && (intptr_t)sfe - (intptr_t)sf != 
 					be64_to_cpu(dip->di_size)) {
 		if (!sflag)
 			dbprintf(_("dir %llu size is %lld, should be %u\n"),
diff --git a/db/field.c b/db/field.c
index 52d9d9b..07067b5 100644
--- a/db/field.c
+++ b/db/field.c
@@ -373,10 +373,10 @@ bitoffset(
 			abase = (f->flags & FLD_ABASE1) != 0;
 			ASSERT(fa->ftyp == f->ftyp);
 			ASSERT((fa->arg & FTARG_SIZE) == 0);
-			return (int)(__psint_t)f->offset +
+			return (int)(intptr_t)f->offset +
 				(idx - abase) * fsize(f, obj, startoff, idx);
 		} else
-			return (int)(__psint_t)f->offset;
+			return (int)(intptr_t)f->offset;
 	} else
 		return (*f->offset)(obj, startoff, idx);
 }
@@ -388,7 +388,7 @@ fcount(
 	int		startoff)
 {
 	if (!(f->flags & FLD_COUNT))
-		return (int)(__psint_t)f->count;
+		return (int)(intptr_t)f->count;
 	else
 		return (*f->count)(obj, startoff);
 }
@@ -421,7 +421,7 @@ fsize(
 	fa = &ftattrtab[f->ftyp];
 	ASSERT(fa->ftyp == f->ftyp);
 	if (!(fa->arg & FTARG_SIZE))
-		return (int)(__psint_t)fa->size;
+		return (int)(intptr_t)fa->size;
 	else
 		return (*fa->size)(obj, startoff, idx);
 }
diff --git a/db/field.h b/db/field.h
index 2546240..11aebc3 100644
--- a/db/field.h
+++ b/db/field.h
@@ -183,10 +183,10 @@ typedef enum fldt	{
 } fldt_t;
 
 typedef int (*offset_fnc_t)(void *obj, int startoff, int idx);
-#define	OI(o)	((offset_fnc_t)(__psint_t)(o))
+#define	OI(o)	((offset_fnc_t)(intptr_t)(o))
 
 typedef int (*count_fnc_t)(void *obj, int startoff);
-#define	CI(c)	((count_fnc_t)(__psint_t)(c))
+#define	CI(c)	((count_fnc_t)(intptr_t)(c))
 #define	C1	CI(1)
 
 typedef struct field
@@ -209,7 +209,7 @@ typedef struct field
 #define	FLD_COUNT	16	/* count value is a function pointer */
 
 typedef int (*size_fnc_t)(void *obj, int startoff, int idx);
-#define	SI(s)	((size_fnc_t)(__psint_t)(s))
+#define	SI(s)	((size_fnc_t)(intptr_t)(s))
 
 typedef struct ftattr
 {
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index ac260bc..529c0a6 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -87,42 +87,6 @@ typedef struct filldir		filldir_t;
 #undef SIZEOF_CHAR_P
 #define BITS_PER_LONG (SIZEOF_LONG * CHAR_BIT)
 
-/* Check if __psint_t is set to something meaningful */
-#undef HAVE___PSINT_T
-#ifndef HAVE___PSINT_T
-# if (SIZEOF_CHAR_P * CHAR_BIT) == 32
-typedef int __psint_t;
-# elif (SIZEOF_CHAR_P * CHAR_BIT) == 64
-#  if BITS_PER_LONG == 64
-typedef long __psint_t;
-#  else
-/* This is a very strange architecture, which has 64 bit pointers but */
-/* not 64 bit longs.  So, just punt here and assume long long is OK.  */
-typedef long long __psint_t;
-#  endif
-# else
-#  error Unknown pointer size
-# endif
-#endif
-
-/* Check if __psunsigned_t is set to something meaningful */
-#undef HAVE___PSUNSIGNED_T
-#ifndef HAVE___PSUNSIGNED_T
-# if (SIZEOF_CHAR_P * CHAR_BIT) == 32
-typedef unsigned int __psunsigned_t;
-# elif (SIZEOF_CHAR_P * CHAR_BIT) == 64
-#  if BITS_PER_LONG == 64
-typedef long __psunsigned_t;
-#  else
-/* This is a very strange architecture, which has 64 bit pointers but */
-/* not 64 bit longs.  So, just punt here and assume long long is OK.  */
-typedef unsigned long long __psunsigned_t;
-#  endif
-# else
-#  error Unknown pointer size
-# endif
-#endif
-
 /* Check whether to define umode_t ourselves. */
 #ifndef HAVE_UMODE_T
 typedef unsigned short umode_t;
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 521ab66..6f41c91 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -929,7 +929,7 @@ xlog_print_record(
 	}
     } else {
 	read_len -= *read_type;
-	buf = (xfs_caddr_t)((__psint_t)(*partial_buf) + (__psint_t)(*read_type));
+	buf = (xfs_caddr_t)((intptr_t)(*partial_buf) + (intptr_t)(*read_type));
 	ptr = *partial_buf;
     }
     if ((ret = (int) read(fd, buf, read_len)) == -1) {
diff --git a/m4/package_types.m4 b/m4/package_types.m4
index 454c84a..c3645bc 100644
--- a/m4/package_types.m4
+++ b/m4/package_types.m4
@@ -1,32 +1,4 @@
 # 
-# Check if we have a type for the pointer's size integer (__psint_t)
-# 
-AC_DEFUN([AC_TYPE_PSINT],
-  [ AC_MSG_CHECKING([for __psint_t ])
-    AC_TRY_COMPILE([
-#include <sys/types.h>
-#include <stdlib.h>
-#include <stddef.h>
-    ], [
-         __psint_t  psint;
-    ], AC_DEFINE(HAVE___PSINT_T) AC_MSG_RESULT(yes) , AC_MSG_RESULT(no))
-  ])
-
-# 
-# Check if we have a type for the pointer's size unsigned (__psunsigned_t)
-# 
-AC_DEFUN([AC_TYPE_PSUNSIGNED],
-  [ AC_MSG_CHECKING([for __psunsigned_t ])
-    AC_TRY_COMPILE([
-#include <sys/types.h>
-#include <stdlib.h>
-#include <stddef.h>
-    ], [
-        __psunsigned_t  psuint;
-    ], AC_DEFINE(HAVE___PSUNSIGNED_T) AC_MSG_RESULT(yes) , AC_MSG_RESULT(no))
-  ])
-
-# 
 # Check if we have a type for __u32
 # 
 AC_DEFUN([AC_TYPE_U32],
diff --git a/repair/agheader.c b/repair/agheader.c
index 9ae2deb..c93b62e 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -305,7 +305,7 @@ secondary_sb_wack(
 			 * be set, and the latter is never updated past
 			 * the last field - just zap them both.
 			 */
-			memset((void *)((__psint_t)sb + size), 0,
+			memset((void *)((intptr_t)sb + size), 0,
 				mp->m_sb.sb_sectsize - size);
 			memset(XFS_BUF_PTR(sbuf) + size, 0,
 				mp->m_sb.sb_sectsize - size);
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index f3332b3..8901640 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -931,7 +931,7 @@ process_shortform_attr(
 	_("removing attribute entry %d for inode %" PRIu64 "\n"),
 					i, ino);
 				tempentry = (xfs_attr_sf_entry_t *)
-					((__psint_t) currententry +
+					((intptr_t) currententry +
 					 XFS_ATTR_SF_ENTSIZE(currententry));
 				memmove(currententry,tempentry,remainingspace);
 				asf->hdr.count -= 1;
@@ -946,7 +946,7 @@ process_shortform_attr(
 		}
 
 		/* Let's get ready for the next entry... */
-		nextentry = (xfs_attr_sf_entry_t *)((__psint_t) nextentry +
+		nextentry = (xfs_attr_sf_entry_t *)((intptr_t) nextentry +
 			 		XFS_ATTR_SF_ENTSIZE(currententry));
 		currentsize = currentsize + XFS_ATTR_SF_ENTSIZE(currententry);
 
@@ -1220,7 +1220,7 @@ process_leaf_attr_block(
 		}
 
 		/* mark the entry used */
-		start = (__psint_t)entry - (__psint_t)leaf;
+		start = (intptr_t)entry - (intptr_t)leaf;
 		stop = start + sizeof(xfs_attr_leaf_entry_t);
 		if (set_da_freemap(mp, attr_freemap, start, stop))  {
 			do_warn(
diff --git a/repair/avl.c b/repair/avl.c
index c5ff919..db3d095 100644
--- a/repair/avl.c
+++ b/repair/avl.c
@@ -69,8 +69,8 @@ avl_checktree(
 	avlnode_t *root)
 {
 	avlnode_t *nlast, *nnext, *np;
-	__psunsigned_t offset = 0;
-	__psunsigned_t end;
+	uintptr_t offset = 0;
+	uintptr_t end;
 
 	nlast = nnext = root;
 
@@ -589,8 +589,8 @@ attach:
 avlnode_t *
 avl_findanyrange(
 	avltree_desc_t *tree,
-	__psunsigned_t start,
-	__psunsigned_t end,
+	uintptr_t start,
+	uintptr_t end,
 	int	checklen)
 {
 	avlnode_t *np = tree->avl_root;
@@ -660,10 +660,10 @@ avl_findanyrange(
 avlnode_t *
 avl_find(
 	avltree_desc_t *tree,
-	__psunsigned_t value)
+	uintptr_t value)
 {
 	avlnode_t *np = tree->avl_root;
-	__psunsigned_t nvalue;
+	uintptr_t nvalue;
 
 	while (np) {
 		nvalue = AVL_START(tree, np);
@@ -887,8 +887,8 @@ static
 avlnode_t *
 avl_insert_find_growth(
 		avltree_desc_t *tree,
-		__psunsigned_t start,	/* range start at start, */
-		__psunsigned_t end,	/* exclusive */
+		uintptr_t start,	/* range start at start, */
+		uintptr_t end,	/* exclusive */
 		int   *growthp)	/* OUT */
 {
 	avlnode_t *root = tree->avl_root;
@@ -941,7 +941,7 @@ avl_insert_grow(
 	int growth)
 {
 	avlnode_t *nnext;
-	__psunsigned_t start = AVL_START(tree, newnode);
+	uintptr_t start = AVL_START(tree, newnode);
 
 	if (growth == AVL_BACK) {
 
@@ -983,8 +983,8 @@ avl_insert(
 	avlnode_t *newnode)
 {
 	avlnode_t *np;
-	__psunsigned_t start = AVL_START(tree, newnode);
-	__psunsigned_t end = AVL_END(tree, newnode);
+	uintptr_t start = AVL_START(tree, newnode);
+	uintptr_t end = AVL_END(tree, newnode);
 	int growth;
 
 	ASSERT(newnode);
@@ -1138,16 +1138,16 @@ avlops_t avl_debug_ops = {
 	avl_debug_end,
 }
 
-static __psunsigned_t
+static uintptr_t
 avl_debug_start(avlnode_t *node)
 {
-	return (__psunsigned_t)(struct avl_debug_node *)node->avl_start;
+	return (uintptr_t)(struct avl_debug_node *)node->avl_start;
 }
 
-static __psunsigned_t
+static uintptr_t
 avl_debug_end(avlnode_t *node)
 {
-	return (__psunsigned_t)
+	return (uintptr_t)
 		((struct avl_debug_node *)node->avl_start +
 		 (struct avl_debug_node *)node->avl_size);
 }
@@ -1283,7 +1283,7 @@ main()
 avlnode_t *
 avl_findadjacent(
 	avltree_desc_t *tree,
-	__psunsigned_t value,
+	uintptr_t value,
 	int		dir)
 {
 	avlnode_t *np = tree->avl_root;
@@ -1357,8 +1357,8 @@ avl_findadjacent(
 void
 avl_findranges(
 	avltree_desc_t *tree,
-	__psunsigned_t start,
-	__psunsigned_t end,
+	uintptr_t start,
+	uintptr_t end,
 	avlnode_t	        **startp,
 	avlnode_t		**endp)
 {
diff --git a/repair/avl.h b/repair/avl.h
index 0078a95..7e59b23 100644
--- a/repair/avl.h
+++ b/repair/avl.h
@@ -31,8 +31,8 @@ typedef struct	avlnode {
  * avl-tree operations
  */
 typedef struct avlops {
-	__psunsigned_t	(*avl_start)(avlnode_t *);
-	__psunsigned_t	(*avl_end)(avlnode_t *);
+	uintptr_t	(*avl_start)(avlnode_t *);
+	uintptr_t	(*avl_end)(avlnode_t *);
 } avlops_t;
 
 #define	AVL_START(tree, n)	(*(tree)->avl_ops->avl_start)(n)
@@ -87,7 +87,7 @@ avl_init_tree(
 static inline avlnode_t *
 avl_findrange(
 	avltree_desc_t *tree,
-	__psunsigned_t value)
+	uintptr_t value)
 {
 	avlnode_t *np = tree->avl_root;
 
@@ -110,27 +110,27 @@ avl_findrange(
 avlnode_t *
 avl_find(
 	avltree_desc_t *tree,
-	__psunsigned_t value);
+	uintptr_t value);
 
 avlnode_t *
 avl_findanyrange(
 	avltree_desc_t *tree,
-	__psunsigned_t start,
-	__psunsigned_t end,
+	uintptr_t start,
+	uintptr_t end,
 	int     checklen);
 
 
 avlnode_t *
 avl_findadjacent(
 	avltree_desc_t *tree,
-	__psunsigned_t value,
+	uintptr_t value,
 	int		dir);
 
 void
 avl_findranges(
 	avltree_desc_t *tree,
-	__psunsigned_t start,
-	__psunsigned_t end,
+	uintptr_t start,
+	uintptr_t end,
 	avlnode_t	        **startp,
 	avlnode_t		**endp);
 
diff --git a/repair/dir2.c b/repair/dir2.c
index ceb8825..9315ff7 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -669,7 +669,7 @@ process_sf_dir2_fixi8(
 	int			oldsize;
 
 	newsfp = sfp;
-	oldsize = (__psint_t)*next_sfep - (__psint_t)sfp;
+	oldsize = (intptr_t)*next_sfep - (intptr_t)sfp;
 	oldsfp = malloc(oldsize);
 	if (oldsfp == NULL) {
 		do_error(_("couldn't malloc dir2 shortform copy\n"));
@@ -874,7 +874,7 @@ _("entry \"%*.*s\" in shortform directory %" PRIu64 " references %s inode %" PRI
 		if (namelen == 0) {
 			junkreason = _("is zero length");
 			bad_sfnamelen = 1;
-		} else if ((__psint_t) sfep - (__psint_t) sfp +
+		} else if ((intptr_t) sfep - (intptr_t) sfp +
 				M_DIROPS(mp)->sf_entsize(sfp, sfep->namelen)
 							> ino_dir_size)  {
 			junkreason = _("extends past end of dir");
@@ -944,15 +944,15 @@ _("entry contains offset out of order in shortform dir %" PRIu64 "\n"),
 				ino_dir_size -= tmp_elen;
 
 				tmp_sfep = (xfs_dir2_sf_entry_t *)
-					((__psint_t) sfep + tmp_elen);
-				tmp_len = max_size - ((__psint_t) tmp_sfep
-							- (__psint_t) sfp);
+					((intptr_t) sfep + tmp_elen);
+				tmp_len = max_size - ((intptr_t) tmp_sfep
+							- (intptr_t) sfp);
 
 				memmove(sfep, tmp_sfep, tmp_len);
 
 				sfp->count -= 1;
 				num_entries--;
-				memset((void *) ((__psint_t) sfep + tmp_len), 0,
+				memset((void *) ((intptr_t) sfep + tmp_len), 0,
 					tmp_elen);
 
 				/*
@@ -990,7 +990,7 @@ _("would have junked entry \"%s\" in directory inode %" PRIu64 "\n"),
 		 * calculate size based on next_sfep.
 		 */
 		next_sfep = (tmp_sfep == NULL)
-			? (xfs_dir2_sf_entry_t *) ((__psint_t) sfep
+			? (xfs_dir2_sf_entry_t *) ((intptr_t) sfep
 							+ ((!bad_sfnamelen)
 				? M_DIROPS(mp)->sf_entsize(sfp, sfep->namelen)
 				: M_DIROPS(mp)->sf_entsize(sfp, namelen)))
@@ -1045,7 +1045,7 @@ _("corrected directory %" PRIu64 " size, was %" PRId64 ", now %" PRIdPTR "\n"),
 				(intptr_t)next_sfep - (intptr_t)sfp);
 
 			dip->di_size = cpu_to_be64(
-					(__psint_t)next_sfep - (__psint_t)sfp);
+					(intptr_t)next_sfep - (intptr_t)sfp);
 			*dino_dirty = 1;
 			*repair = 1;
 		}
diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index 826bf44..849a949 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -498,17 +498,17 @@ get_bcnt_extent(xfs_agnumber_t agno, xfs_agblock_t startblock,
 	return(ext);
 }
 
-static __psunsigned_t
+static uintptr_t
 avl_ext_start(avlnode_t *node)
 {
-	return((__psunsigned_t)
+	return((uintptr_t)
 		((extent_tree_node_t *) node)->ex_startblock);
 }
 
-static __psunsigned_t
+static uintptr_t
 avl_ext_end(avlnode_t *node)
 {
-	return((__psunsigned_t) (
+	return((uintptr_t) (
 		((extent_tree_node_t *) node)->ex_startblock +
 		((extent_tree_node_t *) node)->ex_blockcount));
 }
@@ -517,24 +517,24 @@ avl_ext_end(avlnode_t *node)
  * convert size to an address for the AVL tree code -- the bigger the size,
  * the lower the address so the biggest extent will be first in the tree
  */
-static __psunsigned_t
+static uintptr_t
 avl_ext_bcnt_start(avlnode_t *node)
 {
 /*
-	return((__psunsigned_t) (BCNT_ADDR(((extent_tree_node_t *)
+	return((uintptr_t) (BCNT_ADDR(((extent_tree_node_t *)
 						node)->ex_blockcount)));
 */
-	return((__psunsigned_t) ((extent_tree_node_t *)node)->ex_blockcount);
+	return((uintptr_t) ((extent_tree_node_t *)node)->ex_blockcount);
 }
 
-static __psunsigned_t
+static uintptr_t
 avl_ext_bcnt_end(avlnode_t *node)
 {
 /*
-	return((__psunsigned_t) (BCNT_ADDR(((extent_tree_node_t *)
+	return((uintptr_t) (BCNT_ADDR(((extent_tree_node_t *)
 						node)->ex_blockcount)));
 */
-	return((__psunsigned_t) ((extent_tree_node_t *)node)->ex_blockcount);
+	return((uintptr_t) ((extent_tree_node_t *)node)->ex_blockcount);
 }
 
 avlops_t avl_extent_bcnt_tree_ops = {
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index cda6c2b..0c97439 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -772,16 +772,16 @@ add_ino_ex_data(xfs_mount_t *mp)
 	full_ino_ex_data = 1;
 }
 
-static __psunsigned_t
+static uintptr_t
 avl_ino_start(avlnode_t *node)
 {
-	return((__psunsigned_t) ((ino_tree_node_t *) node)->ino_startnum);
+	return((uintptr_t) ((ino_tree_node_t *) node)->ino_startnum);
 }
 
-static __psunsigned_t
+static uintptr_t
 avl_ino_end(avlnode_t *node)
 {
-	return((__psunsigned_t) (
+	return((uintptr_t) (
 		((ino_tree_node_t *) node)->ino_startnum +
 		XFS_INODES_PER_CHUNK));
 }
diff --git a/repair/phase6.c b/repair/phase6.c
index 130ed4f..bdf32bf 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -649,7 +649,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
-		bmp = (xfs_rtword_t *)((__psint_t) bmp + mp->m_sb.sb_blocksize);
+		bmp = (xfs_rtword_t *)((intptr_t) bmp + mp->m_sb.sb_blocksize);
 		bno++;
 	}
 
@@ -721,7 +721,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
-		smp = (xfs_suminfo_t *)((__psint_t)smp + mp->m_sb.sb_blocksize);
+		smp = (xfs_suminfo_t *)((intptr_t)smp + mp->m_sb.sb_blocksize);
 		bno++;
 	}
 
@@ -2464,12 +2464,12 @@ shortform_dir2_junk(
 	 * now move all the remaining entries down over the junked entry and
 	 * clear the newly unused bytes at the tail of the directory region.
 	 */
-	next_len = *max_size - ((__psint_t)next_sfep - (__psint_t)sfp);
+	next_len = *max_size - ((intptr_t)next_sfep - (intptr_t)sfp);
 	*max_size -= next_elen;
 	*bytes_deleted += next_elen;
 
 	memmove(sfep, next_sfep, next_len);
-	memset((void *)((__psint_t)sfep + next_len), 0, next_elen);
+	memset((void *)((intptr_t)sfep + next_len), 0, next_elen);
 	sfp->count -= 1;
 	*ino_dirty = 1;
 
@@ -2559,7 +2559,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 	sfep = next_sfep = xfs_dir2_sf_firstentry(sfp);
 
 	for (i = 0; i < sfp->count && max_size >
-					(__psint_t)next_sfep - (__psint_t)sfp;
+					(intptr_t)next_sfep - (intptr_t)sfp;
 			sfep = next_sfep, i++)  {
 		bad_sfnamelen = 0;
 
@@ -2582,8 +2582,8 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 
 			if (i == sfp->count - 1)  {
 				namelen = ip->i_d.di_size -
-					((__psint_t) &sfep->name[0] -
-					 (__psint_t) sfp);
+					((intptr_t) &sfep->name[0] -
+					 (intptr_t) sfp);
 			} else  {
 				/*
 				 * don't process the rest of the directory,
@@ -2591,15 +2591,15 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 				 */
 				break;
 			}
-		} else if (no_modify && (__psint_t) sfep - (__psint_t) sfp +
+		} else if (no_modify && (intptr_t) sfep - (intptr_t) sfp +
 				+ M_DIROPS(mp)->sf_entsize(sfp, sfep->namelen)
 				> ip->i_d.di_size)  {
 			bad_sfnamelen = 1;
 
 			if (i == sfp->count - 1)  {
 				namelen = ip->i_d.di_size -
-					((__psint_t) &sfep->name[0] -
-					 (__psint_t) sfp);
+					((intptr_t) &sfep->name[0] -
+					 (intptr_t) sfp);
 			} else  {
 				/*
 				 * don't process the rest of the directory,
@@ -2781,7 +2781,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 		 * on next_sfep.
 		 */
 		ASSERT(no_modify || bad_sfnamelen == 0);
-		next_sfep = (struct xfs_dir2_sf_entry *)((__psint_t)sfep +
+		next_sfep = (struct xfs_dir2_sf_entry *)((intptr_t)sfep +
 			      (bad_sfnamelen
 				? M_DIROPS(mp)->sf_entsize(sfp, namelen)
 				: M_DIROPS(mp)->sf_entsize(sfp, sfep->namelen)));
@@ -2798,8 +2798,8 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 				tmp_sfep = next_sfep;
 				process_sf_dir2_fixi8(mp, sfp, &tmp_sfep);
 				bytes_deleted +=
-					(__psint_t)next_sfep -
-					(__psint_t)tmp_sfep;
+					(intptr_t)next_sfep -
+					(intptr_t)tmp_sfep;
 				next_sfep = tmp_sfep;
 			} else
 				sfp->i8count = i8;
@@ -2820,9 +2820,9 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 
 	if (ip->i_d.di_size != ip->i_df.if_bytes)  {
 		ASSERT(ip->i_df.if_bytes == (xfs_fsize_t)
-				((__psint_t) next_sfep - (__psint_t) sfp));
+				((intptr_t) next_sfep - (intptr_t) sfp));
 		ip->i_d.di_size = (xfs_fsize_t)
-				((__psint_t) next_sfep - (__psint_t) sfp);
+				((intptr_t) next_sfep - (intptr_t) sfp);
 		do_warn(
 	_("setting size to %" PRId64 " bytes to reflect junked entries\n"),
 			ip->i_d.di_size);
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
