Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871047;
	b=O/yUsKiw66mSHUHGMwH0WwIqNKYSY6o0Z4syVuPjuM1ec7CPPVBcPVBR+lYhbPY4LWd6
	 2ZcqqqCMd5zMaIowblhIp9fBh3YQnu5Mo8RNDz7N0Ousjbamv96zJF+M277dEDi++pcZ9
	 MU2jSjgZ22B/CQDhroI7qglF4ogqskNiHoJV5Rw+QgoTJMGcpTTxoJnEbwTN/3W0zhw97
	 KfQl3KJWoqZHEe8GCk0PwH3dLasJ26I8HJmzmOr7lmSXpLBvIlLWXGyHLpE6bikf0bwMi
	 JMjdwIWkKomqK598W8ofJ48BTwPJ7qAnB9fFKKCtqTufFO6WGV6UMeFhdQAcQRMAg8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=mJ94wi94nRlrM9x324xvEUFrr7uYGsIxy7+Vzpq0wos=;
	b=ZyCfU12aSyV+7AK+5LeS5rnebxKnTEiA/3N624KZ3+MuL3xVBqHZSiDdlm58g0x4U1dg
	 G3tPYIQlqly0Jv8HbwrQ81RcQXyPOyi7QjII2JB8609LUoZx+kUwi5YPviMq60fOiS+rR
	 w7WnZR+e+ZkKPcAJ+WFLdgNRkmKq01ujLphWEEvjfMGIPdBQUHVM+FK9Pdy/gHqPRWo3s
	 Z3Gxul86WvM9D5LzP4JX+Zu/zDBcM6rAO1TQoovg3nCNvHSKHEemCfiesHS6uvg6tO/r4
	 KW5webAGY3D+QBYN8jj8bQcgL3fUvPy02EEpuwq4C2RUrGeVGi955IfvLmJzcHN4PHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JOavQRnC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A517C606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JOavQRnC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFD11F000C4;
	Mon, 16 Nov 2026 23:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871047;
	bh=mJ94wi94nRlrM9x324xvEUFrr7uYGsIxy7+Vzpq0wos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOavQRnCIqBLtOzNGlzVZHgUsBdPQ5W/1R/enygJbpSbZPeoWk5yfuY5qCdlBWmyW
	 FsrWOsWISkKmZECSaU5ZhmBsNgC/PzZCLL21qsO5qp0Th48b3rUX/w1hOlx6XWVKBQ
	 NddWeYa0ZIT3exOnP/iue95VegMWHPnQVESU7d4b75KRjJ6qlXZOTltSmdmaef9QDk
	 QZgSuvHX9BPmOsWBBNRv6FYfoulzGuC+0MRJ+o3vgEZ72ywXBRwLnEMgThgI5v8eCP
	 Rm8TLOU5S/2iixxDGVb+nobVMHsRGdO/1RpuR8vXLfbIjhgX8YPKiTDylWWCMQOqVv
	 rDm28/CUJ6A8A==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 10/59] xfs: check the atomic write reservation against the current log size
Date: Tue, 17 Nov 2026 10:14:27 +1100
Message-ID: <20261116231707.3625263-11-dgc@kernel.org>
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

Changing max_atomic_write on remount can disturb transactions running on the
filesystem. The new reservation is checked by computing the minimum log size
for the whole reservation table. That calculation temporarily changes the
mount-wide rmap btree height and resets the live atomic ioend reservation to
its default. It is only safe at mkfs and mount time, but remount runs it on a
live filesystem. A transaction started in that window can see the wrong btree
height or get the wrong atomic ioend reservation.

Mount has already checked every other reservation against the log. Only the
new atomic ioend reservation needs checking. Invert the minimum log size
calculation to give the largest reservation that the current log can hold. It
reads only the superblock log geometry, so it is safe on a live filesystem.
The atomic ioend reservation is now only updated once the new value is known
to fit.

xfs_calc_atomic_write_log_geometry() is unchanged and is still used by mkfs to
size the log.

Fixes: 4528b9052731 ("xfs: allow sysadmins to specify a maximum atomic write limit at mount time")
Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 45 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_shared.h     |  1 +
 fs/xfs/libxfs/xfs_trans_resv.c | 45 ++++++++++++++++++++++++++++------
 fs/xfs/xfs_trace.h             | 34 +++++++++++++++++++++++++
 4 files changed, 118 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 37712b2f8757..685d4797913e 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -249,3 +249,48 @@ xfs_log_calc_minimum_size(
 
 	return XFS_BB_TO_FSB(mp, min_logblks);
 }
+
+/*
+ * Calculate the largest transaction reservation, in bytes, that fits in the
+ * current log. The reservation is a unit reservation from
+ * xfs_log_calc_unit_res() multiplied by the log count, as in
+ * xfs_log_calc_minimum_size().
+ *
+ * This is the inverse of xfs_log_calc_minimum_size(): a reservation fits in the
+ * log if, and only if, it is no larger than the value returned here. The two
+ * functions must be kept in step.
+ *
+ * xfs_log_calc_minimum_size() temporarily changes mount state to calculate the
+ * reservations, so it can only be used at mkfs and mount time. This function
+ * only reads the superblock log geometry, so it is safe to use on a live
+ * filesystem.
+ */
+int
+xfs_log_calc_max_res(
+	struct xfs_mount	*mp)
+{
+	int			logbbs;
+	int			lsunit = 0;
+
+	/* The superblock verifier limits the log to XFS_MAX_LOG_BYTES. */
+	logbbs = (int)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+	logbbs /= XFS_MIN_LOG_FACTOR;
+
+	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
+		lsunit = BTOBB(mp->m_sb.sb_logsunit);
+
+	if (lsunit) {
+		logbbs -= 2 * lsunit;
+		if (logbbs > 0)
+			logbbs = rounddown(logbbs, lsunit);
+	} else {
+		logbbs -= 2 * BBSIZE;
+	}
+
+	/* Mount has already checked that the log fits its reservations. */
+	ASSERT(logbbs > 0);
+	if (logbbs <= 0)
+		return 0;
+	ASSERT(logbbs < BTOBB(XFS_MAX_LOG_BYTES) / 2);
+	return BBTOB(logbbs);
+}
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index b1e0d9bc1f7d..ced25294b57c 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -124,6 +124,7 @@ static inline bool xfs_btree_is_rtrefcount(const struct xfs_btree_ops *ops)
 /* log size calculation functions */
 int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
 int	xfs_log_calc_minimum_size(struct xfs_mount *);
+int	xfs_log_calc_max_res(struct xfs_mount *mp);
 
 struct xfs_trans_res;
 void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index fadbed82cf07..372b0640357c 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -1521,6 +1521,10 @@ xfs_calc_max_atomic_write_fsblocks(
  * Compute the log blocks and transaction reservation needed to complete an
  * atomic write of a given number of blocks.  Worst case, each block requires
  * separate handling.  A return value of 0 means something went wrong.
+ *
+ * This is for mkfs to size the log. It temporarily modifies the mount's
+ * transaction reservations and btree geometry, so it must not be used on a
+ * live filesystem.
  */
 xfs_extlen_t
 xfs_calc_atomic_write_log_geometry(
@@ -1559,29 +1563,56 @@ xfs_calc_atomic_write_log_geometry(
 /*
  * Compute the transaction reservation needed to complete an out of place
  * atomic write of a given number of blocks.
+ *
+ * This is called at mount and remount time, so it must not modify any mount
+ * state other than the atomic ioend reservation. The new reservation is
+ * checked against the largest reservation the current log can hold, and the
+ * atomic ioend reservation is only updated once it is known to fit.
  */
 int
 xfs_calc_atomic_write_reservation(
 	struct xfs_mount	*mp,
 	xfs_extlen_t		blockcount)
 {
-	unsigned int		new_logres;
-	xfs_extlen_t		min_logblocks;
+	struct xfs_trans_resv	*resp = M_RES(mp);
+	struct xfs_trans_res	tres;
+	unsigned int		per_intent, step_size;
+	unsigned int		logres;
+	uint64_t		need_res = 0;
+	int			max_res;
 
 	/*
 	 * If the caller doesn't ask for a specific atomic write size, then
 	 * use the defaults.
 	 */
 	if (blockcount == 0) {
-		xfs_calc_default_atomic_ioend_reservation(M_RES(mp));
+		xfs_calc_default_atomic_ioend_reservation(resp);
 		return 0;
 	}
 
-	min_logblocks = xfs_calc_atomic_write_log_geometry(mp, blockcount,
-			&new_logres);
-	if (!min_logblocks || min_logblocks > mp->m_sb.sb_logblocks)
+	per_intent = xfs_calc_atomic_write_ioend_geometry(mp, &step_size);
+
+	/* Check for overflows */
+	if (check_mul_overflow(blockcount, per_intent, &logres) ||
+	    check_add_overflow(logres, step_size, &logres) ||
+	    logres > INT_MAX)
+		return -EINVAL;
+
+	/* The atomic ioend reservation is based on the default. */
+	tres = resp->tr_itruncate;
+	tres.tr_logres = logres;
+
+	need_res = xfs_log_calc_unit_res(mp, tres.tr_logres);
+	if (tres.tr_logcount > 1)
+		need_res *= tres.tr_logcount;
+	max_res = xfs_log_calc_max_res(mp);
+
+	trace_xfs_calc_atomic_write_reservation(mp, per_intent, step_size,
+			blockcount, logres, need_res, max_res);
+
+	if (need_res > max_res)
 		return -EINVAL;
 
-	M_RES(mp)->tr_atomic_ioend.tr_logres = new_logres;
+	resp->tr_atomic_ioend = tres;
 	return 0;
 }
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 28d49f158b22..0e195a0835ec 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -264,6 +264,40 @@ TRACE_EVENT(xfs_calc_max_atomic_write_log_geometry,
 		  __entry->logres)
 );
 
+TRACE_EVENT(xfs_calc_atomic_write_reservation,
+	TP_PROTO(struct xfs_mount *mp, unsigned int per_intent,
+		 unsigned int step_size, unsigned int blockcount,
+		 unsigned int logres, uint64_t need_res, int max_res),
+	TP_ARGS(mp, per_intent, step_size, blockcount, logres, need_res,
+		max_res),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, per_intent)
+		__field(unsigned int, step_size)
+		__field(unsigned int, blockcount)
+		__field(unsigned int, logres)
+		__field(uint64_t, need_res)
+		__field(int, max_res)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->per_intent = per_intent;
+		__entry->step_size = step_size;
+		__entry->blockcount = blockcount;
+		__entry->logres = logres;
+		__entry->need_res = need_res;
+		__entry->max_res = max_res;
+	),
+	TP_printk("dev %d:%d per_intent %u step_size %u blockcount %u logres %u need_res %llu max_res %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->per_intent,
+		  __entry->step_size,
+		  __entry->blockcount,
+		  __entry->logres,
+		  __entry->need_res,
+		  __entry->max_res)
+);
+
 TRACE_EVENT(xlog_intent_recovery_failed,
 	TP_PROTO(struct xfs_mount *mp, const struct xfs_defer_op_type *ops,
 		 int error),
-- 
2.55.0

