Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37365CBD
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710129; cv=none; b=C0TgpkSfMjAEjS6fum+65tlUnwhMdMfVI0w/3Dv98aguLabUfZe7OX4Ou5vmWkR8XshfiWMfKgNWxwV3SqlggZ8woRVdxwhORnQiO6B7Xo5PrjZVV38YiEA3VCw4LYhjjSKPnEcz69KAXtjrgw7dNGXrqppToIF/PBxcdDYQazk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710129; c=relaxed/simple;
	bh=PRZ8vMEICfJM+Aexj9+ydXhbkREWMF/x/fENOoNSMgg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PraTDZRxeHKziO9ZeYNeqfQ0KTbFUDJhN8oNNZ/n1lzdGl1dDPH3AazVQXOA8w1VLD1mxP8NE25OKfKJgS+SNIaa0ps2OLhut2KYya7PXsrM9+q4+zGQ15K0aWelMRKsnmdEw//xTtPGALNmORCj7JrQE02W64FkexGEQFeOfT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8Bs+/GB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8Bs+/GB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B606C43390;
	Wed, 10 Apr 2024 00:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710129;
	bh=PRZ8vMEICfJM+Aexj9+ydXhbkREWMF/x/fENOoNSMgg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X8Bs+/GBpUqVGoWA4l7s8jxe5AsSPrZR2SYoYv5cmFQT19l3mn5bMJK48jjdqCy4M
	 B0RszQVRRTFFSCZ+2RMVDy5RCE7neSKYtUCMI3NUerq1t9dxCTOyVCJAlBCtzwSPMa
	 09Q7x5zQ+63yZ0CtaDFDpHtmSP4NaeJKtMPp4Ysqpr0bn3VllXqQZEf1EO+hU9GSSQ
	 7ezVCVmAF6stV7t785I1BXWTc9ht8po9p6o0EZmAj7k4tpui6veXh9uAtzxfmFUw91
	 JTxcNExk0oa1eJBAZRcighxcReiPPtd//eTCmRqJgs3p5uqtPfdhjWT7XBPIyotr4e
	 l0LT1NtQGgq8A==
Date: Tue, 09 Apr 2024 17:48:49 -0700
Subject: [PATCH 5/7] xfs: Hold inode locks in xfs_rename
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, catherine.hoang@oracle.com,
 hch@lst.de, allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <171270967988.3631167.14801470316616286607.stgit@frogsfrogsfrogs>
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
index 36e1012e156a1..2aec7ab59aeb7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2804,6 +2804,21 @@ xfs_remove(
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
@@ -3113,8 +3128,10 @@ xfs_rename(
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
@@ -3125,18 +3142,16 @@ xfs_rename(
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
@@ -3150,10 +3165,13 @@ xfs_rename(
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
@@ -3167,6 +3185,7 @@ xfs_rename(
 		if (error == -EDQUOT || error == -ENOSPC) {
 			if (!retried) {
 				xfs_trans_cancel(tp);
+				xfs_iunlock_rename(inodes, num_inodes);
 				xfs_blockgc_free_quota(target_dp, 0);
 				retried = true;
 				goto retry;
@@ -3393,12 +3412,14 @@ xfs_rename(
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

