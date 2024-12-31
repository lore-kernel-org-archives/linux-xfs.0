Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE4313FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688332; cv=none; b=GOUnw+1rT18FngbQjRfRdG11flXGNlfEo2LEQ5QRRByuSAoXTRDYlLXY/1UHnXP1W8nIg7DzXfUMbyE0VFj+2zllfx4LN3ToZNyLzIoyzcEy8/57CyhC0l+5TnOoNbiXWItf6G9z5q5N+jy3g1P9fxuJIVLUy4lO2Ij9ObZG7Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688332; c=relaxed/simple;
	bh=4siW6mV/16ezWx3vT5gKKFFxqagFSZ7Jla9rH23t4uE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S0HJInjQ2K6WSPPSrg5bwOvjOWRiu733p/IB+UnWZitW6OP4fzu9Woowczug4dZvAoYDE7kSkSHXPNBC+JDm4b7c9vLJfC2MYQAZSlUh+HkKRpjpTUMDsWtYlp23AIePv8RBeEvM2HFcf6DuuH4o72CNdA7DseBgEAe35jnhU8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s0mDa1vP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s0mDa1vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79D6C4CED2;
	Tue, 31 Dec 2024 23:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688331;
	bh=4siW6mV/16ezWx3vT5gKKFFxqagFSZ7Jla9rH23t4uE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s0mDa1vPoWP8bIj7s3ZfIyChQ9dnHKh8EfcYpmRMmCpTmjZ4BsGWRt96JfS0fdvef
	 BFraD7cWtb/C3ccwTKOXU/hVRMu36DoMC4FTfC/+kMpzXZ25o9f+CbqaGvThonrMvi
	 VHdwWdaqeV9VGt+lLILJzBNMbfqTP1Tr0G8mX5FM/ujsJJlNwFlz8d9flaHN53edi3
	 wUhfw88evcQATkGtFm2ME8dErf9qr1x6064BLGitpHT9P5So7V+y7jhvAVgwZ2rVLm
	 grfxWdiZQRu/olHgqzN/Ya1zeKaNoI7TQF9cqF7oPH2F0V1m3R1159KsTEnT5mfpSJ
	 wVhb8onaVQgpw==
Date: Tue, 31 Dec 2024 15:38:51 -0800
Subject: [PATCH 4/4] xfs: implement FALLOC_FL_MAP_FREE for realtime files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754285.2704719.13644245015063197003.stgit@frogsfrogsfrogs>
In-Reply-To: <173568754204.2704719.1892779733633851572.stgit@frogsfrogsfrogs>
References: <173568754204.2704719.1892779733633851572.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Implement mapfree for realtime space.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |  202 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h |    2 
 fs/xfs/xfs_file.c      |   14 ++-
 fs/xfs/xfs_rtalloc.c   |  108 ++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h   |    7 ++
 fs/xfs/xfs_trace.h     |   41 ++++++++++
 6 files changed, 368 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8d5c2072bcd533..83e6c27f63a969 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -2219,3 +2219,205 @@ xfs_map_free_space(
 		return 0;
 	return error;
 }
+
+#ifdef CONFIG_XFS_RT
+/*
+ * Given a file and a free rt extent, map it into the file at the same offset
+ * if the file were a sparse image of the physical device.  Set @mval to
+ * whatever mapping we added to the file.
+ */
+STATIC int
+xfs_map_free_rtgroup_extent(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_rtgroup	*rtg,
+	xfs_rtxnum_t		rtx,
+	xfs_rtxlen_t		rtxlen,
+	struct xfs_bmbt_irec	*mval)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fsblock_t		fsbno = xfs_rtx_to_rtb(rtg, rtx);
+	xfs_fileoff_t		startoff = fsbno;
+	xfs_extlen_t		len = xfs_rtbxlen_to_blen(mp, rtxlen);
+	int			nimaps;
+	int			error;
+
+	ASSERT(XFS_IS_REALTIME_INODE(ip));
+
+	trace_xfs_map_free_rt_extent(ip, fsbno, len);
+
+	/* Make sure the entire range is a hole. */
+	nimaps = 1;
+	error = xfs_bmapi_read(ip, startoff, len, &irec, &nimaps, 0);
+	if (error)
+		return error;
+
+	if (irec.br_startoff != startoff ||
+	    irec.br_startblock != HOLESTARTBLOCK ||
+	    irec.br_blockcount < len)
+		return -EINVAL;
+
+	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
+			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error)
+		return error;
+
+	/*
+	 * Allocate the physical extent.  We should not have dropped the lock
+	 * since the scan of the free space metadata, so this should work,
+	 * though the length may be adjusted to play nicely with metadata space
+	 * reservations.
+	 */
+	error = xfs_rtallocate_exact(tp, rtg, rtx, rtxlen);
+	if (error)
+		return error;
+
+	/* Map extent into file, update quota. */
+	mval->br_blockcount = len;
+	mval->br_startblock = fsbno;
+	mval->br_startoff = startoff;
+	mval->br_state = XFS_EXT_UNWRITTEN;
+
+	trace_xfs_map_free_rt_extent_done(ip, mval);
+
+	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, mval);
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_RTBCOUNT,
+			mval->br_blockcount);
+
+	return 0;
+}
+
+/* Find a free extent in this rtgroup and map it into the file. */
+STATIC int
+xfs_map_free_rt_extent(
+	struct xfs_inode	*ip,
+	struct xfs_rtgroup	*rtg,
+	xfs_rtxnum_t		*cursor,
+	xfs_rtxnum_t		end_rtx)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	loff_t			endpos;
+	xfs_rtxlen_t		len_rtx;
+	xfs_extlen_t		free_len;
+	int			error;
+
+	if (fatal_signal_pending(current))
+		return -EINTR;
+
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, 0, 0, false,
+			&tp);
+	if (error)
+		return error;
+
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_BITMAP);
+
+	error = xfs_rtallocate_find_freesp(tp, rtg, cursor, end_rtx, &len_rtx);
+	if (error)
+		goto out_rtglock;
+
+	/*
+	 * If off_rtx is beyond the end of the rt device or is past what the
+	 * user asked for, bail out.
+	 */
+	if (*cursor >= end_rtx)
+		goto out_rtglock;
+
+	free_len = xfs_rtxlen_to_extlen(mp, len_rtx);
+	error = xfs_map_free_reserve_more(tp, ip, &free_len);
+	if (error)
+		goto out_rtglock;
+
+	error = xfs_map_free_rtgroup_extent(tp, ip, rtg, *cursor, len_rtx,
+			&irec);
+	if (error == -EAGAIN) {
+		/*
+		 * The allocator was busy and told us to try again.  The
+		 * transaction could be dirty due to a nrext64 upgrade, so
+		 * commit the transaction and try again without advancing
+		 * the cursor.
+		 *
+		 * XXX do we fail to unlock something here?
+		 */
+		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP);
+		error = xfs_trans_commit(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		return error;
+	}
+	if (error)
+		goto out_cancel;
+
+	/* Update isize if needed. */
+	endpos = XFS_FSB_TO_B(mp, irec.br_startoff + irec.br_blockcount);
+	if (endpos > i_size_read(VFS_I(ip))) {
+		i_size_write(VFS_I(ip), endpos);
+		ip->i_disk_size = endpos;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	}
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error)
+		return error;
+
+	ASSERT(xfs_blen_to_rtxoff(mp, irec.br_blockcount) == 0);
+	*cursor += xfs_extlen_to_rtxlen(mp, irec.br_blockcount);
+	return 0;
+out_rtglock:
+	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP);
+out_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
+/*
+ * Allocate all free physical space between off and len and map it to this
+ * regular realtime file.
+ */
+int
+xfs_map_free_rt_space(
+	struct xfs_inode	*ip,
+	xfs_off_t		off,
+	xfs_off_t		len)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_rtgroup	*rtg = NULL;
+	xfs_daddr_t		off_daddr = BTOBB(off);
+	xfs_daddr_t		end_daddr = BTOBBT(off + len);
+	xfs_rtblock_t		off_rtb = xfs_daddr_to_rtb(mp, off_daddr);
+	xfs_rtblock_t		end_rtb = xfs_daddr_to_rtb(mp, end_daddr);
+	xfs_rgnumber_t		off_rgno = xfs_rtb_to_rgno(mp, off_rtb);
+	xfs_rgnumber_t		end_rgno = xfs_rtb_to_rgno(mp, end_rtb);
+	int			error = 0;
+
+	trace_xfs_map_free_rt_space(ip, off, len);
+
+	while ((rtg = xfs_rtgroup_next_range(mp, rtg, off_rgno,
+					     mp->m_sb.sb_rgcount))) {
+		xfs_rtxnum_t	off_rtx = 0;
+		xfs_rtxnum_t	end_rtx = rtg->rtg_extents;
+
+		if (rtg_rgno(rtg) == off_rgno)
+			off_rtx = xfs_rtb_to_rtx(mp, off_rtb);
+		if (rtg_rgno(rtg) == end_rgno)
+			end_rtx = min(end_rtx, xfs_rtb_to_rtx(mp, end_rtb));
+
+		while (off_rtx < end_rtx) {
+			error = xfs_map_free_rt_extent(ip, rtg, &off_rtx,
+					end_rtx);
+			if (error)
+				goto out;
+		}
+	}
+
+out:
+	if (rtg)
+		xfs_rtgroup_rele(rtg);
+	if (error == -ENOSPC)
+		return 0;
+	return error;
+}
+#endif
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 5d84b702b16326..0e16fbfef6cd09 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -85,8 +85,10 @@ int	xfs_flush_unmap_range(struct xfs_inode *ip, xfs_off_t offset,
 #ifdef CONFIG_XFS_RT
 int xfs_convert_rtbigalloc_file_space(struct xfs_inode *ip, loff_t pos,
 		uint64_t len);
+int xfs_map_free_rt_space(struct xfs_inode *ip, xfs_off_t off, xfs_off_t len);
 #else
 # define xfs_convert_rtbigalloc_file_space(ip, pos, len)	(-EOPNOTSUPP)
+# define xfs_map_free_rt_space(ip, off, len)			(-EOPNOTSUPP)
 #endif
 
 #endif	/* __XFS_BMAP_UTIL_H__ */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8bf1e96ab57a5b..ceb7936e5fd9a3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1580,11 +1580,10 @@ xfs_file_map_freesp(
 	if (error)
 		goto out_unlock;
 
-	if (XFS_IS_REALTIME_INODE(ip)) {
-		error = -EOPNOTSUPP;
-		goto out_unlock;
-	}
-	device_size = XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks);
+	if (XFS_IS_REALTIME_INODE(ip))
+		device_size = XFS_FSB_TO_B(mp, mp->m_sb.sb_rblocks);
+	else
+		device_size = XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks);
 
 	/*
 	 * Bail out now if we aren't allowed to make the file size the
@@ -1597,7 +1596,10 @@ xfs_file_map_freesp(
 			goto out_unlock;
 	}
 
-	error = xfs_map_free_space(ip, mf->offset, mf->len);
+	if (XFS_IS_REALTIME_INODE(ip))
+		error = xfs_map_free_rt_space(ip, mf->offset, mf->len);
+	else
+		error = xfs_map_free_space(ip, mf->offset, mf->len);
 	if (error) {
 		if (error == -ECANCELED)
 			error = 0;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 2728c568ac5a8a..0a4e087b11b60e 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -2230,3 +2230,111 @@ xfs_bmap_rtalloc(
 	xfs_bmap_alloc_account(ap);
 	return 0;
 }
+
+/*
+ * Find the next free realtime extent starting at @rtx and going no higher than
+ * @end_rtx.  Set @rtx and @len_rtx to whatever free extents we find, or to
+ * @end_rtx if we find no space.
+ */
+int
+xfs_rtallocate_find_freesp(
+	struct xfs_trans	*tp,
+	struct xfs_rtgroup	*rtg,
+	xfs_rtxnum_t		*rtx,
+	xfs_rtxnum_t		end_rtx,
+	xfs_rtxlen_t		*len_rtx)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_rtalloc_args	args = {
+		.rtg		= rtg,
+		.mp		= mp,
+		.tp		= tp,
+	};
+	const unsigned int	max_rtxlen =
+			xfs_blen_to_rtbxlen(mp, XFS_MAX_BMBT_EXTLEN);
+	int			error;
+
+	trace_xfs_rtallocate_find_freesp(rtg, *rtx, end_rtx - *rtx);
+
+	while (*rtx < end_rtx) {
+		xfs_rtblock_t	next_rtx;
+		int		is_free = 0;
+
+		if (fatal_signal_pending(current))
+			return -EINTR;
+
+		/* Is the first rtx in the range free? */
+		error = xfs_rtcheck_range(&args, *rtx, 1, 1, &next_rtx,
+				&is_free);
+		if (error)
+			return error;
+
+		/* Free or not, how many more rtx have the same status? */
+		error = xfs_rtfind_forw(&args, *rtx, end_rtx, &next_rtx);
+		if (error)
+			return error;
+
+		if (is_free) {
+			*len_rtx = min_t(xfs_rtxlen_t, max_rtxlen,
+					 next_rtx - *rtx + 1);
+
+			trace_xfs_rtallocate_find_freesp_done(rtg, *rtx,
+					*len_rtx);
+			return 0;
+		}
+
+		*rtx = next_rtx + 1;
+	}
+
+	return 0;
+}
+
+/* Allocate exactly this space from the rt device. */
+int
+xfs_rtallocate_exact(
+	struct xfs_trans	*tp,
+	struct xfs_rtgroup	*rtg,
+	xfs_rtxnum_t		rtx,
+	xfs_rtxlen_t		len)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_rtalloc_args	args = {
+		.rtg		= rtg,
+		.mp		= mp,
+		.tp		= tp,
+	};
+	int			error;
+
+	trace_xfs_rtallocate_exact(rtg, rtx, len);
+
+	if (xfs_has_rtgroups(mp)) {
+		xfs_rtxnum_t	resrtx = rtx;
+		xfs_rtxlen_t	reslen = len;
+
+		/*
+		 * Never pass 0 for start here so that the busy extent code
+		 * knows that we wanted a near allocation and will flush the
+		 * log to wait for the start to become available.
+		 */
+		error = xfs_rtallocate_adjust_for_busy(&args, rtx ? rtx : 1, 1,
+				len, &reslen, 1, &resrtx);
+		if (error)
+			return error;
+
+		if (resrtx != rtx) {
+			ASSERT(resrtx == rtx);
+			return -EAGAIN;
+		}
+
+		len = reslen;
+	}
+
+	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_BITMAP);
+
+	error = xfs_rtallocate_range(&args, rtx, len);
+	if (error)
+		return error;
+
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, -(long)len);
+	return 0;
+}
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 0d95b29092c9f3..745af8a2798d36 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -10,6 +10,7 @@
 
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_rtgroup;
 
 #ifdef CONFIG_XFS_RT
 /* rtgroup superblock initialization */
@@ -48,6 +49,10 @@ xfs_growfs_rt(
 int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 int xfs_growfs_check_rtgeom(const struct xfs_mount *mp, xfs_rfsblock_t dblocks,
 		xfs_rfsblock_t rblocks, xfs_agblock_t rextsize);
+int xfs_rtallocate_find_freesp(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
+		xfs_rtxnum_t *rtx, xfs_rtxnum_t end_rtx, xfs_rtxlen_t *len_rtx);
+int xfs_rtallocate_exact(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
+		xfs_rtxnum_t rtx, xfs_rtxlen_t rtxlen);
 #else
 # define xfs_growfs_rt(mp,in)				(-ENOSYS)
 # define xfs_rtalloc_reinit_frextents(m)		(0)
@@ -67,6 +72,8 @@ xfs_rtmount_init(
 # define xfs_rtunmount_inodes(m)
 # define xfs_rt_resv_free(mp)				((void)0)
 # define xfs_rt_resv_init(mp)				(0)
+# define xfs_rtallocate_find_freesp(...)		(-EOPNOTSUPP)
+# define xfs_rtallocate_exact(...)			(-EOPNOTSUPP)
 
 static inline int
 xfs_growfs_check_rtgeom(const struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ebbc832db8fa1e..76f5d78b6a6e09 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -105,6 +105,7 @@ struct xfs_rtgroup;
 struct xfs_open_zone;
 struct xfs_fsrefs;
 struct xfs_fsrefs_irec;
+struct xfs_rtgroup;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -1732,6 +1733,9 @@ DEFINE_SIMPLE_IO_EVENT(xfs_free_file_space);
 DEFINE_SIMPLE_IO_EVENT(xfs_zero_file_space);
 DEFINE_SIMPLE_IO_EVENT(xfs_collapse_file_space);
 DEFINE_SIMPLE_IO_EVENT(xfs_insert_file_space);
+#ifdef CONFIG_XFS_RT
+DEFINE_SIMPLE_IO_EVENT(xfs_map_free_rt_space);
+#endif /* CONFIG_XFS_RT */
 DEFINE_SIMPLE_IO_EVENT(xfs_map_free_space);
 
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
@@ -1851,6 +1855,9 @@ DEFINE_EVENT(xfs_map_free_extent_class, name, \
 	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t bno, xfs_extlen_t len), \
 	TP_ARGS(ip, bno, len))
 DEFINE_MAP_FREE_EXTENT_EVENT(xfs_map_free_ag_extent);
+#ifdef CONFIG_XFS_RT
+DEFINE_MAP_FREE_EXTENT_EVENT(xfs_map_free_rt_extent);
+#endif
 
 DECLARE_EVENT_CLASS(xfs_extent_busy_class,
 	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
@@ -1995,6 +2002,37 @@ TRACE_EVENT(xfs_rtalloc_extent_busy_trim,
 		  __entry->new_rtx,
 		  __entry->new_len)
 );
+
+DECLARE_EVENT_CLASS(xfs_rtextent_class,
+	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rtxnum_t off_rtx,
+		 xfs_rtxlen_t len_rtx),
+	TP_ARGS(rtg, off_rtx, len_rtx),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(xfs_rtxnum_t, off_rtx)
+		__field(xfs_rtxlen_t, len_rtx)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg_mount(rtg)->m_super->s_dev;
+		__entry->rgno = rtg_rgno(rtg);
+		__entry->off_rtx = off_rtx;
+		__entry->len_rtx = len_rtx;
+	),
+	TP_printk("dev %d:%d rgno 0x%x rtx 0x%llx rtxcount 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rgno,
+		  __entry->off_rtx,
+		  __entry->len_rtx)
+);
+#define DEFINE_RTEXTENT_EVENT(name) \
+DEFINE_EVENT(xfs_rtextent_class, name, \
+	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rtxnum_t off_rtx, \
+		 xfs_rtxlen_t len_rtx), \
+	TP_ARGS(rtg, off_rtx, len_rtx))
+DEFINE_RTEXTENT_EVENT(xfs_rtallocate_exact);
+DEFINE_RTEXTENT_EVENT(xfs_rtallocate_find_freesp);
+DEFINE_RTEXTENT_EVENT(xfs_rtallocate_find_freesp_done);
 #endif /* CONFIG_XFS_RT */
 
 DECLARE_EVENT_CLASS(xfs_agf_class,
@@ -3996,6 +4034,9 @@ DEFINE_EVENT(xfs_inode_irec_class, name, \
 	TP_PROTO(struct xfs_inode *ip, struct xfs_bmbt_irec *irec), \
 	TP_ARGS(ip, irec))
 DEFINE_INODE_IREC_EVENT(xfs_map_free_ag_extent_done);
+#ifdef CONFIG_XFS_RT
+DEFINE_INODE_IREC_EVENT(xfs_map_free_rt_extent_done);
+#endif
 
 /* inode iomap invalidation events */
 DECLARE_EVENT_CLASS(xfs_wb_invalid_class,

