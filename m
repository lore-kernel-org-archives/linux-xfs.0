Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C60B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hz8aJN+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00369C433C7;
	Sun, 31 Dec 2023 19:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051895;
	bh=j1SKqNtePMui1za0HjSlTLvqJUd7hyLdqXYnNe9yXCo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Hz8aJN+rni197/1OGhG+ScDeLb8GPjMd0Y9TASRbxCmt720ruv4ZIJb1Jvh8lVegw
	 F9lYq1k2dvc9uck6gV2gusyY/vywa9v9Y0ecsC+k8XCth9FddfjEhaQAXCfPWW1LZF
	 Chgh6bbGodTkH8gmZCnFrhdxpRKd2p+ipTfiggji8NQoMGuCNWD9jKm2maUedKAjSi
	 QyYf6zh8cWxlPhbPcZTSXz2IRLTwYbpSnzDF/51esB2duSEdXn0YM+Szzn098Abgb6
	 5+OYvBPBLefh/IGPW+k8s0hfL6dTNipC7efoK80H81uD0RdIlrSurEOhBYYHr39t23
	 iWTBetygZ4ATw==
Date: Sun, 31 Dec 2023 11:44:54 -0800
Subject: [PATCHSET v29.0 20/40] xfsprogs: atomic file updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
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

This series creates a new FIEXCHANGE_RANGE system call to exchange
ranges of bytes between two files atomically.  This new functionality
enables data storage programs to stage and commit file updates such that
reader programs will see either the old contents or the new contents in
their entirety, with no chance of torn writes.  A successful call
completion guarantees that the new contents will be seen even if the
system fails.

The ability to swap extent mappings between files in this manner is
critical to supporting online filesystem repair, which is built upon the
strategy of constructing a clean copy of a damaged structure and
committing the new structure into the metadata file atomically.

User programs will be able to update files atomically by opening an
O_TMPFILE, reflinking the source file to it, making whatever updates
they want to make, and exchange the relevant ranges of the temp file
with the original file.  If the updates are aligned with the file block
size, a new (since v2) flag provides for exchanging only the written
areas.  Callers can arrange for the update to be rejected if the
original file has been changed.

The intent behind this new userspace functionality is to enable atomic
rewrites of arbitrary parts of individual files.  For years, application
programmers wanting to ensure the atomicity of a file update had to
write the changes to a new file in the same directory, fsync the new
file, rename the new file on top of the old filename, and then fsync the
directory.  People get it wrong all the time, and $fs hacks abound.

The reference implementation in XFS creates a new log incompat feature
and log intent items to track high level progress of swapping ranges of
two files and finish interrupted work if the system goes down.  Sample
code can be found in the corresponding changes to xfs_io to exercise the
use case mentioned above.

Note that this function is /not/ the O_DIRECT atomic file writes concept
that has also been floating around for years.  It is also not the
RWF_ATOMIC patchset that has been shared.  This RFC is constructed
entirely in software, which means that there are no limitations other
than the general filesystem limits.

As a side note, the original motivation behind the kernel functionality
is online repair of file-based metadata.  The atomic file swap is
implemented as an atomic inode fork swap, which means that we can
implement online reconstruction of extended attributes and directories
by building a new one in another inode and atomically swap the contents.

Subsequent patchsets adapt the online filesystem repair code to use
atomic extent swapping.  This enables repair functions to construct a
clean copy of a directory, xattr information, symbolic links, realtime
bitmaps, and realtime summary information in a temporary inode.  If this
completes successfully, the new contents can be swapped atomically into
the inode being repaired.  This is essential to avoid making corruption
problems worse if the system goes down in the middle of running repair.

This patchset also ports the old XFS extent swap ioctl interface to use
the new extent swap code.

For userspace, this series also includes the userspace pieces needed to
test the new functionality, and a sample implementation of atomic file
updates.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=atomic-file-updates

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=atomic-file-updates

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=atomic-file-updates

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=atomic-file-updates
---
 fsr/xfs_fsr.c                       |  213 +++---
 include/jdm.h                       |   24 +
 include/libxfs.h                    |    1 
 include/xfs.h                       |    1 
 include/xfs_inode.h                 |    5 
 include/xfs_trace.h                 |   14 
 io/Makefile                         |    2 
 io/atomicupdate.c                   |  386 ++++++++++
 io/init.c                           |    1 
 io/inject.c                         |    1 
 io/io.h                             |    5 
 io/open.c                           |   27 +
 io/swapext.c                        |  194 ++++-
 libfrog/Makefile                    |    2 
 libfrog/file_exchange.c             |  186 +++++
 libfrog/file_exchange.h             |   16 
 libfrog/fsgeom.c                    |   45 +
 libfrog/fsgeom.h                    |    7 
 libhandle/jdm.c                     |  117 +++
 libxfs/Makefile                     |    3 
 libxfs/defer_item.c                 |   91 ++
 libxfs/defer_item.h                 |    4 
 libxfs/libxfs_priv.h                |   31 +
 libxfs/xfs_bmap.h                   |    2 
 libxfs/xfs_defer.c                  |    6 
 libxfs/xfs_defer.h                  |    2 
 libxfs/xfs_errortag.h               |    4 
 libxfs/xfs_format.h                 |   20 -
 libxfs/xfs_fs.h                     |    4 
 libxfs/xfs_fs_staging.h             |  107 +++
 libxfs/xfs_log_format.h             |   83 ++
 libxfs/xfs_sb.c                     |    3 
 libxfs/xfs_swapext.c                | 1316 +++++++++++++++++++++++++++++++++++
 libxfs/xfs_swapext.h                |  223 ++++++
 libxfs/xfs_symlink_remote.c         |   47 +
 libxfs/xfs_symlink_remote.h         |    1 
 libxfs/xfs_trans_space.h            |    4 
 logprint/log_misc.c                 |   11 
 logprint/log_print_all.c            |   12 
 logprint/log_redo.c                 |  128 +++
 logprint/logprint.h                 |    6 
 man/man2/ioctl_xfs_exchange_range.2 |  296 ++++++++
 man/man2/ioctl_xfs_fsgeometry.2     |    3 
 man/man8/xfs_io.8                   |   86 ++
 44 files changed, 3590 insertions(+), 150 deletions(-)
 create mode 100644 io/atomicupdate.c
 create mode 100644 libfrog/file_exchange.c
 create mode 100644 libfrog/file_exchange.h
 create mode 100644 libxfs/xfs_fs_staging.h
 create mode 100644 libxfs/xfs_swapext.c
 create mode 100644 libxfs/xfs_swapext.h
 create mode 100644 man/man2/ioctl_xfs_exchange_range.2

