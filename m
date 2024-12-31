Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C080D13FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688253; cv=none; b=pkpjtLZGAIs5Z+4akj6XBNt+fnYQOQ7ExmE3hXOeUostUkZrNkiJyb0MtLi62/Z8+nBWzIDkUiN+PtCdNBO3uyMCr4rk2QvEdGmuQkW/ow0L6agK7A9SxiKPkuY8NU9OiDgA5WHuBL/bMUBU548rZWzb8CxIgpK64BqbMrxOXoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688253; c=relaxed/simple;
	bh=Q+jLCTh+8FNmhKaXwRlvzB6vY9nOx8YiSS12+A5fnPE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WQ/7ZKBO5sR7b+YMyknH2AfcEzFl3a1ObkHBAO7OtEICz3/rdN06AIaGSLOBZVg4WRfofdM/iV6RVDiu+B1ychVhZclrhtlJfnNj9jL/NPAd+Ijsqa2cx8hD4E4g6+KvMq02L6sAo/sE8j0o4+aCQR0kKJl4tGWGQ0WJHy4ZqvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rEGNhjfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rEGNhjfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC4AC4CED2;
	Tue, 31 Dec 2024 23:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688253;
	bh=Q+jLCTh+8FNmhKaXwRlvzB6vY9nOx8YiSS12+A5fnPE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rEGNhjfuFOLl3mcxWhRaLoMu/tbvhTzJEgDOFtFvWS0JwBytEt4NsES6N0uO9gGir
	 w41lMM4pv2EDJjBdkkxGpEUfaGtcx+cs0x3KEng3XvkDVOGMTHwfdIQ2xgoY+0wcqO
	 WbXOMfuC+iJ9dZ/zvNm5MwZp1Bn36zT5zxhnmSwsq++dTDCHpbPpi8MTDn99CfXv4w
	 pxSFIuMup6e4nTvBgoG4jTTnOGI5/Lvkhg3Rsr3wWVMMbbFvZhsMjwJdq9pju5ya8k
	 pV4Jz/mha2rLa6Jr8aWR1kULPdbhfuV6PezCc2y0/bjkRicO6wFKMvlUIb6aetbHJG
	 vEDJ29XDQaKcw==
Date: Tue, 31 Dec 2024 15:37:32 -0800
Subject: [PATCH 5/5] xfs: apply noalloc mode to inode allocations too
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568753409.2704399.9918255860033581381.stgit@frogsfrogsfrogs>
In-Reply-To: <173568753306.2704399.16022227525226280055.stgit@frogsfrogsfrogs>
References: <173568753306.2704399.16022227525226280055.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_ialloc.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 57513ba19d6a71..2d2f132d4d1773 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1107,6 +1107,7 @@ xfs_dialloc_ag_inobt(
 
 	ASSERT(xfs_perag_initialised_agi(pag));
 	ASSERT(xfs_perag_allows_inodes(pag));
+	ASSERT(!xfs_perag_prohibits_alloc(pag));
 	ASSERT(pag->pagi_freecount > 0);
 
  restart_pagno:
@@ -1735,6 +1736,8 @@ xfs_dialloc_good_ag(
 		return false;
 	if (!xfs_perag_allows_inodes(pag))
 		return false;
+	if (xfs_perag_prohibits_alloc(pag))
+		return false;
 
 	if (!xfs_perag_initialised_agi(pag)) {
 		error = xfs_ialloc_read_agi(pag, tp, 0, NULL);

