Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4448BB666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kn8a+B+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10913C433C8;
	Sun, 31 Dec 2023 19:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051535;
	bh=9aay8RuX9bRDOsigR6ZhJEmgFTWDFT8u5m95Q6Qa1oM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Kn8a+B+LgM8/gRmnTtX9XaXvhoaIddzJAzwrPJLoSZQ+8HQkzq/A/YI/Tp7z5laL6
	 AN08yqVV4JtKAJaAFw0GtWRR5y011xbWDm//eFuW618CoKlb1xBBeEW2BDeQJmIen5
	 UfcBFUU9+KrU9KzXSA+KkiF5hPGNVJFCocdCFT3QBBVNfloUTrwhl90B345u/n9ux1
	 RHQgAVF5pmtwAVJKHL8G9w+jaJoGirD12SpNtXFUWjwppMl1CW+6/C0v5zhedDssqU
	 wJhCek/JGzX2m15Pg9GXacfMaeYvvY0TJzK8on5caZHmBTVpA8Q18ybGtXZ8RywuUB
	 F3CuwWeJzHvOQ==
Date: Sun, 31 Dec 2023 11:38:54 -0800
Subject: [PATCHSET RFC 2/5] xfs: noalloc allocation groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404854709.1769671.12231107418026207335.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182553.GV361584@frogsfrogsfrogs>
References: <20231231182553.GV361584@frogsfrogsfrogs>
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

This series creates a new NOALLOC flag for allocation groups that causes
the block and inode allocators to look elsewhere when trying to
allocate resources.  This is either the first part of a patchset to
implement online shrinking (set noalloc on the last AGs, run fsr to move
the files and directories) or freeze-free rmapbt rebuilding (set
noalloc to prevent creation of new mappings, then hook deletion of old
mappings).  This is still totally a research project.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=noalloc-ags

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=noalloc-ags
---
 fs/xfs/Kconfig              |   13 +++++
 fs/xfs/libxfs/xfs_ag.c      |  114 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h      |    8 +++
 fs/xfs/libxfs/xfs_ag_resv.c |   27 +++++++++-
 fs/xfs/libxfs/xfs_defer.c   |   14 +++++
 fs/xfs/libxfs/xfs_fs.h      |    5 ++
 fs/xfs/libxfs/xfs_ialloc.c  |    3 +
 fs/xfs/scrub/btree.c        |   88 +++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c       |  107 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h       |    1 
 fs/xfs/scrub/dabtree.c      |   24 +++++++++
 fs/xfs/scrub/fscounters.c   |    3 +
 fs/xfs/scrub/inode.c        |    4 ++
 fs/xfs/scrub/scrub.c        |   40 +++++++++++++++
 fs/xfs/scrub/trace.c        |   22 ++++++++
 fs/xfs/scrub/trace.h        |    2 +
 fs/xfs/xfs_fsops.c          |   10 +++-
 fs/xfs/xfs_globals.c        |    5 ++
 fs/xfs/xfs_ioctl.c          |    4 +-
 fs/xfs/xfs_super.c          |    1 
 fs/xfs/xfs_sysctl.h         |    1 
 fs/xfs/xfs_sysfs.c          |   32 ++++++++++++
 fs/xfs/xfs_trace.h          |   65 +++++++++++++++++++++++++
 fs/xfs/xfs_trans.c          |    3 +
 fs/xfs/xfs_trans.h          |    7 +++
 25 files changed, 597 insertions(+), 6 deletions(-)

