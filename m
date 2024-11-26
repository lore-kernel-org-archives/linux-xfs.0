Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65493946C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 01:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584440; cv=none; b=SYoqcxtbN3YVy6de8KUB4h5RgSSsHtNZtAJnM/FWjDQ8KPHeQA1AuE8Rtq4AReU/S3PZB1/sV4DQg+lUp58u6WqCUOnuIXULuSCoflYgD6fYh+GNmKmgSguX+8XY0tFas11PMCp3rJBt+9g2rhdOW0onO5ZZ+F63w8z6IuLwwQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584440; c=relaxed/simple;
	bh=+Bz2U8Uf+86gssWiN9CQ6X/u/z4vN/05CWpuE7um/Dc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lqBzNFbVAM9Uug0rUtVo5mIV7DMw+QqSBMBTKnoPvSmVVqYaxKHIL/G91taqTctWUeiAPSvt6Se5lZB9v7bTeZkhrSZthD8FHqf8jq4BfghOD0UocDqs+gHKy5vGe9jIBuS3Oqy1f6lngFa7eh3m2nBFkA1sElubok8YvjihsAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=swjHfmWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="swjHfmWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA53C4CECE;
	Tue, 26 Nov 2024 01:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584439;
	bh=+Bz2U8Uf+86gssWiN9CQ6X/u/z4vN/05CWpuE7um/Dc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=swjHfmWLYuWRumorWtGrioTfnNrfqWwYTmTLEV8TLlC/MjJDQvCms6hwg+1stQcUT
	 uPgBpANrDOYBKxVhAzWbqkwi9ENRUPmYKG1XiVttCDGlLGjGAasgYLdZ9kPC3fNp/5
	 7pyAXTw83mIh2pxHLomHaO7mljx5D6CVtkBzv4ciUHCWAWoVOHyOMo1eFaa7ZEyV23
	 eslSuiq3nO8c1LLvleK4asYt7rw+SlJ3uXnFLR9qdK//a2k6fUkgcclCZ6MlEkscfW
	 H6WzUFxChUkgWIJrYe1hStOXmOtdNY6TibxRC2Nj4KCdtcUwryX+Y9hv2cI789SE0E
	 QYMMhRNsxBZ7Q==
Date: Mon, 25 Nov 2024 17:27:19 -0800
Subject: [PATCH 10/21] xfs: fix error bailout in xfs_rtginode_create
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: dan.carpenter@linaro.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173258397974.4032920.351176801232799495.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

smatch reported that we screwed up the error cleanup in this function.
Fix it.

Fixes: ae897e0bed0f54 ("xfs: support creating per-RTG files in growfs")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index e74bb059f24fa1..4f3bfc884aff29 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -496,7 +496,7 @@ xfs_rtginode_create(
 
 	error = xfs_metadir_create(&upd, S_IFREG);
 	if (error)
-		return error;
+		goto out_cancel;
 
 	xfs_rtginode_lockdep_setup(upd.ip, rtg_rgno(rtg), type);
 

