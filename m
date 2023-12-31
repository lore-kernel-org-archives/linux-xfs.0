Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68360BA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fGeHP9V+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F16C433C8;
	Sun, 31 Dec 2023 20:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055397;
	bh=Yeqj97Zmj17nRw5yusJaYJeTNRffB2CoeAkxGmy5srg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fGeHP9V+zXNnM/18924u1ODCSwP6Ru0gD7LQga10PZxfufJs9SrLC+YWUNfzFaoIf
	 gttN7vN/x4cU4nVrWeaQSo4VYQVcqO04JOMTbwmTRvKLO92bBNY9+rTUzHktVtH9c1
	 4j/iHLvyBIegPNTsqSTkfdaat1VEJVHOc/mNqYk1k6i2sdQzSp2Yx2/4oauNKrMlwW
	 zfWjW2wxXX7/FaSLzPlIKRm6eeA1iGwXxgLAZuAc5bTXEuocA63cn43mJNR8iOFmeQ
	 eKhTlvBJE/EvYsiM9oH7Zfk8zTLG0K5FRezj449SFBdmBiPv/xVeJes/Xdlp3yGvn1
	 oL4tAn6pqPRNQ==
Date: Sun, 31 Dec 2023 12:43:16 -0800
Subject: [PATCH 1/7] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <170404839920.1756291.1075214851131703543.stgit@frogsfrogsfrogs>
In-Reply-To: <170404839888.1756291.10910474860265774109.stgit@frogsfrogsfrogs>
References: <170404839888.1756291.10910474860265774109.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
[djwong: have one sorting function]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c |    6 +++++-
 fs/xfs/libxfs/xfs_defer.h |    8 +++++++-
 fs/xfs/xfs_inode.c        |   27 ++++++++++++++++++---------
 fs/xfs/xfs_inode.h        |    2 ++
 4 files changed, 32 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index f77b2eaaa1b0d..8788f9f3f19ec 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -1096,7 +1096,11 @@ xfs_defer_ops_continue(
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		xfs_sort_inodes(dfc->dfc_held.dr_ip, dfc->dfc_held.dr_inos);
+		xfs_lock_inodes(dfc->dfc_held.dr_ip, dfc->dfc_held.dr_inos,
+				XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index e3cf81bafca3e..c9a1fe3fe363e 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -77,7 +77,13 @@ extern const struct xfs_defer_op_type xfs_swapext_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with deferred ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 71640afc3a8ee..6ff3d2cab5802 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -440,7 +440,7 @@ xfs_lock_inumorder(
  * lock more than one at a time, lockdep will report false positives saying we
  * have violated locking orders.
  */
-static void
+void
 xfs_lock_inodes(
 	struct xfs_inode	**ips,
 	int			inodes,
@@ -2804,7 +2804,7 @@ xfs_sort_for_rename(
 	struct xfs_inode	**i_tab,/* out: sorted array of inodes */
 	int			*num_inodes)  /* in/out: inodes in array */
 {
-	int			i, j;
+	int			i;
 
 	ASSERT(*num_inodes == __XFS_SORT_INODES);
 	memset(i_tab, 0, *num_inodes * sizeof(struct xfs_inode *));
@@ -2826,17 +2826,26 @@ xfs_sort_for_rename(
 		i_tab[i++] = wip;
 	*num_inodes = i;
 
+	xfs_sort_inodes(i_tab, *num_inodes);
+}
+
+void
+xfs_sort_inodes(
+	struct xfs_inode	**i_tab,
+	unsigned int		num_inodes)
+{
+	int			i, j;
+
+	ASSERT(num_inodes <= __XFS_SORT_INODES);
+
 	/*
 	 * Sort the elements via bubble sort.  (Remember, there are at
 	 * most 5 elements to sort, so this is adequate.)
 	 */
-	for (i = 0; i < *num_inodes; i++) {
-		for (j = 1; j < *num_inodes; j++) {
-			if (i_tab[j]->i_ino < i_tab[j-1]->i_ino) {
-				struct xfs_inode *temp = i_tab[j];
-				i_tab[j] = i_tab[j-1];
-				i_tab[j-1] = temp;
-			}
+	for (i = 0; i < num_inodes; i++) {
+		for (j = 1; j < num_inodes; j++) {
+			if (i_tab[j]->i_ino < i_tab[j-1]->i_ino)
+				swap(i_tab[j], i_tab[j - 1]);
 		}
 	}
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 8f0dccb0361d7..4826155ad9147 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -623,6 +623,8 @@ int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_remapping(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
+void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
+void xfs_sort_inodes(struct xfs_inode **i_tab, unsigned int num_inodes);
 
 static inline bool
 xfs_inode_unlinked_incomplete(

