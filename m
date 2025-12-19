Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B627217AE11
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 05:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766122931; cv=none; b=VhB9JrGQO7lD2kzSnejuKmNtmEZAIGhOkQQndghY2MI35vr9jR84tWptqs1EWkMe7UR6IYQ9Fqv8CaDa0xIb5RWGMW2O8v5ECswf8SpmukPN4o2x/3+t7vfYJ75HlDNtlbiBBAaXd52IwbLkKNKibXbR+GTn863SLg2HiIP2HUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766122931; c=relaxed/simple;
	bh=YgrMpo0MI1KXsYI9W05rNBLIeVUoo+S7fp3CJinUzvA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jLWd0Aum/F8qDE8LHG2HDgxSeRr2j7lWOWqOUbtEmG7L7I7IyxKs9fR5AALm+NwPBNC7fmstG5qEEQG05NqfIMrU1VYDv3HTht9Ok3hbM0jf+lqlUw/w9SxJhvYj9gviWj21uvbFuHZOnsThq19M13lX3P0KruqUvPj/5Qy/mxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=byxZ4TIo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="byxZ4TIo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=uXKYvWyW3I10sxdyCmAGUERqsJ7sv/xGBRGDr5NgZoU=; b=byxZ4TIo50xOPy5TZW65fgWbw3
	AMi9GgXr13p2kiZ/oQk+fjgcPNtmiUq8qBqnRWPojmIEveqbaQDXfxImrMOOAlvu3fX4klZ+w7kXP
	q1979EY7U8Uqj4p2Rw9LTvo8Y6R3W5bZcMCCFoDkZJHesRcaK+ZBf41kg4wY6Xge415leNaTybVN/
	pkw7HFtoRUfwjq1vAffSOOgxoYMC+WqQFbJDSewpccfZT1kXVrjgHTAtMkIqdYbxTArl6bZo70EE+
	n69McKtk4qxOQ+GlV0nkt4C8R7qR3+sN6bpobN+qK+8m2GqG3w7fPWErs0Ay55Sv1ltcC4TUMY9RB
	AOPxOmiw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWTFe-00000009fHV-1NqX;
	Fri, 19 Dec 2025 05:42:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2] rename xfs.h
Date: Fri, 19 Dec 2025 06:41:43 +0100
Message-ID: <20251219054202.1773441-1-hch@lst.de>
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

This patch renames xfs.h in the kernel tree to xfs_plaform.h, a name that
is still available in xfsprogs.  Any other name fitting that criteria
should work just as well, I'm open to better suggestion if there are
any.

Diffstat:
 b/fs/xfs/libxfs/xfs_ag.c               |    2 -
 b/fs/xfs/libxfs/xfs_ag_resv.c          |    2 -
 b/fs/xfs/libxfs/xfs_alloc.c            |    2 -
 b/fs/xfs/libxfs/xfs_alloc_btree.c      |    2 -
 b/fs/xfs/libxfs/xfs_attr.c             |    2 -
 b/fs/xfs/libxfs/xfs_attr_leaf.c        |    2 -
 b/fs/xfs/libxfs/xfs_attr_remote.c      |    2 -
 b/fs/xfs/libxfs/xfs_bit.c              |    2 -
 b/fs/xfs/libxfs/xfs_bmap.c             |    2 -
 b/fs/xfs/libxfs/xfs_bmap_btree.c       |    2 -
 b/fs/xfs/libxfs/xfs_btree.c            |    2 -
 b/fs/xfs/libxfs/xfs_btree_mem.c        |    2 -
 b/fs/xfs/libxfs/xfs_btree_staging.c    |    2 -
 b/fs/xfs/libxfs/xfs_da_btree.c         |    2 -
 b/fs/xfs/libxfs/xfs_defer.c            |    2 -
 b/fs/xfs/libxfs/xfs_dir2.c             |    2 -
 b/fs/xfs/libxfs/xfs_dir2_block.c       |    2 -
 b/fs/xfs/libxfs/xfs_dir2_data.c        |    2 -
 b/fs/xfs/libxfs/xfs_dir2_leaf.c        |    2 -
 b/fs/xfs/libxfs/xfs_dir2_node.c        |    2 -
 b/fs/xfs/libxfs/xfs_dir2_sf.c          |    2 -
 b/fs/xfs/libxfs/xfs_dquot_buf.c        |    2 -
 b/fs/xfs/libxfs/xfs_exchmaps.c         |    2 -
 b/fs/xfs/libxfs/xfs_group.c            |    2 -
 b/fs/xfs/libxfs/xfs_ialloc.c           |    2 -
 b/fs/xfs/libxfs/xfs_ialloc_btree.c     |    2 -
 b/fs/xfs/libxfs/xfs_iext_tree.c        |    2 -
 b/fs/xfs/libxfs/xfs_inode_buf.c        |    2 -
 b/fs/xfs/libxfs/xfs_inode_fork.c       |    2 -
 b/fs/xfs/libxfs/xfs_inode_util.c       |    2 -
 b/fs/xfs/libxfs/xfs_log_rlimit.c       |    2 -
 b/fs/xfs/libxfs/xfs_metadir.c          |    2 -
 b/fs/xfs/libxfs/xfs_metafile.c         |    2 -
 b/fs/xfs/libxfs/xfs_parent.c           |    2 -
 b/fs/xfs/libxfs/xfs_refcount.c         |    2 -
 b/fs/xfs/libxfs/xfs_refcount_btree.c   |    2 -
 b/fs/xfs/libxfs/xfs_rmap.c             |    2 -
 b/fs/xfs/libxfs/xfs_rmap_btree.c       |    2 -
 b/fs/xfs/libxfs/xfs_rtbitmap.c         |    2 -
 b/fs/xfs/libxfs/xfs_rtgroup.c          |    2 -
 b/fs/xfs/libxfs/xfs_rtrefcount_btree.c |    2 -
 b/fs/xfs/libxfs/xfs_rtrmap_btree.c     |    2 -
 b/fs/xfs/libxfs/xfs_sb.c               |    2 -
 b/fs/xfs/libxfs/xfs_symlink_remote.c   |    2 -
 b/fs/xfs/libxfs/xfs_trans_inode.c      |    2 -
 b/fs/xfs/libxfs/xfs_trans_resv.c       |    2 -
 b/fs/xfs/libxfs/xfs_trans_space.c      |    2 -
 b/fs/xfs/libxfs/xfs_types.c            |    2 -
 b/fs/xfs/libxfs/xfs_zones.c            |    2 -
 b/fs/xfs/scrub/agb_bitmap.c            |    2 -
 b/fs/xfs/scrub/agheader.c              |    2 -
 b/fs/xfs/scrub/agheader_repair.c       |    2 -
 b/fs/xfs/scrub/alloc.c                 |    2 -
 b/fs/xfs/scrub/alloc_repair.c          |    2 -
 b/fs/xfs/scrub/attr.c                  |    2 -
 b/fs/xfs/scrub/attr_repair.c           |    2 -
 b/fs/xfs/scrub/bitmap.c                |    2 -
 b/fs/xfs/scrub/bmap.c                  |    2 -
 b/fs/xfs/scrub/bmap_repair.c           |    2 -
 b/fs/xfs/scrub/btree.c                 |    2 -
 b/fs/xfs/scrub/common.c                |    2 -
 b/fs/xfs/scrub/cow_repair.c            |    2 -
 b/fs/xfs/scrub/dabtree.c               |    2 -
 b/fs/xfs/scrub/dir.c                   |    2 -
 b/fs/xfs/scrub/dir_repair.c            |    2 -
 b/fs/xfs/scrub/dirtree.c               |    2 -
 b/fs/xfs/scrub/dirtree_repair.c        |    2 -
 b/fs/xfs/scrub/dqiterate.c             |    2 -
 b/fs/xfs/scrub/findparent.c            |    2 -
 b/fs/xfs/scrub/fscounters.c            |    2 -
 b/fs/xfs/scrub/fscounters_repair.c     |    2 -
 b/fs/xfs/scrub/health.c                |    2 -
 b/fs/xfs/scrub/ialloc.c                |    2 -
 b/fs/xfs/scrub/ialloc_repair.c         |    2 -
 b/fs/xfs/scrub/inode.c                 |    2 -
 b/fs/xfs/scrub/inode_repair.c          |    2 -
 b/fs/xfs/scrub/iscan.c                 |    2 -
 b/fs/xfs/scrub/listxattr.c             |    2 -
 b/fs/xfs/scrub/metapath.c              |    2 -
 b/fs/xfs/scrub/newbt.c                 |    2 -
 b/fs/xfs/scrub/nlinks.c                |    2 -
 b/fs/xfs/scrub/nlinks_repair.c         |    2 -
 b/fs/xfs/scrub/orphanage.c             |    2 -
 b/fs/xfs/scrub/parent.c                |    2 -
 b/fs/xfs/scrub/parent_repair.c         |    2 -
 b/fs/xfs/scrub/quota.c                 |    2 -
 b/fs/xfs/scrub/quota_repair.c          |    2 -
 b/fs/xfs/scrub/quotacheck.c            |    2 -
 b/fs/xfs/scrub/quotacheck_repair.c     |    2 -
 b/fs/xfs/scrub/rcbag.c                 |    2 -
 b/fs/xfs/scrub/rcbag_btree.c           |    2 -
 b/fs/xfs/scrub/readdir.c               |    2 -
 b/fs/xfs/scrub/reap.c                  |    2 -
 b/fs/xfs/scrub/refcount.c              |    2 -
 b/fs/xfs/scrub/refcount_repair.c       |    2 -
 b/fs/xfs/scrub/repair.c                |    2 -
 b/fs/xfs/scrub/rgsuper.c               |    2 -
 b/fs/xfs/scrub/rmap.c                  |    2 -
 b/fs/xfs/scrub/rmap_repair.c           |    2 -
 b/fs/xfs/scrub/rtbitmap.c              |    2 -
 b/fs/xfs/scrub/rtbitmap_repair.c       |    2 -
 b/fs/xfs/scrub/rtrefcount.c            |    2 -
 b/fs/xfs/scrub/rtrefcount_repair.c     |    2 -
 b/fs/xfs/scrub/rtrmap.c                |    2 -
 b/fs/xfs/scrub/rtrmap_repair.c         |    2 -
 b/fs/xfs/scrub/rtsummary.c             |    2 -
 b/fs/xfs/scrub/rtsummary_repair.c      |    2 -
 b/fs/xfs/scrub/scrub.c                 |    2 -
 b/fs/xfs/scrub/stats.c                 |    2 -
 b/fs/xfs/scrub/symlink.c               |    2 -
 b/fs/xfs/scrub/symlink_repair.c        |    2 -
 b/fs/xfs/scrub/tempfile.c              |    2 -
 b/fs/xfs/scrub/trace.c                 |    2 -
 b/fs/xfs/scrub/xfarray.c               |    2 -
 b/fs/xfs/scrub/xfblob.c                |    2 -
 b/fs/xfs/scrub/xfile.c                 |    2 -
 b/fs/xfs/xfs_acl.c                     |    2 -
 b/fs/xfs/xfs_aops.c                    |    2 -
 b/fs/xfs/xfs_attr_inactive.c           |    2 -
 b/fs/xfs/xfs_attr_item.c               |    2 -
 b/fs/xfs/xfs_attr_list.c               |    2 -
 b/fs/xfs/xfs_bio_io.c                  |    2 -
 b/fs/xfs/xfs_bmap_item.c               |    2 -
 b/fs/xfs/xfs_bmap_util.c               |    2 -
 b/fs/xfs/xfs_buf.c                     |    2 -
 b/fs/xfs/xfs_buf_item.c                |    2 -
 b/fs/xfs/xfs_buf_item_recover.c        |    2 -
 b/fs/xfs/xfs_buf_mem.c                 |    2 -
 b/fs/xfs/xfs_dahash_test.c             |    2 -
 b/fs/xfs/xfs_dir2_readdir.c            |    2 -
 b/fs/xfs/xfs_discard.c                 |    2 -
 b/fs/xfs/xfs_dquot.c                   |    2 -
 b/fs/xfs/xfs_dquot_item.c              |    2 -
 b/fs/xfs/xfs_dquot_item_recover.c      |    2 -
 b/fs/xfs/xfs_drain.c                   |    2 -
 b/fs/xfs/xfs_error.c                   |    2 -
 b/fs/xfs/xfs_exchmaps_item.c           |    2 -
 b/fs/xfs/xfs_exchrange.c               |    2 -
 b/fs/xfs/xfs_export.c                  |    2 -
 b/fs/xfs/xfs_extent_busy.c             |    2 -
 b/fs/xfs/xfs_extfree_item.c            |    2 -
 b/fs/xfs/xfs_file.c                    |    2 -
 b/fs/xfs/xfs_filestream.c              |    2 -
 b/fs/xfs/xfs_fsmap.c                   |    2 -
 b/fs/xfs/xfs_fsops.c                   |    2 -
 b/fs/xfs/xfs_globals.c                 |    2 -
 b/fs/xfs/xfs_handle.c                  |    2 -
 b/fs/xfs/xfs_health.c                  |    2 -
 b/fs/xfs/xfs_hooks.c                   |    2 -
 b/fs/xfs/xfs_icache.c                  |    2 -
 b/fs/xfs/xfs_icreate_item.c            |    2 -
 b/fs/xfs/xfs_inode.c                   |    2 -
 b/fs/xfs/xfs_inode_item.c              |    2 -
 b/fs/xfs/xfs_inode_item_recover.c      |    2 -
 b/fs/xfs/xfs_ioctl.c                   |    2 -
 b/fs/xfs/xfs_ioctl32.c                 |    2 -
 b/fs/xfs/xfs_iomap.c                   |    2 -
 b/fs/xfs/xfs_iops.c                    |    2 -
 b/fs/xfs/xfs_itable.c                  |    2 -
 b/fs/xfs/xfs_iunlink_item.c            |    2 -
 b/fs/xfs/xfs_iwalk.c                   |    2 -
 b/fs/xfs/xfs_log.c                     |    2 -
 b/fs/xfs/xfs_log_cil.c                 |    2 -
 b/fs/xfs/xfs_log_recover.c             |    2 -
 b/fs/xfs/xfs_message.c                 |    2 -
 b/fs/xfs/xfs_mount.c                   |    2 -
 b/fs/xfs/xfs_mru_cache.c               |    2 -
 b/fs/xfs/xfs_notify_failure.c          |    2 -
 b/fs/xfs/xfs_platform.h                |   46 ++++++++++++++++++++-------------
 b/fs/xfs/xfs_pnfs.c                    |    2 -
 b/fs/xfs/xfs_pwork.c                   |    2 -
 b/fs/xfs/xfs_qm.c                      |    2 -
 b/fs/xfs/xfs_qm_bhv.c                  |    2 -
 b/fs/xfs/xfs_qm_syscalls.c             |    2 -
 b/fs/xfs/xfs_quotaops.c                |    2 -
 b/fs/xfs/xfs_refcount_item.c           |    2 -
 b/fs/xfs/xfs_reflink.c                 |    2 -
 b/fs/xfs/xfs_rmap_item.c               |    2 -
 b/fs/xfs/xfs_rtalloc.c                 |    2 -
 b/fs/xfs/xfs_stats.c                   |    2 -
 b/fs/xfs/xfs_super.c                   |    2 -
 b/fs/xfs/xfs_symlink.c                 |    2 -
 b/fs/xfs/xfs_sysctl.c                  |    2 -
 b/fs/xfs/xfs_sysfs.c                   |    2 -
 b/fs/xfs/xfs_trace.c                   |    2 -
 b/fs/xfs/xfs_trans.c                   |    2 -
 b/fs/xfs/xfs_trans_ail.c               |    2 -
 b/fs/xfs/xfs_trans_buf.c               |    2 -
 b/fs/xfs/xfs_trans_dquot.c             |    2 -
 b/fs/xfs/xfs_xattr.c                   |    2 -
 b/fs/xfs/xfs_zone_alloc.c              |    2 -
 b/fs/xfs/xfs_zone_gc.c                 |    2 -
 b/fs/xfs/xfs_zone_info.c               |    2 -
 b/fs/xfs/xfs_zone_space_resv.c         |    2 -
 fs/xfs/xfs.h                           |   28 --------------------
 195 files changed, 222 insertions(+), 238 deletions(-)
