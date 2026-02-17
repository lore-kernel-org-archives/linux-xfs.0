Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644CB221FCF;
	Tue, 17 Feb 2026 23:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370474; cv=none; b=UMr4TXWg4MCixhUSjP661lXzlVCg/UP0EMqlue2ZDPoZzuv9DPywTaPuBXhMZesA56WdnPgQ2/ToLPgVGyNGOOjuojhkVmQJCYR0zI+dd7NuujkE1PiT3SzIm2qehrJua5+nS7XvodRgd4pbqRBSDsjCgt1a2+e+OoNOXioP1Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370474; c=relaxed/simple;
	bh=6I8gvUxuvD5MPz5tuGeJL3nBgsfVh7JOTSYnZJgR6+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWvW9NSyD/N903HQ6/Lx5D/vpWvctD6XQjFxiMeeagli/t4nmmqzj6lF9GjV0Js26FgOO9Z4d2B1HiB9wMGCSRuttRffLknm5B9sHWgzLs/jnRInm5+Hui5VpU2bkQtVIG4V4ESY8uxWuvo/LCa5zMutivMAxftoiX41LwTDpTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LuTR+z3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LuTR+z3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FA7C19421;
	Tue, 17 Feb 2026 23:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771370474;
	bh=6I8gvUxuvD5MPz5tuGeJL3nBgsfVh7JOTSYnZJgR6+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuTR+z3tSNs9JdFkCnwoHJpJq/AfoPpZkDlABZcGtVpuUDDWFY0CxOHeUUIOoUPgr
	 23wkDZYEhCdHI8AZPtTFMDkLK6GzRGajh4v8B5uPRUiP1140CRUmGsHY4gGn5/23kX
	 VlpIyecaFzvlVsUcetz3pNZ/WJpVx9w404TZ3urtqvq3pWDw6dgVlqIk2e49QVIT2n
	 Eyc9ECFr0M06xvuXsqcKAP043lJGwmuHLP+bPywvYyK5kxc6dVyDWoKOS5TK+1zDHf
	 mFCR6Auhhys8mxst1uOd+wBbLwJN55ZpHwXitVRC9D4l6sorjwVpyUUAARiZ3LwvBQ
	 mdMUwmezSQqdg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH v3 19/35] xfs: introduce XFS_FSVERITY_CONSTRUCTION inode flag
Date: Wed, 18 Feb 2026 00:19:19 +0100
Message-ID: <20260217231937.1183679-20-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260217231937.1183679-1-aalbersh@kernel.org>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add new flag meaning that merkle tree is being build on the inode.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_inode.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index bd6d33557194..6df48d68a919 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -415,6 +415,12 @@ static inline bool xfs_inode_can_sw_atomic_write(const struct xfs_inode *ip)
  */
 #define XFS_IREMAPPING		(1U << 15)
 
+/*
+ * fs-verity's Merkle tree is under construction. The file is read-only, the
+ * only writes happening are for the fsverity metadata.
+ */
+#define XFS_VERITY_CONSTRUCTION	(1U << 16)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
-- 
2.51.2

