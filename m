Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B75C265CD0
	for <linux-xfs@vger.kernel.org>; Sat,  8 Nov 2025 17:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762622156; cv=none; b=NPzWZQnbrKBoWdwamLZkSMfez2UC6z7LU2YAaJ1G4NJtpbKkfYOtXXk89wpDTfS2XWuRwzmvTWYjTHzzPLiT+gCAO3EhljFtUMvzG3pF5Rcf9oPqcQfwew5YZjN9MqxbLgW+73Hctp2a540mSnqydySmNGWo0r6IqWtzwPzZO7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762622156; c=relaxed/simple;
	bh=JgX/Fy0EgW1EMewCDaafc/6NA8uEByMtWqUPPUYs87w=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ft2TiUe2aFeno7LBi0VLtzn4Ut3eozYG8icLXkR85cyghRJudl8TqfWPoWC7VAqgz6Q4W4LZgJVwU5xgQdkT6azPLAmiv/jeJ8HYCbFxYV9BzQpR8tEyrICpJRTYBwMQ3grmCwnwcLjEvF1J6ke9fPBEmdUKGNlGI384j75U5LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tTwuEIiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTwuEIiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79D8C4CEF5;
	Sat,  8 Nov 2025 17:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762622155;
	bh=JgX/Fy0EgW1EMewCDaafc/6NA8uEByMtWqUPPUYs87w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tTwuEIiC89hPlrbUHqC5PYYfgKyxGo29EQVHsCVaLCGomCU578IqZ+fC/fzzGF6hd
	 DKt7i+Gmy0ekocoYv38MZNV/8vbvQPQRT+xPs7LRWtcLJhDSAkerNemBPVwH77qQ+k
	 2F0MRVFq9p3TDMpsHY/nRXFvmFBkOMgVNQKNchTofCVXO5Kwaloc7Wzmj8Z7zllLDH
	 WK8LuW0NQgeZXqGoom7YcRHE2EeYzHR1B0XUwkh+OMpZ8ET4Ks5nGcpws46D88/9FI
	 K/hXJlbmny5LgwAqOMpR8WKQocQOcvEBYl5ryrZnoigHEzQIhAQTLOP0DZQbmX1ARl
	 +MkLfANtPrzQg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADE953A40FD5;
	Sat,  8 Nov 2025 17:15:28 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for for v6.18-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <44wbf62am2tx46wyelnthkhzrh7kkknulqaf7ftpww64zahyr6@kiuc6di55b5g>
References: <44wbf62am2tx46wyelnthkhzrh7kkknulqaf7ftpww64zahyr6@kiuc6di55b5g>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <44wbf62am2tx46wyelnthkhzrh7kkknulqaf7ftpww64zahyr6@kiuc6di55b5g>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.18-rc5
X-PR-Tracked-Commit-Id: d8a823c6f04ef03e3bd7249d2e796da903e7238d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e284d5118ac3e430da32820215c08b2787de8eef
Message-Id: <176262212739.1365123.17837819351712966374.pr-tracker-bot@kernel.org>
Date: Sat, 08 Nov 2025 17:15:27 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 8 Nov 2025 09:58:23 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.18-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e284d5118ac3e430da32820215c08b2787de8eef

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
