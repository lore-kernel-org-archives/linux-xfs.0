Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792547617;
	b=JPdi2maIwBnQpNOuHhX56JKxXyno5wuJk+5rT08JcvbZXh+QAOczItRL1/bgnDYphMCp
	 DV4eeVX64pEhT6Jm3KwzJJdQa6iSbvJ4sFFhgmEsOxTLtb5NmoBNwWoyL0StARA4wmkWO
	 cK/18GDe/Z4Ukz7CJWRu5yxwy6xA/lI5Cxc5ptkYLo0TRZp+iK/RLUlUYByTKIqmNHKH4
	 D97n1LsnbnKBjS8SMP4I6DC1SXp/ddsaDsguluCXqLzRYa6tKcDyE9X87Y5DiE3rUEqW8
	 3tXcjVSiESYVhcQS5LdksBaDKGo9lH1njJ6/9glUrxhFpHfyYpJenC3PJ9A3K7UeujQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792547617;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=vDEUuBlrJb5vggPgQPHdz4gZncrLvgWA27Dz6RFpjHs=;
	b=juG+4cvoApVldXv4Q5zSN8K5McwOqci48bN6876J9leQY/jv/AnA+DuSjz9wkbH89H1Q
	 1dzYJJh+H1+yMkORwMwe9KkvhIVIy0k1pFJsPTxqn1odrLs/SJ5DXwvpIyVnhYlwnUFGS
	 sY2WlleQjfk6mZe5UMv5NgODxZSzcNhNA4vm5dM91wYvGePOjAxzk+GZhD0fwd6gUTO4C
	 V+iRog7L7TGRK9XzDe+wEVcRMaBcOy2S2Og+ERyvv1TApDttfUiwru883Pk4ELwt+HY1Q
	 FBrB+b8umHpjAd7r1sfhlJQH2zhO++eTM7OFOf39aFXq7XMlt9RWhi20Yrnif/P8j6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pmk3MZ3z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6693A606A31A;
	Wed, 21 Oct 2026 01:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pmk3MZ3z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060011F000C9;
	Wed, 21 Oct 2026 01:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792547617;
	bh=vDEUuBlrJb5vggPgQPHdz4gZncrLvgWA27Dz6RFpjHs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Pmk3MZ3zjhtOrG6wtEiLtsxLMvWQW4NdTpLnripc/Fmrm2tonknukgUs/Zt+MtwIq
	 fZ3SWTSwcdGqZIgkPMBs2+FoqryM4sFfxquf/px14g5CzU4VbdQ0T1QfJrR7rr4U4/
	 hg48P0Sj9AzIaUQFsYVqOiemWUpWuGsqjUTJ4EaiWYQ2YEDlgSh8ED56fpj3pjNJym
	 sGOEWfqlDYkgt5s/g2jDgRjCEwE6kFBj1ipQQtdYyBGbNksVcMEfiZhDWZel56YK8Z
	 oqcktbeBJV33iipfbhbMrJhozSLq5v0NDapSFRBCN90VCKhEnMqhi08T33OJrz+oh3
	 p5QcstNiQSwIg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F16353809A0D;
	Wed, 21 Oct 2026 01:53:36 +0000 (UTC)
Subject: Re: [GIT PULL] fsverity updates for 7.4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261019023729.GC3270@sol>
References: <20261019023729.GC3270@sol>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261019023729.GC3270@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/fs/fsverity/linux.git tags/fsverity-for-linus
X-PR-Tracked-Commit-Id: f9e450420da2624c93ce9585deebfabb87932774
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9e73b189c88fcba63af4775d637d395de0af4fdb
Message-Id: <179254761553.320300.4936003740329264700.pr-tracker-bot@kernel.org>
Date: Wed, 21 Oct 2026 01:53:35 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrey Albershteyn <aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Sun, 18 Oct 2026 19:37:29 -0700:

> https://git.kernel.org/pub/scm/fs/fsverity/linux.git tags/fsverity-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9e73b189c88fcba63af4775d637d395de0af4fdb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
