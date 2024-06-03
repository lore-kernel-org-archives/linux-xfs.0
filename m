Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09FD20ED
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717444610; cv=none; b=UYtcb9jq1J4hMAdYvsBYnTJhZeFblXR6rzlFXIQvnZYOyJQzEDykgf26ejG8eG3DxeTOEWtGn5J5vHCxGf3FQzIlJvDRjBvY+hdMRXJAA3KQgIxo71T8+UwXJMAk5sHJLgylhbLtjlHGDtlFjcudpeHx0sQt2FDZ7WJbA76L6HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717444610; c=relaxed/simple;
	bh=WXcG7Xyw13IqlF4XL5I+qh+bPjTaek/o2x8Mp6GaaxY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=h4YBi+T1bM6M/t45FPQ9OTvtCVRGwtTCPvecKaIqhNQ/P3BVqhwstbhOKlNTOEpSQBkr0BWsiSfpN6mewBdndJmHjsDO2xjQ+XjON7wm0bB8UEcEqMWKEP/bMhZmGWNLAy9hEd5ihdkHokoj6oHxPiE7TyRqGJLDaHM7C1fpkoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sCmeWDqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sCmeWDqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783B6C2BD10;
	Mon,  3 Jun 2024 19:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717444609;
	bh=WXcG7Xyw13IqlF4XL5I+qh+bPjTaek/o2x8Mp6GaaxY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sCmeWDqTtnegWBTcmZg/sJ37H1au4mDUYyTPC6mhSzkSMsc5tIj/iyvGK63s5SLZ3
	 VwbH1xoSQJVTdB1V+RXs/nMRSLBAeinglUEi++ytSv72YgSSQDgyEpyTmn9+P5UohR
	 y0xekzj7nspPSbLcloLQvF1/29DOfIecSLnQLkqBS5nI/fSzhBC0M1SrrNjms8c+bZ
	 P5cLsMuM87y1/G/6AuGnozDg9id9jH48W4g87ZrWPHAqiN32NwwZhknvdLMbiHmGn9
	 stX8UJbMJoOuWHDWHRMrW8LGzGOCmbfGEoIupqFAMFPuNBF1lFAG7B4aVTx0GMaPMN
	 PPWjzw1ZGI8SA==
Date: Mon, 03 Jun 2024 12:56:49 -0700
Subject: [GIT PULL 09/10] xfs_repair: reduce refcount repair memory usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171744444180.1510943.16257439427997548126.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240603195305.GE52987@frogsfrogsfrogs>
References: <20240603195305.GE52987@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 47307ecef44599b2caf0546c7e518b544e14d9c8:

xfs_repair: remove the old rmap collection slabs (2024-06-03 11:37:42 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/repair-refcount-scalability-6.9_2024-06-03

for you to fetch changes up to 9a51e91a017bf285ea5fd5c5a6a7534e2ca56587:

xfs_repair: remove the old bag implementation (2024-06-03 11:37:42 -0700)

----------------------------------------------------------------
xfs_repair: reduce refcount repair memory usage [v30.5 09/35]

The refcountbt repair code has serious memory usage problems when the
block sharing factor of the filesystem is very high.  This can happen if
a deduplication tool has been run against the filesystem, or if the fs
stores reflinked VM images that have been aging for a long time.

Recall that the original reference counting algorithm walks the reverse
mapping records of the filesystem to generate reference counts.  For any
given block in the AG, the rmap bag structure contains the all rmap
records that cover that block; the refcount is the size of that bag.

For online repair, the bag doesn't need the owner, offset, or state flag
information, so it discards those.  This halves the record size, but the
bag structure still stores one excerpted record for each reverse
mapping.  If the sharing count is high, this will use a LOT of memory
storing redundant records.  In the extreme case, 100k mappings to the
same piece of space will consume 100k*16 bytes = 1.6M of memory.

For offline repair, the bag stores the owner values so that we know
which inodes need to be marked as being reflink inodes.  If a
deduplication tool has been run and there are many blocks within a file
pointing to the same physical space, this will stll use a lot of memory
to store redundant records.

The solution to this problem is to deduplicate the bag records when
possible by adding a reference count to the bag record, and changing the
bag add function to detect an existing record to bump the refcount.  In
the above example, the 100k mappings will now use 24 bytes of memory.
These lookups can be done efficiently with a btree, so we create a new
refcount bag btree type (inside of online repair).  This is why we
refactored the btree code in the previous patchset.

The btree conversion also dramatically reduces the runtime of the
refcount generation algorithm, because the code to delete all bag
records that end at a given agblock now only has to delete one record
instead of (using the example above) 100k records.  As an added benefit,
record deletion now gives back the unused xfile space, which it did not
do previously.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs_repair: define an in-memory btree for storing refcount bag info
xfs_repair: create refcount bag
xfs_repair: port to the new refcount bag structure
xfs_repair: remove the old bag implementation

libxfs/libxfs_api_defs.h |   9 ++
repair/Makefile          |   4 +
repair/rcbag.c           | 371 ++++++++++++++++++++++++++++++++++++++++++++
repair/rcbag.h           |  32 ++++
repair/rcbag_btree.c     | 390 +++++++++++++++++++++++++++++++++++++++++++++++
repair/rcbag_btree.h     |  77 ++++++++++
repair/rmap.c            | 157 ++++++-------------
repair/slab.c            | 130 ----------------
repair/slab.h            |  19 ---
repair/xfs_repair.c      |   6 +
10 files changed, 934 insertions(+), 261 deletions(-)
create mode 100644 repair/rcbag.c
create mode 100644 repair/rcbag.h
create mode 100644 repair/rcbag_btree.c
create mode 100644 repair/rcbag_btree.h

