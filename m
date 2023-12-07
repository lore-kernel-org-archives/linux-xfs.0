Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A491363
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTtVNCLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAF1C433C7;
	Thu,  7 Dec 2023 02:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916709;
	bh=AiqnDcXqDAlqRScPEfc4Oa2DGKepUDuujdziF+osv/s=;
	h=Date:Subject:From:To:Cc:From;
	b=HTtVNCLaphMFWiwvRahjCRZ50IImTlq2QduQWnt1lZnIGNegtD+RnVpxDum7DL2LF
	 7h13E6+PSJuBC8KOoBHMvnAOCkYuplgiZC3+gr136VMXQsx4RHCcleA10sMKnWXPnK
	 5M0CmGYGWQnewuMcsaueWgtRFsSNRJaX/rYmV/SLVB3baNMky0FzylKYO+oj44m8b8
	 6r4nz2wwpKOov93AQNHEYZutcG91BP9q70mjac0NFOuUAKbhT+kLmdAb4Jwko5iFAU
	 xcF7mwnKP43GAnWI4d3dKkIQddBsdDu6NbWcVeMZdHAso0e6JCZzusb7PW+OtEHwNb
	 Jx0o8opgbuchQ==
Date: Wed, 06 Dec 2023 18:38:28 -0800
Subject: [PATCHSET v28.1 0/9] xfs: online repair of inodes and forks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_attr_leaf.c      |   13 
 fs/xfs/libxfs/xfs_attr_leaf.h      |    3 
 fs/xfs/libxfs/xfs_bmap.c           |   22 
 fs/xfs/libxfs/xfs_bmap.h           |    2 
 fs/xfs/libxfs/xfs_dir2_priv.h      |    3 
 fs/xfs/libxfs/xfs_dir2_sf.c        |   13 
 fs/xfs/libxfs/xfs_format.h         |    2 
 fs/xfs/libxfs/xfs_health.h         |    6 
 fs/xfs/libxfs/xfs_inode_fork.c     |   33 +
 fs/xfs/libxfs/xfs_shared.h         |    2 
 fs/xfs/libxfs/xfs_symlink_remote.c |    8 
 fs/xfs/scrub/bmap.c                |   78 +-
 fs/xfs/scrub/common.c              |   26 +
 fs/xfs/scrub/common.h              |    8 
 fs/xfs/scrub/dir.c                 |   23 
 fs/xfs/scrub/health.c              |   14 
 fs/xfs/scrub/health.h              |    1 
 fs/xfs/scrub/inode.c               |   16 
 fs/xfs/scrub/inode_repair.c        | 1682 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/parent.c              |   17 
 fs/xfs/scrub/repair.c              |   57 +
 fs/xfs/scrub/repair.h              |   29 +
 fs/xfs/scrub/rtbitmap.c            |    4 
 fs/xfs/scrub/rtsummary.c           |    4 
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/trace.h               |  174 ++++
 fs/xfs/xfs_dir2_readdir.c          |    3 
 fs/xfs/xfs_inode.c                 |   25 +
 fs/xfs/xfs_inode.h                 |    2 
 fs/xfs/xfs_symlink.c               |    2 
 fs/xfs/xfs_xattr.c                 |    6 
 32 files changed, 2220 insertions(+), 61 deletions(-)
 create mode 100644 fs/xfs/scrub/inode_repair.c

