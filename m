Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF261DFD8B
	for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 18:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763836239; cv=none; b=hm4FJuGXcV60bfVu9J0iM6FxhF5ZdHKJ0rRUEmTxN9n/KF8SWZZ+Q0OmwgDOALIW862vkLAz01XFxK7j2H9iXKg2UCagXeXP+f+SFfk5ooeKWLsOKeInYUDZfxA6GfNgFU8NMJQxlhCdjgTLecVtXA7I6ioWcMea01OaYv+BQhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763836239; c=relaxed/simple;
	bh=rZ+UiLpoZpCCnxDiKLlrltfKksZIbxReiG2ifJ0qnBE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Y0ssqf/Jz6/t+6BcxdLslPu5VkFpZAevuEfxUuUcgPPQs0wunSAbyEv5xV6kXaRtynSOQKwHUAsDprdBemtoHuJYhCQqdSe466o1RLSJyZTHXm0EQlYWFAFSOASJQ7njiuOYBiKYUa3bfOdUZnz38iuRA+VzuaThRCOAsJo/Je0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i/u7K0um; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i/u7K0um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75815C4CEF5;
	Sat, 22 Nov 2025 18:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763836239;
	bh=rZ+UiLpoZpCCnxDiKLlrltfKksZIbxReiG2ifJ0qnBE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=i/u7K0umWfqWQfZJdHXWeE9R9YOkrZXuS6wHul5HCsOB3FxhsAm3hAUnbRguII30w
	 AuEg7PF1H+zC/Y8SPIdf5c4bAOZDFnBTmnBikCBQb64t/ng/dVNfHxoQ103mY8eSfZ
	 sDCv0UfYb6v4Hd1UEtTP3kKM01vhYD5kyjmOhPyme49rO0na33Wiq1uwj07dOT4x44
	 nfj9mghC/nL5fnSRSaa4IZPNGH5yVTrtVuU7sOwp3BsdKam+PRHZbJq8q+o08tR7es
	 mTFQ98C4GvWnMi1LW+NfDFrPRJ4A76Prc1Wk9xB63RYT/oJLmvLkLuKBURI2pEIL9U
	 zMWdxSbj3hqLQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B97513A82577;
	Sat, 22 Nov 2025 18:30:04 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for for v6.18-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <wcxsin6uzmospeiqmgzxxtg4nn6uwnamywzcd4blxjkjmbbrfq@p7kvosodwcrd>
References: <wcxsin6uzmospeiqmgzxxtg4nn6uwnamywzcd4blxjkjmbbrfq@p7kvosodwcrd>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <wcxsin6uzmospeiqmgzxxtg4nn6uwnamywzcd4blxjkjmbbrfq@p7kvosodwcrd>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.18-rc7
X-PR-Tracked-Commit-Id: 678e1cc2f482e0985a0613ab4a5bf89c497e5acc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 89edd36fd801efdb3d2f38bbf7791a293c24bb45
Message-Id: <176383620359.2850055.525345575529459350.pr-tracker-bot@kernel.org>
Date: Sat, 22 Nov 2025 18:30:03 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 22 Nov 2025 11:15:24 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.18-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/89edd36fd801efdb3d2f38bbf7791a293c24bb45

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
