Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654F8BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bKLJU0oX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC82C433C7;
	Sun, 31 Dec 2023 20:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055459;
	bh=HlO85w5BxoV7fgeIj6VcPX1V5bCrIoQqXb+AbBMvR1U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bKLJU0oX0QpgOJiV0Zo1nvoqTt1fSw6lilTr//jW5c7LIi80hzupA4IyyE4diLnui
	 b4JzwFJkPUFJjyVq49f0z0MvVdfmdeo066Xc0HelQQEJKZOJJCuTsDWuG2tpYwNSgS
	 D7lIKZ0WT4C+5l8J8O17qdZGjJmWHeBhxQFYtVWFq4pbvVPmYTG2QCWS8reppCtOfp
	 Z3p2yGIB3SJCUdTj+lmgISyHwJgFOU1DwtydfgUAQe/g1CK+alHLG9EBPz5uXsTNls
	 eV6Dx0DkEjnT3kQpKVWZGQj3orTJMs5SCNSCOolsl/i2CIpahdS38KQ6BDBOasIZYm
	 jBl6onP67nA7w==
Date: Sun, 31 Dec 2023 12:44:19 -0800
Subject: [PATCH 5/7] xfs: Hold inode locks in xfs_rename
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <170404839985.1756291.7926651650147944817.stgit@frogsfrogsfrogs>
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

Modify xfs_rename to hold all inode locks across a rename operation
We will need this later when we add parent pointers

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 606d0aec9b450..88e0e93ded2e4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2806,6 +2806,21 @@ xfs_remove(
 	return error;
 }
 
+static inline void
+xfs_iunlock_rename(
+	struct xfs_inode	**i_tab,
+	int			num_inodes)
+{
+	int			i;
+
+	for (i = num_inodes - 1; i >= 0; i--) {
+		/* Skip duplicate inodes if src and target dps are the same */
+		if (!i_tab[i] || (i > 0 && i_tab[i] == i_tab[i - 1]))
+			continue;
+		xfs_iunlock(i_tab[i], XFS_ILOCK_EXCL);
+	}
+}
+
 /*
  * Enter all inodes for a rename transaction into a sorted array.
  */
@@ -3115,8 +3130,10 @@ xfs_rename(
 	 * Attach the dquots to the inodes
 	 */
 	error = xfs_qm_vop_rename_dqattach(inodes);
-	if (error)
-		goto out_trans_cancel;
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out_release_wip;
+	}
 
 	/*
 	 * Lock all the participating inodes. Depending upon whether
@@ -3127,18 +3144,16 @@ xfs_rename(
 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
 
 	/*
-	 * Join all the inodes to the transaction. From this point on,
-	 * we can rely on either trans_commit or trans_cancel to unlock
-	 * them.
+	 * Join all the inodes to the transaction.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, 0);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, 0);
+	xfs_trans_ijoin(tp, src_ip, 0);
 	if (target_ip)
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_ip, 0);
 	if (wip)
-		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, wip, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -3152,10 +3167,13 @@ xfs_rename(
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
+		xfs_iunlock_rename(inodes, num_inodes);
+		return error;
+	}
 
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
@@ -3169,6 +3187,7 @@ xfs_rename(
 		if (error == -EDQUOT || error == -ENOSPC) {
 			if (!retried) {
 				xfs_trans_cancel(tp);
+				xfs_iunlock_rename(inodes, num_inodes);
 				xfs_blockgc_free_quota(target_dp, 0);
 				retried = true;
 				goto retry;
@@ -3395,12 +3414,14 @@ xfs_rename(
 		xfs_dir_update_hook(src_dp, wip, 1, src_name);
 
 	error = xfs_finish_rename(tp);
+	xfs_iunlock_rename(inodes, num_inodes);
 	if (wip)
 		xfs_irele(wip);
 	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+	xfs_iunlock_rename(inodes, num_inodes);
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);

