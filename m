Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3556C3A9D9D
	for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2026 09:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861401; cv=none; b=jyVuBF/vyN2qmmvcU5TwD2uX5sZWBq5YhLe6vOJ6p8WrZh6t8g7zb6EX5qYej1Sp6jHiaqyOmXJmkJLbfZ1lUG7aenpOEQsPHU9JnxT5WmToTBI1vooWH3MJObzrjpWcuuD/g8FCByem3CqnmpLIi8YE0UFPYOkJewyRvXQhGD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861401; c=relaxed/simple;
	bh=R7lM5Zosd5nHml3Ck2ZtjqjjJo30clynol9/wSMRJZA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rbDQCr87r87btgP03aX7Zw6HsW7E0i/167xdA0ldCmpzeAmbUCRlCExyZb0D5JfTCCAsmRyPfNn6XNvvqkoNVH42luaHMkuS0F/UvvoxQfWFZetCXaJZarp1zsbXO1bJa3u9Z0BPNXH9gUtGYtQqmqT3h0EEnY0whNpchTfaz4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FMhkzw7d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FMhkzw7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBFC1F00A3A;
	Tue,  8 Sep 2026 09:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788861399;
	bh=NnxIZRcH4bFmJ5w8n8oQ8jBuVF6xVnG6H0/K2qK+sKI=;
	h=Date:From:To:Cc:Subject;
	b=FMhkzw7dC/l0Sc4PGn6J7AVOMRHqKxuXlzglzFEE1P93y/bmr6DMzI7dsSnKoxdb+
	 cPteTWtm/mx4y58yOsxqlvpmtl6xt60yhghmUu8lIcu2SqcguDU6vrlLJaMse19gE2
	 jPEVcHpZ1lP68II+cfi90NXYRqbMh1P4WDhGubdHAR20BfnsCC/tsOr8SHWNZbd/cU
	 YrNCzCqKkJ+94CSROxu9139GNGqeGoVAezbeeEg++DFEOGmrKs9zAale2CCP6Pd7Kh
	 4tG/U4a0fTgRs+eTfzUe0Ih61UJvkzjVHEtnp6+d5fC1ocaiOTDLQ9LGendVTHRTC1
	 KuX+iPHAe9ozw==
Date: Tue, 8 Sep 2026 11:56:33 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, bestswngs@gmail.com, brauner@kernel.org, 
	cem@kernel.org, chuck.lever@oracle.com, cmaiolino@redhat.com, 
	dawei.feng@seu.edu.cn, djwong@kernel.org, gaoyingjie@uniontech.com, 
	hans.holmberg@wdc.com, hch@lst.de, jiapenglin@tencent.com, roland.mainz@nrubsig.org, 
	sandeen@redhat.com, xmei5@asu.edu
Subject: [ANNOUNCE] xfsprogs: for-next updated to 643a5d8ffd76
Message-ID: <ap_bvOk1MuYh3VBZ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

643a5d8ffd766ab2b4837144f230d2a51048f97b

New commits:

Andrey Albershteyn (1):
      [4f927c6d2dab] xfs: fix null pointer dereference in tracepoint

Christoph Hellwig (17):
      [7bfd7d172384] xfs_db: improve the fsmap man page entry
      [3febcf8307d6] xfs: add a XFS_INODE_TO_AGNO helper
      [41023f3078bc] xfs: add a XFS_INODE_TO_AGINO helper
      [0025466aebf4] xfs: add a XFS_INO_TO_FSB helper
      [c46b610bf32c] xfs: add a xfs_rmap_inode_bmbt_owner
      [d6d344c41f52] xfs: add a xfs_rmap_inode_owner helper
      [cb4d9f4a55d8] xfs: remove the i_ino field in struct xfs_inode
      [4c95910197bb] xfs: cleanup xfs_imap
      [ea1901a24f7f] xfs: remove im_len field in struct xfs_imap
      [2f3f536cb02f] xfs: massage xfs_imap_to_bp into xfs_read_icluster
      [d8268ecd7d81] xfs: store an agbno in struct xfs_imap
      [bcb506336f9c] xfs: mark struct xfs_imap as __packed
      [7dce29be4422] xfs: pass back updated nb from xfs_growfs_compute_deltas
      [fbd9f710190a] xfs: cleanup xfs_growfs_compute_deltas
      [1c461401d63c] xfs: move XFS_LSN_CMP to xfs_log_format.h
      [468400494950] xfs: check v5 superblock features early
      [cff14b3bd2bb] xfs_io: cleanup headers

Chuck Lever (1):
      [54d45f9bedfe] xfs: Report case sensitivity in fileattr_get

Darrick J. Wong (2):
      [9595e21992a8] libxfs: convert diff_items helpers to cmp_int
      [85cd98501769] xfs: fix pointer arithmetic error on 32-bit systems

Dawei Feng (1):
      [c2e1a925e98f] xfs: fix memory leak in xfs_dqinode_metadir_create()

Eric Sandeen (1):
      [643a5d8ffd76] mkfs: Emit a clearer message if too-small log is due to AG geometry

Hans Holmberg (1):
      [ba7c0e339296] libxfs: report device open errors during topology probing

Lin Jiapeng (1):
      [8d5bb64656fe] xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN

Xiang Mei (1):
      [4efde4fd2a12] xfs: fix off-by-one in rtrefcount btree root level validation

Yingjie Gao (1):
      [7885cad313d0] xfs: fix exchmaps reservation limit check

Code Diffstat:

 db/attrset.c                  |   2 +-
 db/bmap_inflate.c             |   4 +-
 db/dquot.c                    |   2 +-
 db/iunlink.c                  |  13 ++--
 db/namei.c                    |  14 ++--
 db/rdump.c                    |   2 +-
 include/linux.h               |  17 +++++
 include/xfs_inode.h           |   7 +-
 include/xfs_trans.h           |  18 -----
 io/init.h                     |  10 +--
 io/io.h                       | 158 +++++++++++++++++++++---------------------
 libxfs/defer_item.c           |   8 +--
 libxfs/inode.c                |   8 +--
 libxfs/iunlink.c              |   4 +-
 libxfs/libxfs_api_defs.h      |   2 +-
 libxfs/listxattr.c            |   4 +-
 libxfs/logitem.c              |  17 +++--
 libxfs/topology.c             |   8 ++-
 libxfs/util.c                 |   2 +-
 libxfs/xfs_ag.c               |  42 ++++++-----
 libxfs/xfs_ag.h               |   5 +-
 libxfs/xfs_attr.c             |   2 +-
 libxfs/xfs_attr_leaf.c        |   2 +-
 libxfs/xfs_bmap.c             |  20 +++---
 libxfs/xfs_bmap_btree.c       |   8 +--
 libxfs/xfs_bmap_btree.h       |   2 +-
 libxfs/xfs_btree.c            |  18 +++--
 libxfs/xfs_btree_staging.c    |   2 +-
 libxfs/xfs_da_btree.c         |   2 +-
 libxfs/xfs_defer.c            |   2 +-
 libxfs/xfs_dir2.c             |  44 ++++++------
 libxfs/xfs_dir2_node.c        |   2 +-
 libxfs/xfs_dir2_sf.c          |   4 +-
 libxfs/xfs_dquot_buf.c        |  14 +++-
 libxfs/xfs_exchmaps.c         |  20 ++++--
 libxfs/xfs_format.h           |   6 ++
 libxfs/xfs_ialloc.c           |  90 ++++++++++--------------
 libxfs/xfs_inode_buf.c        |  24 +++----
 libxfs/xfs_inode_buf.h        |  13 ++--
 libxfs/xfs_inode_fork.c       |   6 +-
 libxfs/xfs_inode_util.c       |  15 ++--
 libxfs/xfs_log_format.h       |  13 ++++
 libxfs/xfs_metadir.c          |   2 +-
 libxfs/xfs_parent.c           |   8 +--
 libxfs/xfs_parent.h           |   2 +-
 libxfs/xfs_rmap.c             |   6 +-
 libxfs/xfs_rmap.h             |   4 ++
 libxfs/xfs_rtbitmap.c         |   4 +-
 libxfs/xfs_rtrefcount_btree.c |   8 +--
 libxfs/xfs_rtrmap_btree.c     |   4 +-
 libxfs/xfs_sb.c               |   6 +-
 libxfs/xfs_symlink_remote.c   |   6 +-
 man/man8/xfs_db.8             |  16 ++++-
 mkfs/proto.c                  |  16 ++---
 mkfs/xfs_mkfs.c               |  19 ++++-
 repair/bmap_repair.c          |  12 ++--
 repair/bulkload.c             |   2 +-
 repair/phase6.c               | 128 +++++++++++++++++-----------------
 repair/pptr.c                 | 100 +++++++++++++-------------
 repair/quotacheck.c           |   8 +--
 repair/rt.c                   |   6 +-
 repair/rtrefcount_repair.c    |   2 +-
 repair/rtrmap_repair.c        |   2 +-
 repair/xfs_repair.c           |   2 +-
 64 files changed, 543 insertions(+), 476 deletions(-)

-- 
- Andrey
