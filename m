Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B5913FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688644; cv=none; b=VtuoJXxRvwXwh9wMtE28kzpIF7vFuckE5qf/fkJRoQ265jQ6Pf2wdPAhuJYiUA8nba4k40kFUiNL46ZuxRQVyUg0JfIKWOdBELt9BtQqX41I4UuGoTXxztrkg/pgYEetGHD4fIpxkmObqLUUlw9YmeBYzeQdKUB5UrZgpXpgqxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688644; c=relaxed/simple;
	bh=N10oYL9CHBMX/3gL38XLVgTO9sabR72S9fmCSrVaZnM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BZlIqFl+GBM3xf1vCjmy+DdeWvdiL36swZ7OXHKJGWMRxzVFWEW0oVSOULuCdoxxlFRTGbgztCs5P6vba57lN8QW+CXy1iB9l/qkyvK5rEGLNxIiuARaPmX2DfJ/ivwc5vkos1IYsbgZ5Tg/oiyyW05AgPZEeXSvx6eWhTve2JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lxWGxsE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lxWGxsE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA3FC4CED2;
	Tue, 31 Dec 2024 23:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688644;
	bh=N10oYL9CHBMX/3gL38XLVgTO9sabR72S9fmCSrVaZnM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lxWGxsE1MTQ9LTeVsSn79G190SfuHXPyP2cZeYKWoFpbecqjTtvbZeiNzQeaaeEzJ
	 ywg3pEqzhuopwUU9FAxF6s9rEJr/zVA+kimWjdcA/+5OuRxfAu2nzl/aYwGTzlvBLW
	 dQjKHKCjj2k0baZiHeu8f0g8qjKsamDufG4LJt+ju86mA27Nd4N1L7r2vn0PrZQkUR
	 PPE1kkBShx0JCv3yArtfxbWngiQndF7g0wsDq9krRqFvKPZDXdP/UlZXSn49WgCeUJ
	 kf4gOB7TrAlpaWWONy3hPoTSFxs0FkHaXNX/J5s/KCcnVKst43qdbqH6GndK9GtQoc
	 Dd91XpXqcPUqQ==
Date: Tue, 31 Dec 2024 15:44:03 -0800
Subject: [PATCH 4/5] xfs: apply noalloc mode to inode allocations too
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568777070.2709441.10513728780460673933.stgit@frogsfrogsfrogs>
In-Reply-To: <173568777001.2709441.13781927144429990672.stgit@frogsfrogsfrogs>
References: <173568777001.2709441.13781927144429990672.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_ialloc.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index b401299ad933f7..a086fb30b227a0 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1102,6 +1102,7 @@ xfs_dialloc_ag_inobt(
 
 	ASSERT(xfs_perag_initialised_agi(pag));
 	ASSERT(xfs_perag_allows_inodes(pag));
+	ASSERT(!xfs_perag_prohibits_alloc(pag));
 	ASSERT(pag->pagi_freecount > 0);
 
  restart_pagno:
@@ -1730,6 +1731,8 @@ xfs_dialloc_good_ag(
 		return false;
 	if (!xfs_perag_allows_inodes(pag))
 		return false;
+	if (xfs_perag_prohibits_alloc(pag))
+		return false;
 
 	if (!xfs_perag_initialised_agi(pag)) {
 		error = xfs_ialloc_read_agi(pag, tp, 0, NULL);

