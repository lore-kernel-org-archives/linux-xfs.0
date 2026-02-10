Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8C5234984
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 00:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770684606; cv=none; b=KZ4r7IfVKpNzKW2aS+9zzmlAiGExHS2bt09OlDC2h+69Jduc0y+g8h72bChHbLwKcSkcVgyGWpEE6JxfaIuh+hJDvFaF4oCCXwz4o/w8hvzDVC80/bI8iA1QyBmhZkn5gCQu2qULv9Rf+bx9kvrTG19bMpNZzdlEBILaefzROno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770684606; c=relaxed/simple;
	bh=DjuCjtdgEBE8YnR18x32jb94BIWi6OV1FBVh2dl3qvI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=i9DlI4fihfUiH0/94wfAdDBWED3OdxKeKzkf4o1NgbB5ZVJfCfbJKnu2FTLyY5CAFUaJj5jqnO2r5ZPvT8kF1aWgmM52Iv/gKBOgAdbOT6cZ0uJXtmJudI24hqxUnxCi6E7vYTHEj4y4pMBD8vtEW1UqxdG4hJRIvDWKHLm9c4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Glinw17q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Glinw17q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C98C19425;
	Tue, 10 Feb 2026 00:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770684605;
	bh=DjuCjtdgEBE8YnR18x32jb94BIWi6OV1FBVh2dl3qvI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Glinw17q/v4kJm/1dsCVmUKKz45qPD8KAInJxslp7k3hLmFV6d+cbLrxUKDe56zE7
	 nSIBn0L7A4moJaRCiGUFBPc9B0857NZpj7T1y8ko3UGiN3kMDeRyGrhPe9l7sbDU8j
	 7kkGA4hXJsMRD1es44ax2/l9kuAbVmsBcowlholbWHSMrwP25zvRvsxQv++n/qeZUx
	 ilXYSfRk86A1hI1MTHMp5C8m3xr8129mmF0dmIBF95l3PZAMYysQ1KCYY5ZYT2C7dx
	 OTiMPtkQ9XTENeYEHDctPyvbcF2U9ajOKd5K0sLsv/R0etLh/UzQH4V1U4S68T8imX
	 55vgsda1TxRmw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D5E94380AA4A;
	Tue, 10 Feb 2026 00:50:02 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: New code for v7.0
From: pr-tracker-bot@kernel.org
In-Reply-To: <aYXRoLlWgiUYROCK@nidhogg.toxiclabs.cc>
References: <aYXRoLlWgiUYROCK@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <aYXRoLlWgiUYROCK@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.0
X-PR-Tracked-Commit-Id: e33839b514a8af27ba03f9f2a414d154aa980320
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 56feb532bb927ae1c26726e2e7c0de95f54a3d67
Message-Id: <177068460179.3270491.18070865243842275851.pr-tracker-bot@kernel.org>
Date: Tue, 10 Feb 2026 00:50:01 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 9 Feb 2026 10:31:33 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.0

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/56feb532bb927ae1c26726e2e7c0de95f54a3d67

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
