Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F8F1F9A95;
	Thu, 20 Feb 2025 22:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740089091; cv=none; b=YjJiJtPDOgD+khftX79IDDqhRBANpL+zgtiA3pwM1p42xO0lrimcbYW/plkyaVWpLwXwomci1YNbBz/TQzksbhdoyi+rATiNXTWmmHGKoOohKtkE1+QS3RvcaCVu5cYTVeVI5l8WdAYwlzRlMEk+smWmwv+ybaLVwNFaf4nnqJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740089091; c=relaxed/simple;
	bh=xBozQgykpJho3bIHkPbmFD5K5X0pMp/D94w6ZOSI7Po=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=TmplI6cAJgwjuv9HduQ/TNZ2/DOoCaK0jAmU51GypG1/n3tVi5E2fcY2gvL1hsp7wMDIx4KDEVJcHYo/tgSJl/4/5jIcWAsfRwHXImX0YDPneoeljEEtZuvBIn78aVQ/qNf/EPf5nfRPJM+8pgEycyIqHc0VA/w/KAsv9e7KCr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zs6GoFz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zs6GoFz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900F7C4CED1;
	Thu, 20 Feb 2025 22:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740089091;
	bh=xBozQgykpJho3bIHkPbmFD5K5X0pMp/D94w6ZOSI7Po=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Zs6GoFz50rGhk/sED88McXuUHQYlL9IJ8AwlXIa6kihJZ8QIfibRaCOTYepHmUT+N
	 nE9WsdNKcsL8B2aEAMI7D8FOYWjds7fyA+rrvKo8xES5JXuFhcotZSbu8fWawQWklR
	 Fg2+W45hMshb1aiEBJORY9Evmj3GIodX1e7vnbdYBRbBUxjnMmO8RIx/S04QadC+uI
	 H94LbwLRmfDteWudZlF9WwzBwEhG3Z9oiqgdXRInM+BHegHmZ08CS8npyzJHEG6cuV
	 Buwol345MZ6dXppNNWjtGMyt3+Es5A8ga8zc0hRo0ZJxoR9hkiWs0a5Ue7PNFq1jEv
	 OzHM+/qEZ9rZg==
Date: Thu, 20 Feb 2025 14:04:51 -0800
Subject: [GIT PULL 03/10] fstests: enable metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174008901631.1712746.3692641690159137537.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 84b69f0072563cbfe23f02bd462f092339976c8a:

xfs/349: reclassify this test as not dangerous (2025-02-20 13:52:17 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git tags/metadir_2025-02-20

for you to fetch changes up to 4ddd7a7083e4517a20b933d1eac306527a5e0019:

xfs: test metapath repairs (2025-02-20 13:52:18 -0800)

----------------------------------------------------------------
fstests: enable metadir [v6.5 03/22]

Adjust fstests as needed to support the XFS metadata directory feature,
and add some new tests for online fsck and fuzz testing of the ondisk
metadata.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (12):
various: fix finding metadata inode numbers when metadir is enabled
xfs/{030,033,178}: forcibly disable metadata directory trees
common/repair: patch up repair sb inode value complaints
xfs/206: update for metadata directory support
xfs/{050,144,153,299,330}: update quota reports to handle metadir trees
xfs/509: adjust inumbers accounting for metadata directories
xfs: create fuzz tests for metadata directories
xfs/163: bigger fs for metadir
xfs/122: disable this test for any codebase that knows about metadir
common/populate: label newly created xfs filesystems
scrub: race metapath online fsck with fsstress
xfs: test metapath repairs

common/filter      |   7 +++-
common/populate    |   8 ++++
common/repair      |   4 ++
common/xfs         | 100 +++++++++++++++++++++++++++++++++++++++++++-
tests/xfs/007      |  16 +++----
tests/xfs/030      |   1 +
tests/xfs/033      |   1 +
tests/xfs/050      |   5 +++
tests/xfs/122      |   6 +++
tests/xfs/153      |   5 +++
tests/xfs/1546     |  34 +++++++++++++++
tests/xfs/1546.out |   4 ++
tests/xfs/1547     |  34 +++++++++++++++
tests/xfs/1547.out |   4 ++
tests/xfs/1548     |  34 +++++++++++++++
tests/xfs/1548.out |   4 ++
tests/xfs/1549     |  35 ++++++++++++++++
tests/xfs/1549.out |   4 ++
tests/xfs/1550     |  34 +++++++++++++++
tests/xfs/1550.out |   4 ++
tests/xfs/1551     |  34 +++++++++++++++
tests/xfs/1551.out |   4 ++
tests/xfs/1552     |  34 +++++++++++++++
tests/xfs/1552.out |   4 ++
tests/xfs/1553     |  35 ++++++++++++++++
tests/xfs/1553.out |   4 ++
tests/xfs/163      |   2 +-
tests/xfs/178      |   1 +
tests/xfs/1874     | 119 +++++++++++++++++++++++++++++++++++++++++++++++++++++
tests/xfs/1874.out |  19 +++++++++
tests/xfs/1892     |  66 +++++++++++++++++++++++++++++
tests/xfs/1892.out |   2 +
tests/xfs/1893     |  67 ++++++++++++++++++++++++++++++
tests/xfs/1893.out |   2 +
tests/xfs/206      |   1 +
tests/xfs/299      |   1 +
tests/xfs/330      |   6 ++-
tests/xfs/509      |  23 ++++++++++-
tests/xfs/529      |   5 +--
tests/xfs/530      |   6 +--
tests/xfs/739      |   9 +---
tests/xfs/740      |   9 +---
tests/xfs/741      |   9 +---
tests/xfs/742      |   9 +---
tests/xfs/743      |   9 +---
tests/xfs/744      |   9 +---
tests/xfs/745      |   9 +---
tests/xfs/746      |   9 +---
48 files changed, 773 insertions(+), 78 deletions(-)
create mode 100755 tests/xfs/1546
create mode 100644 tests/xfs/1546.out
create mode 100755 tests/xfs/1547
create mode 100644 tests/xfs/1547.out
create mode 100755 tests/xfs/1548
create mode 100644 tests/xfs/1548.out
create mode 100755 tests/xfs/1549
create mode 100644 tests/xfs/1549.out
create mode 100755 tests/xfs/1550
create mode 100644 tests/xfs/1550.out
create mode 100755 tests/xfs/1551
create mode 100644 tests/xfs/1551.out
create mode 100755 tests/xfs/1552
create mode 100644 tests/xfs/1552.out
create mode 100755 tests/xfs/1553
create mode 100644 tests/xfs/1553.out
create mode 100755 tests/xfs/1874
create mode 100644 tests/xfs/1874.out
create mode 100755 tests/xfs/1892
create mode 100644 tests/xfs/1892.out
create mode 100755 tests/xfs/1893
create mode 100644 tests/xfs/1893.out

