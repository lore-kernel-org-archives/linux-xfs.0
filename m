Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE6F27AC31
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571957; cv=none; b=uBd0mFuP9cs8ruf9vX40CkhIhrR4dcx5PwZdO3IqdMaIgsfxRx6m41WS9hsUd2viHRx0/V3D8kn1IgKPBfJV9hwUZPYbDZtEIssphHCgoXB8rIZSeLPEcXBdReU8Mf/D4eFwqTdKAl/Euo9+xFV15SxRlDvjDq4WsfQE22/fFow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571957; c=relaxed/simple;
	bh=Cy6paM3cJir3nCX7bdXZFkO/XeVpJBLy8xjRKgtay9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4Wk4KUOPlH1xTcmUarNdFuejFzu5T/M2ysz/XRHv05qxNHrBpCGbg0D3ysJ3n9BTs411cwTPYw6rmbndGligreYvjkZjO+MGSpgiH9te9NZq7XdgJJpkm3o68CJRFpkdkNBzwLuGKF7bDQBsEnz1BvFqcScVUsgZJnG99nvAP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTAmB075; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTAmB075"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE9E1F000E9;
	Mon, 24 Aug 2026 11:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787571955;
	bh=fMlbmBj1U7r6RaVmltzvYens8+tJvJBIhKGx8+iHFy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTAmB075el4TGGK6f5fTmK/MApjoSrCO9fquyg6mrspheGYwQRTPjFERfqVW4F5TX
	 tI+ObM44ztyxiSHvvE2jFNk6ehicUjM6XIbugBqi60Sq9oPS2aOKT2XLTd4n4MHP/D
	 FIGIS0WT+u+T+Y8WyJ2BmozJfqXCJXnUI/y9y5BaQYwfug28oHUVCLlft92Xw2AbAE
	 oeo64YUQmn9AEGqmbIn4XPYEJe8H7e2cCt82gsY5F4TJUlQLD6/7vpMrp2Ge9cUkO7
	 MSyWwu+ZVl1Hh+6mNsOQgbiBdwl16gojV2c2Z4E1zXCY7xqINOGQSk/qxrqe0b0v+w
	 a+9K4BVovOZqA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH 02/21] xfs: fix exchmaps reservation limit check
Date: Mon, 24 Aug 2026 12:40:00 +0200
Message-ID: <20260824104022.420566-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824104022.420566-1-aalbersh@kernel.org>
References: <20260824104022.420566-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yingjie Gao <gaoyingjie@uniontech.com>

Source kernel commit: 0a5213bbff62b51c7d4999ac8c7e11ea57d00d45

xfs_exchmaps_estimate_overhead() adds the bmbt and rmapbt
overhead to a local resblks variable, but the final UINT_MAX
check still tests req->resblks.  That is the reservation value
from before the overhead was added.

The computed value is stored back in req->resblks and later passed
to xfs_trans_alloc(), whose block reservation argument is unsigned
int.  Check the computed reservation so the existing limit applies
to the value that will be used.

Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_exchmaps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 5566f9faf456..651c3784caba 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -708,7 +708,7 @@ xfs_exchmaps_estimate_overhead(
 		return -ENOSPC;
 
 	/* Can't actually reserve more than UINT_MAX blocks. */
-	if (req->resblks > UINT_MAX)
+	if (resblks > UINT_MAX)
 		return -ENOSPC;
 
 	req->resblks = resblks;
-- 
2.55.0

