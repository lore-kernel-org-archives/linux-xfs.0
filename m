Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E68381AB
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591542; cv=none; b=LTD5KUZhyR+rVaFA/CRMZ+LeSe0zczUv5kMbbqwwvRvZintIcFpfe87uvxxkSXGyOpuaiRNigR+rQLc8v0Du7BVkShDohjSl4+yC8Lb2x6HMEbb6Uht7TKlReXjDoym6tyWqI6aGSqJQ01QatJ7DzO24Zk1VAgRIcp+8L5N9Le4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591542; c=relaxed/simple;
	bh=/4dsg3KQZPmlo7U6i/x6ZchlHIHzWK+6fjphmqVFj98=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BdmzaJMyKGMHc0qlLcVeTaG8t8T/DOql0GIhdpuhh7NsUcN3qvNw48Vr3PYfIdUiC66iJ5HZnMdcXIrbfF88jIzXNE8dNL/5eGEyPT4CXrSr5puDauUWfMqTzx536hXrr2zNaOnGhLJkCU8LrBtOjhsm5/gO3GKHt4EKmsefNGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ou41jpeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ou41jpeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CA6C433F1;
	Tue, 30 Jan 2024 05:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591541;
	bh=/4dsg3KQZPmlo7U6i/x6ZchlHIHzWK+6fjphmqVFj98=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ou41jpeRoH/a9X7T9LSElJOuzSv1bpaVt3U/4zQbJDBYQDZhp8xt5c4dqz/ihyrKU
	 WvFyFo/7t2S80vo4iqVozKZeCPPwkBePVCtk6vzn+VqghlT+ZAk//ZKEFp6so6DYCD
	 P+NurgHoNh3Zm9eRgeIXMr9hahG8lEnsB0HzUmCgvlbp1Yp1E7PSp0kAYoqdFWcls1
	 UmAfy6ofMbsB7/Sf4uEyllI9U99wgKb25jD1t4NNfbSICUuxl+iYv0OyroGj+1YLUG
	 dGp5Wa5TGWwbLK3qncz4qYwPerzomBjuYE4d8ia1SanWWOgt8yEERlpJiniNFMokWA
	 HtVBXxHXxCj2g==
Date: Mon, 29 Jan 2024 21:12:21 -0800
Subject: [PATCH 1/3] xfs: add secondary and indirect classes to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659064287.3354229.18115067091726205547.stgit@frogsfrogsfrogs>
In-Reply-To: <170659064262.3354229.596649174411799386.stgit@frogsfrogsfrogs>
References: <170659064262.3354229.596649174411799386.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

