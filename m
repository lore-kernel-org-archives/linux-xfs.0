Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00C44D09FC
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 10:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789553753; cv=none; b=qWdl9ag9fz4EG4Wf8v/gTLwnqRBGXxh3QzrUC+UTO7qOX+9o5z/4ymAgnG5M8DlttkWDsDELkDv31ne33cl0ZMpND2F8K+cTeDvsXmE9zAwqXW049jlwVXx/QQMt2i+mS+MFoyS3KS+pb/q0FsIBFqd+6SYAqn7f3V6zNw/wm2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789553753; c=relaxed/simple;
	bh=nWkKqC9y4LzykXj7T0pGXe04gCmWWT6SLjzaFgyye24=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=I2bt82df8F7kzZAocURyTE65xpNxoNZh5MhAglcTPdYUQWhRPCnFP9aHyyYnPMHwXdlP5D+0YSOYzaZc/J121VQdZEE2sTdTyHUS/tIyFt35D2nhnj4R5Eh3M9UqCag0zNXwmsMy8e8hdJKhPaexW7U2VupO31uIdTWbzxw1JUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZSBiljOS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZSBiljOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099C41F000FF;
	Wed, 16 Sep 2026 10:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789553734;
	bh=h4xFOyDtOOLmsX+sD69oLexyTKW26FO2R9LnPBeGFWU=;
	h=Date:From:To:Cc:Subject;
	b=ZSBiljOSdesM97pgoEYhsNdzxRYZjircRSobr9TfS4jW3NdKv1YzJFnnUyuXG+ZC1
	 8zCb1Cxk7VHfVbWBan1wHMNdsjxwyYfI769sIH6vqh7M3DWnxkoIfWZBrjO9YGOMvF
	 dB03RrH84+mxejkIPYMGE8md8Xqh5Zd1aqsKXEmaIT5rbCIyXMtqsHpWPqFZynHbGf
	 445ys85PdqbtQvar3fPTfX6au4MuqOmY4kY6DPd9Q0a53MR7C086JNf3PR5kxCxR+G
	 I4F7sVova2BfNBLXRw3Ml5BbVtbb54eWdBaf1aPctx3z/sLg4oPZWCd2OVyCJ2XAsr
	 VlRPbqzuPFKgw==
Date: Wed, 16 Sep 2026 12:15:30 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, alx@kernel.org, djwong@kernel.org, 
	hch@infradead.org, hch@lst.de, tytso@mit.edu
Subject: [ANNOUNCE] xfsprogs: for-next updated to d1ad770c8e7e
Message-ID: <aqpsOjqgDQwjBA_L@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
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

d1ad770c8e7e6cebc477f3e8555b1601b771ca13

New commits:

Andrey Albershteyn (1):
      [9601f7fff5f5] man: document that XFS_IOC_FS[G|S]ETXATTR can not be used on special files

Christoph Hellwig (10):
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

Darrick J. Wong (13):
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

Code Diffstat:

 configure.ac                              |   1 +
 db/info.c                                 | 201 ++++++++++
 db/xfs_admin.sh                           |  15 +-
 include/Makefile                          |   8 -
 include/builddefs.in                      |   4 +-
 include/libxfs.h                          |   3 +-
 libfrog/Makefile                          |   6 +
 libfrog/fsgeom.c                          | 629 ++++++++++++++++++++++++++++++
 libfrog/fsgeom.h                          |   4 +
 libfrog/paths.c                           |   3 +
 libfrog/paths.h                           |   1 +
 quota/linux.c => libfrog/quotactl.c       |  45 ++-
 libfrog/quotactl.h                        |  30 ++
 libxfs/Makefile                           |  12 +-
 libxfs/buf_mem.c                          |   3 +-
 libxfs/defer_item.c                       |   1 +
 libxfs/init.c                             |   3 +-
 libxfs/rdwr.c                             |   3 +-
 libxfs/{buf_mem.h => stubs/xfs_buf_mem.h} |   2 +
 libxfs/stubs/xfs_error.h                  |  34 ++
 libxfs/stubs/xfs_extent_busy.h            |  20 +
 {include => libxfs/stubs}/xfs_inode.h     |  10 +-
 {include => libxfs/stubs}/xfs_mount.h     |   0
 libxfs/stubs/xfs_quota.h                  |  20 +
 {include => libxfs/stubs}/xfs_trace.h     |   0
 {include => libxfs/stubs}/xfs_trans.h     |   0
 libxfs/xfs_ag.c                           |   1 +
 libxfs/xfs_ag_resv.c                      |   1 +
 libxfs/xfs_alloc.c                        |   2 +
 libxfs/xfs_alloc_btree.c                  |   4 +-
 libxfs/xfs_attr.c                         |   2 +-
 libxfs/xfs_attr_leaf.c                    |   1 +
 libxfs/xfs_attr_remote.c                  |   1 +
 libxfs/xfs_bmap.c                         |   3 +-
 libxfs/xfs_bmap_btree.c                   |   3 +-
 libxfs/xfs_btree.c                        |   5 +-
 libxfs/xfs_btree_mem.c                    |   4 +-
 libxfs/xfs_da_btree.c                     |   2 +
 libxfs/xfs_dir2.c                         |   1 +
 libxfs/xfs_dir2_block.c                   |   1 +
 libxfs/xfs_dir2_data.c                    |   1 +
 libxfs/xfs_dir2_leaf.c                    |   1 +
 libxfs/xfs_dir2_node.c                    |   1 +
 libxfs/xfs_dquot_buf.c                    |   3 +-
 libxfs/xfs_exchmaps.c                     |   2 +
 libxfs/xfs_group.c                        |   2 +
 libxfs/xfs_ialloc.c                       |   1 +
 libxfs/xfs_ialloc_btree.c                 |   3 +-
 libxfs/xfs_inode_buf.c                    |   1 +
 libxfs/xfs_inode_fork.c                   |   1 +
 libxfs/xfs_inode_util.c                   |   1 +
 libxfs/xfs_metadir.c                      |   2 +
 libxfs/xfs_metafile.c                     |   2 +
 libxfs/xfs_parent.c                       |   1 +
 libxfs/xfs_platform.h                     |  57 ---
 libxfs/xfs_refcount.c                     |   1 +
 libxfs/xfs_refcount_btree.c               |   3 +-
 libxfs/xfs_rmap.c                         |   1 +
 libxfs/xfs_rmap_btree.c                   |   7 +-
 libxfs/xfs_rtbitmap.c                     |   2 +
 libxfs/xfs_rtgroup.c                      |   1 +
 libxfs/xfs_rtrefcount_btree.c             |   2 +
 libxfs/xfs_rtrmap_btree.c                 |   5 +-
 libxfs/xfs_sb.c                           |   2 +-
 libxfs/xfs_symlink_remote.c               |   1 +
 libxfs/xfs_trans_resv.c                   |   2 +-
 libxfs/xfs_zones.c                        |   1 -
 m4/package_libcdev.m4                     |  19 +
 man/man2/ioctl_xfs_fsgetxattr.2           |  24 +-
 man/man8/mkfs.xfs.8.in                    |  33 +-
 man/man8/xfs_admin.8                      |   8 +
 man/man8/xfs_db.8                         |   7 +
 man/man8/xfs_spaceman.8                   |   7 +
 mkfs/xfs_mkfs.c                           | 213 ++++++++--
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
 repair/phase6.c                           |   8 +-
 spaceman/info.c                           | 200 ++++++++++
 87 files changed, 1670 insertions(+), 245 deletions(-)
 rename quota/linux.c => libfrog/quotactl.c (53%)
 create mode 100644 libfrog/quotactl.h
 rename libxfs/{buf_mem.h => stubs/xfs_buf_mem.h} (97%)
 create mode 100644 libxfs/stubs/xfs_error.h
 create mode 100644 libxfs/stubs/xfs_extent_busy.h
 rename {include => libxfs/stubs}/xfs_inode.h (97%)
 rename {include => libxfs/stubs}/xfs_mount.h (100%)
 create mode 100644 libxfs/stubs/xfs_quota.h
 rename {include => libxfs/stubs}/xfs_trace.h (100%)
 rename {include => libxfs/stubs}/xfs_trans.h (100%)

-- 
- Andrey
