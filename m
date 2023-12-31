Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BF5B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bc34obMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40689C433C7;
	Sun, 31 Dec 2023 19:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051801;
	bh=l96KXbHjqIVqBVdAPfkY/8CUMaF6RsGvGgwETizyOfw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bc34obMvXnXszGZXUpSuakiI69ZejGPNlZxXIEajUieE1iuW2+1H9N8mzGPjcWzFl
	 QhRB50s0csgP5fkkaDOwQKuJxxyiA1kP6fqWzMDKCJZvzUWimrzXdawfaW+CXBuQ1s
	 SNp9ArlQ6laKTshV7kk69WomuUeeoVm70JqJIh1A+8NGDMLE9PF3OlWBt/lxRlu+qU
	 I7scsUqOp52iSN5FThcuiicWM6u2dvdr7kp/3oNAcYBhTYXzE6P809DjpyAx5xCjU5
	 6KJ9po7ZC/De/X20tO+XfqYAgAo3v0wCu/WVVeEwAuQP/QGuun5auFLOty5WtSSrPR
	 i1ssiEXNcKc2Q==
Date: Sun, 31 Dec 2023 11:43:20 -0800
Subject: [PATCHSET v29.0 14/40] xfsprogs: move btree geometry to ops struct
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404993983.1795132.17312636757680803212.stgit@frogsfrogsfrogs>
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

This patchset prepares the generic btree code to allow for the creation
of new btree types outside of libxfs.  The end goal here is for online
fsck to be able to create its own in-memory btrees that will be used to
improve the performance (and reduce the memory requirements of) the
refcount btree.

To enable this, I decided that the btree ops structure is the ideal
place to encode all of the geometry information about a btree. The btree
ops struture already contains the buffer ops (and hence the btree block
magic numbers) as well as the key and record sizes, so it doesn't seem
all that farfetched to encode the XFS_BTREE_ flags that determine the
geometry (ROOT_IN_INODE, LONG_PTRS, etc).

The rest of the patchset cleans up the btree functions that initialize
btree blocks and btree buffers.  The bulk of this work is to replace
btree geometry related function call arguments with a single pointer to
the ops structure, and then clean up everything else around that.  As a
side effect, we rename the functions.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-geometry-in-ops

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-geometry-in-ops
---
 libxfs/xfbtree.c            |   15 ++-------
 libxfs/xfs_ag.c             |   33 ++++++++------------
 libxfs/xfs_ag.h             |    2 +
 libxfs/xfs_alloc_btree.c    |   21 +++++--------
 libxfs/xfs_bmap.c           |    9 +-----
 libxfs/xfs_bmap_btree.c     |   14 ++-------
 libxfs/xfs_btree.c          |   70 ++++++++++++++++++++++---------------------
 libxfs/xfs_btree.h          |   36 ++++++++++------------
 libxfs/xfs_btree_mem.h      |    9 ------
 libxfs/xfs_btree_staging.c  |    6 +---
 libxfs/xfs_ialloc_btree.c   |   17 +++++-----
 libxfs/xfs_refcount_btree.c |    8 ++---
 libxfs/xfs_rmap_btree.c     |   16 ++++------
 libxfs/xfs_shared.h         |    9 ++++++
 14 files changed, 113 insertions(+), 152 deletions(-)

