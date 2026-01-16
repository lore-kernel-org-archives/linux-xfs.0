Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38E9306B02
	for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 20:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768595127; cv=none; b=RYrjNMx0mZ+C5+bw66toXbyaRaub7FZjv4pINaHVbeFwAFmCzkGt77C1OE9mtMmfKHW6Q+rgWNs4LDF/ow2awWXRIcn2ZOrrZ+RROxzIB9sIxZMn7f0Tuvl3vxxHc0kS6ZqN/+RKeCqOD90XHGRZUUYoCipLd4FqqJgCxNRr9H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768595127; c=relaxed/simple;
	bh=/zVtDwiR9ll8jNjNTImOCXSEg1FcF3YmGkZVuWSxdHo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tD+M/mxcQIPhxwYFWuu1X72++ybtdxj4PsNYblZOTKgippIkmumVybdEAfXLWy8sUgZXgdPvzZfHasUnHN+voJILIuX4PEiXjwq/B377UQS6HfHNpCwBj90Crb9oxtO6deDW+sLfn2L1ADjffbZMTGTU6CR2sEGj7tyVDwDpSN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJMh1yQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJMh1yQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89163C116C6;
	Fri, 16 Jan 2026 20:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768595127;
	bh=/zVtDwiR9ll8jNjNTImOCXSEg1FcF3YmGkZVuWSxdHo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OJMh1yQwifTTPrmJYc9P9JBuQfeLous9888NMpJKy6WqORlCGud2YlDQF6J7f87Kl
	 J0QsvHtBE5kFHARfs5iGY+CaTpbGxYYXohqCnQwStvCxpCWo9sjTX9fFnCY7/yjoyl
	 sOPbo5mSwBmP4xhNROaBs0MJ7L/k7SVnZeFUUpJDeyrvTvTNk5nUJs4FERoSa74fZ5
	 jxAcXHg5eFgvjxVMze7z+F+MXrc4SjuFsRNGdzrKDqvRpQbgiEEr6ftYYGRg6MfCCw
	 mAX4rSJa9veeUsX+vtb31RnLUO+9PPC5W/Aw+oxxQKjZ/1x3BZ1PQPTT/zRLYJwezd
	 PVtoE4hVcz/6A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3B75A380CED1;
	Fri, 16 Jan 2026 20:22:00 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for v6.19-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <aWnwAp-ev5kagXmo@nidhogg.toxiclabs.cc>
References: <aWnwAp-ev5kagXmo@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <aWnwAp-ev5kagXmo@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.19-rc6
X-PR-Tracked-Commit-Id: c360004c0160dbe345870f59f24595519008926f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 353c6f43ab690b5746289c057c1701a389b12f98
Message-Id: <176859491873.789588.11802488441446172281.pr-tracker-bot@kernel.org>
Date: Fri, 16 Jan 2026 20:21:58 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 16 Jan 2026 09:42:43 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.19-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/353c6f43ab690b5746289c057c1701a389b12f98

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
