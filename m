Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B7C158520;
	Thu, 16 Jan 2025 23:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069880; cv=none; b=KOBuMTDiVRrtgPPDL8+487QH4YonI1oKLuetIXZHQdCNcLHNeBfeH2Rkzo0fjYQRcM6DAutbPtnKm4uhXfX80W1JgzPTMmqAEBWal1I6qcjaAoQtwpg4gU6LQnXY8buI9B4p5xHsYa2gvurbXjD2+ZIbpjo/sLVZxmHCD59bXMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069880; c=relaxed/simple;
	bh=SwvwJZ5IW0XqsqXukegOkyoLne0JcrDetmnhjb+6wPc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L5J6Qn2EBmmKMB8+NGcQACzEddlnNam/X60wffR7K3FJfXQNivam+QKivHGWD/lDgBCeVibOshYj753c08AMaw5lvAfY99yPQljfQsQaxqUg+o1dlsyORD3SeYhoObVLAPxCnSR5i4a8a6hluURCXYp8Y3tpiz86Am14dUPut/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mvf86YZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mvf86YZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09308C4CED6;
	Thu, 16 Jan 2025 23:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737069880;
	bh=SwvwJZ5IW0XqsqXukegOkyoLne0JcrDetmnhjb+6wPc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mvf86YZO+d+NoIMf7pGVqGvS7QfS44pIW+Q5fYCT1nCmxSBC3I3SnFiwt1NNhqgqp
	 bzT1NGevqefvi3TVvALvA+YMwBV4MIUs/7ql6TCnFTbBIKvQxQkd8yCrKa2J3WifAk
	 ABbmLUwoTGzaAY3CxjaawSoT9YK2JC94xhd4pROxeNqHklbpx5H7bZcg044q5T4HqT
	 W9E7H78O3MPuD9OPgKlI6RRznwa33eviMhSCD8pa1+PyT1Lvysrau/c2o45SaqSJ2s
	 +gTbQAuUrE/4c7i/qwdrNsKHUJsEz5++hBh1JenaszcDNtCyJLacOs8Scbevm1BnwH
	 bU53YpPHrQoyA==
Date: Thu, 16 Jan 2025 15:24:39 -0800
Subject: [PATCHSET v6.2 5/7] fstests: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
In-Reply-To: <20250116232151.GH3557695@frogsfrogsfrogs>
References: <20250116232151.GH3557695@frogsfrogsfrogs>
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
 common/ext4             |   17 +++++++++
 common/fuzzy            |   84 +++++++++++++++++++++++++++++++++------------
 common/metadump         |   22 ++++++++++--
 common/populate         |   85 ++++++++++++++++++++++++++--------------------
 common/xfs              |   87 +++++++++++++++++++++++++++++++++++++++++++----
 src/punch-alternating.c |   28 +++++++++++++++
 tests/xfs/114           |    4 ++
 tests/xfs/146           |    2 +
 tests/xfs/185           |   65 +++++++++++++++++++++++++++--------
 tests/xfs/187           |    3 +-
 tests/xfs/206           |    1 +
 tests/xfs/271           |    4 ++
 tests/xfs/341           |    4 +-
 tests/xfs/449           |    6 +++
 tests/xfs/556           |   16 +++++----
 tests/xfs/581           |    9 ++++-
 tests/xfs/582           |   14 ++++----
 tests/xfs/720           |    2 +
 tests/xfs/739           |    6 +++
 tests/xfs/740           |    6 +++
 tests/xfs/741           |    6 +++
 tests/xfs/742           |    6 +++
 tests/xfs/743           |    6 +++
 tests/xfs/744           |    6 +++
 tests/xfs/745           |    6 +++
 tests/xfs/746           |    6 +++
 tests/xfs/793           |   14 ++++----
 tests/xfs/795           |    2 +
 28 files changed, 393 insertions(+), 124 deletions(-)

