Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0C4153833
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803957; cv=none; b=Wag/jxxmLJrTN0ptI4fD3d26T2f4FBYKWMgcO0mStrZ8SMPubUDr+Rhv08zCc9y1NEkc7eSQ4Z/DojtOwdtqueIChNLDdINCLHzHtW3RV5YPc0iiPSFLxVCXs0AwWPXdoq87ilJzJgc+ABLa7O8bLZ43NapvxXTrAFNPfFNxwAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803957; c=relaxed/simple;
	bh=GOdqprI8nrfgICBT9hOwQ5WModjn3kps2kn3kqtvbAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbzTnv2MhYIFJINdghrXiwrFlzaqYG2SSVIysuC6AnPlZiiqYaF3t77JuFuq3Hv8+1tQ8ZuX1sFbRqeFnA9vTUbBkahg7nEjgi+JqC5d3Uesam3rzaiPPiJtmN892jllNBKW7PXBlQKWJ/mJQv41WW0AU/oj+7Ht7R5zjnrrZTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CL1WD9pk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CL1WD9pk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B06C32782;
	Mon, 22 Apr 2024 16:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803957;
	bh=GOdqprI8nrfgICBT9hOwQ5WModjn3kps2kn3kqtvbAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CL1WD9pkhUwmiCUYKsyIkfCziF1Gos6sdhtnBlz6+nLG/kzcv1f0kVFt0ZKyCVtfc
	 FACfcCEXMA8sm9BXIjPenH9Oy4C9dH930sY/m6NpjT/YwuvF78na4S8c1Gr/lZg7KL
	 r6QIEROGHnbASOlakdwb7eZNm2OFhclPMUwVJf/gVZWerPy4tbjXoc4ALN2qe0L559
	 Yk/V3zlXBkUk6cNePyCLVGj1BH75JBI7pLkl4XceB3fkm2o82NqbuhGsiPtNN75rgr
	 LKjJdYKHFno0YgmkB6aCLn5t+MUr3dGEQTULouEoeYzOtLFz1RdN0q872zbB4h/78F
	 oL9ZkbsJJOaTg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 06/67] xfs: hoist ->create_intent boilerplate to its callsite
Date: Mon, 22 Apr 2024 18:25:28 +0200
Message-ID: <20240422163832.858420-8-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: f3fd7f6fce1cc9b8eb59705b27f823330207b7c9

Hoist the dirty flag setting code out of each ->create_intent
implementation up to the callsite to reduce boilerplate further.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 6a9ce9241..1be9554e1 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -235,6 +235,8 @@ xfs_defer_create_intent(
 	if (IS_ERR(lip))
 		return PTR_ERR(lip);
 
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &lip->li_flags);
 	dfp->dfp_intent = lip;
 	return 1;
 }
-- 
2.44.0

