Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5FBIEvG084738 for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 06:18:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D2C01BDB75A
	for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 04:20:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8XrmK0NfDbgZMi5B for
	<xfs@oss.sgi.com>; Tue, 15 Jun 2010 04:20:51 -0700 (PDT)
Date: Tue, 15 Jun 2010 07:20:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: avoid synchronous transaction in xfs_fs_write_inode
Message-ID: <20100615112051.GA25064@infradead.org>
References: <20100608195905.GA577@infradead.org>
	<20100609072911.GI7869@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100609072911.GI7869@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jun 09, 2010 at 05:29:11PM +1000, Dave Chinner wrote:
> All great - I attempted this myself - but it breaks bulkstat. See
> xfstest 183:

I can't reproduce the failure.  And then I don't think we should
prioritize bulkstate over metadata performance.  The only major users
of bulkstat on XFS in the mainline kernel is xfsdump, and metadata
performance during normal loads is a lot more important.  And the
difference when using LVM/MD will be even larger with this as barriers
are a lot more expensive there.

What do you think about adding something like the patch below which
always makes bulkstat always use the iget version which doesn't show
this sort of problems.

---

From: Christoph Hellwig <hch@lst.de>
Subject: xfs: always use iget in bulkstat

The non-coherent bulkstat versionsthat look directly at the inode
buffers causes various problems with performance optimizations that
make increased use of just logging inodes.  This patch makes bulkstat
always use iget, which should be fast enough for normal use with the
radix-tree based inode cache introduced a while ago.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---

 linux-2.6/xfs_ioctl.c   |    7 -
 linux-2.6/xfs_ioctl32.c |   12 --
 quota/xfs_qm.c          |   11 -
 quota/xfs_qm_syscalls.c |   16 +-
 xfs_itable.c            |  281 ++++++------------------------------------------
 xfs_itable.h            |   14 --
 6 files changed, 59 insertions(+), 282 deletions(-)

Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2010-06-09 14:41:00.798002937 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2010-06-09 15:29:03.480005242 +0200
@@ -670,10 +670,9 @@ xfs_ioc_bulkstat(
 		error = xfs_bulkstat_single(mp, &inlast,
 						bulkreq.ubuffer, &done);
 	else	/* XFS_IOC_FSBULKSTAT */
-		error = xfs_bulkstat(mp, &inlast, &count,
-			(bulkstat_one_pf)xfs_bulkstat_one, NULL,
-			sizeof(xfs_bstat_t), bulkreq.ubuffer,
-			BULKSTAT_FG_QUICK, &done);
+		error = xfs_bulkstat(mp, &inlast, &count, xfs_bulkstat_one,
+				     sizeof(xfs_bstat_t), bulkreq.ubuffer,
+				     &done);
 
 	if (error)
 		return -error;
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2010-06-09 14:41:00.806011109 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2010-06-09 15:29:03.480005242 +0200
@@ -233,15 +233,13 @@ xfs_bulkstat_one_compat(
 	xfs_ino_t	ino,		/* inode number to get data for */
 	void		__user *buffer,	/* buffer to place output in */
 	int		ubsize,		/* size of buffer */
-	void		*private_data,	/* my private data */
 	xfs_daddr_t	bno,		/* starting bno of inode cluster */
 	int		*ubused,	/* bytes used by me */
-	void		*dibuff,	/* on-disk inode buffer */
 	int		*stat)		/* BULKSTAT_RV_... */
 {
 	return xfs_bulkstat_one_int(mp, ino, buffer, ubsize,
 				    xfs_bulkstat_one_fmt_compat, bno,
-				    ubused, dibuff, stat);
+				    ubused, stat);
 }
 
 /* copied from xfs_ioctl.c */
@@ -294,13 +292,11 @@ xfs_compat_ioc_bulkstat(
 		int res;
 
 		error = xfs_bulkstat_one_compat(mp, inlast, bulkreq.ubuffer,
-				sizeof(compat_xfs_bstat_t),
-				NULL, 0, NULL, NULL, &res);
+				sizeof(compat_xfs_bstat_t), 0, NULL, &res);
 	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
 		error = xfs_bulkstat(mp, &inlast, &count,
-			xfs_bulkstat_one_compat, NULL,
-			sizeof(compat_xfs_bstat_t), bulkreq.ubuffer,
-			BULKSTAT_FG_QUICK, &done);
+			xfs_bulkstat_one_compat, sizeof(compat_xfs_bstat_t),
+			bulkreq.ubuffer, &done);
 	} else
 		error = XFS_ERROR(EINVAL);
 	if (error)
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2010-06-09 14:41:00.816003775 +0200
+++ xfs/fs/xfs/quota/xfs_qm.c	2010-06-09 15:29:03.487003915 +0200
@@ -1625,10 +1625,8 @@ xfs_qm_dqusage_adjust(
 	xfs_ino_t	ino,		/* inode number to get data for */
 	void		__user *buffer,	/* not used */
 	int		ubsize,		/* not used */
-	void		*private_data,	/* not used */
 	xfs_daddr_t	bno,		/* starting block of inode cluster */
 	int		*ubused,	/* not used */
-	void		*dip,		/* on-disk inode pointer (not used) */
 	int		*res)		/* result code value */
 {
 	xfs_inode_t	*ip;
@@ -1789,12 +1787,13 @@ xfs_qm_quotacheck(
 		 * Iterate thru all the inodes in the file system,
 		 * adjusting the corresponding dquot counters in core.
 		 */
-		if ((error = xfs_bulkstat(mp, &lastino, &count,
-				     xfs_qm_dqusage_adjust, NULL,
-				     structsz, NULL, BULKSTAT_FG_IGET, &done)))
+		error = xfs_bulkstat(mp, &lastino, &count,
+				     xfs_qm_dqusage_adjust,
+				     structsz, NULL, &done);
+		if (error)
 			break;
 
-	} while (! done);
+	} while (!done);
 
 	/*
 	 * We've made all the changes that we need to make incore.
Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2010-06-09 14:41:00.829004055 +0200
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2010-06-09 15:29:03.491003845 +0200
@@ -1095,10 +1095,8 @@ xfs_qm_internalqcheck_adjust(
 	xfs_ino_t	ino,		/* inode number to get data for */
 	void		__user *buffer,	/* not used */
 	int		ubsize,		/* not used */
-	void		*private_data,	/* not used */
 	xfs_daddr_t	bno,		/* starting block of inode cluster */
 	int		*ubused,	/* not used */
-	void		*dip,		/* not used */
 	int		*res)		/* bulkstat result code */
 {
 	xfs_inode_t		*ip;
@@ -1191,15 +1189,15 @@ xfs_qm_internalqcheck(
 		 * Iterate thru all the inodes in the file system,
 		 * adjusting the corresponding dquot counters
 		 */
-		if ((error = xfs_bulkstat(mp, &lastino, &count,
-				 xfs_qm_internalqcheck_adjust, NULL,
-				 0, NULL, BULKSTAT_FG_IGET, &done))) {
+		error = xfs_bulkstat(mp, &lastino, &count,
+				 xfs_qm_internalqcheck_adjust,
+				 0, NULL, &done);
+		if (error) {
+			cmn_err(CE_DEBUG, "Bulkstat returned error 0x%x", error);
 			break;
 		}
-	} while (! done);
-	if (error) {
-		cmn_err(CE_DEBUG, "Bulkstat returned error 0x%x", error);
-	}
+	} while (!done);
+
 	cmn_err(CE_DEBUG, "Checking results against system dquots");
 	for (i = 0; i < qmtest_hashmask; i++) {
 		xfs_dqtest_t	*d, *n;
Index: xfs/fs/xfs/xfs_itable.c
===================================================================
--- xfs.orig/fs/xfs/xfs_itable.c	2010-06-09 14:41:00.784003985 +0200
+++ xfs/fs/xfs/xfs_itable.c	2010-06-09 15:29:03.494004753 +0200
@@ -45,24 +45,41 @@ xfs_internal_inum(
 		 (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino)));
 }
 
-STATIC int
-xfs_bulkstat_one_iget(
-	xfs_mount_t	*mp,		/* mount point for filesystem */
-	xfs_ino_t	ino,		/* inode number to get data for */
-	xfs_daddr_t	bno,		/* starting bno of inode cluster */
-	xfs_bstat_t	*buf,		/* return buffer */
-	int		*stat)		/* BULKSTAT_RV_... */
+/*
+ * Return stat information for one inode.
+ * Return 0 if ok, else errno.
+ */
+int
+xfs_bulkstat_one_int(
+	struct xfs_mount	*mp,		/* mount point for filesystem */
+	xfs_ino_t		ino,		/* inode to get data for */
+	void __user		*buffer,	/* buffer to place output in */
+	int			ubsize,		/* size of buffer */
+	bulkstat_one_fmt_pf	formatter,	/* formatter, copy to user */
+	xfs_daddr_t		bno,		/* starting bno of cluster */
+	int			*ubused,	/* bytes used by me */
+	int			*stat)		/* BULKSTAT_RV_... */
 {
-	xfs_icdinode_t	*dic;	/* dinode core info pointer */
-	xfs_inode_t	*ip;		/* incore inode pointer */
-	struct inode	*inode;
-	int		error;
+	struct xfs_icdinode	*dic;		/* dinode core info pointer */
+	struct xfs_inode	*ip;		/* incore inode pointer */
+	struct inode		*inode;
+	struct xfs_bstat	*buf;		/* return buffer */
+	int			error = 0;	/* error value */
+
+	*stat = BULKSTAT_RV_NOTHING;
+
+	if (!buffer || xfs_internal_inum(mp, ino))
+		return XFS_ERROR(EINVAL);
+
+	buf = kmem_alloc(sizeof(*buf), KM_SLEEP | KM_MAYFAIL);
+	if (!buf)
+		return XFS_ERROR(ENOMEM);
 
 	error = xfs_iget(mp, NULL, ino,
 			 XFS_IGET_BULKSTAT, XFS_ILOCK_SHARED, &ip, bno);
 	if (error) {
 		*stat = BULKSTAT_RV_NOTHING;
-		return error;
+		goto out_free;
 	}
 
 	ASSERT(ip != NULL);
@@ -123,77 +140,16 @@ xfs_bulkstat_one_iget(
 		buf->bs_blocks = dic->di_nblocks + ip->i_delayed_blks;
 		break;
 	}
-
 	xfs_iput(ip, XFS_ILOCK_SHARED);
-	return error;
-}
 
-STATIC void
-xfs_bulkstat_one_dinode(
-	xfs_mount_t	*mp,		/* mount point for filesystem */
-	xfs_ino_t	ino,		/* inode number to get data for */
-	xfs_dinode_t	*dic,		/* dinode inode pointer */
-	xfs_bstat_t	*buf)		/* return buffer */
-{
-	/*
-	 * The inode format changed when we moved the link count and
-	 * made it 32 bits long.  If this is an old format inode,
-	 * convert it in memory to look like a new one.  If it gets
-	 * flushed to disk we will convert back before flushing or
-	 * logging it.  We zero out the new projid field and the old link
-	 * count field.  We'll handle clearing the pad field (the remains
-	 * of the old uuid field) when we actually convert the inode to
-	 * the new format. We don't change the version number so that we
-	 * can distinguish this from a real new format inode.
-	 */
-	if (dic->di_version == 1) {
-		buf->bs_nlink = be16_to_cpu(dic->di_onlink);
-		buf->bs_projid = 0;
-	} else {
-		buf->bs_nlink = be32_to_cpu(dic->di_nlink);
-		buf->bs_projid = be16_to_cpu(dic->di_projid);
-	}
+	error = formatter(buffer, ubsize, ubused, buf);
 
-	buf->bs_ino = ino;
-	buf->bs_mode = be16_to_cpu(dic->di_mode);
-	buf->bs_uid = be32_to_cpu(dic->di_uid);
-	buf->bs_gid = be32_to_cpu(dic->di_gid);
-	buf->bs_size = be64_to_cpu(dic->di_size);
-	buf->bs_atime.tv_sec = be32_to_cpu(dic->di_atime.t_sec);
-	buf->bs_atime.tv_nsec = be32_to_cpu(dic->di_atime.t_nsec);
-	buf->bs_mtime.tv_sec = be32_to_cpu(dic->di_mtime.t_sec);
-	buf->bs_mtime.tv_nsec = be32_to_cpu(dic->di_mtime.t_nsec);
-	buf->bs_ctime.tv_sec = be32_to_cpu(dic->di_ctime.t_sec);
-	buf->bs_ctime.tv_nsec = be32_to_cpu(dic->di_ctime.t_nsec);
-	buf->bs_xflags = xfs_dic2xflags(dic);
-	buf->bs_extsize = be32_to_cpu(dic->di_extsize) << mp->m_sb.sb_blocklog;
-	buf->bs_extents = be32_to_cpu(dic->di_nextents);
-	buf->bs_gen = be32_to_cpu(dic->di_gen);
-	memset(buf->bs_pad, 0, sizeof(buf->bs_pad));
-	buf->bs_dmevmask = be32_to_cpu(dic->di_dmevmask);
-	buf->bs_dmstate = be16_to_cpu(dic->di_dmstate);
-	buf->bs_aextents = be16_to_cpu(dic->di_anextents);
-	buf->bs_forkoff = XFS_DFORK_BOFF(dic);
+	if (!error)
+		*stat = BULKSTAT_RV_DIDONE;
 
-	switch (dic->di_format) {
-	case XFS_DINODE_FMT_DEV:
-		buf->bs_rdev = xfs_dinode_get_rdev(dic);
-		buf->bs_blksize = BLKDEV_IOSIZE;
-		buf->bs_blocks = 0;
-		break;
-	case XFS_DINODE_FMT_LOCAL:
-	case XFS_DINODE_FMT_UUID:
-		buf->bs_rdev = 0;
-		buf->bs_blksize = mp->m_sb.sb_blocksize;
-		buf->bs_blocks = 0;
-		break;
-	case XFS_DINODE_FMT_EXTENTS:
-	case XFS_DINODE_FMT_BTREE:
-		buf->bs_rdev = 0;
-		buf->bs_blksize = mp->m_sb.sb_blocksize;
-		buf->bs_blocks = be64_to_cpu(dic->di_nblocks);
-		break;
-	}
+ out_free:
+	kmem_free(buf);
+	return error;
 }
 
 /* Return 0 on success or positive error */
@@ -213,118 +169,19 @@ xfs_bulkstat_one_fmt(
 	return 0;
 }
 
-/*
- * Return stat information for one inode.
- * Return 0 if ok, else errno.
- */
-int		   	    		/* error status */
-xfs_bulkstat_one_int(
-	xfs_mount_t	*mp,		/* mount point for filesystem */
-	xfs_ino_t	ino,		/* inode number to get data for */
-	void		__user *buffer,	/* buffer to place output in */
-	int		ubsize,		/* size of buffer */
-	bulkstat_one_fmt_pf formatter,	/* formatter, copy to user */
-	xfs_daddr_t	bno,		/* starting bno of inode cluster */
-	int		*ubused,	/* bytes used by me */
-	void		*dibuff,	/* on-disk inode buffer */
-	int		*stat)		/* BULKSTAT_RV_... */
-{
-	xfs_bstat_t	*buf;		/* return buffer */
-	int		error = 0;	/* error value */
-	xfs_dinode_t	*dip;		/* dinode inode pointer */
-
-	dip = (xfs_dinode_t *)dibuff;
-	*stat = BULKSTAT_RV_NOTHING;
-
-	if (!buffer || xfs_internal_inum(mp, ino))
-		return XFS_ERROR(EINVAL);
-
-	buf = kmem_alloc(sizeof(*buf), KM_SLEEP);
-
-	if (dip == NULL) {
-		/* We're not being passed a pointer to a dinode.  This happens
-		 * if BULKSTAT_FG_IGET is selected.  Do the iget.
-		 */
-		error = xfs_bulkstat_one_iget(mp, ino, bno, buf, stat);
-		if (error)
-			goto out_free;
-	} else {
-		xfs_bulkstat_one_dinode(mp, ino, dip, buf);
-	}
-
-	error = formatter(buffer, ubsize, ubused, buf);
-	if (error)
-		goto out_free;
-
-	*stat = BULKSTAT_RV_DIDONE;
-
- out_free:
-	kmem_free(buf);
-	return error;
-}
-
 int
 xfs_bulkstat_one(
 	xfs_mount_t	*mp,		/* mount point for filesystem */
 	xfs_ino_t	ino,		/* inode number to get data for */
 	void		__user *buffer,	/* buffer to place output in */
 	int		ubsize,		/* size of buffer */
-	void		*private_data,	/* my private data */
 	xfs_daddr_t	bno,		/* starting bno of inode cluster */
 	int		*ubused,	/* bytes used by me */
-	void		*dibuff,	/* on-disk inode buffer */
 	int		*stat)		/* BULKSTAT_RV_... */
 {
 	return xfs_bulkstat_one_int(mp, ino, buffer, ubsize,
 				    xfs_bulkstat_one_fmt, bno,
-				    ubused, dibuff, stat);
-}
-
-/*
- * Test to see whether we can use the ondisk inode directly, based
- * on the given bulkstat flags, filling in dipp accordingly.
- * Returns zero if the inode is dodgey.
- */
-STATIC int
-xfs_bulkstat_use_dinode(
-	xfs_mount_t	*mp,
-	int		flags,
-	xfs_buf_t	*bp,
-	int		clustidx,
-	xfs_dinode_t	**dipp)
-{
-	xfs_dinode_t	*dip;
-	unsigned int	aformat;
-
-	*dipp = NULL;
-	if (!bp || (flags & BULKSTAT_FG_IGET))
-		return 1;
-	dip = (xfs_dinode_t *)
-			xfs_buf_offset(bp, clustidx << mp->m_sb.sb_inodelog);
-	/*
-	 * Check the buffer containing the on-disk inode for di_mode == 0.
-	 * This is to prevent xfs_bulkstat from picking up just reclaimed
-	 * inodes that have their in-core state initialized but not flushed
-	 * to disk yet. This is a temporary hack that would require a proper
-	 * fix in the future.
-	 */
-	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC ||
-	    !XFS_DINODE_GOOD_VERSION(dip->di_version) ||
-	    !dip->di_mode)
-		return 0;
-	if (flags & BULKSTAT_FG_QUICK) {
-		*dipp = dip;
-		return 1;
-	}
-	/* BULKSTAT_FG_INLINE: if attr fork is local, or not there, use it */
-	aformat = dip->di_aformat;
-	if ((XFS_DFORK_Q(dip) == 0) ||
-	    (aformat == XFS_DINODE_FMT_LOCAL) ||
-	    (aformat == XFS_DINODE_FMT_EXTENTS && !dip->di_anextents)) {
-		*dipp = dip;
-		return 1;
-	}
-	return 1;
+				    ubused, stat);
 }
 
 #define XFS_BULKSTAT_UBLEFT(ubleft)	((ubleft) >= statstruct_size)
@@ -338,10 +195,8 @@ xfs_bulkstat(
 	xfs_ino_t		*lastinop, /* last inode returned */
 	int			*ubcountp, /* size of buffer/count returned */
 	bulkstat_one_pf		formatter, /* func that'd fill a single buf */
-	void			*private_data,/* private data for formatter */
 	size_t			statstruct_size, /* sizeof struct filling */
 	char			__user *ubuffer, /* buffer with inode stats */
-	int			flags,	/* defined in xfs_itable.h */
 	int			*done)	/* 1 if there are more stats to get */
 {
 	xfs_agblock_t		agbno=0;/* allocation group block number */
@@ -376,14 +231,12 @@ xfs_bulkstat(
 	int			ubelem;	/* spaces used in user's buffer */
 	int			ubused;	/* bytes used by formatter */
 	xfs_buf_t		*bp;	/* ptr to on-disk inode cluster buf */
-	xfs_dinode_t		*dip;	/* ptr into bp for specific inode */
 
 	/*
 	 * Get the last inode value, see if there's nothing to do.
 	 */
 	ino = (xfs_ino_t)*lastinop;
 	lastino = ino;
-	dip = NULL;
 	agno = XFS_INO_TO_AGNO(mp, ino);
 	agino = XFS_INO_TO_AGINO(mp, ino);
 	if (agno >= mp->m_sb.sb_agcount ||
@@ -608,37 +461,6 @@ xfs_bulkstat(
 							irbp->ir_startino) +
 						((chunkidx & nimask) >>
 						 mp->m_sb.sb_inopblog);
-
-					if (flags & (BULKSTAT_FG_QUICK |
-						     BULKSTAT_FG_INLINE)) {
-						int offset;
-
-						ino = XFS_AGINO_TO_INO(mp, agno,
-								       agino);
-						bno = XFS_AGB_TO_DADDR(mp, agno,
-								       agbno);
-
-						/*
-						 * Get the inode cluster buffer
-						 */
-						if (bp)
-							xfs_buf_relse(bp);
-
-						error = xfs_inotobp(mp, NULL, ino, &dip,
-								    &bp, &offset,
-								    XFS_IGET_BULKSTAT);
-
-						if (!error)
-							clustidx = offset / mp->m_sb.sb_inodesize;
-						if (XFS_TEST_ERROR(error != 0,
-								   mp, XFS_ERRTAG_BULKSTAT_READ_CHUNK,
-								   XFS_RANDOM_BULKSTAT_READ_CHUNK)) {
-							bp = NULL;
-							ubleft = 0;
-							rval = error;
-							break;
-						}
-					}
 				}
 				ino = XFS_AGINO_TO_INO(mp, agno, agino);
 				bno = XFS_AGB_TO_DADDR(mp, agno, agbno);
@@ -654,35 +476,13 @@ xfs_bulkstat(
 				 * when the chunk is used up.
 				 */
 				irbp->ir_freecount++;
-				if (!xfs_bulkstat_use_dinode(mp, flags, bp,
-							     clustidx, &dip)) {
-					lastino = ino;
-					continue;
-				}
-				/*
-				 * If we need to do an iget, cannot hold bp.
-				 * Drop it, until starting the next cluster.
-				 */
-				if ((flags & BULKSTAT_FG_INLINE) && !dip) {
-					if (bp)
-						xfs_buf_relse(bp);
-					bp = NULL;
-				}
 
 				/*
 				 * Get the inode and fill in a single buffer.
-				 * BULKSTAT_FG_QUICK uses dip to fill it in.
-				 * BULKSTAT_FG_IGET uses igets.
-				 * BULKSTAT_FG_INLINE uses dip if we have an
-				 * inline attr fork, else igets.
-				 * See: xfs_bulkstat_one & xfs_dm_bulkstat_one.
-				 * This is also used to count inodes/blks, etc
-				 * in xfs_qm_quotacheck.
 				 */
 				ubused = statstruct_size;
-				error = formatter(mp, ino, ubufp,
-						ubleft, private_data,
-						bno, &ubused, dip, &fmterror);
+				error = formatter(mp, ino, ubufp, ubleft, bno,
+						  &ubused, &fmterror);
 				if (fmterror == BULKSTAT_RV_NOTHING) {
 					if (error && error != ENOENT &&
 						error != EINVAL) {
@@ -775,7 +575,7 @@ xfs_bulkstat_single(
 
 	ino = (xfs_ino_t)*lastinop;
 	error = xfs_bulkstat_one(mp, ino, buffer, sizeof(xfs_bstat_t),
-				 NULL, 0, NULL, NULL, &res);
+				 0, NULL, &res);
 	if (error) {
 		/*
 		 * Special case way failed, do it the "long" way
@@ -784,8 +584,7 @@ xfs_bulkstat_single(
 		(*lastinop)--;
 		count = 1;
 		if (xfs_bulkstat(mp, lastinop, &count, xfs_bulkstat_one,
-				NULL, sizeof(xfs_bstat_t), buffer,
-				BULKSTAT_FG_IGET, done))
+				sizeof(xfs_bstat_t), buffer, done))
 			return error;
 		if (count == 0 || (xfs_ino_t)*lastinop != ino)
 			return error == EFSCORRUPTED ?
Index: xfs/fs/xfs/xfs_itable.h
===================================================================
--- xfs.orig/fs/xfs/xfs_itable.h	2010-06-09 14:41:00.791011668 +0200
+++ xfs/fs/xfs/xfs_itable.h	2010-06-09 15:29:03.497004334 +0200
@@ -27,10 +27,8 @@ typedef int (*bulkstat_one_pf)(struct xf
 			       xfs_ino_t	ino,
 			       void		__user *buffer,
 			       int		ubsize,
-			       void		*private_data,
 			       xfs_daddr_t	bno,
 			       int		*ubused,
-			       void		*dip,
 			       int		*stat);
 
 /*
@@ -41,13 +39,6 @@ typedef int (*bulkstat_one_pf)(struct xf
 #define BULKSTAT_RV_GIVEUP	2
 
 /*
- * Values for bulkstat flag argument.
- */
-#define BULKSTAT_FG_IGET	0x1	/* Go through the buffer cache */
-#define BULKSTAT_FG_QUICK	0x2	/* No iget, walk the dinode cluster */
-#define BULKSTAT_FG_INLINE	0x4	/* No iget if inline attrs */
-
-/*
  * Return stat information in bulk (by-inode) for the filesystem.
  */
 int					/* error status */
@@ -56,10 +47,8 @@ xfs_bulkstat(
 	xfs_ino_t	*lastino,	/* last inode returned */
 	int		*count,		/* size of buffer/count returned */
 	bulkstat_one_pf formatter,	/* func that'd fill a single buf */
-	void		*private_data,	/* private data for formatter */
 	size_t		statstruct_size,/* sizeof struct that we're filling */
 	char		__user *ubuffer,/* buffer with inode stats */
-	int		flags,		/* flag to control access method */
 	int		*done);		/* 1 if there are more stats to get */
 
 int
@@ -84,7 +73,6 @@ xfs_bulkstat_one_int(
 	bulkstat_one_fmt_pf	formatter,
 	xfs_daddr_t		bno,
 	int			*ubused,
-	void			*dibuff,
 	int			*stat);
 
 int
@@ -93,10 +81,8 @@ xfs_bulkstat_one(
 	xfs_ino_t		ino,
 	void			__user *buffer,
 	int			ubsize,
-	void			*private_data,
 	xfs_daddr_t		bno,
 	int			*ubused,
-	void			*dibuff,
 	int			*stat);
 
 typedef int (*inumbers_fmt_pf)(

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
