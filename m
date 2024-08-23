Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E7F812
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371221; cv=none; b=XETulYRh27LIYiQzvcY3IufVf5qy3JivEucz1gMXCvt8WM/1WlSpJ/ji79vHzXvOf9Lfw3EjEPbeGjI3us8+/QXwLQ5QDiz8nGsY99ALQXXkCynhIeUpkIYY4jXypfA0HoPSJAGAhJIjFqe9AbOqCwhqlj6Ht4eFdjk9HcqydxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371221; c=relaxed/simple;
	bh=lXZId0GxsglspRxrZlW3xgrJimcn76uA6tt0PXNxVEM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lQlKky0bnBS/2aN9YinzmGpPcm11V5yWGjK2i+CajpSGM/MlrAK61gdVUTfgpK9/ibCQnf88KNiK3NMdCWDFXqTJ03AJcS39scurCTmmBGRFo34G/6UssYLMrkAhCHYXkcDgVcB5svFoe22rNV3nAww9u1LHBfH6853rJXQOYKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y69ngV5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y69ngV5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D457C32782;
	Fri, 23 Aug 2024 00:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371220;
	bh=lXZId0GxsglspRxrZlW3xgrJimcn76uA6tt0PXNxVEM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y69ngV5bQ/w4gOH7rLltv2nwy6oIM/BeRKi96xpOOdhIoofOAcB6vUFDLo5V4eqDm
	 Xr7Fg9lm79jtgJfkBueDYA2T1QVmQlDwp7vsTXHJRexG4M3eOJGf6erTupdwqk4Fuh
	 jRSPV4zctpMN/NvMXl7xzDpT5uxWd7pp18KjSL/26aDVYz+0+XAp/Qcm+D4hzrn/1U
	 INynzPJeX26mWNlaD07t4GHxPSrT7jaMroPrwx7f9USwb3qn6T6RHDVlR6mzksF7EX
	 GPB4igin0Cm28d3hCqPEZk7YBd3ckYONUzpot7mOYz3D2LTej7q7Kn/VxXhvOeguIl
	 gGeNPs3mJl1hA==
Date: Thu, 22 Aug 2024 17:00:20 -0700
Subject: [PATCH 6/9] xfs: use XFS_BUF_DADDR_NULL for daddrs in getfsmap code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: wozizhi@huawei.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437083853.56860.15801624695777560515.stgit@frogsfrogsfrogs>
In-Reply-To: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
References: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use XFS_BUF_DADDR_NULL (instead of a magic sentinel value) to mean "this
field is null" like the rest of xfs.

Cc: wozizhi@huawei.com
Fixes: e89c041338ed6 ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 3a30b36779db5..613a0ec204120 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -252,7 +252,7 @@ xfs_getfsmap_rec_before_start(
 	const struct xfs_rmap_irec	*rec,
 	xfs_daddr_t			rec_daddr)
 {
-	if (info->low_daddr != -1ULL)
+	if (info->low_daddr != XFS_BUF_DADDR_NULL)
 		return rec_daddr < info->low_daddr;
 	if (info->low.rm_blockcount)
 		return xfs_rmap_compare(rec, &info->low) < 0;
@@ -983,7 +983,7 @@ xfs_getfsmap(
 		info.dev = handlers[i].dev;
 		info.last = false;
 		info.pag = NULL;
-		info.low_daddr = -1ULL;
+		info.low_daddr = XFS_BUF_DADDR_NULL;
 		info.low.rm_blockcount = 0;
 		error = handlers[i].fn(tp, dkeys, &info);
 		if (error)

