Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871092;
	b=ZyoPfUUmS6/ZrEIrWoRc/CuQVtyDxmQ/dq3kSGC8N0XfSygXUyNEemeOhNRB5nERJxSV
	 UBIbcYRVa8uzJaHUaZyrzu5TCn99P2ULAqdO10z+r8iDx4Q8gFEV+CZz/sYBv16/sfHnu
	 kiy/+PzMZh+8ZRei8Zhi5hmTiAXKhwFLDVBoT7Xmt1G5y6D0Yl4Z6wNOb6UmNLMjI4QUa
	 VhoJtNxorqosIuoYayL0oeFOibfE7kIkWOZu6lioqYXPmb6NstBGH68n6PQ73cxTyHFd6
	 tZjxFJY/O+WoVaBqwfnBLgXxOcH+Zf+H4lWJDnmUmnanRqxNlUbX2h6qJOJBVHzSp1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Ubb7FtFgFSi2XO+cAuasF898MrGTDYSRqapbKbYQP6Y=;
	b=OCPIWYaEP4MX+Z3247QV5IW5kMCrTNwR5T9TSfvlMwt7iszcoZCHWQN5mCvTQRGWemJs
	 HUyjDJYUz5TJC6q3yCVaApxPcn+v3ZTGFN706JiHrcoLI3Y+hRiWlYU/EQkhRc2qTmwdT
	 sViEHPNKLb7cSWcTr2R08+chn17dcomX1L2cC8rI/wBugCdPtWJWMzZDqNRCkDoll37vz
	 zLbsD2HVae0DD/gqJikRmRTDjdeCkF2pyu6jCIUxM4YIRA407Pz37qFLtgcsLwv6V1+8P
	 ikntVg9a3dQXULpN7bni9aL3mSgRQw7lAxmi91C0Ro+UOdlghkP/K/i7d82+LqOhmMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PrZtDowf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77383606A32A
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PrZtDowf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C951F000C4;
	Mon, 16 Nov 2026 23:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871092;
	bh=Ubb7FtFgFSi2XO+cAuasF898MrGTDYSRqapbKbYQP6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PrZtDowfrKZwZl/5T+3+EWZmsWjslv4V0Gfk6r+Y/pYUe7JlEU22fw6ODmJJog510
	 c4LlxolQuwEd25USwKpm7TMby+DERBk+PU80vr340sTRPSlCgXUaqWRHMt5ho4RzcR
	 hrUtDzgr7qfuB8d7tnqkMN9kOcE7Ui7b6ZINdP0LediUSzfalZ5V+SmKP+SfOlSKKG
	 MqzIi9SN4LTb9og4x8RAeNtU/hq+JEc3UUdFK+a+x4JFYkNw7TN4jJZ8PtlNtmjORs
	 a0dlt/Z3YFV2p6cClVDyY0nva2Oa+19Wsx0fKsSzI0rUuuCJJk8N6S1r3bXQwa7+M7
	 6kZvxMnBAZY7A==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 45/59] xfs: validate the inode item format header during recovery
Date: Tue, 17 Nov 2026 10:15:02 +1100
Message-ID: <20261116231707.3625263-46-dgc@kernel.org>
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

The inode item format header describes how many regions the item has and where
the inode lives on disk. Recovery trusted these values, guarding only a few of
them with asserts in the commit handler while walking the regions and reading
the inode buffer.

Validate the format header as the item is decoded, so the rest of recovery can
trust the region count and buffer location it describes. The header is
self-consistent with the fields it logs, and the buffer location is fixed by the
inode number, so both are checked here.

The inode number fixes the block holding the inode and the inode's offset
within that block, so the logged buffer block and offset are always checked
against those, and the inode must lie within the cluster buffer. Where the
cluster starts relative to that block depends on the inode chunk alignment.
When xfs_imap() can resolve that without an inode btree lookup, the exact
cluster location is checked too. Recovery never issues an inode btree lookup.

The host format conversion is split into its own helper so validation always
runs against a host format header.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_inode_item_recover.c | 171 ++++++++++++++++++++++++++++++--
 1 file changed, 164 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 2c7a5627158b..98596f27fb06 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -21,6 +21,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 #include "xfs_icache.h"
+#include "xfs_ialloc.h"
+#include "xfs_ag.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
@@ -343,29 +345,184 @@ xlog_recover_inode_validate_region(
  * format. A header already in host format is left in place.
  */
 static int
-xlog_recover_inode_validate_item(
-	struct xlog			*log,
+xlog_recover_inode_convert_format(
 	struct xlog_recover_item	*item)
 {
-	struct xfs_inode_log_format	*in_f;
+	struct xfs_inode_log_format	*ilfp;
 	int				error;
 
 	if (item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format))
 		return 0;
 
-	in_f = kzalloc_obj(struct xfs_inode_log_format, GFP_KERNEL | __GFP_NOFAIL);
-	error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
+	ilfp = kzalloc_obj(struct xfs_inode_log_format, GFP_KERNEL | __GFP_NOFAIL);
+	error = xfs_inode_item_format_convert(&item->ri_buf[0], ilfp);
 	if (error) {
-		kfree(in_f);
+		kfree(ilfp);
 		return error;
 	}
 
 	kvfree(item->ri_buf[0].iov_base);
-	item->ri_buf[0].iov_base = in_f;
+	item->ri_buf[0].iov_base = ilfp;
 	item->ri_buf[0].iov_len = sizeof(struct xfs_inode_log_format);
 	return 0;
 }
 
+/*
+ * The inode number fixes the filesystem block holding the inode and the inode's
+ * offset within that block. The logged buffer offset and block must agree with
+ * those, and the inode must lie entirely within the cluster buffer.
+ *
+ * Where the cluster starts relative to the inode's block depends on the inode
+ * chunk alignment. For most geometries that is resolvable by arithmetic, and the
+ * exact location is checked. Otherwise it needs an inode btree lookup, which
+ * cannot be run this early in recovery, so the cluster boundary is not checked.
+ */
+static int
+xlog_recover_inode_check_location(
+	struct xlog			*log,
+	struct xfs_inode_log_format	*ilfp)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	xfs_agnumber_t			agno = XFS_INO_TO_AGNO(mp, ilfp->ilf_ino);
+	xfs_agblock_t			agbno = XFS_AGINO_TO_AGBNO(mp,
+						XFS_INO_TO_AGINO(mp, ilfp->ilf_ino));
+	unsigned int			ioffset = XFS_INO_TO_OFFSET(mp,
+						ilfp->ilf_ino) << mp->m_sb.sb_inodelog;
+	struct xfs_perag		*pag;
+	struct xfs_imap			imap;
+	xfs_daddr_t			blkno;
+	unsigned int			start;
+	unsigned int			end;
+	int				len;
+	int				error;
+
+	len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
+	if (ilfp->ilf_len != len) {
+		xfs_warn(mp,
+			"INODE: inode 0x%llx buffer length 0x%x does not match expected 0x%x recovered.",
+			ilfp->ilf_ino, ilfp->ilf_len, len);
+		return -EFSCORRUPTED;
+	}
+
+	/* The inode must lie entirely within the cluster buffer. */
+	if (ilfp->ilf_boffset < 0) {
+		xfs_warn(mp,
+			"INODE: inode 0x%llx bad buffer offset %d recovered.",
+			ilfp->ilf_ino, ilfp->ilf_boffset);
+		return -EFSCORRUPTED;
+	}
+	start = ilfp->ilf_boffset;
+	end = start + mp->m_sb.sb_inodesize;
+	if (end > BBTOB(ilfp->ilf_len)) {
+		xfs_warn(mp,
+			"INODE: inode 0x%llx at buffer offset 0x%x overruns buffer size 0x%x recovered.",
+			ilfp->ilf_ino, start, BBTOB(ilfp->ilf_len));
+		return -EFSCORRUPTED;
+	}
+
+	/* The offset within the inode's block is fixed by the inode number. */
+	if ((start & mp->m_blockmask) != ioffset) {
+		xfs_warn(mp,
+			"INODE: inode 0x%llx buffer offset 0x%x does not match offset 0x%x in its block recovered.",
+			ilfp->ilf_ino, start, ioffset);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * The block part of the buffer offset, counted back from the inode's
+	 * block, must land on the start of the cluster buffer.
+	 */
+	blkno = XFS_AGB_TO_DADDR(mp, agno, agbno) -
+			XFS_FSB_TO_BB(mp, start >> mp->m_sb.sb_blocklog);
+	if (ilfp->ilf_blkno != blkno) {
+		xfs_warn(mp,
+			"INODE: inode 0x%llx buffer block 0x%llx does not match expected 0x%llx recovered.",
+			ilfp->ilf_ino, ilfp->ilf_blkno, blkno);
+		return -EFSCORRUPTED;
+	}
+
+	pag = xfs_perag_get(mp, agno);
+	error = xfs_imap(pag, NULL, ilfp->ilf_ino, &imap, XFS_IMAP_NO_LOOKUP);
+	xfs_perag_put(pag);
+	if (error == -EAGAIN)
+		return 0;
+	if (error)
+		return error;
+
+	/* The geometry is resolvable, so check the exact cluster location. */
+	blkno = XFS_AGB_TO_DADDR(mp, agno, imap.im_agbno);
+	if (ilfp->ilf_blkno != blkno) {
+		xfs_warn(mp,
+			"INODE: inode 0x%llx buffer block 0x%llx does not match expected 0x%llx recovered.",
+			ilfp->ilf_ino, ilfp->ilf_blkno, blkno);
+		return -EFSCORRUPTED;
+	}
+	if (ilfp->ilf_boffset != imap.im_boffset) {
+		xfs_warn(mp,
+			"INODE: inode 0x%llx buffer offset 0x%x does not match expected 0x%x recovered.",
+			ilfp->ilf_ino, ilfp->ilf_boffset, imap.im_boffset);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+/*
+ * Validate the format header once it is in host format. The item size records
+ * how many regions the item should have, the set of logged fields fixes what
+ * that count must be, and the inode number fixes the buffer location, so all of
+ * these are checked against the header here.
+ */
+static int
+xlog_recover_inode_validate_item(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_inode_log_format	*ilfp;
+	unsigned int			nregions;
+	int				error;
+
+	error = xlog_recover_inode_convert_format(item);
+	if (error)
+		return error;
+	ilfp = item->ri_buf[0].iov_base;
+
+	if (!xfs_verify_ino(log->l_mp, ilfp->ilf_ino)) {
+		xfs_warn(log->l_mp, "INODE: bad inode number 0x%llx recovered.",
+				ilfp->ilf_ino);
+		return -EFSCORRUPTED;
+	}
+
+	if (!(ilfp->ilf_fields & XFS_ILOG_CORE)) {
+		xfs_warn(log->l_mp,
+			"INODE: inode 0x%llx has no core logged, fields 0x%x recovered.",
+			ilfp->ilf_ino, ilfp->ilf_fields);
+		return -EFSCORRUPTED;
+	}
+
+	if (ilfp->ilf_size != item->ri_total) {
+		xfs_warn(log->l_mp,
+			"INODE: inode 0x%llx item size %u does not match region count %u recovered.",
+			ilfp->ilf_ino, ilfp->ilf_size, item->ri_total);
+		return -EFSCORRUPTED;
+	}
+
+	nregions = 2;
+	if (ilfp->ilf_fields & XFS_ILOG_DFORK)
+		nregions++;
+	if (ilfp->ilf_fields & XFS_ILOG_AFORK)
+		nregions++;
+	if (ilfp->ilf_size != nregions) {
+		xfs_warn(log->l_mp,
+			"INODE: inode 0x%llx item size %u does not match region count %u the fields 0x%x define.",
+			ilfp->ilf_ino, ilfp->ilf_size, nregions,
+			ilfp->ilf_fields);
+		return -EFSCORRUPTED;
+	}
+
+	return xlog_recover_inode_check_location(log, ilfp);
+}
+
 STATIC int
 xlog_recover_inode_commit_pass2(
 	struct xlog			*log,
-- 
2.55.0

