Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C863347ECCB
	for <linux-xfs@vger.kernel.org>; Sat, 12 Sep 2026 16:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229865; cv=none; b=R7wH2VYvgQYUwfMdLF9CZaE+agjirDZCTBiSgUyfgE5vy4gcM64kBt508wJB/tmQiznSAWeh/3kWWYPDCMSgP7NiNDQZ+jGcQjGveVYFzgZBFZodLt6v5jGsYB62VN0JBayZtK+lcLC1P97C+PCpmiLU+jOQRaWQ13s49aNRi/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229865; c=relaxed/simple;
	bh=GBtoN1BgnHGocn5/3JrGGx/6BOmSWVanbMwA1nNDCB4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=hMSDrXoiXrjNrenTzSFu+04JSASGWmXiEaGkZUdKQI7CQohlldbsp+qcn2YhqlCut/VbP/CLmZ39asR8F1pVofMrPHs3fUH2CufO6ewYM4UXZAoDp8Lrse7Csx1QdGifZlZj96AWVynw20ODiOV4CWiTLDgKUwKo4YiuGkJK10A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EhNBz826; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EhNBz826"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903091F00898;
	Sat, 12 Sep 2026 16:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789229863;
	bh=SlV64N4e2NlApk2j+50usUgRxCfPlvtxb0QesigY+Hw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=EhNBz826r1Z5eTgTTi0/zSl4kDMDPa4tkJ4xzTXPd9HsTqt5pmdE88VwUIPBpNsnk
	 lTftrbvoQTechRYf9JRNS2OYL+sgKSDPYBmigvk9TBXBjNSNiANuQmQp/ixs04Mnvn
	 9rH45okZm2AzQvMAV9yt7Jclez6gy7LC5j+buKfYmK/k2hhFyTBMNqSNwHCHpp5Axs
	 D+2pneFcTwqhMxufKp13KjCWL7htKYy4Hq5XkURjYycIGoipY/fxTO+Xamf5nofVIm
	 o2+bCtv7AehZ+aDWAHBXljxvz6wGU/fZXdNHOnVqePK4st7nTqfqOje2ZY7ckEob5t
	 8FUKaNNGwf32A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19B8E380820D;
	Sat, 12 Sep 2026 16:16:41 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for v7.3-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <aqUKwxI9Bsw4VUZg@nidhogg.toxiclabs.cc>
References: <aqUKwxI9Bsw4VUZg@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <aqUKwxI9Bsw4VUZg@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.3-rc3
X-PR-Tracked-Commit-Id: ad4497a92caba4630f75c80d49cb947026213280
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cba2348ab114391f5b1a00fa65c5b739f13f0563
Message-Id: <178922979991.3530607.3789610399284053806.pr-tracker-bot@kernel.org>
Date: Sat, 12 Sep 2026 16:16:39 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 12 Sep 2026 16:54:29 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.3-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cba2348ab114391f5b1a00fa65c5b739f13f0563

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
