Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B8136EA8F
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jun 2026 17:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780680770; cv=none; b=iP6OpaMjlC+GythUQWpiKQC+V1r8cYBaFN1sz6jDmEIJkwrcmbZsadCiG+3sQkijuENRlsNDZxQJF1v1qeDAKYMfb2GfKD1KeqONGaQMD35YMMKY9jUWseFAuIWUDjwJWWtuwFxE2sD6bS2oj7pQCYhf3b+Ufub/xEq/VGAKV/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780680770; c=relaxed/simple;
	bh=2qPnF1qj8YBeEJSjkYfJT8hMaCQmpA+tBEYiWroU+2E=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=UPE/IiR9mQwcSikQASpIl3UDMpPrcjBNMXDK4fG3luMYnhti/4O9P3TVIn+AYTzDQzUCI9c5bOwSN1B7yi2c80rS75Wr8xFbxso38+TNgCrxc2QCKlWgCRdGmkN0OdkaeTZiudimR1CMGbN8xDtQbGYgL/9WTEUSuJpzY7crIFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXVxzx7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXVxzx7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898FB1F00893;
	Fri,  5 Jun 2026 17:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780680769;
	bh=BqP39Dm2rY0+u2trmuB5iklNNXjaOQQQhFKBhdOWrW4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=nXVxzx7jsvuuE/3OYbiNDDPHZvAMxiw5bW4KPb/oAG06IxPdi7/SGVJNywEXImVof
	 PvJq8wPTgzCEr96N09GmLvjrX38BVjXpIu0OCyGJa5vrKMmm3t4vmf1dr8gpKM88Mb
	 g2KxZktmUDAL5EPMArEDFeiyunuDZuBPA9fD9uGUB7LBVM8xDpHoUgoZ0jb21IIeDV
	 L1ZaS9GJTrdEiWE321PVmrCWirEXFaBwtqQyFSE4vu1VZ4pafThpAuKOvsEagxuOay
	 HuedVpfU9ZlMb9kmIjiQKz+CDRyPt+DwdUvf7KXKUjGNW6A+J/Lxh0uiy2P4WPv9nm
	 yACHVsuk0offg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1997A3930BAF;
	Fri,  5 Jun 2026 17:32:51 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for v7.1-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <aiKcvJ5B_vMKZSup@nidhogg.toxiclabs.cc>
References: <aiKcvJ5B_vMKZSup@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <aiKcvJ5B_vMKZSup@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.1-rc7
X-PR-Tracked-Commit-Id: dabfaca8140f64535a79020f0f86ea56f5db5bb2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6a5358410af387fd48251a5e5cc4cf73dc16de52
Message-Id: <178068076977.3853150.11862059921131502029.pr-tracker-bot@kernel.org>
Date: Fri, 05 Jun 2026 17:32:49 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 5 Jun 2026 11:58:17 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.1-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6a5358410af387fd48251a5e5cc4cf73dc16de52

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
