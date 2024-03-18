Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE5759B59
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798762; cv=none; b=f5x9NoJya2NjPLvvplFLvIvF0SooPB38cyugFLgRCZnVqoGw/zUZYdVkiSXO3IB8clbPdedifIZkVjAjVcuqsmdhvMlj81sJtQzoaAlDS2y+EIXUY6AIgUmmdPQ+RxrXnMV7moIeocAqt5rCNM2wK5bkwlEXQIloBKCQAs5b1os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798762; c=relaxed/simple;
	bh=U6LUTDr5PlJPPF0lYMdsEhul32QE7xVYoJfkI5n3ZMY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p+PXXhrCwatA+Ry1y3ni921215jXht7c5HOGPKiUzueApfifrNk8qdYRbfWz66QeXtYCcfdhXZ0R7Oaj7BMRhnOM3Y39+sHnVioP9XdQHk1DFRy5g+xTCCwVEMhUpmV2qVWJIENW20R67n7dxElg1bhjI5ZC+wUPwQ7QWoeiPTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNpLxaKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNpLxaKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA51CC43390;
	Mon, 18 Mar 2024 21:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798761;
	bh=U6LUTDr5PlJPPF0lYMdsEhul32QE7xVYoJfkI5n3ZMY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oNpLxaKeLyF3ghd25MhkeMVI4AiVlBoP+gF5cdKUZzXTbaLKBERIal9fiJIYhpWx4
	 yh3scUbjsholsxjA8gnFXFkUuw6JApIspLKm+aL0C/QzAdfqweR8FLGdJaXyAJ1Tuw
	 XarSgYpG6a2s8IlXtkCn5LYi0bnOoNQD+H8vg6SHxrPMGx7BfY/IPRaEt6zI4bKpTh
	 4pzDpHWkhX0MlMZZuKykRzBgbTil9RM+ZJORiFR9iHzekKPLTr72hqW9LmvOT/wWn7
	 +RQagp9MgkdTxJHZHaasfc9fRd/dhq6sNOXCA17ogWbuKk7E95TjGtF0Z48nAiF3VB
	 9GpRgbUTgM2gg==
Date: Mon, 18 Mar 2024 14:52:41 -0700
Subject: [PATCH 18/23] xfs: remove pointless unlocked assertion
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802987.3808642.3331549961106067929.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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

Remove this assertion about the inode not having an attr fork from
xfs_bmap_add_attrfork because the function handles that case just fine.
Weirder still, the function actually /requires/ the caller not to hold
the ILOCK, which means that its accesses are not stabilized.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e9e8b7338f220..83cbefc54e1f3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1041,8 +1041,6 @@ xfs_bmap_add_attrfork(
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
 
-	ASSERT(xfs_inode_has_attr_fork(ip) == 0);
-
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 

