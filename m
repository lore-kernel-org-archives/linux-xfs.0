Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177C913FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688050; cv=none; b=KuItmpqirvitVdmsBkmvXciDjrgBvFtoo1q+L3zl3Oe/y67CyC0KFMsDOrafrIJz9UgVk8dQs3S6sgPpWt7Z2OxNY1KEt5LCi9U/so8w0Zd4CiJITFlha1P0y9Vip4EWta88493C/hWzT1T1SLBtqL0bbfdZtZ5mU1WgsIE3a+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688050; c=relaxed/simple;
	bh=QN63wNieU9gHy89C0BxarT5280HF8NpvnN5faMpDffU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fnam6AOmm+mlPlIkVldnWQywoKfQgCf6B+BmyTml8Yu5+C9w4ys16nkgCxkqpvfNNlaONzodomZtm6kkxhSM7CUU8QwUP8n7PD1/eetZZ9/7CdVw60HQv9bQfsbXVlWG1mMjkv4iVylSFAfOZmYJVypry/k1++Im5iivbtvQkvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F777D9w6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F777D9w6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36C8C4CED2;
	Tue, 31 Dec 2024 23:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688050;
	bh=QN63wNieU9gHy89C0BxarT5280HF8NpvnN5faMpDffU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F777D9w6W/QcZY2W1RfMsDGOKJwlxxmOlPtJkZDw8fnxjYp5KkDpbZahevpXFQnBC
	 TNJM2VSLXTEodMb+U2TVEAG+QSGjLmrdTzyQNnJe2UkIJP917uk8QQYADYoifLdTpl
	 IlsW3SzDWHUUKe4FOvCUusZ1xfpa97gyk+dDD4xEm9tEc4cZopL3foiUqTQWuvaRty
	 nYWKn6GQ+I8EmsrTBq8VcB/VFk01Zz7RxW5xEOiisKaM/0Q03F7cmxaD2XcbEpnqtM
	 LAVxQn8NcIbSurOzL3GfCXZ9P8gdm5tn5G4FV97Emkh81Cv8QyTOpGoiIiEtZW8ddw
	 dSnbSkQTYZOAw==
Date: Tue, 31 Dec 2024 15:34:09 -0800
Subject: [PATCHSET 3/5] xfsprogs: defragment free space
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
In-Reply-To: <20241231232503.GU6174@frogsfrogsfrogs>
References: <20241231232503.GU6174@frogsfrogsfrogs>
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
Commits in this patchset:
 * xfs_io: display rtgroup number in verbose fsrefs output
 * xfs: add an ioctl to map free space into a file
 * xfs_io: support using XFS_IOC_MAP_FREESP to map free space
 * xfs_db: get and put blocks on the AGFL
 * xfs_spaceman: implement clearing free space
 * spaceman: physically move a regular inode
 * spaceman: find owners of space in an AG
 * xfs_spaceman: wrap radix tree accesses in find_owner.c
 * xfs_spaceman: port relocation structure to 32-bit systems
 * spaceman: relocate the contents of an AG
 * spaceman: move inodes with hardlinks
---
 configure.ac                    |    1 
 db/agfl.c                       |  297 +++-
 include/builddefs.in            |    1 
 include/xfs_trace.h             |    4 
 io/fsrefcounts.c                |   22 
 io/prealloc.c                   |   35 
 libfrog/Makefile                |    5 
 libfrog/clearspace.c            | 3294 +++++++++++++++++++++++++++++++++++++++
 libfrog/clearspace.h            |   79 +
 libfrog/fsgeom.h                |   29 
 libfrog/radix-tree.c            |    2 
 libfrog/radix-tree.h            |    2 
 libxfs/libxfs_api_defs.h        |    4 
 libxfs/libxfs_priv.h            |    9 
 libxfs/xfs_alloc.c              |   88 +
 libxfs/xfs_alloc.h              |    3 
 libxfs/xfs_fs.h                 |   14 
 m4/package_libcdev.m4           |   20 
 man/man2/ioctl_xfs_map_freesp.2 |   76 +
 man/man8/xfs_db.8               |   11 
 man/man8/xfs_io.8               |    8 
 man/man8/xfs_spaceman.8         |   40 
 spaceman/Makefile               |   11 
 spaceman/clearfree.c            |  171 ++
 spaceman/find_owner.c           |  442 +++++
 spaceman/init.c                 |    7 
 spaceman/move_inode.c           |  662 ++++++++
 spaceman/relocation.c           |  566 +++++++
 spaceman/relocation.h           |   53 +
 spaceman/space.h                |    6 
 30 files changed, 5953 insertions(+), 9 deletions(-)
 create mode 100644 libfrog/clearspace.c
 create mode 100644 libfrog/clearspace.h
 create mode 100644 man/man2/ioctl_xfs_map_freesp.2
 create mode 100644 spaceman/clearfree.c
 create mode 100644 spaceman/find_owner.c
 create mode 100644 spaceman/move_inode.c
 create mode 100644 spaceman/relocation.c
 create mode 100644 spaceman/relocation.h

