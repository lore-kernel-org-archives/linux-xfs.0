Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60111BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUxtTpJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9232C433C7;
	Sun, 31 Dec 2023 20:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054520;
	bh=PGofWGIaGYlPXHORIE1VhZEH4zZXsAsDGqG7wuTtpm4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OUxtTpJ/ApGX0q4jEjegL26CD7oYBAk/f1Ni4B8c4SaUFvrL7SgB+9oW/1ZzUuK7r
	 +mRs4zBu6OoQSscTLKHP8sp1rcqW3SoWGmnIa2F3qaFwWnNqyBbEdoSnmLQQlQZvGn
	 7XD6Noevn0IbAM8Smp0l3JJJH399mL8+VDCqQUYIup88CDxaQX/6yLekaEw0xRVa7F
	 RjDNkbURp+t4tq5nO0aKxSWRjJ338Nd2mvcA9U256fQ1TtYbSXD3iwuQxEIpmHshZw
	 duF+6BD1KGWdEXeG/OH+C7OCSHHjjWEUiGFCByJ/k8HYI5kuxhsG/upaVLAcdhQLXX
	 o8jUdRYIvKyuA==
Date: Sun, 31 Dec 2023 12:28:40 -0800
Subject: [PATCH 17/25] xfs: port xfs_swap_extent_forks to use xfs_swapext_req
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833414.1750288.10005619366030146179.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
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

Port the old extent fork swapping function to take a xfs_swapext_req as
input, which aligns it with the new fiexchange interface.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0056bee7ca1d6..c6d8d061c998b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1400,9 +1400,10 @@ xfs_swap_change_owner(
 STATIC int
 xfs_swap_extent_forks(
 	struct xfs_trans	**tpp,
-	struct xfs_inode	*ip,
-	struct xfs_inode	*tip)
+	struct xfs_swapext_req	*req)
 {
+	struct xfs_inode	*ip = req->ip2;
+	struct xfs_inode	*tip = req->ip1;
 	xfs_filblks_t		aforkblks = 0;
 	xfs_filblks_t		taforkblks = 0;
 	xfs_extnum_t		junk;
@@ -1550,6 +1551,11 @@ xfs_swap_extents(
 	struct xfs_inode	*tip,	/* tmp inode */
 	struct xfs_swapext	*sxp)
 {
+	struct xfs_swapext_req	req = {
+		.ip1		= tip,
+		.ip2		= ip,
+		.whichfork	= XFS_DATA_FORK,
+	};
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	struct xfs_bstat	*sbp = &sxp->sx_stat;
@@ -1686,19 +1692,12 @@ xfs_swap_extents(
 	 * recovery is going to see the fork as owned by the swapped inode,
 	 * not the pre-swapped inodes.
 	 */
+	req.blockcount = XFS_B_TO_FSB(ip->i_mount, i_size_read(VFS_I(ip)));
 	if (xfs_has_rmapbt(mp)) {
-		struct xfs_swapext_req	req = {
-			.ip1		= tip,
-			.ip2		= ip,
-			.whichfork	= XFS_DATA_FORK,
-			.blockcount	= XFS_B_TO_FSB(ip->i_mount,
-						       i_size_read(VFS_I(ip))),
-		};
-
 		xfs_swapext(tp, &req);
 		error = xfs_defer_finish(&tp);
 	} else
-		error = xfs_swap_extent_forks(&tp, ip, tip);
+		error = xfs_swap_extent_forks(&tp, &req);
 	if (error) {
 		trace_xfs_swap_extent_error(ip, error, _THIS_IP_);
 		goto out_trans_cancel;

