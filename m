Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9322116F0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Mar 2025 17:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741024619; cv=none; b=epVa3zkJHfeKkQa47i0ZDrF13S7IaahlI5NVCNHPDe6Rx8E2F9N/M3ichiF72DXg0UqO7KOYF20GjsYppR7u6kZUT5hJ4g7Dgbyf4y33vkQg2ezakVj++LbDd19QYbHvSY82V7d7TOPoSH+G8qV6HY+hZLP3QmYcLg2sQTZGm2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741024619; c=relaxed/simple;
	bh=Y4ahv04+NXuR6YbxpMHUDodsjm6pxNzkeGqUp6YrqV4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=B0QRGWgEHGaJiM0N2yTW8VUEldiRLWX8kZFljTKzGbB74plu0xYhQykxAdVS61tpv6amkM65kw5sPFcQ1+x1zWtQdTJpWNRTG3wOLZj96jR6XzahxK6QI4zeC32CpFjpHm+OWzIt/Z5LJd7LK2PSD0xUU2FY3FiChzaleRhfCpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WqzDWx2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WqzDWx2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7679CC4CED6;
	Mon,  3 Mar 2025 17:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741024618;
	bh=Y4ahv04+NXuR6YbxpMHUDodsjm6pxNzkeGqUp6YrqV4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WqzDWx2kVwG4/+cun0TsRkKlIkqfj4wYxwdQcxYzEB1NnNJNmY0GK69W77RRqpmSN
	 K15RMikYVeh0sfVun95N5+sC+wZDapYyZ3KLTDfSNbgZzrkcUv4GkS41llIyKGQnxw
	 pnq9MtZq6Slg4nP3/heqYgx70DnrSvQig5qedG3gXsLfV72intjuustgpz3HN42gWr
	 lAzrCcEKdTihnUa6looBVRWpwtMUI3lndqhmOO6WtJC0LL86MRigIpDeJSESL6Jobl
	 nQrZ5bINyWuV1zIAlfk99KCoiOFlV9xQqjsV+6rK+78qfrm3BPdIbASexrpKrsV2E5
	 4qYzuVZ7Kov2g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70E353809A8F;
	Mon,  3 Mar 2025 17:57:32 +0000 (UTC)
Subject: Re: [GIT PULL] XFS fixes for v6.14-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <tdyusv26cmphdeo26jil4kfz2nokkf34m3mchl62xpf3rui3i7@z4agwzsfdghd>
References: <tdyusv26cmphdeo26jil4kfz2nokkf34m3mchl62xpf3rui3i7@z4agwzsfdghd>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <tdyusv26cmphdeo26jil4kfz2nokkf34m3mchl62xpf3rui3i7@z4agwzsfdghd>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.14-rc6
X-PR-Tracked-Commit-Id: 9b47d37496e2669078c8616334e5a7200f91681a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d9a9c94dbc8bfeab2b29f860d38e5056894813ec
Message-Id: <174102465108.3669258.968197639450736434.pr-tracker-bot@kernel.org>
Date: Mon, 03 Mar 2025 17:57:31 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 3 Mar 2025 10:18:25 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.14-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d9a9c94dbc8bfeab2b29f860d38e5056894813ec

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
