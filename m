Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B038D3ACA62
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 11:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775560515; cv=none; b=nBCNjfyDZQWodqZv5Qx8ZITVH89aRplv7KF9BBprMfy5Cu1q8GTqLSn913eVan+8Xhq2+GioNyoWRSLEsDEnAucnOxQQ/y/2wlNLJFRWsERTozNurLFgRdyuPlW5OWRBDbsIp5BJcNheKip59wq4gNHSGPHomP85cnimknOoXjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775560515; c=relaxed/simple;
	bh=5ZR3LKZJHc8vQ4JGgKhleZr6gUPER5ZMMNeBksJz1H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tgzd6/+79neOqXpyDbHXcuzUZCZnJenULlK+gO8XV9DIo1UlkRbV0qcFPlNhtyfYxAiRjegtP8v5WAo8+u6SJcnmhnj5bVngsr1QN+u6ThIS426Nrm2Px/f0lCfK3IMet9gUANKavAVsCRV0e7bey/pixr0XW/VVTRJzMbC9D/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fY/AzBFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fY/AzBFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA5DC2BCB0;
	Tue,  7 Apr 2026 11:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775560515;
	bh=5ZR3LKZJHc8vQ4JGgKhleZr6gUPER5ZMMNeBksJz1H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fY/AzBFxJBsFeJ6gdE8TG0QhLTKkqdhyTbut46h/N2vUPnbnT0csR7J9CQLcHNEuA
	 8zjiwppHuCx6tNsqguAzgpOJnSqfRabEcbMT2iBeJPhtdi/d5cNOxlDRuyOQ56Y/9o
	 JDoZ6IsUU/CvsByr1/ifOukp6sccZUfenbKyfVmzQXb/w17BE+KxSanMjcPHGaGJRZ
	 rN4gDhrEiGobH7U/+2BNIGN5C5fbcC7O0DOJEvSJOHFtZZ5FJEElOCdOvm/ir7XdXS
	 AVu33EQEZliI1UAD5bDFOyENFvygRyeR8fGmyDYvdkTMBw1NyWt+BtQGvIcGkYT787
	 arobAz63A+Gbg==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v4 1/2] fsr: package function should check for negative errors
Date: Tue,  7 Apr 2026 13:14:59 +0200
Message-ID: <20260407111507.79977-2-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260407111507.79977-1-cem@kernel.org>
References: <20260407111507.79977-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

xfrog_defragrange as most other functions from libfrog return
a negative error value, while xfs_fsr's packfile(), expects
a positive error value.

Whenever xfrog_defragrange fails, the switch case always falls into the
default clausule, making the error message pointless.
Fix this by inverting xfrog_defragrange() return value call.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

---
V4:	Add Darrick's RwB

V3:
	Just change xfrog_defragrange() return signal.

V2:
	Change packfile() to check for negative error values
	instead of changing the return sign from xfrog_defragrange().
 fsr/xfs_fsr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 8845ff172fcb..390f7c5276df 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1459,7 +1459,7 @@ packfile(
         }
 
 	/* Swap the extents */
-	error = xfrog_defragrange(file_fd->fd, &xdf);
+	error = -xfrog_defragrange(file_fd->fd, &xdf);
 	switch (error) {
 		case 0:
 			break;
-- 
2.53.0

