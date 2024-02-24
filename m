Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A523C39
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738419; cv=none; b=dp7V2i0hIuBMAeAhR0qdaB5iVF1/eHD6wTiOhpDJe0S4fHKGwy6LVvaHMvjvkCqbzwGrsjWozsorFllS80h4DIwHH4DL167eAUDDo+KfH8BcJ3YQ6g+Fw/d9/n77eBhbUuEm11Dw2EeySylvBR8PWYlLstSyrojbgHLWpllMhWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738419; c=relaxed/simple;
	bh=+pQkiLUxY0FVuvExNJsUHMxGtJCBVN+b0kYZ7r52YqA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=WaBGscCw5vl8WVN3E10EMwPrqH3elshJ4gIg0wifoBJYtkHNyLixmvRNb5bVAKMChyBL5CRWgcYMHdc4RTlfZZ7VD2Vv7Ckzsf7hpBaT4Guk7Mo+5mDMuxtVP7d3NRU2BYIIZWoT7JiZuKrndWmSmcu/u/BZrewCGXhPO5uek+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTrbVhSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTrbVhSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE5DC433C7;
	Sat, 24 Feb 2024 01:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738419;
	bh=+pQkiLUxY0FVuvExNJsUHMxGtJCBVN+b0kYZ7r52YqA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QTrbVhSDnvv7U/A8g501HNvcx3k7v3LihXf8o6hW8Eq1BW93S6z1k9+PrSuIk9ljw
	 0IFB4uwCnGuhjR9aYJ1uNXO0pvJj0CDiRn6CKokxPVvVnMrulg2njombnyjTKf31FU
	 p4wq/iP2lqjvNYjVp83z5MjWa3O/lOCjRlm2KA55z6rYxG7CFf/QXs9AXJdO8xCmM8
	 wOWDudgtvgiWJj+foWTtxuVeuRca4yg7veA7RvS5VxS6/+FHydd0/kRpSJtNNtC58Q
	 5QrtfHgiufr7lqzH/sVNoGGhu/ArayiB5wpiqZenk1fr6iA9Gjy373B69I/Ui2mCoT
	 WyhfIO3vsRTpA==
Date: Fri, 23 Feb 2024 17:33:38 -0800
Subject: [GIT PULL 18/18] xfs: clean up symbolic link code
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873807841.1891722.16097328572481729299.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240224010220.GN6226@frogsfrogsfrogs>
References: <20240224010220.GN6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.9-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 6c8127e93e3ac9c2cf6a13b885dd2d057b7e7d50:

xfs: xfs_bmap_finish_one should map unwritten extents properly (2024-02-22 12:45:00 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/symlink-cleanups-6.9_2024-02-23

for you to fetch changes up to b8102b61f7b8929ad8043e4574a1e26276398041:

xfs: move symlink target write function to libxfs (2024-02-22 12:52:37 -0800)

----------------------------------------------------------------
xfs: clean up symbolic link code [v29.3 18/18]

This series cleans up a few bits of the symbolic link code as needed for
future projects.  Online repair requires the ability to commit fixed
fork-based filesystem metadata such as directories, xattrs, and symbolic
links atomically, so we need to rearrange the symlink code before we
land the atomic extent swapping.

Accomplish this by moving the remote symlink target block code and
declarations to xfs_symlink_remote.[ch].

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: move xfs_symlink_remote.c declarations to xfs_symlink_remote.h
xfs: move remote symlink target read function to libxfs
xfs: move symlink target write function to libxfs

fs/xfs/libxfs/xfs_bmap.c           |   1 +
fs/xfs/libxfs/xfs_inode_fork.c     |   1 +
fs/xfs/libxfs/xfs_shared.h         |  13 ----
fs/xfs/libxfs/xfs_symlink_remote.c | 155 ++++++++++++++++++++++++++++++++++++-
fs/xfs/libxfs/xfs_symlink_remote.h |  26 +++++++
fs/xfs/scrub/inode_repair.c        |   1 +
fs/xfs/scrub/symlink.c             |   3 +-
fs/xfs/xfs_symlink.c               | 146 ++--------------------------------
fs/xfs/xfs_symlink.h               |   1 -
9 files changed, 192 insertions(+), 155 deletions(-)
create mode 100644 fs/xfs/libxfs/xfs_symlink_remote.h

