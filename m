Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F770480968
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 13:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853071; cv=none; b=e03EboLMsUvVEyaphV4Hd7csQ0jS7h7I568bwOdVb2Pqvg2ivhx+1JA6cB6TPX3ocvBBwPhO5XQv2AoaAuPcN554TjQtM4/UnUHNdW0vmsZvVlXwOFOSLYgBC1k4pd/VWyhla0a7F8UZQ4NUydrBnXBPiu/JgNvLwIdDoHEH9zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853071; c=relaxed/simple;
	bh=LNAXJZlgNfgjG6EEaJ+uZZgbP902FYX+ycVvHgY7IZg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oEwMHUH4HvHXjmpwd/DZYUzaYK8rP1PjO1yIIs8I9ZcwZI5c/j7gmcupXC4gzbd9gZROxTfHfui91RnH8/XiUeczZLfjTLLrU666vkPJDZKjGXZ3mP0VNX8oVBafVbn+vx8PF5HLcWoDhvKdp6M9A3p1hnkBBlxQQrIP2yffAL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xTzvdGT6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xTzvdGT6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=TPkKF4N1LSJbibTgEsbEqRMSlZn1d8xiKOHs66mqLno=; b=xTzvdGT6GQEP5waZ4U/xov3qQE
	tAeRL/tYJhNTlIRncWqCn+YWX+yyrAO3mhTOh4RqcKvbkowZ8VsyGOek544s27vpeS4fY4R5O2dmF
	TbQfM8q+8QWa9+fQVVIYjdv044GhiVwVd+v9MkUBrpiL7o+2swU+MXkBGIPtv/RXYhIazgT1rxRj2
	yZXad6q/Lem1hXyhgPpa8tHDqRyy62gS5uBIgpUhdr9XnUsFklGz0Vi4P3KwO4BTNbEK64Xld1ypK
	AC6+1Cye1lIdNxmy3RR7d80UEIT6k9Sv+f5ky/+WlQe89cLsVQMcWW2vvYOyQMu2TJmGSxPNWpxyf
	sFr/vxYQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNswV-00000008UVS-0mmV;
	Fri, 15 May 2026 13:51:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: remove struct xfs_inode.i_ino
Date: Fri, 15 May 2026 15:50:21 +0200
Message-ID: <20260515135103.4042407-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

now that the VFS inode i_ino field is always a u64, there is no need
to duplicate the inode number in the XFS inode.

This series first adds a few helpers to reduce i_ino reference, and
then switches the rest of the code over.  A new I_INO helper is added
to shorten the dereference and to make userspace porting easier.

After this and the rw_semaphore shrink that went into 7.1-rc, it might
be time to look into re-packing the xfs_inode, but that is left for
another series.

Diffstat:
 libxfs/xfs_attr.c             |    2 
 libxfs/xfs_attr_leaf.c        |    2 
 libxfs/xfs_bmap.c             |   20 ++----
 libxfs/xfs_bmap_btree.c       |    8 +-
 libxfs/xfs_btree.c            |   18 ++---
 libxfs/xfs_btree_staging.c    |    2 
 libxfs/xfs_da_btree.c         |    2 
 libxfs/xfs_dir2.c             |   44 +++++++-------
 libxfs/xfs_dir2_node.c        |    2 
 libxfs/xfs_dir2_sf.c          |    4 -
 libxfs/xfs_exchmaps.c         |    8 +-
 libxfs/xfs_format.h           |    6 +
 libxfs/xfs_ialloc.c           |    4 -
 libxfs/xfs_inode_buf.c        |    4 -
 libxfs/xfs_inode_fork.c       |    6 -
 libxfs/xfs_inode_util.c       |   13 +---
 libxfs/xfs_metadir.c          |    2 
 libxfs/xfs_parent.c           |    8 +-
 libxfs/xfs_parent.h           |    2 
 libxfs/xfs_rmap.c             |    6 -
 libxfs/xfs_rmap.h             |    4 +
 libxfs/xfs_rtbitmap.c         |    4 -
 libxfs/xfs_rtrefcount_btree.c |    4 -
 libxfs/xfs_rtrmap_btree.c     |    4 -
 libxfs/xfs_symlink_remote.c   |    6 -
 scrub/agheader_repair.c       |   20 ++----
 scrub/attr.c                  |    4 -
 scrub/attr_repair.c           |   16 ++---
 scrub/bmap.c                  |   24 +++----
 scrub/bmap_repair.c           |    8 +-
 scrub/common.c                |   26 ++++----
 scrub/common.h                |    6 +
 scrub/cow_repair.c            |    3 
 scrub/dabtree.c               |    4 -
 scrub/dir.c                   |   24 +++----
 scrub/dir_repair.c            |   42 ++++++-------
 scrub/dirtree.c               |   24 +++----
 scrub/dirtree_repair.c        |    4 -
 scrub/findparent.c            |   33 +++++-----
 scrub/inode.c                 |   18 ++---
 scrub/inode_repair.c          |    5 -
 scrub/iscan.c                 |    2 
 scrub/listxattr.c             |   10 +--
 scrub/metapath.c              |   16 ++---
 scrub/newbt.c                 |    8 --
 scrub/nlinks.c                |   34 +++++------
 scrub/nlinks_repair.c         |    6 -
 scrub/orphanage.c             |   10 +--
 scrub/parent.c                |   31 ++++------
 scrub/parent_repair.c         |   18 ++---
 scrub/quotacheck.c            |    2 
 scrub/readdir.c               |   12 +--
 scrub/reap.c                  |    5 -
 scrub/repair.c                |    2 
 scrub/rmap_repair.c           |    2 
 scrub/rtbitmap.c              |   16 ++---
 scrub/rtbitmap_repair.c       |    2 
 scrub/rtrefcount.c            |    2 
 scrub/rtrefcount_repair.c     |    2 
 scrub/rtrmap.c                |    3 
 scrub/rtrmap_repair.c         |    4 -
 scrub/rtsummary.c             |   14 ++--
 scrub/rtsummary_repair.c      |    2 
 scrub/scrub.c                 |    2 
 scrub/symlink_repair.c        |    8 +-
 scrub/tempfile.c              |    2 
 scrub/trace.c                 |    2 
 scrub/trace.h                 |  116 ++++++++++++++++++-------------------
 xfs_aops.c                    |    2 
 xfs_attr_item.c               |    4 -
 xfs_attr_list.c               |   12 +--
 xfs_bmap_item.c               |    4 -
 xfs_bmap_util.c               |    4 -
 xfs_dir2_readdir.c            |    4 -
 xfs_error.c                   |    2 
 xfs_exchmaps_item.c           |    4 -
 xfs_exchrange.c               |    4 -
 xfs_export.c                  |    8 +-
 xfs_filestream.c              |    6 -
 xfs_handle.c                  |    4 -
 xfs_healthmon.c               |    6 -
 xfs_icache.c                  |   56 +++++++++---------
 xfs_inode.c                   |   37 +++++-------
 xfs_inode.h                   |   19 ++----
 xfs_inode_item.c              |    8 +-
 xfs_inode_item_recover.c      |    4 -
 xfs_ioctl.c                   |    2 
 xfs_iomap.c                   |    4 -
 xfs_iops.c                    |    3 
 xfs_iunlink_item.c            |    2 
 xfs_mount.c                   |    2 
 xfs_qm.c                      |   10 +--
 xfs_quotaops.c                |    2 
 xfs_reflink.c                 |    4 -
 xfs_symlink.c                 |    6 -
 xfs_trace.h                   |  129 ++++++++++++++++++++----------------------
 xfs_trans.c                   |    2 
 xfs_trans_dquot.c             |    6 -
 xfs_xattr.c                   |    2 
 99 files changed, 564 insertions(+), 577 deletions(-)
