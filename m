Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC02A3F5BC8
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 22:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778883245; cv=none; b=WdWQyXa/dlBIlrEREmdS6ydEb8D196bad6KUTQ4WDRMS0sb9DmJpctcHjuclqtv6LRkoDkKrfakdJ13FFAYn7D2mk8eJZfKesGzOI7HxPWc2/QIsu0qpooQ5KEHXhpC8x1pIMfn4p2yeE1S4HrTPTCT9Jy4Ep690IEnjIecpJbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778883245; c=relaxed/simple;
	bh=0zhi75dqL4ZXwebF9r9VkRCsQg/f4G1PpjxNnn9932s=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=uvXdgXwwJKdrgTPHugu1g+OyqUbWiMi1VUogwEWLuf2BYZ+HaYFH5s6OqeUMjYZJ+8WsFq3y3svKcC8lqIDnVaYwAhT7Pr1WmlY169VhysMKli7mWIbQDOR+elz+jFN4kazS2A0pV9rjVDvtedLkkSwS48Y98KOLJmX8q2C35EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aP5vt4Cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aP5vt4Cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D081AC2BCC7;
	Fri, 15 May 2026 22:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778883244;
	bh=0zhi75dqL4ZXwebF9r9VkRCsQg/f4G1PpjxNnn9932s=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=aP5vt4CxYkzeIsRfseoIj36jHCWVaWHOxYdDVfqzkyHhIN9i0fstJP1Q3ynFDXaLP
	 EJtpkGbMoejIa15YsI4fdp6lF6hDlQ15QvbRhHuZIYPZf57c9YyDtkDAo/BkVyvgZJ
	 /iSxqTgzXLAV8seJ4AJk8HrAsyJPYVH1XUMEM9J20uMv25cZi+q/8OSWjDAOsFf+Sb
	 Qm+IwHk0whY+zE7MZOy+16maCAxbziDokzJYTeRPwOQbfxgzOKLKnKpUyPle301/Nf
	 BoZuQthm7sMAazI4Yj9n7KUVycjd6dCm54vg5u08wmUCa6kgCkdnFoGZkeMU27AYT2
	 FXgdcd0dVeRVw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 569943930A12;
	Fri, 15 May 2026 22:14:19 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for v7.1-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <agc_BzMjfmkuojM5@nidhogg.toxiclabs.cc>
References: <agc_BzMjfmkuojM5@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <agc_BzMjfmkuojM5@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.1-rc4
X-PR-Tracked-Commit-Id: 509fdeb3326be0db055e88d0f689a3888f147f90
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 663ea69540c8d7ba332c9a3129d7f3cf5de50d9b
Message-Id: <177888325801.173168.9757578993830862873.pr-tracker-bot@kernel.org>
Date: Fri, 15 May 2026 22:14:18 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 15 May 2026 17:47:17 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.1-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/663ea69540c8d7ba332c9a3129d7f3cf5de50d9b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
