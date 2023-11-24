Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757942C86B
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bNUZBVKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1E9C433C7;
	Fri, 24 Nov 2023 23:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869551;
	bh=VaBgQf13KJwlSkx4pfJevBtJAf/9mtsIA2Pizm7+Et8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bNUZBVKUzW7eprVZTsL7NQ+wJiYRDojWQgd5OQhmXY4CjrLg6qsenEz8Z9YuTBLdM
	 ux1JJtJ74USdIutBPFFZBjotTtmo4Wvth9KLWw6B1zuLjE1iPSB0J3NbdCW3iN4Nkw
	 sSK/B2LhQ3GoHsGu6U1FWBbfI441gSJhtBRwa5i31gA1lLwRYF83t1ivZkjLifcteq
	 Ls3Lzo3IRgIhAnjt82zKNbcij6ZFxkYBl9COOKHpZ7VrzbesO7Ih8IiiKnfL8/S0HS
	 Pg/l+CaTrzXEQoQOhFjebtSvdI5uOPqpDHRaBkhvchps4AQdUsB6jOQQtFXUM1LscL
	 UmMsCpY+qPbmA==
Date: Fri, 24 Nov 2023 15:45:51 -0800
Subject: [PATCHSET v28.0 0/7] xfs: online repair of inodes and forks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
In-Reply-To: <20231124233940.GK36190@frogsfrogsfrogs>
References: <20231124233940.GK36190@frogsfrogsfrogs>
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

In this series, online repair gains the ability to repair inode records.
To do this, we must repair the ondisk inode and fork information enough
to pass the iget verifiers and hence make the inode igettable again.
Once that's done, we can perform higher level repairs on the incore
inode.  The fstests counterpart of this patchset implements stress
testing of repair.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-inodes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-inodes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-inodes
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_attr_leaf.c      |   32 -
 fs/xfs/libxfs/xfs_attr_leaf.h      |    2 
 fs/xfs/libxfs/xfs_bmap.c           |   22 
 fs/xfs/libxfs/xfs_bmap.h           |    2 
 fs/xfs/libxfs/xfs_dir2_priv.h      |    2 
 fs/xfs/libxfs/xfs_dir2_sf.c        |   29 -
 fs/xfs/libxfs/xfs_format.h         |    3 
 fs/xfs/libxfs/xfs_shared.h         |    1 
 fs/xfs/libxfs/xfs_symlink_remote.c |   21 
 fs/xfs/scrub/bmap.c                |   48 +
 fs/xfs/scrub/common.c              |   26 +
 fs/xfs/scrub/common.h              |    8 
 fs/xfs/scrub/dir.c                 |   21 
 fs/xfs/scrub/inode.c               |   14 
 fs/xfs/scrub/inode_repair.c        | 1659 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/parent.c              |   17 
 fs/xfs/scrub/repair.c              |   57 +
 fs/xfs/scrub/repair.h              |   29 +
 fs/xfs/scrub/rtbitmap.c            |    4 
 fs/xfs/scrub/rtsummary.c           |    4 
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/trace.h               |  174 ++++
 23 files changed, 2128 insertions(+), 50 deletions(-)
 create mode 100644 fs/xfs/scrub/inode_repair.c

