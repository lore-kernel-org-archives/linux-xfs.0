Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A7A4B1D0D
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 09:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637966; cv=none; b=SnBSbt5QXWFvBgRPJKt4SlnnrtHOo5ouGwLwk1cnY+RdjicHzNmsYzZU6mGlgvv16GNB+LlSLS261OulyHFy/fbcbYC7zmiFYF2gAlbgDeKWqbf39DCC2+XMBzwg+WBTw+rFD9DhoaTBHmJJTANZrn5s/w2KNTNiaaHaJ/KQdWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637966; c=relaxed/simple;
	bh=iJ6V7Ui6+px5ze5/Xy/V84vUNt9jg2iLgKfZ0kVNmUA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oGyXG6OfaPFraZ90Na/pwxTakphL5sKX3+zq7LLRaJ171x6+CMKmNTye6Tfrs1vw4daLg4LsSoU1nF0h719f5ywOys8DaGmb+p0+ZY4QGzfzgyIt3AYGAninMcWETZsv9jMYlpnVl223VekvMpyfTVdpQS6AoiJ5ArDEdWVShCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fnItkFd2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fnItkFd2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E0A1F000FF;
	Thu, 17 Sep 2026 09:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637916;
	bh=Vl9uoOY+NuniCeBXQO3V1pySg9QDcIfveqPWZNsuC4A=;
	h=Date:From:To:Cc:Subject;
	b=fnItkFd2MsBPCC4IuOWejKkkJzM04wb+mFCUOgauWgLZ5Rw8y1NEwxZwpjpjDUtb7
	 0FcNOe70PsXAtRGckR/e3CYifV3Kxjf/0ttAITiY9GhaQ+x7lRVjw7w2ZNoIVPHdBn
	 Tzle0/izgqiHGnrNlVudnbj5ropPFdIJFupcFLjT3aW61cRBDVZEOC1XgAnFMqIqB9
	 UlmtWyScmR5AhyaNpFYNLU7Fi0EA+VLmmoaHdCPxKB/ZKOVzOalZ8uHVE1wav92YJx
	 bxv922zE8NR7uovgkATUu60aNVZESfMCmg6UO9Urmw8El7QUa1tIBdak/pOuRUmq8j
	 86uRgOheCYPlQ==
Date: Thu, 17 Sep 2026 11:38:29 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, alx@kernel.org, avinesh.kumar@suse.com, 
	bestswngs@gmail.com, brauner@kernel.org, cem@kernel.org, chuck.lever@oracle.com, 
	cmaiolino@redhat.com, dawei.feng@seu.edu.cn, djwong@kernel.org, 
	gaoyingjie@uniontech.com, hans.holmberg@wdc.com, hch@infradead.org, hch@lst.de, 
	jiapenglin@tencent.com, roland.mainz@nrubsig.org, sandeen@redhat.com, tytso@mit.edu, 
	xmei5@asu.edu
Subject: [ANNOUNCE] xfsprogs: v7.2.0 released
Message-ID: <aqu0yB1tlW6w7xgG@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs master branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This release adds a new possibility to save configuration file with user-visible
features, this file may latter be used to re-create filesystem. mkfs.xfs gained
ability to read default configuration file, this configuration can be
overwritten with command line arguments or separate configuration file.
xfs_quota now uses quotactl_fd(2) when available, to prevent failures during
mount point path lookup. A few minor improvements to error reporting, man pages,
and a bunch of internal cleanups.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

84c54d6c0c3b65a3d1f10c4d3ac926bf9ef49b0b

New commits:

Andrey Albershteyn (3):
      [4f927c6d2dab] xfs: fix null pointer dereference in tracepoint
      [9601f7fff5f5] man: document that XFS_IOC_FS[G|S]ETXATTR can not be used on special files
      [84c54d6c0c3b] xfsprogs: Release v7.2.0

Avinesh Kumar (1):
      [2d8d811c789f] libfrog: make cmn_err() emit each message atomically to avoid torn output

Christoph Hellwig (29):
      [b7876c0e11a3] copy: log the error number when failing to write
      [d6d4236027e3] copy: always align to at least page size
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
      [ea60844c0d45] libxfs: remove xfs_inode.i_size
      [8f11dfa97f13] repair: remove the ip variable in ensure_rtgroup_file
      [5b28e18c7b35] include: fix LIBHFILES in Makefile
      [2a43f11f27fc] libxfs: remove a spurious xfs.h include in xfs_zones.c
      [fcc640556e62] libxfs: move a few xfs_health.h includes
      [dc153093e6a2] libxfs: find a better location for stub headers
      [dadaec61aece] libxfs: rename buf_mem.h to xfs_buf_mem.h
      [538b3d77a823] libxfs: provide xfs_error.h
      [d505a55ff272] libxfs: provide xfs_extent_busy.h
      [cea516062157] libxfs: provide xfs_quota.h

Chuck Lever (1):
      [54d45f9bedfe] xfs: Report case sensitivity in fileattr_get

Darrick J. Wong (15):
      [9595e21992a8] libxfs: convert diff_items helpers to cmp_int
      [85cd98501769] xfs: fix pointer arithmetic error on 32-bit systems
      [3659a959beef] mkfs: automatically upgrade autofsck earlier
      [54bb98427105] mkfs: print config file for a given mkfs configuration
      [b76315c9f7df] xfs_db: print configuration file for mounted filesystems
      [b1d1ad39ec38] xfs_spaceman: print configuration file for mounted filesystems
      [7606e83be029] xfs_admin: print configuration file for mounted filesystems
      [ce4ee81aeded] mkfs: allow specification of default options via configuration file
      [dea3a7fdc3c5] libfrog: hoist xfsquotactl out of xfs_quota
      [bf356708c73b] libfrog: clean up xfsquotactl a little bit
      [6571a916bb69] libfrog: enhance struct fs_path to store optional mount fd
      [500da05860c7] libfrog: try to pass struct fs_path objects to quotactl wrapper
      [2eef8aff59eb] libfrog: add quotactl_fd support to xfsquotactl
      [3dc24f302503] xfs_quota: open the filesystem mountpoint for quota operations
      [d1ad770c8e7e] xfs_spaceman: port makecfg to use xfsquotactl

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

 VERSION                                   |   4 +-
 configure.ac                              |   3 +-
 copy/xfs_copy.c                           |   8 +-
 db/attrset.c                              |   2 +-
 db/bmap_inflate.c                         |   4 +-
 db/dquot.c                                |   2 +-
 db/info.c                                 | 201 ++++++++++
 db/iunlink.c                              |  13 +-
 db/namei.c                                |  14 +-
 db/rdump.c                                |   2 +-
 db/xfs_admin.sh                           |  15 +-
 debian/changelog                          |   6 +
 doc/CHANGES                               |  16 +
 include/Makefile                          |   8 -
 include/builddefs.in                      |   4 +-
 include/libxfs.h                          |   3 +-
 include/linux.h                           |  17 +
 io/init.h                                 |  10 +-
 io/io.h                                   | 158 ++++----
 libfrog/Makefile                          |   6 +
 libfrog/fsgeom.c                          | 629 ++++++++++++++++++++++++++++++
 libfrog/fsgeom.h                          |   4 +
 libfrog/paths.c                           |   3 +
 libfrog/paths.h                           |   1 +
 quota/linux.c => libfrog/quotactl.c       |  45 ++-
 libfrog/quotactl.h                        |  30 ++
 libfrog/util.c                            |   2 +
 libxfs/Makefile                           |  12 +-
 libxfs/buf_mem.c                          |   3 +-
 libxfs/defer_item.c                       |   9 +-
 libxfs/init.c                             |   3 +-
 libxfs/inode.c                            |   8 +-
 libxfs/iunlink.c                          |   4 +-
 libxfs/libxfs_api_defs.h                  |   2 +-
 libxfs/listxattr.c                        |   4 +-
 libxfs/logitem.c                          |  17 +-
 libxfs/rdwr.c                             |   3 +-
 libxfs/{buf_mem.h => stubs/xfs_buf_mem.h} |   2 +
 libxfs/stubs/xfs_error.h                  |  34 ++
 libxfs/stubs/xfs_extent_busy.h            |  20 +
 {include => libxfs/stubs}/xfs_inode.h     |  17 +-
 {include => libxfs/stubs}/xfs_mount.h     |   0
 libxfs/stubs/xfs_quota.h                  |  20 +
 {include => libxfs/stubs}/xfs_trace.h     |   0
 {include => libxfs/stubs}/xfs_trans.h     |  18 -
 libxfs/topology.c                         |   8 +-
 libxfs/util.c                             |   2 +-
 libxfs/xfs_ag.c                           |  43 +-
 libxfs/xfs_ag.h                           |   5 +-
 libxfs/xfs_ag_resv.c                      |   1 +
 libxfs/xfs_alloc.c                        |   2 +
 libxfs/xfs_alloc_btree.c                  |   4 +-
 libxfs/xfs_attr.c                         |   4 +-
 libxfs/xfs_attr_leaf.c                    |   3 +-
 libxfs/xfs_attr_remote.c                  |   1 +
 libxfs/xfs_bmap.c                         |  23 +-
 libxfs/xfs_bmap_btree.c                   |  11 +-
 libxfs/xfs_bmap_btree.h                   |   2 +-
 libxfs/xfs_btree.c                        |  23 +-
 libxfs/xfs_btree_mem.c                    |   4 +-
 libxfs/xfs_btree_staging.c                |   2 +-
 libxfs/xfs_da_btree.c                     |   4 +-
 libxfs/xfs_defer.c                        |   2 +-
 libxfs/xfs_dir2.c                         |  45 +--
 libxfs/xfs_dir2_block.c                   |   1 +
 libxfs/xfs_dir2_data.c                    |   1 +
 libxfs/xfs_dir2_leaf.c                    |   1 +
 libxfs/xfs_dir2_node.c                    |   3 +-
 libxfs/xfs_dir2_sf.c                      |   4 +-
 libxfs/xfs_dquot_buf.c                    |  17 +-
 libxfs/xfs_exchmaps.c                     |  22 +-
 libxfs/xfs_format.h                       |   6 +
 libxfs/xfs_group.c                        |   2 +
 libxfs/xfs_ialloc.c                       |  91 ++---
 libxfs/xfs_ialloc_btree.c                 |   3 +-
 libxfs/xfs_inode_buf.c                    |  25 +-
 libxfs/xfs_inode_buf.h                    |  13 +-
 libxfs/xfs_inode_fork.c                   |   7 +-
 libxfs/xfs_inode_util.c                   |  16 +-
 libxfs/xfs_log_format.h                   |  13 +
 libxfs/xfs_metadir.c                      |   4 +-
 libxfs/xfs_metafile.c                     |   2 +
 libxfs/xfs_parent.c                       |   9 +-
 libxfs/xfs_parent.h                       |   2 +-
 libxfs/xfs_platform.h                     |  57 ---
 libxfs/xfs_refcount.c                     |   1 +
 libxfs/xfs_refcount_btree.c               |   3 +-
 libxfs/xfs_rmap.c                         |   7 +-
 libxfs/xfs_rmap.h                         |   4 +
 libxfs/xfs_rmap_btree.c                   |   7 +-
 libxfs/xfs_rtbitmap.c                     |   6 +-
 libxfs/xfs_rtgroup.c                      |   1 +
 libxfs/xfs_rtrefcount_btree.c             |  10 +-
 libxfs/xfs_rtrmap_btree.c                 |   9 +-
 libxfs/xfs_sb.c                           |   8 +-
 libxfs/xfs_symlink_remote.c               |   7 +-
 libxfs/xfs_trans_resv.c                   |   2 +-
 libxfs/xfs_zones.c                        |   1 -
 m4/package_libcdev.m4                     |  19 +
 man/man2/ioctl_xfs_fsgetxattr.2           |  24 +-
 man/man8/mkfs.xfs.8.in                    |  33 +-
 man/man8/xfs_admin.8                      |   8 +
 man/man8/xfs_db.8                         |  23 +-
 man/man8/xfs_spaceman.8                   |   7 +
 mkfs/proto.c                              |  16 +-
 mkfs/xfs_mkfs.c                           | 232 +++++++++--
 quota/Makefile                            |   2 +-
 quota/edit.c                              |  36 +-
 quota/free.c                              |  11 +-
 quota/init.c                              |  15 +
 quota/init.h                              |   2 +
 quota/path.c                              |   4 +-
 quota/project.c                           |   7 +
 quota/quota.c                             |   6 +-
 quota/quota.h                             |  18 +-
 quota/report.c                            |  61 ++-
 quota/state.c                             |  38 +-
 repair/bmap_repair.c                      |  12 +-
 repair/bulkload.c                         |   2 +-
 repair/phase6.c                           | 132 +++----
 repair/pptr.c                             | 100 ++---
 repair/quotacheck.c                       |   8 +-
 repair/rt.c                               |   6 +-
 repair/rtrefcount_repair.c                |   2 +-
 repair/rtrmap_repair.c                    |   2 +-
 repair/xfs_repair.c                       |   4 +-
 spaceman/info.c                           | 200 ++++++++++
 127 files changed, 2244 insertions(+), 726 deletions(-)
 rename quota/linux.c => libfrog/quotactl.c (53%)
 create mode 100644 libfrog/quotactl.h
 rename libxfs/{buf_mem.h => stubs/xfs_buf_mem.h} (97%)
 create mode 100644 libxfs/stubs/xfs_error.h
 create mode 100644 libxfs/stubs/xfs_extent_busy.h
 rename {include => libxfs/stubs}/xfs_inode.h (96%)
 rename {include => libxfs/stubs}/xfs_mount.h (100%)
 create mode 100644 libxfs/stubs/xfs_quota.h
 rename {include => libxfs/stubs}/xfs_trace.h (100%)
 rename {include => libxfs/stubs}/xfs_trans.h (92%)

-- 
- Andrey
