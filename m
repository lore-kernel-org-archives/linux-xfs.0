Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0BDBA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TQc9bZ6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A91C433C7;
	Sun, 31 Dec 2023 21:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059152;
	bh=2LcZaPwPmp6PFPdz+dYMQLgf1E19YPCw1kRIHfY+4Mw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TQc9bZ6vzX16Yki7R64GWi41MxN+bXpZ/cejv2c7NfyN+a/zUt+sNx34HHW6Bum03
	 qSekCqOb7AN/C35s5B563FdY3oIlGAvL0q+Sh310+6oE27gkTCTl0ZSeYyAKAAfsVq
	 I5k4Luv+6SydGtPhtRufUpx+aCoLAZsG+B31yvnpOAX7nZ47Wnh21PQo90mLnsLdIO
	 cao5bjFWJBvYNbNaqs6LfPyx8yf+DFAP19/8NiLLnuhWPBeb5dFRUQNUZk8f4Qm+wH
	 hDzbZ/jilnj5iUIr5vPV+R6QZ5lty+CDArqq+1fQNKbOXyUyVJKkWaWb3kZ56ZBMdq
	 3ZhjoblZEe/gw==
Date: Sun, 31 Dec 2023 13:45:52 -0800
Subject: [PATCH 05/44] xfs: realtime refcount btree transaction reservations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851663.1766284.16226171166478684089.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

Make sure that there's enough log reservation to handle mapping
and unmapping realtime extents.  We have to reserve enough space
to handle a split in the rtrefcountbt to add the record and a second
split in the regular refcountbt to record the rtrefcountbt split.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_resv.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 423b0cede71cb..5b42603de966f 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -93,6 +93,14 @@ xfs_refcountbt_block_count(
 	return num_ops * (2 * mp->m_refc_maxlevels - 1);
 }
 
+static unsigned int
+xfs_rtrefcountbt_block_count(
+	struct xfs_mount	*mp,
+	unsigned int		num_ops)
+{
+	return num_ops * (2 * mp->m_rtrefc_maxlevels - 1);
+}
+
 /*
  * Logging inodes is really tricksy. They are logged in memory format,
  * which means that what we write into the log doesn't directly translate into
@@ -260,10 +268,13 @@ xfs_rtalloc_block_count(
  * Compute the log reservation required to handle the refcount update
  * transaction.  Refcount updates are always done via deferred log items.
  *
- * This is calculated as:
+ * This is calculated as the max of:
  * Data device refcount updates (t1):
  *    the agfs of the ags containing the blocks: nr_ops * sector size
  *    the refcount btrees: nr_ops * 1 trees * (2 * max depth - 1) * block size
+ * Realtime refcount updates (t2);
+ *    the rt refcount inode
+ *    the rtrefcount btrees: nr_ops * 1 trees * (2 * max depth - 1) * block size
  */
 static unsigned int
 xfs_calc_refcountbt_reservation(
@@ -271,12 +282,20 @@ xfs_calc_refcountbt_reservation(
 	unsigned int		nr_ops)
 {
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
+	unsigned int		t1, t2 = 0;
 
 	if (!xfs_has_reflink(mp))
 		return 0;
 
-	return xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
-	       xfs_calc_buf_res(xfs_refcountbt_block_count(mp, nr_ops), blksz);
+	t1 = xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_refcountbt_block_count(mp, nr_ops), blksz);
+
+	if (xfs_has_realtime(mp))
+		t2 = xfs_calc_inode_res(mp, 1) +
+		     xfs_calc_buf_res(xfs_rtrefcountbt_block_count(mp, nr_ops),
+				     blksz);
+
+	return max(t1, t2);
 }
 
 /*

