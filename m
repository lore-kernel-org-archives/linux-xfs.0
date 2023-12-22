Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254A9610A
	for <linux-xfs@vger.kernel.org>; Fri, 22 Dec 2023 02:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iMgVlh7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85564C433C8;
	Fri, 22 Dec 2023 02:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703212317;
	bh=eqLeG0oqcToOEstItmyuZcWB1u+aMGnNhJxfglr3dt8=;
	h=Date:Subject:From:To:Cc:From;
	b=iMgVlh7rYTVY2NDB6ndEvO4ZQPhcKF3LnFb2MmHTwKOI/hvAwhgXMdleCtvpfd6Vw
	 pItoUwInANmcmbiCDcJh4VmRrNeC7RxjaUCdkP5zahih/o9NOzwJiHWAcwYk0CnMn/
	 lNQwbP9UczPDzqG1WqbYkhH4QCdNCMmDpMb2TvRpgx8yAWYyyGDLqCS3/ZkFF/S3vB
	 GKtvo/M/+MDbxR+zbsZeG8KYHScAt57146R9F9lQpIwPJMgch3c5g+Vl5Jwa9sYshr
	 SjbBJfirHaZOgbzazM6uBth1hWljZ1DgHMeYxOCP+nEkH0+Ao6Ku7sXpCov9M3hwLC
	 C8rCSCOJtO6yQ==
Date: Thu, 21 Dec 2023 18:31:57 -0800
Subject: [GIT PULL 4/4] xfsprogs: force rebuilding of metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170321220884.2974519.2153107272415565146.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 9de9b74046527423dfd4a5140e86d74af69ee895:

xfs_io: support passing the FORCE_REBUILD flag to online repair (2023-12-21 18:29:14 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/repair-force-rebuild-6.6_2023-12-21

for you to fetch changes up to c2371fdd0ffeecb407969ad3e4e1d55f26e26407:

xfs_scrub: try to use XFS_SCRUB_IFLAG_FORCE_REBUILD (2023-12-21 18:29:14 -0800)

----------------------------------------------------------------
xfsprogs: force rebuilding of metadata [v28.3 4/8]

This patchset adds a new IFLAG to the scrub ioctl so that userspace can
force a rebuild of an otherwise consistent piece of metadata.  This will
eventually enable the use of online repair to relocate metadata during a
filesystem reorganization (e.g. shrink).  For now, it facilitates stress
testing of online repair without needing the debugging knobs to be
enabled.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs_scrub: handle spurious wakeups in scan_fs_tree
xfs_scrub: don't retry unsupported optimizations
xfs_scrub: try to use XFS_SCRUB_IFLAG_FORCE_REBUILD

scrub/phase1.c    | 28 +++++++++++++++++++++++++
scrub/scrub.c     | 61 +++++++++++++++++++++++++++++--------------------------
scrub/scrub.h     |  1 +
scrub/vfs.c       |  2 +-
scrub/xfs_scrub.c |  3 +++
scrub/xfs_scrub.h |  1 +
6 files changed, 66 insertions(+), 30 deletions(-)

