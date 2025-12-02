Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044B1313E0C
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 13:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764682651; cv=none; b=GHsqKOqqskuBVxKgz6W6HmwNlIUsCjFejboY6w+djwqZoJF8fy8ozcr+8a0s0bz/1OK1b7M5jjJrIIJ2amS+mKY4SxM8ckGU7l+F0oB/yMt0+JHyf7+PxdW5Dq86Fgj6DirlhhZn/ATqTx+luHMwNfwYMIsF8CXhpynzLksWwhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764682651; c=relaxed/simple;
	bh=zAuaxaAueD9sFPcMm1GsD7AF6IquzhWuhnes4ROuqPs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pSDEn36uOn9x3+mSi6X2ZHhWy4iuc0airdtGe0m0E/VUTfzOgu/hXUmziuX/LoENex/XUUXBu4wxDjnIH3kbwkzEmOEG1NWhq4adKE407JGtkEJzt1ugmW8kN5LAbYOcLu31tT8LYXUepof7Uhn5pEny48RYs9jkRPfCGnwhiPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yyQoohP8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yyQoohP8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=bH17NS2FEywylprf13NQ7GyLF03EpRli04ZNukI969k=; b=yyQoohP8UjoLX0SVCcp3FuJf8k
	jCna5sflyf/oxMlfWWV44HKyYuqS8oTQETXJu8mNOCWMTzjm7G2Z1izayGg1oA5GDhSFHSEDrfquP
	sLFMHq9nWaDtGkoHZwyrdmOm9jTTRXmLUGtFMk98e18lPA1xlkqPvVe2N661gmZIVroNo24xV3NNT
	2/iFayGwbNjGe42bNu97xUgqJzXAHPPHFWTp8rszTGmrB8faO3CQQ7qm2bvJsyRFNRkv6D7GpgdOh
	CtmCh8IWkn7qF55dLRqP3Ettq8GHiY22UXNRaQeibPykc4lWastlSj6q1o4IMtJShdIlzwQATryVm
	G3Og4Wpw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQQZL-00000005RtU-0SSv;
	Tue, 02 Dec 2025 13:37:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH, RFC] rename xfs.h
Date: Tue,  2 Dec 2025 14:37:19 +0100
Message-ID: <20251202133723.1928059-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

currently one of the biggest difference between the kernel and xfsprogs
for the shared libxfs files is that the all kernel source files first
include xfs.h, while in xfsprogs they first include libxfs_priv.h.  The
reason for that is that there is a public xfs.h header in xfsprogs that
causes a namespace collision.

This patch renames xfs.h in the kernel tree to xfs_priv.h, a name that
is still available in xfsprogs.h.  Any other name fitting that criteria
should work just as well, I'm open to better suggestion if there are
any.

Diffstat:
 libxfs/xfs_ag.c               |    2 +-
 libxfs/xfs_ag_resv.c          |    2 +-
 libxfs/xfs_alloc.c            |    2 +-
 libxfs/xfs_alloc_btree.c      |    2 +-
 libxfs/xfs_attr.c             |    2 +-
 libxfs/xfs_attr_leaf.c        |    2 +-
 libxfs/xfs_attr_remote.c      |    2 +-
 libxfs/xfs_bit.c              |    2 +-
 libxfs/xfs_bmap.c             |    2 +-
 libxfs/xfs_bmap_btree.c       |    2 +-
 libxfs/xfs_btree.c            |    2 +-
 libxfs/xfs_btree_mem.c        |    2 +-
 libxfs/xfs_btree_staging.c    |    2 +-
 libxfs/xfs_da_btree.c         |    2 +-
 libxfs/xfs_defer.c            |    2 +-
 libxfs/xfs_dir2.c             |    2 +-
 libxfs/xfs_dir2_block.c       |    2 +-
 libxfs/xfs_dir2_data.c        |    2 +-
 libxfs/xfs_dir2_leaf.c        |    2 +-
 libxfs/xfs_dir2_node.c        |    2 +-
 libxfs/xfs_dir2_sf.c          |    2 +-
 libxfs/xfs_dquot_buf.c        |    2 +-
 libxfs/xfs_exchmaps.c         |    2 +-
 libxfs/xfs_group.c            |    2 +-
 libxfs/xfs_ialloc.c           |    2 +-
 libxfs/xfs_ialloc_btree.c     |    2 +-
 libxfs/xfs_iext_tree.c        |    2 +-
 libxfs/xfs_inode_buf.c        |    2 +-
 libxfs/xfs_inode_fork.c       |    2 +-
 libxfs/xfs_inode_util.c       |    2 +-
 libxfs/xfs_log_rlimit.c       |    2 +-
 libxfs/xfs_metadir.c          |    2 +-
 libxfs/xfs_metafile.c         |    2 +-
 libxfs/xfs_parent.c           |    2 +-
 libxfs/xfs_refcount.c         |    2 +-
 libxfs/xfs_refcount_btree.c   |    2 +-
 libxfs/xfs_rmap.c             |    2 +-
 libxfs/xfs_rmap_btree.c       |    2 +-
 libxfs/xfs_rtbitmap.c         |    2 +-
 libxfs/xfs_rtgroup.c          |    2 +-
 libxfs/xfs_rtrefcount_btree.c |    2 +-
 libxfs/xfs_rtrmap_btree.c     |    2 +-
 libxfs/xfs_sb.c               |    2 +-
 libxfs/xfs_symlink_remote.c   |    2 +-
 libxfs/xfs_trans_inode.c      |    2 +-
 libxfs/xfs_trans_resv.c       |    2 +-
 libxfs/xfs_trans_space.c      |    2 +-
 libxfs/xfs_types.c            |    2 +-
 libxfs/xfs_zones.c            |    2 +-
 scrub/agb_bitmap.c            |    2 +-
 scrub/agheader.c              |    2 +-
 scrub/agheader_repair.c       |    2 +-
 scrub/alloc.c                 |    2 +-
 scrub/alloc_repair.c          |    2 +-
 scrub/attr.c                  |    2 +-
 scrub/attr_repair.c           |    2 +-
 scrub/bitmap.c                |    2 +-
 scrub/bmap.c                  |    2 +-
 scrub/bmap_repair.c           |    2 +-
 scrub/btree.c                 |    2 +-
 scrub/common.c                |    2 +-
 scrub/cow_repair.c            |    2 +-
 scrub/dabtree.c               |    2 +-
 scrub/dir.c                   |    2 +-
 scrub/dir_repair.c            |    2 +-
 scrub/dirtree.c               |    2 +-
 scrub/dirtree_repair.c        |    2 +-
 scrub/dqiterate.c             |    2 +-
 scrub/findparent.c            |    2 +-
 scrub/fscounters.c            |    2 +-
 scrub/fscounters_repair.c     |    2 +-
 scrub/health.c                |    2 +-
 scrub/ialloc.c                |    2 +-
 scrub/ialloc_repair.c         |    2 +-
 scrub/inode.c                 |    2 +-
 scrub/inode_repair.c          |    2 +-
 scrub/iscan.c                 |    2 +-
 scrub/listxattr.c             |    2 +-
 scrub/metapath.c              |    2 +-
 scrub/newbt.c                 |    2 +-
 scrub/nlinks.c                |    2 +-
 scrub/nlinks_repair.c         |    2 +-
 scrub/orphanage.c             |    2 +-
 scrub/parent.c                |    2 +-
 scrub/parent_repair.c         |    2 +-
 scrub/quota.c                 |    2 +-
 scrub/quota_repair.c          |    2 +-
 scrub/quotacheck.c            |    2 +-
 scrub/quotacheck_repair.c     |    2 +-
 scrub/rcbag.c                 |    2 +-
 scrub/rcbag_btree.c           |    2 +-
 scrub/readdir.c               |    2 +-
 scrub/reap.c                  |    2 +-
 scrub/refcount.c              |    2 +-
 scrub/refcount_repair.c       |    2 +-
 scrub/repair.c                |    2 +-
 scrub/rgsuper.c               |    2 +-
 scrub/rmap.c                  |    2 +-
 scrub/rmap_repair.c           |    2 +-
 scrub/rtbitmap.c              |    2 +-
 scrub/rtbitmap_repair.c       |    2 +-
 scrub/rtrefcount.c            |    2 +-
 scrub/rtrefcount_repair.c     |    2 +-
 scrub/rtrmap.c                |    2 +-
 scrub/rtrmap_repair.c         |    2 +-
 scrub/rtsummary.c             |    2 +-
 scrub/rtsummary_repair.c      |    2 +-
 scrub/scrub.c                 |    2 +-
 scrub/stats.c                 |    2 +-
 scrub/symlink.c               |    2 +-
 scrub/symlink_repair.c        |    2 +-
 scrub/tempfile.c              |    2 +-
 scrub/trace.c                 |    2 +-
 scrub/xfarray.c               |    2 +-
 scrub/xfblob.c                |    2 +-
 scrub/xfile.c                 |    2 +-
 xfs_acl.c                     |    2 +-
 xfs_aops.c                    |    2 +-
 xfs_attr_inactive.c           |    2 +-
 xfs_attr_item.c               |    2 +-
 xfs_attr_list.c               |    2 +-
 xfs_bio_io.c                  |    2 +-
 xfs_bmap_item.c               |    2 +-
 xfs_bmap_util.c               |    2 +-
 xfs_buf.c                     |    2 +-
 xfs_buf_item.c                |    2 +-
 xfs_buf_item_recover.c        |    2 +-
 xfs_buf_mem.c                 |    2 +-
 xfs_dahash_test.c             |    2 +-
 xfs_dir2_readdir.c            |    2 +-
 xfs_discard.c                 |    2 +-
 xfs_dquot.c                   |    2 +-
 xfs_dquot_item.c              |    2 +-
 xfs_dquot_item_recover.c      |    2 +-
 xfs_drain.c                   |    2 +-
 xfs_error.c                   |    2 +-
 xfs_exchmaps_item.c           |    2 +-
 xfs_exchrange.c               |    2 +-
 xfs_export.c                  |    2 +-
 xfs_extent_busy.c             |    2 +-
 xfs_extfree_item.c            |    2 +-
 xfs_file.c                    |    2 +-
 xfs_filestream.c              |    2 +-
 xfs_fsmap.c                   |    2 +-
 xfs_fsops.c                   |    2 +-
 xfs_globals.c                 |    2 +-
 xfs_handle.c                  |    2 +-
 xfs_health.c                  |    2 +-
 xfs_hooks.c                   |    2 +-
 xfs_icache.c                  |    2 +-
 xfs_icreate_item.c            |    2 +-
 xfs_inode.c                   |    2 +-
 xfs_inode_item.c              |    2 +-
 xfs_inode_item_recover.c      |    2 +-
 xfs_ioctl.c                   |    2 +-
 xfs_ioctl32.c                 |    2 +-
 xfs_iomap.c                   |    2 +-
 xfs_iops.c                    |    2 +-
 xfs_itable.c                  |    2 +-
 xfs_iunlink_item.c            |    2 +-
 xfs_iwalk.c                   |    2 +-
 xfs_log.c                     |    2 +-
 xfs_log_cil.c                 |    2 +-
 xfs_log_recover.c             |    2 +-
 xfs_message.c                 |    2 +-
 xfs_mount.c                   |    2 +-
 xfs_mru_cache.c               |    2 +-
 xfs_notify_failure.c          |    2 +-
 xfs_pnfs.c                    |    2 +-
 xfs_priv.h                    |    2 +-
 xfs_pwork.c                   |    2 +-
 xfs_qm.c                      |    2 +-
 xfs_qm_bhv.c                  |    2 +-
 xfs_qm_syscalls.c             |    2 +-
 xfs_quotaops.c                |    2 +-
 xfs_refcount_item.c           |    2 +-
 xfs_reflink.c                 |    2 +-
 xfs_rmap_item.c               |    2 +-
 xfs_rtalloc.c                 |    2 +-
 xfs_stats.c                   |    2 +-
 xfs_super.c                   |    2 +-
 xfs_symlink.c                 |    2 +-
 xfs_sysctl.c                  |    2 +-
 xfs_sysfs.c                   |    2 +-
 xfs_trace.c                   |    2 +-
 xfs_trans.c                   |    2 +-
 xfs_trans_ail.c               |    2 +-
 xfs_trans_buf.c               |    2 +-
 xfs_trans_dquot.c             |    2 +-
 xfs_xattr.c                   |    2 +-
 xfs_zone_alloc.c              |    2 +-
 xfs_zone_gc.c                 |    2 +-
 xfs_zone_info.c               |    2 +-
 xfs_zone_space_resv.c         |    2 +-
 194 files changed, 194 insertions(+), 194 deletions(-)
