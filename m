Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6F83AC00
	for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 00:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776126662; cv=none; b=QHDVjOQAvmI1gW/tAL2IN33s+Klev/iqbINoiJQ82IstswSFJ/p6qjr87C54epQQOYNg6/cWFSUFR2ii9aNMAxv3n5IXtayRKr27WyOq44mLGTvRj2/aHvqooTIVIRvn1QvU2FmDwv5+NJaLETAIKpQHEw5/LoFkg/A7sedg6Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776126662; c=relaxed/simple;
	bh=IvN27eC6uqR/A/52SXqhC8lUXy6rpeKSn3tYXL6KEi8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=af0jrsZA5nv57bW4PWbdAtqiFq5RhblwyXca1srj+7eW7TekoLBCordGNcrQo0Fzyy7W+BhKQWz+RpuQS+nEVszoO40WkcuKUB2o+V1JYs4QxbM00qjWshirUOkupi44P2RVxmO7eQS1g6Khz17NcEKa5EEGyANTgXmkjbKGuV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DwZejqCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DwZejqCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2284C2BCB8;
	Tue, 14 Apr 2026 00:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776126661;
	bh=IvN27eC6uqR/A/52SXqhC8lUXy6rpeKSn3tYXL6KEi8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=DwZejqCMHZH4iAHR80Ga8kFAOTqaG5CNJ19m7BFeVgELOd9SGyalxC3jS+rhyY80e
	 s9jHk3JgntSKDlaIAG31kdzdZrfcOexJyDxaUZrc12yZIb9GJ9ZXKkXGkAWkCtUpLD
	 4C3NT3ibSMSBh+lf/me8LTJF7QEjEQUkMnNGxEtm3yxTqV6YXu58X5w2VBNIRGTE8x
	 SeOf9fhZwrprPgD8F2kxYE1OhIy09fDawyII1Nn1c1BLco+pVhnBkKpMdttniCMJJv
	 T2TiQkdGagZYx9ejTuQHfrJ+c285vQmCo3rgK5Ism9Cdw3Hd+oqa+FPbEzFERjgcAp
	 tnPHrKh3PS2MA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FE813809A0B;
	Tue, 14 Apr 2026 00:30:34 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: New code for v7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <adypWanwxWF6j9Z1@nidhogg.toxiclabs.cc>
References: <adypWanwxWF6j9Z1@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <adypWanwxWF6j9Z1@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.1
X-PR-Tracked-Commit-Id: 2ffc6900d5c3a7cd59becda2aa67581d9bd3858e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0b0128e64af056a7dd29fa3bc780af654e53f861
Message-Id: <177612663279.618768.10035963996075465865.pr-tracker-bot@kernel.org>
Date: Tue, 14 Apr 2026 00:30:32 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 13 Apr 2026 11:11:08 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0b0128e64af056a7dd29fa3bc780af654e53f861

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
