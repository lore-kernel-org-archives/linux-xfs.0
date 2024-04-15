Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9042159900
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225527; cv=none; b=SicEe7Zl4K6IFgQAaEJDzqTp6Rotp7h+wRwpRNC9M3oJ0QSJ2WqPrcKUjKX+gTk9FIl1K9NJ5F5E8+h07FpV7rGPWNs9G7MvHSAW8pW6ECxW5JoD7W3I63/HEKYynjulzhfyLkXQIeoR9ZxLEdx+As/etdOP5E5/tSLkmfD9Ctg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225527; c=relaxed/simple;
	bh=QTD9c/J0GO64cyezJ/XsuNtaXneLOG46AQWdB+MiI38=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oai59ysYQVEB7bBMN2ejgsqQDOMEZsvAiEGn18qJqAO3BoKHi/xOsEoK7CGBKuCOryQNoDt50YuesjMEGqEnwZ7yJSf77EtcCUueGj/tAUUpw24lUnW5MpJ7gL2aHXZRiXQoJrVhPlnn/gp2tslde4VmXgPDndLcElJ51zsA3so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W6qNyWTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6qNyWTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E674C113CC;
	Mon, 15 Apr 2024 23:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225527;
	bh=QTD9c/J0GO64cyezJ/XsuNtaXneLOG46AQWdB+MiI38=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=W6qNyWTRuvABsTTAK9Uf77mIaDG76Wy1+leTP69/wxswWTyx2BZ1ZRaqCCYfwky5o
	 pDAd9MWsV2jepIiQls5mqTQly0+d3ilsEpbBu0v6KeAn+H/d2xiTV92eWswX1bEAfw
	 9Den1DyJbbTllMLq1eITsalNJiOPwddcvZcVxWHqfUD3nAfdfPb7gAp8VlplHCYGmN
	 D2RFA8aflJYZQ67KLleWZ7dJixraft2tNZ+BJ5JYyxqLVfQl7JdjREohy2JHnNlCzW
	 gbcqoRxaYEzqNlpNEYKDfTCGOFZirDQLHUsumywTiPfq1fhrCzwfMQQdmtn3XXcw2F
	 V/ZPnQctzFysw==
Date: Mon, 15 Apr 2024 16:58:46 -0700
Subject: [PATCH 5/7] xfs: Hold inode locks in xfs_rename
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, Christoph Hellwig <hch@lst.de>,
 hch@lst.de, allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171322386597.92087.12011283342897372633.stgit@frogsfrogsfrogs>
In-Reply-To: <171322386495.92087.3714112630678704273.stgit@frogsfrogsfrogs>
References: <171322386495.92087.3714112630678704273.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c |   45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 36e1012e156a..2aec7ab59aeb 100644
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

