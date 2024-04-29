Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DCCD28D
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 04:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714366182; cv=none; b=MUoY8VPWpo3s6eLKxGmwWo6i01nq1rSYyA5YyQPKvSrmSFVHFC5pCwb/eTBsn9DzKVxLk2SrtQmQcZnf6kx6LCr/chwen67B59sjTde61bCMp8DeMFNdwKTwmx0238aSqvtiPxWOqnAl1aiFy4ay5aqWuW0Y7OJPSs7X4Vhbxf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714366182; c=relaxed/simple;
	bh=f/aDShJ4RfjDQeyCaMlJQHoA5dgZUg85hXaTF+/om/k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=On68FyL5MJ5DER7zkD99T1Y4U7itb8eRNvz6x91dGmno5KYNbzO6N2WafLnl5rj1erwGQ5qaNQQR+7Nq0TjH3rrWGXxTNSCaf2M5vbap7uNhG8T6D+DNcqou4VZclWweErf87cRZDEZCSuHeBd6wU2GKJovEJYq/ciX4b4cYDKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C/zjNTYJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C/zjNTYJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oRJMxDwQJjMLMfL7zqflS9KyLDDWex73oKIF33Jnt0k=; b=C/zjNTYJ9nR0IbzgyLVNlqaPXA
	ujqgJgqnfLm/MR1SAgOXfRSf2thzM2nTXFER/WjwJblqeLi1ypows+WXJCkW7or3ANqvVeqhxGpww
	Q75LQDUavbQlub50LIf/FhG0Knn4LOmmCerpws2/HO7KdzAUHP+fFT1zGkVbOrC6UrCwCZfV1EK1p
	mr1AdmXAZv5UpocMAFo3Ghb3jLTj9Spgwe07gTzVwTvvX3rjflusY3pOQNTUCvanpfKyis+HIQ1PH
	SdbF3oXQ3FMNQMqWeylXr72VWIv5/0qU9g8UEvBx7w6TazD6eIK7Lm7IbcZWhG3x5dzJWt5dzRSE+
	YsOmnwrw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1IxQ-00000001S8X-2e2a;
	Mon, 29 Apr 2024 04:49:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 7/8] xfs: optimize extent remapping in xfs_reflink_end_cow_extent
Date: Mon, 29 Apr 2024 06:49:16 +0200
Message-Id: <20240429044917.1504566-8-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429044917.1504566-1-hch@lst.de>
References: <20240429044917.1504566-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_reflink_end_cow_extent currently caps the range it works on to
fit both the existing extent (or hole) in the data fork and the
new COW range.  For overwrites of fragmented regions that is highly
inefficient, as we need to split the new region at every boundary,
just for it to be merge back in the next pass.

Switch to unmapping the old data using a chain of deferred bmap
and extent free ops ops first, and then handle remapping the new
data in one single transaction instead.

Note that this also switches from a write to an itruncate transaction
reservation as the xfs_reflink_end_cow_extent doesn't touch any of
the allocator data structures in the AGF or the RT inodes.  Instead
the lead transaction just unmaps blocks, and later they get freed,
COW records get freed and the new blocks get mapped into the inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 111 ++++++++++++++++++++++++++++---------------
 1 file changed, 72 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index af388f2caef304..e20db39d1cc46f 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -701,6 +701,72 @@ xfs_reflink_cancel_cow_range(
 	return error;
 }
 
+/*
+ * Unmap any old data covering the COW target.
+ */
+static int
+xfs_reflink_unmap_old_data(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		offset_fsb,
+	xfs_fileoff_t		end_fsb)
+{
+	struct xfs_ifork	*ifp = &ip->i_df;
+	struct xfs_bmbt_irec	got, del;
+	struct xfs_iext_cursor	icur;
+	unsigned int		freed;
+	int			error;
+
+	ASSERT(!xfs_need_iread_extents(ifp));
+
+restart:
+	freed = 0;
+	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
+		return 0;
+
+	while (got.br_startoff + got.br_blockcount > offset_fsb) {
+		del = got;
+		xfs_trim_extent(&del, offset_fsb, end_fsb - offset_fsb);
+
+		/* Extent delete may have bumped us forward */
+		if (!del.br_blockcount)
+			goto prev_extent;
+
+		trace_xfs_reflink_cow_remap_to(ip, &del);
+		if (isnullstartblock(del.br_startblock)) {
+			xfs_bmap_del_extent_delay(ip, XFS_DATA_FORK, &icur,
+					&got, &del);
+			goto refresh;
+		}
+
+		xfs_bmap_unmap_extent(*tpp, ip, XFS_DATA_FORK, &del);
+		xfs_refcount_decrease_extent(*tpp, &del);
+		xfs_trans_mod_dquot_byino(*tpp, ip, XFS_TRANS_DQ_BCOUNT,
+				-del.br_blockcount);
+
+		/*
+		 * We can't add an unlimited number of EFIs and thus deferred
+		 * unmapped items to a transaction.  Once we've filled our
+		 * quota roll the transaction, which requires us to restart
+		 * the lookup as the deferred item processing will change the
+		 * iext tree.
+		 */
+		if (++freed == XFS_MAX_ITRUNCATE_EFIS) {
+			error = xfs_defer_finish(tpp);
+			if (error)
+				return error;
+			goto restart;
+		}
+prev_extent:
+		xfs_iext_prev(ifp, &icur);
+refresh:
+		if (!xfs_iext_get_extent(ifp, &icur, &got))
+			break;
+	}
+
+	return 0;
+}
+
 /*
  * Remap part of the CoW fork into the data fork.
  *
@@ -718,16 +784,15 @@ xfs_reflink_end_cow_extent(
 	xfs_fileoff_t		end_fsb)
 {
 	struct xfs_iext_cursor	icur;
-	struct xfs_bmbt_irec	got, del, data;
+	struct xfs_bmbt_irec	got, del;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
 	unsigned int		resblks;
-	int			nmaps;
 	int			error;
 
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks, 0,
 			XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
@@ -767,51 +832,19 @@ xfs_reflink_end_cow_extent(
 	}
 	del = got;
 	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
+	trace_xfs_reflink_cow_remap_from(ip, &del);
 
 	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_REFLINK_END_COW_CNT);
 	if (error)
 		goto out_cancel;
 
-	/* Grab the corresponding mapping in the data fork. */
-	nmaps = 1;
-	error = xfs_bmapi_read(ip, del.br_startoff, del.br_blockcount, &data,
-			&nmaps, 0);
+	/* Unmap the old data. */
+	error = xfs_reflink_unmap_old_data(&tp, ip, del.br_startoff,
+			del.br_startoff + del.br_blockcount);
 	if (error)
 		goto out_cancel;
 
-	/* We can only remap the smaller of the two extent sizes. */
-	data.br_blockcount = min(data.br_blockcount, del.br_blockcount);
-	del.br_blockcount = data.br_blockcount;
-
-	trace_xfs_reflink_cow_remap_from(ip, &del);
-	trace_xfs_reflink_cow_remap_to(ip, &data);
-
-	if (xfs_bmap_is_real_extent(&data)) {
-		/*
-		 * If the extent we're remapping is backed by storage (written
-		 * or not), unmap the extent and drop its refcount.
-		 */
-		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &data);
-		xfs_refcount_decrease_extent(tp, &data);
-		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
-				-data.br_blockcount);
-	} else if (data.br_startblock == DELAYSTARTBLOCK) {
-		int		done;
-
-		/*
-		 * If the extent we're remapping is a delalloc reservation,
-		 * we can use the regular bunmapi function to release the
-		 * incore state.  Dropping the delalloc reservation takes care
-		 * of the quota reservation for us.
-		 */
-		error = xfs_bunmapi(NULL, ip, data.br_startoff,
-				data.br_blockcount, 0, 1, &done);
-		if (error)
-			goto out_cancel;
-		ASSERT(done);
-	}
-
 	/* Free the CoW orphan record. */
 	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
 
-- 
2.39.2

