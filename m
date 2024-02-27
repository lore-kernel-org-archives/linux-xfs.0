Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90E4199B4
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000314; cv=none; b=VyBzFnVhwcJhAosrqF+TAlN/nkuOifx/9COjRal2N12Z4IxfRiIMD5SGixpSgLgLJ/TcjjUDh59xnvkigdoT/Ws0ryhIPESt/PETefSLAcwSZArolAopz+OMoX8snTZu6Z1Z36V5WYtL+kfT+bAbi9boy60USbAysakLAp5SPz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000314; c=relaxed/simple;
	bh=DVg6On9+pk45MOhiwriWFVA6O1aLj1EXbQXBv2quZ2A=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=TSxXEeiJIPfSGdbBmrd/HOeWmEwe8aix3moCE9LiyhGTu2uCb2j20PUghI1/H6N7GYLD/MosBcod/C6zxlcqL4HdX8b9wRIhjchPbbJtkVcu2f2cb1boznTmf97mCASEo5Yc9q8H9j9RHDLxShsiSqvbaERggZFMwu/00WoKsKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jcAVbHn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jcAVbHn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B004EC433F1;
	Tue, 27 Feb 2024 02:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000314;
	bh=DVg6On9+pk45MOhiwriWFVA6O1aLj1EXbQXBv2quZ2A=;
	h=Date:Subject:From:To:Cc:From;
	b=jcAVbHn0WUGsM6hkL5tkDk8xjkwxK/mSd7U/DY/WrIBx8Ur5+PLsnM8WJUjHKEKQ6
	 fjTDULOz1B+bre3Ev6ZU+HNB0a4owxU/HaAGeWWrnSsJwrhgooWCYK8uZHrEesfdVJ
	 lIzFLBQ2jH0mu3ahZ63fkfFND4dd9eZQECOuUlkpL3az5iqoXIOjDVC8KQrd6RsJan
	 atMo/r/pYIvMIxmIp30CuGMWxxgB1K4UHq7fnhibQrz773rvfV2vipdGYge5pvcLE6
	 ixIt3Y0+WPqLAp9VKeQEAC4DwI/ZlbYAAmAHaT8fkUxLfOvzB02Kge6uj038ZZGgFX
	 CiFhOheBtKNHg==
Date: Mon, 26 Feb 2024 18:18:34 -0800
Subject: [PATCHSET v29.4 09/13] xfs: online repair of directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900014444.939516.15598694515763925938.stgit@frogsfrogsfrogs>
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
Commits in this patchset:
 * xfs: online repair of directories
 * xfs: scan the filesystem to repair a directory dotdot entry
 * xfs: online repair of parent pointers
 * xfs: ask the dentry cache if it knows the parent of a directory
---
 fs/xfs/Makefile              |    3 
 fs/xfs/scrub/dir.c           |    9 
 fs/xfs/scrub/dir_repair.c    | 1404 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/findparent.c    |  451 +++++++++++++
 fs/xfs/scrub/findparent.h    |   50 +
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
 20 files changed, 2418 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/dir_repair.c
 create mode 100644 fs/xfs/scrub/findparent.c
 create mode 100644 fs/xfs/scrub/findparent.h
 create mode 100644 fs/xfs/scrub/parent_repair.c

