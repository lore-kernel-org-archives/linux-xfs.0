Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A583451BB
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 13:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772024783; cv=none; b=tAwg8u+gkvVznKVEzktOXJnCvqh9Eiu1hdh8vGfA81IZhRi981sIpX520YSvSBIt1K5GZl47LNEG2W2sRnZxuq/WZLd8tafMnYJkbcvYL1CCi8gPnLhoxx0HiDZrVYXvGdkj7IWgWZtgMHOD84isO/c7QlruR72AolFQ6ORjzE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772024783; c=relaxed/simple;
	bh=/o8QofHtzlCxw/SgxJWorudQQV9iA+8N1/VPstfq2/o=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=MqRXju6cfbBNyXLfGNW/4LKXYADCvGQtrFH3Y1N0Dq0DiK+zKcW4uu3pLiyTzl8DMaXUylP2a1mfQQ/QEtaaendCeTz2c2rVbY4SXTcWbuuqpz1HiHoe1XCf/9W/r9vZ1t0SWq2iDP+S5T7cHvIt9hGXGaderdufn+UJ8F6YTQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V2FXi7PI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V2FXi7PI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC066C116D0
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 13:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772024783;
	bh=/o8QofHtzlCxw/SgxJWorudQQV9iA+8N1/VPstfq2/o=;
	h=Date:From:To:Subject:From;
	b=V2FXi7PIdxc1Mt8lxM53CYZM8my1XmQmZYEQB9l9XATxUYE1e/U6QEHsbgFiNh81f
	 u9qwfuyLUzrl5Fj9NeEMUtWaUw4Es6Syjf13Q1Xfy04xZ4CEfN2Rmq3pm9c+W38dDy
	 r8oIjVVxBQNhsoTXDvEaSIdqa6loiRFe/4mI0y1uvBm7UeDZvp+TEalumOhw4IXJEp
	 VVcfcAi0aEMZIQ6Z52szsn0+DmhQ3hDi2GRn2/wSEdq+GBHG6Y7Kp99EJZbe3deIED
	 pbjdWvut1dTBb5Uf1NJMs7eThq4W+LXX2lIQH11fJ4N/ASL17PHeZTdibhP6yh06Vt
	 aYyrq6wNU/YmA==
Date: Wed, 25 Feb 2026 14:06:19 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to 650b774cf944
Message-ID: <aZ7zA-oQqzCO-Rs2@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

My apologies for the consecutive rebase, due the previous rebase
I broke up the committer's SoB of some patches. This rebase fixes it,
no patch changes

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

650b774cf944 xfs: add static size checks for ioctl UABI

19 new commits:

Christoph Hellwig (2):
      [03a6d6c4c85d] xfs: cleanup inode counter stats
      [47553dd60b1d] xfs: remove metafile inodes from the active inode stat

Darrick J. Wong (6):
      [e764dd439d68] xfs: fix copy-paste error in previous fix
      [161456987a1f] xfs: fix xfs_group release bug in xfs_verify_report_losses
      [eb8550fb75a8] xfs: fix xfs_group release bug in xfs_dax_notify_dev_failure
      [94014a23e91a] xfs: fix potential pointer access race in xfs_healthmon_get
      [75690e5fdd74] xfs: don't report metadata inodes to fserror
      [115ea07b94d2] xfs: don't report half-built inodes to fserror

Ethan Tidmore (1):
      [cddfa648f1ab] xfs: Fix error pointer dereference

Nirjhar Roy (IBM) (7):
      [18c16f602a67] xfs: Replace ASSERT with XFS_IS_CORRUPT in xfs_rtcopy_summary()
      [a49b7ff63f98] xfs: Refactoring the nagcount and delta calculation
      [4ad85e633bc5] xfs: Replace &rtg->rtg_group with rtg_group()
      [8baa9bccc015] xfs: Fix xfs_last_rt_bmblock()
      [ac1d977096a1] xfs: Add a comment in xfs_log_sb()
      [c2368fc89a68] xfs: Update lazy counters in xfs_growfs_rt_bmblock()
      [9a654a8fa319] xfs: Add comments for usages of some macros.

Wilfred Mallawa (3):
      [fd81d3fd01a5] xfs: fix code alignment issues in xfs_ondisk.c
      [e97cbf863d89] xfs: remove duplicate static size checks
      [650b774cf944] xfs: add static size checks for ioctl UABI

Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c        | 28 +++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h        |  3 +++
 fs/xfs/libxfs/xfs_inode_buf.c |  4 ++++
 fs/xfs/libxfs/xfs_metafile.c  |  5 +++++
 fs/xfs/libxfs/xfs_ondisk.h    | 52 ++++++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_sb.c        |  3 +++
 fs/xfs/scrub/dir_repair.c     |  2 +-
 fs/xfs/scrub/orphanage.c      |  7 +++++-
 fs/xfs/xfs_fsops.c            | 17 ++------------
 fs/xfs/xfs_health.c           | 20 +++++++++++++++--
 fs/xfs/xfs_healthmon.c        | 11 +++++----
 fs/xfs/xfs_icache.c           | 18 +++++++++++----
 fs/xfs/xfs_mount.h            |  2 +-
 fs/xfs/xfs_notify_failure.c   |  4 ++--
 fs/xfs/xfs_platform.h         |  9 ++++++++
 fs/xfs/xfs_rtalloc.c          | 44 ++++++++++++++++++++++++++++++------
 fs/xfs/xfs_stats.c            | 17 +++++++++-----
 fs/xfs/xfs_stats.h            | 19 ++++++++--------
 fs/xfs/xfs_super.c            |  4 ++--
 fs/xfs/xfs_verify_media.c     |  4 ++--
 fs/xfs/xfs_zone_alloc.c       |  6 ++---
 fs/xfs/xfs_zone_gc.c          | 10 ++++-----
 22 files changed, 209 insertions(+), 80 deletions(-)
