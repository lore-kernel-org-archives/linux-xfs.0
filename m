Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CA6313532
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 04:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764823893; cv=none; b=jOZibXTnvJCjx4wb/Fiy/eTd0W36AI/7UcvF+apg35KD1WzWTtMGUuXnnKI6d9IhcCK9+d3phQuNv6f7km8xJnIJQr/9jHy6a+hTlUOr439dDOIxikmELhNKZJCU5iPvxBmNhG/CNBsGfO2iR3RwniWcK2GaGRBBjv740l6/P10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764823893; c=relaxed/simple;
	bh=jYLruNr13gy9rijHLUU5rw5LHrCTvYbjFq3/8g9w3g4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Ooc5eQcVPT/FHD6uVJN19H9E5hN4JknURSSptYiuQwBMOL6if2jOKOP/Wqm0h54jyYL/P5od9cB43xAH6KDj/+FV47Cu17dPVWgnR0feVgCYBUTOwU0ZGcle1F0pLZUpYiyOcrfUFf0pFKrVIEMZFVTFwaZnF4ORF3727a+axhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mtPWT9xO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mtPWT9xO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376A2C113D0;
	Thu,  4 Dec 2025 04:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764823893;
	bh=jYLruNr13gy9rijHLUU5rw5LHrCTvYbjFq3/8g9w3g4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mtPWT9xOdMYqbnThOzUlm0J2XYwQozmzgJWkyVDfWmhs8FMGZgi9yL/oFKumKF/J4
	 rEDIebCjrjv1+wr3p6is3AkeK01t7aZar8YrdJuDDqydoj6hhSLCCuJYQv6Hw9Ajd9
	 zf40AG5fsZg3qYWMweMvzgCj1Dy80puU78wQwRobnnBzBCB1HOun6PnkUYpplgYdby
	 ogtJL0fAS72YBEniKmWjDWQWGdsdmLv/JNgfxrhmSjRewmS7C8eL4FbEAePhb5LGoP
	 hnU4OlIMgO/Xb+G5Ba/RL3vHa9kB2eyUxDraiOpbmCHj9nNVMxWn+O+ltc3qWYpd+k
	 GXhVT5NLa/ftQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F2AE93AA9A8A;
	Thu,  4 Dec 2025 04:48:32 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: New code for v6.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <2lje5mt266gixlqrnqfnkrmcxwjdnu72emnz2gywn2hs5r4z7r@zuyoxysv2uxq>
References: <2lje5mt266gixlqrnqfnkrmcxwjdnu72emnz2gywn2hs5r4z7r@zuyoxysv2uxq>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <2lje5mt266gixlqrnqfnkrmcxwjdnu72emnz2gywn2hs5r4z7r@zuyoxysv2uxq>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-6.19
X-PR-Tracked-Commit-Id: 69ceb8a2d6665625d816fcf8ccd01965cddb233e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3ed1c68307c4ce53256e15b8a8830b12bdba1ff5
Message-Id: <176482371148.238370.2843593174720531114.pr-tracker-bot@kernel.org>
Date: Thu, 04 Dec 2025 04:48:31 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 1 Dec 2025 12:49:56 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-6.19

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3ed1c68307c4ce53256e15b8a8830b12bdba1ff5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
