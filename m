Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD5B2C0F81
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 15:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094124; cv=none; b=RRchJ5QGl7TP9eo3Pim/3piCVyiGrVl9bS/j8HjyJqbEFOZGCTRj79BDvMgHh/+LknWLInWgQ8YBYbXsshWhy6vnGRO/72AdW7fpBmsqUQrEra2+7vLrcz0tF9gQZf3iDPM5Vh5/nrRZhnwZLP4vQWuvUgOHUXMBHEJwxHliDRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094124; c=relaxed/simple;
	bh=ZYUPfHNvg6yF0F8PktpyWejlzf6r/pbPU3WajYcXVr8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=OvdRq2UwiZGMxmju2FJWEukmrznrTb+xVstuEQuprHZcHSeqkVs68wQtZvEOFDcY2xJcw43piqYyezljWVDT8CY6ZAVHFPuBHbg1n53x3fpKB8E1qKye3vmpWYpuBdGBITKIK9p1isxjq3dZ83hX5piz81DUKNe9GlozmLlgQ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ctzse6BJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ctzse6BJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76021F00A3F;
	Fri,  3 Jul 2026 15:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783094122;
	bh=OhupCXxfCZBzlMFUgVYPIb7x0eCYzrx6iXC+mN3+Q58=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Ctzse6BJEKV/WQtRV/WbH6G0DKHAFfvRHvDpOwTltFhlpbUb6fHIltgBgXlCuMN3R
	 w9XRseCIcXLB5aJJ8t/0q3t4rbTAaT63TUFdn9D1A05ZlPGRITEd+aWqLl+pE3GwY/
	 RVbDTJS8CelNIl+t+XQvtpF8Lt/5Jx6AGboCT7vTS1tNj7nwwPkWaKaPlpKVMgHUKe
	 xQx2SZwhk5FQ+36cu4oLCIJrkoHLPM8/njVzaMkauCUfQjbt1rhA1+45QNDAxqqDhh
	 Hl7Vf36v4WVSzoxBH0+BAu5XnXOOfJ6dgSUCFgkvsWhzLN2sjf75wo3L5F6htFnIG/
	 ECo2dPZ3R536Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56B3B3939347;
	Fri,  3 Jul 2026 15:55:06 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for v7.2-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <akerZmyqyLw-ZBta@nidhogg.toxiclabs.cc>
References: <akerZmyqyLw-ZBta@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <akerZmyqyLw-ZBta@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.2-rc2
X-PR-Tracked-Commit-Id: e4281086ae6caf006b6ef0670479eb5f96880fb9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 025d0d6221d9b060bce251427c671cd0080d9dae
Message-Id: <178309410480.2776291.17127293000733751807.pr-tracker-bot@kernel.org>
Date: Fri, 03 Jul 2026 15:55:04 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 3 Jul 2026 14:36:36 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.2-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/025d0d6221d9b060bce251427c671cd0080d9dae

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
