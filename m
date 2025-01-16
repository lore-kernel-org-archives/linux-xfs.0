Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBFB19343E
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 21:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063668; cv=none; b=VYpQ5QS3KdsS3cRVs7xE4A44K+k39XC3zA8RIkPFPWLJoAvIm5FFItdahCNzy6BVWMx/a79oYfRlhyCMC/7GsgVa3WpiDXlC8L28+NLOg6mCk/aTFqCMCe8603Fb+LrpPHXFn/+NrKnKR4knc9m0PURwjKhvVssALkLYjJ0jM1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063668; c=relaxed/simple;
	bh=U1j5sbVjrXrpoN4fycJbgrtJcHnHXIreG8NgGO8q4ts=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=TWr7SsZYp6z4pQwyHUrzy1FiZVzUuWLQPo0vdD+VLXc2nowWafS3zMhHObiO76M/QiYHreMSXLWonX1d11DLPA6luNqMylNX7QI23xeT8Spuepx0+I4NX+ehzLy/DsRLpLQhNSBOXfjtDq+CsLH74S7qrc4+WmXQKCrfEvTanD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VW2ii6NF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VW2ii6NF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39922C4CED6;
	Thu, 16 Jan 2025 21:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737063668;
	bh=U1j5sbVjrXrpoN4fycJbgrtJcHnHXIreG8NgGO8q4ts=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VW2ii6NFb2a6+qp5q2sPcb80zfhGQJqdSiN2UEnSsq+wEuAQKlP4nyZ6rBGMXmr51
	 5UN4NzioGZp1ZVqnb3TGOelTuCy1INnUzPlKUipvB7x+0kKijcRbG9HM+3yd0xarAH
	 0TGe/bU9lPSoMXs5jUaDV4MxxbUy+mlNuGt6goCOuTSaktILcfaZEiAL9KGI0lISjS
	 LXkfiPBZxZzJGhMunzyGLNaYZhDiTfJOw6O7BXy+J/dR+GN0UlPViCQ0Z5rELVqac2
	 iIBKilHrrjVBcxMWO5iSKZGnT35FxoKRfCP5RdRek8rOhX75D3EYvnH4JhyY/sivd7
	 x3tN18Lklu+zA==
Date: Thu, 16 Jan 2025 13:41:07 -0800
Subject: [GIT PULL 2/2] xfs: bug fixes for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, tom.samstag@netrise.io
Message-ID: <173706333949.1823974.4224580111735154685.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250116213334.GB1611770@frogsfrogsfrogs>
References: <20250116213334.GB1611770@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 773c4c6f33cfd0a909fb742f149bd6f59cfa62b6:

xfs: don't return an error from xfs_update_last_rtgroup_size for !XFS_RT (2025-01-16 13:27:27 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/xfs-fixes-6.13_2025-01-16

for you to fetch changes up to 34738ff0ee80de73c4fd3078a89a7bef39be46b6:

mkfs: allow sizing realtime allocation groups for concurrency (2025-01-16 13:27:27 -0800)

----------------------------------------------------------------
xfs: bug fixes for 6.13 [2/2]

Bug fixes for 6.13.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (8):
xfs_db: fix multiple dblock commands
xfs_repair: don't obliterate return codes
libxfs: fix uninit variable in libxfs_alloc_file_space
xfs_db: improve error message when unknown btree type given to btheight
mkfs: fix parsing of value-less -d/-l concurrency cli option
m4: fix statx override selection if /usr/include doesn't define it
build: initialize stack variables to zero by default
mkfs: allow sizing realtime allocation groups for concurrency

configure.ac            |   1 +
db/block.c              |   4 +-
db/btheight.c           |   6 ++
include/builddefs.in    |   2 +-
libxfs/util.c           |   2 +-
m4/package_libcdev.m4   |   2 +-
m4/package_sanitizer.m4 |  14 +++++
man/man8/mkfs.xfs.8.in  |  28 ++++++++++
mkfs/xfs_mkfs.c         | 144 ++++++++++++++++++++++++++++++++++++++++++++++--
repair/quotacheck.c     |   2 +-
10 files changed, 195 insertions(+), 10 deletions(-)

