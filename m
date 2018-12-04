Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42354 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbeLDR7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Dec 2018 12:59:50 -0500
Date: Tue, 4 Dec 2018 09:59:31 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 8f67b5adc030
Message-ID: <20181204175931.GH24487@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Zorro Lang <zlang@redhat.com>

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  Hopefully this will be the last of the 4.20 fixes
so I can actually get on to reviewing things for 5.0.

The new head of the for-next branch is commit:

8f67b5adc030 iomap: partially revert 4721a601099 (simulated directio short read on EFAULT)

New Commits:

Darrick J. Wong (4):
      [a579121f94ab] xfs: fix PAGE_MASK usage in xfs_free_file_space
      [6744557b53a2] vfs: allow some remap flags to be passed to vfs_clone_file_range
      [17614445576b] splice: don't read more than available pipe space
      [8f67b5adc030] iomap: partially revert 4721a601099 (simulated directio short read on EFAULT)

Eric Sandeen (1):
      [7d048df4e9b0] xfs: fix inverted return from xfs_btree_sblock_verify_crc

Ye Yin (1):
      [de7243057e7c] fs/xfs: fix f_ffree value for statfs when project quota is set


Code Diffstat:

 fs/iomap.c                | 9 ---------
 fs/read_write.c           | 2 +-
 fs/splice.c               | 7 ++++++-
 fs/xfs/libxfs/xfs_btree.c | 2 +-
 fs/xfs/xfs_bmap_util.c    | 4 ++--
 fs/xfs/xfs_qm_bhv.c       | 2 +-
 6 files changed, 11 insertions(+), 15 deletions(-)
