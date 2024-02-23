Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397A1125A3
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 07:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708672562; cv=none; b=U0sASbx89Qa6GbPXazKOGf6KW20opSnFWOSDGj69TEE+vhVV0cN8moz/hayhEce/5gfMKwPYQzfj0k1cgefctwp8MFrpnw+NsXOFaOCcRQiADZbIdVOixV+bCeXuu4KDVfzPBvE+tyOZXPjRTi36sN+ZoettjqZwQbzXJPyUY5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708672562; c=relaxed/simple;
	bh=JQ5ratTc+dGOajmjWaqX3R5J7Y9PSHJUamOsii5A+3k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H3/tvs+R1I8O2AdOUchhwDr5+ahLx7PbZPHQvQE/Ip+5yvANVZQ74Yh7tp3PEwNS78msLkqEcXSwADWFoS/tY3eYN47lQ/ZKfD5wfJDIlw9yvZ9fXgSw66lgAeMnb+8WD9bd1A5I5TP9CXz5fLp9KKW3KggXpbAYWhm1EiuRKds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VByvZed+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VByvZed+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dFzERoiNSx+hXCkN8MPRHnjTn/j5sI2fcIvolyvP+CY=; b=VByvZed+nDijqu+ATreeDbt9Ns
	XckAIkBx28yBc8knRJ/XHyLaiXli58CedkzXKOnN4L/x7PVOInC+1sHrFmxbFrkAwuDDkLUf8lVgf
	VkEyK+KerrsIgOh0aJrJODCPFQA+oag4XtEC9RBoFGHUzckP3YnLlsOXYvg2kqQFi6ewpS0xCvqcJ
	r0h/ah+51DGO3neuw9MHTF3slXdQ54SWC/4EZdXcfeSlOLMAuL/3uXJJKzBqErpgVYZvGL2af4KP9
	lpH1KOiEF2fkGLCMqeLuANIgfeyTUCtwpUcASqPCSBhUZlTGy/MK80XB2x1ifDVsSSrNtWsFzzgAf
	VT4DXHCA==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdPmq-00000008GwL-1nJR;
	Fri, 23 Feb 2024 07:16:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/10] xfs: support RT inodes in xfs_mod_delalloc
Date: Fri, 23 Feb 2024 08:15:03 +0100
Message-Id: <20240223071506.3968029-8-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240223071506.3968029-1-hch@lst.de>
References: <20240223071506.3968029-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

To prepare for re-enabling delalloc on RT devices, track the data blocks
(which use the RT device when the inode sits on it) and the indirect
blocks (which don't) separately to xfs_mod_delalloc, and add a new
percpu counter to also track the RT delalloc blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c  | 12 ++++++------
 fs/xfs/scrub/fscounters.c |  3 +++
 fs/xfs/xfs_mount.c        | 16 +++++++++++++---
 fs/xfs/xfs_mount.h        |  9 ++++++++-
 fs/xfs/xfs_super.c        | 11 ++++++++++-
 5 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 074d833e845af3..d7fda286a4eaa0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1926,7 +1926,7 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	if (da_new != da_old)
-		xfs_mod_delalloc(mp, (int64_t)da_new - da_old);
+		xfs_mod_delalloc(bma->ip, 0, (int64_t)da_new - da_old);
 
 	if (bma->cur) {
 		da_new += bma->cur->bc_ino.allocated;
@@ -2622,7 +2622,7 @@ xfs_bmap_add_extent_hole_delay(
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
-		xfs_mod_delalloc(ip->i_mount, (int64_t)newlen - oldlen);
+		xfs_mod_delalloc(ip, 0, (int64_t)newlen - oldlen);
 	}
 }
 
@@ -3292,7 +3292,7 @@ xfs_bmap_alloc_account(
 		 * yet.
 		 */
 		if (ap->wasdel) {
-			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+			xfs_mod_delalloc(ap->ip, -(int64_t)ap->length, 0);
 			return;
 		}
 
@@ -3316,7 +3316,7 @@ xfs_bmap_alloc_account(
 	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 	if (ap->wasdel) {
 		ap->ip->i_delayed_blks -= ap->length;
-		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+		xfs_mod_delalloc(ap->ip, -(int64_t)ap->length, 0);
 		fld = isrt ? XFS_TRANS_DQ_DELRTBCOUNT : XFS_TRANS_DQ_DELBCOUNT;
 	} else {
 		fld = isrt ? XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
@@ -4041,7 +4041,7 @@ xfs_bmapi_reserve_delalloc(
 		goto out_unreserve_frextents;
 
 	ip->i_delayed_blks += alen;
-	xfs_mod_delalloc(ip->i_mount, alen + indlen);
+	xfs_mod_delalloc(ip, alen, indlen);
 
 	got->br_startoff = aoff;
 	got->br_startblock = nullstartblock(indlen);
@@ -4938,7 +4938,7 @@ xfs_bmap_del_extent_delay(
 		fdblocks += del->br_blockcount;
 
 	xfs_add_fdblocks(mp, fdblocks);
-	xfs_mod_delalloc(mp, -(int64_t)fdblocks);
+	xfs_mod_delalloc(ip, -(int64_t)del->br_blockcount, -da_diff);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 5c6d7244078942..b442e50e81555f 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -426,6 +426,9 @@ xchk_fscount_count_frextents(
 		goto out_unlock;
 	}
 
+	fsc->frextents -=
+		xfs_rtb_to_rtx(mp, percpu_counter_sum(&mp->m_delalloc_rtblks));
+
 out_unlock:
 	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	return error;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2e06837051d6b0..afc30d3333e8ad 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1388,9 +1388,19 @@ xfs_clear_incompat_log_features(
 #define XFS_DELALLOC_BATCH	(4096)
 void
 xfs_mod_delalloc(
-	struct xfs_mount	*mp,
-	int64_t			delta)
+	struct xfs_inode	*ip,
+	int64_t			data_delta,
+	int64_t			ind_delta)
 {
-	percpu_counter_add_batch(&mp->m_delalloc_blks, delta,
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		percpu_counter_add_batch(&mp->m_delalloc_rtblks, data_delta,
+				XFS_DELALLOC_BATCH);
+		if (!ind_delta)
+			return;
+		data_delta = 0;
+	}
+	percpu_counter_add_batch(&mp->m_delalloc_blks, data_delta + ind_delta,
 			XFS_DELALLOC_BATCH);
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 891a54d57f576d..71c7d06f3210c8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -195,6 +195,12 @@ typedef struct xfs_mount {
 	 * extents or anything related to the rt device.
 	 */
 	struct percpu_counter	m_delalloc_blks;
+
+	/*
+	 * RT version of the above.
+	 */
+	struct percpu_counter	m_delalloc_rtblks;
+
 	/*
 	 * Global count of allocation btree blocks in use across all AGs. Only
 	 * used when perag reservation is enabled. Helps prevent block
@@ -586,6 +592,7 @@ struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
 void xfs_force_summary_recalc(struct xfs_mount *mp);
 int xfs_add_incompat_log_feature(struct xfs_mount *mp, uint32_t feature);
 bool xfs_clear_incompat_log_features(struct xfs_mount *mp);
-void xfs_mod_delalloc(struct xfs_mount *mp, int64_t delta);
+void xfs_mod_delalloc(struct xfs_inode *ip, int64_t data_delta,
+		int64_t ind_delta);
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b16828410ec19b..1e21f8b953cf77 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1053,12 +1053,18 @@ xfs_init_percpu_counters(
 	if (error)
 		goto free_fdblocks;
 
-	error = percpu_counter_init(&mp->m_frextents, 0, GFP_KERNEL);
+	error = percpu_counter_init(&mp->m_delalloc_rtblks, 0, GFP_KERNEL);
 	if (error)
 		goto free_delalloc;
 
+	error = percpu_counter_init(&mp->m_frextents, 0, GFP_KERNEL);
+	if (error)
+		goto free_delalloc_rt;
+
 	return 0;
 
+free_delalloc_rt:
+	percpu_counter_destroy(&mp->m_delalloc_rtblks);
 free_delalloc:
 	percpu_counter_destroy(&mp->m_delalloc_blks);
 free_fdblocks:
@@ -1087,6 +1093,9 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_icount);
 	percpu_counter_destroy(&mp->m_ifree);
 	percpu_counter_destroy(&mp->m_fdblocks);
+	ASSERT(xfs_is_shutdown(mp) ||
+	       percpu_counter_sum(&mp->m_delalloc_rtblks) == 0);
+	percpu_counter_destroy(&mp->m_delalloc_rtblks);
 	ASSERT(xfs_is_shutdown(mp) ||
 	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
 	percpu_counter_destroy(&mp->m_delalloc_blks);
-- 
2.39.2

