Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB4E25757;
	Wed, 19 Feb 2025 00:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926045; cv=none; b=bILe+JNzWwrjOX7Md+gPX8sbahYISSqSrbEfZAkLqHCSWPxij9k8QP5L3n4kBa+f3qFaUAb4LMY2fxtz+6hKpEUNnXDHPKG4SJrTPHwWIUQ0Pl5a6Etv78EMJGqtls+kxx6XsVWzgO4RjnLdgqQRYP+wNHyW2R/cTV2Fz6YBJlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926045; c=relaxed/simple;
	bh=IV6ghAzcv7S6ueMAA+pPUjGzvEyBuWPBJOL8xtyyUbc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qh0XlJKop+jGdHfTvK+odi72tYaKkPBMoZMyo3Pxq2VeoeB0wTzSzfpeFVsj1JC85Dmt4Oaxb4ilMILOYml+6Zh2ps9OrVvQlxq3rqVCD4i6CgUMfGJYzu+9Jire8L9UrvhSbpF5k8ntX8635sbRCvm+D8PuTPNNyi3+3t+oqpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fK9B2yce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fK9B2yce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8DEC4CEE2;
	Wed, 19 Feb 2025 00:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926045;
	bh=IV6ghAzcv7S6ueMAA+pPUjGzvEyBuWPBJOL8xtyyUbc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fK9B2ycelhbZy/pDM2NEyZk12eL8YCsA/vMMPETS6egCQX1Mt7TMUmL9//xkbtxHg
	 ns/frC2OR01iQpJZ9SPHxRR4YPiFLYnJaJOUNTRObrYw/hI2jFmXbcr4QgIgAc/Mom
	 6O0KUVuv8Ial0HqlmyJJ72Uuqir4+7YXD+1GNhtApGmFvlEfEuUyI7S/tQt803G+8U
	 jqC0BobOtthZSshgDeTE1MVz9juRTtrZqtggEu8FPsx2Uw3wTV/C73p/cRyDrjkxM4
	 ZbeELami+FbjTqFMzzcGTp75/7+ZmTI5IjPHLppCfJmyOUxH4YCHeik3DPNa1XfqSW
	 Bx5ADcdqKtEEg==
Date: Tue, 18 Feb 2025 16:47:25 -0800
Subject: [PATCHSET v6.4 06/12] fstests: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
In-Reply-To: <20250219004353.GM21799@frogsfrogsfrogs>
References: <20250219004353.GM21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

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

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-groups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-groups

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-groups

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-groups
---
Commits in this patchset:
 * common/populate: refactor caching of metadumps to a helper
 * common/{fuzzy,populate}: use _scratch_xfs_mdrestore
 * fuzzy: stress data and rt sections of xfs filesystems equally
 * fuzzy: run fsx on data and rt sections of xfs filesystems equally
 * common/ext4: reformat external logs during mdrestore operations
 * common/populate: use metadump v2 format by default for fs metadata snapshots
 * punch-alternating: detect xfs realtime files with large allocation units
 * xfs/206: update mkfs filtering for rt groups feature
 * common: pass the realtime device to xfs_db when possible
 * xfs/185: update for rtgroups
 * xfs/449: update test to know about xfs_db -R
 * xfs/271,xfs/556: fix tests to deal with rtgroups output in bmap/fsmap commands
 * common/xfs: capture realtime devices during metadump/mdrestore
 * common/fuzzy: adapt the scrub stress tests to support rtgroups
 * xfs: fix fuzz tests of rtgroups bitmap and summary files
---
 common/ext4             |   17 +++++-
 common/fuzzy            |  138 ++++++++++++++++++++++++++++++++++++-----------
 common/metadump         |   22 ++++++-
 common/populate         |   85 +++++++++++++++++------------
 common/xfs              |   87 +++++++++++++++++++++++++++---
 src/punch-alternating.c |   28 +++++++++-
 tests/xfs/114           |    4 +
 tests/xfs/146           |    2 -
 tests/xfs/185           |   65 +++++++++++++++++-----
 tests/xfs/187           |    3 +
 tests/xfs/206           |    1 
 tests/xfs/271           |    4 +
 tests/xfs/341           |    4 +
 tests/xfs/449           |    6 ++
 tests/xfs/556           |   16 +++--
 tests/xfs/581           |    9 +++
 tests/xfs/582           |   14 ++---
 tests/xfs/720           |    2 -
 tests/xfs/739           |    6 ++
 tests/xfs/740           |    6 ++
 tests/xfs/741           |    6 ++
 tests/xfs/742           |    6 ++
 tests/xfs/743           |    6 ++
 tests/xfs/744           |    6 ++
 tests/xfs/745           |    6 ++
 tests/xfs/746           |    6 ++
 tests/xfs/793           |   14 ++---
 tests/xfs/795           |    2 -
 28 files changed, 436 insertions(+), 135 deletions(-)

