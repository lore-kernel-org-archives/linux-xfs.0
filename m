Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A40B364943;
	Thu,  9 Jul 2026 15:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783610663; cv=none; b=jI55J3KIg9zvOFNjgIh1JtFLM5CwHkLQd7yCleKvtDda6HkBtd4drFQdjZSkwhZBupdNBbT/ZDekfRyDYEE8k43VAeKbOZwuZ0W104APFrp9BUShMGrP9no0hLTevWUV6c6Bm5+7JAWijOgL/4pLOGNPzBy8uDIKCS+pWxp0QNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783610663; c=relaxed/simple;
	bh=5mjdH0IwSgLcKtXeERr+/mIGjtFwhrbdsGq/uiVRLRo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YJ7h1qauP4pMx3z6DTH3QcflJVWPLe11aYmMaF6uJuotJc4o+6/gprjy8q1exrcqxDJOm9WBCZfV7BmnY2nBkeTIPwSsxjLfkF2yYIjjfpp0HdNEbg5V6N4eYPxmG+2fgNfhlVvU/wEeKs5Oozo8+B+McZL1TLMgxaKYxoM2SIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8X1dAuT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8X1dAuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729AF1F00A3D;
	Thu,  9 Jul 2026 15:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783610661;
	bh=09hgstD4XclulGwtefgitBwx0Obi+sf0BErgBu+x930=;
	h=From:To:Cc:Subject:Date;
	b=X8X1dAuTxsuUVWSwRR+tZDWbWknDSzls0V8EpwqtshgnP+XoueSFTjqu7SQyswWgT
	 UVmhMH5PX6Btb+3jObKe5EoPKvQv2hHUBO2jyCsJFNIUESPNmxshhnrfAwvhA7UIoh
	 gwc9rQ49QsEdSMQ0q8ii5KxQsi1l5Fu54nt2i4tGGSkBEOVP1p0JX4ftCin5YVYCvn
	 5KfsZ+6E/w8vLC5U4PFiGExKgPdF9A6nbNhTFXT+f1E5dIwXiLUlVNvuy6pdMEk1qT
	 o33Io7TGrbwZBJ85fYV5Yi1E4vFZxQqVOxXlWEme9ui50ShcULz6RF0TAFYIB6aoi7
	 ZglytDdwqEmEQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2] xfs: fix null pointer dereference in tracepoint
Date: Thu,  9 Jul 2026 17:24:07 +0200
Message-ID: <20260709152407.2968448-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If dfp is not NULL we exit early here, when dfp is NULL it's allocated
in xfs_defer_alloc() but not assigned. The tracepoint tries to
dereference members of dfp struct.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Cc: <stable@vger.kernel.org> # v6.8
Fixes: 3f3cec031099c3 ("xfs: force small EFIs for reaping btree extents")
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---

Notes:
    Add Fixes:, Cc: and RvB

 fs/xfs/libxfs/xfs_defer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index c6909716b041..89501e8bd2f8 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -878,7 +878,7 @@ xfs_defer_add_barrier(
 	if (dfp)
 		return;
 
-	xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
+	dfp = xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
 
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
 }
-- 
2.54.0

