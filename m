Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9128A1F95E
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 00:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736384237; cv=none; b=fMIBEk1kOKL7LfXM3N3uvy6oufIOKqOshi2GMlKyLKxBTMiECOX4gw0mohEm3lukx/9qOt7uRBQ4gJA4bkzpL8Je4zE7LpvSZOZ709qOe0iVYGpwIRz43w4QBk4v4gFyY/nxPsQiL8vCwFYCNh0V3r65aOn4hZawv0Rs1FU6ncI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736384237; c=relaxed/simple;
	bh=qfF6AtI5Tbfu1qlXKpB9Lale7UIGBE2F2sucSqVvKKA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Che3Kt35FVLa+kFvAQKlkqu3wRcqTe+g9NEELTde6CGMTTjf0A7z6LYjxxOrmmqwOBi6rgYdhkSWJR8xcijuwkb8QZRRghJ3cjE/H2WvMt8x56NDTuwNyi5xHTT0D34J/8saLpq5B7PY963Eto0fumQsUR6MTbZ89ChNSJaoI3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/RSInIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/RSInIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C16CC4CED3;
	Thu,  9 Jan 2025 00:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736384237;
	bh=qfF6AtI5Tbfu1qlXKpB9Lale7UIGBE2F2sucSqVvKKA=;
	h=Date:From:To:Cc:Subject:From;
	b=a/RSInIs2v3tMuLiXgUZ2zZsTZKnBgKDvfnA44oaMmN7CXn9kG/PxRrlCt5YQYH1k
	 Q8JXn6kO03CaBHQOo5l38QrI8ANQ9zjK7x9h6QJav6F5nKlojuL/Xd14HDIW5kToTq
	 FIFcznF+0eCmskxhm8AXLdArCo42M9CrVnCKCQ7zHdUbO0f3tDEKOSJk+nEYjwXF4k
	 k8yNYFnzhFax0ab4WYSrTD5PM3/lVRSE5Aw6yfW20I7VSsASoDsBzymF+IREf3H6tP
	 MsBXanwAH6vtgT1CPTPGTw0wGn9iGyoLRg7XRzeK7hBj4kTItkurH5m2a5gaiyvn2T
	 DnISSPK4zIAlQ==
Date: Wed, 8 Jan 2025 16:57:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] libxfs: fix uninit variable in libxfs_alloc_file_space
Message-ID: <20250109005716.GL1306365@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Fix this uninitialized variable.

Coverity-id: 1637359
Fixes: b48164b8cd7618 ("libxfs: resync libxfs_alloc_file_space interface with the kernel")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/util.c b/libxfs/util.c
index 4a9dd254083a63..3597850ddccb9a 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -193,7 +193,7 @@ libxfs_alloc_file_space(
 	int			rt;
 	xfs_trans_t		*tp;
 	xfs_bmbt_irec_t		imaps[1], *imapp;
-	int			error;
+	int			error = 0;
 
 	if (len <= 0)
 		return -EINVAL;
