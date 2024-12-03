Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03421FCFF5
	for <linux-xfs@vger.kernel.org>; Tue,  3 Dec 2024 19:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733252726; cv=none; b=pZfPKTXo0f1pVQyC4MDXJUugKMjOyl+jYHScjC9J7sTMG+ZBob591fd9alG31myZppuyzuoCb4IIh0o5AQkPzOR8HQ33/SadYTEvf55L6AaV5En+UoAzCjndWkWZIIcapLAJaq01e/nLF47jcOVdpbS6MjgcENdXqGn7X3PE11M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733252726; c=relaxed/simple;
	bh=WdFZhmwnHY5H9wWEMg6q5wJM67Jt+FgrvDcRgo/uZPg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=dT3t5aNBC/nbWUNrCIXV7faqTx6LXSYDRfM0F7hidumjOOzRQCjhcH+ZKN5wdQIbbiRUIHXIdjdonxDzwl27ZgxuQST0y370dmeDScxYUrRwmeBCXdSiV5k6zGv32h6zF7HqyLPunoKWj1ld2f8tjdoYEv9QbXaFNFq4rpNSAzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ONBmGc5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ONBmGc5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74027C4CECF;
	Tue,  3 Dec 2024 19:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733252726;
	bh=WdFZhmwnHY5H9wWEMg6q5wJM67Jt+FgrvDcRgo/uZPg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ONBmGc5lp/M03rFYCKyaVBOWyQ8e5iueKLSiFrZLfmzTnQLU9jdnkk1S3m1gs6Om+
	 IvYfzTtlnNiq3bKj75U104KQHSy8PgdOZcDlqN0LvTFkGrqsCCzCP4GgfmvSJ9rwfI
	 9lG2nmeo5e73Ocuvga0Drk2T8XsN8ZaWamgw8nYVpfHicfuiPhqCsvfgxe6rF1++hE
	 Y9f/X/u3DnzhHk1shKbfJXcM4rhgO7GR88xAkupNsDVYUpbM3ZFWkT1rhAYL+9HNqT
	 K3oawEOcOfodSdYYI3gCmp+yL1o/fD1b+rekj4lVRTwiS2XMWMrgbawZBk7MeVdhw2
	 WITIpt+ykUuYw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EADBD3806656;
	Tue,  3 Dec 2024 19:05:41 +0000 (UTC)
Subject: Re: [GIT PULL] XFS fixes for 6.13-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <ejncdz5w43y5jn57hzskpsu3hqbxfz56t6mddjtpr3tw6nimyl@ryh2fn4yd4t5>
References: <ejncdz5w43y5jn57hzskpsu3hqbxfz56t6mddjtpr3tw6nimyl@ryh2fn4yd4t5>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <ejncdz5w43y5jn57hzskpsu3hqbxfz56t6mddjtpr3tw6nimyl@ryh2fn4yd4t5>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.13-rc2
X-PR-Tracked-Commit-Id: cc2dba08cc33daf8acd6e560957ef0e0f4d034ed
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9141c5d389a9ec80121de3125cde7c713726ceea
Message-Id: <173325274040.214632.9745508028875001218.pr-tracker-bot@kernel.org>
Date: Tue, 03 Dec 2024 19:05:40 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 3 Dec 2024 13:49:25 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.13-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9141c5d389a9ec80121de3125cde7c713726ceea

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
