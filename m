Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EF0B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CpicVpWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE1AC433C8;
	Sun, 31 Dec 2023 19:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050878;
	bh=aX+jHsEYxWDFByvZsRSVUEP95Q4F1RsBVDXvfQr5+eE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CpicVpWGyjM+AQjZzvykHYQdA0bXKNw9o64vNt/sZQcKhx++kVhPnYHPeJwTAs0Dp
	 wjzK6eCObUSw6fnurIklRm0y9qptsbdpV7PKD3NEqwohU9NuicVT+yWHnIYYm7Dbaz
	 1/5yalQtygrK4tRmAU65oqZA9uchfgqBqaxSPZbdR4kIdP4QGOP/mugzmW7QSySebj
	 G3t9FhsAmQS2TXcebPwKdwhcgk66B4ydrvsKQdNM68P7DzMddMesiUvxqVSISxVlkn
	 G/KxzKHcoAZ0L3j/8WOOuk/7zbaJaKsHmstMW2cchJUbsPxRY1GaFkbpuADbMz+QCm
	 wyFzT5bP2teVQ==
Date: Sun, 31 Dec 2023 11:27:57 -0800
Subject: [PATCHSET v29.0 10/28] xfs: move btree geometry to ops struct
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_ag.c             |   33 +++++++----------
 fs/xfs/libxfs/xfs_ag.h             |    2 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |   21 ++++-------
 fs/xfs/libxfs/xfs_bmap.c           |    9 +----
 fs/xfs/libxfs/xfs_bmap_btree.c     |   14 ++-----
 fs/xfs/libxfs/xfs_btree.c          |   70 +++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_btree.h          |   36 ++++++++-----------
 fs/xfs/libxfs/xfs_btree_mem.h      |    9 -----
 fs/xfs/libxfs/xfs_btree_staging.c  |    6 +--
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   17 ++++-----
 fs/xfs/libxfs/xfs_refcount_btree.c |    8 ++--
 fs/xfs/libxfs/xfs_rmap_btree.c     |   16 ++++----
 fs/xfs/libxfs/xfs_shared.h         |    9 +++++
 fs/xfs/scrub/trace.h               |   10 ++---
 fs/xfs/scrub/xfbtree.c             |   16 +++-----
 15 files changed, 118 insertions(+), 158 deletions(-)

