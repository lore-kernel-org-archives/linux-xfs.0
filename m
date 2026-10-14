Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7123D4D0A01
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 12:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982483; cv=none; b=X9n+cSnleiw6Eqnb15GPi5yaEJJmpjw+W+8UMRnlUtrU47obJNTm4kcgtGXXdjlb0+4lDnEFwXF1IIRbtGRJqOdthwDnKW1PwUj0qm6TkpsTnRhxgMzTRi8zrLtjFVtjidMVEsHoCr3HHL5U4jFRqncyyf6yCx51Hr4PBs16ApU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982483; c=relaxed/simple;
	bh=PrnogLmwKpONs7TFMFlpRYQh5X9k6qxN9XVQHKuZfTM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kdGt4LMSzUyfOGvtHmx+7+P68QejjnHj4JrhOpjruJn91dRpRA6tNt81Q/0xyzXPeWgs03zl9xPMULvak0+M76c6fPuFdPOtxeI6mVHIdliQav7Hc3fpYW+OBTyeqWVyQsUU+aO2WEOOogtX+g/RfdY4rPC+SshpTMOxsyP4FY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vch4NMS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vch4NMS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E001F000FF;
	Wed, 14 Oct 2026 12:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791982472;
	bh=p+zk2EyNzsjkDeF4zVsmzVn2CF9gqf9OmZeDM/r6BeM=;
	h=Date:From:To:Cc:Subject;
	b=Vch4NMS1wmQTGrpDx4S8H3pdZBc6+i7pKp1bCfl0u2ibyxKmEF8HlLC8kdW/1r3/x
	 mMSPSuM11PlUxDVqf90M5tZs0RIEuAnJdFwWDZ8+XQuRWk9taP9q96z110C6wMd6Jf
	 A0kHaiyteSnM+3w6dFNa+a9/ZU46WqIb97dqZwUgtSs6aWQ0tGcUm1Fq2OY8CPvJ+j
	 RGJdWNsTJhSjT3jzWJCvKYGPqkR3l+Dnnq3BWffCKvCjNXUDfZ1txrGgqWa5ipXVJl
	 JMGLyGLSrpgzU11qf3XSx7iBvviFqcHKe14xol9gb04gqLJIcKpikpunuGtk/fQMCj
	 udVtyeQIL4QQw==
Date: Wed, 14 Oct 2026 14:54:29 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, djwong@kernel.org, hch@lst.de
Subject: [ANNOUNCE] xfsprogs: for-next updated to 989686ca4e74
Message-ID: <as97dXSrQSV17HOZ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
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

989686ca4e7462902796e2d9563e016f85ee4173

New commits:

Christoph Hellwig (13):
      [9c2eaf73c5c2] libxfs: use libxfs.h in xfs_platform.h
      [33ac6b04db36] libxfs: provide memalloc_nofs_{save,restore} stubs
      [9eff420fe37f] libxfs: remove a spurious xfs_rtbitmap.h include in xfs_sb.c
      [4f91e3833ef1] libxfs: move the xfs_rtbitmap.h include in xfs_bmap.c
      [d4eae695d6fa] libxfs: remove the unused xfs_log_item.li_mountp field
      [02cc96ba6bd3] libxfs: remove the unused xfs_inode_log_item.ili_fsync_fields field
      [d6af7a826718] libxfs: remove the xfs_log_item_t and xfs_buf_log_item_t typedefs
      [54b8f286f080] libxfs: remove libxfs_trans_alloc_rollable
      [7d413dd9c5f2] libxfs: return int from xfs_buf_item_init
      [31d51bd0c487] libxfs: use xfs_buf_item.h and xfs_inode_item.h from the kernel source
      [7e217148b3eb] libxfs: cleanup xfs_trans.h
      [fa19604607c1] libxfs: use xfs_trans.h from the kernel source
      [809419124ced] libxfs: use all log item headers from the kernel

Darrick J. Wong (2):
      [6c62ff9b47e9] misc: convert as many xfsquotactl callsites to xfrog_quotactl as possible
      [989686ca4e74] quotactl: deploy typechecked helpers

Code Diffstat:

 db/logformat.c                           |   4 +
 include/atomic.h                         |   1 +
 include/libxfs.h                         |   4 +-
 libfrog/quotactl.h                       |  60 +++++++
 libxfs/Makefile                          |  18 +-
 libxfs/buf_mem.c                         |   1 +
 libxfs/defer_item.c                      |   3 +-
 libxfs/defer_item.h                      |  56 ------
 libxfs/init.c                            |   2 +
 libxfs/inode.c                           |   1 +
 libxfs/iunlink.c                         |  10 +-
 libxfs/libxfs_api_defs.h                 |   1 +
 libxfs/logitem.c                         |  19 ++-
 libxfs/stubs/xfs_inode.h                 |   8 +
 libxfs/stubs/xfs_log.h                   |   7 +
 libxfs/stubs/xfs_trans.h                 | 167 ------------------
 libxfs/stubs/xfs_trans_priv.h            |  16 ++
 libxfs/trans.c                           |  64 ++++---
 libxfs/util.c                            |   1 -
 libxfs/xfs_alloc.c                       |   4 +-
 libxfs/xfs_attr.c                        |   2 +-
 libxfs/xfs_attr_item.h                   |  64 +++++++
 libxfs/xfs_attr_leaf.c                   |   2 +
 libxfs/xfs_bmap.c                        |   5 +-
 libxfs/xfs_bmap_item.h                   |  78 +++++++++
 libxfs/xfs_btree.c                       |   2 +
 libxfs/xfs_btree_mem.c                   |   1 +
 libxfs/xfs_buf_item.h                    |  71 ++++++++
 libxfs/xfs_da_btree.c                    |   2 +
 libxfs/xfs_defer.c                       |   4 +
 libxfs/xfs_dir2_block.c                  |   2 +
 libxfs/xfs_dir2_data.c                   |   2 +
 libxfs/xfs_dir2_leaf.c                   |   1 +
 libxfs/xfs_dir2_node.c                   |   2 +
 libxfs/xfs_exchmaps.c                    |   2 +-
 libxfs/xfs_exchmaps_item.h               |  64 +++++++
 libxfs/xfs_extfree_item.h                | 100 +++++++++++
 libxfs/xfs_ialloc.c                      |   3 +
 libxfs/xfs_icreate_item.h                |  22 +++
 libxfs/xfs_inode_fork.c                  |   1 +
 libxfs/xfs_inode_item.h                  |  62 +++++++
 libxfs/xfs_inode_util.c                  |   3 +-
 libxfs/{iunlink.h => xfs_iunlink_item.h} |  17 +-
 libxfs/xfs_parent.c                      |   2 +-
 libxfs/xfs_platform.h                    |  57 +------
 libxfs/xfs_refcount.c                    |   2 +-
 libxfs/xfs_refcount_item.h               |  82 +++++++++
 libxfs/xfs_rmap.c                        |   2 +-
 libxfs/xfs_rmap_item.h                   |  81 +++++++++
 libxfs/xfs_rtbitmap.c                    |   2 +
 libxfs/xfs_rtgroup.c                     |   1 +
 libxfs/xfs_sb.c                          |   3 +-
 libxfs/xfs_symlink_remote.c              |   2 +
 libxfs/xfs_trans.h                       | 283 +++++++++++++++++++++++++++++++
 libxfs/xfs_trans_inode.c                 |   3 +-
 libxfs/xfs_trans_resv.c                  |   8 +-
 mkfs/proto.c                             |   8 +-
 mkfs/xfs_mkfs.c                          |   3 +-
 quota/edit.c                             |  84 ++++-----
 quota/free.c                             |   6 +-
 quota/path.c                             |   2 +-
 quota/quota.c                            |   4 +-
 quota/report.c                           |  22 +--
 quota/state.c                            |  12 +-
 repair/phase2.c                          |   1 +
 repair/phase5.c                          |   3 +-
 repair/phase6.c                          |   3 +-
 repair/rmap.c                            |   5 +-
 spaceman/info.c                          |  15 +-
 69 files changed, 1228 insertions(+), 427 deletions(-)
 delete mode 100644 libxfs/defer_item.h
 create mode 100644 libxfs/stubs/xfs_log.h
 delete mode 100644 libxfs/stubs/xfs_trans.h
 create mode 100644 libxfs/stubs/xfs_trans_priv.h
 create mode 100644 libxfs/xfs_attr_item.h
 create mode 100644 libxfs/xfs_bmap_item.h
 create mode 100644 libxfs/xfs_buf_item.h
 create mode 100644 libxfs/xfs_exchmaps_item.h
 create mode 100644 libxfs/xfs_extfree_item.h
 create mode 100644 libxfs/xfs_icreate_item.h
 create mode 100644 libxfs/xfs_inode_item.h
 rename libxfs/{iunlink.h => xfs_iunlink_item.h} (61%)
 create mode 100644 libxfs/xfs_refcount_item.h
 create mode 100644 libxfs/xfs_rmap_item.h
 create mode 100644 libxfs/xfs_trans.h

-- 
- Andrey
