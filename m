Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F235F37FF42
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 17:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773424456; cv=none; b=Sce6xBMxZ5VON6QENL6EGOWIBJYiVIp9fkXudhMDXFlUNnBIfngpY6BT9EdeS047QnqXv/YfZQMFa82m5vxyH2CPgg7Dg91Tt8BYvtZFDoJxDZejT8jIOECk3DoU/yYcVnagKg2UR7M+JBhelSjztCesvrziTOu3l4GbwS8pl6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773424456; c=relaxed/simple;
	bh=5x9Ek9KADjj2uSbm2V+fsZFuHIVuN1yQVeBpHIzVlUE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=OPnoK1rd+0Cp+63//KSFS7L3QAJTFgtKCSbFyJBgsWB2rWycwSrkzPFslSAAbgz9Jt33TyPRQLTOJq0zcT9ZKiMlMgH08px7FN/tWEkKo+HPpAitfXzllQD5EGQwp920hWQOKDNXfOZHHxpbGappp953W0hvmWmftFVsRaIDsIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/q5khcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/q5khcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E7FC19421;
	Fri, 13 Mar 2026 17:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773424455;
	bh=5x9Ek9KADjj2uSbm2V+fsZFuHIVuN1yQVeBpHIzVlUE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=E/q5khcGOMK1h6HRqm4wcnCHgMXVnTNbE1vBd4N5fjojmOc11ph15cZgfspvLrPKZ
	 WhjtcfEBpI4lOG/wTTxWtzDOIxbReQIangjvf0246TNWyWQEprV+70sLnOiWKPlj1d
	 P7oojMPNAQDCbKhT3nUBpNY5bqgXrkEys42qB3EJFalziulsxTq4vDl30ysRpNWeIv
	 L4e+8AAoiGgsR28Elgprdj+DvCsPEd8ZPgxHAUTvhRfB2Y47a29085f4tk2HQofd4y
	 lR/hQdEsxNhi1od9b+W70pGJfHsFHnVmedEOZc+KUxfZ5Ud7q6WlqAwTEBR+Fo9Oi8
	 ythwl/E/y4hiQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CE5A3808200;
	Fri, 13 Mar 2026 17:54:11 +0000 (UTC)
Subject: Re: [GIT PULL] XFS: Fixes for v7.0-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <abQjwPYZiCGnCVbM@nidhogg.toxiclabs.cc>
References: <abQjwPYZiCGnCVbM@nidhogg.toxiclabs.cc>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <abQjwPYZiCGnCVbM@nidhogg.toxiclabs.cc>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.0-rc4
X-PR-Tracked-Commit-Id: 362c490980867930a098b99f421268fbd7ca05fd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 399af66228cfd7df79dc360810b6b673000f8090
Message-Id: <177342445011.1446579.2941070271993417906.pr-tracker-bot@kernel.org>
Date: Fri, 13 Mar 2026 17:54:10 +0000
To: Carlos Maiolino <cem@kernel.org>
Cc: torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 13 Mar 2026 15:58:01 +0100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.0-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/399af66228cfd7df79dc360810b6b673000f8090

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
