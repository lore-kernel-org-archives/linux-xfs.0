Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBDB13FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995881; cv=none; b=S3XjwOqV9mjcJtYdaXPis7m3lwoPfYfJSEYWZKO7qJpmxDgYiGocvmvuGKjB4NXWS8dr2uiOHptIf+WEedKDXYH795TQ7FX3AXPwAiMIovon1C1iL1dFLx8ahhaBy30EdkTBedPIRw0BDvQ9/6B9ekW3Cb6R6L+MUgeufx6VFCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995881; c=relaxed/simple;
	bh=ChjQ6Rs93Ss6unlj3ktZUL93JsDBJXOFNPGf20RqMA8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=DwwrId669LQsrziwkQHtN75Uj2opSDLHzRXnO8fIqf/zJXnh5e1IMlP92bwus4uGgdGph+RU5oX4nGwXMGvrfsVm1YZMYJwmZ4GPQYZYdwpy8R6JcqdOETZCsXVDMuZpPy9xwZR9oQUxCbpjfVLcUleMD9jWWHpC5kjFPrcWen0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AChWrYhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AChWrYhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53BFC4CED3;
	Mon, 23 Dec 2024 23:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995881;
	bh=ChjQ6Rs93Ss6unlj3ktZUL93JsDBJXOFNPGf20RqMA8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AChWrYhzLq9X6fHJivmAFBeTBSlYibJQMmhnJYM6UT6PyqC2Ii1g2ebLrDB1LufVJ
	 r8pfUXb+lxttVLaFXYoANnnpkDfRi1mPlXn9Gzk1rYZXm7mmMut75jSpsaRQb2RM7o
	 MT7YFVCxknbRbCb0zUA3PDZiZEa+eStZ0gWXIL4dfXF7joWqbuxNMrUjmWAC+46KEX
	 dfg2C8pG3rxpfSn1ODmey2wSJTzOmef969wd1XDsVLFrwqboNu44RoilgqVi8SMGbk
	 TMrAGQG9jps/gp5wENdqbcyXyqhr3tH6QQcEa1abwI79YJYgt7dumNJfAMavyZpVne
	 XFKi0HV7vDhTQ==
Date: Mon, 23 Dec 2024 15:18:00 -0800
Subject: [GIT PULL 2/5] xfs: refactor btrees to support records in inode root
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499428759.2382820.11756798556084282447.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241223224906.GS6174@frogsfrogsfrogs>
References: <20241223224906.GS6174@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 1aacd3fac248902ea1f7607f2d12b93929a4833b:

xfs: release the dquot buf outside of qli_lock (2024-12-23 13:06:01 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/btree-ifork-records_2024-12-23

for you to fetch changes up to 2f63b20b7a26c9a7c76ea5a6565ca38cd9e31282:

xfs: support storing records in the inode core root (2024-12-23 13:06:03 -0800)

----------------------------------------------------------------
xfs: refactor btrees to support records in inode root [v6.2 02/14]

Amend the btree code to support storing btree rcords in the inode root,
because the current bmbt code does not support this.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (8):
xfs: tidy up xfs_iroot_realloc
xfs: refactor the inode fork memory allocation functions
xfs: make xfs_iroot_realloc take the new numrecs instead of deltas
xfs: make xfs_iroot_realloc a bmap btree function
xfs: tidy up xfs_bmap_broot_realloc a bit
xfs: hoist the node iroot update code out of xfs_btree_new_iroot
xfs: hoist the node iroot update code out of xfs_btree_kill_iroot
xfs: support storing records in the inode core root

fs/xfs/libxfs/xfs_bmap.c          |   7 +-
fs/xfs/libxfs/xfs_bmap_btree.c    | 111 +++++++++++++
fs/xfs/libxfs/xfs_bmap_btree.h    |   3 +
fs/xfs/libxfs/xfs_btree.c         | 333 ++++++++++++++++++++++++++++----------
fs/xfs/libxfs/xfs_btree.h         |  18 ++-
fs/xfs/libxfs/xfs_btree_staging.c |   9 +-
fs/xfs/libxfs/xfs_inode_fork.c    | 170 ++++++-------------
fs/xfs/libxfs/xfs_inode_fork.h    |   6 +-
8 files changed, 445 insertions(+), 212 deletions(-)

