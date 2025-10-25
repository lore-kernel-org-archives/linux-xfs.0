Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6292F2FDC54
	for <linux-xfs@vger.kernel.org>; Sat, 25 Oct 2025 17:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761412015; cv=none; b=bQz0fEWgioI9xU8OfwGfdf7dALTWylys//br1DYpHS/mODeN0pf1lYbKnFqWuRkXj9eN3pAkxfjNZQsTlmBqvBR1/ZoF81FJdWUC+V1JDZxErHMWiOeyIBQlb1susZQL/nqZ4JmvBuIFy66lG/yPiF+Uv4Rru+KpUMcFJIWKrSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761412015; c=relaxed/simple;
	bh=jnF6uW79NDcBY4KDTAEqIgCYNzctBjQQX6tSMbZi1Xo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JBeAdKB1VglR94p3JwV1JYBd8DPd2Q/BdxgHh82pvzviP+66mO5vLzz7IXMBj/6kv6SrqrPQs69QJKLlLFQb2UZZPUAHzI7thSeo6P1doPJO5OzHLilVvN1KCZF0SUTMD7iemj2F99YVL5TrYTsNKswuhrtra3pLJyE6ls0XMDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9JVHNLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9JVHNLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C1FC4CEF5;
	Sat, 25 Oct 2025 17:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761412015;
	bh=jnF6uW79NDcBY4KDTAEqIgCYNzctBjQQX6tSMbZi1Xo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=J9JVHNLzESHZE/0Eoxk3z/Ps7mom5Cuoo6594MiRK12CH0Of3k9UJ7p38VMkHZwH/
	 xYoZpkf8pTx4PorX/qpg6uIZUQz4+PIV93Kgo4P+P/Q+eGIGF8aYkjcuMA7lmHUN8u
	 zH9b8FHDUoxVdUmLZ3rAyuYZsHqzANEfOU/PqfExsNADYKPWIqt+A40uLACaWdgcgO
	 GFoXrVWR0lxMpkpqws4tc6J2Ef1H58L8dAh0VEFDChV1jRQtMvajyh7Xp+nOz3ghcn
	 P2fJvvsszv5+gS1VNJUyPCI6vx9xLd/Q5YRMS8fcRenlyTGBVuD3LOTF+L3ZT8+EUe
	 p7d8R+sNOe7Iw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 71168380AA63;
	Sat, 25 Oct 2025 17:06:35 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: fixes for for v6.18-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <pg3ebhfwryenhfnhuhyfqjvs37ivhpqp2ijvhfjbih3c3zyxio@mr2a44csgwzv>
References: <pg3ebhfwryenhfnhuhyfqjvs37ivhpqp2ijvhfjbih3c3zyxio@mr2a44csgwzv>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <pg3ebhfwryenhfnhuhyfqjvs37ivhpqp2ijvhfjbih3c3zyxio@mr2a44csgwzv>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.18-rc3
X-PR-Tracked-Commit-Id: f477af0cfa0487eddec66ffe10fd9df628ba6f52
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 27c0b5c4f67aeb73edd515200bd1e0c82a3ee892
Message-Id: <176141199404.82217.16658913398618060588.pr-tracker-bot@kernel.org>
Date: Sat, 25 Oct 2025 17:06:34 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 25 Oct 2025 11:32:53 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.18-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/27c0b5c4f67aeb73edd515200bd1e0c82a3ee892

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
