Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815CA3A1B5
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 07:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711609389; cv=none; b=WAD0UZ7SQlEfPQxxhb3iVpQ8FtCj2Fbn0s8hmib+NnHsw7Cs0/VoaqaVgDSUaGFrC2o+cNPY5CdM9z8Omgh3kwbEicnh4OOMe9ujeL6689+w5YgBSPpGPykVNv+cSkqGvnsfLLJSc8+Fq2xuPKz31nAqbeucMHcD/aABOZguZLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711609389; c=relaxed/simple;
	bh=2dNcrmQa50z7cwKlUp5NsKmVPksJtfc2nKVqmbJ4/RI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mJluQrX0wPGkY6o5azZ9C5RDywHpZrY3L5+IysgX9dc77Q6EUBPs7yDtLWwHXuzGGOwfDM/q98gffQ4zhusRQEbwsrWOJMg5ey+4WMLsW1dWs+jmNO4PEqbzH9ZOh36RNNbYn+paqOk+KGlHeMFYt8vVi5VB7vrudEjPkvHtNcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0lacY/M2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0lacY/M2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description;
	bh=rmtZpHDsRP/HYlW9P9jaA2pGWOkVFl7pVXAwwuqFDhs=; b=0lacY/M2CUhimLgAc2DTGCSUqL
	Hio8/hXDQVD8EpdDiKGIxmW49Z5sPe24oRdgsZFUeWSFXRpKqtyBR1vTn+uDMi89um9Rcl3vi6zsY
	lr9o4hAZ7adKrNmM82tnYbsN0wnBSL8Of7X1kzm/8JrimazZ5zEKChYA0NK6t/JLJ6urkc75joP8t
	Hz71WYrbI3zRWv1kbCZ77wIz6Mosb4Hs6WfGXOJ1uqhwPpFHrjqaDb+5FGuMWqav2dphPuTVApJx4
	azgrRXLMqyjiv5qppZ89BNZg1l0f8wrsqJX8WNpeEuDSH7hcb0sTANO462rnveQaoAoJxVk+FsCDH
	7w41SLmQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpjn0-0000000Cnft-2A98;
	Thu, 28 Mar 2024 07:03:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] xfs: xfs_quota_unreserve_blkres can't fail
Date: Thu, 28 Mar 2024 08:02:53 +0100
Message-Id: <20240328070256.2918605-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240328070256.2918605-1-hch@lst.de>
References: <20240328070256.2918605-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Unreserving quotas can't fail due to quota limits, and we'll pіck up
a shutdown file system a bit later in all the callers anyway.  Return
void and remove the error checking and propagation in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 16 +++++-----------
 fs/xfs/libxfs/xfs_bmap.h |  2 +-
 fs/xfs/xfs_aops.c        |  6 +-----
 fs/xfs/xfs_bmap_util.c   |  9 +++------
 fs/xfs/xfs_bmap_util.h   |  2 +-
 fs/xfs/xfs_iomap.c       |  4 ++--
 fs/xfs/xfs_quota.h       |  5 +++--
 fs/xfs/xfs_reflink.c     | 11 +++--------
 8 files changed, 19 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 656c95a22f2e6d..6c752e55a52724 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4895,7 +4895,7 @@ xfs_bmap_split_indlen(
 	return stolen;
 }
 
-int
+void
 xfs_bmap_del_extent_delay(
 	struct xfs_inode	*ip,
 	int			whichfork,
@@ -4910,7 +4910,6 @@ xfs_bmap_del_extent_delay(
 	xfs_fileoff_t		del_endoff, got_endoff;
 	xfs_filblks_t		got_indlen, new_indlen, stolen;
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
-	int			error = 0;
 	bool			isrt;
 
 	XFS_STATS_INC(mp, xs_del_exlist);
@@ -4934,9 +4933,7 @@ xfs_bmap_del_extent_delay(
 	 * indirect block accounting.
 	 */
 	ASSERT(!isrt);
-	error = xfs_quota_unreserve_blkres(ip, del->br_blockcount);
-	if (error)
-		return error;
+	xfs_quota_unreserve_blkres(ip, del->br_blockcount);
 	ip->i_delayed_blks -= del->br_blockcount;
 
 	if (got->br_startoff == del->br_startoff)
@@ -5016,7 +5013,6 @@ xfs_bmap_del_extent_delay(
 		xfs_mod_fdblocks(mp, da_diff, false);
 		xfs_mod_delalloc(mp, -da_diff);
 	}
-	return error;
 }
 
 void
@@ -5584,18 +5580,16 @@ __xfs_bunmapi(
 
 delete:
 		if (wasdel) {
-			error = xfs_bmap_del_extent_delay(ip, whichfork, &icur,
-					&got, &del);
+			xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del);
 		} else {
 			error = xfs_bmap_del_extent_real(ip, tp, &icur, cur,
 					&del, &tmp_logflags, whichfork,
 					flags);
 			logflags |= tmp_logflags;
+			if (error)
+				goto error0;
 		}
 
-		if (error)
-			goto error0;
-
 		end = del.br_startoff - 1;
 nodelete:
 		/*
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index f7662595309d86..0144835117c610 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -195,7 +195,7 @@ int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
 		xfs_extnum_t nexts, int *done);
-int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
+void	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
 		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
 		struct xfs_bmbt_irec *del);
 void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3f428620ebf2a3..c51bc17f5cfa03 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -469,7 +469,6 @@ xfs_discard_folio(
 {
 	struct xfs_inode	*ip = XFS_I(folio->mapping->host);
 	struct xfs_mount	*mp = ip->i_mount;
-	int			error;
 
 	if (xfs_is_shutdown(mp))
 		return;
@@ -483,11 +482,8 @@ xfs_discard_folio(
 	 * byte of the next folio. Hence the end offset is only dependent on the
 	 * folio itself and not the start offset that is passed in.
 	 */
-	error = xfs_bmap_punch_delalloc_range(ip, pos,
+	xfs_bmap_punch_delalloc_range(ip, pos,
 				folio_pos(folio) + folio_size(folio));
-
-	if (error && !xfs_is_shutdown(mp))
-		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
 }
 
 static const struct iomap_writeback_ops xfs_writeback_ops = {
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 19e11d1da66074..2be52d8265db91 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -440,7 +440,7 @@ xfs_getbmap(
  * if the ranges only partially overlap them, so it is up to the caller to
  * ensure that partial blocks are not passed in.
  */
-int
+void
 xfs_bmap_punch_delalloc_range(
 	struct xfs_inode	*ip,
 	xfs_off_t		start_byte,
@@ -452,7 +452,6 @@ xfs_bmap_punch_delalloc_range(
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end_byte);
 	struct xfs_bmbt_irec	got, del;
 	struct xfs_iext_cursor	icur;
-	int			error = 0;
 
 	ASSERT(!xfs_need_iread_extents(ifp));
 
@@ -476,15 +475,13 @@ xfs_bmap_punch_delalloc_range(
 			continue;
 		}
 
-		error = xfs_bmap_del_extent_delay(ip, XFS_DATA_FORK, &icur,
-						  &got, &del);
-		if (error || !xfs_iext_get_extent(ifp, &icur, &got))
+		xfs_bmap_del_extent_delay(ip, XFS_DATA_FORK, &icur, &got, &del);
+		if (!xfs_iext_get_extent(ifp, &icur, &got))
 			break;
 	}
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 77ecbb753ef207..51f84d8ff372fa 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -30,7 +30,7 @@ xfs_bmap_rtalloc(struct xfs_bmalloca *ap)
 }
 #endif /* CONFIG_XFS_RT */
 
-int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
+void	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
 		xfs_off_t start_byte, xfs_off_t end_byte);
 
 struct kgetbmap {
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 4087af7f3c9f3f..ba359bee2c2256 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1194,8 +1194,8 @@ xfs_buffered_write_delalloc_punch(
 	loff_t			offset,
 	loff_t			length)
 {
-	return xfs_bmap_punch_delalloc_range(XFS_I(inode), offset,
-			offset + length);
+	xfs_bmap_punch_delalloc_range(XFS_I(inode), offset, offset + length);
+	return 0;
 }
 
 static int
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 621ea9d7cf06d9..078b2b88206b2c 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -215,10 +215,11 @@ xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
 	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
 }
 
-static inline int
+static inline void
 xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t blocks)
 {
-	return xfs_quota_reserve_blkres(ip, -blocks);
+	/* don't return an error as unreserving quotas can't fail */
+	xfs_quota_reserve_blkres(ip, -blocks);
 }
 
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index df632790a0a51c..83f243cfa40571 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -606,10 +606,8 @@ xfs_reflink_cancel_cow_blocks(
 		trace_xfs_reflink_cancel_cow(ip, &del);
 
 		if (isnullstartblock(del.br_startblock)) {
-			error = xfs_bmap_del_extent_delay(ip, XFS_COW_FORK,
-					&icur, &got, &del);
-			if (error)
-				break;
+			xfs_bmap_del_extent_delay(ip, XFS_COW_FORK, &icur, &got,
+					&del);
 		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
 			ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
 
@@ -632,10 +630,7 @@ xfs_reflink_cancel_cow_blocks(
 			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
 
 			/* Remove the quota reservation */
-			error = xfs_quota_unreserve_blkres(ip,
-					del.br_blockcount);
-			if (error)
-				break;
+			xfs_quota_unreserve_blkres(ip, del.br_blockcount);
 		} else {
 			/* Didn't do anything, push cursor back. */
 			xfs_iext_prev(ifp, &icur);
-- 
2.39.2

