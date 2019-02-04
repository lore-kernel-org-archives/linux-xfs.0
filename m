Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbfBDQye (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Feb 2019 11:54:34 -0500
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 00/10] xfs: stable fixes for v4.19.y
Date: Mon,  4 Feb 2019 08:54:17 -0800
Message-Id: <20190204165427.23607-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, Luis Chamberlain <mcgrof@kernel.org>

Kernel stable team,

here is a v2 respin of my XFS stable patches for v4.19.y. The only
change in this series is adding the upstream commit to the commit log,
and I've now also Cc'd stable@vger.kernel.org as well. No other issues
were spotted or raised with this series.

Reviews, questions, or rants are greatly appreciated.

  Luis

Brian Foster (1):
  xfs: fix shared extent data corruption due to missing cow reservation

Carlos Maiolino (1):
  xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat

Christoph Hellwig (1):
  xfs: cancel COW blocks before swapext

Christophe JAILLET (1):
  xfs: Fix error code in 'xfs_ioc_getbmap()'

Darrick J. Wong (1):
  xfs: fix PAGE_MASK usage in xfs_free_file_space

Dave Chinner (3):
  xfs: fix overflow in xfs_attr3_leaf_verify
  xfs: fix transient reference count error in
    xfs_buf_resubmit_failed_buffers
  xfs: delalloc -> unwritten COW fork allocation can go wrong

Eric Sandeen (1):
  xfs: fix inverted return from xfs_btree_sblock_verify_crc

Ye Yin (1):
  fs/xfs: fix f_ffree value for statfs when project quota is set

 fs/xfs/libxfs/xfs_attr_leaf.c | 11 +++++++++--
 fs/xfs/libxfs/xfs_bmap.c      |  5 ++++-
 fs/xfs/libxfs/xfs_btree.c     |  2 +-
 fs/xfs/xfs_bmap_util.c        | 10 ++++++++--
 fs/xfs/xfs_buf_item.c         | 28 +++++++++++++++++++++-------
 fs/xfs/xfs_ioctl.c            |  2 +-
 fs/xfs/xfs_qm_bhv.c           |  2 +-
 fs/xfs/xfs_reflink.c          |  1 +
 fs/xfs/xfs_stats.c            |  2 +-
 9 files changed, 47 insertions(+), 16 deletions(-)

-- 
2.18.0
