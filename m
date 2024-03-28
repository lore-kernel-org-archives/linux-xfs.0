Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E6C4EB44
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 07:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711609396; cv=none; b=bnCx4lCmkHxWtqNO3Jy1FnIKb8+vO5PLFOBE6Rn7+/EFfXKmMAuR/efaT4+ySBw65zQFZD2vbClvoZHB7JdXZJ+vl2BBPahCmhRiKaiY/zivkmoymXfbxUZhGwdZw+wOKy5JWpE2Fae45y57keBUmpltrGPN5eoyg9UhLzSKahE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711609396; c=relaxed/simple;
	bh=61+5bElTQD5jdGGo8qGMgWJNS5F0NU2xV9bhYjj+8+M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K+Y0p+P31iaNEX2sjnYkIgvZhM5nbI4uC07xGF8VMUJChdIlP1eeJUwOpjQrsYwZ/tHQaEEXSIjSLesVx2FIDtokLKXqDhsJSSqotp2Jalw5Jrp+ZevE/ifYrUibX7xN6WmnhgHQilVf73FTl8YvsFzkV344Nb4z7PNXN1+2scQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2sGh4SK/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2sGh4SK/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3+qxNH850ApfP8fO1ijNAlx+IPlK2Fdsx4UoTL4qhhU=; b=2sGh4SK/v+qXaJGiR2iFpgR5r0
	qIndkIMLtI9m5acfXHdFWF0bLUgM2WG8I5oamLbJj6MYg1RZrSJSkFQT8h2DMTxB91tiVWFkLU3+j
	82zH6f5GYUkcQXyr9ITbgO6cdE3p8lSq+GQvwoeN6AQulNJg1kNGGIFnJt+Clmp8ss2lBrHwS0X7a
	zxbJ5i+1e3DaRNPNQPvG2P56CFYdITzOkScNKel9xGWd4Ln83SLDS3EjFy0uKY7WICXchQo/i+7AL
	W5h2CtxwJFc2BxBw/9IjxkMoZf99d1QtTEsCV5etiwmLnJ9CXl+UMRs42Cj5uvYtoHl/2L8E0zia4
	S08a0/sQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpjn8-0000000CnhZ-0THy;
	Thu, 28 Mar 2024 07:03:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] xfs: rename the del variable in xfs_reflink_end_cow_extent
Date: Thu, 28 Mar 2024 08:02:56 +0100
Message-Id: <20240328070256.2918605-7-hch@lst.de>
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

del contains the new extent that we are remapping.  Give it a somewhat
less confusing name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index a7ee868d79bf02..15c723396cfdab 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -764,7 +764,7 @@ xfs_reflink_end_cow_extent(
 	xfs_fileoff_t		end_fsb)
 {
 	struct xfs_iext_cursor	icur;
-	struct xfs_bmbt_irec	got, del;
+	struct xfs_bmbt_irec	got, new;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
@@ -821,29 +821,29 @@ xfs_reflink_end_cow_extent(
 	}
 
 	/*
-	 * Preserve @got for the eventual CoW fork deletion; from now on @del
+	 * Preserve @got for the eventual CoW fork deletion; from now on @new
 	 * represents the mapping that we're actually remapping.
 	 */
-	del = got;
-	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
-	trace_xfs_reflink_cow_remap_from(ip, &del);
+	new = got;
+	xfs_trim_extent(&new, *offset_fsb, end_fsb - *offset_fsb);
+	trace_xfs_reflink_cow_remap_from(ip, &new);
 
 	/* Unmap the old data. */
-	xfs_reflink_unmap_old_data(tp, ip, del.br_startoff,
-			del.br_startoff + del.br_blockcount);
+	xfs_reflink_unmap_old_data(tp, ip, new.br_startoff,
+			new.br_startoff + new.br_blockcount);
 
 	/* Free the CoW orphan record. */
-	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
+	xfs_refcount_free_cow_extent(tp, new.br_startblock, new.br_blockcount);
 
 	/* Map the new blocks into the data fork. */
-	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &del);
+	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &new);
 
 	/* Charge this new data fork mapping to the on-disk quota. */
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
-			(long)del.br_blockcount);
+			(long)new.br_blockcount);
 
 	/* Remove the mapping from the CoW fork. */
-	xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
+	xfs_bmap_del_extent_cow(ip, &icur, &got, &new);
 
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -851,7 +851,7 @@ xfs_reflink_end_cow_extent(
 		return error;
 
 	/* Update the caller about how much progress we made. */
-	*offset_fsb = del.br_startoff + del.br_blockcount;
+	*offset_fsb = new.br_startoff + new.br_blockcount;
 	return 0;
 
 out_cancel:
-- 
2.39.2

