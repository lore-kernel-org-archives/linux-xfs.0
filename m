Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8404B645
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SHOfr7Cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3937EC433C8;
	Sun, 31 Dec 2023 19:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051066;
	bh=ng34dpV/BOLp1Ymumjcy62zZ9och2CAydrTDjJech1Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SHOfr7CcG2QuDTOBQq7tKiF7/cdnd42KuGouiQ1gfHZiHuSmz/GHC237o50PVJbtW
	 qDByv1gL0NXjJc3hTzQ3F/ZOkPEicrTsP/A5/PDGnnXXi/nv8H2dciv8LhHVHzRrJn
	 ptKY/t6UQOsd/G+X2Fpz6jvJQlRbXKrakzG1ZuHhrP5WDUAwOmR88fvbKEaE7Wiedq
	 SASk7epfgy20aD1SP5sKgtsgVt4D2ut6fLpg6yrIG3u8Dr3zDHnEj4vGkVkwCU8JCc
	 L8Kd/qkS17dF2Fuz9ic4w2r515LH8KHjoh2h4/1HSPFDjfpRfjGj6dc120+Wcgdqrr
	 NVCwAdQtXTZaA==
Date: Sun, 31 Dec 2023 11:31:05 -0800
Subject: [PATCHSET v29.0 22/28] xfs: online repair of directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404836024.1753619.16650627532281286267.stgit@frogsfrogsfrogs>
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

This series employs atomic extent swapping to enable safe reconstruction
of directory data.  For now, XFS does not support reverse directory
links (aka parent pointers), so we can only salvage the dirents of a
directory and construct a new structure.

Directory repair therefore consists of five main parts:

First, we walk the existing directory to salvage as many entries as we
can, by adding them as new directory entries to the repair temp dir.

Second, we validate the parent pointer found in the directory.  If one
was not found, we scan the entire filesystem looking for a potential
parent.

Third, we use atomic extent swaps to exchange the entire data fork
between the two directories.

Fourth, we reap the old directory blocks as carefully as we can.

To wrap up the directory repair code, we need to add to the regular
filesystem the ability to free all the data fork blocks in a directory.
This does not change anything with normal directories, since they must
still unlink and shrink one entry at a time.  However, this will
facilitate freeing of partially-inactivated temporary directories during
log recovery.

The second half of this patchset implements repairs for the dotdot
entries of directories.  For now there is only rudimentary support for
this, because there are no directory parent pointers, so the best we can
do is scanning the filesystem and the VFS dcache for answers.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-dirs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-dirs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-dirs
---
 fs/xfs/Makefile              |    3 
 fs/xfs/scrub/dir.c           |    9 
 fs/xfs/scrub/dir_repair.c    | 1399 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/findparent.c    |  451 ++++++++++++++
 fs/xfs/scrub/findparent.h    |   50 ++
 fs/xfs/scrub/inode_repair.c  |    5 
 fs/xfs/scrub/iscan.c         |   18 +
 fs/xfs/scrub/iscan.h         |    1 
 fs/xfs/scrub/nlinks.c        |   23 +
 fs/xfs/scrub/nlinks_repair.c |    9 
 fs/xfs/scrub/parent.c        |   14 
 fs/xfs/scrub/parent_repair.c |  234 +++++++
 fs/xfs/scrub/readdir.c       |    7 
 fs/xfs/scrub/repair.c        |    1 
 fs/xfs/scrub/repair.h        |    8 
 fs/xfs/scrub/scrub.c         |    4 
 fs/xfs/scrub/tempfile.c      |   13 
 fs/xfs/scrub/tempfile.h      |    2 
 fs/xfs/scrub/trace.h         |  115 +++
 fs/xfs/xfs_inode.c           |   51 ++
 20 files changed, 2413 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/dir_repair.c
 create mode 100644 fs/xfs/scrub/findparent.c
 create mode 100644 fs/xfs/scrub/findparent.h
 create mode 100644 fs/xfs/scrub/parent_repair.c

