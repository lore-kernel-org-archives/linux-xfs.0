Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC44B3E5EC0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Aug 2026 11:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785755190; cv=none; b=YVI+agymSG/K3jYfoU4kPPbhfD9b+ufhkIA9fmAM2q1FkqnJBj0KOg93N5wWsKk7K+HNr4isRMY0VMeNKuRrEMY1ZWXKK9TfYkSHQJM0tDr9uxL+TKTnGyFEEZgwrfChFG90knN/+w7J7zqPdON9f1QuuEBleb3QFvrx1fwCg5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785755190; c=relaxed/simple;
	bh=4Uxw66PXU657E4Dp4Gy+1lz9r6Kwd5F9VB55gtXYk/g=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fSonN0d7G9kt1CS8oAdMERacUxD140upAb7TGQ22g2F4E6ut0Rfq7tKsGWzuBICk9dz+ifhvb/w0a9IndStjPz4JtKkQ0lsymFPAEcf4F1u5BQadm1Sc6b1dVSMWBsZx1urXCal7/ZNbcRGr2duVe5hAiewTYLSuK+PNi+ObPQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTDrLulK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTDrLulK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FA31F000E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Aug 2026 11:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755188;
	bh=/sjiY8ETfaKB74sjZ2dUrnAIIQjXNczRp4xbzOKxo00=;
	h=Date:From:To:Subject;
	b=kTDrLulKQxuN5FC7xeqXgcae4IZ/7GvIJImXthmhJPVIlrWGCEOvXmpr5PLsBPiPS
	 p/NeiU2EmUVOXnHYqfqZUIIl0Ynk9JumblC9/cIJ1ynV4RJI2O8j27tG1diljJQDZn
	 wZLPA6+zK9oVLSWsn3GAj5y1kQ6C/3U4UxaP9cGGeF25mzi0QO6qtaWXoH2xEgsnfO
	 9T3Y7ClPuPSnhBR+ZapQfveo0acJ4YeCuU9X6PzFBgvNKQc5Gbm6tdyXEaU70h56Mq
	 kkp03tBpYiIDsEVhVfRiUsltFZkl/2AoXyBhZmyhykYM4zwlN7RSeYa0eVC/SGzIem
	 t5yUWsCKWWxKQ==
Date: Mon, 3 Aug 2026 13:06:23 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 3708f6188677
Message-ID: <anB2FIBRQNaNRaan@andromeda.toxiclabs.cc>
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

	ssh://git@gitolite.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

3708f6188677 Merge branch 'xfs-7.2-fixes' into for-next

24 new commits:

Andrey Albershteyn (1):
      [fb082235c675] xfs: fix inverted clearance of inode junk flags

Carlos Maiolino (1):
      [3708f6188677] Merge branch 'xfs-7.2-fixes' into for-next

Christoph Hellwig (3):
      [63de19199342] xfs: add a separate bio_set for spliting GC writes
      [ec6978e6bf68] xfs: add a comment to describe xfs_gc_bio.victim_rtg
      [eb6b2cc1fc8a] xfs: check v5 superblock features early

Darrick J. Wong (16):
      [97efed1091a5] xfs: only check mergeability of bnobt records
      [5fc643fb8659] xfs: don't double-lock when deleting a self-referential directory
      [8af9cd79cdf6] xfs: don't return EFSCORRUPTED when scrubbing corrupt parent pointers
      [5ee37132ea81] xfs: don't zap the attr fork on repair when there are queued pptr updates
      [b1a296fc2241] xfs: nlink scrub must take IOLOCK before determining ILOCK state
      [0c88e10d12de] xfs: avoid UAF on sc->tempip in xrep_tempfile_create
      [7cdafd8f10eb] xfs: hoist per-bucket unlinked list check to helper
      [527eaaefddb6] xfs: don't livelock in scrub on a circular unlinked list
      [1e96a00e0d3a] xfs: don't walk off the end of a null sc->sa.agi_bp in AGI repair
      [6b9cd540138a] xfs: load next_agino from the correct xfarray in xrep_iunlink_relink_prev
      [5644fab990fc] xfs: pass runtime errors from xrep_iunlink_mark_ondisk_rec up to callers
      [2daf3ed5d059] xfs: check xfarray iteration errors when committing unlinked inode lists
      [68ab37650ce5] xfs: fix allocated inodes that show up in the unlinked list
      [6d67c6b99f1f] xfs: fix another iunlink infinite loop bug in online fsck
      [af146cb7ff8f] xfs: set the prev pointer when reinserting an inode on the unlinked list
      [005263352715] xfs: don't ignore runtime errors in xrep_iunlink_reload_next

Lin Jiapeng (1):
      [b2d5a81dae38] xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN

Long Li (2):
      [63320a0f70f6] xfs: fix ilock leak on error in xfs_dq_get_next_id
      [e2b4a856085e] xfs: don't swallow dquot recovery verification errors

Code Diffstat:

 fs/xfs/libxfs/xfs_exchmaps.c    |  10 +++
 fs/xfs/libxfs/xfs_sb.c          |   4 +-
 fs/xfs/scrub/agheader.c         |  96 +++++++++++++++++------
 fs/xfs/scrub/agheader_repair.c  | 169 +++++++++++++++++++++++++++++++++-------
 fs/xfs/scrub/alloc.c            |   5 +-
 fs/xfs/scrub/attr_repair.c      |   3 +-
 fs/xfs/scrub/dirtree_repair.c   |  22 +++++-
 fs/xfs/scrub/inode_repair.c     |   4 +-
 fs/xfs/scrub/nlinks.c           |  13 ++--
 fs/xfs/scrub/parent.c           |   2 +-
 fs/xfs/scrub/tempfile.c         |   1 +
 fs/xfs/scrub/trace.h            |   2 +
 fs/xfs/xfs_dquot.c              |   3 +-
 fs/xfs/xfs_dquot_item_recover.c |   2 +-
 fs/xfs/xfs_zone_gc.c            |  13 +++-
 15 files changed, 275 insertions(+), 74 deletions(-)
