Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342A427FD50
	for <linux-xfs@vger.kernel.org>; Fri, 16 May 2025 18:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747421799; cv=none; b=YxoibhXJW4HYpehdbsSr2dK3RRXo8mJ0OVo4sIsYx4VqHf1tuI/SZc5Mlx/wIEkwSHy0tv1ByXm+ZSifGceQc+7xkHMPkSKOIG3shMMkzYyKngHq7hzsIQYpZsGfNBfyF+1mlv0Z7FFF/RY15k5hQ2FySPpjvKHUbPVn8mUTRCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747421799; c=relaxed/simple;
	bh=6aAIwmYBpydP7CmclcTy37ctowklw9EaLowDMAFkPcs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=I5v4yo14ig8u7LrZKSxq/74alUvWWJXY3Y0zNPvzk3vr8PtjLYBaoVK/e7s2JyDN86k8i61/cHT+jeVH2x5ND/jFMZkhqHWrARiLeTzcqOBWpNPzZQsHxLYpGvU3gs0b3MQHabUXRKnNplbJMc/iX1gA/a5EwoWXiyb0n9o+7KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbndH0gT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbndH0gT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D208C4CEE4;
	Fri, 16 May 2025 18:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747421798;
	bh=6aAIwmYBpydP7CmclcTy37ctowklw9EaLowDMAFkPcs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bbndH0gTXuZG6QfymOdmryfMLHmUg/8MSBxtH3QjcS2EufLrXEmaumclLsnRg9dHB
	 On55huvnzGgcXX0G095zoboLZy6/3QTcmHitm6sGQDeTRzINZFWsPvwOv0INls3XaD
	 +WNsRJ9PpU9s7NsiaMH1lRh2UvJBQD7laIiv3kZJODOn6kZCXiDVpNocjKwWNgxYSK
	 RSRz5yZMqmhBWpcyD0rLYbPVRTe5Fd3T+nhWzsIaTYgc+Fg03Kgrgg/W84zRg8z2h6
	 HLCXrkXzu/GfSbtPREXXXodY0cOZYHmUJnuuAd4zpoob1unVeTYjeO2FcYeMFuQLxE
	 aXhxnRdZ7yuUA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADCF73806659;
	Fri, 16 May 2025 18:57:16 +0000 (UTC)
Subject: Re: [GIT PULL] XFS fixes for v6.15-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <fo6f25yd3ywgunzhimk6s3c4vmh2bbwic7ihbq6agcafhyhcpx@5akhizn44tqy>
References: <fo6f25yd3ywgunzhimk6s3c4vmh2bbwic7ihbq6agcafhyhcpx@5akhizn44tqy>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <fo6f25yd3ywgunzhimk6s3c4vmh2bbwic7ihbq6agcafhyhcpx@5akhizn44tqy>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.15-rc7
X-PR-Tracked-Commit-Id: 08c73a4b2e3cd2ff9db0ecb3c5c0dd7e23edc770
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1524cb283074743def4469256ae0f555edf06be3
Message-Id: <174742183515.4031545.6387146706836111431.pr-tracker-bot@kernel.org>
Date: Fri, 16 May 2025 18:57:15 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 16 May 2025 15:16:39 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.15-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1524cb283074743def4469256ae0f555edf06be3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
