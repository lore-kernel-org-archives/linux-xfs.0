Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE27C390991
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497200; cv=none; b=j7IusUNhWzhj9yelFUqCZ1ilHqhzQmmCqhmQmFzFA60Quiz/0cB7dUDSzBBbBABPaYYhF8BDn2yUaYi6MbEN7KJU1VL+ofWRcQd2Ovsc+SUtUCJz0xezw9gimM1Ben4FZB32XizJ7AA9lb/9/Djty6yj7vuqbGFXGTwGdpr7r+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497200; c=relaxed/simple;
	bh=audu9TOSi2E85fIuVZEVFla5cfN5v02x46MHL/sAEgo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YyKOt3inoBlcyoJhJMAsviw1IPJyfa/PwKoRl6GLnbtAGECm32uoKwO2sEnA3cc0jFrB0oaEqj9xvEmNBpr6w+pf6uulJhm2lMnFyWQqfmXxgmvOTOqdmSEwHV6A07J0q/SxITzaONUHH6ZMkt8WF9vPvrt/qyvPb/XvKzRQhBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QiXTYkxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QiXTYkxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A221EC19423;
	Tue,  3 Mar 2026 00:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497200;
	bh=audu9TOSi2E85fIuVZEVFla5cfN5v02x46MHL/sAEgo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QiXTYkxKGTE6GkWchqcB3gOYtOqpZmbJrDYqkQSuDKOR8S+3ib5EhU0AMP4j8xP1j
	 PXl3NZhg2dmhyT81w6qSqUT/9OmOIvb+xqG/B4F4caRy5kYO7HFdVdXHvxVOxLScoO
	 lVDo5OQRqcK2HWwp7w82LlYs+kDGAyRUEdcQY1azY4Hp/28fOB/JIQDrG0Fcm8Kvt2
	 dFCGBFryDFlUVH7ne/V+rlNesqyHNaRegnD7ou6UrH28Jw31S1hyM9TO91N4MZ2euk
	 N9moNFUwHCqwgPKX3V+KwLu313SI8LwSHhh27MiuwyIpzpN4ynbZn98VoapZk3cH1+
	 5La/WY0Bj8cow==
Date: Mon, 02 Mar 2026 16:19:59 -0800
Subject: [PATCH 30/36] Convert 'alloc_obj' family to use the new default
 GFP_KERNEL argument
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Message-ID: <177249638330.457970.1851487051288611819.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
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
 

