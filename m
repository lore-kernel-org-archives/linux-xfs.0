Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CEC30E0E4
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 07:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781593734; cv=none; b=L2uKgaOTXOA+CneFOMCykdv1w1Tpces78+esgjsHNSV4XZ8eBb5EoKQEr18jAt6JFtMnDnzwItE1uGsQQcZrvGiUw3ezOyTs9VPA8a9Za65gUQ3I6rY9sNkGVx2xHVdB/gmIoR0tNxXWBLyapUfDJEklUPTSe3zy/GTvXD3gPrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781593734; c=relaxed/simple;
	bh=I7f98v85jqfW9CwV0J7H/NLZR1UlsTEoAGA0hSaCnmE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=q6mHYiZTD6/cnHxfXOMjlQmjR6HvvmAX7qGs6jlCGI+UdGTgIZr61qF4NSoT0yJ+v7Cc19W+lijbso4pl4XnAea+nqtxoEVWsh76xyO/Y6VqsI1veXbpAf4BPGKJsKV/BFybHRg9aej3NwgHZy6JZ2Whxgg86vJoUmWuoH6+rRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHyCnzdm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHyCnzdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D38D1F000E9;
	Tue, 16 Jun 2026 07:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781593733;
	bh=WpXTc9vypvCGRWwpAz8OmRGnOElCf21YPReoe0QZR8w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=BHyCnzdmv0RtBq4VeHey2gIjcFfZQXT0YdLsdjQrigTMGeJ2meVET9NOiX2g1C9MW
	 y5Xl/g3eAYFrOe5EMOAiwByTNZx4bP5IzTTm9NJXic2e0ENQcnkG/YTaXciwnsAlH/
	 RgN14U/cO4zCloa2Nl0Ic05lFQj7MkJySxby3HYVtIiHNyR6+jDqtFFyCEiqIXEzJc
	 DjNN7/tgg/BGcdx/W2p6sCMGSrlakBw1eIzwNT2+r8nC73DDmYHDdpaP8GZkLdckKw
	 hTnLuR3HF8t3nIU8WOy+SbGIjHAxulYlLBmAjE9YHP7zXGyhWTbZR5EBlsmlQ80URF
	 ehvrRWpwgF8TA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939AF383BF5B;
	Tue, 16 Jun 2026 07:08:49 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: New code for v7.2 - with conflicts
From: pr-tracker-bot@kernel.org
In-Reply-To: <ai_AhORI0FprqM9A@nidhogg.toxiclabs.cc>
References: <ai_AhORI0FprqM9A@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <ai_AhORI0FprqM9A@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.2
X-PR-Tracked-Commit-Id: 804826eac53cff44f88f42989fcc601c2612c0ed
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6271f6ea7f65191762efe17c1a7d33f8922e1eeb
Message-Id: <178159372838.494683.3569192842108063736.pr-tracker-bot@kernel.org>
Date: Tue, 16 Jun 2026 07:08:48 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 15 Jun 2026 11:29:29 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6271f6ea7f65191762efe17c1a7d33f8922e1eeb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
