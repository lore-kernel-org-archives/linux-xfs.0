Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7AD49B5D5;
	Tue, 13 Oct 2026 06:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871722; cv=none; b=ljyug5wzxdZwq1ppHSiT7PAEoDYr9lg868F1GtPIRILbAx5K1LOSbBQMlgZr4Ufys3z1TBJWgNPe9XllyuxaeZfcIyWM9lPhgM3KW+izDUHfpRkAkZCo2cLRMsKIf5EKA36rR2G0hM6L042ylulXvQRHHRpcmQTDm5LkEDebWh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871722; c=relaxed/simple;
	bh=nYYHMbl5BdVlgGVJ0EgLksRjXAd43RmuB0YWGke+2D0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XSAGjJoSJWpbalzFbv40cigc+PgV6Eegsv6TdN8rhb+CwqpQpG9LvYLC8AADzt2/96rfmsqsMx4E3E1e7iLSS9lWl+r1BJNGCNr24urYMeN35ly/CZzRIoAWo49NvqaZ41GInIljewGodSGpCLnY5rHWwybLl1Lr6GSG2um7o1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YyKxhu2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YyKxhu2q"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 64F5E1F000FF;
	Tue, 13 Oct 2026 06:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871716;
	bh=x9BxAtYquVxHBE3lzPntPp2uQvQMV7raiIBIDQDnwDs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=YyKxhu2q0NGSK64rhpF1iQzbA1Y+ujpXPXegK1waB5QHCL+8Qvk7OQVuj+hhdauOn
	 Bx2IjVQ9nzuCO+uGJnsu+ci1Ej/Mk8ztKqm/ksu4Z+DbWb3HzdFJp79QZn1c7Z7otE
	 krza+l0DKVAOVM4dbqyg0zse2fUa5l/yJUtePZXHFDwMjK2DQeQr4Mm6Kb+rMpJNCK
	 xSN08rbZjbCBolhQxTuii6b7uw/eCUFnuPaH0nmEat2uPWhOueocw7mu9C5Ze9ZTif
	 Zf8qK51Mpg7x0lzguXSKwkHi9O/xLCtBeQWUSTVdDuFYZgTwXWkra+vVQuWx8GPziW
	 4WrmQk1i+m0LA==
Date: Mon, 12 Oct 2026 23:08:35 -0700
Subject: [PATCH 01/12] xfs: don't set a metadata directory's parent to
 sb_rootino
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107862.1898896.15634751075985252663.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
References: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that it's weird to set a metadata directory's parent
inumber to the regular directory tree root.  Fix this even if nobody's
ever going to notice this because metadata path lookups don't access
dotdot.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 4f3d4dd1b04b2b ("xfs: define the on-disk format for the metadir feature")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dir_repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 4a0b912b657696..bb3f2f462bde56 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1674,7 +1674,10 @@ xrep_dir_swap(
 	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
 	if (rd->pscan.parent_ino == NULLFSINO) {
 		rd->needs_adoption = true;
-		rd->pscan.parent_ino = rd->sc->mp->m_sb.sb_rootino;
+		if (xfs_is_metadir_inode(rd->sc->ip))
+			rd->pscan.parent_ino = rd->sc->mp->m_sb.sb_metadirino;
+		else
+			rd->pscan.parent_ino = rd->sc->mp->m_sb.sb_rootino;
 	}
 
 	/*

