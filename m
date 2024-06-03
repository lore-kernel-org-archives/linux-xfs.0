Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1598013C83A
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441991; cv=none; b=P3qU9B/lTOjJgnTCDWZufaTAgLllLNUjN1NTO9Zjtcf8/8HfipY4EwGQmEnyrMn8h7ORHYVshkTnO3QS8UnS6MohLU3rRslZcUmRiCoEV1BXwr0YhaTybAYDPS6ZuqlBOcs0PreyIP1EqL1zHDawL2l0208fNhin6GXPHpI86cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441991; c=relaxed/simple;
	bh=kZiOkn/jIyZLxjqsuLHBtpoMO+oC3/LI/TmeDjjkf1w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tpDBZ3vEEKo0uGd5OeGc2FSLA0Bk85kgtBjWHdjxyubwK6tICljGhF2j8BGO6ewDMmJKtDp/DgqKAQX/MzToNNIzBnBl1JmfmCcb5yavbrs0zLmgPASSCrgX7H5yCauBYmVLDK6SCx9MKBMKgbLUQMfiHyjx/s5o13/mSsw4rYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/KWC8LQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/KWC8LQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8836FC2BD10;
	Mon,  3 Jun 2024 19:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441990;
	bh=kZiOkn/jIyZLxjqsuLHBtpoMO+oC3/LI/TmeDjjkf1w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U/KWC8LQkKzpGqmXINAmTSClLdtE5i8x8jCkj6lZCOsNsoCxpJOdGreAknsn4yC4e
	 zOy1lCk+XxF9EXN+8IUL8aEJ9wIo2tNXKuFLmC6xzPoHPxNkrBbFd4fhyEdnDyWDW2
	 9/kgfClKMI/l/2Kl2tSwE+Uw53LAc20Rt6HtwPFPhA3wYnaElCZkX4xR/8Hj0j110B
	 dPkiOZWubZWn+8sCZDjP05o83e/4zgSHFdLTGBODWAcgRa9mdI6PODS1GJtls94Wj8
	 /a6t40LtiThCCsZiAN7oEj7k+2p/jYwj/vfc7f+zX17lXbeQ8fn4PbZu5lCFDwDRJ8
	 w+XuMl3p1RAiA==
Date: Mon, 03 Jun 2024 12:13:10 -0700
Subject: [PATCH 081/111] xfs: tighten up validation of root block in inode
 forks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040587.1443973.5999687583339787279.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: d477f1749f00899c71605ea01aba0ce67e030471

Check that root blocks that sit in the inode fork and thus have a NULL
bp don't have siblings.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_btree.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 0b5002540..2f5848b9d 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -104,7 +104,7 @@ __xfs_btree_check_lblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_failaddr_t		fa;
-	xfs_fsblock_t		fsb = NULLFSBLOCK;
+	xfs_fsblock_t		fsb;
 
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -124,9 +124,19 @@ __xfs_btree_check_lblock(
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
 
-	if (bp)
-		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
+	/*
+	 * For inode-rooted btrees, the root block sits in the inode fork.  In
+	 * that case bp is NULL, and the block must not have any siblings.
+	 */
+	if (!bp) {
+		if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK))
+			return __this_address;
+		if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK))
+			return __this_address;
+		return NULL;
+	}
 
+	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 	fa = xfs_btree_check_lblock_siblings(mp, fsb, block->bb_u.l.bb_leftsib);
 	if (!fa)
 		fa = xfs_btree_check_lblock_siblings(mp, fsb,

