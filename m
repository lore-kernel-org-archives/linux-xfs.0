Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD4F4688
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738200; cv=none; b=aAZ97oFY/cOx03wrSNTiJ1kCIGa5G3SikBDAGEDfKFrTA5SKmX1ZSvC6Vfl/TGuaF0B/XmN8AtgGd6g4YMrmczc3a2cIeiYppwsYdqH1KnvASHR04thNy+p55DGW2QJAQv57z0uL8ZXui269IHxUfqBjYuFLh26jE6G7quu3mYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738200; c=relaxed/simple;
	bh=C3jpxJdzpFlEl9JwjsTus9fT2zx53bmYojH4CdJqYLA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=YqVFSzyUtAKFzEmYP8aRfHLpfeZtqX2nWHbeT5Ud7k3rkbma0zp3F8+ebFHfvYVEo7CPNiV1euIBvM2L5SQBpgLyHN3LCAM5bMtPdmh5riRCO5whkkFq/3AnFrKRmS3ozLST/iQDVpHkqj04NP6kxvxUe60hAGyRztPBFx5NJy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qUlDzwsB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qUlDzwsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769ACC433C7;
	Sat, 24 Feb 2024 01:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738200;
	bh=C3jpxJdzpFlEl9JwjsTus9fT2zx53bmYojH4CdJqYLA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qUlDzwsBBjgdsmjyhj8owPG9snwssDJDy0D6W4mWJW5QQ151nEJMu56i9dqFhNsrt
	 FRPg/pxWfTGy7qvniRahOkXVKyiLNLLGm/zbsALgxk8SfNk7llN5V8kv+jgEn+nCBG
	 tCqsG3kDO16ilbrwDsC4HC/pmHoipthszE3EiBp3TCA9Efvg7sDwl86PGHzHHBmcHV
	 GcyPROKoaQIVKhRxLw6sh4bSHrZjxH4W1aTsQdlYkJxU2hpWurOP59lTSsQ5kkD7yB
	 23w3UrPtTbNw09kEwwyG49jXHmFPXL4m8ZxyL+ejDdsJnkt3K66zXPwr6stx/A1ymt
	 YIg4Uf7vyMddA==
Date: Fri, 23 Feb 2024 17:29:59 -0800
Subject: [GIT PULL 4/18] xfs: report corruption to the health trackers
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873801577.1891722.17337684732117119668.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 6b631c60c90a1e5264bc9bcdca2c0adb492d7a62:

xfs: teach repair to fix file nlinks (2024-02-22 12:31:00 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/corruption-health-reports-6.9_2024-02-23

for you to fetch changes up to 989d5ec3175be7c0012d7744c667ae6a266fab06:

xfs: report XFS_IS_CORRUPT errors to the health system (2024-02-22 12:32:55 -0800)

----------------------------------------------------------------
xfs: report corruption to the health trackers [v29.3 04/18]

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

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (11):
xfs: separate the marking of sick and checked metadata
xfs: report fs corruption errors to the health tracking system
xfs: report ag header corruption errors to the health tracking system
xfs: report block map corruption errors to the health tracking system
xfs: report btree block corruption errors to the health system
xfs: report dir/attr block corruption errors to the health system
xfs: report symlink block corruption errors to the health system
xfs: report inode corruption errors to the health system
xfs: report quota block corruption errors to the health system
xfs: report realtime metadata corruption errors to the health system
xfs: report XFS_IS_CORRUPT errors to the health system

fs/xfs/libxfs/xfs_ag.c          |   5 +-
fs/xfs/libxfs/xfs_alloc.c       | 105 +++++++++++++++++++----
fs/xfs/libxfs/xfs_attr_leaf.c   |   4 +
fs/xfs/libxfs/xfs_attr_remote.c |  35 +++++---
fs/xfs/libxfs/xfs_bmap.c        | 135 +++++++++++++++++++++++++----
fs/xfs/libxfs/xfs_btree.c       |  39 ++++++++-
fs/xfs/libxfs/xfs_da_btree.c    |  37 ++++++--
fs/xfs/libxfs/xfs_dir2.c        |   5 +-
fs/xfs/libxfs/xfs_dir2_block.c  |   2 +
fs/xfs/libxfs/xfs_dir2_data.c   |   3 +
fs/xfs/libxfs/xfs_dir2_leaf.c   |   3 +
fs/xfs/libxfs/xfs_dir2_node.c   |   7 ++
fs/xfs/libxfs/xfs_health.h      |  42 ++++++++-
fs/xfs/libxfs/xfs_ialloc.c      |  57 ++++++++++--
fs/xfs/libxfs/xfs_inode_buf.c   |  12 ++-
fs/xfs/libxfs/xfs_inode_fork.c  |   8 ++
fs/xfs/libxfs/xfs_refcount.c    |  43 +++++++++-
fs/xfs/libxfs/xfs_rmap.c        |  83 ++++++++++++++++--
fs/xfs/libxfs/xfs_rtbitmap.c    |   9 +-
fs/xfs/libxfs/xfs_sb.c          |   2 +
fs/xfs/scrub/health.c           |   8 +-
fs/xfs/scrub/refcount_repair.c  |   9 +-
fs/xfs/xfs_attr_inactive.c      |   4 +
fs/xfs/xfs_attr_list.c          |  18 +++-
fs/xfs/xfs_dir2_readdir.c       |   6 +-
fs/xfs/xfs_discard.c            |   2 +
fs/xfs/xfs_dquot.c              |  30 +++++++
fs/xfs/xfs_health.c             | 186 ++++++++++++++++++++++++++++++++++++++++
fs/xfs/xfs_icache.c             |   9 ++
fs/xfs/xfs_inode.c              |  16 +++-
fs/xfs/xfs_iomap.c              |  15 +++-
fs/xfs/xfs_iwalk.c              |   5 +-
fs/xfs/xfs_qm.c                 |   8 +-
fs/xfs/xfs_reflink.c            |   6 +-
fs/xfs/xfs_rtalloc.c            |   6 ++
fs/xfs/xfs_symlink.c            |  17 ++--
fs/xfs/xfs_trace.h              |   4 +
37 files changed, 881 insertions(+), 104 deletions(-)

