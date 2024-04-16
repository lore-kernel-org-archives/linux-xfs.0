Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EBA3C0D
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227259; cv=none; b=djsDjWo0cX25GupmknCT84Kj0oOQrYE2UbUSG1Wj4aCo+vUFlv9e7Qxj6+8SzMpumZX3Hol73REW9e6U5Trnm7LTXqGWJ78mayi10rdGP6p4R8zZBmbLc7PhcMsGJCZ7/96m+6JqGFBn3Ld/nZrIZNctnK9ktun1kzcLDHCtx9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227259; c=relaxed/simple;
	bh=+4IkRBmgXD/anr7sR5dhO66CqGGMBynEVfRMzn36edc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=sboLkRdJfISznWrHIW1P+SYxLD8ZoXfgHjzzXLw/kYoLWrWXHXQSaYamms+grOSfs3U0BAGfdrvnAJXTeVvilVQg0KpD+Ei+aLnPiY0SgO9xC4dbNRCQFROG0pvpM3wyggGWbOueaetJKbdOrT5+0H/oYc8RRNCgZ2ubiRbBxOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sISZjjnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sISZjjnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F369C3277B;
	Tue, 16 Apr 2024 00:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227259;
	bh=+4IkRBmgXD/anr7sR5dhO66CqGGMBynEVfRMzn36edc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sISZjjnYeKrZBBYc61ujh8V7Q48SShCLXD21Pr9ZFpWiD1D4ZXlf/3Q/3lxfDlqHZ
	 Kkp+7zFcBOlp7KSaMpXDNLtLNdlFPsMzSTkPyCnnEYa1JaOaUJia0baJlTkCtYcbo0
	 BknOUgkFyq5hQ75+OnsXgkTXtws+UWCCiZxTwnomVYeJxJ7p9fZ5whKh77QkN67UPI
	 4iOPy/Nxh4svt1m2qcR27jjTW1yTvExQYbfEW6YyOBNYbaMhY56BHVv+0qLOddGMrH
	 ANT4fk3YfRdy5GgCfIjeJO4Z+dQjF+2RC1ybrC6cenU/GXZffX/dArXATYNfIm0Wi+
	 XIdI+VsAqbS4Q==
Date: Mon, 15 Apr 2024 17:27:38 -0700
Subject: [GIT PULL 01/16] xfs: improve log incompat feature handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: dan.carpenter@linaro.org, dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322715062.141687.8066563993145702698.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240416002427.GB11972@frogsfrogsfrogs>
References: <20240416002427.GB11972@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 0bbac3facb5d6cc0171c45c9873a2dc96bea9680:

Linux 6.9-rc4 (2024-04-14 13:38:39 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/log-incompat-permissions-6.10_2024-04-15

for you to fetch changes up to 5302a5c8beb21d01b7b8d92cc73b6871bc27d7bf:

xfs: only clear log incompat flags at clean unmount (2024-04-15 14:54:06 -0700)

----------------------------------------------------------------
xfs: improve log incompat feature handling [v30.3 01/16]

This patchset improves the performance of log incompat feature bit
handling by making a few changes to how the filesystem handles them.
First, we now only clear the bits during a clean unmount to reduce calls
to the (expensive) upgrade function to once per bit per mount.  Second,
we now only allow incompat feature upgrades for sysadmins or if the
sysadmin explicitly allows it via mount option.  Currently the only log
incompat user is logged xattrs, which requires CONFIG_XFS_DEBUG=y, so
there should be no user visible impact to this change.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs: pass xfs_buf lookup flags to xfs_*read_agi
xfs: fix an AGI lock acquisition ordering problem in xrep_dinode_findmode
xfs: fix potential AGI <-> ILOCK ABBA deadlock in xrep_dinode_findmode_walk_directory
xfs: fix error bailout in xrep_abt_build_new_trees
xfs: only clear log incompat flags at clean unmount

.../filesystems/xfs/xfs-online-fsck-design.rst     |  3 --
fs/xfs/libxfs/xfs_ag.c                             |  8 ++--
fs/xfs/libxfs/xfs_ialloc.c                         | 16 ++++---
fs/xfs/libxfs/xfs_ialloc.h                         |  5 ++-
fs/xfs/libxfs/xfs_ialloc_btree.c                   |  4 +-
fs/xfs/scrub/alloc_repair.c                        |  2 +-
fs/xfs/scrub/common.c                              |  4 +-
fs/xfs/scrub/fscounters.c                          |  2 +-
fs/xfs/scrub/inode_repair.c                        | 50 +++++++++++++++++++++-
fs/xfs/scrub/iscan.c                               | 36 +++++++++++++++-
fs/xfs/scrub/iscan.h                               | 15 +++++++
fs/xfs/scrub/repair.c                              |  6 +--
fs/xfs/scrub/trace.h                               | 10 ++++-
fs/xfs/xfs_inode.c                                 |  8 ++--
fs/xfs/xfs_iwalk.c                                 |  4 +-
fs/xfs/xfs_log.c                                   | 28 +-----------
fs/xfs/xfs_log.h                                   |  2 -
fs/xfs/xfs_log_priv.h                              |  3 --
fs/xfs/xfs_log_recover.c                           | 19 +-------
fs/xfs/xfs_mount.c                                 |  8 +++-
fs/xfs/xfs_mount.h                                 |  6 ++-
fs/xfs/xfs_xattr.c                                 | 42 +++---------------
22 files changed, 160 insertions(+), 121 deletions(-)

