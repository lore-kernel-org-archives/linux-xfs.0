Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793972757;
	b=5tknAPbvVQUErnFIKNRl0Nyw8HOh3Bfjdt/xalrf0PwINFNCxfXpMa0XEwSmNbrMfcPC
	 P2rIeBvBOmyiFetAKDPoQUbPJ3txBFHv8lF91/jx4LyDeZdKqo8It76OdctNAmuF6rYzg
	 6eoiF0ZfY3bccFzvzrD6cz9Q8s2WLL+aovkTK8+uCwWZk6duUGn3HJ2At6vDP3PoFwZDX
	 5A5TixhcAhG/YCeJO+zciwLhdM01Q+zgtJDQ4w5FpMipGrmXDjhzS46exkChWBwlEFSVc
	 unkOhgmdceYigMPxeZhCZjlQ+FE19OfOkJ72mS0Bj2SaVwz38YSyUA/MKJq2sXTgzpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793972757;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=PuaN9jhvvuR8lC6kF8K/oPWaEn3N0J0i+m7ihv5jIxM=;
	b=1XWvUhMp1lCXwka6QswiActskjhBSK98qTeCjTXYd0GWQ+uwly6tKWe5N81xbvv2iDfD
	 mWOhHk+nmF1SBGbOErNm/B3s41R+6E7hAetCbrgq88805LxH/eTtwk8NP39Q3jGTAz2h4
	 Tcv5R1YFdlSDw4o3LNkaOqU905qqYld4cEi97E7J/PS+WCdaQbK9p+Gc3nVx6PjSSy3R7
	 /kK2GJbzXUYUusw+qYs3TiLb6Ph9Qj8eSaDL8uiQ8sSOPkP4n3EZ3DC8ozTMPWdTH/+oB
	 vHXd05Wg/E6R3ioe2sjjigsl4XI/GdCGNPkTbHJYd/CSRzaVylRzFsgsIxFr3gkLQ8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IOQiLLiY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44416082BCB
	for <linux-xfs@vger.kernel.org>; Fri,  6 Nov 2026 13:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IOQiLLiY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935AB1F008A3;
	Fri,  6 Nov 2026 13:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793972756;
	bh=PuaN9jhvvuR8lC6kF8K/oPWaEn3N0J0i+m7ihv5jIxM=;
	h=Date:From:To:Cc:Subject;
	b=IOQiLLiYeMtamK8t7Je0cupJINMrbsVnuFpmeNtXBDg1AXr4+yjwFDfgtKJmvSOG+
	 AVbGvSuUteeWg4WF3RI9ECYTeNARTEn/Z0tTCnN+wipNPuasneEqJJdUy7Co6hVjaY
	 JR1L9bhd2+A9bpGdqstw6nWmRwDrsb5y82bQ4X2R6iOrM+eYEaZ3z8VK0buqqAi8+T
	 Ozvhjtmh/b3SRIFQqDO+qnYX80UysICAZtkgPf0Ob3TlkfP0aT9U/9Xi74Pj6XcIWc
	 EfE13EssRvdPnqBFKvwWkMz5D5ZioDyykOWpdQz/KkwveByF2d2bCwnZvOsC1bz+eG
	 3HjCWSItUF2Ug==
Date: Fri, 6 Nov 2026 14:45:52 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.4-rc2
Message-ID: <au3QTc4bZbvePBT2@nidhogg.toxiclabs.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT has been successful.

The most notable fix here IMO is for xfs's pNFS support (mostly related
to LAYOUTCOMMIT) and for that it contains several patches. Besides that,
the PR contain bug fixes for different subsystems in xfs. The last patch
in this PR is mostly a refactor than a bug fix, but the refactor is done
to prevent a nasty journal transaction state corruption to happen.

Thanks,
Carlos

"The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  git://git.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.4-rc2

for you to fetch changes up to 7ba9663607b31108b4350b604a3c85ae86c67c19:

  xfs: kill xfs_trans_set/clear_context() helpers (2026-11-03 15:39:53 +0100)

----------------------------------------------------------------
xfs: fixes for v7.4-rc2

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Anthony Iliopoulos (1):
      xfs: skip iunlock with empty iolock flags in xfs_file_dio_write_aligned

Binbin Deng (1):
      xfs: set healthmon mount cookie before publishing it

Christoph Hellwig (1):
      xfs: fix recovery of partial attr removals

Daejun Park (11):
      xfs: don't skip free extents in later batches of a whole-AG FITRIM
      xfs: don't skip free extents of the longest length in a whole-AG FITRIM
      xfs: mark the inode preallocated for pNFS write layouts past EOF
      xfs: add a flag to convert unwritten extents without allocating blocks
      xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks
      xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
      xfs: cap the block count of xfs_iomap_write_direct() at one extent
      xfs: clamp the pNFS layout range to the maximum file size
      xfs: take the invalidate lock while mapping a pNFS layout
      xfs: add datasync and log_flushed arguments to xfs_log_force_inode()
      xfs: make pNFS LAYOUTCOMMIT stable the way fdatasync does

Jianyun Gao (1):
      xfs: fix temporary cursor leak in btree shift corruption paths

Kefeng Wang (1):
      xfs: kill xfs_trans_set/clear_context() helpers

Ravi Singh (1):
      xfs: mark i_mode=0 and shut down on attr fork inactivation failure

Reid Downing (1):
      xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()

Wilfred Mallawa (1):
      xfs: fix unwind handling during xfs_mount_sysfs_init()

 fs/xfs/libxfs/xfs_attr_leaf.c |  9 ++++-
 fs/xfs/libxfs/xfs_bmap.c      | 14 ++++++--
 fs/xfs/libxfs/xfs_bmap.h      | 10 +++++-
 fs/xfs/libxfs/xfs_btree.c     |  8 ++---
 fs/xfs/libxfs/xfs_trans.h     | 14 --------
 fs/xfs/xfs_discard.c          | 26 +++++++++-----
 fs/xfs/xfs_export.c           |  2 +-
 fs/xfs/xfs_file.c             | 55 ++++-------------------------
 fs/xfs/xfs_healthmon.c        |  2 +-
 fs/xfs/xfs_inode.c            | 47 ++++++++++++++++++++++---
 fs/xfs/xfs_inode.h            |  3 +-
 fs/xfs/xfs_ioctl32.c          |  4 +--
 fs/xfs/xfs_ioend.c            |  2 +-
 fs/xfs/xfs_iomap.c            | 28 +++++++++++++--
 fs/xfs/xfs_iomap.h            |  3 +-
 fs/xfs/xfs_pnfs.c             | 82 ++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_sysfs.c            |  2 +-
 fs/xfs/xfs_trans.c            | 10 ++++--
 fs/xfs/xfs_zone_gc.c          |  2 +-
 19 files changed, 198 insertions(+), 125 deletions(-)"
