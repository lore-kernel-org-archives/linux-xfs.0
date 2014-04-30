Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE7C429DF9
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 09:04:27 -0500 (CDT)
Received: from eagdhcp-232-128.americas.sgi.com
	(eagdhcp-232-128.americas.sgi.com [128.162.232.128])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 94FC5304032
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 07:04:27 -0700 (PDT)
Received: from eagdhcp-232-128.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-128.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s3UE4PEj007728
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 09:04:25 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-128.americas.sgi.com)
Message-Id: <20140430135319.750775813@sgi.com>
Date: Wed, 30 Apr 2014 08:48:46 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 2/2] xfsprogs: dont free xfs_inode until complete
References: <20140430134844.924376330@sgi.com>
Content-Disposition: inline; filename=xfsprogs-fix-release-xfs_inode.patch
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

Originally, the xfs_inode are released upon the first
call to xfs_trans_cancel, xfs_trans_commit, or
inode_item_done. This code used the log item lock field
to prevent the release of the inode on the next call to
one of the above functions. This is a unusual use of the
log item lock field which is suppose to specify which lock
is to be release on transaction commit or cancel. User
space does not perform locking in transactions..

Unfortunately, this breaks any code that relies on multiple
transaction operations. For example, adding an extended
attribute to an inode that does not have an attribute fork
will fail:

 # xfs_db -x XFS_DEVICE
 xfs_db> inode INO_NUM
 xfs_db> attr_set newattribute

This patch does the following:
 1) Removes the iput from the transaction completion and
    requires that the xfs_inode allocators call IRELE()
    when they are done with the pointer. The real time
    inodes are pointed to by the xfs_mount and have a longer
    lifetime.
 2) Removes libxfs_trans_iput() because transaction entries
    are removed in transaction commit and cancel.
 3) Removes libxfs_trans_ihold() which is an obsolete interface.
 4) Removes the now unneeded ili_flags from the xfs_inode_log_item
    structure.
 
Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 include/libxfs.h |    3 --
 libxfs/trans.c   |   59 +++++--------------------------------------------------
 libxfs/util.c    |    1 
 libxfs/xfs.h     |    1 
 mkfs/proto.c     |   16 +-------------
 repair/phase6.c  |   13 +++---------
 repair/phase7.c  |    2 -
 7 files changed, 13 insertions(+), 82 deletions(-)

Index: b/include/libxfs.h
===================================================================
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -477,7 +477,6 @@ typedef struct xfs_inode_log_item {
 	unsigned int		ili_fields;		/* fields to be logged */
 	unsigned int		ili_last_fields;	/* fields when flushed*/
 	xfs_inode_log_format_t	ili_format;		/* logged structure */
-	int			ili_lock_flags;
 } xfs_inode_log_item_t;
 
 typedef struct xfs_buf_log_item {
@@ -532,9 +531,7 @@ extern xfs_buf_t	*libxfs_trans_getsb (xf
 
 extern int	libxfs_trans_iget (xfs_mount_t *, xfs_trans_t *, xfs_ino_t,
 				uint, uint, struct xfs_inode **);
-extern void	libxfs_trans_iput(xfs_trans_t *, struct xfs_inode *);
 extern void	libxfs_trans_ijoin (xfs_trans_t *, struct xfs_inode *, uint);
-extern void	libxfs_trans_ihold (xfs_trans_t *, struct xfs_inode *);
 extern void	libxfs_trans_ijoin_ref(xfs_trans_t *, struct xfs_inode *, int);
 extern void	libxfs_trans_log_inode (xfs_trans_t *, struct xfs_inode *,
 				uint);
Index: b/libxfs/trans.c
===================================================================
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -110,7 +110,7 @@ libxfs_trans_roll(
 	/*
 	 * Commit the current transaction.
 	 * If this commit failed, then it'd just unlock those items that
-	 * are not marked ihold. That also means that a filesystem shutdown
+	 * are marked to be released. That also means that a filesystem shutdown
 	 * is in progress. The caller takes the responsibility to cancel
 	 * the duplicate transaction that gets returned.
 	 */
@@ -248,26 +248,6 @@ libxfs_trans_iget(
 }
 
 void
-libxfs_trans_iput(
-	xfs_trans_t		*tp,
-	xfs_inode_t		*ip)
-{
-	xfs_inode_log_item_t	*iip;
-
-	if (tp == NULL) {
-		IRELE(ip);
-		return;
-	}
-
-	ASSERT(ip->i_transp == tp);
-	iip = ip->i_itemp;
-	ASSERT(iip != NULL);
-	xfs_trans_del_item(&iip->ili_item);
-
-	IRELE(ip);
-}
-
-void
 libxfs_trans_ijoin(
 	xfs_trans_t		*tp,
 	xfs_inode_t		*ip,
@@ -300,7 +280,6 @@ libxfs_trans_ijoin_ref(
 	ASSERT(ip->i_itemp != NULL);
 
 	xfs_trans_ijoin(tp, ip, lock_flags);
-	ip->i_itemp->ili_lock_flags = lock_flags;
 
 #ifdef XACT_DEBUG
 	fprintf(stderr, "ijoin_ref'd inode %llu, transaction %p\n", ip->i_ino, tp);
@@ -308,21 +287,6 @@ libxfs_trans_ijoin_ref(
 }
 
 void
-libxfs_trans_ihold(
-	xfs_trans_t		*tp,
-	xfs_inode_t		*ip)
-{
-	ASSERT(ip->i_transp == tp);
-	ASSERT(ip->i_itemp != NULL);
-
-	ip->i_itemp->ili_lock_flags = 1;
-
-#ifdef XACT_DEBUG
-	fprintf(stderr, "ihold'd inode %llu, transaction %p\n", ip->i_ino, tp);
-#endif
-}
-
-void
 libxfs_trans_inode_alloc_buf(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
@@ -701,7 +665,7 @@ inode_item_done(
 	if (!(iip->ili_fields & XFS_ILOG_ALL)) {
 		ip->i_transp = NULL;	/* disassociate from transaction */
 		iip->ili_flags = 0;	/* reset all flags */
-		goto ili_done;
+		return;
 	}
 
 	/*
@@ -711,7 +675,7 @@ inode_item_done(
 	if (error) {
 		fprintf(stderr, _("%s: warning - imap_to_bp failed (%d)\n"),
 			progname, error);
-		goto ili_done;
+		return;
 	}
 
 	XFS_BUF_SET_FSPRIVATE(bp, iip);
@@ -719,7 +683,7 @@ inode_item_done(
 	if (error) {
 		fprintf(stderr, _("%s: warning - iflush_int failed (%d)\n"),
 			progname, error);
-		goto ili_done;
+		return;
 	}
 
 	ip->i_transp = NULL;	/* disassociate from transaction */
@@ -727,16 +691,9 @@ inode_item_done(
 	XFS_BUF_SET_FSPRIVATE2(bp, NULL);	/* remove xact ptr */
 	libxfs_writebuf(bp, 0);
 #ifdef XACT_DEBUG
-	fprintf(stderr, "flushing dirty inode %llu, buffer %p (hold=%u)\n",
-			ip->i_ino, bp, iip->ili_lock_flags);
+	fprintf(stderr, "flushing dirty inode %llu, buffer %p\n",
+			ip->i_ino, bp);
 #endif
-ili_done:
-	if (iip->ili_lock_flags) {
-		iip->ili_lock_flags = 0;
-		return;
-	}
-	/* free the inode */
-	IRELE(ip);
 }
 
 static void
@@ -817,10 +774,6 @@ inode_item_unlock(
 	ip->i_transp = NULL;
 
 	iip->ili_flags = 0;
-	if (!iip->ili_lock_flags)
-		IRELE(ip);
-	else
-		iip->ili_lock_flags = 0;
 }
 
 /*
Index: b/libxfs/util.c
===================================================================
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -595,7 +595,6 @@ libxfs_alloc_file_space(
 			break;
 		}
 		xfs_trans_ijoin(tp, ip, 0);
-		xfs_trans_ihold(tp, ip);
 
 		xfs_bmap_init(&free_list, &firstfsb);
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb, allocatesize_fsb,
Index: b/libxfs/xfs.h
===================================================================
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -292,7 +292,6 @@ roundup_64(__uint64_t x, __uint32_t y)
 #define xfs_trans_get_buf		libxfs_trans_get_buf
 #define xfs_trans_getsb			libxfs_trans_getsb
 #define xfs_trans_iget			libxfs_trans_iget
-#define xfs_trans_ihold			libxfs_trans_ihold
 #define xfs_trans_ijoin			libxfs_trans_ijoin
 #define xfs_trans_ijoin_ref		libxfs_trans_ijoin_ref
 #define xfs_trans_init			libxfs_trans_init
Index: b/mkfs/proto.c
===================================================================
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -196,7 +196,6 @@ rsvfile(
 	tp = libxfs_trans_alloc(mp, 0);
 
 	libxfs_trans_ijoin(tp, ip, 0);
-	libxfs_trans_ihold(tp, ip);
 
 	ip->i_d.di_mode &= ~S_ISUID;
 
@@ -463,7 +462,6 @@ parseproto(
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_REG_FILE;
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
-		libxfs_trans_ihold(tp, pip);
 		break;
 
 	case IF_RESERVED:			/* pre-allocated space only */
@@ -480,7 +478,6 @@ parseproto(
 
 		xname.type = XFS_DIR3_FT_REG_FILE;
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
-		libxfs_trans_ihold(tp, pip);
 		libxfs_trans_log_inode(tp, ip, flags);
 
 		error = libxfs_bmap_finish(&tp, &flist, &committed);
@@ -488,6 +485,7 @@ parseproto(
 			fail(_("Pre-allocated file creation failed"), error);
 		libxfs_trans_commit(tp, 0);
 		rsvfile(mp, ip, llen);
+		IRELE(ip);
 		return;
 
 	case IF_BLOCK:
@@ -502,7 +500,6 @@ parseproto(
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_BLKDEV;
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
-		libxfs_trans_ihold(tp, pip);
 		flags |= XFS_ILOG_DEV;
 		break;
 
@@ -517,7 +514,6 @@ parseproto(
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_CHRDEV;
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
-		libxfs_trans_ihold(tp, pip);
 		flags |= XFS_ILOG_DEV;
 		break;
 
@@ -530,7 +526,6 @@ parseproto(
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_FIFO;
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
-		libxfs_trans_ihold(tp, pip);
 		break;
 	case IF_SYMLINK:
 		buf = getstr(pp);
@@ -544,7 +539,6 @@ parseproto(
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_SYMLINK;
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
-		libxfs_trans_ihold(tp, pip);
 		break;
 	case IF_DIRECTORY:
 		getres(tp, 0);
@@ -564,7 +558,6 @@ parseproto(
 			newdirent(mp, tp, pip, &xname, ip->i_ino,
 				  &first, &flist);
 			pip->i_d.di_nlink++;
-			libxfs_trans_ihold(tp, pip);
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 		}
 		newdirectory(mp, tp, ip, pip);
@@ -572,7 +565,6 @@ parseproto(
 		error = libxfs_bmap_finish(&tp, &flist, &committed);
 		if (error)
 			fail(_("Directory creation failed"), error);
-		libxfs_trans_ihold(tp, ip);
 		libxfs_trans_commit(tp, 0);
 		/*
 		 * RT initialization.  Do this here to ensure that
@@ -602,6 +594,7 @@ parseproto(
 			error);
 	}
 	libxfs_trans_commit(tp, 0);
+	IRELE(ip);
 }
 
 void
@@ -664,7 +657,6 @@ rtinit(
 	*(__uint64_t *)&rbmip->i_d.di_atime = 0;
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
 	libxfs_mod_sb(tp, XFS_SB_RBMINO);
-	libxfs_trans_ihold(tp, rbmip);
 	mp->m_rbmip = rbmip;
 	error = libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
 					&creds, &fsxattrs, &rsumip);
@@ -675,7 +667,6 @@ rtinit(
 	rsumip->i_d.di_size = mp->m_rsumsize;
 	libxfs_trans_log_inode(tp, rsumip, XFS_ILOG_CORE);
 	libxfs_mod_sb(tp, XFS_SB_RSUMINO);
-	libxfs_trans_ihold(tp, rsumip);
 	libxfs_trans_commit(tp, 0);
 	mp->m_rsumip = rsumip;
 	/*
@@ -688,7 +679,6 @@ rtinit(
 		res_failed(i);
 
 	libxfs_trans_ijoin(tp, rbmip, 0);
-	libxfs_trans_ihold(tp, rbmip);
 	bno = 0;
 	xfs_bmap_init(&flist, &first);
 	while (bno < mp->m_sb.sb_rbmblocks) {
@@ -725,7 +715,6 @@ rtinit(
 	if (i)
 		res_failed(i);
 	libxfs_trans_ijoin(tp, rsumip, 0);
-	libxfs_trans_ihold(tp, rsumip);
 	bno = 0;
 	xfs_bmap_init(&flist, &first);
 	while (bno < nsumblocks) {
@@ -761,7 +750,6 @@ rtinit(
 		if (i)
 			res_failed(i);
 		libxfs_trans_ijoin(tp, rbmip, 0);
-		libxfs_trans_ihold(tp, rbmip);
 		xfs_bmap_init(&flist, &first);
 		ebno = XFS_RTMIN(mp->m_sb.sb_rextents,
 			bno + NBBY * mp->m_sb.sb_blocksize);
Index: b/repair/phase6.c
===================================================================
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -505,7 +505,6 @@ mk_rbmino(xfs_mount_t *mp)
 	 * commit changes
 	 */
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	libxfs_trans_ihold(tp, ip);
 	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
 
 	/*
@@ -762,7 +761,6 @@ mk_rsumino(xfs_mount_t *mp)
 	 * commit changes
 	 */
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	libxfs_trans_ihold(tp, ip);
 	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
 
 	/*
@@ -1024,6 +1022,8 @@ mk_orphanage(xfs_mount_t *mp)
 
 
 	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
+	IRELE(ip);
+	IRELE(pip);
 	add_inode_reached(irec,ino_offset);
 
 	return(ino);
@@ -1221,6 +1221,8 @@ mv_orphanage(
 
 		libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
 	}
+	IRELE(ino_p);
+	IRELE(orphanage_ip);
 }
 
 static int
@@ -1291,7 +1293,6 @@ longform_dir2_rebuild(
 	if (error)
 		res_failed(error);
 	libxfs_trans_ijoin(tp, ip, 0);
-	libxfs_trans_ihold(tp, ip);
 
 	if ((error = libxfs_bmap_last_offset(tp, ip, &lastblock,
 						XFS_DATA_FORK)))
@@ -1331,7 +1332,6 @@ longform_dir2_rebuild(
 			res_failed(error);
 
 		libxfs_trans_ijoin(tp, ip, 0);
-		libxfs_trans_ihold(tp, ip);
 
 		xfs_bmap_init(&flist, &firstblock);
 		error = libxfs_dir_createname(tp, ip, &p->name, p->inum,
@@ -1389,7 +1389,6 @@ dir2_kill_block(
 	if (error)
 		res_failed(error);
 	libxfs_trans_ijoin(tp, ip, 0);
-	libxfs_trans_ihold(tp, ip);
 	libxfs_trans_bjoin(tp, bp);
 	memset(&args, 0, sizeof(args));
 	xfs_bmap_init(&flist, &firstblock);
@@ -1577,7 +1576,6 @@ longform_dir2_entry_check_data(
 	if (error)
 		res_failed(error);
 	libxfs_trans_ijoin(tp, ip, 0);
-	libxfs_trans_ihold(tp, ip);
 	libxfs_trans_bjoin(tp, bp);
 	libxfs_trans_bhold(tp, bp);
 	xfs_bmap_init(&flist, &firstblock);
@@ -2744,7 +2742,6 @@ process_dir_inode(
 				res_failed(error);
 
 			libxfs_trans_ijoin(tp, ip, 0);
-			libxfs_trans_ihold(tp, ip);
 
 			shortform_dir2_entry_check(mp, ino, ip, &dirty,
 						irec, ino_offset,
@@ -2792,7 +2789,6 @@ process_dir_inode(
 			res_failed(error);
 
 		libxfs_trans_ijoin(tp, ip, 0);
-		libxfs_trans_ihold(tp, ip);
 
 		xfs_bmap_init(&flist, &first);
 
@@ -2854,7 +2850,6 @@ process_dir_inode(
 				res_failed(error);
 
 			libxfs_trans_ijoin(tp, ip, 0);
-			libxfs_trans_ihold(tp, ip);
 
 			xfs_bmap_init(&flist, &first);
 
Index: b/repair/phase7.c
===================================================================
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -99,7 +99,6 @@ update_inode_nlinks(
 	set_nlinks(&ip->i_d, ino, nlinks, &dirty);
 
 	if (!dirty)  {
-		libxfs_trans_iput(tp, ip);
 		libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
 	} else  {
 		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
@@ -113,6 +112,7 @@ update_inode_nlinks(
 
 		ASSERT(error == 0);
 	}
+	IRELE(ip);
 }
 
 void


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
