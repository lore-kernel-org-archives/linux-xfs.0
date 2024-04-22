Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F76B1465AA
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713784858; cv=none; b=vFFE1uX5m00jQi0rMKAJwDmkx11ahqzSqt4VlY72Tbkp4XfiozKy8T9GVmQmXrEDtzj8eRyrO8XTsbZXOGOL1WrOLC9kq/zCLkSx3NMSqyIMFSnu3a7oWlnlkjwMmPvE3vSjPkgOWA/72FOiDkLtb3AgUy9HLYSZxMVl0mm+alo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713784858; c=relaxed/simple;
	bh=VyzqLQUptfebPJLXy081JpWlw23ID+LKI+Egft9ptkI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kj4ZmN1kY4u7y+2Yg7oSavjMK+OMDv9aJ2icmwXRhKdBt1nmLyY8/bugnYQMq8xdtOv5ieEoazpRBNTz9/vdgBIGGqaCqIWmLL9SHVvOGRnWKeEjrxfre9DZGwJUea+vP++TSFUbMNcDXjVBiLM2d1GpYjWFzpsIkhePgZ7UEQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yMlMgLex; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yMlMgLex"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ekKLdJQwjEzvXCVVrVmfZZHRI1Mt+c5J7g+GntI3f70=; b=yMlMgLexLkmjmshZCkWi2mBIWX
	JnYHWFgplrQpRIYQsMrkw9564FdqvNFQqXVHbBETf//yuhuiVWey4V/ZlzDrFrw1JeVxMdapRRU+j
	CdpGd2iSrHnvPycf+v6xeGsg689xLqC3oDkMsYCV2dkI7t4dW5E4b1Zc3MBWgSQ3rYQfQqEpj7qwq
	J6IpDHuvVR6y9mj5izvXeZA7zgJTYtVr2XslAKJbfwrGxYUxIsgjKeiTaoZOxy56LfNFKS7v9zWYZ
	kKPVoOpGDJluK7HRtNQ/7KMj9X5DCnLFWmqiQGi7EeSzLJ3YhqC6FwjUH7qe4PzSehCjXgjF46vhS
	w4z7bbqg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ryrjD-0000000DLKc-2jON;
	Mon, 22 Apr 2024 11:20:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 09/13] xfs: support RT inodes in xfs_mod_delalloc
Date: Mon, 22 Apr 2024 13:20:15 +0200
Message-Id: <20240422112019.212467-10-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240422112019.212467-1-hch@lst.de>
References: <20240422112019.212467-1-hch@lst.de>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c         | 12 ++++++------
 fs/xfs/scrub/fscounters.c        |  6 +++++-
 fs/xfs/scrub/fscounters.h        |  1 +
 fs/xfs/scrub/fscounters_repair.c | 12 +++++++++++-
 fs/xfs/xfs_mount.c               | 18 +++++++++++++++---
 fs/xfs/xfs_mount.h               |  9 ++++++++-
 fs/xfs/xfs_super.c               | 11 ++++++++++-
 7 files changed, 56 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d7a5ce2e4305af..a2b715450ec23e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1977,7 +1977,7 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	if (da_new != da_old)
-		xfs_mod_delalloc(mp, (int64_t)da_new - da_old);
+		xfs_mod_delalloc(bma->ip, 0, (int64_t)da_new - da_old);
 
 	if (bma->cur) {
 		da_new += bma->cur->bc_bmap.allocated;
@@ -2696,7 +2696,7 @@ xfs_bmap_add_extent_hole_delay(
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
-		xfs_mod_delalloc(ip->i_mount, (int64_t)newlen - oldlen);
+		xfs_mod_delalloc(ip, 0, (int64_t)newlen - oldlen);
 	}
 }
 
@@ -3373,7 +3373,7 @@ xfs_bmap_alloc_account(
 		 * yet.
 		 */
 		if (ap->wasdel) {
-			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+			xfs_mod_delalloc(ap->ip, -(int64_t)ap->length, 0);
 			return;
 		}
 
@@ -3397,7 +3397,7 @@ xfs_bmap_alloc_account(
 	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 	if (ap->wasdel) {
 		ap->ip->i_delayed_blks -= ap->length;
-		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+		xfs_mod_delalloc(ap->ip, -(int64_t)ap->length, 0);
 		fld = isrt ? XFS_TRANS_DQ_DELRTBCOUNT : XFS_TRANS_DQ_DELBCOUNT;
 	} else {
 		fld = isrt ? XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
@@ -4126,7 +4126,7 @@ xfs_bmapi_reserve_delalloc(
 		goto out_unreserve_frextents;
 
 	ip->i_delayed_blks += alen;
-	xfs_mod_delalloc(ip->i_mount, alen + indlen);
+	xfs_mod_delalloc(ip, alen, indlen);
 
 	got->br_startoff = aoff;
 	got->br_startblock = nullstartblock(indlen);
@@ -5024,7 +5024,7 @@ xfs_bmap_del_extent_delay(
 		fdblocks += del->br_blockcount;
 
 	xfs_add_fdblocks(mp, fdblocks);
-	xfs_mod_delalloc(mp, -(int64_t)fdblocks);
+	xfs_mod_delalloc(ip, -(int64_t)del->br_blockcount, -da_diff);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index b662e52fe69564..1d3e98346933e1 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -412,6 +412,7 @@ xchk_fscount_count_frextents(
 	int			error;
 
 	fsc->frextents = 0;
+	fsc->frextents_delayed = 0;
 	if (!xfs_has_realtime(mp))
 		return 0;
 
@@ -423,6 +424,8 @@ xchk_fscount_count_frextents(
 		goto out_unlock;
 	}
 
+	fsc->frextents_delayed = percpu_counter_sum(&mp->m_delalloc_rtextents);
+
 out_unlock:
 	xfs_rtbitmap_unlock_shared(sc->mp, XFS_RBMLOCK_BITMAP);
 	return error;
@@ -434,6 +437,7 @@ xchk_fscount_count_frextents(
 	struct xchk_fscounters	*fsc)
 {
 	fsc->frextents = 0;
+	fsc->frextents_delayed = 0;
 	return 0;
 }
 #endif /* CONFIG_XFS_RT */
@@ -593,7 +597,7 @@ xchk_fscounters(
 	}
 
 	if (!xchk_fscount_within_range(sc, frextents, &mp->m_frextents,
-			fsc->frextents)) {
+			fsc->frextents - fsc->frextents_delayed)) {
 		if (fsc->frozen)
 			xchk_set_corrupt(sc);
 		else
diff --git a/fs/xfs/scrub/fscounters.h b/fs/xfs/scrub/fscounters.h
index 461a13d25f4b38..bcf56e1c36f91c 100644
--- a/fs/xfs/scrub/fscounters.h
+++ b/fs/xfs/scrub/fscounters.h
@@ -12,6 +12,7 @@ struct xchk_fscounters {
 	uint64_t		ifree;
 	uint64_t		fdblocks;
 	uint64_t		frextents;
+	uint64_t		frextents_delayed;
 	unsigned long long	icount_min;
 	unsigned long long	icount_max;
 	bool			frozen;
diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
index 94cdb852bee462..469bf645dbea52 100644
--- a/fs/xfs/scrub/fscounters_repair.c
+++ b/fs/xfs/scrub/fscounters_repair.c
@@ -65,7 +65,17 @@ xrep_fscounters(
 	percpu_counter_set(&mp->m_icount, fsc->icount);
 	percpu_counter_set(&mp->m_ifree, fsc->ifree);
 	percpu_counter_set(&mp->m_fdblocks, fsc->fdblocks);
-	percpu_counter_set(&mp->m_frextents, fsc->frextents);
+
+	/*
+	 * Online repair is only supported on v5 file systems, which require
+	 * lazy sb counters and thus no update of sb_fdblocks here.  But as of
+	 * now we don't support lazy counting sb_frextents yet, and thus need
+	 * to also update it directly here.  And for that we need to keep
+	 * track of the delalloc reservations separately, as they are are
+	 * subtracted from m_frextents, but not included in sb_frextents.
+	 */
+	percpu_counter_set(&mp->m_frextents,
+		fsc->frextents - fsc->frextents_delayed);
 	mp->m_sb.sb_frextents = fsc->frextents;
 
 	return 0;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b9df7cc9c473dd..b2e5653b5200cb 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -34,6 +34,7 @@
 #include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_ag.h"
+#include "xfs_rtbitmap.h"
 #include "scrub/stats.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -1408,9 +1409,20 @@ xfs_clear_incompat_log_features(
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
+		percpu_counter_add_batch(&mp->m_delalloc_rtextents,
+				xfs_rtb_to_rtx(mp, data_delta),
+				XFS_DELALLOC_BATCH);
+		if (!ind_delta)
+			return;
+		data_delta = 0;
+	}
+	percpu_counter_add_batch(&mp->m_delalloc_blks, data_delta + ind_delta,
 			XFS_DELALLOC_BATCH);
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index fe5ba717043b00..72f603e4206461 100644
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
+	struct percpu_counter	m_delalloc_rtextents;
+
 	/*
 	 * Global count of allocation btree blocks in use across all AGs. Only
 	 * used when perag reservation is enabled. Helps prevent block
@@ -583,6 +589,7 @@ struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
 void xfs_force_summary_recalc(struct xfs_mount *mp);
 int xfs_add_incompat_log_feature(struct xfs_mount *mp, uint32_t feature);
 bool xfs_clear_incompat_log_features(struct xfs_mount *mp);
-void xfs_mod_delalloc(struct xfs_mount *mp, int64_t delta);
+void xfs_mod_delalloc(struct xfs_inode *ip, int64_t data_delta,
+		int64_t ind_delta);
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 66ab769e98b486..6a96f6b07c9f72 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1052,12 +1052,18 @@ xfs_init_percpu_counters(
 	if (error)
 		goto free_fdblocks;
 
-	error = percpu_counter_init(&mp->m_frextents, 0, GFP_KERNEL);
+	error = percpu_counter_init(&mp->m_delalloc_rtextents, 0, GFP_KERNEL);
 	if (error)
 		goto free_delalloc;
 
+	error = percpu_counter_init(&mp->m_frextents, 0, GFP_KERNEL);
+	if (error)
+		goto free_delalloc_rt;
+
 	return 0;
 
+free_delalloc_rt:
+	percpu_counter_destroy(&mp->m_delalloc_rtextents);
 free_delalloc:
 	percpu_counter_destroy(&mp->m_delalloc_blks);
 free_fdblocks:
@@ -1086,6 +1092,9 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_icount);
 	percpu_counter_destroy(&mp->m_ifree);
 	percpu_counter_destroy(&mp->m_fdblocks);
+	ASSERT(xfs_is_shutdown(mp) ||
+	       percpu_counter_sum(&mp->m_delalloc_rtextents) == 0);
+	percpu_counter_destroy(&mp->m_delalloc_rtextents);
 	ASSERT(xfs_is_shutdown(mp) ||
 	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
 	percpu_counter_destroy(&mp->m_delalloc_blks);
-- 
2.39.2

