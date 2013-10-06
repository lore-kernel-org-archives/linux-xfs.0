Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 119347F52
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 15:13:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B5AB4304048
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 13:13:18 -0700 (PDT)
Received: from mail-pd0-f181.google.com (mail-pd0-f181.google.com
	[209.85.192.181]) by cuda.sgi.com with ESMTP id
	lqOJc0IqkY2HeNLz (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 06 Oct 2013 13:13:17 -0700 (PDT)
Received: by mail-pd0-f181.google.com with SMTP id g10so6224249pdj.40
	for <xfs@oss.sgi.com>; Sun, 06 Oct 2013 13:13:17 -0700 (PDT)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH RESEND 2/7] xfs: add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
Date: Mon,  7 Oct 2013 05:13:08 +0900
Message-Id: <1381090388-2761-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, tytso@mit.edu, adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org, hch@infradead.org, david@fromorbit.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add support FALLOC_FL_COLLAPSE_RANGE for fallocate.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/xfs/xfs_bmap.c      |  174 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap.h      |    3 +
 fs/xfs/xfs_bmap_util.c |   96 ++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h |    2 +
 fs/xfs/xfs_file.c      |   20 ++++--
 fs/xfs/xfs_fs.h        |    6 ++
 6 files changed, 296 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 92b8309..c12358e 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5356,3 +5356,177 @@ error0:
 	}
 	return error;
 }
+
+/*
+ * Update extents by shifting them downwards into a hole.
+ * At max count number of extents will be shifted and *current_ext
+ * is the extent number which is currently being shifted.
+ * This function will return error if the hole is not present
+ * while shifting extents. On success, 0 is returned.
+ */
+int
+xfs_bmap_shift_extents(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			*done,
+	xfs_fileoff_t		start_fsb,
+	xfs_fileoff_t		shift,
+	xfs_extnum_t		*current_ext,
+	xfs_fsblock_t		*firstblock,
+	struct xfs_bmap_free	*flist,
+	int			count)
+{
+	struct xfs_btree_cur		*cur;
+	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_bmbt_irec		left;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_ifork		*ifp;
+	xfs_extnum_t			nexts = 0;
+	xfs_fileoff_t			startoff;
+	int				error = 0;
+	int				i;
+	int				whichfork = XFS_DATA_FORK;
+	int				state;
+	int				logflags;
+	xfs_filblks_t			blockcount = 0;
+
+	if (unlikely(XFS_TEST_ERROR(
+	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
+	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
+		XFS_ERROR_REPORT("xfs_bmap_shift_extents",
+				 XFS_ERRLEVEL_LOW, mp);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		/* Read in all the extents */
+		error = xfs_iread_extents(tp, ip, whichfork);
+		if (error)
+			return error;
+	}
+
+	if (!*current_ext) {
+		gotp = xfs_iext_bno_to_ext(ifp, start_fsb, current_ext);
+		/*
+		 * gotp can be null in 2 cases: 1) if there are no extents
+		 * or 2) start_fsb lies in a hole beyond which there are
+		 * no extents. Either way, we are done.
+		 */
+		if (!gotp) {
+			*done = 1;
+			return 0;
+		}
+	}
+
+	/* We are going to change core inode */
+	logflags = XFS_ILOG_CORE;
+
+	if (ifp->if_flags & XFS_IFBROOT) {
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
+		cur->bc_private.b.firstblock = *firstblock;
+		cur->bc_private.b.flist = flist;
+		cur->bc_private.b.flags = 0;
+		}
+	else {
+		cur = NULL;
+		logflags |= XFS_ILOG_DEXT;
+	}
+
+	while (nexts++ < count &&
+	       *current_ext <  XFS_IFORK_NEXTENTS(ip, whichfork)) {
+		state = 0;
+
+		gotp = xfs_iext_get_ext(ifp, *current_ext);
+		startoff = xfs_bmbt_get_startoff(gotp);
+		startoff -= shift;
+
+		/*
+		 * Before shifting extent into hole, make sure that the hole
+		 * is large enough to accomodate the shift.
+		 */
+		if (*current_ext) {
+			state |= BMAP_LEFT_VALID;
+			xfs_bmbt_get_all(xfs_iext_get_ext(ifp,
+						*current_ext - 1), &left);
+
+			if (isnullstartblock(left.br_startblock))
+				state |= BMAP_LEFT_DELAY;
+
+			if (startoff < left.br_startoff + left.br_blockcount)
+				error = XFS_ERROR(EFSCORRUPTED);
+
+		} else if (startoff > xfs_bmbt_get_startoff(gotp))
+			/* Hole is at the start but not large enough */
+			error = XFS_ERROR(EFSCORRUPTED);
+
+		if (error)
+			goto del_cursor;
+
+		/* Check if we can merge 2 adjacent extents */
+		if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY) &&
+		    left.br_startoff + left.br_blockcount == startoff &&
+		    left.br_startblock + left.br_blockcount ==
+		    xfs_bmbt_get_startblock(gotp) &&
+		    xfs_bmbt_get_state(gotp) == left.br_state &&
+		    left.br_blockcount + xfs_bmbt_get_blockcount(gotp) <=
+		    MAXEXTLEN) {
+			blockcount =
+			left.br_blockcount + xfs_bmbt_get_blockcount(gotp);
+			state |= BMAP_LEFT_CONTIG;
+			xfs_iext_remove(ip, *current_ext, 1, 0);
+			XFS_IFORK_NEXT_SET(ip, whichfork,
+				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
+			gotp = xfs_iext_get_ext(ifp, --*current_ext);
+		}
+
+		if (cur) {
+			error = xfs_bmbt_lookup_eq(cur,
+					xfs_bmbt_get_startoff(gotp),
+					xfs_bmbt_get_startblock(gotp),
+					xfs_bmbt_get_blockcount(gotp),
+					&i);
+			if (error)
+				goto del_cursor;
+			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+		}
+
+		if (state & BMAP_LEFT_CONTIG) {
+			/* We have to update extent block count */
+			xfs_bmbt_set_blockcount(gotp, blockcount);
+		} else {
+			/* We have to update the startoff */
+			xfs_bmbt_set_startoff(gotp, startoff);
+		}
+
+		if (cur) {
+			error = xfs_bmbt_update(cur,
+						xfs_bmbt_get_startoff(gotp),
+						xfs_bmbt_get_startblock(gotp),
+						xfs_bmbt_get_blockcount(gotp),
+						xfs_bmbt_get_state(gotp));
+			if (error)
+				goto del_cursor;
+		}
+
+		(*current_ext)++;
+	}
+
+	/* Check if we are done */
+	if (*current_ext ==  XFS_IFORK_NEXTENTS(ip, whichfork))
+		*done = 1;
+
+del_cursor:
+	if (cur)
+		xfs_btree_del_cursor(cur,
+			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+
+	xfs_trans_log_inode(tp, ip, logflags);
+
+	return error;
+}
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 33b41f3..b16ebfa 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -169,5 +169,8 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
 		xfs_extnum_t num);
 uint	xfs_default_attroffset(struct xfs_inode *ip);
+int	xfs_bmap_shift_extents(struct xfs_trans *, struct xfs_inode *,
+			int *, xfs_fileoff_t, xfs_fileoff_t, xfs_extnum_t *,
+			xfs_fsblock_t *, struct xfs_bmap_free *, int);
 
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 541d59f..57f045e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1556,6 +1556,7 @@ xfs_change_file_space(
 	case XFS_IOC_RESVSP64:
 	case XFS_IOC_UNRESVSP:
 	case XFS_IOC_UNRESVSP64:
+	case XFS_COLLAPSE_RANGE:
 		if (bf->l_len <= 0)
 			return XFS_ERROR(EINVAL);
 		break;
@@ -1638,6 +1639,12 @@ xfs_change_file_space(
 
 		clrprealloc = 1;
 		break;
+	case XFS_COLLAPSE_RANGE:
+		error = xfs_collapse_file_space(ip, startoffset, bf->l_len,
+						attr_flags);
+		if (error)
+			return error;
+		break;
 
 	default:
 		ASSERT(0);
@@ -1683,6 +1690,95 @@ xfs_change_file_space(
 	return xfs_trans_commit(tp, 0);
 }
 
+
+/*
+ * xfs_collapse_file_space: Implements the FALLOC_FL_COLLAPSE_SPACE flag.
+ */
+int
+xfs_collapse_file_space(
+	struct xfs_inode	*ip,
+	loff_t			offset,
+	loff_t			len,
+	int			attr_flags)
+{
+	int			done = 0;
+	struct xfs_mount	*mp = ip->i_mount;
+	uint			resblks;
+	struct xfs_trans	*tp;
+	int			error;
+	xfs_extnum_t		current_ext = 0;
+	struct xfs_bmap_free	free_list;
+	xfs_fsblock_t		first_block;
+	int			committed;
+	xfs_fileoff_t	start_fsb = XFS_B_TO_FSB(mp, offset + len);
+	xfs_fileoff_t	shift_fsb = XFS_B_TO_FSB(mp, len);
+
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+
+	/*
+	 * The first thing we do is to free data blocks in the specified range
+	 * by calling xfs_free_file_space(). It would also sync dirty data
+	 * and invalidate page cache over the region on which collapse range
+	 * is working.
+	 */
+
+	error = xfs_free_file_space(ip, offset, len, attr_flags);
+	if (error)
+		return error;
+
+	while (!error && !done) {
+		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
+		tp->t_flags |= XFS_TRANS_RESERVE;
+		/*
+		 * We would need to reserve permanent block for transaction.
+		 * This will come into picture when after shifting extent into
+		 * hole we found that adjacent extents can be merged which
+		 * may lead to freeing of a block during record update.
+		 */
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
+		if (error) {
+			ASSERT(error == ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+			xfs_trans_cancel(tp, 0);
+			break;
+		}
+
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		error = xfs_trans_reserve_quota(tp, mp,
+				ip->i_udquot, ip->i_gdquot, ip->i_pdquot,
+				resblks, 0, XFS_QMOPT_RES_REGBLKS);
+		if (error)
+			goto out;
+
+		xfs_trans_ijoin(tp, ip, 0);
+
+		xfs_bmap_init(&free_list, &first_block);
+
+		/*
+		 * We are using the write transaction in which max 2 bmbt
+		 * updates are allowed
+		 */
+		error = xfs_bmap_shift_extents(tp, ip, &done, start_fsb,
+				shift_fsb, &current_ext,
+				&first_block, &free_list, 2);
+		if (error)
+			goto out;
+
+		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		if (error)
+			goto out;
+
+		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	}
+
+	return error;
+
+out:
+	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	return error;
+}
+
 /*
  * We need to check that the format of the data fork in the temporary inode is
  * valid for the target inode before doing the swap. This is not a problem with
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 0612609..588d29d 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -97,6 +97,8 @@ int	xfs_change_file_space(struct xfs_inode *ip, int cmd,
 			      xfs_flock64_t *bf, xfs_off_t offset,
 			      int attr_flags);
 
+int xfs_collapse_file_space(struct xfs_inode *, loff_t, loff_t, int);
+
 /* EOF block manipulation functions */
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
 int	xfs_free_eofblocks(struct xfs_mount *mp, struct xfs_inode *ip,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 818c623..9c9c1ff 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -807,7 +807,8 @@ xfs_file_fallocate(
 	int		cmd = XFS_IOC_RESVSP;
 	int		attr_flags = XFS_ATTR_NOLOCK;
 
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
+		     FALLOC_FL_COLLAPSE_RANGE))
 		return -EOPNOTSUPP;
 
 	bf.l_whence = 0;
@@ -819,10 +820,19 @@ xfs_file_fallocate(
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		cmd = XFS_IOC_UNRESVSP;
 
-	/* check the new inode size is valid before allocating */
-	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
-	    offset + len > i_size_read(inode)) {
+	/* Shrink size in case of FALLOC_FL_COLLAPSE_RANGE */
+	if (mode & FALLOC_FL_COLLAPSE_RANGE) {
+		cmd = XFS_COLLAPSE_RANGE;
+		if ((offset + len) > i_size_read(inode))
+			new_size = offset;
+		else
+			new_size = i_size_read(inode) - len;
+	} else if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+	    offset + len > i_size_read(inode))
 		new_size = offset + len;
+
+	/* check the new inode size is valid before allocating */
+	if (new_size || mode & FALLOC_FL_COLLAPSE_RANGE) {
 		error = inode_newsize_ok(inode, new_size);
 		if (error)
 			goto out_unlock;
@@ -836,7 +846,7 @@ xfs_file_fallocate(
 		goto out_unlock;
 
 	/* Change file size if needed */
-	if (new_size) {
+	if (new_size ||  mode & FALLOC_FL_COLLAPSE_RANGE) {
 		struct iattr iattr;
 
 		iattr.ia_valid = ATTR_SIZE;
diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 1edb5cc..99f5244 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -516,6 +516,12 @@ typedef struct xfs_swapext
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_eofblocks)
+/*
+ * Although there is no ioctl implemented yet, we reserve an ioctl number for
+ * representing collapse range operation to avoid any possible collision in
+ * switch case of xfs_change_file_space.
+ */
+#define XFS_COLLAPSE_RANGE	_IOW('X', 59, struct xfs_flock64)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
