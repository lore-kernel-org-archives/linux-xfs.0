Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC60156225
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224105; cv=none; b=AWTEKIkhjGAmd/iwdc20r4N4sE0WjkEVE1hQQX2BRa5asUPfM7Gvhf91SchSaNbb2i0bPQDCTjUJJOj9AyvSIMkDlaObws1IOKSjT51wA5ljyiskT2FSiFTJqgiBKD8IX6FbR7oOLJuJIxFe/im8pkw+VUQfmDx8XWtSHgvuCRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224105; c=relaxed/simple;
	bh=KHNC6t05hDimZbUjpagJf/73vvJ7NIeB0CExAmQikZU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D5bV+QfJMaRN57VqMFPrVjSQoLIx2yKNhkfzBYzVowTl9xlc2TKTIchN4EvK8pBP1PtMlxlVfqmjjZpDOlhLn2X0Xn8f2JUDdBpvbtjc9q14nWpW62n5nDFQanqPxqTWHlPjluibAuH6R7acmhlC74TIypY+YOqwANfGUrNJuQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XiY4HHdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XiY4HHdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDCFC113CC;
	Mon, 15 Apr 2024 23:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224104;
	bh=KHNC6t05hDimZbUjpagJf/73vvJ7NIeB0CExAmQikZU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XiY4HHdoAi3Mx+P0ADe4IrkXpnIxzqIavwI+uT2PNq8AyTTGnZhZo8FD0aPeYS4HV
	 WqRQzF66R4BinLweUf5jQpfDX6hpFH/ab7tQvOPJxlvpKDt8QhvcWShdXhhCQkohOw
	 eZkZ2O5kpdE4HPapoZfnO+jJCXTd6tJnHxUmVvQvAsoJfotmyvy+Pw9NPWvnNaCQ37
	 bM/o5zjVVy9K/26+N2WW2u3V8TW84vevt7LfCHq5KtU8lRl8e7vvVGXgF/fdadZqV+
	 lrWlWu8O2AqVS8C2scp/Qnpr+rE62qcmi5qc1vTZlKsGjJPLzLVskYwwPng56kY7GF
	 5n17ADYdSD4Nw==
Date: Mon, 15 Apr 2024 16:35:04 -0700
Subject: [PATCHSET v30.3 06/16] xfs: set and validate dir/attr block owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322382551.88250.5431690184825585631.stgit@frogsfrogsfrogs>
In-Reply-To: <20240415232853.GE11948@frogsfrogsfrogs>
References: <20240415232853.GE11948@frogsfrogsfrogs>
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

There are a couple of significant changes that need to be made to the
directory and xattr code before we can support online repairs of those
data structures.

The first change is because online repair is designed to use libxfs to
create a replacement dir/xattr structure in a temporary file, and use
atomic extent swapping to commit the corrected structure.  To avoid the
performance hit of walking every block of the new structure to rewrite
the owner number before the swap, we instead change libxfs to allow
callers of the dir and xattr code the ability to set an explicit owner
number to be written into the header fields of any new blocks that are
created.  For regular operation this will be the directory inode number.

The second change is to update the dir/xattr code to actually *check*
the owner number in each block that is read off the disk, since we don't
currently do that.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=dirattr-validate-owners-6.10
---
Commits in this patchset:
 * xfs: add an explicit owner field to xfs_da_args
 * xfs: use the xfs_da_args owner field to set new dir/attr block owner
 * xfs: reduce indenting in xfs_attr_node_list
 * xfs: validate attr leaf buffer owners
 * xfs: validate attr remote value buffer owners
 * xfs: validate dabtree node buffer owners
 * xfs: validate directory leaf buffer owners
 * xfs: validate explicit directory data buffer owners
 * xfs: validate explicit directory block buffer owners
 * xfs: validate explicit directory free block owners
---
 fs/xfs/libxfs/xfs_attr.c        |   14 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   60 ++++++++++++--
 fs/xfs/libxfs/xfs_attr_leaf.h   |    4 +
 fs/xfs/libxfs/xfs_attr_remote.c |   13 +--
 fs/xfs/libxfs/xfs_bmap.c        |    1 
 fs/xfs/libxfs/xfs_da_btree.c    |  169 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h    |    3 +
 fs/xfs/libxfs/xfs_dir2.c        |    5 +
 fs/xfs/libxfs/xfs_dir2.h        |    4 +
 fs/xfs/libxfs/xfs_dir2_block.c  |   42 ++++++----
 fs/xfs/libxfs/xfs_dir2_data.c   |   18 +++-
 fs/xfs/libxfs/xfs_dir2_leaf.c   |  100 ++++++++++++++++++-----
 fs/xfs/libxfs/xfs_dir2_node.c   |   44 ++++++----
 fs/xfs/libxfs/xfs_dir2_priv.h   |   15 ++-
 fs/xfs/libxfs/xfs_exchmaps.c    |    7 +-
 fs/xfs/scrub/attr.c             |    1 
 fs/xfs/scrub/dabtree.c          |    8 ++
 fs/xfs/scrub/dir.c              |   23 +++--
 fs/xfs/scrub/readdir.c          |    6 +
 fs/xfs/xfs_attr_item.c          |    1 
 fs/xfs/xfs_attr_list.c          |   89 ++++++++++++++-------
 fs/xfs/xfs_dir2_readdir.c       |    6 +
 fs/xfs/xfs_trace.h              |    7 +-
 23 files changed, 492 insertions(+), 148 deletions(-)

