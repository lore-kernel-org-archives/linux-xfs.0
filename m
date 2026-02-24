Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E87C11CBA
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 14:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771943098; cv=none; b=kFDKerwtEVvQZO67HkQi2pt1UbvEIbwuNtaJ87JAyLF849k2kRWpw5yMCVBkoapKPkVZEUWHVsvN3JhBoET2WMKx+yjrMPLYpuqCxJgveyLRxZ84lFApH7U6WDnaorgTolWlVp4eFNyg/hQAYeJs949l47GVDKuWKPbl7JA530Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771943098; c=relaxed/simple;
	bh=wHy81EcUEDCPRThJ7aV68ObBf7djf+7prQw6Stet+hs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Z4CY4w7CZExZ3XuonhDjsoXm7HnX+WGq+QcJ7Zxwmk87rk/htKa5isWh+y1N6udq3g7rGRblFhxLDRzOhaFSZluiHqzponrvzTVVmZJXj9ettSIr16raPtnIO9Icu4RJOd/c2qEz4P9bspOermNo22r57DkXP8ZfbbtjCs3XoIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7V+RnTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7V+RnTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C31C116D0
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 14:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771943098;
	bh=wHy81EcUEDCPRThJ7aV68ObBf7djf+7prQw6Stet+hs=;
	h=Date:From:To:Subject:From;
	b=i7V+RnTd/rDmZa1Y5/pILt8USQJMgKqo44PczS8V+onR8rRC7trefoJYJC+2pbxbj
	 FSyT69reszy2ICKpvScb5Ap9oEBW5O7YTTD+pyBw5UJNnnzgy1MAVCRXEqkw7YA3Mp
	 nKcNOei8/SKiSM4oXlJ8km3ISjO/RSjgD6iUovV5E+7lM3fbN/XeozNKyGQbnaBviN
	 Ode6x8NfEnbZn+DTPtCvZDoc/89QcuGdDmGtPb6+Y+FQqG47fbo+1zbwrcG+eVPCCZ
	 C+ZSLF3pna5EhKgTUsgFuxeT7NhsegSGKcZBtR4jaDLtfoC+zB0XWddMhl4ezF3AtT
	 REsEWbBXJYm7g==
Date: Tue, 24 Feb 2026 15:24:53 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: xfs-7.0-fixes *REBASED* to d7a474481777
Message-ID: <aZ2zyxF_VFV4WYyt@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The xfs-7.0-fixes branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

This rebases the currently existing patches plus newer ones
on top of 7.0-rc1.

The new head of the xfs-7.0-fixes branch is commit:

d7a474481777 xfs: add static size checks for ioctl UABI

21 new commits:

Carlos Maiolino (1):
      [4b7b9e3b5abf] Merge tag 'xfs-fixes-7.0_2026-02-23' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-7.0-fixes

Christoph Hellwig (2):
      [810e363df769] xfs: cleanup inode counter stats
      [428980f6202b] xfs: remove metafile inodes from the active inode stat

Darrick J. Wong (6):
      [34e20fb02e39] xfs: fix copy-paste error in previous fix
      [b46832816931] xfs: fix xfs_group release bug in xfs_verify_report_losses
      [bc5e571eff64] xfs: fix xfs_group release bug in xfs_dax_notify_dev_failure
      [27997bc4adc8] xfs: fix potential pointer access race in xfs_healthmon_get
      [475d26407127] xfs: don't report metadata inodes to fserror
      [0e9b4455c7a3] xfs: don't report half-built inodes to fserror

Ethan Tidmore (1):
      [98899e053df0] xfs: Fix error pointer dereference

Nirjhar Roy (IBM) (8):
      [8e1283f36fe8] xfs: Replace ASSERT with XFS_IS_CORRUPT in xfs_rtcopy_summary()
      [ae3ddfcd5937] xfs: Fix in xfs_rtalloc_query_range()
      [adc70ba6f06d] xfs: Refactoring the nagcount and delta calculation
      [b420344382a4] xfs: Replace &rtg->rtg_group with rtg_group()
      [5c230c08da92] xfs: Fix xfs_last_rt_bmblock()
      [d93c48bfe3d9] xfs: Add a comment in xfs_log_sb()
      [e37c36b26503] xfs: Update lazy counters in xfs_growfs_rt_bmblock()
      [fddf473b28fb] xfs: Add comments for usages of some macros.

Wilfred Mallawa (3):
      [dcf2e2fa66ef] xfs: fix code alignment issues in xfs_ondisk.c
      [3ab9082fcda0] xfs: remove duplicate static size checks
      [d7a474481777] xfs: add static size checks for ioctl UABI

Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c        | 28 +++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h        |  3 +++
 fs/xfs/libxfs/xfs_inode_buf.c |  4 ++++
 fs/xfs/libxfs/xfs_metafile.c  |  5 +++++
 fs/xfs/libxfs/xfs_ondisk.h    | 52 ++++++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_rtbitmap.c  |  2 +-
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
 23 files changed, 210 insertions(+), 81 deletions(-)
