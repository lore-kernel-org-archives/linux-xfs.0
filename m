Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CF4221265
	for <linux-xfs@vger.kernel.org>; Fri, 15 Aug 2025 19:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755287901; cv=none; b=hq/40wkCIHI+rZPF3TwnFTJTTNGeWJB26dyKQ07w5t85xlLtKL75NDxnsmdLGKTlMHo34WdBVwCLMjMcgNAhfv3miXGZobosZPMNElmLRFhF6uFpgMihxlJ7T1cq9Gceq/Vl7SfSePf8eYfTdeNTCgvnR9EZ56EfO5YAfEZl+xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755287901; c=relaxed/simple;
	bh=cbrmiycR5HXX7M67f4YkBMpfvM7AhShov1HAbshhu/4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Oo1QImNQxqFeu0mL9RRDfb93W3IuO8ojrsoyTcqlvDkJjzFvIlJ8HgDUyBvKqEnPvXrTIFNW59nxHvEkVrGwT067KTEbbMcG+bETWpCtQH6rlDuIpamjOPpPUB5SUYn/j3ZcXSj7b+q73X5P7YmYoXQNEAFP5mmxT1fQwHUJAP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9/V77oC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9/V77oC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77160C4CEEB;
	Fri, 15 Aug 2025 19:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755287900;
	bh=cbrmiycR5HXX7M67f4YkBMpfvM7AhShov1HAbshhu/4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=H9/V77oCecZIyUdoC94Bpbt5uVbSGkLmKkooYKCzM2oOwqg3wS1GUDAbI0NwlDP51
	 uQ6/AGNVUoO9XKtBh9rG8zZmy2+hohsGRnD7Ky4ICIAQYR9nvsyu/J3AQAw3Eyp/Uz
	 spkiluJpS3ROgd+c/dkBCkQQygbpkcwjXPYH6KG/TFOjPmCP73GAWfMySADG6/XuWF
	 /vuMavrcCYRLNc43CgNNKb7NcGC2wf4REXGoMyvpVQpV2in8Xa/h7GrdlOsTb5rDzI
	 t/oSF2T23BGhKvTvXbc0lhw40e4B3vy6oRzb0n7p7xeH4Wz7dpAJ1eX1tgXAifOcNu
	 arJ/rDsplD+cg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE45A39D0C3D;
	Fri, 15 Aug 2025 19:58:32 +0000 (UTC)
Subject: Re: [GIT PULL] XFS fixes for v6.17-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <4uzlmlwbgmv5e7u6ytcigddcqw65omiopv5thji3h4bbt65vrh@v2qu6rexmojc>
References: <4uzlmlwbgmv5e7u6ytcigddcqw65omiopv5thji3h4bbt65vrh@v2qu6rexmojc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <4uzlmlwbgmv5e7u6ytcigddcqw65omiopv5thji3h4bbt65vrh@v2qu6rexmojc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.17-rc2
X-PR-Tracked-Commit-Id: f76823e3b284aae30797fded988a807eab2da246
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d0efc9e4276cda07c2f76652d240b165c30b05b8
Message-Id: <175528791135.1256160.17122852754300773066.pr-tracker-bot@kernel.org>
Date: Fri, 15 Aug 2025 19:58:31 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 15 Aug 2025 20:28:43 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.17-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d0efc9e4276cda07c2f76652d240b165c30b05b8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
