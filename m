Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464AB379982
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 07:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780990043; cv=none; b=WYEqFYNte19eYLyHFZk4VX31+zZCp79caCJE5wxpI+/fkbM72LmY0hY0CHGXbb+rNOk3uBgxRtdBL6fw9FjEyMBbTWcKJaxrLIq/mxOVJjzMtOjgytbMvSWN/dRZBkI5AWf3SV9b7EHuC8Zl2lgJmtSL8iM/Q/5okMyGJAJtEoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780990043; c=relaxed/simple;
	bh=UiaeyEo38fwR9zPYCAAqcsTclaolQi2RtIq9tTENC2o=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pfg2xCs3c6t+6cg7oeOTJTQHD5clTPDSE3y05j1IkivGapq9bfLQ1kgOXRhcejiORGGKJXcdY8wEOjXTS1M+HbW6DHmqeISxs9LA0x6BCHlprO1DwC+/Ly1sav5vxN0nsunNtoC+iDn4tGZ3l0Xgm4zfS4pl5DNSxtrgF47Aq1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aU5uJ6e7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aU5uJ6e7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A5F1F00893
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 07:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780990042;
	bh=f9Ic5n2bCb7Keedlyf8/JtzA4WEKqJZ4Ad9GLYV3QWo=;
	h=Date:From:To:Subject;
	b=aU5uJ6e7gnNEN7B+wTLbnYv9acyNR7zeyMF+e8tKU4fYG1JFg31QfCOOHR5t3KNCC
	 UKJDwGTBjfkQgIAHK31Sd/OFkTD++KAlIdttoqBq2KI2QPZxT/39IpdUNxwA6jPyUE
	 WRZar18YwpZBrTLpCfQAQ898PWkfMTzw/4LG9jam3bMGh90/ddejImpTjEcfOO04wY
	 2hbL+vlYIXHvmd0mlxnuugEUitcJk/D8K93K1ZH0tPov/w+CAyXDEF36wr5rb+9TYe
	 27sRFnvJRFK4wpIKMuDZyvRSrXeTkjsIsGzxzheFyA+sW2V41yBdtG5/IzSNmXpCdH
	 IEGfNtpI9JUXw==
Date: Tue, 9 Jun 2026 09:27:18 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 4f16139d8e29
Message-ID: <aifAO0O0_ZDUIpbn@nidhogg.toxiclabs.cc>
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

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

4f16139d8e29 xfs: mark struct xfs_imap as __packed

18 new commits:

Alexey Nepomnyashih (1):
      [03866d130ed3] xfs: fix unreachable BIGTIME check in dquot flush validation

Christoph Hellwig (16):
      [610c08cbe79b] xfs: drop the experimental warning for the zoned allocator
      [a22166add624] xfs: add a XFS_INODE_TO_AGNO helper
      [f46edc9f1310] xfs: add a XFS_INODE_TO_AGINO helper
      [f8b7c9a8b0a9] xfs: add a XFS_INO_TO_FSB helper
      [ee237a900cee] xfs: add a xfs_rmap_inode_bmbt_owner
      [f882fc7dd9f0] xfs: add a xfs_rmap_inode_owner helper
      [aa7cfdb6e16b] xfs: add a xchk_ip_set_corrupt helper
      [bef4cee25fbc] xfs: convert xchk_inode_xref_set_corrupt to xchk_ip_xref_set_corrupt
      [79c1363d33c1] xfs: remove xfs_setup_existing_inode
      [1113a6d6d5d1] xfs: remove the i_ino field in struct xfs_inode
      [f8e9350fff08] xfs: remove the call to xfs_buf_reverify in xfs_trans_read_buf_map
      [41397e7ca8a0] xfs: cleanup xfs_imap
      [33451947c4f0] xfs: remove im_len field in struct xfs_imap
      [caffb4252cf1] xfs: massage xfs_imap_to_bp into xfs_read_icluster
      [9b64ca202f36] xfs: store an agbno in struct xfs_imap
      [4f16139d8e29] xfs: mark struct xfs_imap as __packed

Yingjie Gao (1):
      [0a5213bbff62] xfs: fix exchmaps reservation limit check

Code Diffstat:

 fs/xfs/libxfs/xfs_attr.c             |   2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c        |   2 +-
 fs/xfs/libxfs/xfs_bmap.c             |  20 +++---
 fs/xfs/libxfs/xfs_bmap_btree.c       |   8 +--
 fs/xfs/libxfs/xfs_btree.c            |  18 +++--
 fs/xfs/libxfs/xfs_btree_staging.c    |   2 +-
 fs/xfs/libxfs/xfs_da_btree.c         |   2 +-
 fs/xfs/libxfs/xfs_dir2.c             |  44 ++++++------
 fs/xfs/libxfs/xfs_dir2_node.c        |   2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c          |   4 +-
 fs/xfs/libxfs/xfs_exchmaps.c         |  10 +--
 fs/xfs/libxfs/xfs_format.h           |   6 ++
 fs/xfs/libxfs/xfs_ialloc.c           |  92 +++++++++++--------------
 fs/xfs/libxfs/xfs_inode_buf.c        |  24 +++----
 fs/xfs/libxfs/xfs_inode_buf.h        |  13 ++--
 fs/xfs/libxfs/xfs_inode_fork.c       |   6 +-
 fs/xfs/libxfs/xfs_inode_util.c       |  13 ++--
 fs/xfs/libxfs/xfs_metadir.c          |   2 +-
 fs/xfs/libxfs/xfs_parent.c           |   8 +--
 fs/xfs/libxfs/xfs_parent.h           |   2 +-
 fs/xfs/libxfs/xfs_rmap.c             |   6 +-
 fs/xfs/libxfs/xfs_rmap.h             |   4 ++
 fs/xfs/libxfs/xfs_rtbitmap.c         |   4 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   4 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |   4 +-
 fs/xfs/libxfs/xfs_symlink_remote.c   |   6 +-
 fs/xfs/scrub/agheader_repair.c       |  20 ++----
 fs/xfs/scrub/attr.c                  |   4 +-
 fs/xfs/scrub/attr_repair.c           |  16 ++---
 fs/xfs/scrub/bmap.c                  |  24 +++----
 fs/xfs/scrub/bmap_repair.c           |   8 +--
 fs/xfs/scrub/common.c                |  26 +++----
 fs/xfs/scrub/common.h                |   6 +-
 fs/xfs/scrub/cow_repair.c            |   3 +-
 fs/xfs/scrub/dabtree.c               |   4 +-
 fs/xfs/scrub/dir.c                   |  24 +++----
 fs/xfs/scrub/dir_repair.c            |  42 ++++++------
 fs/xfs/scrub/dirtree.c               |  24 +++----
 fs/xfs/scrub/dirtree_repair.c        |   4 +-
 fs/xfs/scrub/findparent.c            |  33 +++++----
 fs/xfs/scrub/ialloc.c                |  11 +--
 fs/xfs/scrub/ialloc_repair.c         |   7 +-
 fs/xfs/scrub/inode.c                 |  18 ++---
 fs/xfs/scrub/inode_repair.c          |  17 +++--
 fs/xfs/scrub/iscan.c                 |   2 +-
 fs/xfs/scrub/listxattr.c             |  10 +--
 fs/xfs/scrub/metapath.c              |  16 ++---
 fs/xfs/scrub/newbt.c                 |   8 +--
 fs/xfs/scrub/nlinks.c                |  34 ++++-----
 fs/xfs/scrub/nlinks_repair.c         |   6 +-
 fs/xfs/scrub/orphanage.c             |  10 +--
 fs/xfs/scrub/parent.c                |  31 ++++-----
 fs/xfs/scrub/parent_repair.c         |  18 ++---
 fs/xfs/scrub/quotacheck.c            |   2 +-
 fs/xfs/scrub/readdir.c               |  12 ++--
 fs/xfs/scrub/reap.c                  |   5 +-
 fs/xfs/scrub/repair.c                |   2 +-
 fs/xfs/scrub/rmap_repair.c           |   2 +-
 fs/xfs/scrub/rtbitmap.c              |  16 ++---
 fs/xfs/scrub/rtbitmap_repair.c       |   2 +-
 fs/xfs/scrub/rtrefcount.c            |   2 +-
 fs/xfs/scrub/rtrefcount_repair.c     |   2 +-
 fs/xfs/scrub/rtrmap.c                |   3 +-
 fs/xfs/scrub/rtrmap_repair.c         |   4 +-
 fs/xfs/scrub/rtsummary.c             |  14 ++--
 fs/xfs/scrub/rtsummary_repair.c      |   2 +-
 fs/xfs/scrub/scrub.c                 |   2 +-
 fs/xfs/scrub/symlink_repair.c        |   8 +--
 fs/xfs/scrub/tempfile.c              |   2 +-
 fs/xfs/scrub/trace.c                 |   2 +-
 fs/xfs/scrub/trace.h                 | 128 +++++++++++++++++-----------------
 fs/xfs/xfs_aops.c                    |   2 +-
 fs/xfs/xfs_attr_item.c               |   4 +-
 fs/xfs/xfs_attr_list.c               |  12 ++--
 fs/xfs/xfs_bmap_item.c               |   4 +-
 fs/xfs/xfs_bmap_util.c               |   4 +-
 fs/xfs/xfs_buf.c                     |   2 +-
 fs/xfs/xfs_buf.h                     |   1 -
 fs/xfs/xfs_dir2_readdir.c            |   4 +-
 fs/xfs/xfs_dquot.c                   |  16 ++---
 fs/xfs/xfs_error.c                   |   2 +-
 fs/xfs/xfs_exchmaps_item.c           |   4 +-
 fs/xfs/xfs_exchrange.c               |   4 +-
 fs/xfs/xfs_export.c                  |   8 +--
 fs/xfs/xfs_filestream.c              |   6 +-
 fs/xfs/xfs_handle.c                  |   4 +-
 fs/xfs/xfs_healthmon.c               |   6 +-
 fs/xfs/xfs_icache.c                  |  58 ++++++++--------
 fs/xfs/xfs_inode.c                   |  37 +++++-----
 fs/xfs/xfs_inode.h                   |  19 +++---
 fs/xfs/xfs_inode_item.c              |  28 +++++---
 fs/xfs/xfs_inode_item_recover.c      |   4 +-
 fs/xfs/xfs_ioctl.c                   |   2 +-
 fs/xfs/xfs_iomap.c                   |   4 +-
 fs/xfs/xfs_iops.c                    |   3 +-
 fs/xfs/xfs_itable.c                  |   2 +-
 fs/xfs/xfs_iunlink_item.c            |   4 +-
 fs/xfs/xfs_message.c                 |   4 --
 fs/xfs/xfs_message.h                 |   1 -
 fs/xfs/xfs_mount.c                   |   2 +-
 fs/xfs/xfs_mount.h                   |   2 -
 fs/xfs/xfs_qm.c                      |  10 +--
 fs/xfs/xfs_quotaops.c                |   2 +-
 fs/xfs/xfs_reflink.c                 |   4 +-
 fs/xfs/xfs_super.c                   |   1 -
 fs/xfs/xfs_symlink.c                 |   6 +-
 fs/xfs/xfs_trace.h                   | 129 +++++++++++++++++------------------
 fs/xfs/xfs_trans.c                   |   2 +-
 fs/xfs/xfs_trans_buf.c               |  39 ++---------
 fs/xfs/xfs_trans_dquot.c             |   6 +-
 fs/xfs/xfs_xattr.c                   |   2 +-
 111 files changed, 668 insertions(+), 730 deletions(-)
