Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4124EB44
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 07:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711609393; cv=none; b=mzvfbZ3/RLGOJ3gDEgyy9tNbjacmlomvkrSC3qDgbLhmKBQ98w9x5vk6Ff9ZMnkCvcbOrR2zIiGqdFWU26fuHuedokx5hylYnJUR504T3P0eMz1I9Mfxp8TwgZlduNzg/h5tW8HlatCv5Y0QhtaucsGN8jiseLAjWunT6UCrOJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711609393; c=relaxed/simple;
	bh=EHJcjtNCFInwqGIIjSRKeF/ImgTVAp9csVS8Rryhe0U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m1xXm4eLvg3af1WnoGiULHpEHtiNGYwbPq8I3PFkqVuSRMN3pDW1LYFtp3FoowJYwWxR1y467EYiMPoAF9DqQqBNtdPJaQoJonxEScgZj+FdwUA47MYO49GT4He9eNXiRpijfSaZFPSTPCMeUPg/yTg9Fa26QMW4eIlPKVP+vHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cDpHgSwx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cDpHgSwx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/m0JP75I276wQgPuGvm/0Z+qHT/Ge4ee4CAR39iQfdw=; b=cDpHgSwx6xws9OI8VEc6DIcwff
	m00yUFOnGlLQoP/MwXCwd2F4rqcI85KxvWVJj0UOnF0jQRisUooB5j0bccFDcemtKJKggZSkm6v/F
	rKBC0eV7k1XvAzaQj4DBr1L6/pkxhC1EldOM22dYpwfuJfAObHCCVxKIUdUqHcarBcN0AvapVN1VX
	JcFccZMEOvoKTi6vyZFQtzXLAZg0VOVMKrZCmrQBT8dFX24J1JwQ8IrheEPS3w3SLDQIxztj2M6bO
	NwA6AhziR9jwT3v3z1kdrSsugQoaRwoYDvRBUDXf8cSattJYj21Xmtuyc3P290e4HtJKgoJvQsRFG
	ywmcUo6Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpjn5-0000000Cngn-1tkQ;
	Thu, 28 Mar 2024 07:03:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: optimize extent remapping in xfs_reflink_end_cow_extent
Date: Thu, 28 Mar 2024 08:02:55 +0100
Message-Id: <20240328070256.2918605-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240328070256.2918605-1-hch@lst.de>
References: <20240328070256.2918605-1-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 98 +++++++++++++++++++++++++-------------------
 1 file changed, 56 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3c35cd3b2dec5d..a7ee868d79bf02 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -701,6 +701,52 @@ xfs_reflink_cancel_cow_range(
 	return error;
 }
 
+/*
+ * Unmap any old data covering the COW target.
+ */
+static void
+xfs_reflink_unmap_old_data(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		offset_fsb,
+	xfs_fileoff_t		end_fsb)
+{
+	struct xfs_ifork	*ifp = &ip->i_df;
+	struct xfs_bmbt_irec	got, del;
+	struct xfs_iext_cursor	icur;
+
+	ASSERT(!xfs_need_iread_extents(ifp));
+
+	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
+		return;
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
+		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &del);
+		xfs_refcount_decrease_extent(tp, &del);
+		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
+				-del.br_blockcount);
+prev_extent:
+		xfs_iext_prev(ifp, &icur);
+refresh:
+		if (!xfs_iext_get_extent(ifp, &icur, &got))
+			break;
+	}
+}
+
 /*
  * Remap part of the CoW fork into the data fork.
  *
@@ -718,12 +764,11 @@ xfs_reflink_end_cow_extent(
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
@@ -765,9 +810,7 @@ xfs_reflink_end_cow_extent(
 	/*
 	 * Only remap real extents that contain data.  With AIO, speculative
 	 * preallocations can leak into the range we are called upon, and we
-	 * need to skip them.  Preserve @got for the eventual CoW fork
-	 * deletion; from now on @del represents the mapping that we're
-	 * actually remapping.
+	 * need to skip them.
 	 */
 	while (!xfs_bmap_is_written_extent(&got)) {
 		if (!xfs_iext_next_extent(ifp, &icur, &got) ||
@@ -776,47 +819,18 @@ xfs_reflink_end_cow_extent(
 			goto out_cancel;
 		}
 	}
+
+	/*
+	 * Preserve @got for the eventual CoW fork deletion; from now on @del
+	 * represents the mapping that we're actually remapping.
+	 */
 	del = got;
 	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
-
-	/* Grab the corresponding mapping in the data fork. */
-	nmaps = 1;
-	error = xfs_bmapi_read(ip, del.br_startoff, del.br_blockcount, &data,
-			&nmaps, 0);
-	if (error)
-		goto out_cancel;
-
-	/* We can only remap the smaller of the two extent sizes. */
-	data.br_blockcount = min(data.br_blockcount, del.br_blockcount);
-	del.br_blockcount = data.br_blockcount;
-
 	trace_xfs_reflink_cow_remap_from(ip, &del);
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
+	/* Unmap the old data. */
+	xfs_reflink_unmap_old_data(tp, ip, del.br_startoff,
+			del.br_startoff + del.br_blockcount);
 
 	/* Free the CoW orphan record. */
 	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
-- 
2.39.2

