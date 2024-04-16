Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BC5539C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231623; cv=none; b=naoVOmp/XCFXHyY6aB6QssxmzJ3L4SZ4uEmnHVI80NTxbeJzVmD66JK30icM9ntBsFVN/WahOAW6EzP6Y4ImuDC62bwg/OhOlTeUKPJxqo2PFqH/k/Ca5GeWBVJ4BweJ/qHZU8KdyBNlvWy5f8XshJ8sZHcZmEumMTe4ksN5QsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231623; c=relaxed/simple;
	bh=SJzOxMXrkZLLXLjdKF3/XHh1uC3NeCg9KX6bnlxvq7U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OuAyhWnsLmmmiGpDmBpiiTSv/3Q5MssCTe+VRVL/O/E7nHOmxmUoanZai7eD4cJtD6syo5NCgQPiOp2fHiU+ftQ9L6z6MPKjA3MaR9mzij2QkLAzvIHME147Uvf3xddDP62NG4OakDrxfGuaVY+RmROZwyRWm4LejLzAATbcBsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WZS5zGWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WZS5zGWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1467EC113CC;
	Tue, 16 Apr 2024 01:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231623;
	bh=SJzOxMXrkZLLXLjdKF3/XHh1uC3NeCg9KX6bnlxvq7U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WZS5zGWdtd4eQ4pG2vTrGhpuFsSufNW8rcz2/yN8LuUEsvOAfdF9tosQ0VHA44SNw
	 TMBwuQhKHRmULHfDtBEpLaKb1KF/A3BYyzglcVLhq88wSR+tgr52IK6J64alJDQbiT
	 cbkCEBUMB1f6usHha/w5nmz0xoWGdS6q/LIeVS5UqAsa/bnig2GoCxETYmb0EUU7RB
	 ZdgEtB/UY2MGA7Pi/1uj9sQidwBmWb6KR3y+X1G+bj5wciFcad5rNMS3O8Ty9lHjdu
	 yUMoyFW/Z5kOCs67wtyUWjbJ9TgtEtls75Wd3QtaYhdV9dx7mSUe+hPIB88uQq4ldM
	 W0TFKLV7JHDSQ==
Date: Mon, 15 Apr 2024 18:40:22 -0700
Subject: [PATCH 17/17] xfs: inode repair should ensure there's an attr fork to
 store parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323029459.253068.17231638937736352624.stgit@frogsfrogsfrogs>
In-Reply-To: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
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

The runtime parent pointer update code expects that any file being moved
around the directory tree already has an attr fork.  However, if we had
to rebuild an inode core record, there's a chance that we zeroed forkoff
as part of the inode to pass the iget verifiers.

Therefore, if we performed any repairs on an inode core, ensure that the
inode has a nonzero forkoff before unlocking the inode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode_repair.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index e3b74ea50fdef..daf9f1ee7c2cb 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1736,6 +1736,44 @@ xrep_inode_extsize(
 	}
 }
 
+/* Ensure this file has an attr fork if it needs to hold a parent pointer. */
+STATIC int
+xrep_inode_pptr(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_inode	*ip = sc->ip;
+	struct inode		*inode = VFS_I(ip);
+
+	if (!xfs_has_parent(mp))
+		return 0;
+
+	/*
+	 * Unlinked inodes that cannot be added to the directory tree will not
+	 * have a parent pointer.
+	 */
+	if (inode->i_nlink == 0 && !(inode->i_state & I_LINKABLE))
+		return 0;
+
+	/* The root directory doesn't have a parent pointer. */
+	if (ip == mp->m_rootip)
+		return 0;
+
+	/*
+	 * Metadata inodes are rooted in the superblock and do not have any
+	 * parents.
+	 */
+	if (xfs_is_metadata_inode(ip))
+		return 0;
+
+	/* Inode already has an attr fork; no further work possible here. */
+	if (xfs_inode_has_attr_fork(ip))
+		return 0;
+
+	return xfs_bmap_add_attrfork(sc->tp, ip,
+			sizeof(struct xfs_attr_sf_hdr), true);
+}
+
 /* Fix any irregularities in an inode that the verifiers don't catch. */
 STATIC int
 xrep_inode_problems(
@@ -1744,6 +1782,9 @@ xrep_inode_problems(
 	int			error;
 
 	error = xrep_inode_blockcounts(sc);
+	if (error)
+		return error;
+	error = xrep_inode_pptr(sc);
 	if (error)
 		return error;
 	xrep_inode_timestamps(sc->ip);

