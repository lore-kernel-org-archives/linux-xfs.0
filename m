Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4P7IoaO044145 for <xfs@oss.sgi.com>; Fri, 25 May 2012 02:18:50 -0500
Received: from seven.medozas.de (seven.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id VedmsP9Dj0CvcBm6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 May 2012 00:18:48 -0700 (PDT)
From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 4/6] build: use standard type intptr_t
Date: Fri, 25 May 2012 09:18:41 +0200
Message-Id: <1337930323-575-5-git-send-email-jengelh@inai.de>
In-Reply-To: <1337930323-575-1-git-send-email-jengelh@inai.de>
References: <1337930323-575-1-git-send-email-jengelh@inai.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: jengelh@inai.de

It seems that the four supported platforms have intptr_t support, for
they run with gcc, so rip out __psint_t and the size detection. If it
breaks, speak up, and will devise something.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac               |    8 ++++-
 db/bit.c                   |    8 +++---
 db/check.c                 |    8 +++---
 db/field.c                 |    8 +++---
 db/field.h                 |    6 ++--
 include/platform_defs.h.in |   18 +-----------
 libxfs/xfs_alloc_btree.c   |    2 +-
 libxfs/xfs_bmap_btree.c    |    2 +-
 libxfs/xfs_ialloc_btree.c  |    2 +-
 logprint/log_misc.c        |    2 +-
 m4/package_types.m4        |   28 -------------------
 repair/agheader.c          |   26 +++++++++---------
 repair/attr_repair.c       |    6 ++--
 repair/dir.c               |   54 ++++++++++++++++++------------------
 repair/dir2.c              |   24 ++++++++--------
 repair/phase5.c            |    5 ++-
 repair/phase6.c            |   64 ++++++++++++++++++++++----------------------
 17 files changed, 116 insertions(+), 155 deletions(-)

diff --git a/configure.ac b/configure.ac
index e0237ba..113c47f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -111,10 +111,14 @@ AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
 AC_HAVE_BLKID_TOPO($enable_blkid)
 
+AC_CHECK_TYPES([intptr_t, __psint_t, __psunsigned_t], [], [], [
+	#include <stddef.h>
+	#include <stdint.h>
+	#include <stdlib.h>
+	#include <sys/types.h>
+])
 AC_CHECK_SIZEOF([long])
 AC_CHECK_SIZEOF([char *])
-AC_TYPE_PSINT
-AC_TYPE_PSUNSIGNED
 AC_TYPE_U32
 AC_MANUAL_FORMAT
 
diff --git a/db/bit.c b/db/bit.c
index ca57d31..9aecf78 100644
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
index e601e0a..247400f 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3646,8 +3646,8 @@ process_sf_dir_v2(
 	sfe = xfs_dir2_sf_firstentry(sf);
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
 	for (i = sf->hdr.count - 1, i8 = 0; i >= 0; i--) {
-		if ((__psint_t)sfe + xfs_dir2_sf_entsize_byentry(sf, sfe) -
-		    (__psint_t)sf > be64_to_cpu(dip->di_size)) {
+		if ((intptr_t)sfe + xfs_dir2_sf_entsize_byentry(sf, sfe) -
+		    (intptr_t)sf > be64_to_cpu(dip->di_size)) {
 			if (!sflag)
 				dbprintf(_("dir %llu bad size in entry at %d\n"),
 					id->ino,
@@ -3688,7 +3688,7 @@ process_sf_dir_v2(
 			xfs_dir2_data_entsize(sfe->namelen);
 		sfe = xfs_dir2_sf_nextentry(sf, sfe);
 	}
-	if (i < 0 && (__psint_t)sfe - (__psint_t)sf != 
+	if (i < 0 && (intptr_t)sfe - (intptr_t)sf !=
 					be64_to_cpu(dip->di_size)) {
 		if (!sflag)
 			dbprintf(_("dir %llu size is %lld, should be %u\n"),
@@ -3769,7 +3769,7 @@ process_shortform_dir_v1(
 				sfe->namelen, sfe->namelen, sfe->name, lino);
 		sfe = xfs_dir_sf_nextentry(sfe);
 	}
-	if ((__psint_t)sfe - (__psint_t)sf != be64_to_cpu(dip->di_size))
+	if ((intptr_t)sfe - (intptr_t)sf != be64_to_cpu(dip->di_size))
 		dbprintf(_("dir %llu size is %lld, should be %d\n"),
 			id->ino, be64_to_cpu(dip->di_size),
 			(int)((char *)sfe - (char *)sf));
diff --git a/db/field.c b/db/field.c
index 6903898..8147df0 100644
--- a/db/field.c
+++ b/db/field.c
@@ -323,10 +323,10 @@ bitoffset(
 			abase = (f->flags & FLD_ABASE1) != 0;
 			ASSERT(fa->ftyp == f->ftyp);
 			ASSERT((fa->arg & FTARG_SIZE) == 0);
-			return (int)(__psint_t)f->offset +
+			return (intptr_t)f->offset +
 				(idx - abase) * fsize(f, obj, startoff, idx);
 		} else
-			return (int)(__psint_t)f->offset;
+			return (intptr_t)f->offset;
 	} else
 		return (*f->offset)(obj, startoff, idx);
 }
@@ -338,7 +338,7 @@ fcount(
 	int		startoff)
 {
 	if (!(f->flags & FLD_COUNT))
-		return (int)(__psint_t)f->count;
+		return (intptr_t)f->count;
 	else
 		return (*f->count)(obj, startoff);
 }
@@ -371,7 +371,7 @@ fsize(
 	fa = &ftattrtab[f->ftyp];
 	ASSERT(fa->ftyp == f->ftyp);
 	if (!(fa->arg & FTARG_SIZE))
-		return (int)(__psint_t)fa->size;
+		return (intptr_t)fa->size;
 	else
 		return (*fa->size)(obj, startoff, idx);
 }
diff --git a/db/field.h b/db/field.h
index 6962d69..28f5767 100644
--- a/db/field.h
+++ b/db/field.h
@@ -149,10 +149,10 @@ typedef enum fldt	{
 } fldt_t;
 
 typedef int (*offset_fnc_t)(void *obj, int startoff, int idx);
-#define	OI(o)	((offset_fnc_t)(__psint_t)(o))
+#define	OI(o)	((offset_fnc_t)(intptr_t)(o))
 
 typedef int (*count_fnc_t)(void *obj, int startoff);
-#define	CI(c)	((count_fnc_t)(__psint_t)(c))
+#define	CI(c)	((count_fnc_t)(intptr_t)(c))
 #define	C1	CI(1)
 
 typedef struct field
@@ -175,7 +175,7 @@ typedef struct field
 #define	FLD_COUNT	16	/* count value is a function pointer */
 
 typedef int (*size_fnc_t)(void *obj, int startoff, int idx);
-#define	SI(s)	((size_fnc_t)(__psint_t)(s))
+#define	SI(s)	((size_fnc_t)(intptr_t)(s))
 
 typedef struct ftattr
 {
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 4e1e0c4..d05e492 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -82,23 +82,7 @@ typedef struct filldir		filldir_t;
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
+#undef HAVE_INTPTR_T
 
 /* Check if __psunsigned_t is set to something meaningful */
 #undef HAVE___PSUNSIGNED_T
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index b782d9d..b292cce 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -321,7 +321,7 @@ xfs_allocbt_trace_enter(
 	__psunsigned_t		a9,
 	__psunsigned_t		a10)
 {
-	ktrace_enter(xfs_allocbt_trace_buf, (void *)(__psint_t)type,
+	ktrace_enter(xfs_allocbt_trace_buf, (void *)(intptr_t)type,
 		(void *)func, (void *)s, NULL, (void *)cur,
 		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
 		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index ff51fdd..c24cc2a 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -736,7 +736,7 @@ xfs_bmbt_trace_enter(
 	int			whichfork = cur->bc_private.b.whichfork;
 
 	ktrace_enter(xfs_bmbt_trace_buf,
-		(void *)((__psint_t)type | (whichfork << 8) | (line << 16)),
+		(void *)((intptr_t)type | (whichfork << 8) | (line << 16)),
 		(void *)func, (void *)s, (void *)ip, (void *)cur,
 		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
 		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 35dd96f..5c54f75 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -207,7 +207,7 @@ xfs_inobt_trace_enter(
 	__psunsigned_t		a9,
 	__psunsigned_t		a10)
 {
-	ktrace_enter(xfs_inobt_trace_buf, (void *)(__psint_t)type,
+	ktrace_enter(xfs_inobt_trace_buf, (void *)(intptr_t)type,
 		(void *)func, (void *)s, NULL, (void *)cur,
 		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
 		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index e42e108..8392b45 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -873,7 +873,7 @@ xlog_print_record(int			  fd,
 	}
     } else {
 	read_len -= *read_type;
-	buf = (xfs_caddr_t)((__psint_t)(*partial_buf) + (__psint_t)(*read_type));
+	buf = (xfs_caddr_t)((intptr_t)(*partial_buf) + (intptr_t)(*read_type));
 	ptr = *partial_buf;
     }
     if ((ret = (int) read(fd, buf, read_len)) == -1) {
diff --git a/m4/package_types.m4 b/m4/package_types.m4
index dfcb0d9..4a2a90e 100644
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
index 769022d..957a499 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -241,22 +241,22 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
 		 * gets rev'ed again with new fields appended.
 		 */
 		if (xfs_sb_version_hasmorebits(sb))
-			size = (__psint_t)&sb->sb_features2
-				+ sizeof(sb->sb_features2) - (__psint_t)sb;
+			size = (intptr_t)&sb->sb_features2
+				+ sizeof(sb->sb_features2) - (intptr_t)sb;
 		else if (xfs_sb_version_haslogv2(sb))
-			size = (__psint_t)&sb->sb_logsunit
-				+ sizeof(sb->sb_logsunit) - (__psint_t)sb;
+			size = (intptr_t)&sb->sb_logsunit
+				+ sizeof(sb->sb_logsunit) - (intptr_t)sb;
 		else if (xfs_sb_version_hassector(sb))
-			size = (__psint_t)&sb->sb_logsectsize
-				+ sizeof(sb->sb_logsectsize) - (__psint_t)sb;
+			size = (intptr_t)&sb->sb_logsectsize
+				+ sizeof(sb->sb_logsectsize) - (intptr_t)sb;
 		else if (xfs_sb_version_hasdirv2(sb))
-			size = (__psint_t)&sb->sb_dirblklog
-				+ sizeof(sb->sb_dirblklog) - (__psint_t)sb;
+			size = (intptr_t)&sb->sb_dirblklog
+				+ sizeof(sb->sb_dirblklog) - (intptr_t)sb;
 		else
-			size = (__psint_t)&sb->sb_width
-				+ sizeof(sb->sb_width) - (__psint_t)sb;
-		for (ip = (char *)((__psint_t)sb + size);
-		     ip < (char *)((__psint_t)sb + mp->m_sb.sb_sectsize);
+			size = (intptr_t)&sb->sb_width
+				+ sizeof(sb->sb_width) - (intptr_t)sb;
+		for (ip = (char *)((intptr_t)sb + size);
+		     ip < (char *)((intptr_t)sb + mp->m_sb.sb_sectsize);
 		     ip++)  {
 			if (*ip)  {
 				do_bzero = 1;
@@ -270,7 +270,7 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
 				do_warn(
 		_("zeroing unused portion of %s superblock (AG #%u)\n"),
 					!i ? _("primary") : _("secondary"), i);
-				memset((void *)((__psint_t)sb + size), 0,
+				memset((void *)((intptr_t)sb + size), 0,
 					mp->m_sb.sb_sectsize - size);
 			} else
 				do_warn(
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index bab65b1..4ec716c 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -265,7 +265,7 @@ process_shortform_attr(
 	_("removing attribute entry %d for inode %" PRIu64 "\n"),
 					i, ino);
 				tempentry = (xfs_attr_sf_entry_t *)
-					((__psint_t) currententry +
+					((intptr_t)currententry +
 					 XFS_ATTR_SF_ENTSIZE(currententry));
 				memmove(currententry,tempentry,remainingspace);
 				asf->hdr.count -= 1;
@@ -280,7 +280,7 @@ process_shortform_attr(
 		}
 
 		/* Let's get ready for the next entry... */
-		nextentry = (xfs_attr_sf_entry_t *)((__psint_t) nextentry +
+		nextentry = (xfs_attr_sf_entry_t *)((intptr_t)nextentry +
 			 		XFS_ATTR_SF_ENTSIZE(currententry));
 		currentsize = currentsize + XFS_ATTR_SF_ENTSIZE(currententry);
 
@@ -538,7 +538,7 @@ process_leaf_attr_block(
 		}
 
 		/* mark the entry used */
-		start = (__psint_t)&leaf->entries[i] - (__psint_t)leaf;
+		start = (intptr_t)&leaf->entries[i] - (intptr_t)leaf;
 		stop = start + sizeof(xfs_attr_leaf_entry_t);
 		if (set_da_freemap(mp, attr_freemap, start, stop))  {
 			do_warn(
diff --git a/repair/dir.c b/repair/dir.c
index 01c8f10..cbcd4ea 100644
--- a/repair/dir.c
+++ b/repair/dir.c
@@ -124,7 +124,7 @@ process_shortform_dir(
 	 */
 	sf_entry = next_sfe = &sf->list[0];
 	for (i = 0; i < num_entries && ino_dir_size >
-				(__psint_t)next_sfe - (__psint_t)sf; i++)  {
+				(intptr_t)next_sfe - (intptr_t)sf; i++)  {
 		tmp_sfe = NULL;
 		sf_entry = next_sfe;
 		junkit = 0;
@@ -229,8 +229,8 @@ process_shortform_dir(
 
 			if (i == num_entries - 1)  {
 				namelen = ino_dir_size -
-					((__psint_t) &sf_entry->name[0] -
-					 (__psint_t) sf);
+					((intptr_t)&sf_entry->name[0] -
+					 (intptr_t)sf);
 				if (!no_modify)  {
 					do_warn(
 		_("zero length entry in shortform dir %" PRIu64 ", resetting to %d\n"),
@@ -257,15 +257,15 @@ process_shortform_dir(
 				 */
 				break;
 			}
-		} else if ((__psint_t) sf_entry - (__psint_t) sf +
+		} else if ((intptr_t)sf_entry - (intptr_t)sf +
 				+ xfs_dir_sf_entsize_byentry(sf_entry)
 				> ino_dir_size)  {
 			bad_sfnamelen = 1;
 
 			if (i == num_entries - 1)  {
 				namelen = ino_dir_size -
-					((__psint_t) &sf_entry->name[0] -
-					 (__psint_t) sf);
+					((intptr_t)&sf_entry->name[0] -
+					 (intptr_t)sf);
 				do_warn(
 	_("size of last entry overflows space left in in shortform dir %" PRIu64 ", "),
 					ino);
@@ -342,15 +342,15 @@ process_shortform_dir(
 				ino_dir_size -= tmp_elen;
 
 				tmp_sfe = (xfs_dir_sf_entry_t *)
-					((__psint_t) sf_entry + tmp_elen);
-				tmp_len = max_size - ((__psint_t) tmp_sfe
-							- (__psint_t) sf);
+					((intptr_t)sf_entry + tmp_elen);
+				tmp_len = max_size - ((intptr_t)tmp_sfe
+							- (intptr_t)sf);
 
 				memmove(sf_entry, tmp_sfe, tmp_len);
 
 				sf->hdr.count -= 1;
 				num_entries--;
-				memset((void *)((__psint_t)sf_entry + tmp_len), 
+				memset((void *)((intptr_t)sf_entry + tmp_len),
 								0, tmp_elen);
 
 				/*
@@ -388,7 +388,7 @@ process_shortform_dir(
 		 * calculate size based on next_sfe.
 		 */
 		next_sfe = (tmp_sfe == NULL)
-			? (xfs_dir_sf_entry_t *) ((__psint_t) sf_entry
+			? (xfs_dir_sf_entry_t *) ((intptr_t)sf_entry
 				+ ((!bad_sfnamelen)
 					? xfs_dir_sf_entsize_byentry(sf_entry)
 					: sizeof(xfs_dir_sf_entry_t) - 1
@@ -413,20 +413,20 @@ process_shortform_dir(
 		}
 	}
 
-	if ((__psint_t) next_sfe - (__psint_t) sf != ino_dir_size)  {
+	if ((intptr_t)next_sfe - (intptr_t)sf != ino_dir_size)  {
 		if (no_modify)  {
 			do_warn(
 	_("would have corrected directory %" PRIu64 " size from %" PRId64 "to %" PRIdPTR "\n"),
 				ino, ino_dir_size,
-				(intptr_t)next_sfe - (intptr_t )sf);
+				(intptr_t)next_sfe - (intptr_t)sf);
 		} else  {
 			do_warn(
 	_("corrected directory %" PRIu64 " size, was %" PRId64 ", now %" PRIdPTR "\n"),
 				ino, ino_dir_size,
 				(intptr_t)next_sfe - (intptr_t)sf);
 
-			dip->di_size = cpu_to_be64((__psint_t)next_sfe 
-							- (__psint_t)sf);
+			dip->di_size = cpu_to_be64((intptr_t)next_sfe
+							- (intptr_t)sf);
 			*dino_dirty = 1;
 			*repair = 1;
 		}
@@ -1393,7 +1393,7 @@ _("nameidx %d for entry #%d, bno %d, ino %" PRIu64 " > fs blocksize, deleting en
 						memmove(entry, entry + 1,
 							bytes);
 						memset((void *)
-						((__psint_t) entry + bytes), 0,
+						((intptr_t)entry + bytes), 0,
 						sizeof(xfs_dir_leaf_entry_t));
 					} else  {
 						memset(entry, 0,
@@ -1625,7 +1625,7 @@ _("entry references free inode %" PRIu64 " in directory %" PRIu64 ", would clear
 				 */
 				if (bytes > sizeof(xfs_dir_leaf_entry_t))  {
 					memmove(entry, entry + 1, bytes);
-					memset((void *)((__psint_t) entry + 
+					memset((void *)((intptr_t)entry +
 							bytes), 0,
 						sizeof(xfs_dir_leaf_entry_t));
 				} else  {
@@ -1667,7 +1667,7 @@ _("bad size, entry #%d in dir inode %" PRIu64 ", block %u -- entry overflows blo
 			goto out;
 		}
 
-		start = (__psint_t)&leaf->entries[i] - (__psint_t)leaf;;
+		start = (intptr_t)&leaf->entries[i] - (intptr_t)leaf;
 		stop = start + sizeof(xfs_dir_leaf_entry_t);
 
 		if (set_da_freemap(mp, dir_freemap, start, stop))  {
@@ -2084,7 +2084,7 @@ _("- existing hole info for block %d, dir inode %" PRIu64 " (base, size) - \n"),
 			num_entries = 0;
 			first_used = XFS_LBSIZE(mp);
 			first_byte = (char *) new_leaf
-					+ (__psint_t) XFS_LBSIZE(mp);
+					+ (intptr_t)XFS_LBSIZE(mp);
 
 			/*
 			 * copy entry table and pack names starting from the end
@@ -2103,9 +2103,9 @@ _("- existing hole info for block %d, dir inode %" PRIu64 " (base, size) - \n"),
 				bytes = sizeof(xfs_dir_leaf_name_t)
 					+ s_entry->namelen - 1;
 
-				if ((__psint_t) first_byte - bytes <
+				if ((intptr_t)first_byte - bytes <
 						sizeof(xfs_dir_leaf_entry_t)
-						+ (__psint_t) d_entry)  {
+						+ (intptr_t)d_entry)  {
 					do_warn(
 	_("not enough space in block %u of dir inode %" PRIu64 " for all entries\n"),
 						da_bno, ino);
@@ -2134,8 +2134,8 @@ _("- existing hole info for block %d, dir inode %" PRIu64 " (base, size) - \n"),
 			/*
 			 * zero space between end of table and top of heap
 			 */
-			memset(d_entry, 0, (__psint_t) first_byte
-					- (__psint_t) d_entry);
+			memset(d_entry, 0, (intptr_t)first_byte
+					- (intptr_t)d_entry);
 
 			/*
 			 * reset header info
@@ -2148,14 +2148,14 @@ _("- existing hole info for block %d, dir inode %" PRIu64 " (base, size) - \n"),
 			new_leaf->hdr.pad1 = 0;
 
 			new_leaf->hdr.freemap[0].base = cpu_to_be16(
-				(__psint_t) d_entry - (__psint_t) new_leaf);
+				(intptr_t)d_entry - (intptr_t)new_leaf);
 			new_leaf->hdr.freemap[0].size = cpu_to_be16(
-				(__psint_t) first_byte - (__psint_t) d_entry);
+				(intptr_t)first_byte - (intptr_t)d_entry);
 
 			ASSERT(be16_to_cpu(new_leaf->hdr.freemap[0].base) < first_used);
 			ASSERT(be16_to_cpu(new_leaf->hdr.freemap[0].base) ==
-					(__psint_t) (&new_leaf->entries[0])
-					- (__psint_t) new_leaf
+					(intptr_t)(&new_leaf->entries[0])
+					- (intptr_t)new_leaf
 					+ i * sizeof(xfs_dir_leaf_entry_t));
 			ASSERT(be16_to_cpu(new_leaf->hdr.freemap[0].base) < XFS_LBSIZE(mp));
 			ASSERT(be16_to_cpu(new_leaf->hdr.freemap[0].size) < XFS_LBSIZE(mp));
diff --git a/repair/dir2.c b/repair/dir2.c
index f9562d7..3d5e1eb 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -776,7 +776,7 @@ process_sf_dir2_fixi8(
 	int			oldsize;
 
 	newsfp = sfp;
-	oldsize = (__psint_t)*next_sfep - (__psint_t)sfp;
+	oldsize = (intptr_t)*next_sfep - (intptr_t)sfp;
 	oldsfp = malloc(oldsize);
 	if (oldsfp == NULL) {
 		do_error(_("couldn't malloc dir2 shortform copy\n"));
@@ -988,8 +988,8 @@ _("entry \"%*.*s\" in shortform directory %" PRIu64 " references %s inode %" PRI
 
 			if (i == num_entries - 1)  {
 				namelen = ino_dir_size -
-					((__psint_t) &sfep->name[0] -
-					 (__psint_t) sfp);
+					((intptr_t)&sfep->name[0] -
+					 (intptr_t)sfp);
 				if (!no_modify)  {
 					do_warn(
 _("zero length entry in shortform dir %" PRIu64 ", resetting to %d\n"),
@@ -1016,15 +1016,15 @@ _("zero length entry in shortform dir %" PRIu64 ""),
 				 */
 				break;
 			}
-		} else if ((__psint_t) sfep - (__psint_t) sfp +
+		} else if ((intptr_t)sfep - (intptr_t)sfp +
 				xfs_dir2_sf_entsize_byentry(sfp, sfep)
 							> ino_dir_size)  {
 			bad_sfnamelen = 1;
 
 			if (i == num_entries - 1)  {
 				namelen = ino_dir_size -
-					((__psint_t) &sfep->name[0] -
-					 (__psint_t) sfp);
+					((intptr_t)&sfep->name[0] -
+					 (intptr_t)sfp);
 				do_warn(
 _("size of last entry overflows space left in in shortform dir %" PRIu64 ", "),
 					ino);
@@ -1111,15 +1111,15 @@ _("entry contains offset out of order in shortform dir %" PRIu64 "\n"),
 				ino_dir_size -= tmp_elen;
 
 				tmp_sfep = (xfs_dir2_sf_entry_t *)
-					((__psint_t) sfep + tmp_elen);
-				tmp_len = max_size - ((__psint_t) tmp_sfep
-							- (__psint_t) sfp);
+					((intptr_t)sfep + tmp_elen);
+				tmp_len = max_size - ((intptr_t)tmp_sfep
+							- (intptr_t)sfp);
 
 				memmove(sfep, tmp_sfep, tmp_len);
 
 				sfp->hdr.count -= 1;
 				num_entries--;
-				memset((void *) ((__psint_t) sfep + tmp_len), 0,
+				memset((void *) ((intptr_t)sfep + tmp_len), 0,
 					tmp_elen);
 
 				/*
@@ -1157,7 +1157,7 @@ _("would have junked entry \"%s\" in directory inode %" PRIu64 "\n"),
 		 * calculate size based on next_sfep.
 		 */
 		next_sfep = (tmp_sfep == NULL)
-			? (xfs_dir2_sf_entry_t *) ((__psint_t) sfep
+			? (xfs_dir2_sf_entry_t *) ((intptr_t)sfep
 				+ ((!bad_sfnamelen)
 					? xfs_dir2_sf_entsize_byentry(sfp,
 						sfep)
@@ -1214,7 +1214,7 @@ _("corrected directory %" PRIu64 " size, was %" PRId64 ", now %" PRIdPTR "\n"),
 				(intptr_t)next_sfep - (intptr_t)sfp);
 
 			dip->di_size = cpu_to_be64(
-					(__psint_t)next_sfep - (__psint_t)sfp);
+					(intptr_t)next_sfep - (intptr_t)sfp);
 			*dino_dirty = 1;
 			*repair = 1;
 		}
diff --git a/repair/phase5.c b/repair/phase5.c
index 7d5cd49..1dc0e47 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1216,8 +1216,9 @@ build_agf_agfl(xfs_mount_t	*mp,
 	memset(agf, 0, mp->m_sb.sb_sectsize);
 
 #ifdef XR_BLD_FREE_TRACE
-	fprintf(stderr, "agf = 0x%x, agf_buf->b_un.b_addr = 0x%x\n",
-		(__psint_t) agf, (__psint_t) agf_buf->b_un.b_addr);
+	fprintf(stderr, "agf = 0x%lx, agf_buf->b_un.b_addr = 0x%lx\n",
+		(unsigned long)(intptr_t)agf,
+		(unsigned long)(intptr_t)agf_buf->b_un.b_addr);
 #endif
 
 	/*
diff --git a/repair/phase6.c b/repair/phase6.c
index cbe0b35..c4b52cc 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -568,7 +568,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
-		bmp = (xfs_rtword_t *)((__psint_t) bmp + mp->m_sb.sb_blocksize);
+		bmp = (xfs_rtword_t *)((intptr_t)bmp + mp->m_sb.sb_blocksize);
 		bno++;
 	}
 
@@ -637,7 +637,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
-		smp = (xfs_suminfo_t *)((__psint_t)smp + mp->m_sb.sb_blocksize);
+		smp = (xfs_suminfo_t *)((intptr_t)smp + mp->m_sb.sb_blocksize);
 		bno++;
 	}
 
@@ -2642,7 +2642,7 @@ shortform_dir_entry_check(xfs_mount_t	*mp,
 		}
 	else {
 	   for (i = 0; i < sf->hdr.count && max_size >
-				(__psint_t)next_sfe - (__psint_t)sf;
+				(intptr_t)next_sfe - (intptr_t)sf;
 			sf_entry = next_sfe, i++)  {
 		junkit = 0;
 		bad_sfnamelen = 0;
@@ -2667,8 +2667,8 @@ shortform_dir_entry_check(xfs_mount_t	*mp,
 
 			if (i == sf->hdr.count - 1)  {
 				namelen = ip->i_d.di_size -
-					((__psint_t) &sf_entry->name[0] -
-					 (__psint_t) sf);
+					((intptr_t)&sf_entry->name[0] -
+					 (intptr_t)sf);
 			} else  {
 				/*
 				 * don't process the rest of the directory,
@@ -2676,15 +2676,15 @@ shortform_dir_entry_check(xfs_mount_t	*mp,
 				 */
 				break;
 			}
-		} else if (no_modify && (__psint_t) sf_entry - (__psint_t) sf +
+		} else if (no_modify && (intptr_t)sf_entry - (intptr_t)sf +
 				+ xfs_dir_sf_entsize_byentry(sf_entry)
 				> ip->i_d.di_size)  {
 			bad_sfnamelen = 1;
 
 			if (i == sf->hdr.count - 1)  {
 				namelen = ip->i_d.di_size -
-					((__psint_t) &sf_entry->name[0] -
-					 (__psint_t) sf);
+					((intptr_t)&sf_entry->name[0] -
+					 (intptr_t)sf);
 			} else  {
 				/*
 				 * don't process the rest of the directory,
@@ -2759,7 +2759,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 			 */
 			add_inode_reached(irec, ino_offset);
 
-			next_sfe = (xfs_dir_sf_entry_t *)((__psint_t)sf_entry +
+			next_sfe = (xfs_dir_sf_entry_t *)((intptr_t)sf_entry +
 					xfs_dir_sf_entsize_byentry(sf_entry));
 			continue;
 		} else  {
@@ -2801,16 +2801,16 @@ do_junkit:
 			if (!no_modify)  {
 				tmp_elen = xfs_dir_sf_entsize_byentry(sf_entry);
 				tmp_sfe = (xfs_dir_sf_entry_t *)
-					((__psint_t) sf_entry + tmp_elen);
-				tmp_len = max_size - ((__psint_t) tmp_sfe
-							- (__psint_t) sf);
+					((intptr_t)sf_entry + tmp_elen);
+				tmp_len = max_size - ((intptr_t)tmp_sfe
+							- (intptr_t)sf);
 				max_size -= tmp_elen;
 				bytes_deleted += tmp_elen;
 
 				memmove(sf_entry, tmp_sfe, tmp_len);
 
 				sf->hdr.count -= 1;
-				memset((void *)((__psint_t)sf_entry + tmp_len),
+				memset((void *)((intptr_t)sf_entry + tmp_len),
 						0, tmp_elen);
 
 				/*
@@ -2848,7 +2848,7 @@ do_junkit:
 		ASSERT(no_modify || bad_sfnamelen == 0);
 
 		next_sfe = (tmp_sfe == NULL)
-			? (xfs_dir_sf_entry_t *) ((__psint_t) sf_entry
+			? (xfs_dir_sf_entry_t *) ((intptr_t)sf_entry
 				+ ((!bad_sfnamelen)
 					? xfs_dir_sf_entsize_byentry(sf_entry)
 					: sizeof(xfs_dir_sf_entry_t) - 1
@@ -2869,9 +2869,9 @@ do_junkit:
 
 	if (ip->i_d.di_size != ip->i_df.if_bytes)  {
 		ASSERT(ip->i_df.if_bytes == (xfs_fsize_t)
-				((__psint_t) next_sfe - (__psint_t) sf));
+				((intptr_t)next_sfe - (intptr_t)sf));
 		ip->i_d.di_size = (xfs_fsize_t)
-				((__psint_t) next_sfe - (__psint_t) sf);
+				((intptr_t)next_sfe - (intptr_t)sf);
 		do_warn(
 		_("setting size to %" PRId64 " bytes to reflect junked entries\n"),
 				ip->i_d.di_size);
@@ -2959,7 +2959,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 	sfep = next_sfep = xfs_dir2_sf_firstentry(sfp);
 
 	for (i = 0; i < sfp->hdr.count && max_size >
-					(__psint_t)next_sfep - (__psint_t)sfp;
+					(intptr_t)next_sfep - (intptr_t)sfp;
 			sfep = next_sfep, i++)  {
 		junkit = 0;
 		bad_sfnamelen = 0;
@@ -2984,8 +2984,8 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 
 			if (i == sfp->hdr.count - 1)  {
 				namelen = ip->i_d.di_size -
-					((__psint_t) &sfep->name[0] -
-					 (__psint_t) sfp);
+					((intptr_t)&sfep->name[0] -
+					 (intptr_t)sfp);
 			} else  {
 				/*
 				 * don't process the rest of the directory,
@@ -2993,15 +2993,15 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 				 */
 				break;
 			}
-		} else if (no_modify && (__psint_t) sfep - (__psint_t) sfp +
+		} else if (no_modify && (intptr_t)sfep - (intptr_t)sfp +
 				+ xfs_dir2_sf_entsize_byentry(sfp, sfep)
 				> ip->i_d.di_size)  {
 			bad_sfnamelen = 1;
 
 			if (i == sfp->hdr.count - 1)  {
 				namelen = ip->i_d.di_size -
-					((__psint_t) &sfep->name[0] -
-					 (__psint_t) sfp);
+					((intptr_t)&sfep->name[0] -
+					 (intptr_t)sfp);
 			} else  {
 				/*
 				 * don't process the rest of the directory,
@@ -3023,7 +3023,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 		 */
 
 		if (no_modify && verify_inum(mp, lino))  {
-			next_sfep = (xfs_dir2_sf_entry_t *)((__psint_t)sfep +
+			next_sfep = (xfs_dir2_sf_entry_t *)((intptr_t)sfep +
 					xfs_dir2_sf_entsize_byentry(sfp, sfep));
 			continue;
 		}
@@ -3134,16 +3134,16 @@ do_junkit:
 			if (!no_modify)  {
 				tmp_elen = xfs_dir2_sf_entsize_byentry(sfp, sfep);
 				tmp_sfep = (xfs_dir2_sf_entry_t *)
-					((__psint_t) sfep + tmp_elen);
-				tmp_len = max_size - ((__psint_t) tmp_sfep
-							- (__psint_t) sfp);
+					((intptr_t)sfep + tmp_elen);
+				tmp_len = max_size - ((intptr_t)tmp_sfep
+							- (intptr_t)sfp);
 				max_size -= tmp_elen;
 				bytes_deleted += tmp_elen;
 
 				memmove(sfep, tmp_sfep, tmp_len);
 
 				sfp->hdr.count -= 1;
-				memset((void *)((__psint_t)sfep + tmp_len), 0,
+				memset((void *)((intptr_t)sfep + tmp_len), 0,
 						tmp_elen);
 
 				/*
@@ -3182,7 +3182,7 @@ do_junkit:
 		ASSERT(no_modify || bad_sfnamelen == 0);
 
 		next_sfep = (tmp_sfep == NULL)
-			? (xfs_dir2_sf_entry_t *) ((__psint_t) sfep
+			? (xfs_dir2_sf_entry_t *) ((intptr_t)sfep
 				+ ((!bad_sfnamelen)
 					? xfs_dir2_sf_entsize_byentry(sfp, sfep)
 					: xfs_dir2_sf_entsize_byname(sfp, namelen)))
@@ -3198,8 +3198,8 @@ do_junkit:
 				tmp_sfep = next_sfep;
 				process_sf_dir2_fixi8(sfp, &tmp_sfep);
 				bytes_deleted +=
-					(__psint_t)next_sfep -
-					(__psint_t)tmp_sfep;
+					(intptr_t)next_sfep -
+					(intptr_t)tmp_sfep;
 				next_sfep = tmp_sfep;
 			} else
 				sfp->hdr.i8count = i8;
@@ -3221,9 +3221,9 @@ do_junkit:
 
 	if (ip->i_d.di_size != ip->i_df.if_bytes)  {
 		ASSERT(ip->i_df.if_bytes == (xfs_fsize_t)
-				((__psint_t) next_sfep - (__psint_t) sfp));
+				((intptr_t)next_sfep - (intptr_t)sfp));
 		ip->i_d.di_size = (xfs_fsize_t)
-				((__psint_t) next_sfep - (__psint_t) sfp);
+				((intptr_t)next_sfep - (intptr_t)sfp);
 		do_warn(
 	_("setting size to %" PRId64 " bytes to reflect junked entries\n"),
 			ip->i_d.di_size);
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
