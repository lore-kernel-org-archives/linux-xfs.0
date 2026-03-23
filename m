Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE7E31D75E
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291779; cv=none; b=td/0qm8MgR5LeW8NgJxgBI1Zp32FYPwl4M4t+l6r2xZvAXITndllZ267WfDok6s+OwriF7TztSDbBVozeykuqWl6QdKCeIZa2WOVtv3ddnwnInHmaEebmhvqyX2NOxmXfrrwltMAl5C7EATcyhEE5sV3Z1cyQ0asyTVudVCDE1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291779; c=relaxed/simple;
	bh=audu9TOSi2E85fIuVZEVFla5cfN5v02x46MHL/sAEgo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fBGW5JWG//+wRJEG1xSxDLqB0xJJiQanA9LpliGyomfrB2LrVBfps0smMUm9zXV4/J1SxSvUCe7H5DmN9kGPlCrXsnsE0mdsRHHQUqw/Zgj60A+9ql0Xr1Q86ILGCSopDAqgIvrglEGhnc0fbI/MQh8mIcHLisYG8qCGN2WP1TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k291XIyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k291XIyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6965C4CEF7;
	Mon, 23 Mar 2026 18:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291779;
	bh=audu9TOSi2E85fIuVZEVFla5cfN5v02x46MHL/sAEgo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k291XIyWB2si8iWAvMQbyAVt7WcJiQCisgR6hRYbadU0mDZRV+wD9aqVnz8/U+0MT
	 EVZqFo9zQXlz3SbHCFvfEq5g1Ax20smqTLSxHqWbg43VvnV2f+iuByxN7FB0u0hQBT
	 SIqjPf5oO6Fpx6ydi6jzjeF4VGllJ9bkRDinOsUA9LwckQGccOCBQqNOzmPyoO1WL5
	 2VkdYl04rsylBqFWBSN59zMNLfKRLtw2lV0q+yHBM1RpPe5uUV6D7+a1R7IryBq7s7
	 Gt9Yzkmk0Prh0eJqF5oaiq7PJnS8A/9MdXSKDjhb3V+os+T686Z2T6OL6oiqU4UYdN
	 IBclz97yJnI0Q==
Date: Mon, 23 Mar 2026 11:49:39 -0700
Subject: [PATCH 32/40] Convert 'alloc_obj' family to use the new default
 GFP_KERNEL argument
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Message-ID: <177429121328.2266274.2437421086621550448.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Linus Torvalds <torvalds@linux-foundation.org>

Source kernel commit: bf4afc53b77aeaa48b5409da5c8da6bb4eff7f43

This was done entirely with mindless brute force, using

git grep -l '\<k[vmz]*alloc_objs*(.*, GFP_KERNEL)' |
xargs sed -i 's/\(alloc_objs*(.*\), GFP_KERNEL)/\1)/'

to convert the new alloc_obj() users that had a simple GFP_KERNEL
argument to just drop that argument.

Note that due to the extreme simplicity of the scripting, any slightly
more complex cases spread over multiple lines would not be triggered:
they definitely exist, but this covers the vast bulk of the cases, and
the resulting diff is also then easier to check automatically.

For the same reason the 'flex' versions will be done as a separate
conversion.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 libxfs/xfs_ag.c      |    2 +-
 libxfs/xfs_rtgroup.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 0f1eaf5d6e39b8..5742d59a2659da 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -222,7 +222,7 @@ xfs_perag_alloc(
 	struct xfs_perag	*pag;
 	int			error;
 
-	pag = kzalloc_obj(*pag, GFP_KERNEL);
+	pag = kzalloc_obj(*pag);
 	if (!pag)
 		return -ENOMEM;
 
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 69e71494057a1e..d127ac0d611026 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -95,7 +95,7 @@ xfs_rtgroup_alloc(
 	struct xfs_rtgroup	*rtg;
 	int			error;
 
-	rtg = kzalloc_obj(struct xfs_rtgroup, GFP_KERNEL);
+	rtg = kzalloc_obj(struct xfs_rtgroup);
 	if (!rtg)
 		return -ENOMEM;
 

