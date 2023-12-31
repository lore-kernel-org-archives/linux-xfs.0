Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8F5C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mITeqhtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9032CC433C8;
	Sun, 31 Dec 2023 23:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066626;
	bh=M8kgRDvfECFph8+HK62Is5od/XNQFqoFRPTm0ndd5hE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mITeqhtw0CPGi474AgtaHmRZETynqri6+XWXBWJdsiBJ8M8E0Msdi0ymkP/lBDiJ+
	 9npr1+8tPNcKkpWDvmBnuxgDI+WDZtlRjfQMsm+ziGo3TzZTsUaZTscLGz2Cs4VHuS
	 Ae/mQagnbLoW5PeiYjtatUovcBByQSreedWfk4/AWPtqawJl9ESQI1jIi71Qb0U82i
	 EepArfuGj1UblV5zA0FXrYwVe4NueqIqYuS8Y796oGPySgkFxzyMXF4oYDR73L3TNG
	 EZNOwODgamBa0Vbv5DA5n/UUjNzS2Ke/TCgGQ5go5XaiMFJNDEvmTHsfyg0LaRbZIv
	 Mr+0cNM0dW2vA==
Date: Sun, 31 Dec 2023 15:50:26 -0800
Subject: [PATCH 11/52] xfs: define locking primitives for realtime groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012317.1811243.6429425331947593787.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Define helper functions to lock all metadata inodes related to a
realtime group.  There's not much to look at now, but this will become
important when we add per-rtgroup metadata files and online fsck code
for them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtgroup.c |   33 +++++++++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.h |   14 ++++++++++++++
 2 files changed, 47 insertions(+)


diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 8bfaa8d06f8..7003ac5c567 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -533,3 +533,36 @@ xfs_rtgroup_update_secondary_sbs(
 
 	return saved_error ? saved_error : error;
 }
+
+/* Lock metadata inodes associated with this rt group. */
+void
+xfs_rtgroup_lock(
+	struct xfs_trans	*tp,
+	struct xfs_rtgroup	*rtg,
+	unsigned int		rtglock_flags)
+{
+	ASSERT(!(rtglock_flags & ~XFS_RTGLOCK_ALL_FLAGS));
+	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
+	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
+
+	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
+		xfs_rtbitmap_lock(tp, rtg->rtg_mount);
+	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
+		xfs_rtbitmap_lock_shared(rtg->rtg_mount, XFS_RBMLOCK_BITMAP);
+}
+
+/* Unlock metadata inodes associated with this rt group. */
+void
+xfs_rtgroup_unlock(
+	struct xfs_rtgroup	*rtg,
+	unsigned int		rtglock_flags)
+{
+	ASSERT(!(rtglock_flags & ~XFS_RTGLOCK_ALL_FLAGS));
+	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
+	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
+
+	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
+		xfs_rtbitmap_unlock(rtg->rtg_mount);
+	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
+		xfs_rtbitmap_unlock_shared(rtg->rtg_mount, XFS_RBMLOCK_BITMAP);
+}
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index c3f4f644ea5..70968cf700f 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -221,11 +221,25 @@ void xfs_rtgroup_update_super(struct xfs_buf *rtsb_bp,
 		const struct xfs_buf *sb_bp);
 void xfs_rtgroup_log_super(struct xfs_trans *tp, const struct xfs_buf *sb_bp);
 int xfs_rtgroup_update_secondary_sbs(struct xfs_mount *mp);
+
+/* Lock the rt bitmap inode in exclusive mode */
+#define XFS_RTGLOCK_BITMAP		(1U << 0)
+/* Lock the rt bitmap inode in shared mode */
+#define XFS_RTGLOCK_BITMAP_SHARED	(1U << 1)
+
+#define XFS_RTGLOCK_ALL_FLAGS	(XFS_RTGLOCK_BITMAP | \
+				 XFS_RTGLOCK_BITMAP_SHARED)
+
+void xfs_rtgroup_lock(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
+		unsigned int rtglock_flags);
+void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
 #else
 # define xfs_rtgroup_block_count(mp, rgno)	(0)
 # define xfs_rtgroup_update_super(bp, sb_bp)	((void)0)
 # define xfs_rtgroup_log_super(tp, sb_bp)	((void)0)
 # define xfs_rtgroup_update_secondary_sbs(mp)	(0)
+# define xfs_rtgroup_lock(tp, rtg, gf)		((void)0)
+# define xfs_rtgroup_unlock(rtg, gf)		((void)0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */

