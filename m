Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4SJ0lFt237257 for <xfs@oss.sgi.com>; Fri, 28 May 2010 14:00:49 -0500
Date: Fri, 28 May 2010 15:03:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix access to upper inodes without inode64
Message-ID: <20100528190310.GA21403@infradead.org>
References: <20100527190515.GA16102@infradead.org>
	<1275070759.2302.14.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1275070759.2302.14.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, May 28, 2010 at 01:19:19PM -0500, Alex Elder wrote:
> >  		}
> > +
> > +		*maxagi = agcount;
> 
> Here you unconditionally assign to *maxagi...

Actually that hunk shouldn't be there, I think I sent you a previous
version of the patch before I did the final quilt refresh.  Below it
the final version, which also fixes your other nit:

---

From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: fix access to upper inodes without inode64

If a filesystem is mounted without the inode64 mount option we should still
be able to access inodes not fitting into 32 bits, just not created new
ones.  For this to work we need to make sure the inode cache radix tree
is initialized for all allocation groups, not just those we plan to allocate
inodes from.  This patch makes sure we initialize the inode cache radix
tree for all allocation groups, and also cleans xfs_initialize_perag up
a bit to separate the inode32 logical from the general perag structure
setup.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2010-05-28 20:57:59.014025018 +0200
+++ xfs/fs/xfs/xfs_mount.c	2010-05-28 20:58:53.579005781 +0200
@@ -413,17 +413,6 @@ xfs_mount_validate_sb(
 	return 0;
 }
 
-STATIC void
-xfs_initialize_perag_icache(
-	xfs_perag_t	*pag)
-{
-	if (!pag->pag_ici_init) {
-		rwlock_init(&pag->pag_ici_lock);
-		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-		pag->pag_ici_init = 1;
-	}
-}
-
 int
 xfs_initialize_perag(
 	xfs_mount_t	*mp,
@@ -436,13 +425,8 @@ xfs_initialize_perag(
 	xfs_agino_t	agino;
 	xfs_ino_t	ino;
 	xfs_sb_t	*sbp = &mp->m_sb;
-	xfs_ino_t	max_inum = XFS_MAXINUMBER_32;
 	int		error = -ENOMEM;
 
-	/* Check to see if the filesystem can overflow 32 bit inodes */
-	agino = XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks - 1, 0);
-	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
-
 	/*
 	 * Walk the current per-ag tree so we don't try to initialise AGs
 	 * that already exist (growfs case). Allocate and insert all the
@@ -456,11 +440,18 @@ xfs_initialize_perag(
 		}
 		if (!first_initialised)
 			first_initialised = index;
+
 		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
 		if (!pag)
 			goto out_unwind;
+		pag->pag_agno = index;
+		pag->pag_mount = mp;
+		rwlock_init(&pag->pag_ici_lock);
+		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+
 		if (radix_tree_preload(GFP_NOFS))
 			goto out_unwind;
+
 		spin_lock(&mp->m_perag_lock);
 		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
 			BUG();
@@ -469,25 +460,26 @@ xfs_initialize_perag(
 			error = -EEXIST;
 			goto out_unwind;
 		}
-		pag->pag_agno = index;
-		pag->pag_mount = mp;
 		spin_unlock(&mp->m_perag_lock);
 		radix_tree_preload_end();
 	}
 
-	/* Clear the mount flag if no inode can overflow 32 bits
-	 * on this filesystem, or if specifically requested..
+	/*
+	 * If we mount with the inode64 option, or no inode overflows
+	 * the legacy 32-bit address space clear the inode32 option.
 	 */
-	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > max_inum) {
+	agino = XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks - 1, 0);
+	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
+
+	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32)
 		mp->m_flags |= XFS_MOUNT_32BITINODES;
-	} else {
+	else
 		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
-	}
 
-	/* If we can overflow then setup the ag headers accordingly */
 	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
-		/* Calculate how much should be reserved for inodes to
-		 * meet the max inode percentage.
+		/*
+		 * Calculate how much should be reserved for inodes to meet
+		 * the max inode percentage.
 		 */
 		if (mp->m_maxicount) {
 			__uint64_t	icount;
@@ -500,30 +492,28 @@ xfs_initialize_perag(
 		} else {
 			max_metadata = agcount;
 		}
+
 		for (index = 0; index < agcount; index++) {
 			ino = XFS_AGINO_TO_INO(mp, index, agino);
-			if (ino > max_inum) {
+			if (ino > XFS_MAXINUMBER_32) {
 				index++;
 				break;
 			}
 
-			/* This ag is preferred for inodes */
 			pag = xfs_perag_get(mp, index);
 			pag->pagi_inodeok = 1;
 			if (index < max_metadata)
 				pag->pagf_metadata = 1;
-			xfs_initialize_perag_icache(pag);
 			xfs_perag_put(pag);
 		}
 	} else {
-		/* Setup default behavior for smaller filesystems */
 		for (index = 0; index < agcount; index++) {
 			pag = xfs_perag_get(mp, index);
 			pag->pagi_inodeok = 1;
-			xfs_initialize_perag_icache(pag);
 			xfs_perag_put(pag);
 		}
 	}
+
 	if (maxagi)
 		*maxagi = index;
 	return 0;
Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-05-28 20:57:58.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2010-05-28 20:58:09.538261854 +0200
@@ -164,10 +164,6 @@ xfs_inode_ag_iterator(
 		struct xfs_perag	*pag;
 
 		pag = xfs_perag_get(mp, ag);
-		if (!pag->pag_ici_init) {
-			xfs_perag_put(pag);
-			continue;
-		}
 		error = xfs_inode_ag_walk(mp, pag, execute, flags, tag,
 						exclusive, &nr);
 		xfs_perag_put(pag);
@@ -867,12 +863,7 @@ xfs_reclaim_inode_shrink(
 	down_read(&xfs_mount_list_lock);
 	list_for_each_entry(mp, &xfs_mount_list, m_mplist) {
 		for (ag = 0; ag < mp->m_sb.sb_agcount; ag++) {
-
 			pag = xfs_perag_get(mp, ag);
-			if (!pag->pag_ici_init) {
-				xfs_perag_put(pag);
-				continue;
-			}
 			reclaimable += pag->pag_ici_reclaimable;
 			xfs_perag_put(pag);
 		}
Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2010-05-28 20:57:49.000000000 +0200
+++ xfs/fs/xfs/xfs_ag.h	2010-05-28 20:58:09.542081591 +0200
@@ -227,7 +227,6 @@ typedef struct xfs_perag {
 
 	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
 
-	int		pag_ici_init;	/* incore inode cache initialised */
 	rwlock_t	pag_ici_lock;	/* incore inode lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
 	int		pag_ici_reclaimable;	/* reclaimable inodes */
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2010-05-28 20:57:58.000000000 +0200
+++ xfs/fs/xfs/xfs_iget.c	2010-05-28 20:58:09.549120633 +0200
@@ -382,9 +382,6 @@ xfs_iget(
 
 	/* get the perag structure and ensure that it's inode capable */
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
-	if (!pag->pagi_inodeok)
-		return EINVAL;
-	ASSERT(pag->pag_ici_init);
 	agino = XFS_INO_TO_AGINO(mp, ino);
 
 again:
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-05-28 20:57:58.000000000 +0200
+++ xfs/fs/xfs/xfs_inode.c	2010-05-28 20:58:26.993255425 +0200
@@ -2649,8 +2649,6 @@ xfs_iflush_cluster(
 	int			i;
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-	ASSERT(pag->pagi_inodeok);
-	ASSERT(pag->pag_ici_init);
 
 	inodes_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog;
 	ilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
