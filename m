Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2043207A12
	for <linux-xfs@vger.kernel.org>; Wed,  6 Nov 2024 19:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920656; cv=none; b=oHzWuu23MtzWjN2pn8RNRcSYlYXZVqlb68fdAllaEPOa20um8igbGjLSo7+hmJDx+L3USQ2QZ99EMcAm2DHbbGTxA0luyehhQ778Xblc1BjzWifrl0ZHNESkjKi1W1mfRhelRrZf0EpJ847xXO575wmpH9pA8Q6fsOQWovoVfng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920656; c=relaxed/simple;
	bh=ddPF00TEQkPGqvcY3HpUHAOIqx0S9FzwcLy0CWyqtBg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WvR+e/meXqGWn+A8ZoX2tDDbM0doUNxiZhsip3gMylprItSo3niJRjwG9aydkGfOp3cKe1kZYO9pXdIqJbJrB9DXwkAh5LHw6xNRzPyCTK4cvVDXCHf4+lwX9eUygCy+IWk3VUbReDgEHwP/ZP/f5d6P704NN66hs80FN64S0u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uE5fnQuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uE5fnQuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A91AC4CEC6;
	Wed,  6 Nov 2024 19:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730920656;
	bh=ddPF00TEQkPGqvcY3HpUHAOIqx0S9FzwcLy0CWyqtBg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uE5fnQuOElF1Jqrw9yX3ZbINay3409ojABsBKxqX+eR/4P99Mdx8/MPCi4o3oYTOU
	 LMcVRUCH4rkrUgwOVcp4KS6AXEz5cwYmOfgEilM+JE3RIFrMEO5TNeO7sN6L/0LX9b
	 /EzQ5TFK6glSsV9VUqzC30Wr1L+IaKu14ZCPmwqbd9/WQrcRKAmOV6Clh9ncJOUujG
	 tF08yTiWaknSG0mzFXT9aGRij+9j3fZE98GWVB3qvBZfjo9I99FpJq9k/M7+FAUlzf
	 7vqpb8z1tqQESegrNfZr5kK8HPKXfC4tMhAyD49mCkMOX4dB9RrYUrgUSU4t23afJ3
	 ZiJTTNlj+YODQ==
Date: Wed, 06 Nov 2024 11:17:35 -0800
Subject: [PATCHSET v5.5 2/3] xfs-documentation: document metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173092059330.2883162.3635720032055054907.stgit@frogsfrogsfrogs>
In-Reply-To: <20241106191602.GO2386201@frogsfrogsfrogs>
References: <20241106191602.GO2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This patch documents the metadata directory tree feature.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=metadir
---
Commits in this patchset:
 * design: document the changes required to handle metadata directories
---
 .../allocation_groups.asciidoc                     |   14 +-
 .../internal_inodes.asciidoc                       |  113 ++++++++++++++++++++
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   22 ++++
 3 files changed, 142 insertions(+), 7 deletions(-)

