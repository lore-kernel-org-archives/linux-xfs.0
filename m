Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED300BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BoFPVq5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FE2C433C8;
	Sun, 31 Dec 2023 20:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053567;
	bh=MHVtLvqFpt5urDbIyKV4i+0hJGtKlJD+DTjvmrkg41A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BoFPVq5uuTjV/vdXB0ozP1r/1ipkDyqtSOM3aeCPaXKuv8XwZb91RguYScQoZWSHU
	 aPIJBPLDrd3uA6Zghz4p9Cmrta12ZBdgsr4FwfC4Lvt/ptp7fldctmv7F8u3UxcxEV
	 YJrkEJKrliNoD75X3mFvTmJkioRqx1kbsQvTD7I9sUB8RCkTCWseDbyQTSNcdt3bHB
	 aJuY9qCKtSct79ZJiauemQGlr1qCHVX4tRbyKn8sI8JB92SOcF8P9lw3FPRPAgn0PQ
	 t7Zy+Er4Su9mvOpxNkXFH5YGsn5EnrusHYlBUVdWd1Ma4j1AflmsxjTipmg/s68cWc
	 WPxiFg8CGDDjg==
Date: Sun, 31 Dec 2023 12:12:46 -0800
Subject: [PATCH 1/3] xfs: add secondary and indirect classes to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404828829.1748648.4029931620882730072.stgit@frogsfrogsfrogs>
In-Reply-To: <170404828806.1748648.14558047021297001140.stgit@frogsfrogsfrogs>
References: <170404828806.1748648.14558047021297001140.stgit@frogsfrogsfrogs>
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

Establish two more classes of health tracking bits:

 * Indirect problems, which suggest problems in other health domains
   that we weren't able to preserve.

 * Secondary problems, which track state that's related to primary
   evidence of health problems; and

The first class we'll use in an upcoming patch to record in the AG
health status the fact that we ran out of memory and had to inactivate
an inode with defective metadata.  The second class we use to indicate
that repair knows that an inode is bad and we need to fix it later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_health.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_health.c        |   26 +++++++++++++++++---------
 2 files changed, 60 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index a5b346b377cbb..26a2661571b1d 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -31,6 +31,19 @@
  *  - !checked && sick  => errors have been observed during normal operation,
  *                         but the metadata has not been checked thoroughly
  *  - !checked && !sick => has not been examined since mount
+ *
+ * Evidence of health problems can be sorted into three basic categories:
+ *
+ * a) Primary evidence, which signals that something is defective within the
+ *    general grouping of metadata.
+ *
+ * b) Secondary evidence, which are side effects of primary problem but are
+ *    not themselves problems.  These can be forgotten when the primary
+ *    health problems are addressed.
+ *
+ * c) Indirect evidence, which points to something being wrong in another
+ *    group, but we had to release resources and this is all that's left of
+ *    that state.
  */
 
 struct xfs_mount;
@@ -115,6 +128,36 @@ struct xfs_da_args;
 				 XFS_SICK_INO_DIR_ZAPPED | \
 				 XFS_SICK_INO_SYMLINK_ZAPPED)
 
+/* Secondary state related to (but not primary evidence of) health problems. */
+#define XFS_SICK_FS_SECONDARY	(0)
+#define XFS_SICK_RT_SECONDARY	(0)
+#define XFS_SICK_AG_SECONDARY	(0)
+#define XFS_SICK_INO_SECONDARY	(0)
+
+/* Evidence of health problems elsewhere. */
+#define XFS_SICK_FS_INDIRECT	(0)
+#define XFS_SICK_RT_INDIRECT	(0)
+#define XFS_SICK_AG_INDIRECT	(0)
+#define XFS_SICK_INO_INDIRECT	(0)
+
+/* All health masks. */
+#define XFS_SICK_FS_ALL	(XFS_SICK_FS_PRIMARY | \
+				 XFS_SICK_FS_SECONDARY | \
+				 XFS_SICK_FS_INDIRECT)
+
+#define XFS_SICK_RT_ALL	(XFS_SICK_RT_PRIMARY | \
+				 XFS_SICK_RT_SECONDARY | \
+				 XFS_SICK_RT_INDIRECT)
+
+#define XFS_SICK_AG_ALL	(XFS_SICK_AG_PRIMARY | \
+				 XFS_SICK_AG_SECONDARY | \
+				 XFS_SICK_AG_INDIRECT)
+
+#define XFS_SICK_INO_ALL	(XFS_SICK_INO_PRIMARY | \
+				 XFS_SICK_INO_SECONDARY | \
+				 XFS_SICK_INO_INDIRECT | \
+				 XFS_SICK_INO_ZAPPED)
+
 /*
  * These functions must be provided by the xfs implementation.  Function
  * behavior with respect to the first argument should be as follows:
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 64dffc69a219d..6ea85cd6b66f8 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -97,7 +97,7 @@ xfs_fs_mark_sick(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_FS_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_FS_ALL));
 	trace_xfs_fs_mark_sick(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
@@ -124,11 +124,13 @@ xfs_fs_mark_healthy(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_FS_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_FS_ALL));
 	trace_xfs_fs_mark_healthy(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
 	mp->m_fs_sick &= ~mask;
+	if (!(mp->m_fs_sick & XFS_SICK_FS_PRIMARY))
+		mp->m_fs_sick &= ~XFS_SICK_FS_SECONDARY;
 	mp->m_fs_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
 }
@@ -152,7 +154,7 @@ xfs_rt_mark_sick(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_RT_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_RT_ALL));
 	trace_xfs_rt_mark_sick(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
@@ -180,11 +182,13 @@ xfs_rt_mark_healthy(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_RT_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_RT_ALL));
 	trace_xfs_rt_mark_healthy(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
 	mp->m_rt_sick &= ~mask;
+	if (!(mp->m_rt_sick & XFS_SICK_RT_PRIMARY))
+		mp->m_rt_sick &= ~XFS_SICK_RT_SECONDARY;
 	mp->m_rt_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
 }
@@ -225,7 +229,7 @@ xfs_ag_mark_sick(
 	struct xfs_perag	*pag,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_AG_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
 	trace_xfs_ag_mark_sick(pag->pag_mount, pag->pag_agno, mask);
 
 	spin_lock(&pag->pag_state_lock);
@@ -252,11 +256,13 @@ xfs_ag_mark_healthy(
 	struct xfs_perag	*pag,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_AG_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
 	trace_xfs_ag_mark_healthy(pag->pag_mount, pag->pag_agno, mask);
 
 	spin_lock(&pag->pag_state_lock);
 	pag->pag_sick &= ~mask;
+	if (!(pag->pag_sick & XFS_SICK_AG_PRIMARY))
+		pag->pag_sick &= ~XFS_SICK_AG_SECONDARY;
 	pag->pag_checked |= mask;
 	spin_unlock(&pag->pag_state_lock);
 }
@@ -280,7 +286,7 @@ xfs_inode_mark_sick(
 	struct xfs_inode	*ip,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~(XFS_SICK_INO_PRIMARY | XFS_SICK_INO_ZAPPED)));
+	ASSERT(!(mask & ~XFS_SICK_INO_ALL));
 	trace_xfs_inode_mark_sick(ip, mask);
 
 	spin_lock(&ip->i_flags_lock);
@@ -303,7 +309,7 @@ xfs_inode_mark_checked(
 	struct xfs_inode	*ip,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~(XFS_SICK_INO_PRIMARY | XFS_SICK_INO_ZAPPED)));
+	ASSERT(!(mask & ~XFS_SICK_INO_ALL));
 
 	spin_lock(&ip->i_flags_lock);
 	ip->i_checked |= mask;
@@ -316,11 +322,13 @@ xfs_inode_mark_healthy(
 	struct xfs_inode	*ip,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~(XFS_SICK_INO_PRIMARY | XFS_SICK_INO_ZAPPED)));
+	ASSERT(!(mask & ~XFS_SICK_INO_ALL));
 	trace_xfs_inode_mark_healthy(ip, mask);
 
 	spin_lock(&ip->i_flags_lock);
 	ip->i_sick &= ~mask;
+	if (!(ip->i_sick & XFS_SICK_INO_PRIMARY))
+		ip->i_sick &= ~XFS_SICK_INO_SECONDARY;
 	ip->i_checked |= mask;
 	spin_unlock(&ip->i_flags_lock);
 }

