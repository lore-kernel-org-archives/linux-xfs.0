Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D583322C99
	for <linux-xfs@vger.kernel.org>; Fri, 29 Aug 2025 16:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756485595; cv=none; b=Ig7CXJMMkhyUbhld4x+OGLVTHuLhrMr6Y5vjTkMvoSBrwz2tPlyvH4kMK7A5rFAUHa8qlyjicwgxmRsZ0khPK6cLgsUtSg6JPVXJxneFkM+nLTWDx57U8OaKLHYygbispBo2mg/79L22b5fTwi6ngWcbpqEsyiBjAkLSN+Xu33k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756485595; c=relaxed/simple;
	bh=d0n4/PLaBifRb/BqRy+uFpAIe/nwQ0VbHOT7ppA0B9g=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=OzDAHEducUVTGYKcnZ7iu6PJmTF8gXxn2ijKqLDjWjwyA2bcuIZOG6prKFMK1qHniVLXiqFAxm5UfyqnVXiSBywT4CDyq4rDq5Lpj5R+7bCNSJRjt/0S5XD4Gj64rrGoa7x+jgYoVJr0fYxAIynipPsqtUei4ynOLCTWOPvU/CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SHEKyn4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SHEKyn4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32041C4CEF0;
	Fri, 29 Aug 2025 16:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756485595;
	bh=d0n4/PLaBifRb/BqRy+uFpAIe/nwQ0VbHOT7ppA0B9g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=SHEKyn4gm5hcBYEmZdVmod4wVLsCphAaUOH8c5SNlvTvn1Q+PybRw9oCYZ7gyWlVy
	 XcI+yo3zepUGG85kj2tHU1i4mIrVV9vWvO0uSLCSyYtJZJUkA6SLTxv+6VyGqny3aH
	 yWab6BMVDorqNBWRB7FuCwafJkBHkQfckCQ3bTUyX1VPz7tbws+j10tqPblBiLaTGp
	 GZH8Zm9NkmhwG8rIWudAcUOLzWTIGP/XZ9eS/1RdaTD/OMRgcOOPf8OOb1sSRyVlKv
	 R1lK0+lb6F8/dWhyGQiMMPCMgz7A8J5e8nlv9eUIvnl6Gi++YWf1pCunIDIvGuMM/q
	 IGJ0xbLzaDVXA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3444B383BF75;
	Fri, 29 Aug 2025 16:40:03 +0000 (UTC)
Subject: Re: [GIT PULL] XFS fixes for v6.17-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <3uiirotnharj7uo3zjqlubc47cenqkzd5nqynoe37o3jkvodj5@dfezum2m7jr7>
References: <3uiirotnharj7uo3zjqlubc47cenqkzd5nqynoe37o3jkvodj5@dfezum2m7jr7>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <3uiirotnharj7uo3zjqlubc47cenqkzd5nqynoe37o3jkvodj5@dfezum2m7jr7>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.17-rc4
X-PR-Tracked-Commit-Id: ae668cd567a6a7622bc813ee0bb61c42bed61ba7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 469447200aed04c383189b64aa07070be052c48a
Message-Id: <175648560185.2275621.13628333829286232649.pr-tracker-bot@kernel.org>
Date: Fri, 29 Aug 2025 16:40:01 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 29 Aug 2025 14:01:34 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.17-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/469447200aed04c383189b64aa07070be052c48a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
