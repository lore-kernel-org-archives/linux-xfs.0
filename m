Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB0D33D5
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738326; cv=none; b=m9tTLS3wmbtExoOkLnZrlppwbnnwteDt0f6jImPnFOIC7pEIGqaAhyUnd26FutkTjJN9cdjQqyGd7TBZVXlOj+DBbAk62hqQQ8oYUyyjsQSKKXZcBERARbciQF3S4uTZNzYoeBcqadZThFz3hTm1dy7+7f6+5bPV8xM/wU8102o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738326; c=relaxed/simple;
	bh=6678nJzm9H/zU2bvB48AQIFZf4Lz07TwYQOOJf1LyeA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=aGousxadq71tlfh8IsMQbEaX3hYnmf4BLJwwdR7u5I06POfLaGzE50ngoSvnDu3vmFb+mMvb7yOSd/DUtMKAUpt79+ZYcbQFpiuzEMdhhPPqZPJH+dRzus3XsAdnQZIA4fnefsbUUJQ6t56ctcQ2KuHtkeYjmqNB3QkShXtagwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vd7++OJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vd7++OJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE97C433C7;
	Sat, 24 Feb 2024 01:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738325;
	bh=6678nJzm9H/zU2bvB48AQIFZf4Lz07TwYQOOJf1LyeA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vd7++OJP9de6NQTQElOkr9n+znHEOVC4fYnDCi/V/gBlplVhJKBe9LBDaxi28x6rU
	 b6FF5Crmuc/srv3d1P+v8lovgzS1HxkTBu5UquO4UE/ax9KvugVznTSJSs8rKNaSvO
	 tUOfwC0aXZJnKLi673yihaRXZSfV16NkC57lDptCpzciPPQ3GuAoFEOASicqYU7OQ3
	 bnPN3YXi3V4fTDGNJuQ2bxkd6g6ejrlHqoO8ZM4dNOvRiY9J0wruxo2zTKrbSSnH+Z
	 OkmL3+U7KWCXAJ9Ijr8Wn4td0mFktwWuZebrxqWgMjFRpNv/PDb/RBwU1P5LErI+Aa
	 HFzTu4ODI6byw==
Date: Fri, 23 Feb 2024 17:32:05 -0800
Subject: [GIT PULL 12/18] xfs: support in-memory btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170873805154.1891722.14629140541264696458.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 1c51ac0998ed9baaca3ac75c0083b4c3b4d993ef:

xfs: move setting bt_logical_sectorsize out of xfs_setsize_buftarg (2024-02-22 12:42:45 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/in-memory-btrees-6.9_2024-02-23

for you to fetch changes up to 0dc63c8a1ce39c1ac7da536ee9174cdc714afae2:

xfs: launder in-memory btree buffers before transaction commit (2024-02-22 12:43:36 -0800)

----------------------------------------------------------------
xfs: support in-memory btrees [v29.3 12/18]

Online repair of the reverse-mapping btrees presens some unique
challenges.  To construct a new reverse mapping btree, we must scan the
entire filesystem, but we cannot afford to quiesce the entire filesystem
for the potentially lengthy scan.

For rmap btrees, therefore, we relax our requirements of totally atomic
repairs.  Instead, repairs will scan all inodes, construct a new reverse
mapping dataset, format a new btree, and commit it before anyone trips
over the corruption.  This is exactly the same strategy as was used in
the quotacheck and nlink scanners.

Unfortunately, the xfarray cannot perform key-based lookups and is
therefore unsuitable for supporting live updates.  Luckily, we already a
data structure that maintains an indexed rmap recordset -- the existing
rmap btree code!  Hence we port the existing btree and buffer target
code to be able to create a btree using the xfile we developed earlier.
Live hooks keep the in-memory btree up to date for any resources that
have already been scanned.

This approach is not maximally memory efficient, but we can use the same
rmap code that we do everywhere else, which provides improved stability
without growing the code base even more.  Note that in-memory btree
blocks are always page sized.

This patchset modifies the kernel xfs buffer cache to be capable of
using a xfile (aka a shmem file) as a backing device.  It then augments
the btree code to support creating btree cursors with buffers that come
from a buftarg other than the data device (namely an xfile-backed
buftarg).  For the userspace xfs buffer cache, we instead use a memfd or
an O_TMPFILE file as a backing device.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (1):
xfs: add a xfs_btree_ptrs_equal helper

Darrick J. Wong (4):
xfs: teach buftargs to maintain their own buffer hashtable
xfs: support in-memory buffer cache targets
xfs: support in-memory btrees
xfs: launder in-memory btree buffers before transaction commit

.../filesystems/xfs/xfs-online-fsck-design.rst     |   5 +-
fs/xfs/Kconfig                                     |   8 +
fs/xfs/Makefile                                    |   2 +
fs/xfs/libxfs/xfs_ag.c                             |   6 +-
fs/xfs/libxfs/xfs_ag.h                             |   4 +-
fs/xfs/libxfs/xfs_btree.c                          | 286 ++++++++++++++---
fs/xfs/libxfs/xfs_btree.h                          |   7 +
fs/xfs/libxfs/xfs_btree_mem.c                      | 347 +++++++++++++++++++++
fs/xfs/libxfs/xfs_btree_mem.h                      |  75 +++++
fs/xfs/scrub/scrub.c                               |   5 +
fs/xfs/scrub/scrub.h                               |   3 +
fs/xfs/xfs_buf.c                                   | 214 ++++++++-----
fs/xfs/xfs_buf.h                                   |  17 +
fs/xfs/xfs_buf_mem.c                               | 270 ++++++++++++++++
fs/xfs/xfs_buf_mem.h                               |  34 ++
fs/xfs/xfs_health.c                                |   3 +
fs/xfs/xfs_mount.h                                 |   3 -
fs/xfs/xfs_trace.c                                 |   2 +
fs/xfs/xfs_trace.h                                 | 167 +++++++++-
fs/xfs/xfs_trans.h                                 |   1 +
fs/xfs/xfs_trans_buf.c                             |  42 +++
21 files changed, 1363 insertions(+), 138 deletions(-)
create mode 100644 fs/xfs/libxfs/xfs_btree_mem.c
create mode 100644 fs/xfs/libxfs/xfs_btree_mem.h
create mode 100644 fs/xfs/xfs_buf_mem.c
create mode 100644 fs/xfs/xfs_buf_mem.h

