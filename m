Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D802C027F
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 11:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772018060; cv=none; b=o/WDrGs0ZYu1vh4tKP0wqB+S4teLicR8vt/K0zz0FhOtg/HY5laXjw9UZ+cpT0Ofz32xOjSjm6yYAfkFq8W+WgzloBZqIilsmmvw9IOjbrDMOxX+ZHD50P0rlkit+F8W6Rl2ou72b8a8o5lKr8JqQ42+1TQNQu3ZqC5jMBBEK8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772018060; c=relaxed/simple;
	bh=w9eUkvidI12B19rmyfVeDVOCjL/QkENx1dNCqYg4FyQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KT+Cr27UlGGDVrhBDlA4EmtEgXBEB4Sw2ACbq+jHFfIJrpIHF6d9MAiPC/vZpb9uFkrrsRVezY1Qry0kNCa6C729yGzNk37gI8sFU8/2e2s1d7wJx2Ue3w5xKzEbvHMfl3D6qJ6EcJJ7gLsjFiU4mSMBG6t/ZxnQuafRQtLJenQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aplb3MrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aplb3MrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885A6C116D0
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 11:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772018060;
	bh=w9eUkvidI12B19rmyfVeDVOCjL/QkENx1dNCqYg4FyQ=;
	h=Date:From:To:Subject:From;
	b=aplb3MrNcei1fLPGR/rlBQNEQriFc24F2oDbX4tq2UbJKqihYI4CoQIwkC/+nna2m
	 mPuWY26XeqClMbuXwYeNALNeY2W9j+UMV3T6i8tOqyTwOi4OJIyGPCQW1h10WuXft3
	 p3fXHEJ5XFTkgUBjP/NyEyE//ZFMoGz4HDnGS1f8PrS+LosBwvy3OqMDMJjfYuEAYb
	 JVLQv+wVceA/JJ5fh+sPtR4ChKnrxK3nMsJfX+0neXas3sdp8O0MC83h8ZX29VKsMG
	 MkyKff1j8YkO6Fsh7pM5INI49dvyAzECcnQNPAR4BKplC1l6lP/Beoljmt+IjcB/yv
	 UawMDI3/bCkbg==
Date: Wed, 25 Feb 2026 12:14:16 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to df026203678b
Message-ID: <aZ7ZM5fa2g6b0Wtq@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

This removes one patch that caused a regression during testing. There
are no new patches in this rebase.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

df026203678b xfs: add static size checks for ioctl UABI

19 new commits:

Christoph Hellwig (2):
      [dcb932c368fd] xfs: cleanup inode counter stats
      [33637f84617c] xfs: remove metafile inodes from the active inode stat

Darrick J. Wong (6):
      [9ee0cb71de74] xfs: fix copy-paste error in previous fix
      [61a02d38303f] xfs: fix xfs_group release bug in xfs_verify_report_losses
      [fd992a409aef] xfs: fix xfs_group release bug in xfs_dax_notify_dev_failure
      [253b1a2ac9db] xfs: fix potential pointer access race in xfs_healthmon_get
      [d33f104ea40e] xfs: don't report metadata inodes to fserror
      [d412c65646d3] xfs: don't report half-built inodes to fserror

Ethan Tidmore (1):
      [caf8f7681e45] xfs: Fix error pointer dereference

Nirjhar Roy (IBM) (7):
      [8e1283f36fe8] xfs: Replace ASSERT with XFS_IS_CORRUPT in xfs_rtcopy_summary()
      [c49424d4e319] xfs: Refactoring the nagcount and delta calculation
      [7f636729386b] xfs: Replace &rtg->rtg_group with rtg_group()
      [69a082676e2e] xfs: Fix xfs_last_rt_bmblock()
      [9508b8b360b5] xfs: Add a comment in xfs_log_sb()
      [e1577fe5b485] xfs: Update lazy counters in xfs_growfs_rt_bmblock()
      [a5748007de0f] xfs: Add comments for usages of some macros.

Wilfred Mallawa (3):
      [08f4ae901d8d] xfs: fix code alignment issues in xfs_ondisk.c
      [66c98b0469bf] xfs: remove duplicate static size checks
      [df026203678b] xfs: add static size checks for ioctl UABI

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
