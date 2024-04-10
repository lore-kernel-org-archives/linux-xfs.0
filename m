Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D3839B
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711241; cv=none; b=LfcoIybL/W32SFO3GJYgYuFrscJBTcrL3kTv4DVrwZySJA3yKcNPrzMEA66zaI5cjJu9RZNmdfh8Q3E3p7b1EnkEQv7sv9/KrLMcIgQzTo6IahjOc33HJyxaqrSwt4mid9+ZodOB+DBBRINKNVyJzwejFiGQQ6+uuBaYg4HoK9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711241; c=relaxed/simple;
	bh=Zr7Fk5hMk4wHWUH8rlThfcxPP+uINsQFQlNtqIiOv2s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iz4uR4ScPQz/ynVhGdXi6t7KhmUWjQSJySXcjraFLXeV1ks4aSaVDQWtmSsJMseUTjecvMzjSoUJoepGbHL9wSjzIV6bUv2G6UVH0cpxK2MsLbPttBMlH6kA8Nyn3JpuIPhnyNDL1BtuiQ0Xh0Qqq1LXov1+1U8ljsBmM/JpaDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rTJ/FDoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rTJ/FDoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C239AC433F1;
	Wed, 10 Apr 2024 01:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712711240;
	bh=Zr7Fk5hMk4wHWUH8rlThfcxPP+uINsQFQlNtqIiOv2s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rTJ/FDoT/4m1qNAnVsfjsTdqj0tabRxgYJSle3aOD/7D3v1mu1thefsH5gVEG18jx
	 6YvShavkFu/LOlWzUMtWVvT5DYiXPL72N5k2VuKRtVtL+6RZIVl9Mk8N/GFBV5E3LW
	 +OBj3fYNvwNVAlPzp/0P9d4ZCQR01A7JTSqR/7wxd9/10CkAJWgh1NBhJpd5JAsmdR
	 yQ69X+ADhRSf5+COhm8QVaxa0FnAlZ1n+entOOmOomlS6id6ijzOsXiv5soWE35gXL
	 Anorbylct02817P8dU7WfSZVrfSsOx0CSbJSpc12j5EXUijWqHi4BuLYxCzo48Fzbd
	 1UCmUuDXR5vXg==
Date: Tue, 09 Apr 2024 18:07:20 -0700
Subject: [PATCH 14/14] xfs: inode repair should ensure there's an attr fork to
 store parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270971220.3632937.18307837789023273828.stgit@frogsfrogsfrogs>
In-Reply-To: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
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

