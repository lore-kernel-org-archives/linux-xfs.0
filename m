Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F64C4A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607108; cv=none; b=labgj5Wba27VLJgiBpI3xPeMP9Zh1SnxAIALiVEKZhxjI6D8dlRcdelzGT595XRNa1fGRnDiEH0mg1DXRl0+BYXCFf8OrAA4eEeAFiLL726lO0S4YpHE3jjyi3GwXE+eQDaCPjMBwN6tNuTjtf0uuK0QeHWe7rMsEFdW7qZ1sk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607108; c=relaxed/simple;
	bh=sV1eptP9GyVv6cDRbKlQM+7GSbvoyuOq5Jmo/tLOti0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wc43QJupVfgWu5PZfJPrr9JKqY9iWMSBBUOjfLj7ONm1U0lFvGkGFRInNnNhP1z6LS2YAmntseMidLM4LqRCqLN32/5PNn4z6qNzwZtNzdPjOLH5kZWrIGWdCVdYDJ+oX5cRm0D+h9ghPA6WI8k6hKejrtxUUeFZDQrc92ClKUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZVCGlV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZVCGlV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636AAC4CEC5;
	Fri, 11 Oct 2024 00:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607108;
	bh=sV1eptP9GyVv6cDRbKlQM+7GSbvoyuOq5Jmo/tLOti0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JZVCGlV2vdquGBNWJBxZly2EvzcKw/BxZqPWb5dxE1ue0UVELHKIDBE7Wk2Bplcuj
	 xwYjRwanEcwiB6JqwXlRFN+jqu9uT1alibkpEyEYWu43A9n+Dw6SeYmUlUvXaB7KG9
	 OixQfgMzgF42QcnVYMCTg/5l9y5e4hG7klPRBDBLA5MQIgmiPnvEUkk1Y1W9/pNtUn
	 AGQ4IflSVBSdaPnZClvgVA+u3ZHhhWhKXtOWzoHtW7JR7zrriB3BXPnchD4ZZBlZ7Q
	 wSawRjB/Hy+XR451MxkCgmB1dsFMTgyLwZ7G6SLoK+HCWQY9ti2lM+yzVbuifNdHfP
	 qthmu/NP5BH+g==
Date: Thu, 10 Oct 2024 17:38:27 -0700
Subject: [PATCH 03/25] xfs: don't use __GFP_RETRY_MAYFAIL in
 xfs_initialize_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640460.4175438.12667208165438940417.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

__GFP_RETRY_MAYFAIL increases the likelyhood of allocations to fail,
which isn't really helpful during log recovery.  Remove the flag and
stick to the default GFP_KERNEL policies.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 8fac0ce45b1559..29feaed7c8f880 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -289,7 +289,7 @@ xfs_initialize_perag(
 		return 0;
 
 	for (index = old_agcount; index < new_agcount; index++) {
-		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+		pag = kzalloc(sizeof(*pag), GFP_KERNEL);
 		if (!pag) {
 			error = -ENOMEM;
 			goto out_unwind_new_pags;

