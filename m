Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4F0B666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXnb+aJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAA3C433C8;
	Sun, 31 Dec 2023 19:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051769;
	bh=LVJGwfNF8x5QPWTwkea3Yrlu9rHhIvm5FGAytYlAQuo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fXnb+aJukI3Jbuw6RFKPv78xpYA6doZeYIfjojXMsze4LOpNSL4W7sSiPDYEIficf
	 qSZhQ8FjBq1hZXhIpQ23XxbVW83lvaTlQWWQTg4nLbGMRwoZYx0nhlbNAPeFG9alhp
	 mQGLnIZTssleu956g2PVfXyVjg8d16QAi7tUUnkwEZ++FO+VZmSM3lwVAsly+o3rFT
	 anBPm9KSXWKDOn467A1aMqzS4CDoTjjZ4ReNteZPBZlYzUSD2qW8y32qkp8aajpIG5
	 Rw280h6joatRxGc/sbV/LkXbwjKNvzxaMNOIIP0ax2eNxKhwR4vurfzI+WVOJS1Gax
	 p1qeLAGgi+evg==
Date: Sun, 31 Dec 2023 11:42:49 -0800
Subject: [PATCHSET v29.0 12/40] xfsprogs: online repair of rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404993240.1794784.3257777351086453063.stgit@frogsfrogsfrogs>
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

We have now constructed the four tools that we need to scan the
filesystem looking for reverse mappings: an inode scanner, hooks to
receive live updates from other writer threads, the ability to construct
btrees in memory, and a btree bulk loader.

This series glues those three together, enabling us to scan the
filesystem for mappings and keep it up to date while other writers run,
and then commit the new btree to disk atomically.

To reduce the size of each patch, the functionality is left disabled
until the end of the series and broken up into three patches: one to
create the mechanics of scanning the filesystem, a second to transition
to in-memory btrees, and a third to set up the live hooks.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-rmap-btree

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rmap-btree

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-rmap-btree
---
 include/xfs_mount.h     |    6 +
 libxfs/xfs_ag.c         |    1 
 libxfs/xfs_ag.h         |    3 +
 libxfs/xfs_bmap.c       |   49 +++++++++++-
 libxfs/xfs_bmap.h       |    8 ++
 libxfs/xfs_inode_fork.c |    9 ++
 libxfs/xfs_inode_fork.h |    1 
 libxfs/xfs_rmap.c       |  190 +++++++++++++++++++++++++++++++++++------------
 libxfs/xfs_rmap.h       |   30 +++++++
 libxfs/xfs_rmap_btree.c |  136 +++++++++++++++++++++++++++++++++-
 libxfs/xfs_rmap_btree.h |    9 ++
 11 files changed, 387 insertions(+), 55 deletions(-)

