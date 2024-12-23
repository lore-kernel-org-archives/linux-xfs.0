Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125AF13FEE;
	Mon, 23 Dec 2024 22:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991860; cv=none; b=h8whfTvIDy+Amy4lVyano9vU0awhlwJytkWOu1YGG4cmR59WDh8Xd0jg7koF3cNX6kjeBYaxNgDOmajZC/WjzCQkWked/xJ0gccPufOpsdt+qfRk4VOuL3HwDV+9ue792Mi2gfW2rsVpx/BKvKPQFC1kfwHPvKPqxCm4Q/ZIQWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991860; c=relaxed/simple;
	bh=l9ZOYCXsHIFayVF5BZUOX4+UFNO5ZJWPDofVXI83tT8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oTopu598K08dlXschYbsbOxDa7F8MCwdPHftc27bewGcgXAky0pSdKcD7XA+XdDfsk8B7+uRz/eGDN6vNuh1UYq18YAS6Rcj5/13zNkoJtKnHZtnbrOKikIvka4fPF1YqIQaHffzSu4KFwm+fypD/eU6R9pzZt9O+ngcin3Bce4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UY0k4t0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UY0k4t0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD249C4CED3;
	Mon, 23 Dec 2024 22:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991859;
	bh=l9ZOYCXsHIFayVF5BZUOX4+UFNO5ZJWPDofVXI83tT8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UY0k4t0xoS0O9PC6fvEfjwX2qikmQpWSirakBD3Cu8c2rkqWoowjiMwawVsJlJdFE
	 uYHjMW9xPM7C8+IXJJDPpfnSPepvOZRCT3V6OOA7NyKuNFbiUtm1/rJ8Xuzg7cE0ba
	 x4kd2tvGGXGFhiMl5Lcs/lBqudMAB+v5lK1g9Xk6tj7ViXUvK2iQgBI4wrjbKLW19M
	 7e+cZXNDeQEnjwwe4tiJ0nH828eguX3KGQ1fxb4uRj1TIczFZHQez2FMr0dHmLNFE5
	 ehCUWunsgs7HHWX2Uttt3lmkvGFEL1Kiuh9LsY5Ulw5oX6OeYp1uoc5hR7l0pabhnp
	 4r5vP/xz/kL4A==
Date: Mon, 23 Dec 2024 14:10:59 -0800
Subject: [PATCH 49/52] xfs: fix error bailout in xfs_rtginode_create
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: stable@vger.kernel.org, dan.carpenter@linaro.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <173498943241.2295836.1099700705759793351.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 23bee6f390a12d0c4c51fefc083704bc5dac377e

smatch reported that we screwed up the error cleanup in this function.
Fix it.

Cc: <stable@vger.kernel.org> # v6.13-rc1
Fixes: ae897e0bed0f54 ("xfs: support creating per-RTG files in growfs")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 8189b83d0f184a..aaaec2a1cef9e5 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -493,7 +493,7 @@ xfs_rtginode_create(
 
 	error = xfs_metadir_create(&upd, S_IFREG);
 	if (error)
-		return error;
+		goto out_cancel;
 
 	xfs_rtginode_lockdep_setup(upd.ip, rtg_rgno(rtg), type);
 

