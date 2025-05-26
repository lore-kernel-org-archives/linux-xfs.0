Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572402417C5
	for <linux-xfs@vger.kernel.org>; Mon, 26 May 2025 21:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748294384; cv=none; b=dTo1rp7M6Ac5Hl8SJ2iZwxhkiQgKqNPzkxgjwOV1nmFrX+qcCEjQMGXLPD8DPz0zABSGD2weHh7RT6QhBMW2j9eUMSmwHpAwY2GMyuV0bkw9+JEMtWXULE3LHKQUQeIRfs9CHlBcoqvwFvqy77qJNYG5oJnOrUEbOl0T/nqsHJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748294384; c=relaxed/simple;
	bh=zmhfX2jUUcPx5MmnMpTFZF5GR/9AbOLlYN7vQfRbe8M=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=huxyMcheaID6t2p6pypC69C/EYkY2isT87atGWEak1wmjt4YjcIQ0kRb1VPcdBesrAHSG0zlB7n9o5QowOF7vaC8QNSuwWHGwEKelixbdlIoqTTkxZwQ2cG5V/RGBUNNLbJTL+sAMjY59IancnQtB/coL/myTT35P5u/tHMUPXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7Sbq/wB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7Sbq/wB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A49EC4CEF1;
	Mon, 26 May 2025 21:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748294384;
	bh=zmhfX2jUUcPx5MmnMpTFZF5GR/9AbOLlYN7vQfRbe8M=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=k7Sbq/wBwNqPwYTTPpbrvsrCmXUOeoJi7OM8sCLrg0rByHy0fmD0b50XKfFwlh2sg
	 IHEyvBtKEDiUevJHAXNYdYdC13sZKn0n2RCSHj6o4vTDhmqIIrYtqPBzv8egnvHaiN
	 Gs2twj6yKoSJJeSlicW1tuJmFIJSS1PTmTZI/NCGTrVpZcvO/COaxFULgzPgw1GYy7
	 X7uIghH3O82tAMqVUlL5VggLNKkPRGhOxEL6hlwm3a9CnILT74Fa47wCEeB2p0R4i/
	 7mcqCEWskXB4lExNu9DCUGBXpFQ3GSdLQLfVTcQ/aQySSntR2RI4NkzcIoZVv6Tusl
	 hBXVEIpEaD/8g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB1263805D8E;
	Mon, 26 May 2025 21:20:19 +0000 (UTC)
Subject: Re: [GIT PULL] XFS merge for v6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <5nolvl6asnjrnuprjpnuqdvw54bm3tbikztjx5bq5nga4wuvlp@t7ea2blwntwm>
References: <5nolvl6asnjrnuprjpnuqdvw54bm3tbikztjx5bq5nga4wuvlp@t7ea2blwntwm>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <5nolvl6asnjrnuprjpnuqdvw54bm3tbikztjx5bq5nga4wuvlp@t7ea2blwntwm>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-6.16
X-PR-Tracked-Commit-Id: f3e2e53823b98d55da46ea72d32ac18bd7709c33
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f83fcb87f824b0bfbf1200590cc80f05e66488a7
Message-Id: <174829441871.1051981.8878746658670950573.pr-tracker-bot@kernel.org>
Date: Mon, 26 May 2025 21:20:18 +0000
To: cem@kernel.org
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 26 May 2025 11:21:10 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-6.16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f83fcb87f824b0bfbf1200590cc80f05e66488a7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
