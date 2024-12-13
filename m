Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA37DDDC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052935; cv=none; b=Y6qeR+89P1Vusi2uNfWNIlKCyQUOKhOTEkNC+ODCesZlamxjsDMugILGuiNfciz4e2ArDV7y5YNU16Buin2sMrCgV+/qp/c5q7wyfufTd8OXQhoPyGo9AJb6+ztCnjeKuyfmuARy7ethurfj+8XEzAp6OgbQlGRHosk8mbezew0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052935; c=relaxed/simple;
	bh=tYFRfTaYWFLF1LBGiqPXSf7STfiVxXYUre03GvvLNHc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uCYkpUa3tEjLjzN8fHpbDmNNBRm11EWXrXXHTKtbWGh6buFVNSMsbTV1o3Va+RutGHRXHizCMVe/1WQRHsJviVS6FNOLTWRLWeoRYXPnA1MSgffHC7dhwiqKHm4vl7lDJ1poyQ8DTh9zFvWJDDp7xpXb+wvCrMeYkX0GUzI7a9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2V4nviK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2V4nviK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208B3C4CECE;
	Fri, 13 Dec 2024 01:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052935;
	bh=tYFRfTaYWFLF1LBGiqPXSf7STfiVxXYUre03GvvLNHc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U2V4nviKKBwElknWBg8hAtlK4qFhC5NFTXptWIoVuSsQJJhMphfFBNjkrUWBqyZJn
	 sxV41w0v3GXSA6ePN0E49bQKuIVKenAQQ4lDRgmPRBKNHbnIwVJnKtN6G3dvCAONWC
	 F7A+3K2Z56nI2BKOgMIu6xhx4D4Z8BQys7balJ36mh+YqjnrWRrjsSbOUYnlhO/8Ue
	 HgaYce9uhx1chAcZNc0Cj50w5bPN/jcAxIC4Dg4A6i1IbqQmd4MT2VXqhIXjjkbfyO
	 0dmM2V6bQO3qLppp02kpg87yGgr06SqBy7huqcEv20r+G4GfiSYJrMMdmOv/PAIX8l
	 vxJZtwbYeIeuA==
Date: Thu, 12 Dec 2024 17:22:14 -0800
Subject: [PATCH 03/11] xfs: convert partially written rt file extents to
 completely written
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125794.1184063.17925337081966040081.stgit@frogsfrogsfrogs>
In-Reply-To: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
References: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a utility function to convert the partially written extents of a
realtime file to be completely written.  In other words, if rextsize==7
and only block 6 is unwritten, these functions will zero out block 6 and
convert the mapping to written so that the entire 7-block allocation
unit can be remapped in a single operation.  This is required for any
rt file remapping activities that do not use log items to restart
interrupted operations.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.h |   12 +++
 fs/xfs/xfs_bmap_util.c       |  182 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h       |    7 ++
 fs/xfs/xfs_trace.h           |   11 ++-
 4 files changed, 208 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 22e5d9cd95f47c..89eb1e42128b38 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -157,6 +157,18 @@ xfs_rtb_to_rtxoff(
 	return do_div(rtbno, mp->m_sb.sb_rextsize);
 }
 
+/* Return the offset of a file block offset within an rt extent. */
+static inline xfs_extlen_t
+xfs_fileoff_to_rtxoff(
+	struct xfs_mount	*mp,
+	xfs_fileoff_t		off)
+{
+	if (likely(mp->m_rtxblklog >= 0))
+		return off & mp->m_rtxblkmask;
+
+	return do_div(off, mp->m_sb.sb_rextsize);
+}
+
 /* Round this file block offset up to the nearest rt extent size. */
 static inline xfs_rtblock_t
 xfs_fileoff_roundup_rtx(
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0836fea2d6d814..3229b756f33780 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1726,3 +1726,185 @@ xfs_swap_extents(
 	xfs_trans_cancel(tp);
 	goto out_unlock_ilock;
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
+xfs_want_convert_rtbigalloc_mapping(
+	struct xfs_mount	*mp,
+	struct xfs_bmbt_irec	*irec)
+{
+	xfs_fileoff_t		rext_next;
+	xfs_extlen_t		modoff, modcnt;
+
+	if (irec->br_state != XFS_EXT_UNWRITTEN)
+		return false;
+
+	modoff = xfs_fileoff_to_rtxoff(mp, irec->br_startoff);
+	if (modoff == 0) {
+		xfs_rtbxlen_t	rexts;
+
+		rexts = xfs_blen_to_rtbxlen(mp, irec->br_blockcount);
+		modcnt = xfs_blen_to_rtxoff(mp, irec->br_blockcount);
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
+xfs_convert_rtbigalloc_mapping(
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
+	if (!xfs_want_convert_rtbigalloc_mapping(mp, &irec)) {
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
+xfs_convert_rtbigalloc_file_space(
+	struct xfs_inode	*ip,
+	loff_t			pos,
+	uint64_t		len)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		off;
+	xfs_fileoff_t		endoff;
+	int			error;
+
+	if (!xfs_inode_has_bigrtalloc(ip))
+		return 0;
+
+	off = xfs_fileoff_rounddown_rtx(mp, XFS_B_TO_FSBT(mp, pos));
+	endoff = xfs_fileoff_roundup_rtx(mp, XFS_B_TO_FSB(mp, pos + len));
+
+	trace_xfs_convert_rtbigalloc_file_space(ip, pos, len);
+
+	while (off < endoff) {
+		if (fatal_signal_pending(current))
+			return -EINTR;
+
+		error = xfs_convert_rtbigalloc_mapping(ip, &off, endoff);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+#endif /* CONFIG_XFS_RT */
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index b29760d36e1ab1..3834962670449f 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -79,4 +79,11 @@ int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_flush_unmap_range(struct xfs_inode *ip, xfs_off_t offset,
 			      xfs_off_t len);
 
+#ifdef CONFIG_XFS_RT
+int xfs_convert_rtbigalloc_file_space(struct xfs_inode *ip, loff_t pos,
+		uint64_t len);
+#else
+# define xfs_convert_rtbigalloc_file_space(ip, pos, len)	(-EOPNOTSUPP)
+#endif
+
 #endif	/* __XFS_BMAP_UTIL_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4fe689410eb6ae..8af9c38bea152f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1555,7 +1555,7 @@ DEFINE_IMAP_EVENT(xfs_iomap_alloc);
 DEFINE_IMAP_EVENT(xfs_iomap_found);
 
 DECLARE_EVENT_CLASS(xfs_simple_io_class,
-	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, u64 count),
 	TP_ARGS(ip, offset, count),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -1563,7 +1563,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 		__field(loff_t, isize)
 		__field(loff_t, disize)
 		__field(loff_t, offset)
-		__field(size_t, count)
+		__field(u64, count)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
@@ -1574,7 +1574,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 		__entry->count = count;
 	),
 	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx disize 0x%llx "
-		  "pos 0x%llx bytecount 0x%zx",
+		  "pos 0x%llx bytecount 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->isize,
@@ -1585,7 +1585,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 
 #define DEFINE_SIMPLE_IO_EVENT(name)	\
 DEFINE_EVENT(xfs_simple_io_class, name,	\
-	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),	\
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, u64 count),	\
 	TP_ARGS(ip, offset, count))
 DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc);
 DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
@@ -3971,6 +3971,9 @@ TRACE_EVENT(xfs_ioctl_clone,
 /* unshare tracepoints */
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_unshare);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
+#ifdef CONFIG_XFS_RT
+DEFINE_SIMPLE_IO_EVENT(xfs_convert_rtbigalloc_file_space);
+#endif /* CONFIG_XFS_RT */
 
 /* copy on write */
 DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_around_shared);

