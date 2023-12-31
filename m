Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D98BB64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZRDVJHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF71C433C7;
	Sun, 31 Dec 2023 19:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051394;
	bh=vLNEfCdSr5tzH8RptvaL0EcN9YmwacQxTe61YPHl7aI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DZRDVJHoZ9W02HJ8ytkf7HyyZniSnNNyT6O1VCfCPtdIAnbYBC7p6qhoDmFBZCTGQ
	 eY+x8k+8Fg01w8HtWQ9z/Rop0RNqvAqfUMBwnCxx3JKpVM0cvf3cQxgltF3u1mnviS
	 y9m0fPo8SewxXpoQbSI0KJJOvyii3k1p+CUjH/DWbqXVNApSBdAlT9MK9NEe/jYiLj
	 FuvU0oOUEFqfWXiRClN8Bwnx8X0Juui6zTX7F74qFlcyei1oA8i3Ntcxm30LI3j30C
	 LuEcMzaORnfxTaFl+JJhzc5I9+nk4x571honb7N9DUno4wF+68uTXO25iI0rS6Pl1i
	 ZaJiRlzfmgv5Q==
Date: Sun, 31 Dec 2023 11:36:34 -0800
Subject: [PATCHSET v2.0 08/15] xfs: extent free log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

This series cleans up some warts in the extent freeing log intent code.
We start by acknowledging that this mechanism does not have anything to
do with the bmap code by moving it to xfs_alloc.c and giving the
function a more descriptive name.  Then we clean up the tracepoints and
the _finish_one call paths to pass the intent structure around.  This
reduces the overhead when the tracepoints are disabled and will make
things much cleaner when we start adding realtime support in the next
patch.  I also incorporated a bunch of cleanups from Christoph Hellwig.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=extfree-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=extfree-intent-cleanups
---
 fs/xfs/libxfs/xfs_ag.c             |    2 -
 fs/xfs/libxfs/xfs_alloc.c          |   92 ++++++++---------------------
 fs/xfs/libxfs/xfs_alloc.h          |   12 ++--
 fs/xfs/libxfs/xfs_bmap.c           |   12 +++-
 fs/xfs/libxfs/xfs_bmap_btree.c     |    2 -
 fs/xfs/libxfs/xfs_ialloc.c         |    5 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 -
 fs/xfs/libxfs/xfs_refcount.c       |    6 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 -
 fs/xfs/scrub/newbt.c               |    5 +-
 fs/xfs/scrub/reap.c                |    7 +-
 fs/xfs/xfs_bmap_item.c             |    6 --
 fs/xfs/xfs_drain.c                 |    8 +--
 fs/xfs/xfs_drain.h                 |    5 +-
 fs/xfs/xfs_extfree_item.c          |  115 +++++++++++++++++-------------------
 fs/xfs/xfs_extfree_item.h          |    6 ++
 fs/xfs/xfs_refcount_item.c         |    5 --
 fs/xfs/xfs_reflink.c               |    2 -
 fs/xfs/xfs_rmap_item.c             |    5 --
 fs/xfs/xfs_trace.h                 |   33 +++++-----
 20 files changed, 141 insertions(+), 191 deletions(-)

