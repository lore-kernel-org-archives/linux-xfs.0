Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5EAC126
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJEeQ/YO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE3DC433C7;
	Sun, 31 Dec 2023 22:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060122;
	bh=MV8rfkGzWmusWy8QHJKGZa4Z7oXRFHcJK40+OLZmK+E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XJEeQ/YOGJhi5o1RfcTMqwIizZPp10OtUFFbzyXYS/epOzwyvR1/BZp2t/jwP+QHe
	 s1xZgFt/NnHoYf1VScd8yvdWiAo9uJMsRiUt8X2YcOockfYHCNa9vB/8xziC/nnMER
	 DMMdYIx1gi958xgrzuDrui/JR7RTIUPwd8kBtjAsd7uEgzbg38z32vyI66gFWktxQN
	 getFpTm2wvpaEbwtiNKHHVxKiq1L4OHl/Q9VmXFrMa8NFDetNSp/euvuI9C1hKlN6q
	 7d2aOyBfkIQvKZy1NEvIHU8kxQ4aewdzUGg7Jqdq8zo0iOpijPXldMhhAtIuaNHh4D
	 vorJshM1HVsGg==
Date: Sun, 31 Dec 2023 14:02:02 -0800
Subject: [PATCH 5/5] xfs: apply noalloc mode to inode allocations too
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404854804.1769671.2859585470367782301.stgit@frogsfrogsfrogs>
In-Reply-To: <170404854709.1769671.12231107418026207335.stgit@frogsfrogsfrogs>
References: <170404854709.1769671.12231107418026207335.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_ialloc.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 46c0bb67e4c47..e22f02722d19f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1064,6 +1064,7 @@ xfs_dialloc_ag_inobt(
 
 	ASSERT(xfs_perag_initialised_agi(pag));
 	ASSERT(xfs_perag_allows_inodes(pag));
+	ASSERT(!xfs_perag_prohibits_alloc(pag));
 	ASSERT(pag->pagi_freecount > 0);
 
  restart_pagno:
@@ -1692,6 +1693,8 @@ xfs_dialloc_good_ag(
 		return false;
 	if (!xfs_perag_allows_inodes(pag))
 		return false;
+	if (xfs_perag_prohibits_alloc(pag))
+		return false;
 
 	if (!xfs_perag_initialised_agi(pag)) {
 		error = xfs_ialloc_read_agi(pag, tp, NULL);

