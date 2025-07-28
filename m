Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EDE253925
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 23:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753745999; cv=none; b=toSA0n8OZr6pLn4yBNfqse42BpiEyrrMkSvMcJ0Q0YO4EtGzwwc6nu8QV7lXNlxNZuenWfDg/c6VfZ/2iL8PEwsHXEQSR4ik4RyDaKo1GqKHtxxkHpnIa+fGgCMrq07yB4JfO8DhMcy7MPAXlRowSXp1/5G1y0Bh5nLxz7E9HfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753745999; c=relaxed/simple;
	bh=XEBLZEqvI3tCh38SVMjk+KU+TJ+RFNpkkw+htWifyk0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ttNjTK7qa2T64pAPr3Ry0djMtaMDBWZvG0bYrc8hU3cnTlQ+Hrrm04oMqOKlszo+bgxoHY7snX/jO29AysEY/b8jP6ISqlqW19Zzki/YClzkMfcsbU/7nMtsi+r+ZrtJW9gpFp+qzpYZOEXX2gMfsX1QdoWmrSf+1qxz63aILW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m4TK6sgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4TK6sgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF1AC4CEFA;
	Mon, 28 Jul 2025 23:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753745999;
	bh=XEBLZEqvI3tCh38SVMjk+KU+TJ+RFNpkkw+htWifyk0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=m4TK6sgDOqXydhHr8XVUY7W9O31Z2D2DYiPJCR34yVQrikaNenRpFSltE2p35MYaj
	 24h8DgBm673WtFv1DvvVM0vgofbfluHW7StGXF4YLgVkSMTOHjDJf9xMCOHn3Mx1u8
	 o8Au2EmCdFcQY1/TSXhxG6RdMMFmWCFp7HAwuGWEBEJFc1wSv3D71+U3yHXlb2BMA7
	 8PTGHeiAKGoXk3AwPKUsfSm40Pk/hvU1kJ17AzoAEeACBJS7h3OXKcXGb0M6EhNi31
	 EbEz4yoYEXCajABME2JvYqglzcFeeD5nG7LYleBPqDdLd9D56W1jyY67GXX5IC3Cg+
	 J0k4o0ot7Pxog==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D4E3D383BF60;
	Mon, 28 Jul 2025 23:40:16 +0000 (UTC)
Subject: Re: [GIT PULL] XFS new code for 6.17
From: pr-tracker-bot@kernel.org
In-Reply-To: <sueusz4drzu3yag3w6psq4ewym2a3xowzkz6mafeommuf7swwy@dx77kbi5uldo>
References: <sueusz4drzu3yag3w6psq4ewym2a3xowzkz6mafeommuf7swwy@dx77kbi5uldo>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <sueusz4drzu3yag3w6psq4ewym2a3xowzkz6mafeommuf7swwy@dx77kbi5uldo>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-6.17
X-PR-Tracked-Commit-Id: ded74fddcaf685a9440c5612f7831d0c4c1473ca
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f3f5edc5e41e038cf66d124a4cbacf6ff0983513
Message-Id: <175374601575.885311.10163556552419024206.pr-tracker-bot@kernel.org>
Date: Mon, 28 Jul 2025 23:40:15 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 28 Jul 2025 10:35:07 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-6.17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f3f5edc5e41e038cf66d124a4cbacf6ff0983513

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
