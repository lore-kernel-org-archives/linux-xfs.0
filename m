Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02111FCD18
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527832; cv=none; b=ptfmtiyw4VZ7JVdofzfckllozqDcV9FYnPlcmnnh9P+zo9e2AX7u4SC4iI10JUHbsrNPQaV0MyBgo0+mXfGjJB4+2Rl9ElwdhTujT47M8tezpqiqjn9KC8iIGwYljGsLTbmqSrP+9MlOvZhpy6vHESN6VYxD96waECBP/R5C0kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527832; c=relaxed/simple;
	bh=d3Vu/YGQ49fxEhHmTCNaDmt+0LxGV0BHuA0IUFIHU7E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tCAsSWaUQYqiMVQcErum78hVFydYOvkSy8fP3MoRCN/z6D8eP6kVokiOauIJUgu3uAA92tBG7Wa+EhmADfh2rWVKHwUqjADmNn6xoBaRwFm/aRTsOPNlqQ5HE7NXEmHIrcQuCk4RDLyiCXRrZ3KVo4gpsZ5+ryJsRFoO6pxGdY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pRCxw5jX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pRCxw5jX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C61DC4CED1;
	Fri,  6 Dec 2024 23:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527832;
	bh=d3Vu/YGQ49fxEhHmTCNaDmt+0LxGV0BHuA0IUFIHU7E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pRCxw5jXsAzUicOQ2jAgDkgXJctqaUQETgSV93TMDAtdNBugHUEtzv/e9/hv5kA8e
	 ivwgi1b+nctx4xHlcIZF9d4xCyS2FvuPIlK6yyUm6pjL2U0DZHegaoKjiXgUqNOIVz
	 LNqzFJY5PuqzG2hPxxIZ1R+LkRO+nTyWsZZBkYcY4uGehunqEPPdXJceBDHM7q1DAT
	 76beCfG630LUNBONH0xJH+Y8Wzax/gPtR+2PMprMH+Utg3ro60ilDfoRHkwAzqda07
	 8jAlySJzK4gsDLisMurjqbO66YxdJma0zNfZgtWofdaWizsFTZ41qT0JJwnlUQJ9tB
	 jL2wHT0rV06uQ==
Date: Fri, 06 Dec 2024 15:30:31 -0800
Subject: [PATCH 01/36] xfs: remove the redundant xfs_alloc_log_agf
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: leo.lilong@huawei.com, dchinner@redhat.com, cem@kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <173352746897.121772.5621271968296589393.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Long Li <leo.lilong@huawei.com>

Source kernel commit: 8b9b261594d8ef218ef4d0e732dad153f82aab49

There are two invocations of xfs_alloc_log_agf in xfs_alloc_put_freelist.
The AGF does not change between the two calls. Although this does not pose
any practical problems, it seems like a small mistake. Therefore, fix it
by removing the first xfs_alloc_log_agf invocation.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_alloc.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index f0635b17f18548..355f8ef1a872d3 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3152,8 +3152,6 @@ xfs_alloc_put_freelist(
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
 
-	xfs_alloc_log_agf(tp, agbp, logflags);
-
 	ASSERT(be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp));
 
 	agfl_bno = xfs_buf_to_agfl_bno(agflbp);

