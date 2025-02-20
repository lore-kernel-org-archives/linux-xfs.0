Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033C720FA98
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 17:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071019; cv=none; b=dEpYog+qNtgBs+1scVdSVsb7KlzOrmx1NygqSxunkMHsVfqEd348FWgYWBjddIl9FaPlyfSJDDakbGMdrWuFOLsFX6WMaMxGO++qDZZRPURvyEPIrEx8+wAxReepah+H0iGYmmkg3J3M+9Hi8QBvOHrIstl6LV1AEWdnsA5Ks/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071019; c=relaxed/simple;
	bh=l0lM141fDWqz2ekarWZ0b0YH1B+S1o675s6xRYd4RfM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=m/BCMvjvnCgi9gzJD3SpcvzfYZYe4+9uIIFQ1vS4kA07RSVoBGk10ObT1nAguQg+fuHmrUQaZvxQUA26I7eNCCn1d2n57f9XzjOZU0nvW4RrcwtwThlxwFnHV0Fqf3ySpPuNdzmUWd80mHMaBQrnypXubGayZz4Eu6fyWY5W0MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n/hg3XTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/hg3XTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A698C4CED1;
	Thu, 20 Feb 2025 17:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740071018;
	bh=l0lM141fDWqz2ekarWZ0b0YH1B+S1o675s6xRYd4RfM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=n/hg3XTGC7P7cFNijuI0ZEJk2keqkHFWSQjdR5Mts8sGLk3Hlf9o4LjaidQ4IvmLW
	 Nsr6AYuw+gMvoBs/Quhr5ZE5IoslPQVndiV3pZrL926446eqyTn82BbxxQZgHAkKus
	 5WXP+7xJVhO25UetMX6NuGrzk9Ev2F4tSdvjd7FctaS2aU0xFn+s+iQEE0zObco461
	 7mZVbF8crdx9QPB+mALHc50ieAHUCen3qqs847gb4rF+H1N/+ivvHRtEmbGzSpPHA6
	 9fJ7VL4lWA+wSkZBr3NMrNsXnLx4BRqj3OYaxnDl8YGwlUtj5chCpRNat8HWYRn6oh
	 vLZdoIMkzIBJA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 71162380CEE2;
	Thu, 20 Feb 2025 17:04:10 +0000 (UTC)
Subject: Re: [GIT PULL] XFS fixes for v6.14-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <rjf47upmybci3sspru25djnbnd34k5r2cybp7t3t2gqhpzkypc@6s7ntozehtmm>
References: <rjf47upmybci3sspru25djnbnd34k5r2cybp7t3t2gqhpzkypc@6s7ntozehtmm>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <rjf47upmybci3sspru25djnbnd34k5r2cybp7t3t2gqhpzkypc@6s7ntozehtmm>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.14-rc4
X-PR-Tracked-Commit-Id: 2d873efd174bae9005776937d5ac6a96050266db
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 770b7eec04c986ace0e632527ee7e1fafc2e5964
Message-Id: <174007104903.1392144.1596879903129391805.pr-tracker-bot@kernel.org>
Date: Thu, 20 Feb 2025 17:04:09 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 19 Feb 2025 11:12:47 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.14-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/770b7eec04c986ace0e632527ee7e1fafc2e5964

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
