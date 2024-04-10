Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3C237C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710067; cv=none; b=akoxWmSkM7dJZeD61mKGOSzrJqiM9iQotKhpHQ9LdHGvWprDuFYDB4M3yK2qf7rHGlpf0LGOWGNUxBHDRrWuh9oz00ssWe1lT4qLh1ksrc7kej/l6hx1MZitGaESWyUL9EpFrZwh+2mGO/FetZhANSMxEeyDUc6LW/i93ANQl8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710067; c=relaxed/simple;
	bh=phK99IXpkZSMy7HkWAf5G44jlrAWRsOSYiW4j/R4D5k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EnAuEnAY7+Apsok+Z5Y6OYZImT69U5gFBjiFSnthyvRoqPWBMKCUGjI4v+NO7F6fXU8ZSvtALvl9aXlcQ/l+VS7p/KmJN/rMUB82vRJ/DrIbVeq4kMAZWHs4L4Z8JUzzQ/U4Cvh1AaRTTMWqoi0+sUVzLgAKUqHetuCUYKpKaEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qbVAo1/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qbVAo1/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1422BC433F1;
	Wed, 10 Apr 2024 00:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710067;
	bh=phK99IXpkZSMy7HkWAf5G44jlrAWRsOSYiW4j/R4D5k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qbVAo1/SmA553PAIm2W8p0MjMsr//OoqPGUIwxzOYDJTZIsK6htN7QoL8IbMuqoUs
	 kCkPekudLXFk7FiM3ccqwmnfnZsUPuXMdwZKrLyH6R8FzJDKAfdjSZ4SgiWmCPDRFl
	 RcqnR0ADDZJ5IG2VKrf+wUDoOmOwbvDg/XTWm2qqM19W+RQ2t3N+oywpKZEC2T3EGc
	 h/SeadfHBDmF5CttdAgNFFFzFFCjtb/OJRXKNVGTkT4lH91g474O2lnwdS7B+VTlCq
	 JoobS0hJ/s+zryA7vGJjfhCRtpIXeOCv2ZY17cgJBXfCynPhFK3LsyKCqj7gK3G4Zk
	 OGGiiUmZ0JaOQ==
Date: Tue, 09 Apr 2024 17:47:46 -0700
Subject: [PATCH 1/7] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, catherine.hoang@oracle.com,
 hch@lst.de, allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <171270967922.3631167.6063402039662594735.stgit@frogsfrogsfrogs>
In-Reply-To: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
References: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
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
index 061cc01245a91..4a078e07e1a0a 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -1092,7 +1092,11 @@ xfs_defer_ops_continue(
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
index 81cca60d70a3b..8b338031e487c 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -77,7 +77,13 @@ extern const struct xfs_defer_op_type xfs_exchmaps_defer_type;
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
index 03dcb4ac04312..efd040094753f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -418,7 +418,7 @@ xfs_lock_inumorder(
  * lock more than one at a time, lockdep will report false positives saying we
  * have violated locking orders.
  */
-static void
+void
 xfs_lock_inodes(
 	struct xfs_inode	**ips,
 	int			inodes,
@@ -2802,7 +2802,7 @@ xfs_sort_for_rename(
 	struct xfs_inode	**i_tab,/* out: sorted array of inodes */
 	int			*num_inodes)  /* in/out: inodes in array */
 {
-	int			i, j;
+	int			i;
 
 	ASSERT(*num_inodes == __XFS_SORT_INODES);
 	memset(i_tab, 0, *num_inodes * sizeof(struct xfs_inode *));
@@ -2824,17 +2824,26 @@ xfs_sort_for_rename(
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
index c74c48bc09453..a6da1ab8ab136 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -627,6 +627,8 @@ int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_remapping(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
+void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
+void xfs_sort_inodes(struct xfs_inode **i_tab, unsigned int num_inodes);
 
 static inline bool
 xfs_inode_unlinked_incomplete(

