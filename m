Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B590035973
	for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744909559; cv=none; b=NykrEOEcZ2B9cyYeKZapVKQKZoiKe8i3KVVnyUHVj60YSXH74lvWL63dJqTfI50pjagqu0NnmzjWaH30VhvFShTBSY4pHfNO0k2YOUuCvfuQPKDyN3JvgnelkJ4wriD1ZgZMLA54Eat6OgRUGUiMKkxBKQctgT3WoDLCfikIyNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744909559; c=relaxed/simple;
	bh=QU3FGT1iRACJDUf6nMZPry+pzFBbpif9WjpebsF0GGg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=t1NZNEHF+AVE91b4v6Ck6AysikIXH7rBDfyzOX6zIUPczuyPKaZ5lxOKIKpOlS7NB639Q9cRFH9NvU4lnFhinniAYVjMoNRNP0u/BeGNIgWbL7PU2ToRAhTCVnOpiaAFdtyRIUxvvfnX1HN39qGvre3grgDAAjF3qV5kUIGH218=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2lU1wQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2lU1wQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97887C4CEE4;
	Thu, 17 Apr 2025 17:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744909559;
	bh=QU3FGT1iRACJDUf6nMZPry+pzFBbpif9WjpebsF0GGg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=c2lU1wQ7PYUre+rEkygKas8oIjys7bnDZ3euKPMdda8lrpS1bXTVLCaKvIg+QqyZ1
	 yBt2IH0eJtr0wfcw7iyMa3pFL8fzXPuaDDQe+YbUGWqBQYbw1VkNjyeQN571GscHAI
	 dslj1LgBH7onSjgY3mTywcXNUg4G50uWQrA+XLTk94DJyy32yOM5FfxOwFkOBsiH4J
	 Yvi7H5MsajI3SGHNlSVRXD8/JosMM2OwDGvjiOQNUs8l87QIdx/DcLDTmzVvzTNH36
	 pNS2z9UFNZ6rEykGkZjWcrwFU4an1DRKehpErWLouoYMpoPKx7cOmyEKw1uAfpJpmr
	 vhnqFpZl7pR4w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB1EF380664C;
	Thu, 17 Apr 2025 17:06:38 +0000 (UTC)
Subject: Re: [GIT PULL] XFS fixes for v6.15-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <e3ip6gczsaxvbg7iddmvwy5svl54hig7tjbarvf7ttfqymcqcp@xlvtlw3se257>
References: <e3ip6gczsaxvbg7iddmvwy5svl54hig7tjbarvf7ttfqymcqcp@xlvtlw3se257>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <e3ip6gczsaxvbg7iddmvwy5svl54hig7tjbarvf7ttfqymcqcp@xlvtlw3se257>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.15-rc3
X-PR-Tracked-Commit-Id: c7b67ddc3c999aa2f8d77be7ef1913298fe78f0e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 096384deed6b873e62ac854b624f5be94f8f7357
Message-Id: <174490959759.4147514.8451573706297649636.pr-tracker-bot@kernel.org>
Date: Thu, 17 Apr 2025 17:06:37 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 17 Apr 2025 14:07:01 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.15-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/096384deed6b873e62ac854b624f5be94f8f7357

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
