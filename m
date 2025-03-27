Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D864A35964
	for <linux-xfs@vger.kernel.org>; Thu, 27 Mar 2025 20:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743108564; cv=none; b=neSxi1fwaOwmQN5/GwOEkwars+WvHkI4P1s7O31cafR1zH/LZMQUXKSOVLtK7mhu+RYM3jPMBQ8QWqqjq/bY/d+eZI2ys8ZQPe1jxnCO4+7Fbb8iij/YSDR8a/KRoZsUWHmS6RWzilADFAe7iU+tdcOyaMxc2Kir8dBzRAxgSSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743108564; c=relaxed/simple;
	bh=YRDxHE6tKlSae1cjSA4U78SgBI8WaPJMQ4u3Sqjpcso=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VjjpEKcPDVlGAAjcoaL7qhY2WP/Xi/MUnDxP8Alnj3MnP5Ni63lUKIlZLRLY1a8DlD1l5QkPwPm3BmKbxudYH3MfJJCaKaBw31jdABztfScM+yNVvvXO8oq5d8eE5BXq/JoLV0rRxzVWN/+8JkDDLNQpeXs9iyp0+t5HIKEBOWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGaepQqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGaepQqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C5AC4CEDD;
	Thu, 27 Mar 2025 20:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743108564;
	bh=YRDxHE6tKlSae1cjSA4U78SgBI8WaPJMQ4u3Sqjpcso=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kGaepQqNssJNGiW3XY0ia4qdbzbdTz7DTwI4f/rnZ8kOSS9Yg9Y3hBumDAnVZiU79
	 7RAz9EBKLMbQBiecZS7WOgADw4N9pB0NA1ZgUZdjoXAhO+/hOx/Kcb/ns7kisnMSLy
	 V0Q+l13p+hA7rOafp8JeqrSG2qhjJI5jOHC0xKNLyp5xYQoZPySj6vcbh6pxp0RM8c
	 mB8WCDlxRINjoewzqwHQEYcJ/ypu/xveIEJ3j17AYf6rs89fBmtkGSJzH72yolxavT
	 uteaSzYUQByfdGXaG7sn582OibeInrcXfXtGu8Z/jqqyptn1eh6+B2tIf9o8I0VwXU
	 QgZ6Cq49SUv5A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB994380AAFD;
	Thu, 27 Mar 2025 20:50:01 +0000 (UTC)
Subject: Re: [GIT PULL] XFS fixes for v6.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <7osalttg7zzp5q5pee3zqjqde4tzspqjaix5q2suoxoewn4n5d@ausn55axx2z4>
References: <7osalttg7zzp5q5pee3zqjqde4tzspqjaix5q2suoxoewn4n5d@ausn55axx2z4>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <7osalttg7zzp5q5pee3zqjqde4tzspqjaix5q2suoxoewn4n5d@ausn55axx2z4>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.15-merge
X-PR-Tracked-Commit-Id: b3f8f2903b8cd48b0746bf05a40b85ae4b684034
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c148bc7535650fbfa95a1f571b9ffa2ab478ea33
Message-Id: <174310860050.2212788.8128409522083871510.pr-tracker-bot@kernel.org>
Date: Thu, 27 Mar 2025 20:50:00 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 24 Mar 2025 20:54:40 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.15-merge

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c148bc7535650fbfa95a1f571b9ffa2ab478ea33

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
