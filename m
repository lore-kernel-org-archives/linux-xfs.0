Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF39C8CB
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nPxj2eoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174A2C433C8;
	Sun, 31 Dec 2023 19:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052614;
	bh=PCLVEhu2o2pTXN5V4FvEmj1yyMB1GxQQtjALXOMQYIQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nPxj2eooncw23ZPFMWMEeoon8Oh4Atm4IhYn/oVXUHlab+gc4i47rlIz3YBzZOUku
	 Wxti5CUYlTEXGqn5nQfGCNhgSGg6zHQPz8Tm1m1ocldVLB8986PY5N9ePTnfGl/hFh
	 /1O9WGFn00lA2ibaZ6gbmVxIuF53Jzq5opEszUa1mhDgPkBvf6GPTCILq4tXIvaj+B
	 PP5fDwKUnE3x0aOKD/WtqbUcTHGmA+zIn80jDoN+hs8BmY81vvvRA7+kfro366DVeM
	 CxNxf+COKt/xzvCN/RNxrbL+8SS0vT9OwAWHIwvLeAleDD9gjgYc7gEd5MerDmwjSI
	 nC3yv3MkpSLYQ==
Date: Sun, 31 Dec 2023 11:56:53 -0800
Subject: [PATCHSET 3/3] xfsprogs: defragment free space
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170405020316.1820796.451112156000559887.stgit@frogsfrogsfrogs>
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

These patches contain experimental code to enable userspace to defragment
the free space in a filesystem.  Two purposes are imagined for this
functionality: clearing space at the end of a filesystem before
shrinking it, and clearing free space in anticipation of making a large
allocation.

The first patch adds a new fallocate mode that allows userspace to
allocate free space from the filesystem into a file.  The goal here is
to allow the filesystem shrink process to prevent allocation from a
certain part of the filesystem while a free space defragmenter evacuates
all the files from the doomed part of the filesystem.

The second patch amends the online repair system to allow the sysadmin
to forcibly rebuild metadata structures, even if they're not corrupt.
Without adding an ioctl to move metadata btree blocks, this is the only
way to dislodge metadata.

This patchset also includes a separate inode migration tool as
prototyped by Dave Chinner in 2020.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=defrag-freespace

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=defrag-freespace

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=defrag-freespace
---
 Makefile                        |    2 
 configure.ac                    |    1 
 db/agfl.c                       |  297 ++++
 include/builddefs.in            |    1 
 include/xfs_trace.h             |    4 
 io/prealloc.c                   |   35 
 libfrog/Makefile                |    5 
 libfrog/clearspace.c            | 3103 +++++++++++++++++++++++++++++++++++++++
 libfrog/clearspace.h            |   72 +
 libfrog/fsgeom.h                |   29 
 libfrog/radix-tree.c            |    2 
 libfrog/radix-tree.h            |    2 
 libxfs/libxfs_api_defs.h        |    4 
 libxfs/libxfs_priv.h            |   10 
 libxfs/xfs_alloc.c              |   88 +
 libxfs/xfs_alloc.h              |    3 
 libxfs/xfs_bmap.c               |  149 ++
 libxfs/xfs_bmap.h               |    3 
 libxfs/xfs_fs.h                 |    1 
 libxfs/xfs_fs_staging.h         |   15 
 m4/package_libcdev.m4           |   20 
 man/man2/ioctl_xfs_map_freesp.2 |   76 +
 man/man8/xfs_db.8               |   11 
 man/man8/xfs_io.8               |    8 
 man/man8/xfs_spaceman.8         |   40 +
 spaceman/Makefile               |   10 
 spaceman/clearfree.c            |  164 ++
 spaceman/find_owner.c           |  443 ++++++
 spaceman/init.c                 |    7 
 spaceman/move_inode.c           |  663 ++++++++
 spaceman/relocation.c           |  566 +++++++
 spaceman/relocation.h           |   53 +
 spaceman/space.h                |    6 
 33 files changed, 5883 insertions(+), 10 deletions(-)
 create mode 100644 libfrog/clearspace.c
 create mode 100644 libfrog/clearspace.h
 create mode 100644 man/man2/ioctl_xfs_map_freesp.2
 create mode 100644 spaceman/clearfree.c
 create mode 100644 spaceman/find_owner.c
 create mode 100644 spaceman/move_inode.c
 create mode 100644 spaceman/relocation.c
 create mode 100644 spaceman/relocation.h

