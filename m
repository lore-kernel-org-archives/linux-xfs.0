Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD687ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6t5D7aY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3F9C433C8;
	Mon,  1 Jan 2024 00:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069614;
	bh=bAzPVhvBi/HYhV/uSt+3+w675yPt1hbABxTLtUXLH3w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j6t5D7aYtBSrGdEtx1A6oYV4db7Pf2SG6Wu2jEy8+wsfZiGQg+Kb8U3ReWN1lYY3c
	 fGnIUuZexqRX6ikRA36ORXNGbdN1O9ZrjirUZrlZP5pLak53LOQZxaHP/ZgClZ8oyW
	 4YLeDzoLTgc1xgPn2gDJEWS68Ko+VSqSP5tzEatbQ6L8+anlogh3J4ngJtaCgpumMa
	 7pSsI1ROkYvX/axcgEdLBr7W6ulkGDH/1+jdHrCeTjmGt/f1sYx5QZyUE95mfJq8Wu
	 ObSQuZWJ6t5MEcymG3RXt9EMOxumQJmebbEW1oqWl1yb3ckSp+ecsa+ZN8moCfQEmh
	 u4123N+wKM9bQ==
Date: Sun, 31 Dec 2023 16:40:14 +9900
Subject: [PATCH 01/10] xfs: add an ioctl to map free space into a file
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405020337.1820796.14472849118957827138.stgit@frogsfrogsfrogs>
In-Reply-To: <170405020316.1820796.451112156000559887.stgit@frogsfrogsfrogs>
References: <170405020316.1820796.451112156000559887.stgit@frogsfrogsfrogs>
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

Add a new ioctl to map free physical space into a file, at the same file
offset as if the file were a sparse image of the physical device backing
the filesystem.  The intent here is to use this to prototype a free
space defragmentation tool.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h             |    4 +
 libxfs/libxfs_priv.h            |   10 +++
 libxfs/xfs_alloc.c              |   88 +++++++++++++++++++++++
 libxfs/xfs_alloc.h              |    3 +
 libxfs/xfs_bmap.c               |  149 +++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_bmap.h               |    3 +
 libxfs/xfs_fs.h                 |    1 
 libxfs/xfs_fs_staging.h         |   15 ++++
 man/man2/ioctl_xfs_map_freesp.2 |   76 ++++++++++++++++++++
 9 files changed, 349 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_map_freesp.2


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index c8368227705..328f276d498 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -26,6 +26,8 @@
 #define trace_xfs_alloc_exact_done(a)		((void) 0)
 #define trace_xfs_alloc_exact_notfound(a)	((void) 0)
 #define trace_xfs_alloc_exact_error(a)		((void) 0)
+#define trace_xfs_alloc_find_freesp(...)	((void) 0)
+#define trace_xfs_alloc_find_freesp_done(...)	((void) 0)
 #define trace_xfs_alloc_near_first(a)		((void) 0)
 #define trace_xfs_alloc_near_greater(a)		((void) 0)
 #define trace_xfs_alloc_near_lesser(a)		((void) 0)
@@ -196,6 +198,8 @@
 
 #define trace_xfs_bmap_pre_update(a,b,c,d)	((void) 0)
 #define trace_xfs_bmap_post_update(a,b,c,d)	((void) 0)
+#define trace_xfs_bmapi_freesp(...)		((void) 0)
+#define trace_xfs_bmapi_freesp_done(...)	((void) 0)
 #define trace_xfs_bunmap(a,b,c,d,e)		((void) 0)
 #define trace_xfs_read_extent(a,b,c,d)		((void) 0)
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index bbe7dd63443..bc8f66aa986 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -501,6 +501,16 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_filestream_new_ag(ip,ag)		(0)
 #define xfs_filestream_select_ag(...)		(-ENOSYS)
 
+struct xfs_trans;
+
+static inline int
+xfs_rtallocate_extent(struct xfs_trans *tp, xfs_rtblock_t bno,
+		xfs_extlen_t minlen, xfs_extlen_t maxlen, xfs_extlen_t *len,
+		int wasdel, xfs_extlen_t prod, xfs_rtblock_t *rtblock)
+{
+	return -EOPNOTSUPP;
+}
+
 #define xfs_trans_inode_buf(tp, bp)		((void) 0)
 
 /* quota bits */
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 589e9ef3003..50626d79c3f 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -4092,3 +4092,91 @@ xfs_extfree_intent_destroy_cache(void)
 	kmem_cache_destroy(xfs_extfree_item_cache);
 	xfs_extfree_item_cache = NULL;
 }
+
+/*
+ * Find the next chunk of free space in @pag starting at @agbno and going no
+ * higher than @end_agbno.  Set @agbno and @len to whatever free space we find,
+ * or to @end_agbno if we find no space.
+ */
+int
+xfs_alloc_find_freesp(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	xfs_agblock_t		*agbno,
+	xfs_agblock_t		end_agbno,
+	xfs_extlen_t		*len)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_btree_cur	*cur;
+	struct xfs_buf		*agf_bp = NULL;
+	xfs_agblock_t		found_agbno;
+	xfs_extlen_t		found_len;
+	int			found;
+	int			error;
+
+	trace_xfs_alloc_find_freesp(mp, pag->pag_agno, *agbno,
+			end_agbno - *agbno);
+
+	error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
+	if (error)
+		return error;
+
+	cur = xfs_allocbt_init_cursor(mp, tp, agf_bp, pag, XFS_BTNUM_BNO);
+
+	/* Try to find a free extent that starts before here. */
+	error = xfs_alloc_lookup_le(cur, *agbno, 0, &found);
+	if (error)
+		goto out_cur;
+	if (found) {
+		error = xfs_alloc_get_rec(cur, &found_agbno, &found_len,
+				&found);
+		if (error)
+			goto out_cur;
+		if (XFS_IS_CORRUPT(mp, !found)) {
+			xfs_btree_mark_sick(cur);
+			error = -EFSCORRUPTED;
+			goto out_cur;
+		}
+
+		if (found_agbno + found_len > *agbno)
+			goto found;
+	}
+
+	/* Examine the next record if free extent not in range. */
+	error = xfs_btree_increment(cur, 0, &found);
+	if (error)
+		goto out_cur;
+	if (!found)
+		goto next_ag;
+
+	error = xfs_alloc_get_rec(cur, &found_agbno, &found_len, &found);
+	if (error)
+		goto out_cur;
+	if (XFS_IS_CORRUPT(mp, !found)) {
+		xfs_btree_mark_sick(cur);
+		error = -EFSCORRUPTED;
+		goto out_cur;
+	}
+
+	if (found_agbno >= end_agbno)
+		goto next_ag;
+
+found:
+	/* Found something, so update the mapping. */
+	trace_xfs_alloc_find_freesp_done(mp, pag->pag_agno, found_agbno,
+			found_len);
+	if (found_agbno < *agbno) {
+		found_len -= *agbno - found_agbno;
+		found_agbno = *agbno;
+	}
+	*len = found_len;
+	*agbno = found_agbno;
+	goto out_cur;
+next_ag:
+	/* Found nothing, so advance the cursor beyond the end of the range. */
+	*agbno = end_agbno;
+	*len = 0;
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 130026e981e..fedb6dc0443 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -290,5 +290,8 @@ void xfs_extfree_intent_destroy_cache(void);
 
 xfs_failaddr_t xfs_validate_ag_length(struct xfs_buf *bp, uint32_t seqno,
 		uint32_t length);
+int xfs_alloc_find_freesp(struct xfs_trans *tp, struct xfs_perag *pag,
+		xfs_agblock_t *agbno, xfs_agblock_t end_agbno,
+		xfs_extlen_t *len);
 
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 13bcf146d08..94640a5077c 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6436,3 +6436,152 @@ xfs_get_cowextsz_hint(
 		return XFS_DEFAULT_COWEXTSZ_HINT;
 	return a;
 }
+
+static inline xfs_fileoff_t
+xfs_fsblock_to_fileoff(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsbno)
+{
+	xfs_daddr_t		daddr = XFS_FSB_TO_DADDR(mp, fsbno);
+
+	return XFS_B_TO_FSB(mp, BBTOB(daddr));
+}
+
+/*
+ * Given a file and a free physical extent, map it into the file at the same
+ * offset if the file were a sparse image of the physical device.  Set @mval to
+ * whatever mapping we added to the file.
+ */
+int
+xfs_bmapi_freesp(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_fsblock_t		fsbno,
+	xfs_extlen_t		len,
+	struct xfs_bmbt_irec	*mval)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		startoff;
+	bool			isrt = XFS_IS_REALTIME_INODE(ip);
+	int			nimaps;
+	int			error;
+
+	trace_xfs_bmapi_freesp(ip, fsbno, len);
+
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error)
+		return error;
+
+	if (isrt)
+		startoff = fsbno;
+	else
+		startoff = xfs_fsblock_to_fileoff(mp, fsbno);
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
+	/*
+	 * Allocate the physical extent.  We should not have dropped the lock
+	 * since the scan of the free space metadata, so this should work,
+	 * though the length may be adjusted to play nicely with metadata space
+	 * reservations.
+	 */
+	if (isrt) {
+		xfs_rtxnum_t	rtx_in, rtx_out;
+		xfs_extlen_t	rtxlen_in, rtxlen_out;
+		uint32_t	mod;
+
+		rtx_in = xfs_rtb_to_rtxrem(mp, fsbno, &mod);
+		if (mod) {
+			ASSERT(mod == 0);
+			return -EFSCORRUPTED;
+		}
+
+		rtxlen_in = xfs_rtb_to_rtxrem(mp, len, &mod);
+		if (mod) {
+			ASSERT(mod == 0);
+			return -EFSCORRUPTED;
+		}
+
+		error = xfs_rtallocate_extent(tp, rtx_in, 1, rtxlen_in,
+				&rtxlen_out, 0, 1, &rtx_out);
+		if (error)
+			return error;
+		if (rtx_out == NULLRTEXTNO) {
+			/*
+			 * We were promised the space!  In theory there aren't
+			 * any reserve lists that would prevent us from getting
+			 * the space.
+			 */
+			return -ENOSPC;
+		}
+		if (rtx_out != rtx_in) {
+			ASSERT(0);
+			xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
+			return -EFSCORRUPTED;
+		}
+		mval->br_blockcount = rtxlen_out * mp->m_sb.sb_rextsize;
+	} else {
+		struct xfs_alloc_arg	args = {
+			.mp		= mp,
+			.tp		= tp,
+			.oinfo		= XFS_RMAP_OINFO_SKIP_UPDATE,
+			.resv		= XFS_AG_RESV_NONE,
+			.prod		= 1,
+			.datatype	= XFS_ALLOC_USERDATA,
+			.maxlen		= len,
+			.minlen		= 1,
+		};
+		args.pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, fsbno));
+		error = xfs_alloc_vextent_exact_bno(&args, fsbno);
+		xfs_perag_put(args.pag);
+		if (error)
+			return error;
+		if (args.fsbno == NULLFSBLOCK) {
+			/*
+			 * We were promised the space, but failed to get it.
+			 * This could be because the space is reserved for
+			 * metadata expansion, or it could be because the AGFL
+			 * fixup grabbed the first block we wanted.  Either
+			 * way, if the transaction is dirty we must commit it
+			 * and tell the caller to try again.
+			 */
+			if (tp->t_flags & XFS_TRANS_DIRTY)
+				return -EAGAIN;
+			return -ENOSPC;
+		}
+		if (args.fsbno != fsbno) {
+			ASSERT(0);
+			xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
+			return -EFSCORRUPTED;
+		}
+		mval->br_blockcount = args.len;
+	}
+
+	/* Map extent into file, update quota. */
+	mval->br_startblock = fsbno;
+	mval->br_startoff = startoff;
+	mval->br_state = XFS_EXT_UNWRITTEN;
+
+	trace_xfs_bmapi_freesp_done(ip, mval);
+
+	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, mval);
+	if (isrt)
+		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_RTBCOUNT,
+				mval->br_blockcount);
+	else
+		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
+				mval->br_blockcount);
+
+	return 0;
+}
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 61c195198db..afb54a517f1 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -197,6 +197,9 @@ int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
 		xfs_extlen_t total, struct xfs_bmbt_irec *mval, int *nmap);
+int	xfs_bmapi_freesp(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fsblock_t fsbno, xfs_extlen_t len,
+		struct xfs_bmbt_irec *mval);
 int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
 		xfs_extnum_t nexts, int *done);
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 96688f9301e..922e9acfdc3 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -864,6 +864,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
 /*	XFS_IOC_GETPARENTS ---- staging 62         */
 /*	XFS_IOC_RTGROUP_GEOMETRY - staging 63	   */
+/*	XFS_IOC_MAP_FREESP ---- staging 64	   */
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/libxfs/xfs_fs_staging.h b/libxfs/xfs_fs_staging.h
index f7d872f8a88..2a9effb7a84 100644
--- a/libxfs/xfs_fs_staging.h
+++ b/libxfs/xfs_fs_staging.h
@@ -303,4 +303,19 @@ xfs_getfsrefs_advance(
 /* XXX stealing XFS_IOC_GETBIOSIZE */
 #define XFS_IOC_GETFSREFCOUNTS		_IOWR('X', 47, struct xfs_getfsrefs_head)
 
+/* map free space to file */
+
+struct xfs_map_freesp {
+	__s64	offset;		/* disk address to map, in bytes */
+	__s64	len;		/* length in bytes */
+	__u64	flags;		/* must be zero */
+	__u64	pad;		/* must be zero */
+};
+
+/*
+ * XFS_IOC_MAP_FREESP maps all the free physical space in the filesystem into
+ * the file at the same offsets.  This ioctl requires CAP_SYS_ADMIN.
+ */
+#define XFS_IOC_MAP_FREESP	_IOWR('X', 64, struct xfs_map_freesp)
+
 #endif /* __XFS_FS_STAGING_H__ */
diff --git a/man/man2/ioctl_xfs_map_freesp.2 b/man/man2/ioctl_xfs_map_freesp.2
new file mode 100644
index 00000000000..ca1d9882437
--- /dev/null
+++ b/man/man2/ioctl_xfs_map_freesp.2
@@ -0,0 +1,76 @@
+.\" Copyright (c) 2023-2024 Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0-or-later
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-MAP-FREESP 2 2023-11-17 "XFS"
+.SH NAME
+ioctl_xfs_map_freesp \- map free space into a file
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs_staging.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_MAP_FREESP, struct xfs_map_freesp *" arg );
+.SH DESCRIPTION
+Maps free space into the sparse ranges of a regular file.
+This ioctl uses
+.B struct xfs_map_freesp
+to specify the range of free space to be mapped:
+.PP
+.in +4n
+.nf
+struct xfs_map_freesp {
+	__s64   offset;
+	__s64   len;
+	__s64   flags;
+	__s64   pad;
+};
+.fi
+.in
+.PP
+.I offset
+is the physical disk address, in bytes, of the start of the range to scan.
+Each free space extent in this range will be mapped to the file if the
+corresponding range of the file is sparse.
+.PP
+.I len
+is the number of bytes in the range to scan.
+.PP
+.I flags
+must be zero; there are no flags defined yet.
+.PP
+.I pad
+must be zero.
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EFAULT
+The kernel was not able to copy into the userspace buffer.
+.TP
+.B EFSBADCRC
+Metadata checksum validation failed while performing the query.
+.TP
+.B EFSCORRUPTED
+Metadata corruption was encountered while performing the query.
+.TP
+.B EINVAL
+One of the arguments was not valid,
+or the file was not sparse.
+.TP
+.B EIO
+An I/O error was encountered while performing the query.
+.TP
+.B ENOMEM
+There was insufficient memory to perform the query.
+.TP
+.B ENOSPC
+There was insufficient disk space to commit the space mappings.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2)

