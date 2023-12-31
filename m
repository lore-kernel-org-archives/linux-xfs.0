Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FE2F9CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="phBR+I0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CCCC433C8;
	Sun, 31 Dec 2023 20:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054614;
	bh=9882EWFGHEOwHo7bT2wt+zpbv9AgbqopDD9aP5IaKbU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=phBR+I0Z9IT1bsAcdXenQ5j8Yx3yxb+Ud1nlzV4Z6ifYr2npnimZnVbmqjX7Eipqx
	 xV55v+lHWPuLKi1WWGreHOdhNVXleA8lWVG5zP0NeC7F5u1ruQSMrbE8zQYfXa2g75
	 5xj1lYGUE3WbVqWqv7Esie9h3LfHXK1o/bCy52fs/IL8DUCcYZvcOeCNsz8oR+b0l7
	 gTrf8gxzrPmrWu4iBtnqvP0vnHWHNsLuAvzVYOGUEtO75FbC3/2jnVXt5sMQnoJVrZ
	 Y6L+tVFmJ+cwGHQ+7J4SOtxC8f8cRwO6QuSjZh7UrghhNQ7wU/9FvQ9zq6w6s4jJvS
	 l4BENFXC9vTZg==
Date: Sun, 31 Dec 2023 12:30:14 -0800
Subject: [PATCH 23/25] xfs: make atomic extent swapping support realtime files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833510.1750288.3946324503305445551.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that bmap items support the realtime device, we can add the
necessary pieces to the atomic extent swapping code to support such
things.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_swapext.c |  165 ++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_bmap_util.c      |  185 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h      |    7 ++
 fs/xfs/xfs_inode.h          |    5 +
 fs/xfs/xfs_trace.h          |   11 ++-
 fs/xfs/xfs_xchgrange.c      |   61 ++++++++++++++
 fs/xfs/xfs_xchgrange.h      |    2 
 7 files changed, 418 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index e84b9ffe9df6b..7e36e136cee0d 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -31,6 +31,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_dir2.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_rtbitmap.h"
 
 struct kmem_cache	*xfs_swapext_intent_cache;
 
@@ -133,6 +134,102 @@ sxi_advance(
 	sxi->sxi_blockcount -= irec->br_blockcount;
 }
 
+#ifdef DEBUG
+/*
+ * If we're going to do a BUI-only extent swap, ensure that all mappings are
+ * aligned to the realtime extent size.
+ */
+static inline int
+xfs_swapext_check_rt_extents(
+	struct xfs_mount		*mp,
+	const struct xfs_swapext_req	*req)
+{
+	struct xfs_bmbt_irec		irec1, irec2;
+	xfs_fileoff_t			startoff1 = req->startoff1;
+	xfs_fileoff_t			startoff2 = req->startoff2;
+	xfs_filblks_t			blockcount = req->blockcount;
+	uint32_t			mod;
+	int				nimaps;
+	int				error;
+
+	/* xattrs don't live on the rt device */
+	if (req->whichfork == XFS_ATTR_FORK)
+		return 0;
+
+	/*
+	 * Caller got permission to use SXI log items, so log recovery will
+	 * finish the swap and not leave us with partially swapped rt extents
+	 * exposed to userspace.
+	 */
+	if (req->req_flags & XFS_SWAP_REQ_LOGGED)
+		return 0;
+
+	/*
+	 * Allocation units must be fully mapped to a file range.  For files
+	 * with a single-fsblock allocation unit, this is trivial.
+	 */
+	if (!xfs_inode_has_bigallocunit(req->ip2))
+		return 0;
+
+	/*
+	 * For multi-fsblock allocation units, we must check the alignment of
+	 * every single mapping.
+	 */
+	while (blockcount > 0) {
+		/* Read extent from the first file */
+		nimaps = 1;
+		error = xfs_bmapi_read(req->ip1, startoff1, blockcount,
+				&irec1, &nimaps, 0);
+		if (error)
+			return error;
+		ASSERT(nimaps == 1);
+
+		/* Read extent from the second file */
+		nimaps = 1;
+		error = xfs_bmapi_read(req->ip2, startoff2,
+				irec1.br_blockcount, &irec2, &nimaps,
+				0);
+		if (error)
+			return error;
+		ASSERT(nimaps == 1);
+
+		/*
+		 * We can only swap as many blocks as the smaller of the two
+		 * extent maps.
+		 */
+		irec1.br_blockcount = min(irec1.br_blockcount,
+					  irec2.br_blockcount);
+
+		/* Both mappings must be aligned to the realtime extent size. */
+		mod = xfs_rtb_to_rtxoff(mp, irec1.br_startoff);
+		if (mod) {
+			ASSERT(mod == 0);
+			return -EINVAL;
+		}
+
+		mod = xfs_rtb_to_rtxoff(mp, irec1.br_startoff);
+		if (mod) {
+			ASSERT(mod == 0);
+			return -EINVAL;
+		}
+
+		mod = xfs_rtb_to_rtxoff(mp, irec1.br_blockcount);
+		if (mod) {
+			ASSERT(mod == 0);
+			return -EINVAL;
+		}
+
+		startoff1 += irec1.br_blockcount;
+		startoff2 += irec1.br_blockcount;
+		blockcount -= irec1.br_blockcount;
+	}
+
+	return 0;
+}
+#else
+# define xfs_swapext_check_rt_extents(mp, req)		(0)
+#endif
+
 /* Check all extents to make sure we can actually swap them. */
 int
 xfs_swapext_check_extents(
@@ -152,12 +249,7 @@ xfs_swapext_check_extents(
 	    ifp2->if_format == XFS_DINODE_FMT_LOCAL)
 		return -EINVAL;
 
-	/* We don't support realtime data forks yet. */
-	if (!XFS_IS_REALTIME_INODE(req->ip1))
-		return 0;
-	if (req->whichfork == XFS_ATTR_FORK)
-		return 0;
-	return -EINVAL;
+	return xfs_swapext_check_rt_extents(mp, req);
 }
 
 #ifdef CONFIG_XFS_QUOTA
@@ -198,6 +290,8 @@ xfs_swapext_can_skip_mapping(
 	struct xfs_swapext_intent	*sxi,
 	struct xfs_bmbt_irec		*irec)
 {
+	struct xfs_mount		*mp = sxi->sxi_ip1->i_mount;
+
 	/* Do not skip this mapping if the caller did not tell us to. */
 	if (!(sxi->sxi_flags & XFS_SWAP_EXT_INO1_WRITTEN))
 		return false;
@@ -210,10 +304,63 @@ xfs_swapext_can_skip_mapping(
 	 * The mapping is unwritten or a hole.  It cannot be a delalloc
 	 * reservation because we already excluded those.  It cannot be an
 	 * unwritten extent with dirty page cache because we flushed the page
-	 * cache.  We don't support realtime files yet, so we needn't (yet)
-	 * deal with them.
+	 * cache.  For files where the allocation unit is 1FSB (files on the
+	 * data dev, rt files if the extent size is 1FSB), we can safely
+	 * skip this mapping.
 	 */
-	return true;
+	if (!xfs_inode_has_bigallocunit(sxi->sxi_ip1))
+		return true;
+
+	/*
+	 * For a realtime file with a multi-fsb allocation unit, the decision
+	 * is trickier because we can only swap full allocation units.
+	 * Unwritten mappings can appear in the middle of an rtx if the rtx is
+	 * partially written, but they can also appear for preallocations.
+	 *
+	 * If the mapping is a hole, skip it entirely.  Holes should align with
+	 * rtx boundaries.
+	 */
+	if (!xfs_bmap_is_real_extent(irec))
+		return true;
+
+	/*
+	 * All mappings below this point are unwritten.
+	 *
+	 * - If the beginning is not aligned to an rtx, trim the end of the
+	 *   mapping so that it does not cross an rtx boundary, and swap it.
+	 *
+	 * - If both ends are aligned to an rtx, skip the entire mapping.
+	 */
+	if (!isaligned_64(irec->br_startoff, mp->m_sb.sb_rextsize)) {
+		xfs_fileoff_t	new_end;
+
+		new_end = roundup_64(irec->br_startoff, mp->m_sb.sb_rextsize);
+		irec->br_blockcount = min(irec->br_blockcount,
+					  new_end - irec->br_startoff);
+		return false;
+	}
+	if (isaligned_64(irec->br_blockcount, mp->m_sb.sb_rextsize))
+		return true;
+
+	/*
+	 * All mappings below this point are unwritten, start on an rtx
+	 * boundary, and do not end on an rtx boundary.
+	 *
+	 * - If the mapping is longer than one rtx, trim the end of the mapping
+	 *   down to an rtx boundary and skip it.
+	 *
+	 * - The mapping is shorter than one rtx.  Swap it.
+	 */
+	if (irec->br_blockcount > mp->m_sb.sb_rextsize) {
+		xfs_fileoff_t	new_end;
+
+		new_end = rounddown_64(irec->br_startoff + irec->br_blockcount,
+				mp->m_sb.sb_rextsize);
+		irec->br_blockcount = new_end - irec->br_startoff;
+		return true;
+	}
+
+	return false;
 }
 
 /*
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8eab56a62ce24..d1a57164de032 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -684,7 +684,7 @@ xfs_can_free_eofblocks(
 	 * forever.
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
-	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1)
+	if (xfs_inode_has_bigallocunit(ip))
 		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
 	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	if (last_fsb <= end_fsb)
@@ -985,7 +985,7 @@ xfs_free_file_space(
 	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
 
 	/* We can only free complete realtime extents. */
-	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1) {
+	if (xfs_inode_has_bigallocunit(ip)) {
 		startoffset_fsb = xfs_rtb_roundup_rtx(mp, startoffset_fsb);
 		endoffset_fsb = xfs_rtb_rounddown_rtx(mp, endoffset_fsb);
 	}
@@ -1234,3 +1234,184 @@ xfs_insert_file_space(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
+
+#ifdef CONFIG_XFS_RT
+/*
+ * Decide if this is an unwritten extent that isn't aligned to an allocation
+ * unit boundary.
+ *
+ * If it is, shorten the mapping to the end of the allocation unit so that
+ * we're ready to convert all the mappings for this allocation unit to a zeroed
+ * written extent.  If not, return false.
+ */
+static inline bool
+xfs_want_convert_bigalloc_mapping(
+	struct xfs_mount	*mp,
+	struct xfs_bmbt_irec	*irec)
+{
+	xfs_fileoff_t		rext_next;
+	xfs_extlen_t		modoff, modcnt;
+
+	if (irec->br_state != XFS_EXT_UNWRITTEN)
+		return false;
+
+	modoff = xfs_rtb_to_rtxoff(mp, irec->br_startoff);
+	if (modoff == 0) {
+		xfs_rtbxlen_t	rexts;
+
+		rexts = xfs_rtb_to_rtxrem(mp, irec->br_blockcount, &modcnt);
+		if (rexts > 0) {
+			/*
+			 * Unwritten mapping starts at an rt extent boundary
+			 * and is longer than one rt extent.  Round the length
+			 * down to the nearest extent but don't select it for
+			 * conversion.
+			 */
+			irec->br_blockcount -= modcnt;
+			modcnt = 0;
+		}
+
+		/* Unwritten mapping is perfectly aligned, do not convert. */
+		if (modcnt == 0)
+			return false;
+	}
+
+	/*
+	 * Unaligned and unwritten; trim to the current rt extent and select it
+	 * for conversion.
+	 */
+	rext_next = (irec->br_startoff - modoff) + mp->m_sb.sb_rextsize;
+	xfs_trim_extent(irec, irec->br_startoff, rext_next - irec->br_startoff);
+	return true;
+}
+
+/*
+ * Find an unwritten extent in the given file range, zero it, and convert the
+ * mapping to written.  Adjust the scan cursor on the way out.
+ */
+STATIC int
+xfs_convert_bigalloc_mapping(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		*offp,
+	xfs_fileoff_t		endoff)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	unsigned int		resblks;
+	int			nmap;
+	int			error;
+
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 1);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	/*
+	 * Read the mapping.  If we find an unwritten extent that isn't aligned
+	 * to an allocation unit...
+	 */
+retry:
+	nmap = 1;
+	error = xfs_bmapi_read(ip, *offp, endoff - *offp, &irec, &nmap, 0);
+	if (error)
+		goto out_cancel;
+	ASSERT(nmap == 1);
+	ASSERT(irec.br_startoff == *offp);
+	if (!xfs_want_convert_bigalloc_mapping(mp, &irec)) {
+		*offp = irec.br_startoff + irec.br_blockcount;
+		if (*offp >= endoff)
+			goto out_cancel;
+		goto retry;
+	}
+
+	/*
+	 * ...then write zeroes to the space and change the mapping state to
+	 * written.  This consolidates the mappings for this allocation unit.
+	 */
+	nmap = 1;
+	error = xfs_bmapi_write(tp, ip, irec.br_startoff, irec.br_blockcount,
+			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO, 0, &irec, &nmap);
+	if (error)
+		goto out_cancel;
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_unlock;
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	/*
+	 * If an unwritten mapping was returned, something is very wrong.
+	 * If no mapping was returned, then bmapi_write thought it performed
+	 * a short allocation, which should be impossible since we previously
+	 * queried the mapping and haven't cycled locks since then.  Either
+	 * way, fail the operation.
+	 */
+	if (nmap == 0 || irec.br_state != XFS_EXT_NORM) {
+		ASSERT(nmap != 0);
+		ASSERT(irec.br_state == XFS_EXT_NORM);
+		return -EIO;
+	}
+
+	/* Advance the cursor to the end of the mapping returned. */
+	*offp = irec.br_startoff + irec.br_blockcount;
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
+/*
+ * Prepare a file with multi-fsblock allocation units for a remapping.
+ *
+ * File allocation units (AU) must be fully mapped to the data fork.  If the
+ * space in an AU have not been fully written, there can be multiple extent
+ * mappings (e.g. mixed written and unwritten blocks) to the AU.  If the log
+ * does not have a means to ensure that all remappings for a given AU will be
+ * completed even if the fs goes down, we must maintain the above constraint in
+ * another way.
+ *
+ * Convert the unwritten parts of an AU to written by writing zeroes to the
+ * storage and flipping the mapping.  Once this completes, there will be a
+ * single mapping for the entire AU, and we can proceed with the remapping
+ * operation.
+ *
+ * Callers must ensure that there are no dirty pages in the given range.
+ */
+int
+xfs_convert_bigalloc_file_space(
+	struct xfs_inode	*ip,
+	loff_t			pos,
+	uint64_t		len)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		off;
+	xfs_fileoff_t		endoff;
+	int			error;
+
+	if (!xfs_inode_has_bigallocunit(ip))
+		return 0;
+
+	off = xfs_rtb_rounddown_rtx(mp, XFS_B_TO_FSBT(mp, pos));
+	endoff = xfs_rtb_roundup_rtx(mp, XFS_B_TO_FSB(mp, pos + len));
+
+	trace_xfs_convert_bigalloc_file_space(ip, pos, len);
+
+	while (off < endoff) {
+		if (fatal_signal_pending(current))
+			return -EINTR;
+
+		error = xfs_convert_bigalloc_mapping(ip, &off, endoff);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+#endif /* CONFIG_XFS_RT */
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 8eb7166aa9d41..231c4f1629c66 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -76,4 +76,11 @@ int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_flush_unmap_range(struct xfs_inode *ip, xfs_off_t offset,
 			      xfs_off_t len);
 
+#ifdef CONFIG_XFS_RT
+int xfs_convert_bigalloc_file_space(struct xfs_inode *ip, loff_t pos,
+		uint64_t len);
+#else
+# define xfs_convert_bigalloc_file_space(ip, pos, len)	(-EOPNOTSUPP)
+#endif
+
 #endif	/* __XFS_BMAP_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e1d60ba75bbdd..77acc3177ecea 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -311,6 +311,11 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
 }
 
+static inline bool xfs_inode_has_bigallocunit(struct xfs_inode *ip)
+{
+	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 47c30d8093289..91ec676fcf8ed 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1494,7 +1494,7 @@ DEFINE_IMAP_EVENT(xfs_iomap_alloc);
 DEFINE_IMAP_EVENT(xfs_iomap_found);
 
 DECLARE_EVENT_CLASS(xfs_simple_io_class,
-	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, u64 count),
 	TP_ARGS(ip, offset, count),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -1502,7 +1502,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 		__field(loff_t, isize)
 		__field(loff_t, disize)
 		__field(loff_t, offset)
-		__field(size_t, count)
+		__field(u64, count)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
@@ -1513,7 +1513,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 		__entry->count = count;
 	),
 	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx disize 0x%llx "
-		  "pos 0x%llx bytecount 0x%zx",
+		  "pos 0x%llx bytecount 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->isize,
@@ -1524,7 +1524,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 
 #define DEFINE_SIMPLE_IO_EVENT(name)	\
 DEFINE_EVENT(xfs_simple_io_class, name,	\
-	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),	\
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, u64 count),	\
 	TP_ARGS(ip, offset, count))
 DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc);
 DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
@@ -3728,6 +3728,9 @@ TRACE_EVENT(xfs_ioctl_clone,
 /* unshare tracepoints */
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_unshare);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
+#ifdef CONFIG_XFS_RT
+DEFINE_SIMPLE_IO_EVENT(xfs_convert_bigalloc_file_space);
+#endif /* CONFIG_XFS_RT */
 
 /* copy on write */
 DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_around_shared);
diff --git a/fs/xfs/xfs_xchgrange.c b/fs/xfs/xfs_xchgrange.c
index c3476e68d6410..fd09a2dfca9b9 100644
--- a/fs/xfs/xfs_xchgrange.c
+++ b/fs/xfs/xfs_xchgrange.c
@@ -27,6 +27,8 @@
 #include "xfs_sb.h"
 #include "xfs_icache.h"
 #include "xfs_log.h"
+#include "xfs_bmap_util.h"
+#include "xfs_rtbitmap.h"
 #include <linux/fsnotify.h>
 
 /*
@@ -403,7 +405,7 @@ xfs_file_xchg_range(
 		priv_flags |= XFS_XCHG_RANGE_LOGGED;
 
 	/* Prepare and then exchange file contents. */
-	error = xfs_xchg_range_prep(file1, file2, fxr);
+	error = xfs_xchg_range_prep(file1, file2, fxr, priv_flags);
 	if (error)
 		goto out_drop_feat;
 
@@ -773,12 +775,46 @@ xfs_swap_extent_forks(
 	return 0;
 }
 
+/*
+ * Do we need to convert partially written extents before a swap?
+ *
+ * There may be partially written rt extents lurking in the ranges to be
+ * swapped.  According to the rules for realtime files with big rt extents, we
+ * must guarantee that a userspace observer (an IO thread, realistically) never
+ * sees multiple physical rt extents mapped to the same logical file rt extent.
+ */
+static bool
+xfs_xchg_range_need_convert_bigalloc(
+	struct xfs_inode		*ip,
+	unsigned int			xchg_flags)
+{
+	/*
+	 * Extent swap log intent (SXI) items take care of this by ensuring
+	 * that we always complete the entire swap operation.  If the caller
+	 * obtained permission to use these log items, no conversion work is
+	 * needed.
+	 */
+	if (xchg_flags & XFS_XCHG_RANGE_LOGGED)
+		return false;
+
+	/*
+	 * If the caller did not get SXI permission but the filesystem is new
+	 * enough to use BUI log items and big rt extents are in play, the only
+	 * way to prevent userspace from seeing partially mapped big rt extents
+	 * in case of a crash midway through remapping a big rt extent is to
+	 * convert all the partially written rt extents before the swap.
+	 */
+	return xfs_swapext_supports_nonatomic(ip->i_mount) &&
+	       xfs_inode_has_bigallocunit(ip);
+}
+
 /* Prepare two files to have their data exchanged. */
 int
 xfs_xchg_range_prep(
 	struct file		*file1,
 	struct file		*file2,
-	struct xfs_exch_range	*fxr)
+	struct xfs_exch_range	*fxr,
+	unsigned int		xchg_flags)
 {
 	struct xfs_inode	*ip1 = XFS_I(file_inode(file1));
 	struct xfs_inode	*ip2 = XFS_I(file_inode(file2));
@@ -842,6 +878,19 @@ xfs_xchg_range_prep(
 			return error;
 	}
 
+	/* Convert unwritten sub-extent mappings if required. */
+	if (xfs_xchg_range_need_convert_bigalloc(ip2, xchg_flags)) {
+		error = xfs_convert_bigalloc_file_space(ip2, fxr->file2_offset,
+				fxr->length);
+		if (error)
+			return error;
+
+		error = xfs_convert_bigalloc_file_space(ip1, fxr->file1_offset,
+				fxr->length);
+		if (error)
+			return error;
+	}
+
 	return 0;
 }
 
@@ -1103,6 +1152,14 @@ xfs_xchg_range(
 	if (xchg_flags & XFS_XCHG_RANGE_LOGGED)
 		req.req_flags |= XFS_SWAP_REQ_LOGGED;
 
+	/*
+	 * Round the request length up to the nearest file allocation unit.
+	 * The prep function already checked that the request offsets and
+	 * length in @fxr are safe to round up.
+	 */
+	if (xfs_inode_has_bigallocunit(ip2))
+		req.blockcount = xfs_rtb_roundup_rtx(mp, req.blockcount);
+
 	error = xfs_xchg_range_estimate(&req);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_xchgrange.h b/fs/xfs/xfs_xchgrange.h
index 3471182d1402f..5ca902b11c2e9 100644
--- a/fs/xfs/xfs_xchgrange.h
+++ b/fs/xfs/xfs_xchgrange.h
@@ -51,6 +51,6 @@ void xfs_xchg_range_rele_log_assist(struct xfs_mount *mp);
 int xfs_xchg_range(struct xfs_inode *ip1, struct xfs_inode *ip2,
 		const struct xfs_exch_range *fxr, unsigned int xchg_flags);
 int xfs_xchg_range_prep(struct file *file1, struct file *file2,
-		struct xfs_exch_range *fxr);
+		struct xfs_exch_range *fxr, unsigned int xchg_flags);
 
 #endif /* __XFS_XCHGRANGE_H__ */

