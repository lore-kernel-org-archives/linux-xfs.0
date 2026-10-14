Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5EF3AD51C
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 08:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791967020; cv=none; b=OB/V+ro3ptBtJ0EbMTQNoGDLOsVYl7ylPH4xglTgTbOK0zS5ybXqFl1Rqjuslh64UGPm3nXbqr8/phfU42fcCu6DOyo6z9D8sbQeK3PK87Q9ksdLetwHGjZtRML8YKFOcU04Uo0hods/asZEkBBrltXFF/z/1cXUYJmMlhTsFLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791967020; c=relaxed/simple;
	bh=TsSjxnCgCqvqyPy8NbmnVIEFL0TZOLvBrxNAZ2dq4xQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VWj6wkl7ggKI5sauLdIQguRKgjVyyyx6wNwTAvgsUkI/vS3hCcdulZRyZFzuDvB2gifgd6x2aUIkIegQiSmxIzooKwXGKEyifA6nZFes7yC0Cgc2LuPdnCZi/NPPsMTuVPl2rn2mZ7uOQvbFf0eK5M34i8RD/yRtfTWyghtI2XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZoJxAcJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZoJxAcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E783E1F00893
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 08:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791967019;
	bh=aYgzekYRUh127/aUQSu4DDdVDCaVxNFxUA0Z/F+PfwU=;
	h=Date:From:To:Subject;
	b=RZoJxAcJHn2AbgSY4igduCiqq/cCPu+8SyUr45UHaywG2FjGT2Cfz3y6uDlf1l471
	 EJJeoQd+BIthi/GPTvaKbeaQUmj5/zztyf9P2TOEqPgKGLU9aOvK930t/w8elFKplG
	 7e48Atws35IIKTFqEmNxDsNFyh/o9WlBUILLg/gu5x+w4bY+RFj3/JC/ZH7UXo/jrG
	 VYX0zg7bl5H/leasq4LYAIQZeBJqgBRskwD+ZFPHcK9xXqwU34HG4h9Ds/nGvU5hpR
	 y4mZkP9PJg+B6pfOpOJWwnKZJ8PsYfEiX20fn/9UbZQ689GNONrTns0RBrQOWqpYEl
	 yZ9i78D4/jV2w==
Date: Wed, 14 Oct 2026 10:36:56 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to ec8f62cc109a
Message-ID: <as8-sepzHF-WC3n2@nidhogg.toxiclabs.cc>
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

	git.kernel.org:/pub/scm/fs/xfs/xfs-linux.git

has just been rebased.

The rebase just remove a couple patches from for-next that are already
merged with different hashes, everything below is new...

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

ec8f62cc109a xfs: don't limit software atomic writes by the group alignment

41 new commits:

Christoph Hellwig (1):
      [90388d46b08a] xfs: handle NULL open_zone for merged ioends in xfs_end_ioend_write_zoned

Darrick J. Wong (37):
      [1fc241cdeab2] xfs: check for termination during rmap btree walk
      [4439b626fb51] xfs: don't subtract excess usage twice when computing agf_btreeblks
      [4582327e7068] xfs: abort directory tree repair whenever dl->aborted is set
      [2f528e4a8f89] xfs: reattach dquots after changing inode ids
      [ddf4fe30c3fd] xfs: never reset the default quota timer
      [6f2792720673] xfs: fix correction of unwritten extents in quota file data fork
      [ce9098338a7e] xfs: always report inode repair setup failures
      [73b7276b8a4b] xfs: range-check bc_levels array access in scrub tracepoints
      [fd0129556418] xfs: reject absurdly large xattr value lengths in xchk_xattr_actor
      [9eb04a6d41c7] xfs: break out xattr entry checks into separate functions
      [91c41f952490] xfs: check for buffer overruns when examining local/remote xattr entries
      [00f32fdf5498] xfs: clarify various parts of the bitmap API
      [e09438cab72c] xfs: complain loudly when dirtree checker finds broken links
      [c28b4b48deac] xfs: don't overrun incore inode when cleaning attr forks
      [147f9f8300cb] xfs: fix data fork block count check in xrep_inode_blockcounts
      [ca12256b7f98] xfs: avoid oversized space allocations when regenerating metadata
      [80f13dc7225e] xfs: reduce new btree slack factor if free space is negative
      [219ff8a734d8] xfs: don't queue rmap update twice when reaping a fork
      [634b63baf050] xfs: only written file data blocks can be shared
      [95e213c1ddb4] xfs: check for fragments when full-extent sharing matches
      [3978b1f3109d] xfs: don't clear COWEXTSIZE on directories on reflink filesystems
      [eb20a959760c] xfs: clear set[ug]id mode bits when zapping attr fork
      [4ce244b234c2] xfs: opportunistically skip btree block checks
      [1ccc8f553d88] xfs: always report scrub errors in tracepoints
      [03ce4ca43c00] xfs: don't scan across metadata/regular directory trees for dirents
      [c9f98b0f4f70] xfs: don't set a metadata directory's parent to sb_rootino
      [18028768415e] xfs: don't rescan ifree and icount when frozen
      [47b1e941bb55] xfs: rescan the AGs if incore delalloc counter is negative
      [6e82b7641889] xfs: don't try to repair rtsummary if the summary file isn't computed
      [9d9ea6e6cbc4] xfs: update quota flags on secondary supers when metadir enabled
      [19b5653cc870] xfs: refactor directory data block walking loops in scrub
      [5d470234d04d] xfs: improve dirent bounds checking in scrub and repair
      [a55686b2f505] xfs: drop unnecessary sa parameter from the xrep_ag init functions
      [ec72fccbc852] xfs: drop unnecessary sr parameter from xrep_rtgroup init functions
      [49869d5d0356] xfs: drop unnecessary sa parameter from xchk_ag init functions
      [02c8e8d78792] xfs: drop unnecessary sr parameter from xchk_rtgroup init functions
      [ce58cff1077d] xfs: refactor inode forkoff to byte conversions

Eric Sandeen (2):
      [5beb41df46f2] xfs: add missing cursor status check after xfs_inobt_get_rec
      [b47fb1ed0221] xfs: add missing cursor stat checks after xfs_btree_delete

Pankaj Raghav (1):
      [ec8f62cc109a] xfs: don't limit software atomic writes by the group alignment

Code Diffstat:

 fs/xfs/libxfs/xfs_attr_leaf.c    |  12 +--
 fs/xfs/libxfs/xfs_bmap.c         |   4 +-
 fs/xfs/libxfs/xfs_bmap.h         |   6 ++
 fs/xfs/libxfs/xfs_format.h       |   6 +-
 fs/xfs/libxfs/xfs_ialloc.c       |  32 ++++++--
 fs/xfs/libxfs/xfs_inode_buf.c    |   4 +-
 fs/xfs/libxfs/xfs_inode_util.c   |   2 +-
 fs/xfs/scrub/agheader.c          |  16 ++--
 fs/xfs/scrub/alloc_repair.c      |  15 ++--
 fs/xfs/scrub/attr.c              | 108 +++++++++++++++++++++------
 fs/xfs/scrub/attr_repair.c       |  16 +++-
 fs/xfs/scrub/bitmap.c            |  20 +++++
 fs/xfs/scrub/bmap.c              |  13 ++--
 fs/xfs/scrub/bmap_repair.c       |  15 ++--
 fs/xfs/scrub/btree.c             |  20 ++++-
 fs/xfs/scrub/common.c            |  57 ++++++++------
 fs/xfs/scrub/common.h            |  46 +++++-------
 fs/xfs/scrub/cow_repair.c        |  12 +--
 fs/xfs/scrub/dabtree.c           |   6 +-
 fs/xfs/scrub/dir.c               | 110 ++++++++++++++++++++++++---
 fs/xfs/scrub/dir_repair.c        | 109 +++++++++++++++++++++------
 fs/xfs/scrub/dirtree.c           |   4 +-
 fs/xfs/scrub/dirtree_repair.c    |   9 +++
 fs/xfs/scrub/fscounters.c        |  26 ++++++-
 fs/xfs/scrub/ialloc_repair.c     |   4 +-
 fs/xfs/scrub/inode.c             |   8 +-
 fs/xfs/scrub/inode_repair.c      | 156 +++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/newbt.c             |  19 +----
 fs/xfs/scrub/newbt.h             |   1 -
 fs/xfs/scrub/parent_repair.c     |   4 +
 fs/xfs/scrub/quota_repair.c      |  28 ++++++-
 fs/xfs/scrub/reap.c              |   4 +-
 fs/xfs/scrub/refcount.c          |  17 ++++-
 fs/xfs/scrub/refcount_repair.c   |   4 +-
 fs/xfs/scrub/repair.c            |  23 +++---
 fs/xfs/scrub/repair.h            |  13 ++--
 fs/xfs/scrub/rgsuper.c           |   4 +-
 fs/xfs/scrub/rmap_repair.c       |   8 +-
 fs/xfs/scrub/rtbitmap.c          |   4 +-
 fs/xfs/scrub/rtbitmap_repair.c   |   4 +-
 fs/xfs/scrub/rtrefcount.c        |   8 +-
 fs/xfs/scrub/rtrefcount_repair.c |   8 +-
 fs/xfs/scrub/rtrmap.c            |   4 +-
 fs/xfs/scrub/rtrmap_repair.c     |  12 +--
 fs/xfs/scrub/rtsummary.c         |  13 +++-
 fs/xfs/scrub/rtsummary.h         |   1 +
 fs/xfs/scrub/rtsummary_repair.c  |   2 +-
 fs/xfs/scrub/scrub.c             |   6 +-
 fs/xfs/scrub/trace.c             |  13 ++++
 fs/xfs/scrub/trace.h             |  10 +--
 fs/xfs/xfs_inode.h               |  11 ++-
 fs/xfs/xfs_ioend.c               |  16 ++--
 fs/xfs/xfs_iops.c                |  30 ++++++--
 fs/xfs/xfs_mount.c               |  44 ++++++++---
 fs/xfs/xfs_mount.h               |   2 +
 fs/xfs/xfs_qm.c                  |  36 ++++++++-
 fs/xfs/xfs_quota.h               |   9 +++
 57 files changed, 904 insertions(+), 290 deletions(-)
