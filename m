Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D54A80C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227337; cv=none; b=BjVV8b3Q7g19M8EsJj/wIE5wS2Usw/cmddvpNm2x+G9dKl+CJNxcIy2RddDcQg16gYuD6R9PptX65RqclhB9uBvDnB1U7ONie9moTb+Shvw+Kku968NwthC0TA+PMioattt3+selmhH4uaTqVjZOws7Ps+70XiMt+7y0WFPHyBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227337; c=relaxed/simple;
	bh=uFVkcK7Df6DFZOkBIeJBmDPfNNtRqMY2MTHcNkCROhc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=LoPqk2GQxOf+GrUeaR90ix8+LBpKhHkPHvQryuvi8/WFeF19LYrhEaRD3lmsn9qFNZ4Yz8rXCgoYlFQ6RWxaLXnKj4FT+aVROFhiaqHeSlqSCfQ6JsLw7LX48SVY3Qg8HE6xKeoeTn1J8FlooXTXBchNwKtdrHe+KNPhrKO+N+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gpqsH8ic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gpqsH8ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51082C113CC;
	Tue, 16 Apr 2024 00:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227337;
	bh=uFVkcK7Df6DFZOkBIeJBmDPfNNtRqMY2MTHcNkCROhc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gpqsH8icaCiZUAhV71lvOpXdDLD5PXGbArhYMLyxhliPr3YWENJWLdhl6Y6bkaUBa
	 6igPqlbjJ4rE8nAWkCYNWpPJGtqLvcb4ACn82E41i6VfZqTSsz2rPIJDr5WcirtjUc
	 /GRDvZmEeq6BoTATPLDNsMZVrVeXDIdVENq5lF/aCxzD09cNE7pedPhAbx8ZfDcJl1
	 MJlNVBvdr7kmuWeb8gpUI61awsvuWICNitTNX/SB+6FTZ38SkRVEpOdra96/St7tId
	 LomoeFKlScNPD8Vedt5PEi3aIiAiqHka0uZDfa0FQq6bYneE5cl4yIW0bLbP1Xy77A
	 SpS5vuHg+hRqg==
Date: Mon, 15 Apr 2024 17:28:56 -0700
Subject: [GIT PULL 06/16] xfs: set and validate dir/attr block owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322716673.141687.7531023432046638316.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240416002427.GB11972@frogsfrogsfrogs>
References: <20240416002427.GB11972@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit abf039e2e4afde98e448253f9a7ecc784a87924d:

xfs: online repair of realtime summaries (2024-04-15 14:58:49 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/dirattr-validate-owners-6.10_2024-04-15

for you to fetch changes up to fe6c9f8e48e0dcbfc3dba17edd88490c8579b34b:

xfs: validate explicit directory free block owners (2024-04-15 14:58:52 -0700)

----------------------------------------------------------------
xfs: set and validate dir/attr block owners [v30.3 06/16]

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

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (10):
xfs: add an explicit owner field to xfs_da_args
xfs: use the xfs_da_args owner field to set new dir/attr block owner
xfs: reduce indenting in xfs_attr_node_list
xfs: validate attr leaf buffer owners
xfs: validate attr remote value buffer owners
xfs: validate dabtree node buffer owners
xfs: validate directory leaf buffer owners
xfs: validate explicit directory data buffer owners
xfs: validate explicit directory block buffer owners
xfs: validate explicit directory free block owners

fs/xfs/libxfs/xfs_attr.c        |  14 ++--
fs/xfs/libxfs/xfs_attr_leaf.c   |  60 +++++++++++---
fs/xfs/libxfs/xfs_attr_leaf.h   |   4 +-
fs/xfs/libxfs/xfs_attr_remote.c |  13 ++--
fs/xfs/libxfs/xfs_bmap.c        |   1 +
fs/xfs/libxfs/xfs_da_btree.c    | 169 +++++++++++++++++++++++++++++++++++++++-
fs/xfs/libxfs/xfs_da_btree.h    |   3 +
fs/xfs/libxfs/xfs_dir2.c        |   5 ++
fs/xfs/libxfs/xfs_dir2.h        |   4 +
fs/xfs/libxfs/xfs_dir2_block.c  |  42 +++++-----
fs/xfs/libxfs/xfs_dir2_data.c   |  18 +++--
fs/xfs/libxfs/xfs_dir2_leaf.c   | 100 ++++++++++++++++++------
fs/xfs/libxfs/xfs_dir2_node.c   |  44 ++++++-----
fs/xfs/libxfs/xfs_dir2_priv.h   |  15 ++--
fs/xfs/libxfs/xfs_exchmaps.c    |   7 +-
fs/xfs/scrub/attr.c             |   1 +
fs/xfs/scrub/dabtree.c          |   8 ++
fs/xfs/scrub/dir.c              |  23 +++---
fs/xfs/scrub/readdir.c          |   6 +-
fs/xfs/xfs_attr_item.c          |   1 +
fs/xfs/xfs_attr_list.c          |  89 ++++++++++++++-------
fs/xfs/xfs_dir2_readdir.c       |   6 +-
fs/xfs/xfs_trace.h              |   7 +-
23 files changed, 492 insertions(+), 148 deletions(-)

