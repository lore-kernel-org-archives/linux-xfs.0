Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DDD257AEE
	for <linux-xfs@vger.kernel.org>; Thu,  3 Jul 2025 16:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751560247; cv=none; b=i1rvbf9/hrfHGcGnFj0O0B5HOcsgpgs9owaXYiSfqwDV+1tPn3cZ3mM+9NGsn9sYG/uK45BWHNeFd8aFvvP2mr9cHr1xQQH50ioM4FPws3dNlQLWsmjSjGKftIB/qG2X/MwWsLUrjCaNpIkNePmoMAaeIzxIiUB5ZLT4EXnkd8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751560247; c=relaxed/simple;
	bh=4vZKth5hZOEyXs2/A37gwilA2w2UXoqqbcdzgLLlM+I=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=V0gUEru1YmofYm3EZ9SGO3YQNC9cQ6U41Z94TNu43yfT5SEfOzh7wZ74/H7rZZokN2d46Uek+wyTy+64u3eC3XPdem2fz9JZIj6wJfkMSJBjjBh1tf0ewv0o2cROHNTsfMJTVsjTEWftzhTiVyS09R4BlPTGg9BBh5zX0X+gJj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DOkDhSZt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DOkDhSZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC80CC4CEE3;
	Thu,  3 Jul 2025 16:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751560247;
	bh=4vZKth5hZOEyXs2/A37gwilA2w2UXoqqbcdzgLLlM+I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=DOkDhSZtul5vSYU12xpAkKTl++n2eTPky2WtFLtz+UmPKXhv5rvjyMKSi/N/fkrxA
	 I03fQndYKfXjPumy+4hoiBR6Mnnm0fNiMXshLJsgeb5qqK8hIGigeQYP+oxB/Jzocf
	 lCeGyVLuScuyXGPNf0K+MLOib151oXTj/zI6/2QB2Tli9onkj8479Ox3OijCid0Ioi
	 UFGCoK+PAKCqfAd22dJMiyv6xDDtJ3PxozUcejJIxFa+rNRriJB3mOoiPwjOiNWjur
	 Iv+3tA5hCkuGdlV3KXFkbU7yhK+kvWBmKoe5mXnRas3CO8eHMJ848P0ti515KLoJoQ
	 xI7xFP2C5dPgg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70E09383B274;
	Thu,  3 Jul 2025 16:31:12 +0000 (UTC)
Subject: Re: [GIT PULL] XFS fixes for v6.16-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <fy5upmtfgiuzh55xaghv3w3vqqsbgszlraw6hv23a4qycirsg3@qzbwz5m2q7f6>
References: <fy5upmtfgiuzh55xaghv3w3vqqsbgszlraw6hv23a4qycirsg3@qzbwz5m2q7f6>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <fy5upmtfgiuzh55xaghv3w3vqqsbgszlraw6hv23a4qycirsg3@qzbwz5m2q7f6>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.16-rc5
X-PR-Tracked-Commit-Id: 9e9b46672b1daac814b384286c21fb8332a87392
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d32e907d15f7257f69d38b4c829f87a79ecf8b7f
Message-Id: <175156027089.1548768.1860202571333543352.pr-tracker-bot@kernel.org>
Date: Thu, 03 Jul 2025 16:31:10 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 3 Jul 2025 09:27:51 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.16-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d32e907d15f7257f69d38b4c829f87a79ecf8b7f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
