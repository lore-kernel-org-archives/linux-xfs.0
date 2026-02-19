Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F3F325712
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544736; cv=none; b=kFl+Lu5gtqoNtxFdEqNrcOGrZ9hZ/AYAQGqGEDbTr9bZv+Zx5ZJGJfaXb9qStEI7a2xcKTtFkdFie1bsyrvQ8DzkDmdNjEdeaV6AEtfCostYCbZFEVmrc5d7b9cdRFw2Gsvp8WyhcgvXM//egCsE4X/KDlg4qXTZ3ZLvDT8Tg8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544736; c=relaxed/simple;
	bh=orfpf6z7mxHBShmH3QAVXuls5JT313wnMhN9QT/ZWO0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OM2E9NpocNvcFtDOHp7MmS5Lk11RHMkAIzi8cVwOaF0DqRUUIDatbSNS8gf6yQLpDMGO7h81inRcdWpKPwk7ng/QSPFxAMb5MmGe9Bt6Owden4qk5wxtIDa5xkwMy6979V8RCs6TCkrpVxq7neYcRckqIGOPVwNU04//EoMB6jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IX0K996k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IX0K996k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6736C4CEF7;
	Thu, 19 Feb 2026 23:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544735;
	bh=orfpf6z7mxHBShmH3QAVXuls5JT313wnMhN9QT/ZWO0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IX0K996kKzF6Tm8E0fIyIq7CZhxFFj3/c2sHEwWBj3thIUWJpzxgol7VI737g/b9+
	 JgdiPPdvJbaReQKLtXX/+iI53Yno3+JSQUoZw8t5g0ZkRIcCtu/V033vOQWn3Utg0o
	 JeWtPMnSXN3fEHhJukMC0e21fGyTCfF7+0J8E13Zceb9InJ3WWKhLSqSqbZhXLuZ3o
	 c250m1WubJX3w6uZHVS7ZXjiir7j37LuxUokjjMSJIvOoj6i1/6E+Un0Wdz8YIFrxW
	 8lQYuvakn9oprtFxUygIz0nq+hfcA+sqy3GWUH6xV/afAvuVjI+Z0NgN+WOGV9Lm10
	 4D8FxW8QYC9YQ==
Date: Thu, 19 Feb 2026 15:45:35 -0800
Subject: [PATCH 08/12] xfs: remove xarray mark for reclaimable zones
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, hans.holmberg@wdc.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <177154456873.1285810.8177929225997763863.stgit@frogsfrogsfrogs>
In-Reply-To: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
References: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Hans Holmberg <hans.holmberg@wdc.com>

Source kernel commit: bf3b8e915215ef78319b896c0ccc14dc57dac80f

We can easily check if there are any reclaimble zones by just looking
at the used counters in the reclaim buckets, so do that to free up the
xarray mark we currently use for this purpose.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtgroup.h |    6 ------
 1 file changed, 6 deletions(-)


diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index a94e925ae67cb6..03f1e2493334f3 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -64,12 +64,6 @@ struct xfs_rtgroup {
  */
 #define XFS_RTG_FREE			XA_MARK_0
 
-/*
- * For zoned RT devices this is set on groups that are fully written and that
- * have unused blocks.  Used by the garbage collection to pick targets.
- */
-#define XFS_RTG_RECLAIMABLE		XA_MARK_1
-
 static inline struct xfs_rtgroup *to_rtg(struct xfs_group *xg)
 {
 	return container_of(xg, struct xfs_rtgroup, rtg_group);

