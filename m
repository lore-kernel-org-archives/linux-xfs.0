Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 032927FF3
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 10:38:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF9298F8068
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 08:38:10 -0800 (PST)
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id G8qrIHhL7KS4dDJu
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 18 Feb 2014 08:38:06 -0800 (PST)
Received: by mail-pb0-f53.google.com with SMTP id md12so16931789pbc.12
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 08:38:05 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v5 2/10] xfs: Add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
Date: Wed, 19 Feb 2014 01:37:55 +0900
Message-Id: <1392741475-20063-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com, lczerner@redhat.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch implements fallocate's FALLOC_FL_COLLAPSE_RANGE for XFS.

The semantics of this flag are following:
1) It collapses the range lying between offset and length by removing any data
   blocks which are present in this range and than updates all the logical
   offsets of extents beyond "offset + len" to nullify the hole created by
   removing blocks. In short, it does not leave a hole.
2) It should be used exclusively. No other fallocate flag in combination.
3) Offset and length supplied to fallocate should be fs block size aligned
   in case of xfs and ext4.
4) Collaspe range does not work beyond i_size.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---

Changelog
v5:
- reduce the number of extents to be shifted under write transactions from 2 to 1
- Simplified a check for the case when shifting first extent of the file,
  the hole is at the begining not large enough to contain the shift

v4:
- move block size aligned check from VFS layer to FS specific layer.
- update comments for xfs_bmap_shift_extents and change variable name
  to more reasonable name.
- add ASSERTs for pointers in XFS patch.
- drop all the xfs_bmbt_get*() wrappers.
- change return errno from EFSCORRUPTED to EINVAL,
  when hole is not large enough to contain the shift.
- xfs: remove extents from on-disk btree also in case of merge.

v3:
- fix checkpatch.pl warning

v2:
- Added check to make sure before shifting that the hole is big enough to
  contian the shift.
- Added code to make merging of extent where possible.
- Under write transaction we are only allowed for 2 bmbt updated. Reduce the
  number of extents to be shifted in 1 transaction from 3 to 2.
- Change semantics of collapse range and contain it within EOF.

 fs/xfs/xfs_bmap.c      | 193 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap.h      |  15 ++++
 fs/xfs/xfs_bmap_util.c |  96 ++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h |   2 +
 fs/xfs/xfs_file.c      |  19 ++++-
 fs/xfs/xfs_trace.h     |   1 +
 6 files changed, 324 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 152543c..5b6092e 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5378,3 +5378,196 @@ error0:
 	}
 	return error;
 }
+
+/*
+ * Shift extent records to the left to cover a hole.
+ *
+ * The maximum number of extents to be shifted in a single operation
+ * is @num_exts, and @current_ext keeps track of the current extent
+ * index we have shifted. @offset_shift_fsb is the length by which each
+ * extent is shifted. If there is no hole to shift the extents
+ * into, this will be considered invalid operation and we abort immediately.
+ */
+int
+xfs_bmap_shift_extents(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			*done,
+	xfs_fileoff_t		start_fsb,
+	xfs_fileoff_t		offset_shift_fsb,
+	xfs_extnum_t		*current_ext,
+	xfs_fsblock_t		*firstblock,
+	struct xfs_bmap_free	*flist,
+	int			num_exts)
+{
+	struct xfs_btree_cur		*cur;
+	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_bmbt_irec            got;
+	struct xfs_bmbt_irec		left;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_ifork		*ifp;
+	xfs_extnum_t			nexts = 0;
+	xfs_fileoff_t			startoff;
+	int				error = 0;
+	int				i;
+	int				whichfork = XFS_DATA_FORK;
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
+	ASSERT(current_ext != NULL);
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
+	/*
+	 * If *current_ext is 0, we would need to lookup the extent
+	 * from where we would start shifting and store it in gotp.
+	 */
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
+	} else {
+		cur = NULL;
+		logflags |= XFS_ILOG_DEXT;
+	}
+
+	while (nexts++ < num_exts &&
+	       *current_ext <  XFS_IFORK_NEXTENTS(ip, whichfork)) {
+
+		gotp = xfs_iext_get_ext(ifp, *current_ext);
+		xfs_bmbt_get_all(gotp, &got);
+		startoff = got.br_startoff - offset_shift_fsb;
+
+		/*
+		 * Before shifting extent into hole, make sure that the hole
+		 * is large enough to accomodate the shift.
+		 */
+		if (*current_ext) {
+			xfs_bmbt_get_all(xfs_iext_get_ext(ifp,
+						*current_ext - 1), &left);
+
+			if (startoff < left.br_startoff + left.br_blockcount)
+				error = XFS_ERROR(EINVAL);
+		} else if (offset_shift_fsb > got.br_startoff) {
+			/*
+			 * When first extent is shifted, offset_shift_fsb
+			 * should be less than the stating offset of
+			 * the first extent.
+			 */
+			error = XFS_ERROR(EINVAL);
+		}
+
+		if (error)
+			goto del_cursor;
+
+		if (cur) {
+			error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
+						   got.br_startblock,
+						   got.br_blockcount,
+						   &i);
+			if (error)
+				goto del_cursor;
+			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+		}
+
+		/* Check if we can merge 2 adjacent extents */
+		if (*current_ext &&
+		    left.br_startoff + left.br_blockcount == startoff &&
+		    left.br_startblock + left.br_blockcount ==
+				got.br_startblock &&
+		    left.br_state == got.br_state &&
+		    left.br_blockcount + got.br_blockcount <= MAXEXTLEN) {
+			blockcount = left.br_blockcount +
+				got.br_blockcount;
+			xfs_iext_remove(ip, *current_ext, 1, 0);
+			if (cur) {
+				error = xfs_btree_delete(cur, &i);
+				if (error)
+					goto del_cursor;
+				XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+			}
+			XFS_IFORK_NEXT_SET(ip, whichfork,
+				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
+			gotp = xfs_iext_get_ext(ifp, --*current_ext);
+			xfs_bmbt_get_all(gotp, &got);
+
+			/* Make cursor point to the extent we will update */
+			if (cur) {
+				error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
+							   got.br_startblock,
+							   got.br_blockcount,
+							   &i);
+				if (error)
+					goto del_cursor;
+				XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+			}
+
+			xfs_bmbt_set_blockcount(gotp, blockcount);
+			got.br_blockcount = blockcount;
+		} else {
+			/* We have to update the startoff */
+			xfs_bmbt_set_startoff(gotp, startoff);
+			got.br_startoff = startoff;
+		}
+
+		if (cur) {
+			error = xfs_bmbt_update(cur, got.br_startoff,
+						got.br_startblock,
+						got.br_blockcount,
+						got.br_state);
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
index 33b41f3..f84bd7a 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -127,6 +127,16 @@ static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
 	{ BMAP_RIGHT_FILLING,	"RF" }, \
 	{ BMAP_ATTRFORK,	"ATTR" }
 
+
+/*
+ * This macro is used to determine how many extents will be shifted
+ * in one write transaction. We could require two splits,
+ * an extent move on the first and an extent merge on the second,
+ * So it is proper that one extent is shifted inside write transaction
+ * at a time.
+ */
+#define XFS_BMAP_MAX_SHIFT_EXTENTS	1
+
 #ifdef DEBUG
 void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 		int whichfork, unsigned long caller_ip);
@@ -169,5 +179,10 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
 		xfs_extnum_t num);
 uint	xfs_default_attroffset(struct xfs_inode *ip);
+int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
+		int *done, xfs_fileoff_t start_fsb,
+		xfs_fileoff_t offset_shift_fsb, xfs_extnum_t *current_ext,
+		xfs_fsblock_t *firstblock, struct xfs_bmap_free	*flist,
+		int num_exts);
 
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f264616..4e59da4 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1468,6 +1468,102 @@ out:
 }
 
 /*
+ * xfs_collapse_file_space()
+ *	This routine frees disk space and shift extent for the given file.
+ *	The first thing we do is to free data blocks in the specified range
+ *	by calling xfs_free_file_space(). It would also sync dirty data
+ *	and invalidate page cache over the region on which collapse range
+ *	is working. And Shift extent records to the left to cover a hole.
+ * RETURNS:
+ *	0 on success
+ *	errno on error
+ *
+ */
+int
+xfs_collapse_file_space(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		len)
+{
+	int			done = 0;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+	xfs_extnum_t		current_ext = 0;
+	struct xfs_bmap_free	free_list;
+	xfs_fsblock_t		first_block;
+	int			committed;
+	xfs_fileoff_t		start_fsb;
+	xfs_fileoff_t		shift_fsb;
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+
+	trace_xfs_collapse_file_space(ip);
+
+	start_fsb = XFS_B_TO_FSB(mp, offset + len);
+	shift_fsb = XFS_B_TO_FSB(mp, len);
+
+	error = xfs_free_file_space(ip, offset, len);
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
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
+		if (error) {
+			ASSERT(error == ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+			xfs_trans_cancel(tp, 0);
+			break;
+		}
+
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
+				ip->i_gdquot, ip->i_pdquot,
+				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0,
+				XFS_QMOPT_RES_REGBLKS);
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
+					       shift_fsb, &current_ext,
+					       &first_block, &free_list,
+					       XFS_BMAP_MAX_SHIFT_EXTENTS);
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
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
+/*
  * We need to check that the format of the data fork in the temporary inode is
  * valid for the target inode before doing the swap. This is not a problem with
  * attr1 because of the fixed fork offset, but attr2 has a dynamically sized
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 900747b..935ed2b 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -99,6 +99,8 @@ int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
 			    xfs_off_t len);
 int	xfs_zero_file_space(struct xfs_inode *ip, xfs_off_t offset,
 			    xfs_off_t len);
+int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
+				xfs_off_t len);
 
 /* EOF block manipulation functions */
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 64b48ea..7a774f9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -823,7 +823,8 @@ xfs_file_fallocate(
 
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
+		     FALLOC_FL_COLLAPSE_RANGE))
 		return -EOPNOTSUPP;
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
@@ -831,6 +832,20 @@ xfs_file_fallocate(
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
 			goto out_unlock;
+	} else if (mode & FALLOC_FL_COLLAPSE_RANGE) {
+		unsigned blksize_mask = (1 << inode->i_blkbits) - 1;
+
+		if (offset & blksize_mask || len & blksize_mask) {
+			error = -EINVAL;
+			goto out_unlock;
+		}
+
+		ASSERT(offset + len < i_size_read(inode));
+		new_size = i_size_read(inode) - len;
+
+		error = xfs_collapse_file_space(ip, offset, len);
+		if (error)
+			goto out_unlock;
 	} else {
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    offset + len > i_size_read(inode)) {
@@ -859,7 +874,7 @@ xfs_file_fallocate(
 	if (ip->i_d.di_mode & S_IXGRP)
 		ip->i_d.di_mode &= ~S_ISGID;
 
-	if (!(mode & FALLOC_FL_PUNCH_HOLE))
+	if (!(mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)))
 		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 425dfa4..a4ae41c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -603,6 +603,7 @@ DEFINE_INODE_EVENT(xfs_readlink);
 DEFINE_INODE_EVENT(xfs_inactive_symlink);
 DEFINE_INODE_EVENT(xfs_alloc_file_space);
 DEFINE_INODE_EVENT(xfs_free_file_space);
+DEFINE_INODE_EVENT(xfs_collapse_file_space);
 DEFINE_INODE_EVENT(xfs_readdir);
 #ifdef CONFIG_XFS_POSIX_ACL
 DEFINE_INODE_EVENT(xfs_get_acl);
-- 
1.7.11-rc0


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
