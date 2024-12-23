Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCE1192B86
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992845; cv=none; b=cwUg1tmCVoPWzcYdJrhPtHZ972CJabGtjQxteiHU6DEjibzuVwxJZtXXtavh+bCX2UqAQSCqqc4etRvgrHdl+mpoJssK8bY4l6bEqP9tCHR+raHlN6/nYl/UcgU+aFDzBF2n8F1l9S4gWhyAbIEZNkIWumnRjSwzKD9CFRCX0HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992845; c=relaxed/simple;
	bh=XJSmF4kkRkz5WGRKjaWcG6fuozk2ByI7WRSPetQQgjg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nb70WaL3S19ZDPxy0VRaR9+oclITLjoJzOdSOgzJncIggUz8XMTIFAFfCzYuO89udKZTzj6/eTRUMeuS/KuRKHykNe7TF6HR/liUviP0dg7HTfm2nbxdGDdbSRVEh4EFrWI1ya3cWRe8XUluuU301No2NIn0Tva1j0Uz8pDhqIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G88+Nhwq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G88+Nhwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4A3C4CED3;
	Mon, 23 Dec 2024 22:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992844;
	bh=XJSmF4kkRkz5WGRKjaWcG6fuozk2ByI7WRSPetQQgjg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G88+Nhwq048bvb0GRplqlKh52DS/4tGmmqqYb6RR1F9xI5lsofhmHk/0Qfvu4ZLQQ
	 J7PMHyc4V9z6xp4Z9APjvXIuqEUuv5rSg9lLWpxuNlf4qFJrkv0Y1rcTXS9i35rHlJ
	 IVMAPRgODVmPjI8PfxBnQJP71P02CaLjHQUaQYOR5Qmc1/BY9Uk88qUHGseCNFFOzB
	 cnNd5n7Q73sMZhXLBBYgNfKQkC1grrrXk6e876SazFo/XeBYgk901yl5jISWSAk8+0
	 5frxZ3DbVazpdUJgEW7B8+M0JjdkjJlNknwxF/kJfVsUjun+7lRLnRwuQ44uoUaa0Y
	 LJf/ndgDFqe9g==
Date: Mon, 23 Dec 2024 14:27:24 -0800
Subject: [PATCH 2/2] mkfs: enable rt quota options
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498945472.2299549.10695247805344413916.stgit@frogsfrogsfrogs>
In-Reply-To: <173498945439.2299549.17098839803824591839.stgit@frogsfrogsfrogs>
References: <173498945439.2299549.17098839803824591839.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that the kernel supports quota and realtime devices, allow people to
format filesystems with permanent quota options.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c |    6 ------
 1 file changed, 6 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a15c19df03a86d..956cc295489342 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2649,12 +2649,6 @@ _("cowextsize not supported without reflink support\n"));
 		cli->sb_feat.exchrange = true;
 	}
 
-	if (cli->sb_feat.qflags && cli->xi->rt.name) {
-		fprintf(stderr,
-_("persistent quota flags not supported with realtime volumes\n"));
-				usage();
-	}
-
 	/*
 	 * Persistent quota flags requires metadir support because older
 	 * kernels (or current kernels with old filesystems) will reset qflags

