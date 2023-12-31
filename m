Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CF1BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s0woDowL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FBFC433C7;
	Sun, 31 Dec 2023 21:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057431;
	bh=4ul8+N48oPnBfqmSTe1PlrQkXMcQfb9UIE8FH7ykL60=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s0woDowLYNMpTudGz3jDF+yCxWxPhkUzIwodyjPWcr5j3UFUKnouIQs1/YjLCZnga
	 Gn2EFQ74soDEkNrbErTHh92mCftEVw4oD3NQUKYIgZ77osEgVkmpfbaYDETXOiL+gd
	 hHLQQaJnKAnc08ySCj3m0TCWvVD+c0Z2OygTsFYUFduhPwqkXjY44hZB7ZBRonTp41
	 FFhm1ZqEF4sV4RXGucoslClYDi0mGZA0oHxxe1oTqNdjR3hTZB5zWENYAKswMuXzZm
	 9MHOKN2GTJnyMI8QGqoyY9F3aPekNu0tR4AvU8NZSzyBFkVq3shgpEc47vxzfPr8BK
	 JxbW+s21TyYew==
Date: Sun, 31 Dec 2023 13:17:10 -0800
Subject: [PATCH 06/24] xfs: write secondary realtime superblocks to disk
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846338.1763124.14677859962621212096.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create some library functions to make it easy to update all the
secondary realtime superblocks on disk; this will be used by growfs,
xfs_db, mkfs, and xfs_repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtgroup.c |  117 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |    2 +
 2 files changed, 119 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 325e4eb8f8781..173297f582e00 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -419,3 +419,120 @@ xfs_rtgroup_log_super(
 	xfs_rtgroup_update_super(rtsb_bp, sb_bp);
 	xfs_trans_ordered_buf(tp, rtsb_bp);
 }
+
+/* Initialize a secondary realtime superblock. */
+static int
+xfs_rtgroup_init_secondary_super(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_buf		*bp;
+	struct xfs_rtsb		*rsb;
+	xfs_rtblock_t		rtbno;
+	int			error;
+
+	ASSERT(rgno != 0);
+
+	error = xfs_buf_get_uncached(mp->m_rtdev_targp, XFS_FSB_TO_BB(mp, 1),
+			0, &bp);
+	if (error)
+		return error;
+
+	rtbno = xfs_rgbno_to_rtb(mp, rgno, 0);
+	bp->b_maps[0].bm_bn = xfs_rtb_to_daddr(mp, rtbno);
+	bp->b_ops = &xfs_rtsb_buf_ops;
+	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
+
+	rsb = bp->b_addr;
+	rsb->rsb_magicnum = cpu_to_be32(XFS_RTSB_MAGIC);
+	rsb->rsb_blocksize = cpu_to_be32(mp->m_sb.sb_blocksize);
+	rsb->rsb_rblocks = cpu_to_be64(mp->m_sb.sb_rblocks);
+
+	rsb->rsb_rextents = cpu_to_be64(mp->m_sb.sb_rextents);
+
+	memcpy(&rsb->rsb_uuid, &mp->m_sb.sb_uuid, sizeof(rsb->rsb_uuid));
+
+	rsb->rsb_rgcount = cpu_to_be32(mp->m_sb.sb_rgcount);
+	memcpy(&rsb->rsb_fname, &mp->m_sb.sb_fname, XFSLABEL_MAX);
+
+	rsb->rsb_rextsize = cpu_to_be32(mp->m_sb.sb_rextsize);
+	rsb->rsb_rbmblocks = cpu_to_be32(mp->m_sb.sb_rbmblocks);
+
+	rsb->rsb_rgblocks = cpu_to_be32(mp->m_sb.sb_rgblocks);
+	rsb->rsb_blocklog = mp->m_sb.sb_blocklog;
+	rsb->rsb_sectlog = mp->m_sb.sb_sectlog;
+	rsb->rsb_rextslog = mp->m_sb.sb_rextslog;
+
+	memcpy(&rsb->rsb_meta_uuid, &mp->m_sb.sb_meta_uuid,
+			sizeof(rsb->rsb_meta_uuid));
+
+	*bpp = bp;
+	return 0;
+}
+
+/*
+ * Update all the realtime superblocks to match the new state of the primary.
+ * Because we are completely overwriting all the existing fields in the
+ * secondary superblock buffers, there is no need to read them in from disk.
+ * Just get a new buffer, stamp it and write it.
+ *
+ * The rt super buffers do not need to be kept them in memory once they are
+ * written so we mark them as a one-shot buffer.
+ */
+int
+xfs_rtgroup_update_secondary_sbs(
+	struct xfs_mount	*mp)
+{
+	LIST_HEAD		(buffer_list);
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		start_rgno = 1;
+	int			saved_error = 0;
+	int			error = 0;
+
+	for_each_rtgroup_from(mp, start_rgno, rtg) {
+		struct xfs_buf		*bp;
+
+		error = xfs_rtgroup_init_secondary_super(mp, rtg->rtg_rgno,
+				&bp);
+		/*
+		 * If we get an error reading or writing alternate superblocks,
+		 * continue.  If we break early, we'll leave more superblocks
+		 * un-updated than updated.
+		 */
+		if (error) {
+			xfs_warn(mp,
+		"error allocating secondary superblock for rt group %d",
+				rtg->rtg_rgno);
+			if (!saved_error)
+				saved_error = error;
+			continue;
+		}
+
+		xfs_buf_oneshot(bp);
+		xfs_buf_delwri_queue(bp, &buffer_list);
+		xfs_buf_relse(bp);
+
+		/* don't hold too many buffers at once */
+		if (rtg->rtg_rgno % 16)
+			continue;
+
+		error = xfs_buf_delwri_submit(&buffer_list);
+		if (error) {
+			xfs_warn(mp,
+	"write error %d updating a secondary superblock near rt group %u",
+				error, rtg->rtg_rgno);
+			if (!saved_error)
+				saved_error = error;
+			continue;
+		}
+	}
+	error = xfs_buf_delwri_submit(&buffer_list);
+	if (error) {
+		xfs_warn(mp,
+	"write error %d updating a secondary superblock near rt group %u",
+			error, start_rgno);
+	}
+
+	return saved_error ? saved_error : error;
+}
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 83bbd43f7271a..2d0422c6712da 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -212,10 +212,12 @@ xfs_rgblock_t xfs_rtgroup_block_count(struct xfs_mount *mp,
 void xfs_rtgroup_update_super(struct xfs_buf *rtsb_bp,
 		const struct xfs_buf *sb_bp);
 void xfs_rtgroup_log_super(struct xfs_trans *tp, const struct xfs_buf *sb_bp);
+int xfs_rtgroup_update_secondary_sbs(struct xfs_mount *mp);
 #else
 # define xfs_rtgroup_block_count(mp, rgno)	(0)
 # define xfs_rtgroup_update_super(bp, sb_bp)	((void)0)
 # define xfs_rtgroup_log_super(tp, sb_bp)	((void)0)
+# define xfs_rtgroup_update_secondary_sbs(mp)	(0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */

