Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A1884FCF
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816391; cv=none; b=FHXJp8Y+RUcA2W/OF1rTPUy5XtIDzCNQkogahJB26s1CVXfYOb6XhTqRYBDWY70lVDm8qe9/wbNlhBspKYNHJ6kWC3Od/BHrNI3eGOn+JzrRnREGB48pJuGfPszuqsk8HnmTCkWAnv+arQX7UR4KQyTyj37hKOAigckqn/zqCoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816391; c=relaxed/simple;
	bh=pUgNnHUUQzoVlzT1d6eHaU2mR4xbvMQWmuNa1BAmqdo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=umlEJLHc7NzPSlmaFtsIIaEISQ3Q7IxHc3XlCkZtvCZBjVoWPdBh2la4sgegNORUTbQCUOunMSseEuN5bTL2Kj4zsyISsHzD+yomtKKau8CObvhfxbubEEKADDH7kNTsbp8kDd+YOPmBsK1UZXJ2QfRoDdJfM6DLRQ7cLWCTxUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aKT10jND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aKT10jND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30D0C433F1;
	Thu,  1 Feb 2024 19:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816390;
	bh=pUgNnHUUQzoVlzT1d6eHaU2mR4xbvMQWmuNa1BAmqdo=;
	h=Date:Subject:From:To:Cc:From;
	b=aKT10jNDLiOUtPSb77ZbT2lsqqrGuy2qgsWd06Rp1Yhl5iEuqPrAtWRXa40ETBL0Z
	 Wtwz8Pz1ObJd+Rf/LIpFot3zc39DB4fRjcv9dCAMYHDarCxrzCfoYkl/xDxFksd2yc
	 Bqmr9lk8GtgyN0OmxklcgYkLMMjEvhn5WXFZ+Jzc7rs6eyPisC5VFccUKZ0Hx+xRjp
	 JbdowmGEVATiABviH0hQ+WVI/OvLKMcL2pDgGWrGfmmdFpAoy+eSu9vyBYhkaA2HLw
	 j1If7yPk9tCwreVE7Ph3g55vJWxvQhN/oSfw2cmHeunSdEsbFgOPX1pUcnQvk3i6lG
	 +xscpW6PIEVZw==
Date: Thu, 01 Feb 2024 11:39:50 -0800
Subject: [PATCHSET v29.2 8/8] xfs: reduce refcount repair memory usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681337865.1608752.14424093781022631293.stgit@frogsfrogsfrogs>
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

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-refcount-scalability

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-refcount-scalability
---
Commits in this patchset:
 * xfs: define an in-memory btree for storing refcount bag info during repairs
 * xfs: create refcount bag structure for btree repairs
 * xfs: port refcount repair to the new refcount bag structure
---
 fs/xfs/Makefile                |    2 
 fs/xfs/scrub/rcbag.c           |  307 +++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rcbag.h           |   28 +++
 fs/xfs/scrub/rcbag_btree.c     |  370 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rcbag_btree.h     |   81 +++++++++
 fs/xfs/scrub/refcount.c        |   12 +
 fs/xfs/scrub/refcount_repair.c |  164 ++++++------------
 fs/xfs/scrub/repair.h          |    2 
 fs/xfs/xfs_stats.c             |    3 
 fs/xfs/xfs_stats.h             |    1 
 fs/xfs/xfs_super.c             |   10 +
 11 files changed, 872 insertions(+), 108 deletions(-)
 create mode 100644 fs/xfs/scrub/rcbag.c
 create mode 100644 fs/xfs/scrub/rcbag.h
 create mode 100644 fs/xfs/scrub/rcbag_btree.c
 create mode 100644 fs/xfs/scrub/rcbag_btree.h

