Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886013F9D4;
	Sat,  6 Apr 2024 16:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712420345; cv=none; b=K7fFGznYDcv65Bz9xngUop8JK3BvPnBNDdjMvMV8KvYVehy8G+EIougsJIGzWBFlcviIqbOvmEMkGtsM3CJh2Us0Zfn5ptodhxEuKVVBWYWZUtYTRIgMIKzXs6tsONchUBd+Tkl4WAcWg1oi+uN7fGYqDMJs6uqkt0f9W8RBPnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712420345; c=relaxed/simple;
	bh=H/6btIUI69l3hqvbJuOXI9gKB0Wbv0bWGrQw5jtsO5Y=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=c3di55jXBeHmssdlHglGlbZzEECFxDc3L213bAkQbJYGTMefH2S5a1ekptj5STwKQ1Vp0XJ+N+6RwOZqymC7oWxRRZAMa+2h+RcuBkcOQSYCQ9dM6x98o2w7mwVQCDuuQs12UJR2kF+8Q/KIuO/QlvZfhF331ERvCFm+QLLuKRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p4wpZX/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4wpZX/N"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18114C43394;
	Sat,  6 Apr 2024 16:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712420345;
	bh=H/6btIUI69l3hqvbJuOXI9gKB0Wbv0bWGrQw5jtsO5Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=p4wpZX/NOE0Th4WqHf42mdKbFtDoRIkXLG4cX2K6ThjJsLTDS3fvpf/YY0tAueQzG
	 woAl/kseUD5hBZVTd7KjdPNn600/d+dLbXwOloZmV5vB/ZVF3BFyPSj/+vS/XpEB2X
	 DSyQ0gLPc8IYGXqhD60Q0ySoLG79QNKBOB3yYaaFdLMFpi87WFgWkAtuyKNt/lRDJm
	 +p1BzDS6f3IrZ3sUCRhY0Zwnald3jqe/8YIE1cH68nJiEXHY6mvtzwTvRG0IdL585J
	 8kBfnLmWdc4QBTIyRFItfJ9ssimGgPKCbWnf5Q8145/mU8N5ZlaQ77YKNOO7JE8SOo
	 iQRoilzJKEMKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A55CD8A103;
	Sat,  6 Apr 2024 16:19:05 +0000 (UTC)
Subject: Re: [GIT PULL] xfs: bug fixes for 6.9
From: pr-tracker-bot@kernel.org
In-Reply-To: <878r1q3byi.fsf@debian-BULLSEYE-live-builder-AMD64>
References: <878r1q3byi.fsf@debian-BULLSEYE-live-builder-AMD64>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <878r1q3byi.fsf@debian-BULLSEYE-live-builder-AMD64>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.9-fixes-2
X-PR-Tracked-Commit-Id: e23d7e82b707d1d0a627e334fb46370e4f772c11
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9520c192e853bad2a0029f5ce00fa7774408efad
Message-Id: <171242034503.494.6533765764306092670.pr-tracker-bot@kernel.org>
Date: Sat, 06 Apr 2024 16:19:05 +0000
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: torvalds@linux-foundation.org, chandanbabu@kernel.org, aalbersh@redhat.com, djwong@kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 06 Apr 2024 18:02:40 +0530:

> https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.9-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9520c192e853bad2a0029f5ce00fa7774408efad

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
