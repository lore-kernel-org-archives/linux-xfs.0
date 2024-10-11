Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CA67E1;
	Fri, 11 Oct 2024 00:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607046; cv=none; b=gHx/CVcYbbNwEaNTAiX2vS5ws3IBQfxf7Si6d1rBN5UjzncTyV15JM3rOqFPFp9ep5LwFN8yjsMKcCSug/phmDzL46JcDXLEIE1H8EgypQ0waQr0SUDj26IAghspB5FtC134lOLhqvDiZUyaQ56EXNZA7+AKk9eTkRYPwyJn78Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607046; c=relaxed/simple;
	bh=iLBw2hpIamlT02T+wnWVN9ETTeUDhelv8hfZg9soVEo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=djL51QffhSaExJYgZXF/gPYPK37ntrb3T1DHuOFP+MwhEYLbOV4585/gUiQBYEadPEC1hNIeS9W2m1N335rqx8Bu9Og0sOzcqF/M2XlW9/1MGksshdKLPMf+BsiFoNZB4pO3KODhWQGlthtxkzNFObthgO+zXDTzYc7IYKuIlZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LNH+CZHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LNH+CZHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44ABC4CEC5;
	Fri, 11 Oct 2024 00:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607046;
	bh=iLBw2hpIamlT02T+wnWVN9ETTeUDhelv8hfZg9soVEo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LNH+CZHLBzxCfiPswuY7lDi6uImohEjy1K1G5gR/uAP5Br1H1dETIURrz2B3Tn3lR
	 mpQkE1kkUK7FTBLiuKx9hDAN/Bg6C99N597oYHbw3Wl5TciuJLJpl/zas29y4k4pU8
	 Ctl1NpiZ0e1pUw+0oac/WVO3cUZCX5WlFdzgIOkSpJW/ewoDIKI5RAfGKO+dhN65pp
	 zL2Y2hnoIpZgdPx1Mdv/XEVR5COqs+k12x3EyNg8p6W9+iQXwNrCZweQsxyGkEnRNF
	 eJAoMm0JfX1oZL/8QiwuJtVyNU7i6vzHWnY/jNcFhvsJ0Eqs3bUz0Ct3Vtly2erC+k
	 LC49TOe8VE2sw==
Date: Thu, 10 Oct 2024 17:37:25 -0700
Subject: [PATCHSET v5.0 2/3] xfsprogs: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
In-Reply-To: <20241011002402.GB21877@frogsfrogsfrogs>
References: <20241011002402.GB21877@frogsfrogsfrogs>
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
 * common/ext4: reformat external logs during mdrestore operations
 * common/populate: use metadump v2 format by default for fs metadata snapshots
 * xfs/122: update for rtgroups
 * punch-alternating: detect xfs realtime files with large allocation units
 * xfs/206: update mkfs filtering for rt groups feature
 * common: pass the realtime device to xfs_db when possible
 * xfs/185: update for rtgroups
 * xfs/449: update test to know about xfs_db -R
 * xfs/122: update for rtbitmap headers
 * xfs/271,xfs/556: fix tests to deal with rtgroups output in bmap/fsmap commands
 * common/xfs: capture realtime devices during metadump/mdrestore
 * common/fuzzy: adapt the scrub stress tests to support rtgroups
 * xfs: fix fuzz tests of rtgroups bitmap and summary files
---
 common/ext4             |   17 ++++++++
 common/fuzzy            |   95 ++++++++++++++++++++++++++++++++++++-----------
 common/metadump         |   21 ++++++++--
 common/populate         |   85 ++++++++++++++++++++++++------------------
 common/xfs              |   87 +++++++++++++++++++++++++++++++++++++++----
 src/punch-alternating.c |   28 +++++++++++++-
 tests/xfs/114           |    4 ++
 tests/xfs/122.out       |    8 +++-
 tests/xfs/146           |    2 -
 tests/xfs/185           |   65 +++++++++++++++++++++++++-------
 tests/xfs/187           |    3 +
 tests/xfs/206           |    1 
 tests/xfs/271           |    4 +-
 tests/xfs/341           |    4 +-
 tests/xfs/449           |    6 ++-
 tests/xfs/556           |   16 +++++---
 tests/xfs/581           |    9 ++++
 tests/xfs/582           |   14 +++----
 tests/xfs/720           |    2 -
 tests/xfs/739           |    6 ++-
 tests/xfs/740           |    6 ++-
 tests/xfs/741           |    6 ++-
 tests/xfs/742           |    6 ++-
 tests/xfs/743           |    6 ++-
 tests/xfs/744           |    6 ++-
 tests/xfs/745           |    6 ++-
 tests/xfs/746           |    6 ++-
 tests/xfs/793           |   14 +++----
 tests/xfs/795           |    2 -
 29 files changed, 409 insertions(+), 126 deletions(-)

