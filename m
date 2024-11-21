Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D9133F9
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 00:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732147942; cv=none; b=nJCypxtIR1zXxwvA7+nOklqkparYfpWA4T9DMlTrGlRdAB6PbT0ZfZjk5RGK9qL9/vakfdOgYlssSRZ7kYNCP+qJFdFaVKPMON13D1nu1dttOuOEKP0qpK9Ji7U34dU5YsZi12Le2TB8K2gf4ryyJDVdAY4KKm+KiHkTaKhdn5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732147942; c=relaxed/simple;
	bh=2e7aEGBxL8GMQh1tLHFD/90R1rIk+HhOh13tLUG5HTc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=Yv5Mn3eb5nc9N6BjoJY690p1TB4KV7AL5dfz/OthFoKZLLHLDgb/9002bWA8tJan/A0FLUGtgaF+ZsSX/3LkopSnte3+mW1mCmojnG9J2/ekyGOvQXa5uFglkWsuT9t0CzTw9xb5FDVHetAul6R4CVl/InDhrKkJVKoo5eirAko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sGpPQ+1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sGpPQ+1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F52BC4CECD;
	Thu, 21 Nov 2024 00:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732147941;
	bh=2e7aEGBxL8GMQh1tLHFD/90R1rIk+HhOh13tLUG5HTc=;
	h=Date:Subject:From:To:Cc:From;
	b=sGpPQ+1cEZPu7GNx+49kdFdm4FOLVKK4w8/HJi8DygEaClzOfcO8QNFx0m3ZPF1yn
	 U1jkrB1fwqG0xvfEbmuZRhFYbTZC98nKsE+SJXwhI41r8HQ/q0ADGycv6F673arR8m
	 MGRmz4AzBLZNJofe0mbMnM+Tkaxiczh5I0NcWYtb9uvpikHaytFiXZezqVALOLiZgK
	 wpBELAP9WiXlpVJe6llS3Koeo7UjbQkySGbkPWsawKriqlKZlcZodfHkq+Wv2ww9e3
	 kIcqZT2WkXj+BIQ7jaWFyGVfXfCkGQ3NUPS7EAIHEvY/51yAZ5629r5F9L/ZmGAx+I
	 rabMTqgcWcPMA==
Date: Wed, 20 Nov 2024 16:12:21 -0800
Subject: [GIT PULL 2/2] xfs: bug fixes for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173214788656.2961979.5172451040789575673.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.12-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 0cc807347d5a47d106b6196606e01297aa3a5f31:

xfs: Reduce unnecessary searches when searching for the best extents (2024-11-20 16:03:44 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/xfs-fixes-6.12_2024-11-20

for you to fetch changes up to 09f319213924f4ed144b23368e33a7ff7ef5ddd2:

xfs_repair: synthesize incore inode tree records when required (2024-11-20 16:03:44 -0800)

----------------------------------------------------------------
xfs: bug fixes for 6.12 [02/17]

Bug fixes for 6.12.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs_repair: fix crasher in pf_queuing_worker
xfs_repair: synthesize incore inode tree records when required

repair/dino_chunks.c | 28 ++++++++++++++++++++++++++++
repair/prefetch.c    |  2 ++
2 files changed, 30 insertions(+)

