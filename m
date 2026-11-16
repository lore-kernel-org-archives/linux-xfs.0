Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871110;
	b=S1MrOyreOwGcd61Up8g4qofX4WYFBReLT1FJKslcK0OjdvuTBTAoOeepQ5/le2SwFwmi
	 TFOih+H9SkIOwk5SHlZHPHWwyLYemJrcrC9QnvuUW+8zo9pPWkBW/N15wsWY1CcsBOAnP
	 gyDbwPhqzv2H98yB8vDrDDkqCPIwvXD3wZ2OScYGLwEsMEeROhTt64vh963fIv41r14xl
	 JdC6CWqvCMxFeCWytUE4fRiTEndr6kEMGK4Auj3GcvE9bDTekhKuUtBxRUQdNhdemN35d
	 qv7rv9HqzkeHL/5WKrqdisKD8W/v7+CqS9JmwVfSz2HBwQBrEctgLhnkpf5s0Vtyc2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zBSj+H3yBXWXoJ/nylK52ZyagxojWwEDgAa+1vuCVus=;
	b=cO8fAWFFDSjg8KAHh9wVHojMsbx1wSuysE7t87JEEM1P2hZVLPqnR5FUmsUpGwYxNYiJ
	 1y2FmpvggSlOzMu6AQW8Aq2bhtb5MSPsulAZbTp/KrAYuYxoK6fdn1NYMFqfxHFKIXYrU
	 9YPIaBznTZxc/2AAvMmn4z8LenUZ/LBkFruJW25HGN6GmNFzHEePJYIkYLORLc8MfrqRW
	 V3hKNMnZ6nG3d7cwBg6y48TKeWMzzRa6hWNJr/uRjTjNtm8z04nsRuG9r7AF+2WlQuJH4
	 5RHrVBJ/Vpab7WlmyY1jCheHJJypARsjdT4jZTdvduedSmpya/ueHUGEbRSQ+vc1nJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaRmiWah;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7B4606A32A
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaRmiWah
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985091F000CD;
	Mon, 16 Nov 2026 23:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871110;
	bh=zBSj+H3yBXWXoJ/nylK52ZyagxojWwEDgAa+1vuCVus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SaRmiWahMNSbIHJ4WYaC+SJE6ecn+/SNGL1xBRECs1MWlPiqRjSRRonUkezL1QZvI
	 V6UfEKu94Qb4gA67Z3lQQesf84OsFrcDq9pwnko7lj+fpMCeCqnFTgzBvH7UHOZKCC
	 zeA1CHcRkgLtby8Itcx20MsL+Sft3B1znffGf/V1YnBAj5tFztuHHS+OMKLpwCfQd8
	 XoztNYP+n1cPvl3cClL/yIdlNiDlWpZvonVakVkGm68aKJ2U+++6L/0kWmggX18ucl
	 ZLPrKDhbu4jOWa3IDwnqXu6PZDYE7uHZSRzIaEk22mWvmqEj6Eu07cbW36QFi/vIZE
	 xcKcgea9Mzg6A==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 59/59] xfs: validate logged dquot buffers during recovery
Date: Tue, 17 Nov 2026 10:15:16 +1100
Message-ID: <20261116231707.3625263-60-dgc@kernel.org>
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

A buffer with a dquot type flag is only ever logged by
xfs_qm_init_dquot_blk(), which initialises and logs the whole buffer in a
single region. So such a buffer has exactly two regions: the format header,
and one data region covering the entire buffer that holds a full chunk of
valid dquots. Online repair also logs whole dquot buffers, but without the
type flag, so they are not checked here.

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
 fs/xfs/libxfs/xfs_dquot_buf.c  | 64 ++++++++++++++++-------------
 fs/xfs/libxfs/xfs_quota_defs.h |  2 +
 fs/xfs/xfs_buf_item_recover.c  | 73 +++++++++++++++++++---------------
 3 files changed, 81 insertions(+), 58 deletions(-)

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
index 32c7bf16378a..7be00f0e6b34 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -483,8 +483,6 @@ xlog_recover_do_reg_buffer(
 	int			i;
 	int			bit;
 	int			nbits;
-	xfs_failaddr_t		fa;
-	const size_t		size_disk_dquot = sizeof(struct xfs_disk_dquot);
 
 	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
 
@@ -498,39 +496,10 @@ xlog_recover_do_reg_buffer(
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
@@ -1309,6 +1278,44 @@ xlog_recover_buf_verify_type(
 	return NULL;
 }
 
+/*
+ * A buffer with a dquot type flag is only logged by xfs_qm_init_dquot_blk(),
+ * which initialises and logs the entire buffer in one go. Online repair also
+ * logs whole dquot buffers, but without the type flag, so they are replayed as
+ * regular buffers and are not checked here. So a logged dquot buffer has
+ * exactly one data region covering the whole buffer, and that region is a full
+ * chunk of valid dquots. Reject anything else, then verify every dquot in the
+ * logged chunk so a corrupt dquot is not replayed onto disk.
+ */
+static int
+xlog_recover_buf_validate_dquot(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	struct xfs_buf_log_format	*blf)
+{
+	struct xfs_dqblk		*dqb;
+	xfs_failaddr_t			fa;
+	unsigned int			ndquots;
+
+	if (item->ri_total != 2 ||
+	    item->ri_buf[1].iov_len != BBTOB(blf->blf_len)) {
+		xfs_warn(log->l_mp,
+			"BUF: dquot buffer is not a single whole region recovered.");
+		return -EFSCORRUPTED;
+	}
+	dqb = item->ri_buf[1].iov_base;
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
@@ -1416,6 +1423,10 @@ xlog_recover_buf_validate_item(
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

