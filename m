Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D014F9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440661; cv=none; b=nBfqmLaIhCXQHpk96udAptKTdGlmEhlaFpTBIBotF3RSGzCtfsut1snzkKs7ZmyUGOV8zGgtRDa0CxmzUY8O/bfPUwZBW6M+fpMNVHl2ydGNlhvk+HJkJN8NpEHpTISzZjJfEM0SaZgU1vAuASQU3LPFZvl8Ek8XeZLtjc9AGIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440661; c=relaxed/simple;
	bh=JLxAAe3wi+MtCemo1NZKmwbQpdREA9zf57aO/8VIjqI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kRhcxFmjy2KZmUuD2FjPql7OyeH5OSw5sRICxk6lF3bZ44FNcd8xfQRyVPB6qxAC5g5Woz0/SZ3J2Y+lfJYppql8s12I+GKOvcmlDZKOzQGk1NdKO/yO+a28fovg5EnelRrz7zq1omMHmqdPVsPOHfa9lDlW4Brws+ObZxRMxX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TOxsYdQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TOxsYdQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054BDC2BD10;
	Mon,  3 Jun 2024 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440661;
	bh=JLxAAe3wi+MtCemo1NZKmwbQpdREA9zf57aO/8VIjqI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TOxsYdQRLvSd+3MT3TcWpsV26dZ394fFrXpFH+m7vBz0IgEFOmDxDb5kECM4arSTr
	 wrdzp9NarVN2ZMLVreyJM3EUoc+Wf4hK/V70W7h3xkVgpmjIAcEVA50UyS7lV9uQKo
	 0gWJ6X+nSmh+/QolJcipQq3vAO3y3ruqDY+ee3FAQVtSZ3Fr/rRXbg5vtGvretnkrM
	 lbmYTLsCf3NOxhLeNF6R31wKeSNqma+G2l1k2YbXILiz5xNXaDCOoQSzPPnD916Kqa
	 GVrAvLiEossMvT+Nuqmv4q1t4jfCQ6wzX6wWAn81QPcPtNZVJw3hRTurfTRVjRqCRV
	 O5cPDo7UYvUcg==
Date: Mon, 03 Jun 2024 11:51:00 -0700
Subject: [PATCHSET v30.5 09/10] xfs_repair: reduce refcount repair memory
 usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744043484.1450408.1711608371281603052.stgit@frogsfrogsfrogs>
In-Reply-To: <20240603184512.GD52987@frogsfrogsfrogs>
References: <20240603184512.GD52987@frogsfrogsfrogs>
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

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-refcount-scalability-6.9

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-refcount-scalability-6.9
---
Commits in this patchset:
 * xfs_repair: define an in-memory btree for storing refcount bag info
 * xfs_repair: create refcount bag
 * xfs_repair: port to the new refcount bag structure
 * xfs_repair: remove the old bag implementation
---
 libxfs/libxfs_api_defs.h |    9 +
 repair/Makefile          |    4 
 repair/rcbag.c           |  371 ++++++++++++++++++++++++++++++++++++++++++++
 repair/rcbag.h           |   32 ++++
 repair/rcbag_btree.c     |  390 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/rcbag_btree.h     |   77 +++++++++
 repair/rmap.c            |  157 +++++--------------
 repair/slab.c            |  130 ---------------
 repair/slab.h            |   19 --
 repair/xfs_repair.c      |    6 +
 10 files changed, 934 insertions(+), 261 deletions(-)
 create mode 100644 repair/rcbag.c
 create mode 100644 repair/rcbag.h
 create mode 100644 repair/rcbag_btree.c
 create mode 100644 repair/rcbag_btree.h

