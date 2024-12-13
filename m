Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA2215573A
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 22:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734129248; cv=none; b=A968aLzHv80PJCfXyAlxNzZLYC9BgP/lq9yya1mPxSHT9MSWdgZoMLGBIjHz7KX1HgNKdazIT3799mQlrAvptG2y55sSgcGWL6IX3M45MGtxThP4gUO0yS3BYg3p7Sh0qDwdnvMOAw9RnmfCkQVnI2fpRQhGYMHmP0vtag0Xgb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734129248; c=relaxed/simple;
	bh=5YLPfLbUkzmSO1KG5KW6JUBLHZq1lzHrgNTzFxffBDY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=coIoxfRAMnRUHuCfBG/M62k2UTn7jOrhkNfwOnXJ0Nw3da8z4YWEYM4ZmSHqmXbIEUK/zxiIke2ABffOScN7a/cZ2lqL+nRpvFLE4yNpOFbHk6SLaYFxCSDs1B4uhuDAMdZ/E8VbF5W/ARymN8d7E89WADP9PxTEEsxtvZXKBU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGzlcuW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGzlcuW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD0DC4CED0;
	Fri, 13 Dec 2024 22:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734129248;
	bh=5YLPfLbUkzmSO1KG5KW6JUBLHZq1lzHrgNTzFxffBDY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=HGzlcuW+Nefyr6VHnt2Uy4lbS5L2ynw85BICraHwW+YlqCyHPoyK4/Wws41kPZIVh
	 pHd6TMUYED+UTEB5/jTpmC8+XZqM4JOxg5lD9PV0W98qAtBzO5rYkWcv/j0pZco/I9
	 /MCg+GM/4/s/26+3r5KiT26OZrqR+gZBSMi/mY4eDXAgE8SW+HXJTrZhcP68EB0iN5
	 bjNQUbzBgnC32jmaDi65MwDILJoepVszvvUvYGMz66DwYsPqkT8HDbNx1Y18EH2D9c
	 hkJUW+dKDgqgzhx3CjfIAyWrCz35h3qSL9wuwYuQlK+51/gJPalfTh9LKev7F9444B
	 wmx8XPbwvht6A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34100380A959;
	Fri, 13 Dec 2024 22:34:26 +0000 (UTC)
Subject: Re: [GIT PULL] XFS fixes for 6.13-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <cf5d4x5hfxbsca5c5g5o5r7k225ul3v67liy365gp5wagq2yzv@6v427uwmp5vz>
References: <cf5d4x5hfxbsca5c5g5o5r7k225ul3v67liy365gp5wagq2yzv@6v427uwmp5vz>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cf5d4x5hfxbsca5c5g5o5r7k225ul3v67liy365gp5wagq2yzv@6v427uwmp5vz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.13-rc3
X-PR-Tracked-Commit-Id: bf354410af832232db8438afe006bb12675778bc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4800575d8c0b2f354ab05ab1c4749e45e213bf73
Message-Id: <173412926492.3178864.18412029160498733408.pr-tracker-bot@kernel.org>
Date: Fri, 13 Dec 2024 22:34:24 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, hch@lst.de, djwong@kernel.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 13 Dec 2024 16:57:36 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.13-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4800575d8c0b2f354ab05ab1c4749e45e213bf73

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
