Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82HwJlr034430 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:58:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29E6915B1A32
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:58:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wuSfvCMm22hRDUfe for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:58:42 -0700 (PDT)
Message-Id: <20090902175841.711310240@bombadil.infradead.org>
Date: Wed, 02 Sep 2009 13:55:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/14] repair: cleanup alloc/free/reset of the block usage
	tracking
References: <20090902175531.469184575@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-cleanup-bmap-helpers-2
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
Cc: Barry Naujok <bnaujok@sgi.com>

Currently the code to allocate, free and reset the block usage bitmaps
is a complete mess.  This patch reorganizes it into logical helpers.

Details:

 - the current incore_init code is called just before phase2 is called,
   which then marks the log and the AG headers used.
 - we get rid of incore_init init, and replace it with direct calls to the
   unchanched incore_ino_init/incore_ext_init functions and our new init_bmaps
   which does all the allocations for the block usage tracking, aswell
   as a call to reset_bmaps to initialize it to the default values.
 - reset_bmaps is also called from early phase4 code to reset all state
   instead of opencoding it.
 - there is a new free_bmaps helper which we call to free our block usage
   bitmaps when we don't need them anymore after phase5.  The current
   code frees some of it a bit early in phase5, but needs to take of it
   in phase6 in case we didn't call phase5 due to nomodify mode, and leaks
   it if we don't call phase 6, which might happen in case of a bad inode
   allocation btree.


Signed-off-by: Barry Naujok <bnaujok@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/phase4.c
===================================================================
--- xfsprogs-dev.orig/repair/phase4.c	2009-08-21 01:59:26.000000000 +0000
+++ xfsprogs-dev/repair/phase4.c	2009-08-21 02:41:44.000000000 +0000
@@ -355,19 +355,7 @@ phase4(xfs_mount_t *mp)
 	/*
 	 * initialize bitmaps for all AGs
 	 */
-	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
-		/*
-		 * now reset the bitmap for all ags
-		 */
-		memset(ba_bmap[i], 0,
-		    roundup((mp->m_sb.sb_agblocks+(NBBY/XR_BB)-1)/(NBBY/XR_BB),
-						sizeof(__uint64_t)));
-		for (j = 0; j < ag_hdr_block; j++)
-			set_bmap(i, j, XR_E_INUSE_FS);
-	}
-	set_bmap_rt(mp->m_sb.sb_rextents);
-	set_bmap_log(mp);
-	set_bmap_fs(mp);
+	reset_bmaps(mp);
 
 	do_log(_("        - check for inodes claiming duplicate blocks...\n"));
 	set_progress_msg(PROG_FMT_DUP_BLOCKS, (__uint64_t) mp->m_sb.sb_icount);
Index: xfsprogs-dev/repair/incore.c
===================================================================
--- xfsprogs-dev.orig/repair/incore.c	2009-08-21 01:59:26.000000000 +0000
+++ xfsprogs-dev/repair/incore.c	2009-08-21 03:02:28.000000000 +0000
@@ -52,205 +52,117 @@ free_allocations(ba_rec_t *list)
 	return;
 }
 
-/* ba bmap setupstuff.  setting/getting state is in incore.h  */
 
-void
-setup_bmap(xfs_agnumber_t agno, xfs_agblock_t numblocks, xfs_drtbno_t rtblocks)
-{
-	int i;
-	size_t size = 0;
+static size_t		rt_bmap_size;
 
-	ba_bmap = (__uint64_t**)malloc(agno*sizeof(__uint64_t *));
-	if (!ba_bmap)
-		do_error(_("couldn't allocate block map pointers\n"));
-	ag_locks = malloc(agno * sizeof(pthread_mutex_t));
-	if (!ag_locks)
-		do_error(_("couldn't allocate block map locks\n"));
-
-	for (i = 0; i < agno; i++)  {
-		size = roundup((numblocks+(NBBY/XR_BB)-1) / (NBBY/XR_BB),
-		       		sizeof(__uint64_t));
-
-		ba_bmap[i] = (__uint64_t*)memalign(sizeof(__uint64_t), size);
-		if (!ba_bmap[i]) {
-			do_error(_("couldn't allocate block map, size = %d\n"),
-				numblocks);
-			return;
-		}
-		memset(ba_bmap[i], 0, size);
-		pthread_mutex_init(&ag_locks[i], NULL);
-	}
+static void
+reset_rt_bmap(void)
+{
+	if (rt_ba_bmap)
+		memset(rt_ba_bmap, 0x22, rt_bmap_size);	/* XR_E_FREE */
+}
 
-	if (rtblocks == 0)  {
-		rt_ba_bmap = NULL;
+static void
+init_rt_bmap(
+	xfs_mount_t	*mp)
+{
+	if (mp->m_sb.sb_rextents == 0)
 		return;
-	}
 
-	size = roundup(rtblocks / (NBBY/XR_BB), sizeof(__uint64_t));
+	rt_bmap_size = roundup(mp->m_sb.sb_rextents / (NBBY / XR_BB),
+			       sizeof(__uint64_t));
 
-	rt_ba_bmap=(__uint64_t*)memalign(sizeof(__uint64_t), size);
+	rt_ba_bmap = memalign(sizeof(__uint64_t), rt_bmap_size);
 	if (!rt_ba_bmap) {
-			do_error(
+		do_error(
 		_("couldn't allocate realtime block map, size = %llu\n"),
-				rtblocks);
-			return;
+			mp->m_sb.sb_rextents);
+		return;
 	}
-
-	/*
-	 * start all real-time as free blocks
-	 */
-	set_bmap_rt(rtblocks);
-
-	return;
 }
 
-/* ARGSUSED */
-void
-teardown_rt_bmap(xfs_mount_t *mp)
+static void
+free_rt_bmap(xfs_mount_t *mp)
 {
-	if (rt_ba_bmap != NULL)  {
-		free(rt_ba_bmap);
-		rt_ba_bmap = NULL;
-	}
-
-	return;
+	free(rt_ba_bmap);
+	rt_ba_bmap = NULL;
 }
 
-/* ARGSUSED */
-void
-teardown_ag_bmap(xfs_mount_t *mp, xfs_agnumber_t agno)
-{
-	ASSERT(ba_bmap[agno] != NULL);
-
-	free(ba_bmap[agno]);
-	ba_bmap[agno] = NULL;
-
-	return;
-}
 
-/* ARGSUSED */
 void
-teardown_bmap_finish(xfs_mount_t *mp)
+reset_bmaps(xfs_mount_t *mp)
 {
-	free(ba_bmap);
-	ba_bmap = NULL;
-
-	return;
-}
+	xfs_agnumber_t	agno;
+	int		ag_hdr_block;
+	int		i;
 
-void
-teardown_bmap(xfs_mount_t *mp)
-{
-	xfs_agnumber_t i;
+	ag_hdr_block = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
 
-	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
-		teardown_ag_bmap(mp, i);
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)  {
+		memset(ba_bmap[agno], 0,
+		       roundup((mp->m_sb.sb_agblocks + (NBBY / XR_BB) - 1) /
+				(NBBY / XR_BB), sizeof(__uint64_t)));
+		for (i = 0; i < ag_hdr_block; i++)
+			set_bmap(agno, i, XR_E_INUSE_FS);
 	}
 
-	teardown_rt_bmap(mp);
-	teardown_bmap_finish(mp);
+	if (mp->m_sb.sb_logstart != 0) {
+		xfs_dfsbno_t	logend;
 
-	return;
-}
+		logend = mp->m_sb.sb_logstart + mp->m_sb.sb_logblocks;
 
-/*
- * block map initialization routines -- realtime, log, fs
- */
-void
-set_bmap_rt(xfs_drtbno_t num)
-{
-	xfs_drtbno_t j;
-	xfs_drtbno_t size;
-
-	/*
-	 * for now, initialize all realtime blocks to be free
-	 * (state == XR_E_FREE)
-	 */
-	size = howmany(num / (NBBY/XR_BB), sizeof(__uint64_t));
-
-	for (j = 0; j < size; j++)
-		rt_ba_bmap[j] = 0x2222222222222222LL;
-
-	return;
-}
-
-void
-set_bmap_log(xfs_mount_t *mp)
-{
-	xfs_dfsbno_t	logend, i;
-
-	if (mp->m_sb.sb_logstart == 0)
-		return;
-
-	logend = mp->m_sb.sb_logstart + mp->m_sb.sb_logblocks;
-
-	for (i = mp->m_sb.sb_logstart; i < logend ; i++)  {
-		set_bmap(XFS_FSB_TO_AGNO(mp, i),
-			 XFS_FSB_TO_AGBNO(mp, i), XR_E_INUSE_FS);
+		for (i = mp->m_sb.sb_logstart; i < logend ; i++)  {
+			set_bmap(XFS_FSB_TO_AGNO(mp, i),
+				 XFS_FSB_TO_AGBNO(mp, i), XR_E_INUSE_FS);
+		}
 	}
 
-	return;
+	reset_rt_bmap();
 }
 
 void
-set_bmap_fs(xfs_mount_t *mp)
+init_bmaps(xfs_mount_t *mp)
 {
-	xfs_agnumber_t	i;
-	xfs_agblock_t	j;
-	xfs_agblock_t	end;
-
-	/*
-	 * AG header is 4 sectors
-	 */
-	end = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
+	xfs_agblock_t numblocks = mp->m_sb.sb_agblocks;
+	int agcount = mp->m_sb.sb_agcount;
+	int i;
+	size_t size = 0;
 
-	for (i = 0; i < mp->m_sb.sb_agcount; i++)
-		for (j = 0; j < end; j++)
-			set_bmap(i, j, XR_E_INUSE_FS);
+	ba_bmap = calloc(agcount, sizeof(__uint64_t *));
+	if (!ba_bmap)
+		do_error(_("couldn't allocate block map pointers\n"));
 
-	return;
-}
+	ag_locks = calloc(agcount, sizeof(pthread_mutex_t));
+	if (!ag_locks)
+		do_error(_("couldn't allocate block map locks\n"));
 
-#if 0
-void
-set_bmap_fs_bt(xfs_mount_t *mp)
-{
-	xfs_agnumber_t	i;
-	xfs_agblock_t	j;
-	xfs_agblock_t	begin;
-	xfs_agblock_t	end;
-
-	begin = bnobt_root;
-	end = inobt_root + 1;
-
-	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
-		/*
-		 * account for btree roots
-		 */
-		for (j = begin; j < end; j++)
-			set_bmap(i, j, XR_E_INUSE_FS);
+	for (i = 0; i < agcount; i++)  {
+		size = roundup((numblocks+(NBBY/XR_BB)-1) / (NBBY/XR_BB),
+		       		sizeof(__uint64_t));
+
+		ba_bmap[i] = memalign(sizeof(__uint64_t), size);
+		if (!ba_bmap[i]) {
+			do_error(_("couldn't allocate block map, size = %d\n"),
+				numblocks);
+			return;
+		}
+		memset(ba_bmap[i], 0, size);
+		pthread_mutex_init(&ag_locks[i], NULL);
 	}
 
-	return;
+	init_rt_bmap(mp);
+	reset_bmaps(mp);
 }
-#endif
 
 void
-incore_init(xfs_mount_t *mp)
+free_bmaps(xfs_mount_t *mp)
 {
-	int agcount = mp->m_sb.sb_agcount;
-	extern void incore_ino_init(xfs_mount_t *);
-	extern void incore_ext_init(xfs_mount_t *);
-
-	/* init block alloc bmap */
-
-	setup_bmap(agcount, mp->m_sb.sb_agblocks, mp->m_sb.sb_rextents);
-	incore_ino_init(mp);
-	incore_ext_init(mp);
-
-	/* initialize random globals now that we know the fs geometry */
+	xfs_agnumber_t i;
 
-	inodes_per_block = mp->m_sb.sb_inopblock;
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+		free(ba_bmap[i]);
+	free(ba_bmap);
+	ba_bmap = NULL;
 
-	return;
+	free_rt_bmap(mp);
 }
Index: xfsprogs-dev/repair/incore.h
===================================================================
--- xfsprogs-dev.orig/repair/incore.h	2009-08-21 01:59:26.000000000 +0000
+++ xfsprogs-dev/repair/incore.h	2009-08-21 03:00:13.000000000 +0000
@@ -43,14 +43,10 @@ void			free_allocations(ba_rec_t *list);
  */
 #define BA_BMAP_SIZE(x)		(howmany(x, 4))
 
-void			set_bmap_rt(xfs_drfsbno_t numblocks);
-void			set_bmap_log(xfs_mount_t *mp);
-void			set_bmap_fs(xfs_mount_t *mp);
-void			teardown_bmap(xfs_mount_t *mp);
-
-void			teardown_rt_bmap(xfs_mount_t *mp);
-void			teardown_ag_bmap(xfs_mount_t *mp, xfs_agnumber_t agno);
-void			teardown_bmap_finish(xfs_mount_t *mp);
+void			init_bmaps(xfs_mount_t *mp);
+void			reset_bmaps(xfs_mount_t *mp);
+void			free_bmaps(xfs_mount_t *mp);
+
 
 /* blocks are numbered from zero */
 
@@ -254,6 +250,7 @@ void		release_agbcnt_extent_tree(xfs_agn
  */
 void		free_rt_dup_extent_tree(xfs_mount_t *mp);
 
+void		incore_ext_init(xfs_mount_t *);
 /*
  * per-AG extent trees shutdown routine -- all (bno, bcnt and dup)
  * at once.  this one actually frees the memory instead of just recyling
@@ -261,6 +258,8 @@ void		free_rt_dup_extent_tree(xfs_mount_
  */
 void		incore_ext_teardown(xfs_mount_t *mp);
 
+void		incore_ino_init(xfs_mount_t *);
+
 /*
  * inode definitions
  */
Index: xfsprogs-dev/repair/phase2.c
===================================================================
--- xfsprogs-dev.orig/repair/phase2.c	2009-08-21 02:04:25.000000000 +0000
+++ xfsprogs-dev/repair/phase2.c	2009-08-21 02:41:43.000000000 +0000
@@ -134,12 +134,6 @@ phase2(xfs_mount_t *mp)
 
 	do_log(_("        - scan filesystem freespace and inode maps...\n"));
 
-	/*
-	 * account for space used by ag headers and log if internal
-	 */
-	set_bmap_log(mp);
-	set_bmap_fs(mp);
-
 	bad_ino_btree = 0;
 
 	set_progress_msg(PROG_FMT_SCAN_AG, (__uint64_t) glob_agcount);
Index: xfsprogs-dev/repair/xfs_repair.c
===================================================================
--- xfsprogs-dev.orig/repair/xfs_repair.c	2009-08-21 02:47:02.000000000 +0000
+++ xfsprogs-dev/repair/xfs_repair.c	2009-08-21 03:03:51.000000000 +0000
@@ -39,7 +39,6 @@ extern void	phase4(xfs_mount_t *);
 extern void	phase5(xfs_mount_t *);
 extern void	phase6(xfs_mount_t *);
 extern void	phase7(xfs_mount_t *);
-extern void	incore_init(xfs_mount_t *);
 
 #define		XR_MAX_SECT_SIZE	(64 * 1024)
 
@@ -694,9 +693,14 @@ main(int argc, char **argv)
 	calc_mkfs(mp);
 
 	/*
-	 * check sb filesystem stats and initialize in-core data structures
+	 * initialize block alloc map
 	 */
-	incore_init(mp);
+	init_bmaps(mp);
+	incore_ino_init(mp);
+	incore_ext_init(mp);
+
+	/* initialize random globals now that we know the fs geometry */
+	inodes_per_block = mp->m_sb.sb_inopblock;
 
 	if (parse_sb_version(&mp->m_sb))  {
 		do_warn(
@@ -724,6 +728,11 @@ main(int argc, char **argv)
 	}
 	timestamp(PHASE_END, 5, NULL);
 
+	/*
+	 * Done with the block usage maps, toss them...
+	 */
+	free_bmaps(mp);
+
 	if (!bad_ino_btree)  {
 		phase6(mp);
 		timestamp(PHASE_END, 6, NULL);
Index: xfsprogs-dev/repair/phase6.c
===================================================================
--- xfsprogs-dev.orig/repair/phase6.c	2009-08-21 02:44:58.000000000 +0000
+++ xfsprogs-dev/repair/phase6.c	2009-08-21 02:54:54.000000000 +0000
@@ -3661,11 +3661,6 @@ phase6(xfs_mount_t *mp)
 
 	do_log(_("Phase 6 - check inode connectivity...\n"));
 
-	if (!no_modify)
-		teardown_bmap_finish(mp);
-	else
-		teardown_bmap(mp);
-
 	incore_ext_teardown(mp);
 
 	add_ino_ex_data(mp);
Index: xfsprogs-dev/repair/phase5.c
===================================================================
--- xfsprogs-dev.orig/repair/phase5.c	2009-08-21 02:42:26.000000000 +0000
+++ xfsprogs-dev/repair/phase5.c	2009-08-21 03:00:07.000000000 +0000
@@ -1465,11 +1465,6 @@ phase5_func(
 		}
 
 		/*
-		 * done with the AG bitmap, toss it...
-		 */
-		teardown_ag_bmap(mp, agno);
-
-		/*
 		 * ok, now set up the btree cursors for the
 		 * on-disk btrees (includs pre-allocating all
 		 * required blocks for the trees themselves)
@@ -1655,7 +1650,6 @@ phase5(xfs_mount_t *mp)
 		_("        - generate realtime summary info and bitmap...\n"));
 		rtinit(mp);
 		generate_rtinfo(mp, btmcompute, sumcompute);
-		teardown_rt_bmap(mp);
 	}
 
 	do_log(_("        - reset superblock...\n"));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
