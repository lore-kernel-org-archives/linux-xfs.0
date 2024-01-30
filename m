Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5181E376EA
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591009; cv=none; b=hdlchewzBHi+JtILPKik001fAu2fm3oRdtXlrhDnu7j9GrcqzBbIdFt4K+eEpd7rsa2CIX3tKC6zbSHxaMptXVG/LAwZacXDnyjNzq60gA7zx03z3tRfK4hjB+to+Wk9VMGGWiFeLHdxpLKD+NGR5D2dzt9dCNa1jGq40Vy5XhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591009; c=relaxed/simple;
	bh=AZOFfus5bhi3uGYnFyKD64l3X8rVk174QCZWnLLFWTE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=VUsvP5iFUIlYC8B7+hX182Ub+pU9i4Zi8cnsKS+M5sbFal5ogfT0KuwuWW81SHK21IgBGSdT9PIBBpQnGgt0JM+1COwGr8G7RUVdaWUap1X+Cyr7tapLJ+xinIfvGPrNXA42KOz1HSbLvZL6mc8gPRaZqOCaHrb48gu3520jgQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DR/JyDCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DR/JyDCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9593C433C7;
	Tue, 30 Jan 2024 05:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591008;
	bh=AZOFfus5bhi3uGYnFyKD64l3X8rVk174QCZWnLLFWTE=;
	h=Date:Subject:From:To:Cc:From;
	b=DR/JyDCPlpJixM3Unv+eTvk8q4f6lotLoS1s0k+v6IK09DWVNhNXKjoQ4p+7voKs1
	 +R5JOnKtVPRGtqGRH9GPj6fJGz02x41LRRoM/7cQAJLEqSbtI2tgGEWrTn9mfWLxRo
	 7Ognj/XUKlz9O8KOUfxjBtbANKoAM/nRTxOGp+r+ANmghy/oA+kRQcn/kfl14b5bKI
	 9k4Cr0b44ubitGl06JYDiKKn+Sw59Rh+hsYkg5CVx/xYQ0AutmbZXzvKoV/03HW0HM
	 se1Ivg5Z0uHG+5gFXIeNj6Gc6AmoAXoqJHKTt+ZOT/ztPed3FjWMbXu913806f4loq
	 tpwnDsT3dq+bw==
Date: Mon, 29 Jan 2024 21:03:28 -0800
Subject: [PATCHSET v29.2 5/7] xfs: report corruption to the health trackers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
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
Commits in this patchset:
 * xfs: separate the marking of sick and checked metadata
 * xfs: report fs corruption errors to the health tracking system
 * xfs: report ag header corruption errors to the health tracking system
 * xfs: report block map corruption errors to the health tracking system
 * xfs: report btree block corruption errors to the health system
 * xfs: report dir/attr block corruption errors to the health system
 * xfs: report symlink block corruption errors to the health system
 * xfs: report inode corruption errors to the health system
 * xfs: report quota block corruption errors to the health system
 * xfs: report realtime metadata corruption errors to the health system
 * xfs: report XFS_IS_CORRUPT errors to the health system
---
 fs/xfs/libxfs/xfs_ag.c          |    5 +
 fs/xfs/libxfs/xfs_alloc.c       |  105 ++++++++++++++++++++----
 fs/xfs/libxfs/xfs_attr_leaf.c   |    4 +
 fs/xfs/libxfs/xfs_attr_remote.c |   35 +++++---
 fs/xfs/libxfs/xfs_bmap.c        |  135 +++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_btree.c       |   39 ++++++++-
 fs/xfs/libxfs/xfs_da_btree.c    |   37 +++++++-
 fs/xfs/libxfs/xfs_dir2.c        |    5 +
 fs/xfs/libxfs/xfs_dir2_block.c  |    2 
 fs/xfs/libxfs/xfs_dir2_data.c   |    3 +
 fs/xfs/libxfs/xfs_dir2_leaf.c   |    3 +
 fs/xfs/libxfs/xfs_dir2_node.c   |    7 ++
 fs/xfs/libxfs/xfs_health.h      |   35 +++++++-
 fs/xfs/libxfs/xfs_ialloc.c      |   57 +++++++++++--
 fs/xfs/libxfs/xfs_inode_buf.c   |   12 ++-
 fs/xfs/libxfs/xfs_inode_fork.c  |    8 ++
 fs/xfs/libxfs/xfs_refcount.c    |   43 +++++++++-
 fs/xfs/libxfs/xfs_rmap.c        |   83 ++++++++++++++++++-
 fs/xfs/libxfs/xfs_rtbitmap.c    |    9 ++
 fs/xfs/libxfs/xfs_sb.c          |    2 
 fs/xfs/scrub/health.c           |   20 +++--
 fs/xfs/scrub/refcount_repair.c  |    9 ++
 fs/xfs/xfs_attr_inactive.c      |    4 +
 fs/xfs/xfs_attr_list.c          |   18 +++-
 fs/xfs/xfs_dir2_readdir.c       |    6 +
 fs/xfs/xfs_discard.c            |    2 
 fs/xfs/xfs_dquot.c              |   30 +++++++
 fs/xfs/xfs_health.c             |  172 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c             |    9 ++
 fs/xfs/xfs_inode.c              |   16 +++-
 fs/xfs/xfs_iomap.c              |   15 +++
 fs/xfs/xfs_iwalk.c              |    5 +
 fs/xfs/xfs_mount.c              |    5 +
 fs/xfs/xfs_qm.c                 |    8 +-
 fs/xfs/xfs_reflink.c            |    6 +
 fs/xfs/xfs_rtalloc.c            |    6 +
 fs/xfs/xfs_symlink.c            |   17 +++-
 37 files changed, 867 insertions(+), 110 deletions(-)

