Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39511 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbdH3QIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 12:08:43 -0400
Date: Wed, 30 Aug 2017 09:08:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 0/9] xfs: refactor ordered buffer logging code
Message-ID: <20170830160839.GK4757@magnolia>
References: <20170829143758.58990-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829143758.58990-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2017 at 10:37:49AM -0400, Brian Foster wrote:
> Hi all,
> 
> Here's v2 of the ordered buffer / buffer relogging refactoring series.
> Only minor updates in this version. I've also tagged patch 6 for stable
> as it fixes a log recovery regression for bmbt owner change operations.

Seems to have passed testing cycle, queued for next.

--D

> 
> Brian
> 
> v2:
> - Various cleanups.
> - Rename bmbt scan invalid owner flag.
> - Added stable CC for bmbt owner change log recovery fix (6/9).
> v1: https://marc.info/?l=linux-xfs&m=150367356112090&w=2
> - Drop unnecessary buffer type set in xfs_btree_block_change_owner().
> - Several new cleanup patches.
> - Fix bmbt owner change (extent swap) log recovery.
> - Update buffer ordering to fail on previously dirty buffers.
> - Rework bmbt owner change to use ordered buffers correctly.
> rfc: https://marc.info/?l=linux-xfs&m=150272969407981&w=2
> 
> Brian Foster (9):
>   xfs: open-code xfs_buf_item_dirty()
>   xfs: remove unnecessary dirty bli format check for ordered bufs
>   xfs: ordered buffer log items are never formatted
>   xfs: refactor buffer logging into buffer dirtying helper
>   xfs: don't log dirty ranges for ordered buffers
>   xfs: skip bmbt block ino validation during owner change
>   xfs: move bmbt owner change to last step of extent swap
>   xfs: disallow marking previously dirty buffers as ordered
>   xfs: relog dirty buffers during swapext bmbt owner change
> 
>  fs/xfs/libxfs/xfs_bmap_btree.c |  1 +
>  fs/xfs/libxfs/xfs_btree.c      | 27 ++++++++----
>  fs/xfs/libxfs/xfs_btree.h      |  3 +-
>  fs/xfs/libxfs/xfs_ialloc.c     |  2 -
>  fs/xfs/xfs_bmap_util.c         | 93 +++++++++++++++++++++++++++++++-----------
>  fs/xfs/xfs_buf_item.c          | 75 +++++++++++++---------------------
>  fs/xfs/xfs_buf_item.h          |  2 +-
>  fs/xfs/xfs_trace.h             |  1 -
>  fs/xfs/xfs_trans.h             |  6 ++-
>  fs/xfs/xfs_trans_buf.c         | 79 +++++++++++++++++++++--------------
>  10 files changed, 173 insertions(+), 116 deletions(-)
> 
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
