Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214EE4C6C
	for <linux-xfs@vger.kernel.org>; Sun, 24 May 2026 00:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779581265; cv=none; b=TxWM7Gq1Rbz/7J6diPvhO9XgwNsWbQ/WdNzav/g1VwtsLXCyofyUyFv9IY0mX/N9ByE8WazuKY7GwbYNcx36jJ4JLy9W1ftyBBWr3+obn65ow/aEmZsNwFOog/0D3lEdLfcRkf8M4E9uTvyl+LI51E87nqIl3BHeSPxsRry3lkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779581265; c=relaxed/simple;
	bh=IQB5gVsnu8z/72T0E/4f4caMMQxw2qDW+Y2vKASvoSw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=HLFd15JWYrvHSILM5i7svCGACuw0XQnGs/UNZD0xP9ayLMocbHj5/8k90ALHwcUyUNCZLk4EFd3de/Wkg5tzQulYpojAy5zJjfopE5vPvXIWXXRu3EMTLpifTJDkp/ZazQU61Xq5nvlGadHiyK8tMNmeGpgkqm4eO+zsc0b3zho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFhOXzWp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFhOXzWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0869B1F000E9;
	Sun, 24 May 2026 00:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779581264;
	bh=7PHPcH7YLezUscQtWu86LaFoHkJVoU9RoabtsLJytIc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=eFhOXzWpUzbl9wihzBHGea40sBFVmT0QNwZQujm2JpHuF0ZV+k4W1hv8S+27Vdsg0
	 uQDdMLTeOB26doGX9MD/vCTkch3m02i+SQf07yRXEems0BkC7iJgF5NzCFXGyliYgJ
	 aIY2p/trjbOlVMwC3XleuL3Thia0R1SI8T1Z1px8f9XkzOYinuKPyO05V7U4VhIfzi
	 LGjVTPbCUcJAiTr5EdKfB9TyDPltZW2ukHdJqEHHKOsFcWbTVcfdrxRf5zGc/ZYBvh
	 ZVrn+U+5v3OwugB3hMaK39uk6GnKbe/TMh2u9h9DKXtAjy2gcupaXEYoRCffeShACZ
	 dFrMErI4xJc3A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56EF33808205;
	Sun, 24 May 2026 00:07:53 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for v7.1-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <ahG3Z0ngBT3K1Doc@nidhogg.toxiclabs.cc>
References: <ahG3Z0ngBT3K1Doc@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <ahG3Z0ngBT3K1Doc@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.1-rc5
X-PR-Tracked-Commit-Id: 8339dd0e5090f092c525c5e04b2a75ec5e5305a6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f83ef5bca211a1bdc1ea661c11543712f96a6cea
Message-Id: <177958127194.1680243.10566253304779277959.pr-tracker-bot@kernel.org>
Date: Sun, 24 May 2026 00:07:51 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 23 May 2026 16:22:07 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.1-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f83ef5bca211a1bdc1ea661c11543712f96a6cea

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
