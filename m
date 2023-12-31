Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D037B666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lh6mV8cA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DA0C433C7;
	Sun, 31 Dec 2023 19:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051081;
	bh=POqRXhYi0/9GAhNq4/xyScBQXIRf6WS3HGJUSXydsMM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lh6mV8cAlZMHzLt3nntUxhXyx8fKRBiZ4EKTCpRlo/LCa8NzSVfHjBvjOUtQQ6JwL
	 TlahRsLPG18M/Z/YlZZgX0JnIPc+mzwHyqIfp79Tn/JdIwAE8BaQUlL+m5TqlG+6KX
	 c6vqAbr4eKqszCNnzBe2/ZvZUQDYiKJ/kxYTlAwjdMLRJ/XJZ1RBjW/nQDrakybhaC
	 DBj3DUj5Ukx0927DP5bqLK74flTNxzCTvuWiy74elHQqyx4Jny+Xb/brdFDg/Ypb6M
	 BQg5EylBnMNZsBQIgVuQ9zYuEhuhWv0Ov09Qb7FcY7FbzAgiaCmzaFgPHYdpSIFwMV
	 X8xtzDsErJ5/g==
Date: Sun, 31 Dec 2023 11:31:21 -0800
Subject: [PATCHSET v29.0 23/28] xfs: move orphan files to lost and found
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404836433.1753770.18094386562668840224.stgit@frogsfrogsfrogs>
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

Orphaned files are defined to be files with nonzero ondisk link count
but no observable parent directory.  This series enables online repair
to reparent orphaned files into the filesystem directory tree, and wires
up this reparenting ability into the directory, file link count, and
parent pointer repair functions.  This is how we fix files with positive
link count that are not reachable through the directory tree.

This patch will also create the orphanage directory (lost+found) if it
is not present.  In contrast to xfs_repair, we follow e2fsck in creating
the lost+found without group or other-owner access to avoid accidental
disclosure of files that were previously hidden by an 0700 directory.
That's silly security, but people have been known to do it.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-orphanage
---
 .../filesystems/xfs-online-fsck-design.rst         |   20 -
 fs/xfs/Makefile                                    |    1 
 fs/xfs/scrub/dir_repair.c                          |  130 ++++
 fs/xfs/scrub/nlinks.c                              |   11 
 fs/xfs/scrub/nlinks.h                              |    6 
 fs/xfs/scrub/nlinks_repair.c                       |  124 ++++
 fs/xfs/scrub/orphanage.c                           |  587 ++++++++++++++++++++
 fs/xfs/scrub/orphanage.h                           |   75 +++
 fs/xfs/scrub/parent_repair.c                       |   98 +++
 fs/xfs/scrub/repair.h                              |    2 
 fs/xfs/scrub/scrub.c                               |    2 
 fs/xfs/scrub/scrub.h                               |    4 
 fs/xfs/scrub/trace.c                               |    1 
 fs/xfs/scrub/trace.h                               |   96 +++
 fs/xfs/xfs_inode.c                                 |    6 
 fs/xfs/xfs_inode.h                                 |    1 
 16 files changed, 1130 insertions(+), 34 deletions(-)
 create mode 100644 fs/xfs/scrub/orphanage.c
 create mode 100644 fs/xfs/scrub/orphanage.h

