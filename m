Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE402F9D89
	for <linux-xfs@vger.kernel.org>; Sat,  1 Nov 2025 17:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762018927; cv=none; b=mHhgKyjv6LJe8zUwK8FyGKgoZUof1famwGRmi8vqhEAxX9asmW9WV7wzhT0Z5ATSbdI3OTjtueo295V0C+2aiMLxkgv3+QwcyJyEi1ODzHL73NNPgNhcCPb0ArPSgsXczKG/vALg5vmQBXw4LrofCiWXbbtENKxdg6P9nsrIryQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762018927; c=relaxed/simple;
	bh=fbBSClU7DAw3qyMKwc8iKzWipWNS7aqDrnRtt7KBTRE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FA7TCutGT6xxxJbzzN5nKwLghDseUF6Ysu6gQirk6IAtZBpkgnke1nZN0L/BSHK+wD3UFrvlrC9VFtDe4py5+lSKGE5t8h4IXYcuUqj96P8hj1ccIqc8bWP4LflM5ut5HCIVD31hhmyRdtrU+DSIybCZ5hvo1FCcZkodC2BFsXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A5LUUC9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A5LUUC9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC95C4CEF1;
	Sat,  1 Nov 2025 17:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762018927;
	bh=fbBSClU7DAw3qyMKwc8iKzWipWNS7aqDrnRtt7KBTRE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=A5LUUC9bPjaSszRZGelzdpEFFOigDvJJcIcPfThFaYwAbCf8ypIcNjjNjI+w2xyqq
	 Ul+m/ucyzOVLoqX6kO5w6iScc6kBTqDT1wbHyrm6evTSYKgOfEqAMA/dlIyBFQyFcd
	 WxcrvA5Juttij+OXfFXiHLpeN4lBoxw9fuScpCV246xGGhURHBz6kKsKhx4u6iMUmS
	 yX7RnaFfFLABy4CnISbYka8gQJ1g6+2nZHn0l7bR+ECx8rAPJOgvbB+AFP6f1oWQls
	 HLlbOIFhf5E5p+ppGfHcrkuOIKoHw/bliZwuCT//QQ6v8DFDdKUAOHjmRhDUeHjHbK
	 HCKF94Dy4u5tQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB15A3809A1B;
	Sat,  1 Nov 2025 17:41:43 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: fixes for v6.18-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <gq4gdpaijznzx3syhbpipjsdlcladlv6wain5y7fjqgct2zkpy@dnbipiq2yb46>
References: <gq4gdpaijznzx3syhbpipjsdlcladlv6wain5y7fjqgct2zkpy@dnbipiq2yb46>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <gq4gdpaijznzx3syhbpipjsdlcladlv6wain5y7fjqgct2zkpy@dnbipiq2yb46>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.18-rc4
X-PR-Tracked-Commit-Id: 0db22d7ee462c42c1284e98d47840932792c1adb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9db0d7c5a5be25e56c3eacc1f03d296b7b0b960f
Message-Id: <176201890261.850663.17781629601704154095.pr-tracker-bot@kernel.org>
Date: Sat, 01 Nov 2025 17:41:42 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 1 Nov 2025 10:15:10 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.18-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9db0d7c5a5be25e56c3eacc1f03d296b7b0b960f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
