Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45548183A
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0EfpRNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD86C433C7;
	Wed, 13 Dec 2023 22:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702507901;
	bh=Wo1KFuaoZXFNjnrlrqnjz2gsDYVvMdwOisiLfzTiu4o=;
	h=Date:Subject:From:To:Cc:From;
	b=Q0EfpRNtC4LTKcmdP/4D8rA/5hDJ4zP5sJc0iuJebKE5qzPIaK03sdYUgk5EXE89D
	 /+/lEdePziVZTxc2m4qE0TBRz+CYQUEigVwOoTd2XGr6E/1b8ZpkcbLyk31toSQbIl
	 ewB7djWILyvpbiZmfVaDPYlg/bfQTceLWrvZ+XwbBDGbDwaXlTpznMpQ81ScSty3iw
	 gnYDfFrVEHfRuQAJPQQvp7TKd0cxqSGyl9i63NP255I2LL6VdbT9pgBGNToh8v2B/6
	 9e6XwGq3C2G2SUQVKTDcrc706XW6bpsOcwiPD/zrHdGsO840kJsr6e0wMNzblDm8Ov
	 NRtiZkC1tEnWA==
Date: Wed, 13 Dec 2023 14:51:40 -0800
Subject: [PATCHSET v28.2 0/9] xfs: online repair of inodes and forks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-inodes-6.8
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_attr_leaf.c      |   13 
 fs/xfs/libxfs/xfs_attr_leaf.h      |    3 
 fs/xfs/libxfs/xfs_bmap.c           |   22 -
 fs/xfs/libxfs/xfs_bmap.h           |    2 
 fs/xfs/libxfs/xfs_dir2_priv.h      |    3 
 fs/xfs/libxfs/xfs_dir2_sf.c        |   13 
 fs/xfs/libxfs/xfs_format.h         |    2 
 fs/xfs/libxfs/xfs_health.h         |   10 
 fs/xfs/libxfs/xfs_inode_fork.c     |   33 +
 fs/xfs/libxfs/xfs_shared.h         |    2 
 fs/xfs/libxfs/xfs_symlink_remote.c |    8 
 fs/xfs/scrub/bmap.c                |  144 +++
 fs/xfs/scrub/common.c              |   28 +
 fs/xfs/scrub/common.h              |    8 
 fs/xfs/scrub/dir.c                 |   42 +
 fs/xfs/scrub/health.c              |   32 +
 fs/xfs/scrub/health.h              |    2 
 fs/xfs/scrub/inode.c               |   16 
 fs/xfs/scrub/inode_repair.c        | 1525 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/parent.c              |   17 
 fs/xfs/scrub/repair.c              |   57 +
 fs/xfs/scrub/repair.h              |   29 +
 fs/xfs/scrub/rtbitmap.c            |    4 
 fs/xfs/scrub/rtsummary.c           |    4 
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/symlink.c             |   20 
 fs/xfs/scrub/trace.h               |  171 ++++
 fs/xfs/xfs_dir2_readdir.c          |    3 
 fs/xfs/xfs_health.c                |    8 
 fs/xfs/xfs_inode.c                 |   35 +
 fs/xfs/xfs_inode.h                 |    2 
 fs/xfs/xfs_symlink.c               |    3 
 fs/xfs/xfs_xattr.c                 |    6 
 34 files changed, 2185 insertions(+), 85 deletions(-)
 create mode 100644 fs/xfs/scrub/inode_repair.c

