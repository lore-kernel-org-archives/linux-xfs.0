Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346C513AF2;
	Thu, 20 Feb 2025 22:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740089201; cv=none; b=UA/XTqLkEyPO0WklPtju4EUlmc0mgr+JENntHRR7DXG+YdqMWIvbX1kBEW7D74sK8ukj6StlEex+sANSn8jVLWt9mO6gLW8MnNzQE/sz83odlHq/wRXfDeUXv6itaYsV2eoah1mZ5ueCrgnqGJohcaw74ao42KZRq7LW6HwEo1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740089201; c=relaxed/simple;
	bh=m41NLmn/EiNQh6Zz4eov0nx4VbvLAbh546WJiFBRmQ4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=DhpvD9UKVHrTMheopCN/PUB6vhLVeEGggKytryKFqQkfvjKVheoWB1dAj92yfO09K6XlIlJ9AEGyj7msAFRJztVzEhqt6CL2ZBFQwAzGxzVpD11s9nxxw0hbnGGlCNfJvdFUSgQar2NcNZY4cCgi7nTT4YlisB7/dEtZhfkjjgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+99lOFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+99lOFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091FAC4CED6;
	Thu, 20 Feb 2025 22:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740089201;
	bh=m41NLmn/EiNQh6Zz4eov0nx4VbvLAbh546WJiFBRmQ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g+99lOFefsF/THqt0sqOdb2tubqGKuYMhm8nbsdV/lB9m5AnMwsU6zzIm0vIWgcDQ
	 i7HdDUE0FzIPNeUZPKCuMu0v4bzNPOEdWXohhDYK+V3cyC8b+VxQX2+2dtriGDTlM9
	 xsGcw976qfuFXHvktkD1iO0r7q0qXkDkrApuuc39rKq0/59LmDKo6CfwctGTMGoGaB
	 TsrJdfcoSVl701mVmN/7+9q9bjfOpe0ITUrGKTZUODi6pPjiyDs5OZjylONksRlqw3
	 ImNmg9Ss5prbx3jdgbBsVsmzqL5C3GVpAfQDGFw8qhcCCimz0zJ7BKu3iq02FgJjCg
	 c3agwKgvkU4RA==
Date: Thu, 20 Feb 2025 14:06:40 -0800
Subject: [GIT PULL 10/10] fstests: reflink on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174008902261.1712746.314103647857932575.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit b18c215bfdbfae74b29f427b6cf6695a9f4b2dc6:

fuzzy: create missing fuzz tests for rt rmap btrees (2025-02-20 13:52:21 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git tags/realtime-reflink_2025-02-20

for you to fetch changes up to b5c6d3f2e83d023f1dc102b76c5685b180949f88:

common/xfs: fix _xfs_get_file_block_size when rtinherit is set and no rt section (2025-02-20 13:52:21 -0800)

----------------------------------------------------------------
fstests: reflink on the realtime device [v6.5 10/22]

This patchset enables use of the file data block sharing feature (i.e.
reflink) on the realtime device.  It follows the same basic sequence as
the realtime rmap series -- first a few cleanups; then widening of the
API parameters; and introduction of the new btree format and inode fork
format.  Next comes enabling CoW and remapping for the rt device; new
scrub, repair, and health reporting code; and at the end we implement
some code to lengthen write requests so that rt extents are always CoWed
fully.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (7):
common/populate: create realtime refcount btree
xfs: create fuzz tests for the realtime refcount btree
xfs/27[24]: adapt for checking files on the realtime volume
xfs: race fsstress with realtime refcount btree scrub and repair
xfs: remove xfs/131 now that we allow reflink on realtime volumes
generic/331,xfs/240: support files that skip delayed allocation
common/xfs: fix _xfs_get_file_block_size when rtinherit is set and no rt section

common/populate       | 26 ++++++++++++++++++---
common/xfs            | 15 +++++++++++++
tests/generic/331     | 13 +++++++++--
tests/generic/331.out |  2 +-
tests/xfs/131         | 46 --------------------------------------
tests/xfs/131.out     |  5 -----
tests/xfs/1538        | 38 +++++++++++++++++++++++++++++++
tests/xfs/1538.out    |  4 ++++
tests/xfs/1539        | 38 +++++++++++++++++++++++++++++++
tests/xfs/1539.out    |  4 ++++
tests/xfs/1540        | 38 +++++++++++++++++++++++++++++++
tests/xfs/1540.out    |  4 ++++
tests/xfs/1541        | 39 ++++++++++++++++++++++++++++++++
tests/xfs/1541.out    |  4 ++++
tests/xfs/1542        | 38 +++++++++++++++++++++++++++++++
tests/xfs/1542.out    |  4 ++++
tests/xfs/1543        | 37 ++++++++++++++++++++++++++++++
tests/xfs/1543.out    |  4 ++++
tests/xfs/1544        | 37 ++++++++++++++++++++++++++++++
tests/xfs/1544.out    |  4 ++++
tests/xfs/1545        | 38 +++++++++++++++++++++++++++++++
tests/xfs/1545.out    |  4 ++++
tests/xfs/1818        | 40 +++++++++++++++++++++++++++++++++
tests/xfs/1818.out    |  2 ++
tests/xfs/1819        | 40 +++++++++++++++++++++++++++++++++
tests/xfs/1819.out    |  2 ++
tests/xfs/1893        |  2 +-
tests/xfs/240         | 12 ++++++++--
tests/xfs/240.out     |  2 +-
tests/xfs/272         | 40 ++++++++++++++++++++++-----------
tests/xfs/274         | 62 +++++++++++++++++++++++++++++++++++----------------
31 files changed, 551 insertions(+), 93 deletions(-)
delete mode 100755 tests/xfs/131
delete mode 100644 tests/xfs/131.out
create mode 100755 tests/xfs/1538
create mode 100644 tests/xfs/1538.out
create mode 100755 tests/xfs/1539
create mode 100644 tests/xfs/1539.out
create mode 100755 tests/xfs/1540
create mode 100644 tests/xfs/1540.out
create mode 100755 tests/xfs/1541
create mode 100644 tests/xfs/1541.out
create mode 100755 tests/xfs/1542
create mode 100644 tests/xfs/1542.out
create mode 100755 tests/xfs/1543
create mode 100644 tests/xfs/1543.out
create mode 100755 tests/xfs/1544
create mode 100644 tests/xfs/1544.out
create mode 100755 tests/xfs/1545
create mode 100644 tests/xfs/1545.out
create mode 100755 tests/xfs/1818
create mode 100644 tests/xfs/1818.out
create mode 100755 tests/xfs/1819
create mode 100644 tests/xfs/1819.out

