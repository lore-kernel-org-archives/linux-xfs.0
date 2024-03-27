Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707D753800
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537440; cv=none; b=TZD0tFmUUrmsZfTdaMcy69njFzFv0J/2D2eRHeJZDGR7R2703l7g+Ws09TxuOShLpoPSC7AAZP6RB72O+gcdEMsS7fn5aemBlBecuEShpwWmpFQT72+mPeVajEebXJms/IoY1eiNl5qRoBc55Qs629HF1twLukMRCcE+R9kkuBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537440; c=relaxed/simple;
	bh=AO3Yx5XaBe34DauKlZF2MUeirWcoZ/9vPhg/3yEfgmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gBrCDXP/w7lwi4zQXuJ35ybUBOqgV3VHivYQDUJHITDY8lchq5mqhuMi8jBAcUV2cQa6vL/LrAGegOto/LzhVy10985Z4MvYaMsR04SEIkqTiJ9tvUHmtfVaYAW1OKsMi1y81uFIXRPrK1/aiLZGJyRIld6Ind4sMS0VZdCyNVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Tv4Vkusf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Tv4Vkusf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qIZnDmjqyRUM0DJcvXk/O0z4eazGwds+7rw1NdoBgcE=; b=Tv4VkusfGdM+QdZpIjMi+sAzBM
	8D3bHyRBlJ6sU8bndzbgsatyrO3OSNzVShWz/YWYBGP92hNryDatMn2BYkxQ/5ZohTaX/2MTIMByC
	0gL4jYoBl70InXdb7dZxlxANhz6FzS6+wnYr9iWLKoWZAMI86STfrMc6oSh8QuM1tozI1Kf3BdcxX
	4LX4SopNqEJ6UguELeKl0ADKOUimCsWUsxhx6WVux2Fl33jb02GIF7iyagZOtGiAFezprOrHsutq7
	aLoujNJWIk4ibeRR78OERIRtANC5wmY19G7vWCsxcL6nyr9K8e7Zip0ECEeViAreWgr2EDWP9yMno
	5v/bHjAQ==;
Received: from [89.144.223.137] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR4Y-00000008WjY-0KYw;
	Wed, 27 Mar 2024 11:03:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/13] xfs: support RT inodes in xfs_mod_delalloc
Date: Wed, 27 Mar 2024 12:03:14 +0100
Message-Id: <20240327110318.2776850-10-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240327110318.2776850-1-hch@lst.de>
References: <20240327110318.2776850-1-hch@lst.de>
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
 fs/xfs/libxfs/xfs_bmap.c         | 12 ++++++------
 fs/xfs/scrub/fscounters.c        |  6 +++++-
 fs/xfs/scrub/fscounters.h        |  1 +
 fs/xfs/scrub/fscounters_repair.c |  3 ++-
 fs/xfs/xfs_mount.c               | 18 +++++++++++++++---
 fs/xfs/xfs_mount.h               |  9 ++++++++-
 fs/xfs/xfs_super.c               | 11 ++++++++++-
 7 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a9a23a5d2e487f..131d4f063b660a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1975,7 +1975,7 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	if (da_new != da_old)
-		xfs_mod_delalloc(mp, (int64_t)da_new - da_old);
+		xfs_mod_delalloc(bma->ip, 0, (int64_t)da_new - da_old);
 
 	if (bma->cur) {
 		da_new += bma->cur->bc_bmap.allocated;
@@ -2694,7 +2694,7 @@ xfs_bmap_add_extent_hole_delay(
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
-		xfs_mod_delalloc(ip->i_mount, (int64_t)newlen - oldlen);
+		xfs_mod_delalloc(ip, 0, (int64_t)newlen - oldlen);
 	}
 }
 
@@ -3371,7 +3371,7 @@ xfs_bmap_alloc_account(
 		 * yet.
 		 */
 		if (ap->wasdel) {
-			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+			xfs_mod_delalloc(ap->ip, -(int64_t)ap->length, 0);
 			return;
 		}
 
@@ -3395,7 +3395,7 @@ xfs_bmap_alloc_account(
 	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 	if (ap->wasdel) {
 		ap->ip->i_delayed_blks -= ap->length;
-		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+		xfs_mod_delalloc(ap->ip, -(int64_t)ap->length, 0);
 		fld = isrt ? XFS_TRANS_DQ_DELRTBCOUNT : XFS_TRANS_DQ_DELBCOUNT;
 	} else {
 		fld = isrt ? XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
@@ -4124,7 +4124,7 @@ xfs_bmapi_reserve_delalloc(
 		goto out_unreserve_frextents;
 
 	ip->i_delayed_blks += alen;
-	xfs_mod_delalloc(ip->i_mount, alen + indlen);
+	xfs_mod_delalloc(ip, alen, indlen);
 
 	got->br_startoff = aoff;
 	got->br_startblock = nullstartblock(indlen);
@@ -5022,7 +5022,7 @@ xfs_bmap_del_extent_delay(
 		fdblocks += del->br_blockcount;
 
 	xfs_add_fdblocks(mp, fdblocks);
-	xfs_mod_delalloc(mp, -(int64_t)fdblocks);
+	xfs_mod_delalloc(ip, -(int64_t)del->br_blockcount, -da_diff);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index c910b5f1306913..d18a3cac30479d 100644
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
index 94cdb852bee462..210ebbcf3e1520 100644
--- a/fs/xfs/scrub/fscounters_repair.c
+++ b/fs/xfs/scrub/fscounters_repair.c
@@ -65,7 +65,8 @@ xrep_fscounters(
 	percpu_counter_set(&mp->m_icount, fsc->icount);
 	percpu_counter_set(&mp->m_ifree, fsc->ifree);
 	percpu_counter_set(&mp->m_fdblocks, fsc->fdblocks);
-	percpu_counter_set(&mp->m_frextents, fsc->frextents);
+	percpu_counter_set(&mp->m_frextents,
+		fsc->frextents - fsc->frextents_delayed);
 	mp->m_sb.sb_frextents = fsc->frextents;
 
 	return 0;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e7dfa259d0e6a2..2feb1a81bb87b5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -34,6 +34,7 @@
 #include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_ag.h"
+#include "xfs_rtbitmap.h"
 #include "scrub/stats.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -1402,9 +1403,20 @@ xfs_clear_incompat_log_features(
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
index d941437a0c7369..0e8d7779c0a561 100644
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
@@ -577,6 +583,7 @@ struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
 void xfs_force_summary_recalc(struct xfs_mount *mp);
 int xfs_add_incompat_log_feature(struct xfs_mount *mp, uint32_t feature);
 bool xfs_clear_incompat_log_features(struct xfs_mount *mp);
-void xfs_mod_delalloc(struct xfs_mount *mp, int64_t delta);
+void xfs_mod_delalloc(struct xfs_inode *ip, int64_t data_delta,
+		int64_t ind_delta);
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 784ff7d1c986ba..39a5e664870485 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1051,12 +1051,18 @@ xfs_init_percpu_counters(
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
@@ -1085,6 +1091,9 @@ xfs_destroy_percpu_counters(
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

