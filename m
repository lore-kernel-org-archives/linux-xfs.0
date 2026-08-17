Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966963BBFDA
	for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2026 07:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786953429; cv=none; b=n4DiaDwuiJZxu6T3V9FPn7LjRAvx09pKlICSNKE6UvDazmB08JUWTxjmOdmhjCbTdBcUvarg0ougoEzCAhjWpVt19lXLTwe9PeSYWyMoUDfWHAaPl1nQ8yATML1mW8bwMLZOsZhjYFFr1vK9klKw0uLx/+CP5XoEQoHspHeoM90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786953429; c=relaxed/simple;
	bh=9q2WPyq3lpX0dK5ka8SFjmqkASnkFeZrkJX9kYzSIF4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nRtY6tzJKV+7od2oc94YrOiL8OvhGrr2vjP5guco/CvqLpf6XIIMcU+9HligKyzUIBTdnP1SzOXGD5ERhiUuBOso6NLtskccEBO+ivuyh3S1UMBNUxm0FJXe55dIvfhu3vPWle7bqjhQJiBn4fdmMeAbuizPRL7463Gvs7VGBrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rz1MpXPk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rz1MpXPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8D11F000E9;
	Mon, 17 Aug 2026 07:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786953428;
	bh=evuGia/mexn4f+s2231YFd4sRxo+X5U55rYxN5/BKR8=;
	h=Date:From:To:Cc:Subject;
	b=Rz1MpXPkrx0RHzMRBz4heO4Lk53rBECw8l0elOBKVbUxXvQKrF16nq0OXQrPbxeO7
	 BWX0kUVrb+3gVttZapwtYjhzNgY+JO22XzasjUhNXt39lBozp+cKai0vXDeuZfTKRF
	 MuURCSO/WEENlmrr/FGw8BbbYuvjnEjJj35xO7rO95WygyXmjslbVYZ6cvp9ddqYPQ
	 9kbJENzKlVGPIFKHE1z9Z2K7j9I+CqlGA9dlsNz2oA3ejHBNol/V1fI6V6k0PDtyiv
	 eEhKccj6Ky69wN+at0vZWEoHjSnOCGGd2FeMCmSfjC5N5td32FNxKVWy6f+WEwgS8/
	 xePoXFVXXGYjg==
Date: Mon, 17 Aug 2026 09:57:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: New code for v7.3
Message-ID: <aoK5ypb3oTVLlhFf@andromeda.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT has been successful.

There are no big standing out features on this window, so this mostly
consists on bug fixes and code refactoring. The only user visible
change that stands out is the support for FALLOC_FL_WRITE_ZEROES added
to this.

Thanks,
Carlos

"The following changes since commit b28d23c51635b646784a2a62c71ba99458c07d5e:

  xfs: mark nonzero sb_gquotino as corrupt on metadir filesystems (2026-07-22 15:06:25 +0200)

are available in the Git repository at:

  git://git.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.3

for you to fetch changes up to b7eea80be25f3334f131d52982b3131aba77b97d:

  xfs: validate attr entry pointer before field access (2026-08-10 08:51:30 +0200)

----------------------------------------------------------------
xfs: new patches for Linux 7.3

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (12):
      xfs: don't get a pag reference in xfs_buf_get_map
      xfs: consolidate buffer locking in xfs_buf_get_map
      xfs: split out a lower-level xfs_buf_get_map helper from xfs_find_get_buf
      xfs: remove spurious XBF_DONE clearing on readahead validation failure
      xfs: remove _XBF_LOGRECOVERY
      xfs: hide b_flags manipulation from code outside of xfs_buf.c
      xfs: use WRITE_ONCE to update b_flags
      xfs: don't reverify buffers in xfs_buf_readahead_map
      xfs: use goto based error unwinding in xfs_buf_read_map
      xfs: merge xfs_buf_reverify into xfs_buf_read_map
      xfs: move buffer locking out of xfs_find_get_buf
      xfs: add lockless xfs_buf_readahead_map fast path

Cihan Karadag (1):
      xfs: use kmalloc_objs() instead of kmalloc() in xfs_da_grow_inode_int

Hongling Zeng (3):
      xfs: use file target for post-log fsync fallback flush
      xfs: check split_sectors validity before bio_split call
      xfs: validate attr entry pointer before field access

Johannes Thumshirn (4):
      xfs: add xfs_metadir_create_file helper
      xfs: create quota metadir inodes using xfs_metadir_create_file
      xfs: create rtgroup metadir inodes using xfs_metadir_create_file
      xfs: mark internal metadir file creation helpers static

Pankaj Raghav (2):
      xfs: add an allocation mode to xfs_alloc_file_space()
      xfs: add support for FALLOC_FL_WRITE_ZEROES

Yun Zhou (1):
      xfs: restore nofs context unconditionally in xfs_trans_roll

 fs/xfs/libxfs/xfs_attr_leaf.c     |  14 ++
 fs/xfs/libxfs/xfs_btree_staging.c |   7 +-
 fs/xfs/libxfs/xfs_da_btree.c      |   3 +-
 fs/xfs/libxfs/xfs_dquot_buf.c     |  47 ++---
 fs/xfs/libxfs/xfs_ialloc.c        |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c     |  15 +-
 fs/xfs/libxfs/xfs_metadir.c       |  64 ++++---
 fs/xfs/libxfs/xfs_metadir.h       |   8 +-
 fs/xfs/libxfs/xfs_rtgroup.c       |  58 +++---
 fs/xfs/xfs_bmap_util.c            |  42 +++-
 fs/xfs/xfs_bmap_util.h            |   7 +-
 fs/xfs/xfs_buf.c                  | 392 ++++++++++++++++++++------------------
 fs/xfs/xfs_buf.h                  |   8 +-
 fs/xfs/xfs_buf_item.c             |  10 +-
 fs/xfs/xfs_buf_item_recover.c     |   3 -
 fs/xfs/xfs_dquot_item_recover.c   |   1 -
 fs/xfs/xfs_file.c                 | 118 ++++++++++--
 fs/xfs/xfs_fsops.c                |   2 +-
 fs/xfs/xfs_inode.c                |   4 +-
 fs/xfs/xfs_inode_item_recover.c   |   1 -
 fs/xfs/xfs_log_recover.c          |   5 +-
 fs/xfs/xfs_trace.h                |   2 +-
 fs/xfs/xfs_trans.c                |  16 +-
 fs/xfs/xfs_trans_buf.c            |   7 +-
 fs/xfs/xfs_zone_gc.c              |   2 +-
 25 files changed, 492 insertions(+), 346 deletions(-)"
