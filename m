Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A514E20B807
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 18:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738606200; cv=none; b=q7x/uXuWUal3yjTVCNq5dNJiaSSPXXIfOnOYKvInSGu1ZyG8y61RLDgdgPKbgbAIHb+h8bIclCEyOW6soTsfK1WSxaqlJqjVv3P91gef3voVOHjbLsTtVnXzLEcFahTaEm3jIkyHUUdF6XTd4ihg4lZga4VN6Qdi7OWnXf2c/8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738606200; c=relaxed/simple;
	bh=V57+ApCO2BPiY48ZRcikUaeERX1IYlX4pnrar9Za7QI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fii87XDxUBf+Jf56+63PnSlGlSs5DNiJquMdLg1k5wAsxQ+YbO14OcswrJ6r3p5zsIKp+uLRtm0FVda7v2MLfvjJmqXZOUnmlWXZg3xWsGzwOXIcUckwLW6Y8JWN+XO8Aa/zZ9QmC0wjBREvTg1LCteNERZkam/cCCwiL6Cr6Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0/z90WK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0/z90WK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD6AC4CED2;
	Mon,  3 Feb 2025 18:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738606200;
	bh=V57+ApCO2BPiY48ZRcikUaeERX1IYlX4pnrar9Za7QI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Q0/z90WKXgZFgcIiRyd3G640HwZD2eNyleP5BpJA+I7/ySH9e02JX7iF5tE2bAwhY
	 64/O7vHOV2ITcAleH40eDnlq+RUG0mD7Ari8bZ7SI2BPog7M8I5CnboszYOh8MREex
	 wldr0en6K0e0kwTy9UM7iHoA+0g3/45z6NihSqmP5NiHnzAqdwK9w2rvVEIIUnleYc
	 YvqYdKnLM+zlsBUr0fEa9KzgL2NJ1G/74nf5coXmbFEICbpsqKf6wWAy6OwYFDVW2C
	 uloC2Onuxgt4e8ZulT+3PMyuXDPxWVRAQFYGp/rfAMXPIZysu17UM6nkzCAB/CYMJ5
	 fNrYT3L7xvRKA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 73234380AA67;
	Mon,  3 Feb 2025 18:10:28 +0000 (UTC)
Subject: Re: [GIT PULL] XFS fixes for 6.14-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <asmybeduuf7ue3yd4akkyhjuwxbeb5yepprzs72zgedgj2xjir@cxbpahwzp5c2>
References: <asmybeduuf7ue3yd4akkyhjuwxbeb5yepprzs72zgedgj2xjir@cxbpahwzp5c2>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <asmybeduuf7ue3yd4akkyhjuwxbeb5yepprzs72zgedgj2xjir@cxbpahwzp5c2>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.14-rc2
X-PR-Tracked-Commit-Id: a9ab28b3d21aec6d0f56fe722953e20ce470237b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0a08238acfbaeb7d3605a5bec623ed1bc88734eb
Message-Id: <173860622702.3393002.7337972736000724925.pr-tracker-bot@kernel.org>
Date: Mon, 03 Feb 2025 18:10:27 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 3 Feb 2025 13:40:24 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.14-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0a08238acfbaeb7d3605a5bec623ed1bc88734eb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
