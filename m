Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBC31EEA56;
	Thu, 20 Feb 2025 22:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740089123; cv=none; b=gZp0ROfke1Xi4uaB8S5/MWDry86dH0J89WdU2WhYqmuQ2Kq3baTY7IDAHV5XnQfyuJkbXoes2KBF6gYcFK3UgrLCLSrsibrtHDsP0D7llYDyPEKvIBhECFvBBcwXMUrsZFNOu7zZCqJqjzpeD+2Pdqih64PlpKo5hW4JcYVYiSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740089123; c=relaxed/simple;
	bh=Wh5qldGX/Nz7Iw7hAGTTdNSmXEJp1J1/97E1S+GwCrQ=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=r+6N7/YNlaHiZdLEFozGHHPFKmW9ixzuimljkxbOfM+o5IyzPXjdAUWYhlR42Cxd4tD5j6O6aOJf+sDuPz0aA8cyZrZefa2lL9E+RbWje+gypPAr6sEybjZVJ1+hta1ey7ZF1JBhnxU9YPWCvjHBfgas/le9v8wZHpePj//vIkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m5DWDN9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m5DWDN9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E78C4CED1;
	Thu, 20 Feb 2025 22:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740089122;
	bh=Wh5qldGX/Nz7Iw7hAGTTdNSmXEJp1J1/97E1S+GwCrQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m5DWDN9pzmCI/5V3wrVpqOjqDIcrqTz1dx9dMATcuJ8049GNKkoQxwXS//Zd74CAo
	 D/VZQ2o/cSYcoW4h3rWRSqyhqCNqJf6xnYLTjI0dvcrPToBuXLeKk7cmNsbigCBhmp
	 Whkq4Km2GF6KccHWz8YT+dje/f6SsStwgJIOMHGdCGcj/dENbQrZ3By+7QXCDBkJ6M
	 RnfWJbNsPvf2MpFZcBw/N2aDLgdcEvMPFdqSKsg1QXOeeb8iYtq94Cl7jJvDxz+pb3
	 uWp1jZtK0aGGOIDHqY2j/4Ul/Iyy/NgwNQQHIUlyDJIHDIbFTYjDmqbn/zs5uTzQeF
	 YNBx6zJRwysWA==
Date: Thu, 20 Feb 2025 14:05:22 -0800
Subject: [GIT PULL 05/10] fstests: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174008901793.1712746.16151411627153146701.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250220220245.GW21799@frogsfrogsfrogs>
References: <20250220220245.GW21799@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Zorro,

Please pull this branch with changes for fstests.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 915630e294582b91658e300b2302129d77f36504:

fstests: test mkfs.xfs protofiles with xattr support (2025-02-20 13:52:18 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git tags/realtime-groups_2025-02-20

for you to fetch changes up to 153e2550b7bf4b0ebb3c6d0e1757a6709858a0b0:

xfs: fix fuzz tests of rtgroups bitmap and summary files (2025-02-20 13:52:19 -0800)

----------------------------------------------------------------
fstests: shard the realtime section [v6.5 05/22]

Right now, the realtime section uses a single pair of metadata inodes to
store the free space information.  This presents a scalability problem
since every thread trying to allocate or free rt extents have to lock
these files.  It would be very useful if we could begin to tackle these
problems by sharding the realtime section, so create the notion of
realtime groups, which are similar to allocation groups on the data
section.

While we're at it, define a superblock to be stamped into the start of
each rt section.  This enables utilities such as blkid to identify block
devices containing realtime sections, and helpfully avoids the situation
where a file extent can cross an rtgroup boundary.

The best advantage for rtgroups will become evident later when we get to
adding rmap and reflink to the realtime volume, since the geometry
constraints are the same for rt groups and AGs.  Hence we can reuse all
that code directly.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (15):
common/populate: refactor caching of metadumps to a helper
common/{fuzzy,populate}: use _scratch_xfs_mdrestore
fuzzy: stress data and rt sections of xfs filesystems equally
fuzzy: run fsx on data and rt sections of xfs filesystems equally
common/ext4: reformat external logs during mdrestore operations
common/populate: use metadump v2 format by default for fs metadata snapshots
punch-alternating: detect xfs realtime files with large allocation units
xfs/206: update mkfs filtering for rt groups feature
common: pass the realtime device to xfs_db when possible
xfs/185: update for rtgroups
xfs/449: update test to know about xfs_db -R
xfs/271,xfs/556: fix tests to deal with rtgroups output in bmap/fsmap commands
common/xfs: capture realtime devices during metadump/mdrestore
common/fuzzy: adapt the scrub stress tests to support rtgroups
xfs: fix fuzz tests of rtgroups bitmap and summary files

common/ext4             |  17 +++++-
common/fuzzy            | 138 ++++++++++++++++++++++++++++++++++++------------
common/metadump         |  22 ++++++--
common/populate         |  85 ++++++++++++++++-------------
common/xfs              |  87 +++++++++++++++++++++++++++---
src/punch-alternating.c |  28 +++++++++-
tests/xfs/114           |   4 ++
tests/xfs/146           |   2 +-
tests/xfs/185           |  65 +++++++++++++++++------
tests/xfs/187           |   3 +-
tests/xfs/206           |   1 +
tests/xfs/271           |   4 +-
tests/xfs/341           |   4 +-
tests/xfs/449           |   6 ++-
tests/xfs/556           |  16 +++---
tests/xfs/581           |   9 +++-
tests/xfs/582           |  14 ++---
tests/xfs/720           |   2 +-
tests/xfs/739           |   6 ++-
tests/xfs/740           |   6 ++-
tests/xfs/741           |   6 ++-
tests/xfs/742           |   6 ++-
tests/xfs/743           |   6 ++-
tests/xfs/744           |   6 ++-
tests/xfs/745           |   6 ++-
tests/xfs/746           |   6 ++-
tests/xfs/793           |  14 ++---
tests/xfs/795           |   2 +-
28 files changed, 436 insertions(+), 135 deletions(-)

