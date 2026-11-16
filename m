Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871044;
	b=0TBGVhljmaASQ5tlzZHEJvLWg6IHTjbCXE0sm64eRMa5mLm0fOZ8Sdv1E9/lDqcWRBOo
	 y1lAigzFWQTFIkeKT3XxbOavSiJMwfapja9fJSi2NoHfeJeopJwULBQ8Vcm+sAvHAsi5o
	 sfQhIzVYW6PFh3329q++DQHzUI7eYsrocHoBibMynFiL7cxqk8c9cSxtkx2IXqJpHJorp
	 EqaW3HAq9piz+c8WpY/ZvfolhWXD9FuyeUw3DVeOGyW7VazDxyoe4VSjCZ4mRDwdK4BnI
	 tU7pgHTKSjCeDnyBHXKynrfbKsuugLgd5HeEFSFJ9WXFHTCdPMq8VbHC9M27Irjw9Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qaZavRBV8w0O6AJwRye0c+reJeQB/nci9tUzuJgjUB0=;
	b=zBAFuFTbKL70sIj9TOqQGJ7O1FFAdOBMmM6BjBoH8IKFeSbhSUb90ALGiJOcXwaPqvj3
	 /jx09rcO6xIaTN9NMLrJJPs1IJFUXNs49/AYEPWndKJjfqd13wc9OcCQYwGfuu+qg8GeR
	 l3gf7Kn5WoHEftOXUaLrLSQlhtHzkxU3KLOEwkSR18phG80Uj5Ry/H85JNXMhCbhALkbQ
	 tT8xZk32Z1UA5gw06XSiS6aErdiMtGGWmnkyM3zHFDBmFeHrqINKU5YoGRMo/eFgvTUJJ
	 9qBwA3iHGTm6Gqle+iM6DwV8deIARBVj+FD4UaIbNJlMAfTinPsbg/oYxLgNsoz2arg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=flubetRa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA38B606A334
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=flubetRa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41601F000C4;
	Mon, 16 Nov 2026 23:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871044;
	bh=qaZavRBV8w0O6AJwRye0c+reJeQB/nci9tUzuJgjUB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=flubetRabAVUGHOp9uSVcq9AUtq7OpMznYLJiHsl8kWJ+RnCO2SlEGJK1+gCQlG9L
	 Iq2hkgccfUTwHYASMSwZoousWmnyGIE/6ludGZ9Nhzd5KTDKbiA9Fvilo1BTADXpdi
	 XhcFRkP30Fs+XqAy/P3HS2mySq/9lfyIg5+Tx3kdRKUt48fUFFsku2ryqkqrAKDrr3
	 lxndwXhnyMXs6o0NvzLJimpElIZhljbBmsP3tWDW4BuGeLEX10UEzluXTgCvW32G36
	 wRvgOADX8/pd3+6MSHnMftrFfszg7aCVQBarW+uJp9mmxbDR43bPEN1l4ryTgwDdkc
	 x9pA/yfqRm6Ag==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 08/59] xfs: reinitialise the filesystem geometry after log recovery
Date: Tue, 17 Nov 2026 10:14:25 +1100
Message-ID: <20261116231707.3625263-9-dgc@kernel.org>
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

Log recovery can replay a growfs, which changes the filesystem geometry
recorded in the superblock. Mount computes state such as the realtime extent
and summary geometry, the low space thresholds and the transaction
reservations from the superblock before recovery runs. Nothing recomputes that
state afterwards, so the rest of the mount uses values that describe the
geometry from before recovery. The realtime device is also only checked
against the pre-recovery superblock. Runtime growfs recomputes this state
whenever it changes the superblock.

Log recovery re-reads the superblock once it has replayed the log, and
re-derives the mount features from it. That is mount reinitialisation rather
than journal work. Move it into the mount code, and run it after a dirty log has
been recovered. Recompute all the mount state derived from the superblock
geometry there as well, finishing with the transaction reservations that depend
on it.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 27 ------------------
 fs/xfs/xfs_mount.c       | 59 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 457617979668..fd356b09f9d1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3368,9 +3368,6 @@ xlog_do_recover(
 	xfs_daddr_t		head_blk,
 	xfs_daddr_t		tail_blk)
 {
-	struct xfs_mount	*mp = log->l_mp;
-	struct xfs_buf		*bp = mp->m_sb_bp;
-	struct xfs_sb		*sbp = &mp->m_sb;
 	int			error;
 
 	trace_xfs_log_recover(log, head_blk, tail_blk);
@@ -3395,30 +3392,6 @@ xlog_do_recover(
 	 */
 	xfs_ail_assign_tail_lsn(log->l_ailp);
 
-	/*
-	 * Now that we've finished replaying all buffer and inode updates,
-	 * re-read the superblock and reverify it.
-	 */
-	xfs_buf_lock(bp);
-	xfs_buf_hold(bp);
-	error = _xfs_buf_read(bp);
-	if (error) {
-		if (!xlog_is_shutdown(log)) {
-			xfs_buf_ioerror_alert(bp, __this_address);
-			ASSERT(0);
-		}
-		xfs_buf_relse(bp);
-		return error;
-	}
-
-	/* Convert superblock from on-disk format */
-	xfs_sb_from_disk(sbp, bp->b_addr);
-	xfs_buf_relse(bp);
-
-	/* re-initialise in-core superblock and geometry structures */
-	mp->m_features |= xfs_sb_version_to_features(sbp);
-	xfs_reinit_percpu_counters(mp);
-
 	/* Normal transactions can now occur */
 	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
 	return 0;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e4036eec579d..11040773fca0 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -833,6 +833,54 @@ xfs_set_max_atomic_write_opt(
 	return 0;
 }
 
+/*
+ * Log recovery can change the on-disk superblock, including the filesystem
+ * geometry if it replays a growfs. Re-read the superblock now that recovery has
+ * finished, and recompute the mount state that is derived from it so the rest
+ * of the mount uses the recovered geometry.
+ */
+static int
+xfs_mount_reinit_fs_geometry(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp = mp->m_sb_bp;
+	int			error;
+
+	xfs_buf_lock(bp);
+	xfs_buf_hold(bp);
+	error = _xfs_buf_read(bp);
+	if (error) {
+		if (!xfs_is_shutdown(mp)) {
+			xfs_buf_ioerror_alert(bp, __this_address);
+			ASSERT(0);
+		}
+		xfs_buf_relse(bp);
+		return error;
+	}
+	xfs_sb_from_disk(&mp->m_sb, bp->b_addr);
+	xfs_buf_relse(bp);
+
+	xfs_sb_mount_rextsize(mp, &mp->m_sb);
+	mp->m_features |= xfs_sb_version_to_features(&mp->m_sb);
+	xfs_reinit_percpu_counters(mp);
+
+	xfs_rtrmapbt_compute_maxlevels(mp);
+	xfs_rtrefcountbt_compute_maxlevels(mp);
+	xfs_rtbtree_compute_maxlevels(mp);
+
+	error = xfs_rtmount_init(mp);
+	if (error) {
+		xfs_warn(mp, "RT mount failed");
+		return error;
+	}
+
+	xfs_set_low_space_thresholds(mp);
+
+	/* The reservations depend on all of the above. */
+	xfs_trans_resv_calc(mp, M_RES(mp));
+	return 0;
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -1047,6 +1095,17 @@ xfs_mountfs(
 		goto out_inodegc_shrinker;
 	}
 
+	/*
+	 * If the log was dirty, recovery may have changed the filesystem
+	 * geometry. Re-read the superblock and reinitialise the mount geometry
+	 * structures derived from it.
+	 */
+	if (xlog_recovery_needed(mp->m_log)) {
+		error = xfs_mount_reinit_fs_geometry(mp);
+		if (error)
+			goto out_free_metadir;
+	}
+
 	/*
 	 * If we're resuming quota status and recovered the log, re-sample the
 	 * qflags from the ondisk superblock now that we've recovered it, just
-- 
2.55.0

