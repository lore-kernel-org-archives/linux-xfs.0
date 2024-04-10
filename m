Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D4637C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712709879; cv=none; b=PdYw/k6tUXrviisBa4VkfooXsti/dtGKALdGGzH3Y9VJRaazZwP7XYUd378OAihw/Lwhiy5CLbTjSljWWHfGGLpWK+8JZzkXQ9jU7dWw2S42qayHXK5ccfnzxqwcKxozdebal1XoQ4Zlim17IxYFxiNN8zgV5NoVI0SJEEPJKi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712709879; c=relaxed/simple;
	bh=/Fr6OTquSTqKlU+v81+NeXOYBhlVZAe16yID00nruxc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DO5S6OSjuv8aWfEW79XvX/+B0lNcLgPi8CYx4WoZc1TljwMb2pUjlZhLjg67rGIdGD2zQrnERgg9nxvud28Iiymra/U+go2KVcrBqi2/vFyOqAUTYaNl1xRVGNLVCFEF3FzVApFwPLhfaiJzcDdAhDfY6vYquMN80zqa0zANUC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XiAkBEEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XiAkBEEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FB5C433C7;
	Wed, 10 Apr 2024 00:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712709879;
	bh=/Fr6OTquSTqKlU+v81+NeXOYBhlVZAe16yID00nruxc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XiAkBEEiWryUQchJk5vusDZM3i7FkRiA3HQCrzJl/87ub/+0qHykK1Fn9iPSvjon9
	 TBhRccAIcRMegaXeexK0N8xQgg1h/Tm/JqJy3qwkaUd7zJppareiuA641ZkbgeCKzu
	 K6cMcbQi4YpvjMUCH5EydQpcaEjK0PUrEmy2RsHD6ODcAGsXq31pZi9MeOHJwCG9i1
	 XgRS6t8VN2IPMj7C2ppAA/JVqz+CyUela3zBZms2a+dlNnyo7Z+EA0YaT6RLaf17ks
	 +mSQ05jXkTUvHa3bLoeIt7ZLjoRe9s3a1G7inWVQOaMChvncF4P448N62fWGJvVtwS
	 7hA2gODI3CF6w==
Date: Tue, 09 Apr 2024 17:44:38 -0700
Subject: [PATCHSET v13.1 2/9] xfs: retain ILOCK during directory updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Catherine Hoang <catherine.hoang@oracle.com>,
 Allison Henderson <allison.henderson@oracle.com>, catherine.hoang@oracle.com,
 hch@lst.de, allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
In-Reply-To: <20240410003646.GS6390@frogsfrogsfrogs>
References: <20240410003646.GS6390@frogsfrogsfrogs>
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

This series changes the directory update code to retain the ILOCK on all
files involved in a rename until the end of the operation.  The upcoming
parent pointers patchset applies parent pointers in a separate chained
update from the actual directory update, which is why it is now
necessary to keep the ILOCK instead of dropping it after the first
transaction in the chain.

As a side effect, we no longer need to hold the IOLOCK during an rmapbt
scan of inodes to serialize the scan with ongoing directory updates.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=retain-ilock-during-dir-ops

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=retain-ilock-during-dir-ops
---
Commits in this patchset:
 * xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
 * xfs: Increase XFS_QM_TRANS_MAXDQS to 5
 * xfs: Hold inode locks in xfs_ialloc
 * xfs: Hold inode locks in xfs_trans_alloc_dir
 * xfs: Hold inode locks in xfs_rename
 * xfs: don't pick up IOLOCK during rmapbt repair scan
 * xfs: unlock new repair tempfiles after creation
---
 fs/xfs/libxfs/xfs_defer.c  |    6 ++-
 fs/xfs/libxfs/xfs_defer.h  |    8 +++-
 fs/xfs/scrub/rmap_repair.c |   16 -------
 fs/xfs/scrub/tempfile.c    |    2 +
 fs/xfs/xfs_dquot.c         |   41 ++++++++++++++++++
 fs/xfs/xfs_dquot.h         |    1 
 fs/xfs/xfs_inode.c         |   98 ++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_inode.h         |    2 +
 fs/xfs/xfs_qm.c            |    4 +-
 fs/xfs/xfs_qm.h            |    2 -
 fs/xfs/xfs_symlink.c       |    6 ++-
 fs/xfs/xfs_trans.c         |    9 +++-
 fs/xfs/xfs_trans_dquot.c   |   15 ++++---
 13 files changed, 156 insertions(+), 54 deletions(-)

