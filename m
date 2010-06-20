Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5KNulPk091982 for <xfs@oss.sgi.com>; Sun, 20 Jun 2010 18:56:47 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 679843ED454
	for <xfs@oss.sgi.com>; Sun, 20 Jun 2010 16:59:26 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	cUhGyhSvG4fWDIfx for <xfs@oss.sgi.com>;
	Sun, 20 Jun 2010 16:59:26 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: remove block number from inode lookup code
Date: Mon, 21 Jun 2010 09:59:01 +1000
Message-Id: <1277078341-19087-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1277078341-19087-1-git-send-email-david@fromorbit.com>
References: <1277078341-19087-1-git-send-email-david@fromorbit.com>
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
Cc: security@kernel.org

From: Dave Chinner <dchinner@redhat.com>

The block number comes from bulkstat based inode lookups to shortcut
the mapping calculations. We ar enot able to trust anything from
bulkstat, so drop the block number as well so that the correct
lookups and mappings are always done.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_export.c  |    2 +-
 fs/xfs/linux-2.6/xfs_ioctl32.c |    5 ++---
 fs/xfs/quota/xfs_qm.c          |    7 +++----
 fs/xfs/quota/xfs_qm_syscalls.c |   11 +++++------
 fs/xfs/xfs_ialloc.c            |   16 ----------------
 fs/xfs/xfs_iget.c              |   10 +++-------
 fs/xfs/xfs_inode.c             |    3 ---
 fs/xfs/xfs_inode.h             |    4 ++--
 fs/xfs/xfs_itable.c            |   12 ++++--------
 fs/xfs/xfs_itable.h            |    3 ---
 fs/xfs/xfs_log_recover.c       |    2 +-
 fs/xfs/xfs_mount.c             |    2 +-
 fs/xfs/xfs_rtalloc.c           |    4 ++--
 fs/xfs/xfs_trans_inode.c       |    2 +-
 fs/xfs/xfs_vnodeops.c          |    2 +-
 15 files changed, 26 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
index b39c05c..55df942 100644
--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -132,7 +132,7 @@ xfs_nfs_get_inode(
 	 * send invalid file handles and we have to handle it gracefully..
 	 */
 	error = xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED,
-			 XFS_ILOCK_SHARED, &ip, 0);
+			 XFS_ILOCK_SHARED, &ip);
 	if (error) {
 		/*
 		 * EINVAL means the inode cluster doesn't exist anymore.
diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
index 48c1aba..6cd1225 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -233,12 +233,11 @@ xfs_bulkstat_one_compat(
 	xfs_ino_t	ino,		/* inode number to get data for */
 	void		__user *buffer,	/* buffer to place output in */
 	int		ubsize,		/* size of buffer */
-	xfs_daddr_t	bno,		/* starting bno of inode cluster */
 	int		*ubused,	/* bytes used by me */
 	int		*stat)		/* BULKSTAT_RV_... */
 {
 	return xfs_bulkstat_one_int(mp, ino, buffer, ubsize,
-				    xfs_bulkstat_one_fmt_compat, bno,
+				    xfs_bulkstat_one_fmt_compat,
 				    ubused, stat);
 }
 
@@ -292,7 +291,7 @@ xfs_compat_ioc_bulkstat(
 		int res;
 
 		error = xfs_bulkstat_one_compat(mp, inlast, bulkreq.ubuffer,
-				sizeof(compat_xfs_bstat_t), 0, NULL, &res);
+				sizeof(compat_xfs_bstat_t), 0, &res);
 	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
 		error = xfs_bulkstat(mp, &inlast, &count,
 			xfs_bulkstat_one_compat, sizeof(compat_xfs_bstat_t),
diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index 25bc7da..175032f 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -1625,7 +1625,6 @@ xfs_qm_dqusage_adjust(
 	xfs_ino_t	ino,		/* inode number to get data for */
 	void		__user *buffer,	/* not used */
 	int		ubsize,		/* not used */
-	xfs_daddr_t	bno,		/* starting block of inode cluster */
 	int		*ubused,	/* not used */
 	int		*res)		/* result code value */
 {
@@ -1651,7 +1650,7 @@ xfs_qm_dqusage_adjust(
 	 * the case in all other instances. It's OK that we do this because
 	 * quotacheck is done only at mount time.
 	 */
-	if ((error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_EXCL, &ip, bno))) {
+	if ((error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_EXCL, &ip))) {
 		*res = BULKSTAT_RV_NOTHING;
 		return error;
 	}
@@ -1881,14 +1880,14 @@ xfs_qm_init_quotainos(
 		    mp->m_sb.sb_uquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_uquotino > 0);
 			if ((error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
-					     0, 0, &uip, 0)))
+					     0, 0, &uip)))
 				return XFS_ERROR(error);
 		}
 		if (XFS_IS_OQUOTA_ON(mp) &&
 		    mp->m_sb.sb_gquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_gquotino > 0);
 			if ((error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
-					     0, 0, &gip, 0))) {
+					     0, 0, &gip))) {
 				if (uip)
 					IRELE(uip);
 				return XFS_ERROR(error);
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index aa44c58..2d1abbf 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -252,7 +252,7 @@ xfs_qm_scall_trunc_qfiles(
 	}
 
 	if ((flags & XFS_DQ_USER) && mp->m_sb.sb_uquotino != NULLFSINO) {
-		error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino, 0, 0, &qip, 0);
+		error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino, 0, 0, &qip);
 		if (!error) {
 			error = xfs_truncate_file(mp, qip);
 			IRELE(qip);
@@ -261,7 +261,7 @@ xfs_qm_scall_trunc_qfiles(
 
 	if ((flags & (XFS_DQ_GROUP|XFS_DQ_PROJ)) &&
 	    mp->m_sb.sb_gquotino != NULLFSINO) {
-		error2 = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino, 0, 0, &qip, 0);
+		error2 = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino, 0, 0, &qip);
 		if (!error2) {
 			error2 = xfs_truncate_file(mp, qip);
 			IRELE(qip);
@@ -407,12 +407,12 @@ xfs_qm_scall_getqstat(
 	}
 	if (!uip && mp->m_sb.sb_uquotino != NULLFSINO) {
 		if (xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
-					0, 0, &uip, 0) == 0)
+					0, 0, &uip) == 0)
 			tempuqip = B_TRUE;
 	}
 	if (!gip && mp->m_sb.sb_gquotino != NULLFSINO) {
 		if (xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
-					0, 0, &gip, 0) == 0)
+					0, 0, &gip) == 0)
 			tempgqip = B_TRUE;
 	}
 	if (uip) {
@@ -1095,7 +1095,6 @@ xfs_qm_internalqcheck_adjust(
 	xfs_ino_t	ino,		/* inode number to get data for */
 	void		__user *buffer,	/* not used */
 	int		ubsize,		/* not used */
-	xfs_daddr_t	bno,		/* starting block of inode cluster */
 	int		*ubused,	/* not used */
 	int		*res)		/* bulkstat result code */
 {
@@ -1118,7 +1117,7 @@ xfs_qm_internalqcheck_adjust(
 	ipreleased = B_FALSE;
  again:
 	lock_flags = XFS_ILOCK_SHARED;
-	if ((error = xfs_iget(mp, NULL, ino, 0, lock_flags, &ip, bno))) {
+	if ((error = xfs_iget(mp, NULL, ino, 0, lock_flags, &ip))) {
 		*res = BULKSTAT_RV_NOTHING;
 		return (error);
 	}
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index c3de5fa..abf80ae 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1351,22 +1351,6 @@ xfs_imap(
 	}
 
 	/*
-	 * If we get a block number passed we can use it to
-	 * find the buffer easily.
-	 */
-	if (imap->im_blkno) {
-		offset = XFS_INO_TO_OFFSET(mp, ino);
-		ASSERT(offset < mp->m_sb.sb_inopblock);
-
-		cluster_agbno = xfs_daddr_to_agbno(mp, imap->im_blkno);
-		offset += (agbno - cluster_agbno) * mp->m_sb.sb_inopblock;
-
-		imap->im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
-		imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
-		return 0;
-	}
-
-	/*
 	 * If the inode chunks are aligned then use simple maths to
 	 * find the location. Otherwise we have to do a btree
 	 * lookup to find the location.
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index a80b9b9..d6ef971 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -255,7 +255,6 @@ xfs_iget_cache_miss(
 	xfs_trans_t		*tp,
 	xfs_ino_t		ino,
 	struct xfs_inode	**ipp,
-	xfs_daddr_t		bno,
 	int			flags,
 	int			lock_flags)
 {
@@ -268,7 +267,7 @@ xfs_iget_cache_miss(
 	if (!ip)
 		return ENOMEM;
 
-	error = xfs_iread(mp, tp, ip, bno, flags);
+	error = xfs_iread(mp, tp, ip, flags);
 	if (error)
 		goto out_destroy;
 
@@ -354,8 +353,6 @@ out_destroy:
  *        within the file system for the inode being requested.
  * lock_flags -- flags indicating how to lock the inode.  See the comment
  *		 for xfs_ilock() for a list of valid values.
- * bno -- the block number starting the buffer containing the inode,
- *	  if known (as by bulkstat), else 0.
  */
 int
 xfs_iget(
@@ -364,8 +361,7 @@ xfs_iget(
 	xfs_ino_t	ino,
 	uint		flags,
 	uint		lock_flags,
-	xfs_inode_t	**ipp,
-	xfs_daddr_t	bno)
+	xfs_inode_t	**ipp)
 {
 	xfs_inode_t	*ip;
 	int		error;
@@ -393,7 +389,7 @@ again:
 		read_unlock(&pag->pag_ici_lock);
 		XFS_STATS_INC(xs_ig_missed);
 
-		error = xfs_iget_cache_miss(mp, pag, tp, ino, &ip, bno,
+		error = xfs_iget_cache_miss(mp, pag, tp, ino, &ip,
 							flags, lock_flags);
 		if (error)
 			goto out_error_or_again;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9101e79..5715a9d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -783,7 +783,6 @@ xfs_iread(
 	xfs_mount_t	*mp,
 	xfs_trans_t	*tp,
 	xfs_inode_t	*ip,
-	xfs_daddr_t	bno,
 	uint		iget_flags)
 {
 	xfs_buf_t	*bp;
@@ -793,11 +792,9 @@ xfs_iread(
 	/*
 	 * Fill in the location information in the in-core inode.
 	 */
-	ip->i_imap.im_blkno = bno;
 	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, iget_flags);
 	if (error)
 		return error;
-	ASSERT(bno == 0 || bno == ip->i_imap.im_blkno);
 
 	/*
 	 * Get pointers to the on-disk inode and the buffer containing it.
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7a2f347..7a19d52 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -442,7 +442,7 @@ static inline void xfs_ifunlock(xfs_inode_t *ip)
  * xfs_iget.c prototypes.
  */
 int		xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
-			 uint, uint, xfs_inode_t **, xfs_daddr_t);
+			 uint, uint, xfs_inode_t **);
 void		xfs_iput(xfs_inode_t *, uint);
 void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
@@ -508,7 +508,7 @@ int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, struct xfs_dinode **,
 			  struct xfs_buf **, uint);
 int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
-			  struct xfs_inode *, xfs_daddr_t, uint);
+			  struct xfs_inode *, uint);
 void		xfs_dinode_to_disk(struct xfs_dinode *,
 				   struct xfs_icdinode *);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 5fccd84..200dc6f 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -56,7 +56,6 @@ xfs_bulkstat_one_int(
 	void __user		*buffer,	/* buffer to place output in */
 	int			ubsize,		/* size of buffer */
 	bulkstat_one_fmt_pf	formatter,	/* formatter, copy to user */
-	xfs_daddr_t		bno,		/* starting bno of cluster */
 	int			*ubused,	/* bytes used by me */
 	int			*stat)		/* BULKSTAT_RV_... */
 {
@@ -76,7 +75,7 @@ xfs_bulkstat_one_int(
 		return XFS_ERROR(ENOMEM);
 
 	error = xfs_iget(mp, NULL, ino,
-			 XFS_IGET_UNTRUSTED, XFS_ILOCK_SHARED, &ip, bno);
+			 XFS_IGET_UNTRUSTED, XFS_ILOCK_SHARED, &ip);
 	if (error) {
 		*stat = BULKSTAT_RV_NOTHING;
 		goto out_free;
@@ -175,13 +174,11 @@ xfs_bulkstat_one(
 	xfs_ino_t	ino,		/* inode number to get data for */
 	void		__user *buffer,	/* buffer to place output in */
 	int		ubsize,		/* size of buffer */
-	xfs_daddr_t	bno,		/* starting bno of inode cluster */
 	int		*ubused,	/* bytes used by me */
 	int		*stat)		/* BULKSTAT_RV_... */
 {
 	return xfs_bulkstat_one_int(mp, ino, buffer, ubsize,
-				    xfs_bulkstat_one_fmt, bno,
-				    ubused, stat);
+				    xfs_bulkstat_one_fmt, ubused, stat);
 }
 
 #define XFS_BULKSTAT_UBLEFT(ubleft)	((ubleft) >= statstruct_size)
@@ -481,7 +478,7 @@ xfs_bulkstat(
 				 * Get the inode and fill in a single buffer.
 				 */
 				ubused = statstruct_size;
-				error = formatter(mp, ino, ubufp, ubleft, bno,
+				error = formatter(mp, ino, ubufp, ubleft,
 						  &ubused, &fmterror);
 				if (fmterror == BULKSTAT_RV_NOTHING) {
 					if (error && error != ENOENT &&
@@ -574,8 +571,7 @@ xfs_bulkstat_single(
 	 */
 
 	ino = (xfs_ino_t)*lastinop;
-	error = xfs_bulkstat_one(mp, ino, buffer, sizeof(xfs_bstat_t),
-				 0, NULL, &res);
+	error = xfs_bulkstat_one(mp, ino, buffer, sizeof(xfs_bstat_t), 0, &res);
 	if (error) {
 		/*
 		 * Special case way failed, do it the "long" way
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index fea0339..97295d9 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -27,7 +27,6 @@ typedef int (*bulkstat_one_pf)(struct xfs_mount	*mp,
 			       xfs_ino_t	ino,
 			       void		__user *buffer,
 			       int		ubsize,
-			       xfs_daddr_t	bno,
 			       int		*ubused,
 			       int		*stat);
 
@@ -71,7 +70,6 @@ xfs_bulkstat_one_int(
 	void			__user *buffer,
 	int			ubsize,
 	bulkstat_one_fmt_pf	formatter,
-	xfs_daddr_t		bno,
 	int			*ubused,
 	int			*stat);
 
@@ -81,7 +79,6 @@ xfs_bulkstat_one(
 	xfs_ino_t		ino,
 	void			__user *buffer,
 	int			ubsize,
-	xfs_daddr_t		bno,
 	int			*ubused,
 	int			*stat);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1ac0b79..6f3f5fa 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3186,7 +3186,7 @@ xlog_recover_process_one_iunlink(
 	int				error;
 
 	ino = XFS_AGINO_TO_INO(mp, agno, agino);
-	error = xfs_iget(mp, NULL, ino, 0, 0, &ip, 0);
+	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
 	if (error)
 		goto fail;
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4e1725b..aeb9d72 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1297,7 +1297,7 @@ xfs_mountfs(
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
 	 */
-	error = xfs_iget(mp, NULL, sbp->sb_rootino, 0, XFS_ILOCK_EXCL, &rip, 0);
+	error = xfs_iget(mp, NULL, sbp->sb_rootino, 0, XFS_ILOCK_EXCL, &rip);
 	if (error) {
 		cmn_err(CE_WARN, "XFS: failed to read root inode");
 		goto out_log_dealloc;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 20b5eb7..891260f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -2270,12 +2270,12 @@ xfs_rtmount_inodes(
 	sbp = &mp->m_sb;
 	if (sbp->sb_rbmino == NULLFSINO)
 		return 0;
-	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip, 0);
+	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
 	if (error)
 		return error;
 	ASSERT(mp->m_rbmip != NULL);
 	ASSERT(sbp->sb_rsumino != NULLFSINO);
-	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip, 0);
+	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
 	if (error) {
 		IRELE(mp->m_rbmip);
 		return error;
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 10534c2..cdc53a1 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -57,7 +57,7 @@ xfs_trans_iget(
 {
 	int			error;
 
-	error = xfs_iget(mp, tp, ino, flags, lock_flags, ipp, 0);
+	error = xfs_iget(mp, tp, ino, flags, lock_flags, ipp);
 	if (!error && tp) {
 		xfs_trans_ijoin(tp, *ipp);
 		(*ipp)->i_itemp->ili_lock_flags = lock_flags;
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index df6d1b5..ad599cc 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1233,7 +1233,7 @@ xfs_lookup(
 	if (error)
 		goto out;
 
-	error = xfs_iget(dp->i_mount, NULL, inum, 0, 0, ipp, 0);
+	error = xfs_iget(dp->i_mount, NULL, inum, 0, 0, ipp);
 	if (error)
 		goto out_free_name;
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
