Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A7E1FB3
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 00:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732147727; cv=none; b=ApdshCbL/PLlBdpDtIfZSxy3LRHf3NPkfTgaDxWzDl/SmdmYW8t6BQ2F/bF2DBaNcd9mFEzROZ3mofqygz8SvK8kLr4zHCv0HagCflaDBsN4K2BoSZJxH49mh6Gbi+QSvfc8DnDPQLW2+WX+yHCDgXop5vzK+f41B+SeWwqG+Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732147727; c=relaxed/simple;
	bh=UJcGtiCLbTHoLX22YhPFWAwK5aalHj7M5uNeGVv7YqA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AZDweUhLJopcP60y+R/vptk55hIa3bDNyEo6CELvNtOX7Bi3xwHVC7QcArPAtmCC9/0WJs+s2s7nS1ps8B9z8hO41YuytIs/MKrvOReJNSqx5r1h+rQvNeGm0wQRilcHvqseueszR2gtdCszHkjY7rZ/u9azatDoKxkbdyhkPYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FvTrIRiO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FvTrIRiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2386EC4CECD;
	Thu, 21 Nov 2024 00:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732147727;
	bh=UJcGtiCLbTHoLX22YhPFWAwK5aalHj7M5uNeGVv7YqA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FvTrIRiOHKZRWtauaWbnS/aWc7Q+iWRLp0ieqBX0lbRwj18t3t5NZKaKzWk//p7CJ
	 flzEYgRA4iJvkBhcjkSmPRl19KyyybUGPsNqbs4L9zhrGJYAuPJJ9Mcfr+Bj0i+qlj
	 fkOo2jLtzo0a7HJIPlq614kpljNMEDs64urWjTPI/Espbq3Y+DjqgPJsgwllZlcDqJ
	 NP6+a8RVfwYPjQZ5Gf4upN4LRRtJ3kZfu3t/J2UQlTR8BulxHUb1C8rJ7a6M2obc+U
	 k49zuCf44fhnJ2KQITM96XWsDzNp7YH145zgm5TiD0wDF7cWbYMNA+FPcQXZy98Fo3
	 SwZsRp0uX3jlA==
Date: Wed, 20 Nov 2024 16:08:46 -0800
Subject: [PATCHSET 2/2] xfs: bug fixes for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173214768829.2957531.4071177223892485486.stgit@frogsfrogsfrogs>
In-Reply-To: <20241121000705.GE9438@frogsfrogsfrogs>
References: <20241121000705.GE9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Bug fixes for 6.12.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-6.12

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfs-fixes-6.12
---
Commits in this patchset:
 * xfs_repair: fix crasher in pf_queuing_worker
 * xfs_repair: synthesize incore inode tree records when required
---
 repair/dino_chunks.c |   28 ++++++++++++++++++++++++++++
 repair/prefetch.c    |    2 ++
 2 files changed, 30 insertions(+)

