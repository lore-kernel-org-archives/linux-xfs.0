Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF353D7A
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301372; cv=none; b=NM+p9+6Czk9Ceb4h7igLxoZQ1ks3xmuiHBpFr1LTlze5L69cTCLKH6SyP/Ift+G+3eVHoR9GEBpP5ytVZfaX6aOM5sSGXAmvW8CDQ6P7eSMqAV8+Z0Sybc3BZ03wgKUPFH6qsymGulf6+6dPq8qQkkgFHjx95FalCV88lvIYTJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301372; c=relaxed/simple;
	bh=6jOUPYVnm0m1kqNju+jA1oNo7mf9VWRCwibfbAunm0w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJm7eCE5gbENlFnwHtIn2+sXHEt/M4PEEgjZ68RMImPZ3LlSsIbYyavRgstu/n62dpIdBZN/Oj7HS71S7Dy/eNB+V9CuLdJ+FQhLMFenHfrIPhjQfhkFAiM17Jc3P+RYezKx96RE95suCeh6mOdsd6AUzvcLzf4vOmK1KvyROLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KdalNa2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdalNa2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0B7C4CEC2;
	Mon,  2 Sep 2024 18:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301372;
	bh=6jOUPYVnm0m1kqNju+jA1oNo7mf9VWRCwibfbAunm0w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KdalNa2AnM7pHoJPsgpRHiC2x2aEWpROLWSso9hcO9vTp/SBKdOwFtwVMPUHaqB1O
	 UjscvF1Xg5j+1c8fenrFz0K+EJuAMhk9b/Fl1zy5dQOkoJgBZ/Z59b2ULofUK+0N+D
	 bLuqliiNj9jgnBCam2grlGXuQ0jDu3YcfRPlq7t7Q3Mva1wJLOxZh1TLvClJ8CGECv
	 QDF6gODjOBWoXfZxPpFJqbv+GQHDRMyq1Z2pshTmmr/b+qk2NFGggJ7Q4VuGnhuE3T
	 QIbaDbifvuCGbXYM9R8eQuD7wGI5S2EOwaDN4WS+g9Y2T6wMWMwcfqkyKY3ui5jlSW
	 lH+FxuRyIK/5Q==
Date: Mon, 02 Sep 2024 11:22:51 -0700
Subject: [PATCHSET v4.2 8/8] xfs: cleanups for inode rooted btree code
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530107961.3326739.11577236979175106791.stgit@frogsfrogsfrogs>
In-Reply-To: <20240902181606.GX6224@frogsfrogsfrogs>
References: <20240902181606.GX6224@frogsfrogsfrogs>
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

This series prepares the btree code to support realtime reverse mapping btrees
by refactoring xfs_ifork_realloc to be fed a per-btree ops structure so that it
can handle multiple types of inode-rooted btrees.  It moves on to refactoring
the btree code to use the new realloc routines.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-cleanups-6.12
---
Commits in this patchset:
 * xfs: replace shouty XFS_BM{BT,DR} macros
 * xfs: standardize the btree maxrecs function parameters
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    6 +
 fs/xfs/libxfs/xfs_alloc_btree.h    |    3 -
 fs/xfs/libxfs/xfs_attr_leaf.c      |    8 +
 fs/xfs/libxfs/xfs_bmap.c           |   42 ++++---
 fs/xfs/libxfs/xfs_bmap_btree.c     |   24 ++--
 fs/xfs/libxfs/xfs_bmap_btree.h     |  207 +++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_ialloc.c         |    4 -
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    6 +
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    3 -
 fs/xfs/libxfs/xfs_inode_fork.c     |   34 +++---
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 +
 fs/xfs/libxfs/xfs_refcount_btree.h |    3 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |    7 +
 fs/xfs/libxfs/xfs_rmap_btree.h     |    3 -
 fs/xfs/libxfs/xfs_sb.c             |   16 +--
 fs/xfs/libxfs/xfs_trans_resv.c     |    2 
 fs/xfs/scrub/bmap_repair.c         |    2 
 fs/xfs/scrub/inode_repair.c        |   12 +-
 fs/xfs/xfs_bmap_util.c             |    4 -
 19 files changed, 237 insertions(+), 154 deletions(-)

