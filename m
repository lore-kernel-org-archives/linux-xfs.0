Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F784688
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738357; cv=none; b=ez9tUYQwEH2TmgO4zyUOtQvJpZYi8F8RpDK45HMyv7fPvLgxll9U9DHKCjdTUuKOUZpGNo/e0EBodmcJDmI/ks0H0MsUxAFZ5CR3IIHjzV2ai03gLuUKlAaVGIaH78DV7kRrar7FNeP/jzU7vbb85i/ZLzmNoRDc0hypwBGA1D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738357; c=relaxed/simple;
	bh=+ma+bDQO0E92vjWxNSNah6czrS3mDBVru8Fwu914U8M=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=X5aQv8UpJpJ6QZcsbOsqFFAmsQGHaZmuu2ChpTmZmn2a3eeY3OlKRB05Kj77WN9wrscr0qg5I2afS2m2+p/+LZAjTNLgysTenTBr6G6HieuSBHfk0758gJoma2zPaxKj6Z+hY9TQ/bBZ55Ija8Xd4wu6f3CLW/C2oZiU2+PdLRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRU7d5I0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRU7d5I0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23A4C433F1;
	Sat, 24 Feb 2024 01:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738356;
	bh=+ma+bDQO0E92vjWxNSNah6czrS3mDBVru8Fwu914U8M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LRU7d5I0fzLpSwhlbaY+wa22hyA7qP8NLOc3MQkGCsOdTwUOyiWLdmESA4BI4Sz7G
	 BKPnns75C5u2gErbwYbnVcmgTLS5JfyLy/G2rjTh5gGzI9xDoLmlbjc7Qw/lFm9lvA
	 51aErb4CIP9VNcWQseJhwzKpTX1H0rnIZYX6o0o2NtSDaOJUANPW6xMVz2PM7kcGyd
	 zkbdTKq7tFt3WoUNCMUSTofBRUsqu8Ps3z2UKR0jch/Wxp/BOw4zxCMmJBS9T/TPmD
	 Zeeuf3JaVmb8OxEHqVx4c6bYf0UEYfTcmwtXxZlNyXTrZMclcW9S49TJ0wv7B13FE4
	 /sRdPf1rDToXQ==
Date: Fri, 23 Feb 2024 17:32:36 -0800
Subject: [GIT PULL 14/18] xfs: reduce refcount repair memory usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873806024.1891722.15628825342498983385.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240224010220.GN6226@frogsfrogsfrogs>
References: <20240224010220.GN6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.9-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 7e1b84b24d257700e417bc9cd724c1efdff653d7:

xfs: hook live rmap operations during a repair operation (2024-02-22 12:43:40 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-refcount-scalability-6.9_2024-02-23

for you to fetch changes up to 7fbaab57a80f1639add1c7d02adeb9d17bd50206:

xfs: port refcount repair to the new refcount bag structure (2024-02-22 12:43:42 -0800)

----------------------------------------------------------------
xfs: reduce refcount repair memory usage [v29.3 14/18]

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
Darrick J. Wong (3):
xfs: define an in-memory btree for storing refcount bag info during repairs
xfs: create refcount bag structure for btree repairs
xfs: port refcount repair to the new refcount bag structure

fs/xfs/Makefile                |   2 +
fs/xfs/scrub/rcbag.c           | 307 ++++++++++++++++++++++++++++++++++
fs/xfs/scrub/rcbag.h           |  28 ++++
fs/xfs/scrub/rcbag_btree.c     | 370 +++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/rcbag_btree.h     |  81 +++++++++
fs/xfs/scrub/refcount.c        |  12 ++
fs/xfs/scrub/refcount_repair.c | 164 +++++++-----------
fs/xfs/scrub/repair.h          |   2 +
fs/xfs/xfs_stats.c             |   3 +-
fs/xfs/xfs_stats.h             |   1 +
fs/xfs/xfs_super.c             |  10 +-
11 files changed, 872 insertions(+), 108 deletions(-)
create mode 100644 fs/xfs/scrub/rcbag.c
create mode 100644 fs/xfs/scrub/rcbag.h
create mode 100644 fs/xfs/scrub/rcbag_btree.c
create mode 100644 fs/xfs/scrub/rcbag_btree.h

