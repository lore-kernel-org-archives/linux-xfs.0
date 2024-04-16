Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5417539C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231529; cv=none; b=Nt9P30/Ev7CO3hiqgywpOmmL/POlSKAt4BpR4eC461+uWmZ/nIpwex2C0Yf5gj3Bgbjl64z+kU7F2sCCUfBIAo/K/2NmBwQDY8OJXwsCXz5JanI8xNhMr6ZagDl25mNPq8Go/6WDx2l87LRGYIIutkm/ZhT1AjO5HRut5UvHw+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231529; c=relaxed/simple;
	bh=w6Ud6u4itjPCpwyVUR2tWVspXLm6O0fKSYuVIzXDnR4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=na8fIw4O+/cgmiBG+pDmOxMBexId1dWTHVKy8Wu+gbpaBhxhGky00es7wc5oD3c4u5DOtdO/0O1YbxuhHYsWSBAHtUg01w0hFQVoqnqVieDZS385rXw5UIYuraXqskopIA5rQwDIUt2BKJ/rINIXVjWFjGq+Nt6CCJ8cpWuUBho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GrvPfXvA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GrvPfXvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2817EC113CC;
	Tue, 16 Apr 2024 01:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231529;
	bh=w6Ud6u4itjPCpwyVUR2tWVspXLm6O0fKSYuVIzXDnR4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GrvPfXvACkdU0FTJ3qlO0Tz1iSUX5MzcYt1GMl0skLo312yYjKJXZiXVxjGhsh69s
	 NRhzBjZzwpkucNtt/b6N0wwJHv7IdMsr/3MLHGJsxGy6PE6OybkmdOOTDs8oD/poly
	 QUaPIzAqDeIx6Z+I1jTTfmvjPYD+UeDhDqZ321yu2sXR2j5FewemGI+5zv2BqppMUu
	 nRuTq1wwcPHlv5gx5H5gFGj0MFm3eOO09UmyE0edVhn63wpT+/sb8crGfh8LzP6R+i
	 l7tqkh/gYClziWYckC5TXzCjoAAyzYPJnGeEne6gp0ZJ6OAUFXrOxEn1Mr3S1vNHMc
	 BLGLuEofqjL+Q==
Date: Mon, 15 Apr 2024 18:38:48 -0700
Subject: [PATCH 11/17] xfs: remove pointless unlocked assertion
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323029362.253068.1784222365312393758.stgit@frogsfrogsfrogs>
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

Remove this assertion about the inode not having an attr fork from
xfs_bmap_add_attrfork because the function handles that case just fine.
Weirder still, the function actually /requires/ the caller not to hold
the ILOCK, which means that its accesses are not stabilized.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 59b8b9dc29ccf..55a64a72771f2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1041,8 +1041,6 @@ xfs_bmap_add_attrfork(
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
 
-	ASSERT(xfs_inode_has_attr_fork(ip) == 0);
-
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 

