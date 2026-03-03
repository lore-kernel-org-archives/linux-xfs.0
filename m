Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754DA1096F
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496739; cv=none; b=WJHAXapksSZ3LuzNlQNRb+9p/bufRr0dsxZk8+g55OyrwmRUz/GrcgfYAE/xuUEU4B5hDeUfEje0NcjlwmUz93aqLVXJqxTggSIGVhlxoL2DCRuv6cRNcaBFQza1MQZs5k9bxVmOaXg2C2cbs0vnAUVFjbhFZHgS9i7d7xuxXEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496739; c=relaxed/simple;
	bh=lT+H5S63UMWL6K0m2JpC31kLxMdU8XJ0/Fj33fSOlUQ=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=XtCn8GxUvgUB/uGG1qJR/wOS1hTvCrhbNdXgmTVTzrI7jsNZhhDTv3ooHdlgzdfRNaZ83e+0Oi2rNTSTqVqjk5W+ifYl/zlPCFRSS15VU7q4J66mimeO5LH405TbDSknPkhWvCDko5MBjCo0yh2XlDNxIIirlxBbP6uguOgw0Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SPFtytvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SPFtytvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F316C19423;
	Tue,  3 Mar 2026 00:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496739;
	bh=lT+H5S63UMWL6K0m2JpC31kLxMdU8XJ0/Fj33fSOlUQ=;
	h=Date:Subject:From:To:Cc:From;
	b=SPFtytvYdQmC5a1G+FAFm7utR/nbYvut0ntD+ysyd27c+SUOT4OcNZaX4ReT8bJUp
	 ydxWTA1Rm1NG9PDuxNbxe/cfU83WFGV/XnBUBQSEmsqCgx5Cj5G/le+UGc+6wlxfSa
	 7kOZUzVRkF9LC1NpXYrd++IVaBsTq+2xvwY7nzZwEJoj15fg30yvVdl+FJDSEN2d9f
	 +xs2AO7XuFoI9yidlcZO9NiSnnhqbHfemL4y4KNLubErF80CIDP0qoRFsD5t3brS9E
	 uqyrnfvCFySKwV/atkfOl/9R2xJ7ZnAIiwnMFhS+dGX5KJa6NQCQxuw4ESaywXXjaB
	 eS121wFBr+S2Q==
Date: Mon, 02 Mar 2026 16:12:18 -0800
Subject: [PATCHSET] xfsprogs: new libxfs code from kernel 7.0
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: kees@kernel.org, hans.holmberg@wdc.com, torvalds@linux-foundation.org,
 shinsj4653@gmail.com, cem@kernel.org, dlemoal@kernel.org, hch@lst.de,
 nirjhar.roy.lists@gmail.com, mark.tinguely@oracle.com,
 wilfred.mallawa@wdc.com, cmaiolino@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series ports kernel libxfs code to userspace from 7.0-rc2 and is a prereq
for the xfs_healer patches that come next.  The cc list on this userspace port
has gotten kind of out of hand due to the treewide cleanups that went in just
before -rc1.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-7.0-sync
---
Commits in this patchset:
 * libfrog: hoist some utilities from libxfs
 * libfrog: fix missing gettext call in current_fixed_time
 * xfs: start creating infrastructure for health monitoring
 * xfs: create event queuing, formatting, and discovery infrastructure
 * xfs: convey filesystem unmount events to the health monitor
 * xfs: convey metadata health events to the health monitor
 * xfs: convey filesystem shutdown events to the health monitor
 * xfs: convey externally discovered fsdax media errors to the health monitor
 * xfs: convey file I/O errors to the health monitor
 * xfs: check if an open file is on the health monitored fs
 * xfs: add media verification ioctl
 * xfs: move struct xfs_log_iovec to xfs_log_priv.h
 * xfs: directly include xfs_platform.h
 * xfs: remove xfs_attr_leaf_hasname
 * xfs: add missing forward declaration in xfs_zones.h
 * xfs: add a xfs_rtgroup_raw_size helper
 * xfs: split and refactor zone validation
 * xfs: delete attr leaf freemap entries when empty
 * xfs: fix freemap adjustments when adding xattrs to leaf blocks
 * xfs: refactor attr3 leaf table size computation
 * xfs: strengthen attr leaf block freemap checking
 * xfs: reduce xfs_attr_try_sf_addname parameters
 * xfs: speed up parent pointer operations when possible
 * xfs: add a method to replace shortform attrs
 * xfs: fix spacing style issues in xfs_alloc.c
 * xfs: don't validate error tags in the I/O path
 * xfs: add zone reset error injection
 * xfs: give the defer_relog stat a xs_ prefix
 * treewide: Replace kmalloc with kmalloc_obj for non-scalar types
 * Convert 'alloc_obj' family to use the new default GFP_KERNEL argument
 * xfs: Refactoring the nagcount and delta calculation
 * xfs: fix code alignment issues in xfs_ondisk.c
 * xfs: remove metafile inodes from the active inode stat
 * xfs: Add a comment in xfs_log_sb()
 * xfs: remove duplicate static size checks
 * xfs: add static size checks for ioctl UABI
---
 include/kmem.h                |   36 +++++++
 include/libxfs.h              |    7 -
 include/platform_defs.h       |    8 ++
 include/xfs_fs_compat.h       |    8 --
 include/xfs_trace.h           |    1 
 libfrog/util.h                |   21 ++++
 libxfs/libxfs_api_defs.h      |    2 
 libxfs/xfs_ag.h               |    3 +
 libxfs/xfs_attr.h             |    6 +
 libxfs/xfs_attr_leaf.h        |    1 
 libxfs/xfs_da_format.h        |    2 
 libxfs/xfs_errortag.h         |    8 +-
 libxfs/xfs_fs.h               |  189 +++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_health.h           |    5 +
 libxfs/xfs_log_format.h       |    7 -
 libxfs/xfs_ondisk.h           |   52 +++++++----
 libxfs/xfs_platform.h         |   25 +----
 libxfs/xfs_rtgroup.h          |   15 +++
 libxfs/xfs_zones.h            |    6 +
 libfrog/Makefile              |    4 +
 libfrog/util.c                |  166 +++++++++++++++++++++++++++++++++++
 libxfs/Makefile               |    4 -
 libxfs/buf_mem.c              |    2 
 libxfs/cache.c                |    2 
 libxfs/defer_item.c           |    2 
 libxfs/init.c                 |    2 
 libxfs/inode.c                |    2 
 libxfs/iunlink.c              |    2 
 libxfs/kmem.c                 |    2 
 libxfs/logitem.c              |    2 
 libxfs/rdwr.c                 |    2 
 libxfs/topology.c             |    2 
 libxfs/trans.c                |    2 
 libxfs/util.c                 |  162 ----------------------------------
 libxfs/xfblob.c               |    2 
 libxfs/xfile.c                |    2 
 libxfs/xfs_ag.c               |   32 ++++++-
 libxfs/xfs_ag_resv.c          |    2 
 libxfs/xfs_alloc.c            |   10 +-
 libxfs/xfs_alloc_btree.c      |    2 
 libxfs/xfs_attr.c             |  191 +++++++++++++++++++++++++++-------------
 libxfs/xfs_attr_leaf.c        |  197 ++++++++++++++++++++++++++++++++++-------
 libxfs/xfs_attr_remote.c      |    2 
 libxfs/xfs_bit.c              |    2 
 libxfs/xfs_bmap.c             |    2 
 libxfs/xfs_bmap_btree.c       |    2 
 libxfs/xfs_btree.c            |    2 
 libxfs/xfs_btree_mem.c        |    2 
 libxfs/xfs_btree_staging.c    |    2 
 libxfs/xfs_da_btree.c         |    2 
 libxfs/xfs_defer.c            |    6 +
 libxfs/xfs_dir2.c             |   21 ++--
 libxfs/xfs_dir2_block.c       |    2 
 libxfs/xfs_dir2_data.c        |    2 
 libxfs/xfs_dir2_leaf.c        |    2 
 libxfs/xfs_dir2_node.c        |    2 
 libxfs/xfs_dir2_sf.c          |    2 
 libxfs/xfs_dquot_buf.c        |    2 
 libxfs/xfs_exchmaps.c         |    2 
 libxfs/xfs_group.c            |    2 
 libxfs/xfs_ialloc.c           |    2 
 libxfs/xfs_ialloc_btree.c     |    2 
 libxfs/xfs_iext_tree.c        |    2 
 libxfs/xfs_inode_buf.c        |    6 +
 libxfs/xfs_inode_fork.c       |    2 
 libxfs/xfs_inode_util.c       |    2 
 libxfs/xfs_log_rlimit.c       |    2 
 libxfs/xfs_metadir.c          |    2 
 libxfs/xfs_metafile.c         |    7 +
 libxfs/xfs_parent.c           |   16 ++-
 libxfs/xfs_refcount.c         |    6 +
 libxfs/xfs_refcount_btree.c   |    2 
 libxfs/xfs_rmap.c             |    2 
 libxfs/xfs_rmap_btree.c       |    2 
 libxfs/xfs_rtbitmap.c         |    2 
 libxfs/xfs_rtgroup.c          |    4 -
 libxfs/xfs_rtrefcount_btree.c |    2 
 libxfs/xfs_rtrmap_btree.c     |    2 
 libxfs/xfs_sb.c               |    5 +
 libxfs/xfs_symlink_remote.c   |    2 
 libxfs/xfs_trans_inode.c      |    2 
 libxfs/xfs_trans_resv.c       |    2 
 libxfs/xfs_trans_space.c      |    2 
 libxfs/xfs_types.c            |    2 
 libxfs/xfs_zones.c            |  151 ++++++++-----------------------
 libxlog/xfs_log_recover.c     |    4 -
 repair/zoned.c                |    7 +
 87 files changed, 973 insertions(+), 526 deletions(-)
 rename libxfs/{libxfs_priv.h => xfs_platform.h} (96%)

