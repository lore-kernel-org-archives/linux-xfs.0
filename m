Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E29A3A1E8B
	for <linux-xfs@vger.kernel.org>; Fri, 27 Feb 2026 18:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772218746; cv=none; b=DTurpYZ1OeBOREvZVs52bSjk8DeVLTGCrk7XvXZWTpvMiIEW4VZrhu67DAHe6H91kCcBHw3fmLTZSyVPvwEF0OJJdZLU2zKB168z3PIoMSWEUuI/FRSpt2JR59mYCxRj9cRz4UPg+uQhBHUAiLrvQjPKbYmjki1/1vksuqR0DII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772218746; c=relaxed/simple;
	bh=cfM0PRvsXNKzclQHfQoLrPWD+r+9dCd1h28u9HniqaA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=QZtdSR4cQx9ghnz8yXkngEG8l6SZnrwqQfMtGlcD1SLX+W8TonMRliN+oIBPCixYNUeOr136hyPTmEG88Qw+utJccjRk8FO0JO3ZZevMRxIEDSCbFS2lv7SCC/uEWvWYSJWlJVcpZV5tXr84KytIItS6gwmnodKH0c0ltM4jLHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d64pql9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d64pql9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515E5C116C6;
	Fri, 27 Feb 2026 18:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772218746;
	bh=cfM0PRvsXNKzclQHfQoLrPWD+r+9dCd1h28u9HniqaA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=d64pql9pAa3TqhoLsaQjVrPws4if5q7Vw1ocJQgct+IugEDusE4GgyGSBWd1mfD1b
	 yXIR2Bb1PeYzaoEkZWAKFtJ4ihDTVnzamoaAe413PLqJgXCcufgCK/mRAnU/hqIpkE
	 OI6TYLkFkh9/KzuJNSRYAi5iJPWm6ocEwNOPpTM+dZFeBR457dw1AyNkm6iPw9fynQ
	 57euRKrhlSh2PZMlqdrXb9nNV69jW/z8q3FlPHIeJ4b2KmHzdQnDHTS3gBxAZLjgLN
	 Vnr6ac0Gwcjn5K1iCBEGVN23DXQoMBIxtlpZm67itdIiSo30o0Ae3LmSQGT49pmzaz
	 sNuTNn7BLkZYA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FFF339E9614;
	Fri, 27 Feb 2026 18:59:11 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for v7.0-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <aaG7BJKexHHjD-0h@nidhogg.toxiclabs.cc>
References: <aaG7BJKexHHjD-0h@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <aaG7BJKexHHjD-0h@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.0-rc2
X-PR-Tracked-Commit-Id: 650b774cf94495465d6a38c31bb1a6ce697b6b37
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 764a167f54a5ae2dd7ad93267e69b296dcb948b7
Message-Id: <177221874981.2713791.6073302932869341195.pr-tracker-bot@kernel.org>
Date: Fri, 27 Feb 2026 18:59:09 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 27 Feb 2026 17:30:07 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.0-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/764a167f54a5ae2dd7ad93267e69b296dcb948b7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
