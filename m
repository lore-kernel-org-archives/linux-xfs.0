Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF62AB65D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tLzapcAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923FEC433C7;
	Sun, 31 Dec 2023 19:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050893;
	bh=zxG7vjJHw8AubIn07O3yELL9Bn5PuQRYO10JyuxhwQ8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tLzapcAjqNrzjAVps1DgdCUkvP4J1CkDYyIDlQZenYHVJeRRhRz3kwstTwPWWPki5
	 SMPFA22tWXh2NOMcAFopq7GJOnm9M194huViPskCzl/WTcpEv7FkZpuvRHJmhUo4rt
	 bqDlSpY5hQ64JIRr+1SRpHm3e8Gxnvfl/1awRATHrXkz7tggTs1fBaVJSgzN3vbDOY
	 /ttU09L1H9D6tTiqtTQuSklYcyFcbWZ3DJDO/682Sjg+OeaW1gkdPebuMdUnz6gnN0
	 HEw1kTBlDsWtvRaiWqKUiln6XaPFgIYB1yFKfCPAQj8FwwFm85x4ncIyP3wdcndg+S
	 FPFJXBgCGkWkA==
Date: Sun, 31 Dec 2023 11:28:13 -0800
Subject: [PATCHSET v29.0 11/28] xfs: reduce refcount repair memory usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404830995.1749557.6135790697605021363.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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
 fs/xfs/Makefile                    |    2 
 fs/xfs/libxfs/xfs_alloc_btree.c    |    2 
 fs/xfs/libxfs/xfs_bmap_btree.c     |    1 
 fs/xfs/libxfs/xfs_btree.c          |   24 --
 fs/xfs/libxfs/xfs_btree.h          |    4 
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 
 fs/xfs/libxfs/xfs_refcount_btree.c |    1 
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 
 fs/xfs/libxfs/xfs_types.h          |    6 -
 fs/xfs/scrub/rcbag.c               |  331 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rcbag.h               |   28 +++
 fs/xfs/scrub/rcbag_btree.c         |  372 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rcbag_btree.h         |   83 ++++++++
 fs/xfs/scrub/refcount.c            |   12 +
 fs/xfs/scrub/refcount_repair.c     |  164 ++++++----------
 fs/xfs/scrub/repair.h              |    2 
 fs/xfs/scrub/trace.h               |    1 
 fs/xfs/xfs_super.c                 |   10 +
 fs/xfs/xfs_trace.h                 |    1 
 19 files changed, 917 insertions(+), 131 deletions(-)
 create mode 100644 fs/xfs/scrub/rcbag.c
 create mode 100644 fs/xfs/scrub/rcbag.h
 create mode 100644 fs/xfs/scrub/rcbag_btree.c
 create mode 100644 fs/xfs/scrub/rcbag_btree.h

