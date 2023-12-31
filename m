Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A60B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cb0+xAfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E34C433C8;
	Sun, 31 Dec 2023 19:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051363;
	bh=LMcpbRLwAd6OKTE0jSmhArxrlFBhW9vIh2c53CWQ07k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cb0+xAfjadCHVcbvv5qYG4cuj2rciWOmjgmO0afk+oEtGSJ5Zur0UnjwQNKiAI+wQ
	 BYsmDuTDWB40iTz2BnbyjKwslll004U1QGyLPxJKd8CW54eWjMyui3QpuCMo9dVs1C
	 cNd2dQFvR5hefRpMyJwZkQFFmXRc9/ZtXzWKb16sAZvPsucGioGQfVGuNFYrNI4oOt
	 eh/pCPdnYuoZhaL8lSZXzbfvZdEvMkNBDpUitQDrGfvUVE6J9mjUnAz73RbeZAJcmR
	 +CXYsFg6ILc1beneh4pJcVtqUWqHZdS2j7DX5KkJT6wMuUjgD1yCUgvR9y+bq4M2xJ
	 0KfL9Y+KhgoUg==
Date: Sun, 31 Dec 2023 11:36:02 -0800
Subject: [PATCHSET v2.0 06/15] xfs: refactor btrees to support records in
 inode root
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
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

This series prepares the btree code to support realtime reverse mapping
btrees by refactoring xfs_ifork_realloc to be fed a per-btree ops
structure so that it can handle multiple types of inode-rooted btrees.
It moves on to refactoring the btree code to use the new realloc
routines and to support storing btree rcords in the inode root, because
the current bmbt code does not support this.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-ifork-records

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-ifork-records
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    6 -
 fs/xfs/libxfs/xfs_alloc_btree.h    |    3 
 fs/xfs/libxfs/xfs_attr_leaf.c      |    8 -
 fs/xfs/libxfs/xfs_bmap.c           |   59 ++----
 fs/xfs/libxfs/xfs_bmap_btree.c     |   93 ++++++++-
 fs/xfs/libxfs/xfs_bmap_btree.h     |  219 +++++++++++++++------
 fs/xfs/libxfs/xfs_btree.c          |  382 ++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_btree.h          |    4 
 fs/xfs/libxfs/xfs_btree_staging.c  |    4 
 fs/xfs/libxfs/xfs_ialloc.c         |    4 
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    6 -
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    3 
 fs/xfs/libxfs/xfs_inode_fork.c     |  163 +++++++--------
 fs/xfs/libxfs/xfs_inode_fork.h     |   27 ++-
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 
 fs/xfs/libxfs/xfs_refcount_btree.h |    3 
 fs/xfs/libxfs/xfs_rmap_btree.c     |    9 -
 fs/xfs/libxfs/xfs_rmap_btree.h     |    3 
 fs/xfs/libxfs/xfs_sb.c             |   16 +-
 fs/xfs/libxfs/xfs_trans_resv.c     |    2 
 fs/xfs/scrub/bmap_repair.c         |    2 
 fs/xfs/scrub/inode_repair.c        |   12 +
 fs/xfs/xfs_xchgrange.c             |    4 
 23 files changed, 707 insertions(+), 330 deletions(-)

