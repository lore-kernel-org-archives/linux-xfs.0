Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0210C20E71F
	for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 17:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504401; cv=none; b=rNroVg6g6Ai6nokLv7yVB1M8QD7qY2lXDzYycsnCChhhDjKkz4PlHRPzbLxAzjgb3dFiBeD53iF86XT/B50nvimuYEM81LeWQ5wm/jGZGuxPBSuzlf6UH48PfqCdmacYb6VFcpbLR9WM7bwxH5LA2MJFST2Cl88wtMEA8KpKS8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504401; c=relaxed/simple;
	bh=1mk3r16d4BS20TgJzpg/aHwgc5NYld1kMvXb11st4BA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=mXWzCpj/d4snqYR29KiRjktckfy7jkA9gyXkQBFHbAvgmwNcGAKKEt143Ni5uwNdk9YM0H+KxT0+HugTbAuSdhBj8NaEDZEQmf+NWN2+11br40JAr4/pFfPjOcUiXUZiAK5GiMOx7R6/BeZnYOPdV76OyzMEZ0PsWH6dt1hj6GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DFBaRGnO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DFBaRGnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456FFC4CEDD;
	Tue, 25 Feb 2025 17:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504399;
	bh=1mk3r16d4BS20TgJzpg/aHwgc5NYld1kMvXb11st4BA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DFBaRGnOjwPmOpDBBBUR3gFSnOjIqK4VzIv/XqjhWnUdYWro9y914pIY6Iqvon1F1
	 TrTkbLJDcmTHlxkKfthE4u2W6li9x8UDNZkc+T0/vGXDTTAZEn+yPlZQ2ePWQA4gyx
	 ag08876r0Y+9qE5P2h/G9cxk/r5qk+sIf95ZVFvstNGguEsMesTt0y/hKyeum6ZcFl
	 Q3UAVgaJd93ituXAOElp3loGPDzURVBZkjon5+YsZHvjSedl3QkXMV9YIW+U3dIlby
	 jc2688ony0qSGi0UbHy+fgyI8nvjGisv6qwl18rcjUNz3lOnl1W8wP60S+aptJo5KH
	 fxV5us8WdPu2A==
Date: Tue, 25 Feb 2025 09:26:38 -0800
Subject: [GIT PULL 1/7] xfsprogs: random bug fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174050432806.404908.4967721209831766653.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250225172123.GB6242@frogsfrogsfrogs>
References: <20250225172123.GB6242@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.14-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 4fd999332e19993fb7fd381f5fcd40ff943d98ac:

xfsprogs: Release v6.13.0 (2025-02-13 11:28:27 +0100)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/random-fixes-6.14_2025-02-25

for you to fetch changes up to c1963d498ad2612203d83fd7f2d1fb88a4a63eb2:

libxfs: mark xmbuf_{un,}map_page static (2025-02-25 09:15:56 -0800)

----------------------------------------------------------------
xfsprogs: random bug fixes [1/7]

Here's a pile of assorted bug fixes from around the codebase.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (1):
libxfs: mark xmbuf_{un,}map_page static

Darrick J. Wong (3):
mkfs,xfs_repair: don't pass a daddr as the flags argument
xfs_db: obfuscate rt superblock label when metadumping
libxfs: unmap xmbuf pages to avoid disaster

include/cache.h  |   6 +++
libxfs/buf_mem.h |   3 --
db/metadump.c    |  11 ++++
libxfs/buf_mem.c | 159 ++++++++++++++++++++++++++++++++++++++++++++-----------
libxfs/cache.c   |  11 ++++
mkfs/xfs_mkfs.c  |   3 +-
repair/rt.c      |   2 +-
7 files changed, 157 insertions(+), 38 deletions(-)

