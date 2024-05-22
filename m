Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558224C7B
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346064; cv=none; b=pHdHm45U91I8PnyM2w8enA5K/JjjRZ1RP0AZ0WwiYZAfNWRQcSOzZOCSpY/OZS7PTxiH9vnLl5w/0T4iPwZWRqqBkuhQ6r3tkY2712SoKWPymU4gWiGeYCsgvqk3hwtyrnIsSHnhExY2XfuLZsUrKqCiStA3s8arvxgB0BZwFFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346064; c=relaxed/simple;
	bh=JLxAAe3wi+MtCemo1NZKmwbQpdREA9zf57aO/8VIjqI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nt+TvNpaaojfZqzrHKfE2eSYoacFgcog2BwOrIz4jFVtHCyL08qkEdOkTQ13pNCfIGZ7oBggvalaWhJpCSXxG4DtrBssmF3RMD3uFlyo9Z4+eXQzxxHzbeD21RPwUQYrO+fYsllF+S5lmweB8jKlHwX5pFKzH3VHxx/EcJwuc6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QwlkwRBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QwlkwRBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B14C2BD11;
	Wed, 22 May 2024 02:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346063;
	bh=JLxAAe3wi+MtCemo1NZKmwbQpdREA9zf57aO/8VIjqI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QwlkwRBqwlXS99p7NpyCMYge6HYr5f3R1qzZ7EVYh3H44S6D+pDv2o0BnLuf6h8uF
	 J+Fn29ID5Soju4v/Wla7UN6gI0q6XAwbJEkHCvkSp0lsaqVRaaDj9+Zir60Q3U8Ghm
	 +aO9KnH82lMcCAwg2lhzyuxdnI7juuIgFaX1FLYj+JZmh1rXn8/JnGQTRvu+hqRvqN
	 fNTtRTm1z1T5UZ+cC81olx2L+Ch0LW0LLkux+E/ynlgYttWOY/E1Ji937P4/cx8i+u
	 P/36KkfYISq79YYQAKYq7wH2RS9Ketd2eEPEhiYIxTyoyQvuhXPmvxV1fEnvUXk+SL
	 G72o/j+MuLoRw==
Date: Tue, 21 May 2024 19:47:43 -0700
Subject: [PATCHSET v30.4 09/10] xfs_repair: reduce refcount repair memory
 usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634535800.2483533.14373829251885822374.stgit@frogsfrogsfrogs>
In-Reply-To: <20240522023341.GB25546@frogsfrogsfrogs>
References: <20240522023341.GB25546@frogsfrogsfrogs>
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

