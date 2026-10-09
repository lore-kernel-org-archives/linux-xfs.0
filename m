Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B56B35C6B8
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589899; cv=none; b=f93H9sCsYBSGUJz/Lnudp1YBHaXlkbKdXPCMUmkrryptR6ZomA8LU9fpfRN0Os1+Vur3RSopB/FDE6bwcRudbOENCEvPvJwac/aUePeMf+ee1mmkWi6CvX4nAt/cWpgHKAzqV3hfj5RviH+xAGepmOYwa0NSu8TSbUFENT/Gyoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589899; c=relaxed/simple;
	bh=cQgrjRURq8xcjCwVpxHg4LDVpqeQlQMvPAWcLs7bC6s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KKB5+BswjGeDVcm+PnUVNuBWQtCzJ+DywO82E7j2MlHdbm657QKqjdQFkA/bMtPmYh/HdsiOrOvK2FnIvvkPpFzeLgluFlTgXXIJxDS3G82/m0LCov97fGYsmq4aOG+KzN1/OCxditIqQBFM03lDCH4nWsbIWtLeiMcjw+heSLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jzAKTMXe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzAKTMXe"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ABD031F000FF;
	Fri,  9 Oct 2026 23:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589897;
	bh=YLYxgwywZewmrH0PWIC5Sj/KhxYe1dxLYg1WRhC+Gr8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=jzAKTMXeyGG9D5eGA/W0kE4EDKeqeX2yCuFbQi0+9FB5+nKPWzHieRn6GyTOnI3US
	 jKrdJtZNAkUQYfI5vJdjXoHNH7FI3S9RP9YDZpAxbfa2HTSFX1IejQLuGhzVvvst/z
	 mYoH5Qozqkl/UA3yyYrWX36ekrksqbWxqanA3VY0bRevneMd0+tz0VTkjl+6/fCMMz
	 zpFh6a4WOpF0bdt/wrGLJ7qCkT1xHB9RZFLrjxc838FPJH627Jb+HrTJbXlNQIg9Sg
	 hrKAl0s4i2+cyt3ytovfwtXARhxhRaJ/NDl1YNM2Vi0UddExtxvVFxTNZxOFrNlJbv
	 iZdKbWvFp4ncQ==
Date: Fri, 09 Oct 2026 16:51:37 -0700
Subject: [PATCH 23/26] xfs: remove duplicate INO1_WRITTEN check
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, yijiangshan@kylinos.cn, linux-xfs@vger.kernel.org
Message-ID: <179158947790.3719791.15913650685072145538.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Jiangshan Yi <yijiangshan@kylinos.cn>

Source kernel commit: ce2b91bebc7bc0495fe3ad5ee47e4977fbb77fc5

Commit a23eca88448e ("xfs: fix exchange-range reflink flag clearing
issue with INO1_WRITTEN") duplicated commit b2d5a81dae38 ("xfs: fix
exchange-range reflink flag clearing issue with INO1_WRITTEN"), so
xmi_can_exchange_reflink_flags() ended up with two identical
XFS_EXCHMAPS_INO1_WRITTEN checks.  The second one is dead code,
since the first one already returned false.  Remove it.

Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_exchmaps.c |   10 ----------
 1 file changed, 10 deletions(-)


diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 21b64aa953a2f5..7d6f949aa1f3b3 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -958,16 +958,6 @@ xmi_can_exchange_reflink_flags(
 {
 	struct xfs_mount		*mp = req->ip1->i_mount;
 
-	/*
-	 * The INO1_WRITTEN optimization can skip exchanging hole and
-	 * unwritten mappings, which means we cannot guarantee that all
-	 * shared extents actually moved to the other file.  Clearing the
-	 * reflink flag of an inode that still holds shared extents breaks
-	 * the CoW write path, so refuse to exchange the flags in that case.
-	 */
-	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
-		return false;
-
 	/*
 	 * The INO1_WRITTEN optimization can skip exchanging hole and
 	 * unwritten mappings, which means we cannot guarantee that all

