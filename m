Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8215FC126
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uaUmE5dP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2D3C433C7;
	Sun, 31 Dec 2023 20:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056258;
	bh=n5x3wKcay7LxdKw+va7Yvw7Zg8gUhc8Mk30TNiEEPdk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uaUmE5dPc8iV7/s2apVRnbspP4nxbk5SmMb2G8clFSWLJ2RUnjid0BugFcI9SwIo8
	 w8JI7fuHAUjIDwdGWpB+O0ynzlRF3x34MZFQ4iAWc6eKpe9KKVTrtrKxSNjVfFg3fl
	 eACi+6PHXdplJlAov30WLUdXwMaSAVmlEtuYz4DaSSmxSuKYWl4DTbi3PGn5kyi7Gs
	 qaWqPYIQ/ItJO7GYhG/Glyy85Ea3bdvbso+cbbXYyrO1wBNH+5tSC5BIzjVtKDoAc1
	 ox5A6Q7UcTr4oZ2qnwu1tlpjK0aHtr4zVXgokzWQdhC2FmVFY2VVtkYyVcS4ui34+T
	 7arXCgZPzG/4g==
Date: Sun, 31 Dec 2023 12:57:37 -0800
Subject: [PATCH 17/22] xfs: remove pointless unlocked assertion
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404842020.1757392.7312336360740998905.stgit@frogsfrogsfrogs>
In-Reply-To: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
References: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
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
index 44b8c315c5978..1dd1876a7b145 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1023,8 +1023,6 @@ xfs_bmap_add_attrfork(
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
 
-	ASSERT(xfs_inode_has_attr_fork(ip) == 0);
-
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 

