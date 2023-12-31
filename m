Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE23B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LdTiq1NU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3B0C433C7;
	Sun, 31 Dec 2023 19:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051723;
	bh=LQQX2X4WNc1fXo6GiKhIpwXzqIYg8PzAi22gMZwxcHI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LdTiq1NUok+NWH89szwn3J5ZizMuHwIeAAVJa1uj8yuQ/v5RyvGKI/E/LpR+3gg71
	 Pb3ifzOVqXtPoQR980i0Me7g0sOs0UFZg4XCGErgAXvxUDLZ6zzsak4+4SJMttbmK5
	 0Xqn22+ccBtL1GpCJIwCMxSYT5QPJiZ38YUR+SVvS//95hRhlWyy4xnMQ8ZKG38t3H
	 Bu8iLGX7jMapqPoMyKmUhPJcPMMeAHQEfaUcqRZizrmPpNNv/gVUqNt9d0HGJlSx4c
	 2YGFX1B2E5Kk2b2/u97yWq0VPRQPLxTtH36PJ1dhrli9UucMMBLnSmnuOFXKpb698C
	 7Nh8VxUgZgzGg==
Date: Sun, 31 Dec 2023 11:42:02 -0800
Subject: [PATCHSET v29.0 09/40] xfsprogs: report corruption to the health
 trackers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404991943.1794070.7853125417143732405.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

Any time that the runtime code thinks it has found corrupt metadata, it
should tell the health tracking subsystem that the corresponding part of
the filesystem is sick.  These reports come primarily from two places --
code that is reading a buffer that fails validation, and higher level
pieces that observe a conflict involving multiple buffers.  This
patchset uses automated scanning to update all such callsites with a
mark_sick call.

Doing this enables the health system to record problem observed at
runtime, which (for now) can prompt the sysadmin to run xfs_scrub, and
(later) may enable more targetted fixing of the filesystem.

Note: Earlier reviewers of this patchset suggested that the verifier
functions themselves should be responsible for calling _mark_sick.  In a
higher level language this would be easily accomplished with lambda
functions and closures.  For the kernel, however, we'd have to create
the necessary closures by hand, pass them to the buf_read calls, and
then implement necessary state tracking to detach the xfs_buf from the
closure at the necessary time.  This is far too much work and complexity
and will not be pursued further.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=corruption-health-reports

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=corruption-health-reports

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=corruption-health-reports
---
 libxfs/util.c            |   10 +++
 libxfs/xfs_ag.c          |    5 +-
 libxfs/xfs_alloc.c       |  105 ++++++++++++++++++++++++++++++------
 libxfs/xfs_attr_leaf.c   |    4 +
 libxfs/xfs_attr_remote.c |   35 +++++++-----
 libxfs/xfs_bmap.c        |  135 +++++++++++++++++++++++++++++++++++++++++-----
 libxfs/xfs_btree.c       |   39 ++++++++++++-
 libxfs/xfs_da_btree.c    |   37 +++++++++++--
 libxfs/xfs_dir2.c        |    5 +-
 libxfs/xfs_dir2_block.c  |    2 +
 libxfs/xfs_dir2_data.c   |    3 +
 libxfs/xfs_dir2_leaf.c   |    3 +
 libxfs/xfs_dir2_node.c   |    7 ++
 libxfs/xfs_health.h      |   35 +++++++++++-
 libxfs/xfs_ialloc.c      |   57 ++++++++++++++++---
 libxfs/xfs_inode_buf.c   |   12 +++-
 libxfs/xfs_inode_fork.c  |    8 +++
 libxfs/xfs_refcount.c    |   43 ++++++++++++++-
 libxfs/xfs_rmap.c        |   83 +++++++++++++++++++++++++++-
 libxfs/xfs_rtbitmap.c    |    9 +++
 libxfs/xfs_sb.c          |    2 +
 21 files changed, 559 insertions(+), 80 deletions(-)

