Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5261373
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300686; cv=none; b=OlVB9Y5grnzrMaXEyulG7qC7g78IgGFteIB0VXpNIK7UM9vbCyt1MFYMzCiI04z0LPQ9yasn5l68aHOkzJfJmJbbxjzQkv680QghyqM2TsQu2HfRyTNaC+X9s+1nFeY/F4weCACBOlNVHt9Z9Bq5QKzxcafgew3uXSs/B6846y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300686; c=relaxed/simple;
	bh=CY9MehgVyxEs1R462SS9fNdXDlf9A+7SFrTrgNmo6c0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=beb6+OWCztZWpzUZXJM+SvJpRcqeFw9F61UB3czVbcffkoA7c0xTe7AFsNe9TzyqaZNbjC6UP0l04WjgexlGtNv0vu2yxC5rU7zgWJ6eFuaTrZHPWCub2GYlEVmmgB2gs9HAlhQS6WAwmPUqCib8nrABAXO734A8RDJga643YUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LrTLmIwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LrTLmIwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0205FC32786;
	Tue, 30 Jul 2024 00:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300686;
	bh=CY9MehgVyxEs1R462SS9fNdXDlf9A+7SFrTrgNmo6c0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LrTLmIwb+JAWxHaMghSmgrWkgdnLg9GeIfBwEFLWt1m5ZkYJ9mIc+c9WzjzMJa0BJ
	 ugpQN6G0OJ926IiRdWx+Ew54GSNTauWo4NJ0y1gvBHsG4JqUWeCTw7dfiXggDZ8WUi
	 n1WxA4HQBhPLl5m3uw6ERX7A/u6hWfx/e9aDuTFOwo9ZwQWxy1p3BvtO3ok2UuoH4i
	 clbEK+lNPe/SNka87xa0Uz2YczgXIySBgGZpM1EYlP+Pcjq7/F9Qsen8jVED0WK6G7
	 29Gkkt58UgfKPnd+LjqGXd3TfEwBW4gArt4/UVZJcf9ht7l6euWieJIkgtVvUFk9Ko
	 JvTMh/J1G+Adw==
Date: Mon, 29 Jul 2024 17:51:25 -0700
Subject: [PATCH 106/115] xfs: xfs_quota_unreserve_blkres can't fail
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843941.1338752.15359927679279017373.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: cc3c92e7e79eb5f7f3ec4d5790ade384b7d294f7

Unreserving quotas can't fail due to quota limits, and we'll notice a
shut down file system a bit later in all the callers anyway.  Return
void and remove the error checking and propagation in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |   16 +++++-----------
 libxfs/xfs_bmap.h |    2 +-
 2 files changed, 6 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index e6d700138..4a365f1a1 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4922,7 +4922,7 @@ xfs_bmap_split_indlen(
 	*indlen2 = len2;
 }
 
-int
+void
 xfs_bmap_del_extent_delay(
 	struct xfs_inode	*ip,
 	int			whichfork,
@@ -4938,7 +4938,6 @@ xfs_bmap_del_extent_delay(
 	xfs_filblks_t		got_indlen, new_indlen, stolen = 0;
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	uint64_t		fdblocks;
-	int			error = 0;
 	bool			isrt;
 
 	XFS_STATS_INC(mp, xs_del_exlist);
@@ -4958,9 +4957,7 @@ xfs_bmap_del_extent_delay(
 	 * sb counters as we might have to borrow some blocks for the
 	 * indirect block accounting.
 	 */
-	error = xfs_quota_unreserve_blkres(ip, del->br_blockcount);
-	if (error)
-		return error;
+	xfs_quota_unreserve_blkres(ip, del->br_blockcount);
 	ip->i_delayed_blks -= del->br_blockcount;
 
 	if (got->br_startoff == del->br_startoff)
@@ -5058,7 +5055,6 @@ xfs_bmap_del_extent_delay(
 
 	xfs_add_fdblocks(mp, fdblocks);
 	xfs_mod_delalloc(ip, -(int64_t)del->br_blockcount, -da_diff);
-	return error;
 }
 
 void
@@ -5616,18 +5612,16 @@ __xfs_bunmapi(
 
 delete:
 		if (wasdel) {
-			error = xfs_bmap_del_extent_delay(ip, whichfork, &icur,
-					&got, &del);
+			xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del);
 		} else {
 			error = xfs_bmap_del_extent_real(ip, tp, &icur, cur,
 					&del, &tmp_logflags, whichfork,
 					flags);
 			logflags |= tmp_logflags;
+			if (error)
+				goto error0;
 		}
 
-		if (error)
-			goto error0;
-
 		end = del.br_startoff - 1;
 nodelete:
 		/*
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index e98849eb9..667b0c2b3 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -202,7 +202,7 @@ int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
 		xfs_extnum_t nexts, int *done);
-int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
+void	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
 		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
 		struct xfs_bmbt_irec *del);
 void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,

