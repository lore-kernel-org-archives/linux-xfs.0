Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E4D436BD9
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 07:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789112267; cv=none; b=Jg2aa5gVoODGx7AZ7DDM3rEzRHDwRrOEoqGqhE4czbddfq2azPH3OsH8iZte8um9P8qX5DuzU/FOHxZITUCcTnI1Klo9CyLZeCT2BbIwE9tB1UkMgHGVJk+Qen+ip33rQARTlOSDEZQbIxCpfy8XsQBjhxf4CpsucY9J+WMHihw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789112267; c=relaxed/simple;
	bh=MFkK2qe/qYWMAEc8p8bcmbjt+KnjAXO7DbrX9BEnbbo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XgYX5UukkM13y1Ee98490lBE717Z7eQ0FZWUBKLX7Y0hA3EOMw29Kr3veMgZIJiRiYB9ul6kIHbYXu13JJC64sjuMI1k8Ylc1XcJJzoztcJPKKz2RNZa81rrrKhMasA3rMlILAhLfLF2FQxt+FZcEkPZmTW+FVVLFLuOUaZU38U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NxT4qNT6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NxT4qNT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649081F000FF
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 07:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789112265;
	bh=goJ+JcCf7y0n9Hwp9X9aFFzrw4B06PrBPgb+e1jFhoA=;
	h=Date:From:To:Subject;
	b=NxT4qNT6GPuMR6hseXvetuClVQ8W9BoPrkqTmnEJc6MjZPXyh2OLi3SilyjtHJrFe
	 u1ezB7B67Bj0a0gYvxxJ/0IK7S6phEhjpyf+5RiZeIROP/achIrY4pzS9JDz9GtURo
	 HJa199BXDF9RCfCdMLklq5dusJNMWYT6XTTmt5yJJtL80XzHO0c2chJbukzdAEo4mC
	 VCpVAz5P9nWjVK2GEuyLs3aQa8VHC9rDuARuvxYiYQHi1g1ZywSkYgpkCsj9gwzMYy
	 0jh3EyJNBmdXg1WZUdQA43nJFAl38HFi16W9UhJosGzSESBa3VdiJNRCjEiDPZFd75
	 DdCghSXPttcpw==
Date: Fri, 11 Sep 2026 09:37:41 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next rebased to 4266ffdfd7cb
Message-ID: <aqOupMB38rMV7Nio@andromeda.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

This contains some repeated commits due the rebases from yesterday.
Also, giving the rebase was needed, I also rebased 7.4 queue on
for-next, which added a patch to the bottom of the stack.

The report below has been taken from the last fixes commit already
available in linux-next.
If nothing goes wrong from here or anything urgent appears. This is
the last state that will go to mainline on the next pull request.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

4266ffdfd7cb xfs: remove an extra cast in xfs_file_compat_ioctl

35 new commits:

Anuj Gupta (1):
      [50ba24ccb9a9] xfs: set IOMAP_F_INTEGRITY for zoned writes on integrity devices

Christoph Hellwig (20):
      [ad0033e2dbd3] xfs: also flush the RT device cache in xlog_write_iclog
      [c84455c683eb] xfs: don't continue on error in xfs_fsync
      [761e015e5a54] xfs: avoid extra cache flushes for multi-device file systems in xfs_fsync
      [ea089258eac7] xfs: convert all !XFS_RT stubs to inline functions
      [34b44966e46e] xfs: remove an outdated comment above xfs_file_ioctl
      [a641a01bf99d] xfs: rename xfs_ioc_swapext to xfs_swapext
      [97a669731739] xfs: rename xfs_ioctl_fs_counts to xfs_ioc_fs_counts
      [7de4def1bfe0] xfs: rename xfs_ioctl_getset_resblocks to xfs_ioc_getset_resblocks
      [fa5430828316] xfs: split out the handler for XFS_IOC_DIOINFO
      [b4a18a3e3c0f] xfs: split out the handlers for XFS_IOC_.*HANDLE
      [ff769de84457] xfs: split out the handler for XFS_IOC_SWAPEXT
      [be985a993115] xfs: split out the handlers for XFS_IOC_FSGROWFS*
      [ce6573a5a2fa] xfs: split out the handler for XFS_IOC_GOINGDOWN
      [4af1c139fee7] xfs: split out the handler for XFS_IOC_ERROR_INJECTION
      [b9638c7afc5d] xfs: split out the handler for XFS_IOC_FREE_EOFBLOCKS
      [8cd2a2124a00] xfs: split out the handlers for XFS_IOC_FSGROWFS_*_32
      [ac5bbdbf7261] xfs: cleanup XFS_IOC_GETVERSION_32 handling
      [b6e5528433b3] xfs: split out the handlers for XFS_IOC_SWAPEXT_32
      [f2602bd55824] xfs: split out the handlers for XFS_IOC_*_BY_HANDLE_32
      [4266ffdfd7cb] xfs: remove an extra cast in xfs_file_compat_ioctl

Darrick J. Wong (13):
      [568a1588b906] xfs: snapshot scrub stats when rendering them
      [0ae61c331ec5] xfs: report healthy filesystem events in scrub stats
      [d3dc979a49df] xfs: report runtime failures in scrub
      [341f03865d07] xfs: remove redundant function declaration
      [3466dfef0a20] xfs: snapshot old AGFL before rewriting it
      [eaf580538eb1] xfs: bail out on bitmap errors in xrep_agfl_fill
      [4d3c07591534] xfs: fix under-reservation of blocks when repairing sf directories
      [1ee2ce797c36] xfs: actually check internal-rtdev fields in the superblock
      [3bdbf472a608] xfs: fix rtrmap cross-referencing elision logic
      [d3a6a35a2206] xfs: fix termination logic in xchk_bmap
      [e854f9a28b1f] xfs: fix replaying dirent removals into the temporary directory
      [69e10c2b4a51] xfs: reset parent pointer args before each dir tree unlink repair
      [ad4497a92cab] xfs: advance the findparent inode scan cursor while holding ILOCK

Deepanshu Kartikey (1):
      [e240919ca727] xfs: take hm->lock in xfs_ioc_health_monitor() before insert

Code Diffstat:

 fs/xfs/libxfs/xfs_da_btree.c   |   2 +-
 fs/xfs/libxfs/xfs_da_btree.h   |   2 +
 fs/xfs/scrub/agheader.c        |   7 +
 fs/xfs/scrub/agheader_repair.c |  39 +++--
 fs/xfs/scrub/attr_repair.c     |   2 +-
 fs/xfs/scrub/bmap.c            |   7 +-
 fs/xfs/scrub/dabtree.h         |   2 -
 fs/xfs/scrub/dir_repair.c      |   4 +-
 fs/xfs/scrub/dirtree_repair.c  |   1 +
 fs/xfs/scrub/findparent.c      |  54 ++++--
 fs/xfs/scrub/stats.c           |  45 +++--
 fs/xfs/scrub/tempfile.c        |  29 +++-
 fs/xfs/xfs_file.c              |  47 ++---
 fs/xfs/xfs_healthmon.c         |   2 +
 fs/xfs/xfs_ioctl.c             | 385 ++++++++++++++++++++++++-----------------
 fs/xfs/xfs_ioctl.h             |   4 +-
 fs/xfs/xfs_ioctl32.c           | 188 +++++++++++---------
 fs/xfs/xfs_iomap.h             |   2 +
 fs/xfs/xfs_log.c               |  45 +++--
 fs/xfs/xfs_log_cil.c           |   7 +-
 fs/xfs/xfs_rtalloc.h           |  49 +++++-
 21 files changed, 564 insertions(+), 359 deletions(-)
