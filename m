Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E931E48A
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324502; cv=none; b=UOeqvF3cKNJLG2LnLJd5t6M2sDS4ShhxU/1ZU73Yp70ZGnqy2KxGPaY8p79WzfSdP+Uictyk7QE84ERVq+P8VDRls3yyqqTW1YXiDVnc/j7TatAq/zVrBGiOYuNy8zRmpwY4/gLL8T80F//sBAm1QfA9UCkJnq383Vmf0A3iwgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324502; c=relaxed/simple;
	bh=bGIfK0TqtdTMn5VrgMmCstOGCZt/kRwtIgUykWpikkI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lMzANYESWf3BgIw9JTndxle+ag2w3Lqg7swHzGqgZ1VI4ikqYKaKPVVyxjrtJ7/PRUHFNDoVKa9gH3t4S4KjvlDPaGXIMQRpzkQx1OwgrqA45PwyEW82bY+khG/JaeNNhZA2JMX+L7kaQsVOwz1PilnZzYh2XVNvMmrJTqI5BP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x1W0QzLF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x1W0QzLF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nLOmUU8+8nHiPqoyDNG7pTQp+gJieCFxRwUwOvpdD3g=; b=x1W0QzLFDsDbopA2S5PTnViEWY
	sBXJB9BBl6ex0bPpdxCePYxIcXoeZxxCTqqPeKmT2F4Y0bmvvqDVRAyhS1o01ad1fwSliclLyiaGW
	8zLwLSJNDQ/wNZdMWPtstZrPZd2emWMgeV+izgyjrParS9JmhxYT7oQPsDnCvwtD64AeMo3NSSmfv
	F48oE/KVKluQHBZp5DrP00PxvT1reWYzkz9/2z/KljjsMkfjWoX6MZAx+Iz0TnjM0IBlTMJWNECtw
	Cz+04woWPARen6G6tDG3w4+gihVURoZ+wgDxwQoApTU/gjJEMkhiyOWhyFi0/ArliaffL1Xg6FsCH
	ZM9ppsUg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbxEx-00000009GM3-0bPQ;
	Mon, 19 Feb 2024 06:34:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/9] xfs: support RT inodes in xfs_mod_delalloc
Date: Mon, 19 Feb 2024 07:34:47 +0100
Message-Id: <20240219063450.3032254-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219063450.3032254-1-hch@lst.de>
References: <20240219063450.3032254-1-hch@lst.de>
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
index 074d833e845af3..8a84b7f0b55f38 100644
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
+	xfs_mod_delalloc(ip, -(long)del->br_blockcount, -da_diff);
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

