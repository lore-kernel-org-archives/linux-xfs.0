Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8A72139DB
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725302555; cv=none; b=dzFQBAkURs3oBf2TkXPvdb3nbxSJGiXrfkriHHT5alCGWc5oSWVdAkKLKkUrtGdp5GrU/9OgQs9I6OXwM4omIanxpUyntEEhDFv31hf5wJhapg2DDD9me9lU2Jq8xao+BFQkfObP3G71Ww059YHJJ+QR1UE63/8uRGfhhoqYTnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725302555; c=relaxed/simple;
	bh=YKwI50g2mYW80tAsn/sJVibXWnpmgPG0fY5TJoArGoA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=BiqNVnShL6mh4g/wc8xJkvBWV5FV2EmYYPcJFughLjl7KBPVLdhzLnFcD7GoVuyZZdGG9p+kByQ1K8d1dF0l1jXwLv9LcxtNqhw/pN5xga+8b7OmsJRtWBCK31UPvrj0pzREkQHyO6uXQX+wYzWS5PnZJCKH2C7cyGeApuekZWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YoPy8OPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YoPy8OPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CC5C4CECB;
	Mon,  2 Sep 2024 18:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725302555;
	bh=YKwI50g2mYW80tAsn/sJVibXWnpmgPG0fY5TJoArGoA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YoPy8OPVvtxnmfGaFmRcmF/kYEpp5zv5m/SguvyVBXcCPUdv9prCMT/ykDaQJxdFJ
	 lSrYZMOaLGAvowiLd7ulIDCAKfk7CCeVtQGYpHI5g3jS4BMiUo0wshmfgkp7p19v3j
	 Y571B5k3H7iTBuhcpXej38QXd9XkcGdk45u66xW0UtAOZTvgYMXfxtdw6uSqC2ggN7
	 Pjtw5N06lzQM63h/q7PT65ZznZPcoENisXC0Fh3oARTrOni08dvwhuE9WF8MqzpGqQ
	 ugX5VrVZSFXYsnjRgQurJ9Z7WzMY7JVUQDZedY2Y/ukhFRcRMwUNcBxwDUDg/AunT8
	 7WH8pVIdXCCjQ==
Date: Mon, 02 Sep 2024 11:42:35 -0700
Subject: [GIT PULL 4/8] xfs: fixes for the realtime allocator
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172530248247.3348968.5957783046629027826.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240902184002.GY6224@frogsfrogsfrogs>
References: <20240902184002.GY6224@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.12-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 0a59e4f3e1670bc49d60e1bd1a9b19ca156ae9cb:

xfs: push transaction join out of xfs_rtbitmap_lock and xfs_rtgroup_lock (2024-09-01 08:58:19 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/rtalloc-fixes-6.12_2024-09-02

for you to fetch changes up to df8b181f1551581e96076a653cdca43468093c0f:

xfs: simplify xfs_rtalloc_query_range (2024-09-01 08:58:19 -0700)

----------------------------------------------------------------
xfs: fixes for the realtime allocator [v4.2 4/8]

While I was reviewing how to integrate realtime allocation groups with
the rt allocator, I noticed several bugs in the existing allocation code
with regards to calculating the maximum range of rtx to scan for free
space.  This series fixes those range bugs and cleans up a few things
too.

I also added a few cleanups from Christoph.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (4):
xfs: use the recalculated transaction reservation in xfs_growfs_rt_bmblock
xfs: ensure rtx mask/shift are correct after growfs
xfs: remove xfs_rtb_to_rtxrem
xfs: simplify xfs_rtalloc_query_range

Darrick J. Wong (6):
xfs: don't return too-short extents from xfs_rtallocate_extent_block
xfs: don't scan off the end of the rt volume in xfs_rtallocate_extent_block
xfs: refactor aligning bestlen to prod
xfs: clean up xfs_rtallocate_extent_exact a bit
xfs: reduce excessive clamping of maxlen in xfs_rtallocate_extent_near
xfs: fix broken variable-sized allocation detection in xfs_rtallocate_extent_block

fs/xfs/libxfs/xfs_rtbitmap.c |  51 +++++++--------
fs/xfs/libxfs/xfs_rtbitmap.h |  21 +------
fs/xfs/libxfs/xfs_sb.c       |  12 +++-
fs/xfs/libxfs/xfs_sb.h       |   2 +
fs/xfs/xfs_discard.c         |  15 +++--
fs/xfs/xfs_fsmap.c           |  11 ++--
fs/xfs/xfs_rtalloc.c         | 145 +++++++++++++++++++++++--------------------
7 files changed, 124 insertions(+), 133 deletions(-)

