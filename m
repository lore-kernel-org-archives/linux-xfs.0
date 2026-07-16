Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA7943304F
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 17:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784222800; cv=none; b=oMZCJghrSGyMGXFZgcvWocJNsNIyR7QgYf7BHtoeNciBDXbdjyPSd4gYcYt0yL9u7VVyBAbTmuAhNH7eqbWE0HVcegErIf2sTvmoQmSyBtBKSg6c3Pso23nuhCZ/TpiMV8bSEcrjmp9sA2aFD4a+8nlAtpzR9b+nwSJoVFcfgco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784222800; c=relaxed/simple;
	bh=rwwLCgbT5FySR1KhCXTGaHMstErwjMw/DoiUqxzYxUg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=g3kemNz6CLrvwtluzM0FNupqi+3iPFIuTBljbTGAkHZYC1Dn27/HKD+oIOCIto8rwsuau0HMziO1e7fcl8vmux8gWFj2C4cT3KW42+w/YwKMcMJV/JA+Sv3rjQGK4379KElUIuQhevHp/M4JjiSPUrwKGNrj4DyLctK/4kWeymY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FUd8Fm5v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FUd8Fm5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0841F000E9;
	Thu, 16 Jul 2026 17:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784222799;
	bh=7XCH81JXpXNjw1N4DR3lsK715VA5b8bATPOKmwTUhls=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=FUd8Fm5vGmjICvZptadjpnU4Dny01Kt875rpw8XHOHzOPY1AVcFuGWsfjgpxaIn17
	 wuIHMeTSyDwz4nW8JvzKQqFkEEM3jltoU+NFvfuAiyPVzSLNX4xlwJHcRnFZ892cyC
	 BnB/LwztKn38ZDJ4UidVD4sDzc0oYF5jDVYJBRAcTCFjnbxwz9OnyTapnId01wdyIP
	 BTEe3pvPS3B8yvHyb7H3584kU9idFhtIevgboLVsbqsTTs+jtulcWbtaeDc2m7x2xD
	 4EoCHBTD4Dv4gegWTICvYi681OSXorJLGSx9xBkDqIRKiomqrNrRUBf+jezpRMrBa2
	 OBZtbOdMDK4Kw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0AF43809A8C;
	Thu, 16 Jul 2026 17:26:13 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for v7.2-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <alkAOxMdRvYOKSm2@nidhogg.toxiclabs.cc>
References: <alkAOxMdRvYOKSm2@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <alkAOxMdRvYOKSm2@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.2-rc4
X-PR-Tracked-Commit-Id: 59c462b0f5cfa107794228051724b34ae9334168
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e22254e9ddd8020130c4b806b6b4aa77b09c2560
Message-Id: <178422277236.1357537.2466458855734834934.pr-tracker-bot@kernel.org>
Date: Thu, 16 Jul 2026 17:26:12 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 16 Jul 2026 18:06:09 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.2-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e22254e9ddd8020130c4b806b6b4aa77b09c2560

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
