Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871041;
	b=T3BBWwCCQ8S5xaWtM9o4ppugWGy0ziRokcBebKXQlcNg+/GdrkJFsgpZ7ZfFQUmcW1Dy
	 H/RMH/9GnuGevOmLAGh8qahjo/hfKBAyfS+T+2a/YgS3cAtU8d/pxGoyYXFXF3Y20LPw5
	 7OGe12XBkUWFW/MyCg7j4QErp1a0wC27ZclGZ7RvXZ6JPqhxtJKi5Ns2wmeSv2qlZU45G
	 qKwYXjRDSD15Kt0qv+7MvHjOrct17LQP0EfaOMWVgEzw4crls+nz1+5R1DvXbTDdgrmvy
	 W+WPiMf7W0rRtbullgxX4XjXjAa1uJVjVDKMWCczXCOVb9RC5HvPe+In7lALUfii9bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=fzLAWd5oJQv66tWwy3oxL9Tr2Rjq4lL2O+riz+N+ABE=;
	b=t7G+LxZHRoNDCRdDhztQmQLRQ5XxcOpVeDHtnsiwD5WvhgP6KcSoFPJvIdK46xDt/nHX
	 3NwbrGSn6aeT7pWGd9ZMeEsjEdx/3v7+soih9k/0/9s8j/hNuu8DtH07VInZkUvlX9iFX
	 /u3712X5r+zwgXlmB5PP6axkWDfrFf6Z8ELk0/BgF+EIcXTtlnNZO6dQkQCjZKrU4rZ3P
	 ZlwkYKhJgdRnHLWquPiH9CH0+zbTgENPQ8Mqm79Ij+I6KJfKKCVsh+Tz90mRzMEHURtQs
	 rP/IZWiezUFq2o9NfPhNEKC5Epz4H1+lCXfRtfaipbaFwUXP/Etnu1z3OqvctrE9gFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UKHVvbCp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F17606A334
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UKHVvbCp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2CF1F000C4;
	Mon, 16 Nov 2026 23:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871040;
	bh=fzLAWd5oJQv66tWwy3oxL9Tr2Rjq4lL2O+riz+N+ABE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKHVvbCp1iCiDUpRzAHyCX0/K7ct9tlZ2AYznAPiNp3XP1Yb3q4ZaXaBTcEqP95vL
	 x8xZpUGWUrHZcTN1BzmNTCx/6lsULIquXU1rJQqjLnj0P09iJ7UOHSem3N4eqZ1kE7
	 IlZ8XoeKDYaaaHAzLSsxm3LTtnjICpJgYSPsU1QOLreIOpxpsuL6qqyOdFcMmFN0+6
	 nyPSS5oJ3hyvbY90rk0DwHu9YL7ZROjpWOMclLKHk2TpnVYcisd7PUyzRrXXmaKD6j
	 rYg1YddUIpZoDFPpETlxXKvDi+ESPIG9SMPD+pfB8pf4ARJ+cTZv6g5wjPTHDndDg5
	 MT0xdO6a+L9EA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 05/59] xfs: recompute the transaction reservations after growfs
Date: Tue, 17 Nov 2026 10:14:22 +1100
Message-ID: <20261116231707.3625263-6-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Growfs can leave the transaction reservations sized for the old geometry.
Growing the data device or the realtime volume can increase the rt rmap
btree height. The write and truncate reservations include that height, but
growfs recomputes the btree heights without recomputing the reservations.
Adding the first realtime volume also leaves the reservations without their
realtime terms, because they are recalculated before the realtime feature
is set. A transaction that later needs the larger reservation can overrun
it and shut down the log.

The realtime grow also loses a configured max_atomic_write reservation. Its
reservation update resets the atomic ioend reservation to the default.
The atomic write limits are still sized for the larger reservation, so an
atomic write can overrun its ioend transaction reservation.

Add xfs_trans_resv_recalc() to recompute the reservations on a live
filesystem. It calculates the reservations in a separate table and copies
them into place, so a transaction never sees a partial update. It keeps a
configured atomic ioend reservation, which growfs does not change. Call it
after every growfs recomputes the rt btree heights. This replaces the
realtime grow's update before the commit, which only refreshed a
reservation that the grow takes from its temporary mount.

Growfs and a remount that changes max_atomic_write are not serialised.
Both update the atomic ioend reservation, so a racing remount can lose its
update. The realtime grow already raced this way, because it reset the
reservation in place. This race is not addressed here.

Fixes: 59a57acbce28 ("xfs: check that the rtrmapbt maxlevels doesn't increase when growing fs")
Fixes: 4528b9052731 ("xfs: allow sysadmins to specify a maximum atomic write limit at mount time")
Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 27 +++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.h |  1 +
 fs/xfs/xfs_fsops.c             |  6 +++++-
 fs/xfs/xfs_rtalloc.c           | 13 ++++++-------
 4 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index b09c88aec185..fadbed82cf07 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -1402,6 +1402,33 @@ xfs_trans_resv_calc(
 	xfs_calc_default_atomic_ioend_reservation(resp);
 }
 
+/*
+ * Recompute the transaction reservations on a live filesystem after growfs
+ * has changed the geometry they depend on.
+ *
+ * The new reservations are calculated in a separate table and copied into
+ * place, so that transactions starting during the update never see partially
+ * calculated values.
+ *
+ * A configured atomic ioend reservation depends only on intent item sizes,
+ * AG btree heights, the bmap btree height and the filesystem features, none of
+ * which growfs changes. Keep it, rather than resetting it to the default.
+ *
+ * This is not serialised against a remount that changes max_atomic_write,
+ * which also updates the atomic ioend reservation.
+ */
+void
+xfs_trans_resv_recalc(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans_resv	resv = {};
+
+	xfs_trans_resv_calc(mp, &resv);
+	if (mp->m_awu_max_bytes)
+		resv.tr_atomic_ioend = M_RES(mp)->tr_atomic_ioend;
+	*M_RES(mp) = resv;
+}
+
 /*
  * Return the per-extent and fixed transaction reservation sizes needed to
  * complete an atomic write.
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 336279e0fc61..33b5bd2e50df 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -97,6 +97,7 @@ struct xfs_trans_resv {
 #define	XFS_WRITE_LOG_COUNT_REFLINK	8
 
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
+void xfs_trans_resv_recalc(struct xfs_mount *mp);
 uint xfs_allocfree_block_count(struct xfs_mount *mp, uint num_ops);
 
 unsigned int xfs_calc_finish_bui_reservation(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index cd399e2a9c7f..3c68ab991a44 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -223,10 +223,14 @@ xfs_growfs_data_private(
 		if (error == -ENOSPC)
 			error = 0;
 
-		/* Compute new maxlevels for rt btrees. */
+		/*
+		 * Compute new maxlevels for rt btrees, and the transaction
+		 * reservations that depend on them.
+		 */
 		xfs_rtrmapbt_compute_maxlevels(mp);
 		xfs_rtrefcountbt_compute_maxlevels(mp);
 		xfs_rtbtree_compute_maxlevels(mp);
+		xfs_trans_resv_recalc(mp);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 760d73e4afa2..b11a088e43ff 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -928,12 +928,14 @@ xfs_growfs_rt_zoned(
 
 	/*
 	 * Ensure the mount RT feature flag is now set, and compute new
-	 * maxlevels for rt btrees.
+	 * maxlevels for rt btrees and the transaction reservations that depend
+	 * on them.
 	 */
 	mp->m_features |= XFS_FEAT_REALTIME;
 	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_rtrefcountbt_compute_maxlevels(mp);
 	xfs_rtbtree_compute_maxlevels(mp);
+	xfs_trans_resv_recalc(mp);
 
 	/*
 	 * Finally add the newly added zone to the freelist and add the space
@@ -1054,11 +1056,6 @@ xfs_growfs_rt_bmblock(
 	mp->m_rsumlevels = nmp->m_rsumlevels;
 	mp->m_rsumblocks = nmp->m_rsumblocks;
 
-	/*
-	 * Recompute the growfsrt reservation from the new rsumsize.
-	 */
-	xfs_trans_resv_calc(mp, &mp->m_resv);
-
 	/*
 	 * Sync sb counters now to reflect the updated values. Lazy counters are
 	 * not always updated and in order to avoid inconsistencies between
@@ -1074,12 +1071,14 @@ xfs_growfs_rt_bmblock(
 
 	/*
 	 * Ensure the mount RT feature flag is now set, and compute new
-	 * maxlevels for rt btrees.
+	 * maxlevels for rt btrees and the transaction reservations that depend
+	 * on them.
 	 */
 	mp->m_features |= XFS_FEAT_REALTIME;
 	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_rtrefcountbt_compute_maxlevels(mp);
 	xfs_rtbtree_compute_maxlevels(mp);
+	xfs_trans_resv_recalc(mp);
 
 	kfree(nmp);
 	return 0;
-- 
2.55.0

