Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17Hs33P248932 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 11:54:04 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	t4tPJjPPyhr8UCrz (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Feb 2012 09:54:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RupEu-0006K0-Lr
	for xfs@oss.sgi.com; Tue, 07 Feb 2012 17:54:00 +0000
Date: Tue, 7 Feb 2012 12:54:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] repair: fix incorrect use of thread local data in dir and
	attr code
Message-ID: <20120207175400.GA24301@infradead.org>
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

The attribute and dirv1 code use pthread thread local data incorrectly in
a few places, which will make them fail in horrible ways when using the
ag_stride options.

Replace the use of thread local data with simple local allocations given
that there is no needed to micro-optimize these allocations as much
as e.g. the extent map.  The added benefit is that we have to allocate
less memory, and can free it quickly.

Reported-by: Tom Crane <T.Crane@rhul.ac.uk>
Tested-by: Tom Crane <T.Crane@rhul.ac.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/attr_repair.c
===================================================================
--- xfsprogs-dev.orig/repair/attr_repair.c	2012-02-02 09:25:50.000000000 +0000
+++ xfsprogs-dev/repair/attr_repair.c	2012-02-02 11:14:06.000000000 +0000
@@ -363,12 +363,6 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t in
 	return (clearit);
 }
 
-/*
- * freespace map for directory and attribute leaf blocks (1 bit per byte)
- * 1 == used, 0 == free
- */
-size_t ts_attr_freemap_size = sizeof(da_freemap_t) * DA_BMAP_SIZE;
-
 /* The block is read in. The magic number and forward / backward
  * links are checked by the caller process_leaf_attr.
  * If any problems occur the routine returns with non-zero. In
@@ -503,7 +497,7 @@ process_leaf_attr_block(
 {
 	xfs_attr_leaf_entry_t *entry;
 	int  i, start, stop, clearit, usedbs, firstb, thissize;
-	da_freemap_t *attr_freemap = ts_attr_freemap();
+	da_freemap_t *attr_freemap;
 
 	clearit = usedbs = 0;
 	*repair = 0;
@@ -519,7 +513,7 @@ process_leaf_attr_block(
 		return (1);
 	}
 
-	init_da_freemap(attr_freemap);
+	attr_freemap = alloc_da_freemap(mp);
 	(void) set_da_freemap(mp, attr_freemap, 0, stop);
 
 	/* go thru each entry checking for problems */
@@ -636,6 +630,8 @@ process_leaf_attr_block(
 		* we can add it then.
 		*/
 	}
+
+	free(attr_freemap);
 	return (clearit);  /* and repair */
 }
 
Index: xfsprogs-dev/repair/dir.c
===================================================================
--- xfsprogs-dev.orig/repair/dir.c	2012-02-02 09:25:50.000000000 +0000
+++ xfsprogs-dev/repair/dir.c	2012-02-02 11:17:20.000000000 +0000
@@ -495,23 +495,19 @@ process_shortform_dir(
 }
 
 /*
- * freespace map for directory leaf blocks (1 bit per byte)
- * 1 == used, 0 == free
+ * Allocate a freespace map for directory or attr leaf blocks (1 bit per byte)
+ * 1 == used, 0 == free.
  */
-size_t ts_dir_freemap_size = sizeof(da_freemap_t) * DA_BMAP_SIZE;
-
-void
-init_da_freemap(da_freemap_t *dir_freemap)
+da_freemap_t *
+alloc_da_freemap(struct xfs_mount *mp)
 {
-	memset(dir_freemap, 0, sizeof(da_freemap_t) * DA_BMAP_SIZE);
+	return calloc(1, mp->m_sb.sb_blocksize / NBBY);
 }
 
 /*
- * sets directory freemap, returns 1 if there is a conflict
- * returns 0 if everything's good.  the range [start, stop) is set.
- * right now, we just use the static array since only one directory
- * block will be processed at once even though the interface allows
- * you to pass in arbitrary da_freemap_t array's.
+ * Set the he range [start, stop) in the directory freemap.
+ *
+ * Returns 1 if there is a conflict or 0 if everything's good.
  *
  * Within a char, the lowest bit of the char represents the byte with
  * the smallest address
@@ -728,28 +724,6 @@ _("- derived hole (base %d, size %d) in
 	return(res);
 }
 
-#if 0
-void
-test(xfs_mount_t *mp)
-{
-	int i = 0;
-	da_hole_map_t	holemap;
-
-	init_da_freemap(dir_freemap);
-	memset(&holemap, 0, sizeof(da_hole_map_t));
-
-	set_da_freemap(mp, dir_freemap, 0, 50);
-	set_da_freemap(mp, dir_freemap, 100, 126);
-	set_da_freemap(mp, dir_freemap, 126, 129);
-	set_da_freemap(mp, dir_freemap, 130, 131);
-	set_da_freemap(mp, dir_freemap, 150, 160);
-	process_da_freemap(mp, dir_freemap, &holemap);
-
-	return;
-}
-#endif
-
-
 /*
  * walk tree from root to the left-most leaf block reading in
  * blocks and setting up cursor.  passes back file block number of the
@@ -1366,8 +1340,6 @@ verify_da_path(xfs_mount_t	*mp,
 	return(0);
 }
 
-size_t ts_dirbuf_size = 64*1024;
-
 /*
  * called by both node dir and leaf dir processing routines
  * validates all contents *but* the sibling pointers (forw/back)
@@ -1441,7 +1413,7 @@ process_leaf_dir_block(
 	char				fname[MAXNAMELEN + 1];
 	da_hole_map_t			holemap;
 	da_hole_map_t			bholemap;
-	unsigned char			*dir_freemap = ts_dir_freemap();
+	da_freemap_t			*dir_freemap;
 
 #ifdef XR_DIR_TRACE
 	fprintf(stderr, "\tprocess_leaf_dir_block - ino %" PRIu64 "\n", ino);
@@ -1450,7 +1422,7 @@ process_leaf_dir_block(
 	/*
 	 * clear static dir block freespace bitmap
 	 */
-	init_da_freemap(dir_freemap);
+	dir_freemap = alloc_da_freemap(mp);
 
 	*buf_dirty = 0;
 	first_used = mp->m_sb.sb_blocksize;
@@ -1462,7 +1434,8 @@ process_leaf_dir_block(
 		do_warn(
 _("directory block header conflicts with used space in directory inode %" PRIu64 "\n"),
 			ino);
-		return(1);
+		res = 1;
+		goto out;
 	}
 
 	/*
@@ -1778,8 +1751,8 @@ _("entry references free inode %" PRIu64
 			do_warn(
 _("bad size, entry #%d in dir inode %" PRIu64 ", block %u -- entry overflows block\n"),
 				i, ino, da_bno);
-
-			return(1);
+			res = 1;
+			goto out;
 		}
 
 		start = (__psint_t)&leaf->entries[i] - (__psint_t)leaf;;
@@ -1789,7 +1762,8 @@ _("bad size, entry #%d in dir inode %" P
 			do_warn(
 _("dir entry slot %d in block %u conflicts with used space in dir inode %" PRIu64 "\n"),
 				i, da_bno, ino);
-			return(1);
+			res = 1;
+			goto out;
 		}
 
 		/*
@@ -2183,7 +2157,7 @@ _("- existing hole info for block %d, di
 			_("- compacting block %u in dir inode %" PRIu64 "\n"),
 					da_bno, ino);
 
-			new_leaf = (xfs_dir_leafblock_t *) ts_dirbuf();
+			new_leaf = malloc(mp->m_sb.sb_blocksize);
 
 			/*
 			 * copy leaf block header
@@ -2223,6 +2197,7 @@ _("- existing hole info for block %d, di
 					do_warn(
 	_("not enough space in block %u of dir inode %" PRIu64 " for all entries\n"),
 						da_bno, ino);
+					free(new_leaf);
 					break;
 				}
 
@@ -2284,6 +2259,7 @@ _("- existing hole info for block %d, di
 			 * final step, copy block back
 			 */
 			memmove(leaf, new_leaf, mp->m_sb.sb_blocksize);
+			free(new_leaf);
 
 			*buf_dirty = 1;
 		} else  {
@@ -2302,10 +2278,13 @@ _("- existing hole info for block %d, di
 		junk_zerolen_dir_leaf_entries(mp, leaf, ino, buf_dirty);
 	}
 #endif
+
+out:
+	free(dir_freemap);
 #ifdef XR_DIR_TRACE
 	fprintf(stderr, "process_leaf_dir_block returns %d\n", res);
 #endif
-	return((res > 0) ? 1 : 0);
+	return res > 0 ? 1 : 0;
 }
 
 /*
Index: xfsprogs-dev/repair/dir.h
===================================================================
--- xfsprogs-dev.orig/repair/dir.h	2012-02-02 09:28:58.000000000 +0000
+++ xfsprogs-dev/repair/dir.h	2012-02-02 11:09:41.000000000 +0000
@@ -21,9 +21,6 @@
 
 struct blkmap;
 
-/* 1 bit per byte, max XFS blocksize == 64K bits / NBBY */
-#define DA_BMAP_SIZE		8192
-
 typedef unsigned char	da_freemap_t;
 
 /*
@@ -81,9 +78,9 @@ get_first_dblock_fsbno(
 	xfs_ino_t	ino,
 	xfs_dinode_t	*dino);
 
-void
-init_da_freemap(
-	da_freemap_t *dir_freemap);
+da_freemap_t *
+alloc_da_freemap(
+	xfs_mount_t	*mp);
 
 int
 namecheck(
Index: xfsprogs-dev/repair/globals.h
===================================================================
--- xfsprogs-dev.orig/repair/globals.h	2012-02-02 09:33:29.000000000 +0000
+++ xfsprogs-dev/repair/globals.h	2012-02-02 09:34:49.000000000 +0000
@@ -185,10 +185,6 @@ EXTERN xfs_extlen_t	sb_inoalignmt;
 EXTERN __uint32_t	sb_unit;
 EXTERN __uint32_t	sb_width;
 
-extern size_t 		ts_dirbuf_size;
-extern size_t 		ts_dir_freemap_size;
-extern size_t 		ts_attr_freemap_size;
-
 EXTERN pthread_mutex_t	*ag_locks;
 
 EXTERN int 		report_interval;
Index: xfsprogs-dev/repair/init.c
===================================================================
--- xfsprogs-dev.orig/repair/init.c	2012-02-02 09:25:50.000000000 +0000
+++ xfsprogs-dev/repair/init.c	2012-02-02 09:37:02.000000000 +0000
@@ -29,67 +29,16 @@
 #include "prefetch.h"
 #include <sys/resource.h>
 
-/* TODO: dirbuf/freemap key usage is completely b0rked - only used for dirv1 */
-static pthread_key_t dirbuf_key;
-static pthread_key_t dir_freemap_key;
-static pthread_key_t attr_freemap_key;
-
 extern pthread_key_t dblkmap_key;
 extern pthread_key_t ablkmap_key;
 
 static void
-ts_alloc(pthread_key_t key, unsigned n, size_t size)
-{
-	void *voidp;
-	voidp = calloc(n, size);
-	if (voidp == NULL) {
-		do_error(_("ts_alloc: cannot allocate thread specific storage\n"));
-		/* NO RETURN */
-		return;
-	}
-	pthread_setspecific(key,  voidp);
-}
-
-static void
 ts_create(void)
 {
-	/* create thread specific keys */
-	pthread_key_create(&dirbuf_key, NULL);
-	pthread_key_create(&dir_freemap_key, NULL);
-	pthread_key_create(&attr_freemap_key, NULL);
-
 	pthread_key_create(&dblkmap_key, NULL);
 	pthread_key_create(&ablkmap_key, NULL);
 }
 
-void
-ts_init(void)
-{
-
-	/* allocate thread specific storage */
-	ts_alloc(dirbuf_key, 1, ts_dirbuf_size);
-	ts_alloc(dir_freemap_key, 1, ts_dir_freemap_size);
-	ts_alloc(attr_freemap_key, 1, ts_attr_freemap_size);
-}
-
-void *
-ts_dirbuf(void)
-{
-	return pthread_getspecific(dirbuf_key);
-}
-
-void *
-ts_dir_freemap(void)
-{
-	return pthread_getspecific(dir_freemap_key);
-}
-
-void *
-ts_attr_freemap(void)
-{
-	return pthread_getspecific(attr_freemap_key);
-}
-
 static void
 increase_rlimit(void)
 {
@@ -156,7 +105,6 @@ xfs_init(libxfs_init_t *args)
 		do_error(_("couldn't initialize XFS library\n"));
 
 	ts_create();
-	ts_init();
 	increase_rlimit();
 	pftrace_init();
 }
Index: xfsprogs-dev/repair/protos.h
===================================================================
--- xfsprogs-dev.orig/repair/protos.h	2012-02-02 09:33:29.000000000 +0000
+++ xfsprogs-dev/repair/protos.h	2012-02-02 09:36:42.000000000 +0000
@@ -41,9 +41,5 @@ char	*alloc_ag_buf(int size);
 void	print_inode_list(xfs_agnumber_t i);
 char *	err_string(int err_code);
 
-extern void *ts_attr_freemap(void);
-extern void *ts_dir_freemap(void);
-extern void *ts_dirbuf(void);
-extern void ts_init(void);
 extern void thread_init(void);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
