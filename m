Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B54D3EDAA9
	for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2026 03:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787025502; cv=none; b=aLaf8o3qmAtkAGJZMYmodlxg5wzM/Vsf171AIbbj22mVAjb9T8OCglmBNtBAx8pF4GzpF1xCAzDHDpXQPtH3gnAXYC/DtYeknte5wcl+tieEWFTh4oMv6hmgjOOzpsMcINrO5bYXK6WMF1Gw2Rbv4ZQf8EWouV2ptXTOlkuJyTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787025502; c=relaxed/simple;
	bh=uRRseP7L/WAGIl6qhxvvvyO/Kr5BUDpx1kLts7DhvEg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=LqQGQxNsvrbwqL9Um77yY+1AYmAEhq4e5lxjGrkjwVsOQQ1rSAF6E4LFMZFwWzrEAzfV6I07lu53OtqtFT94IjN7N/7IxOiVLlMYfMp2FD1jc8Og8j9MXjOXUuODufzaGjw6IwUiMZv+w2dM82kf4p9V/ArW2PlmnVgM1DMTKiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i3WaXk55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i3WaXk55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733AC1F000E9;
	Tue, 18 Aug 2026 03:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787025500;
	bh=+VVDu7K0rkKIeUMN+cZ8Ls9+4e9JH9lv/EVBeENr1jQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=i3WaXk55xNpGiyg8Kgx+uJCTltwB5rhwBdgn3gMyt0Y/uUz0GPSKcUQtgu74r+x7Y
	 +RaL7FgzKmyghCuESBHeMq0OFg9uaXzsgRCqqHPigfUJ5kDoZdyKlhcC9aYL++P1LY
	 PoedRHtfeVEdC6AA09EkZeJcjADfZ1uH3lAbp4LaUr+5FBlW4vCDS3UqPeumPVsTLi
	 vJC5ypigrSYkyF01ryLiq3bQ05K6MUj3U4flARthM6269QgZduVMNmU2HOhHitmAIf
	 X3QQH4nSiztiZoJ5Wil+Q6mkQkXBqDCPfLYSqrOGOFJWnX9yevfVD91B7CrqQLWY0m
	 R7F7/qGf8PBRA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939763926381;
	Tue, 18 Aug 2026 03:57:33 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: New code for v7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <aoK5ypb3oTVLlhFf@andromeda.toxiclabs.cc>
References: <aoK5ypb3oTVLlhFf@andromeda.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <aoK5ypb3oTVLlhFf@andromeda.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.3
X-PR-Tracked-Commit-Id: b7eea80be25f3334f131d52982b3131aba77b97d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cf07e82984895a06a7cbfadee1b13d83805bb41b
Message-Id: <178702545224.1862718.11179776591479048163.pr-tracker-bot@kernel.org>
Date: Tue, 18 Aug 2026 03:57:32 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 17 Aug 2026 09:57:04 +0200:

> git://git.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cf07e82984895a06a7cbfadee1b13d83805bb41b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
