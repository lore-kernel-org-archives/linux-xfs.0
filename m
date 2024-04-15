Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D6015749D
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224027; cv=none; b=WmXvs2RVBLTUXy/ceJ63c6PDEHyvQSelStGYSStMahOO4IXKJq6qGSwNcYUeB+n9RSc8cWSLiEPtAf8CDIapCMTK6xvHb7WMbaXcYyjIkE3hx7Eo9Di/KXIHfCze0ajWS1jq6ZTuMN86gmf2aeOzsB5KDVx4oxGfDKSkJ/tQX6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224027; c=relaxed/simple;
	bh=NeKorqjM520ekFMa0IWbS69GnC2P0iwA+++xo16d22I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GIup7GpVL6jOgbX5u3sOnH/TJlsWj5ZUEqgvmQl3by+xXcHj1DmD02Ww7J+qi78GxOMByJQATuKZVW5X3P8ngfvSV4rV4QzSERBrXigTTR40yiLjRgbhq9V4WgpgZoxtqOHKVxe+XqvOgPzVt01QnGitiHOx9yq94Vnd3LcAnd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tKD6aW15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tKD6aW15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843DFC113CC;
	Mon, 15 Apr 2024 23:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224026;
	bh=NeKorqjM520ekFMa0IWbS69GnC2P0iwA+++xo16d22I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tKD6aW15zthNWTNsiHO3Otg3A1vRoVZs1eA06+j5YTdzR9X/FpfPjMkpyLLjUUjUc
	 20H5+niUrH1Fr6xrFGuWiywhYQthJ8UL9//G+8cDcEB+DtjVnfnRo/JeKwKbzJAXnK
	 xdqQq5WQ1vF5myTA0F0YV6Svupt4j1Isir9EA57lZYcXW9Y2ThY8QzoOEM5ksUuKbT
	 TBnBefXB3qj8IIwGiTWtpy9Kx0mUMBjSOHQLARxchKIjiAIi48YhLrZyaDj/zloRK/
	 C9EyKuKoCUniWAc7E+Ii52lRrLnfwv3Qc94QDxZ9b69GUYHa3wmkMqQDVKVgfrom76
	 59NsAGqcxjJLw==
Date: Mon, 15 Apr 2024 16:33:46 -0700
Subject: [PATCHSET v30.3 01/16] xfs: improve log incompat feature handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Dan Carpenter <dan.carpenter@linaro.org>, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <171322380288.86847.5430338887776337667.stgit@frogsfrogsfrogs>
In-Reply-To: <20240415232853.GE11948@frogsfrogsfrogs>
References: <20240415232853.GE11948@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This patchset improves the performance of log incompat feature bit
handling by making a few changes to how the filesystem handles them.
First, we now only clear the bits during a clean unmount to reduce calls
to the (expensive) upgrade function to once per bit per mount.  Second,
we now only allow incompat feature upgrades for sysadmins or if the
sysadmin explicitly allows it via mount option.  Currently the only log
incompat user is logged xattrs, which requires CONFIG_XFS_DEBUG=y, so
there should be no user visible impact to this change.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=log-incompat-permissions-6.10
---
Commits in this patchset:
 * xfs: pass xfs_buf lookup flags to xfs_*read_agi
 * xfs: fix an AGI lock acquisition ordering problem in xrep_dinode_findmode
 * xfs: fix potential AGI <-> ILOCK ABBA deadlock in xrep_dinode_findmode_walk_directory
 * xfs: fix error bailout in xrep_abt_build_new_trees
 * xfs: only clear log incompat flags at clean unmount
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |    3 -
 fs/xfs/libxfs/xfs_ag.c                             |    8 ++-
 fs/xfs/libxfs/xfs_ialloc.c                         |   16 ++++--
 fs/xfs/libxfs/xfs_ialloc.h                         |    5 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c                   |    4 +-
 fs/xfs/scrub/alloc_repair.c                        |    2 -
 fs/xfs/scrub/common.c                              |    4 +-
 fs/xfs/scrub/fscounters.c                          |    2 -
 fs/xfs/scrub/inode_repair.c                        |   50 ++++++++++++++++++++
 fs/xfs/scrub/iscan.c                               |   36 ++++++++++++++
 fs/xfs/scrub/iscan.h                               |   15 ++++++
 fs/xfs/scrub/repair.c                              |    6 +-
 fs/xfs/scrub/trace.h                               |   10 +++-
 fs/xfs/xfs_inode.c                                 |    8 ++-
 fs/xfs/xfs_iwalk.c                                 |    4 +-
 fs/xfs/xfs_log.c                                   |   28 -----------
 fs/xfs/xfs_log.h                                   |    2 -
 fs/xfs/xfs_log_priv.h                              |    3 -
 fs/xfs/xfs_log_recover.c                           |   19 +-------
 fs/xfs/xfs_mount.c                                 |    8 +++
 fs/xfs/xfs_mount.h                                 |    6 ++
 fs/xfs/xfs_xattr.c                                 |   42 ++---------------
 22 files changed, 160 insertions(+), 121 deletions(-)

