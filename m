Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3CA7F9
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b9PA6IXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FCBC433C7;
	Mon,  1 Jan 2024 00:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069552;
	bh=b27XyqnqjDR9oRR9vFpOLESXgkhid9oSYE+uiZU0CiM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b9PA6IXW3wTvL56ZYt9BojJ2Z4SAj1QM9Um7QWlRYivJ16dKBEVNzFy69MMJwlkVh
	 rmuEglds7RhFL3DncEcM/O9c83KK2NslnYq+WDdeAGp52T1AVu+JZIVNyDlXCNX8jl
	 UIok900GJDiGKPsF1oUL3OanLSe+ec24YN5yU5lLiXzMkX6wHT8FjRGLOicaIuW+uv
	 FANk2Xhv7Xyd8Xu8UZaeEIDgylIrIKbyRBMSAn6wNCcE3RXvQ/S1s2IFtCno0v5gIp
	 IpTV70tDZ0t0C5xrv6yyCKET2sbysj2nb5S+gbVEFYH2j8is6f58DKyYxXfHgb/RUQ
	 bNVZyH/+4NFZA==
Date: Sun, 31 Dec 2023 16:39:11 +9900
Subject: [PATCH 4/5] xfs: apply noalloc mode to inode allocations too
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405019617.1820520.17125148444200392717.stgit@frogsfrogsfrogs>
In-Reply-To: <170405019560.1820520.7145960948523376788.stgit@frogsfrogsfrogs>
References: <170405019560.1820520.7145960948523376788.stgit@frogsfrogsfrogs>
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

Don't allow inode allocations from this group if it's marked noalloc.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 935f8127c0e..09e494f4089 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1059,6 +1059,7 @@ xfs_dialloc_ag_inobt(
 
 	ASSERT(xfs_perag_initialised_agi(pag));
 	ASSERT(xfs_perag_allows_inodes(pag));
+	ASSERT(!xfs_perag_prohibits_alloc(pag));
 	ASSERT(pag->pagi_freecount > 0);
 
  restart_pagno:
@@ -1687,6 +1688,8 @@ xfs_dialloc_good_ag(
 		return false;
 	if (!xfs_perag_allows_inodes(pag))
 		return false;
+	if (xfs_perag_prohibits_alloc(pag))
+		return false;
 
 	if (!xfs_perag_initialised_agi(pag)) {
 		error = xfs_ialloc_read_agi(pag, tp, NULL);

