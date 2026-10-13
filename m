Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA883988E3
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871390; cv=none; b=H9Yle3pidJoNy5V4GAVBGW2Aw1X6gIyXa6R7vcwxVO8iVtK+4Cktbg8j+gxZHV26MUk7tg9QoKoKSnXfjt4rv4hkXFQwT4iMKpu5fkIm+gQynVV69Vfiz3AwqahcZp91eQaqqCwkof0d3J00vKKuyVkYEDg3B46h7/b2WQkaLMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871390; c=relaxed/simple;
	bh=emOvdZ5jH5SJvliFYXudAsNp4Ld10h2ES9dVXSK/ERw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/OV5JYU31VvMYO959YFcFID0ZwqF5czg+iLYGL9IECc/iTRPe8wC7PZxV+jQZqCE04cDWky9eHHJM36cFpU+r234VChi9S/SMY17CDBglhpoSrfjEVRcOfrymM+wL36pcwNtbhlghjwkP/t+cihiUixid2ufwc2M6SnD8Oim/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BFDz/1CY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFDz/1CY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6181F00893;
	Tue, 13 Oct 2026 06:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871389;
	bh=r7EAAabPVkZ7qcWqhWR0O6zQEdTpyN+pXLgkjorta0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BFDz/1CYCyvwXCyMWYX9bpsljjnVC8BAobKSi/KOzKj68Rws8BfrB5Rr3qmRZ8AJ/
	 WVTPkehgsDb/plrptD3Qhd+kWmj8xS/rmpxKQZjJUYkyf0YKkTNbh3lcGTgc8gsCbC
	 kqK0WyRH/VMYihiiV8Spr7LV8JaRgF6fsq951wSZ6Z++JZCp9JrfD7qbpKkHrhcfyJ
	 aWyr0ahTKdrQLQJjC+119HyK78YL3DMt10EKdZfGhipKh/BBsReKjVrOGYi2jnYzYQ
	 k83sMdu2D95ozcXGuk4O+fhFEhQCSQLan4BBZw2F7dNFPDVlRIw8wzmUoMwncdHBrg
	 +3AeCVwNMM5dw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 48/48] xfs: validate logged dquot buffers during recovery
Date: Tue, 13 Oct 2026 17:01:38 +1100
Message-ID: <20261013060204.3138690-49-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A dquot buffer is only ever logged by xfs_qm_init_dquot_blk(), which initialises
and logs the whole buffer in a single region. So a logged dquot buffer has
exactly two regions, the format header and one data region covering the entire
buffer, and that region holds a full chunk of valid dquots.

Validate this in the buffer item validate_item callback. A buffer carrying a
dquot type flag must have that shape, and every dquot in the logged chunk is
verified so a corrupt dquot is never replayed to disk. The dquot content check
in the replay path only looked at the first dquot and relied on the replay loop
for the region bounds, so it is removed and the replay loop reduces to copying
the logged regions into the buffer.

To share the per-dquot verification, xfs_dquot_verify_chunk() is factored out of
xfs_dquot_buf_verify(). It walks a chunk of dquots and, on failure, updates its
dquot pointer to the offending dquot so the caller can report it. The buffer
read verifier is otherwise unchanged.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  | 64 ++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_quota_defs.h |  2 +
 fs/xfs/xfs_buf_item_recover.c  | 70 +++++++++++++++++++---------------
 3 files changed, 78 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 6c8a9afdfb1c..d6837c840989 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -179,6 +179,38 @@ xfs_dquot_buf_verify_crc(
 	return true;
 }
 
+/*
+ * Verify every dquot in a full chunk of dquots. We don't know what the id of
+ * the first dquot is supposed to be, just that they should be increasing
+ * monotonically within the chunk. If the first id is corrupt, then it will fail
+ * on the second dquot in the chunk so corruptions could point to the wrong
+ * dquot in this case. On failure @dqb is updated to point at the failing dquot
+ * so the caller can report it.
+ */
+xfs_failaddr_t
+xfs_dquot_verify_chunk(
+	struct xfs_mount	*mp,
+	struct xfs_dqblk	**dqb,
+	unsigned int		ndquots)
+{
+	xfs_failaddr_t		fa;
+	xfs_dqid_t		id = 0;
+	unsigned int		i;
+
+	for (i = 0; i < ndquots; i++) {
+		if (i == 0)
+			id = be32_to_cpu((*dqb)[i].dd_diskdq.d_id);
+
+		fa = xfs_dqblk_verify(mp, &(*dqb)[i], id + i);
+		if (fa) {
+			*dqb = &(*dqb)[i];
+			return fa;
+		}
+	}
+
+	return NULL;
+}
+
 STATIC xfs_failaddr_t
 xfs_dquot_buf_verify(
 	struct xfs_mount	*mp,
@@ -187,9 +219,7 @@ xfs_dquot_buf_verify(
 {
 	struct xfs_dqblk	*dqb = bp->b_addr;
 	xfs_failaddr_t		fa;
-	xfs_dqid_t		id = 0;
 	int			ndquots;
-	int			i;
 
 	/*
 	 * if we are in log recovery, the quota subsystem has not been
@@ -201,32 +231,12 @@ xfs_dquot_buf_verify(
 	else
 		ndquots = xfs_calc_dquots_per_chunk(bp->b_length);
 
-	/*
-	 * On the first read of the buffer, verify that each dquot is valid.
-	 * We don't know what the id of the dquot is supposed to be, just that
-	 * they should be increasing monotonically within the buffer. If the
-	 * first id is corrupt, then it will fail on the second dquot in the
-	 * buffer so corruptions could point to the wrong dquot in this case.
-	 */
-	for (i = 0; i < ndquots; i++) {
-		struct xfs_disk_dquot	*ddq;
+	fa = xfs_dquot_verify_chunk(mp, &dqb, ndquots);
+	if (fa && !readahead)
+		xfs_buf_verifier_error(bp, -EFSCORRUPTED, __func__, dqb,
+				sizeof(struct xfs_dqblk), fa);
 
-		ddq = &dqb[i].dd_diskdq;
-
-		if (i == 0)
-			id = be32_to_cpu(ddq->d_id);
-
-		fa = xfs_dqblk_verify(mp, &dqb[i], id + i);
-		if (fa) {
-			if (!readahead)
-				xfs_buf_verifier_error(bp, -EFSCORRUPTED,
-					__func__, &dqb[i],
-					sizeof(struct xfs_dqblk), fa);
-			return fa;
-		}
-	}
-
-	return NULL;
+	return fa;
 }
 
 static xfs_failaddr_t
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 551d7ae46c5c..73d82edf0969 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -132,6 +132,8 @@ extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
 		struct xfs_disk_dquot *ddq, xfs_dqid_t id);
 extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
 		struct xfs_dqblk *dqb, xfs_dqid_t id);
+xfs_failaddr_t xfs_dquot_verify_chunk(struct xfs_mount *mp,
+		struct xfs_dqblk **dqb, unsigned int ndquots);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
 		xfs_dqid_t id, xfs_dqtype_t type);
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 27cab5afc8ba..be1558d851db 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -481,8 +481,6 @@ xlog_recover_do_reg_buffer(
 	int			i;
 	int			bit;
 	int			nbits;
-	xfs_failaddr_t		fa;
-	const size_t		size_disk_dquot = sizeof(struct xfs_disk_dquot);
 
 	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
 
@@ -496,39 +494,10 @@ xlog_recover_do_reg_buffer(
 		nbits = xfs_contig_bits(buf_f->blf_data_map,
 					buf_f->blf_map_size, bit);
 
-		/*
-		 * Do a sanity check if this is a dquot buffer. Just checking
-		 * the first dquot in the buffer should do. XXXThis is
-		 * probably a good thing to do for other buf types also.
-		 */
-		fa = NULL;
-		if (buf_f->blf_flags &
-		   (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
-			if (item->ri_buf[i].iov_base == NULL) {
-				xfs_alert(mp,
-					"XFS: NULL dquot in %s.", __func__);
-				goto next;
-			}
-			if (item->ri_buf[i].iov_len < size_disk_dquot) {
-				xfs_alert(mp,
-					"XFS: dquot too small (%zd) in %s.",
-					item->ri_buf[i].iov_len, __func__);
-				goto next;
-			}
-			fa = xfs_dquot_verify(mp, item->ri_buf[i].iov_base, -1);
-			if (fa) {
-				xfs_alert(mp,
-	"dquot corrupt at %pS trying to replay into block 0x%llx",
-					fa, xfs_buf_daddr(bp));
-				goto next;
-			}
-		}
-
 		memcpy(xfs_buf_offset(bp,
 			(uint)bit << XFS_BLF_SHIFT),	/* dest */
 			item->ri_buf[i].iov_base,		/* source */
 			nbits<<XFS_BLF_SHIFT);		/* length */
- next:
 		i++;
 		bit += nbits;
 	}
@@ -1246,6 +1215,41 @@ xlog_recover_buf_verify_type(
 	return NULL;
 }
 
+/*
+ * A dquot buffer is only ever logged by xfs_qm_init_dquot_blk(), which
+ * initialises and logs the entire buffer in one go. So a logged dquot buffer
+ * has exactly one data region covering the whole buffer, and that region is a
+ * full chunk of valid dquots. Reject anything else, then verify every dquot in
+ * the logged chunk so a corrupt dquot is not replayed onto disk.
+ */
+static int
+xlog_recover_buf_validate_dquot(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	struct xfs_buf_log_format	*blf)
+{
+	struct xfs_dqblk		*dqb = item->ri_buf[1].iov_base;
+	xfs_failaddr_t			fa;
+	unsigned int			ndquots;
+
+	if (item->ri_total != 2 ||
+	    item->ri_buf[1].iov_len != BBTOB(blf->blf_len)) {
+		xfs_warn(log->l_mp,
+			"BUF: dquot buffer is not a single whole region recovered.");
+		return -EFSCORRUPTED;
+	}
+
+	ndquots = xfs_calc_dquots_per_chunk(blf->blf_len);
+	fa = xfs_dquot_verify_chunk(log->l_mp, &dqb, ndquots);
+	if (fa) {
+		xfs_warn(log->l_mp,
+			"BUF: dquot at %pS failed validation recovered.", fa);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 /*
  * Validate the whole buffer item once all regions are assembled. The item size
  * must match the number of regions attached. A cancelled buffer is not
@@ -1346,6 +1350,10 @@ xlog_recover_buf_validate_item(
 	if (ri != item->ri_total || total > BBTOB(blf->blf_len))
 		goto bad_map;
 
+	if (blf->blf_flags &
+	    (XFS_BLF_UDQUOT_BUF | XFS_BLF_PDQUOT_BUF | XFS_BLF_GDQUOT_BUF))
+		return xlog_recover_buf_validate_dquot(log, item, blf);
+
 	return 0;
 
 bad_map:
-- 
2.55.0

