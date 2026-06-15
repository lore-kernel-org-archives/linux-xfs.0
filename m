Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC23D21CFEF
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jun 2026 09:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781515774; cv=none; b=jdo89vNW181yPXFOO50zuyyUKRPsy2pY6UJaIdmiYlkIfIFJBINUe5Xuzf9CRRB7P3FxB15/6BqBxE4DmMYBqfy13tXv6KFKTbO2IXncqVl+XY30yoLlwqMVo8KIgmIOk2pEI9EVPFCXIMMaFK46eZ0MTxH9D8Fo5CnXnvD+qns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781515774; c=relaxed/simple;
	bh=bSbBubKDoyr0vaqAtQkFkjqq4eUrTAaAn0f8HdMD4RU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Xur/5jPTb3nJ49Wo4ft8s4z3/crYkiAlVmXr4ypKBJtAt/yrYpgrasXZ3jaClTRToZh2yaQGNPgyGSxp+0ctTrUeY6SufxRyVrxH2AbSHc+iKAdEcF/m7p89WgeDpkdpre3Tc6DkhpdP3fuuGjF1ejxXIotIkNsfBaUAWOa+AhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHzbtcmY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHzbtcmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812E91F000E9;
	Mon, 15 Jun 2026 09:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781515773;
	bh=Scba2GwIDBtrUmkMspLGf1JiQPk+byg+tnHErp3LcCc=;
	h=Date:From:To:Cc:Subject;
	b=GHzbtcmYzCZcAzM9BkNM9zD+OqXvb0rNiFpfYnH85wvViDg9mlZ/SXAyYYP5MPHJn
	 Zi/IQ1MGslIQCbIV7OLh5rJ/JGld2OU7N9G2FI6aTh/i0CD6SPMBzNun1i68vYfkZh
	 gpXnS+tzgTWfH0fkHK/uo/IsTox34FMQoEc+L2rD08+Uy+JZbw94Rx2zB8F92TrtGm
	 8P3a5Saf7cJi7Xa8rAhvZskScu6DbDhym73JqPOyvg2Hkc6ljzvKzfBsc7kaOq0HCa
	 Dcd4KZcOnTaK39ZAMuGxHyDQKBzdfZdcx3X4T6uNJoeJ7SLxgVqXhcrQN5fCZ9vqN7
	 NwWZhLtzCymiw==
Date: Mon, 15 Jun 2026 11:29:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: New code for v7.2 - with conflicts
Message-ID: <ai_AhORI0FprqM9A@nidhogg.toxiclabs.cc>
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

The main highlight in this pull is the removal of experimental tag of the
zone allocator feature.
Besides that, the pull request contains a collection of bug fixes and
code refactoring but no new features have been added.

Merging this causes a simple conflict in: fs/xfs/xfs_trace.h while
applying patch:
1113a6d6d5d1 ("xfs: remove the i_ino field in struct xfs_inode")

The reason is patch: 769e143b115a ("fs: add icount_read_once() and stop open-coding ->i_count loads")
replacing icount_read() by icount_read_once().

For completeness, below is my resolution for the conflict during my
merge test:

diff --cc fs/xfs/xfs_trace.h
index f87c738d84b2,ae5faa787830..d478693674f9
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@@ -1157,8 -1157,8 +1157,8 @@@ DECLARE_EVENT_CLASS(xfs_iref_class
        ),
        TP_fast_assign(
                __entry->dev = VFS_I(ip)->i_sb->s_dev;
-               __entry->ino = ip->i_ino;
+               __entry->ino = I_INO(ip);
 -              __entry->count = icount_read(VFS_I(ip));
 +              __entry->count = icount_read_once(VFS_I(ip));
                __entry->pincount = atomic_read(&ip->i_pincount);
                __entry->iflags = ip->i_flags;
                __entry->caller_ip = caller_ip;


Thanks,
Carlos

"The following changes since commit dabfaca8140f64535a79020f0f86ea56f5db5bb2:

  xfs: Remove mention of PageWriteback (2026-05-30 08:26:18 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.2

for you to fetch changes up to 804826eac53cff44f88f42989fcc601c2612c0ed:

  xfs: shut down the filesystem on a failed mount (2026-06-12 09:57:02 +0200)

----------------------------------------------------------------
xfs: new code for Linux 7.2

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Alexey Nepomnyashih (1):
      xfs: fix unreachable BIGTIME check in dquot flush validation

Christoph Hellwig (23):
      xfs: drop the experimental warning for the zoned allocator
      xfs: add a XFS_INODE_TO_AGNO helper
      xfs: add a XFS_INODE_TO_AGINO helper
      xfs: add a XFS_INO_TO_FSB helper
      xfs: add a xfs_rmap_inode_bmbt_owner
      xfs: add a xfs_rmap_inode_owner helper
      xfs: add a xchk_ip_set_corrupt helper
      xfs: convert xchk_inode_xref_set_corrupt to xchk_ip_xref_set_corrupt
      xfs: remove xfs_setup_existing_inode
      xfs: remove the i_ino field in struct xfs_inode
      xfs: remove the call to xfs_buf_reverify in xfs_trans_read_buf_map
      xfs: cleanup xfs_imap
      xfs: remove im_len field in struct xfs_imap
      xfs: massage xfs_imap_to_bp into xfs_read_icluster
      xfs: store an agbno in struct xfs_imap
      xfs: mark struct xfs_imap as __packed
      xfs: factor out a xfs_zone_mark_free helper
      xfs: add newly added RTGs to the free pool in growfs
      xfs: only log freed extents for the current RTG in zoned growfs
      xfs: initialize iomap->flags earlier in xfs_bmbt_to_iomap
      xfs: pass back updated nb from xfs_growfs_compute_deltas
      xfs: cleanup xfs_growfs_compute_deltas
      xfs: move XFS_LSN_CMP to xfs_log_format.h

Darrick J. Wong (1):
      xfs: fix pointer arithmetic error on 32-bit systems

Mikhail Lobanov (2):
      xfs: skip inode inactivation on a shut down mount
      xfs: shut down the filesystem on a failed mount

Yao Sang (1):
      xfs: shut down zoned file systems on writeback errors

Yingjie Gao (1):
      xfs: fix exchmaps reservation limit check

 fs/xfs/libxfs/xfs_ag.c               |  44 ++++++------
 fs/xfs/libxfs/xfs_ag.h               |   5 +-
 fs/xfs/libxfs/xfs_attr.c             |   2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c        |   2 +-
 fs/xfs/libxfs/xfs_bmap.c             |  20 +++---
 fs/xfs/libxfs/xfs_bmap_btree.c       |   8 +--
 fs/xfs/libxfs/xfs_bmap_btree.h       |   2 +-
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
 fs/xfs/libxfs/xfs_log_format.h       |  13 ++++
 fs/xfs/libxfs/xfs_metadir.c          |   2 +-
 fs/xfs/libxfs/xfs_parent.c           |   9 ++-
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
 fs/xfs/xfs_aops.c                    |  13 +++-
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
 fs/xfs/xfs_fsops.c                   |   4 +-
 fs/xfs/xfs_handle.c                  |   4 +-
 fs/xfs/xfs_healthmon.c               |   6 +-
 fs/xfs/xfs_icache.c                  |  58 ++++++++--------
 fs/xfs/xfs_inode.c                   |  54 +++++++++------
 fs/xfs/xfs_inode.h                   |  19 +++---
 fs/xfs/xfs_inode_item.c              |  28 +++++---
 fs/xfs/xfs_inode_item_recover.c      |   4 +-
 fs/xfs/xfs_ioctl.c                   |   2 +-
 fs/xfs/xfs_iomap.c                   |   6 +-
 fs/xfs/xfs_iops.c                    |   3 +-
 fs/xfs/xfs_itable.c                  |   2 +-
 fs/xfs/xfs_iunlink_item.c            |   4 +-
 fs/xfs/xfs_log.h                     |  17 -----
 fs/xfs/xfs_message.c                 |   4 --
 fs/xfs/xfs_message.h                 |   1 -
 fs/xfs/xfs_mount.c                   |  18 +++--
 fs/xfs/xfs_mount.h                   |   2 -
 fs/xfs/xfs_qm.c                      |  10 +--
 fs/xfs/xfs_quotaops.c                |   2 +-
 fs/xfs/xfs_reflink.c                 |   4 +-
 fs/xfs/xfs_rtalloc.c                 |  16 +++--
 fs/xfs/xfs_super.c                   |   1 -
 fs/xfs/xfs_symlink.c                 |   6 +-
 fs/xfs/xfs_trace.h                   | 129 +++++++++++++++++------------------
 fs/xfs/xfs_trans.c                   |   2 +-
 fs/xfs/xfs_trans_buf.c               |  39 ++---------
 fs/xfs/xfs_trans_dquot.c             |   6 +-
 fs/xfs/xfs_xattr.c                   |   2 +-
 fs/xfs/xfs_zone_alloc.c              |  11 ++-
 fs/xfs/xfs_zone_alloc.h              |   1 +
 fs/xfs/xfs_zone_gc.c                 |   4 +-
 121 files changed, 770 insertions(+), 792 deletions(-)"
