Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DD02E88BD
	for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752864586; cv=none; b=R7l1G7SbXZ1IB9N3TLbyFOvmDAD5dZzK1p+jTK/mr/hLWKkaiVh10KtClPYW2ddwjO+VIcJ6A69iuzCA8/r+RY95DEuAb7eHqatwy6lHgutkQ08c727xv1T6uCnGW1sag/YQNXYyjUNjq459EeUXF+SxvvNmPW3eXIVqQFllQbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752864586; c=relaxed/simple;
	bh=PBvo/F47WWa35drxxfP5wbOSaiuWPproxHo9rFPlWLk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PDG0iNts/l8ny2XNpeqrx5jVeC1qdRg3N1dnmoIC9CLg85bE9jgRIw5krZ0Ka9PRoQzIJrTgNAZHJGTnSeR7ZK3uRyh5qZGrEsUKed0ejKfn9f0meZYUzjSR5XfLmiwVnhgF5e7sCqwnaVQMGITK4OLO4k2h+n1TdmOAtV9RF+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FLoA1EAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FLoA1EAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF7EC4CEF1;
	Fri, 18 Jul 2025 18:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752864585;
	bh=PBvo/F47WWa35drxxfP5wbOSaiuWPproxHo9rFPlWLk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=FLoA1EAd+Bmm4oX313mkszwPWI1ZytV2ywOdG4bhY8M4xAuPDL0jQaHQqVVsvujVc
	 6/h+Kj+nD9oIrqzogi8hMyEfXRFXpgXbZTxlnCrgaQoLTBOgUcoztRk3eekK3gM83g
	 YIbSdhU/qeAsPsT/6vLVgw2wzSL4AkA4/SLcp0QKjm3wEiYZQDMiTUA/ykx3dr6yGA
	 JE8FslkUipxHYVkntYIbKheGlIxUfUdMvH7yvud/CrxYuk0Kz115giqYsKY4exqcN8
	 mo6YP1R1j2oXB/g9BobTcxCevowVVBDbnD4lLn40t8ERm5jnl0HqVeuSjuXGYiLleg
	 kuG2ERRiDEqnw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AF4B7383BF4E;
	Fri, 18 Jul 2025 18:50:06 +0000 (UTC)
Subject: Re: [GIT PULL] XFS fixes for v6.16-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <lwjtudstcnsdwkum4szlk3k3lrqxykvijlsqbk3bznggpw7wok@2xxumekrogmy>
References: <lwjtudstcnsdwkum4szlk3k3lrqxykvijlsqbk3bznggpw7wok@2xxumekrogmy>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <lwjtudstcnsdwkum4szlk3k3lrqxykvijlsqbk3bznggpw7wok@2xxumekrogmy>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.16-rc7
X-PR-Tracked-Commit-Id: 5948705adbf1a7afcecfe9a13ff39221ef61e16b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d551d7bbf264ed11d897368e3670bda5b37b360e
Message-Id: <175286460525.2758816.3683417066518671924.pr-tracker-bot@kernel.org>
Date: Fri, 18 Jul 2025 18:50:05 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 18 Jul 2025 18:12:31 +0200:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.16-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d551d7bbf264ed11d897368e3670bda5b37b360e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
