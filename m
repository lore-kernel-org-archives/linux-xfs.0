Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CC4382F3A
	for <linux-xfs@vger.kernel.org>; Fri, 27 Mar 2026 20:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774644012; cv=none; b=SXdFpNqKperbIyfRrzA54hMnnTkAurZVsio9jukyIARloRRMVnZNfxfYOyyEfYwJFtCAx9RaS98ggwqTS5VjaD8HbqWenKSUJ7f6cg4QPMzzfoPv/qbBzCqreId8WmH/jtfnWxFiSa71VdRU0tGwEoC8zsYwov9O9dnjcXUS0Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774644012; c=relaxed/simple;
	bh=oQlHSOWCwTw1BRC6ZAVyaWjGr9MAY/nJrxXLHcwwKlg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=lN41DuM7SdK0wRemNG3D/3ftWxI11WJj2TWhn9UksICcL5jftdbYaNfAiQT9siDAj4u/5Z6oiE2XvV65L0KU16eNUHLw2tM/doz+y061xCeQzjeIPkjyjgzFLsWaPFraSRpEuZLsyNSYR6h6gEcbya/u/HxRp5pxpm7lZXarPhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7d9UwKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7d9UwKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76CFC19423;
	Fri, 27 Mar 2026 20:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774644011;
	bh=oQlHSOWCwTw1BRC6ZAVyaWjGr9MAY/nJrxXLHcwwKlg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=M7d9UwKwNFRnLDVyf5A+vBj+BA+9WGbIgCePCsoTF1gWieqpj2HKaoKHdHqbP1WG2
	 UXVsMmgJYjdjBBb4/U5LMNPCUf6u4JLaEg6+ZT0RrAV8hTpfnkmEqXxqOTytHYdujA
	 UeMMdd/ZKhebGPvWK/DfdYMSkPKyzNW8eZg4+Z2swIARAUkaEx9wqeh2HPy8Qi1mGS
	 Suyk1lAwsKqaATFrMG5AK4Y5fE6fVUTOAyNZ2Ko6G0run9Q5zQNFVPYCIzcU3ntzzx
	 PryAAMFw7hA3yYyXeNtnLgQoauBxk3qqHxUakLuKLcI8d4yg6Xw+7GML4KenpxfiXY
	 UH5PyklOvm+NA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9F493806928;
	Fri, 27 Mar 2026 20:39:58 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for v7.0-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <acZYhpOcsyA3ZhsZ@nidhogg.toxiclabs.cc>
References: <acZYhpOcsyA3ZhsZ@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <acZYhpOcsyA3ZhsZ@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.0-rc6
X-PR-Tracked-Commit-Id: e31c53a8060e134111ed095783fee0aa0c43b080
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3577cfd738e29b3d54cdb10c45a56730346dfe8b
Message-Id: <177464399725.3654421.10585855177742905672.pr-tracker-bot@kernel.org>
Date: Fri, 27 Mar 2026 20:39:57 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 27 Mar 2026 20:20:47 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.0-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3577cfd738e29b3d54cdb10c45a56730346dfe8b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
