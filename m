Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E5FC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 00:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2DB9611C3
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 00:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235554AbhIRAE4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:04:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230379AbhIRAE4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 20:04:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8867260F51;
        Sat, 18 Sep 2021 00:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631923413;
        bh=HtQI9JwI2+8PnWmq8AJ7xzV3AvN1zoixQbcei+v3h4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lqJP7DGYfDctXuMQSNfgEb+mUuh5nHj33lmouXQ6zr1hSiHKC+BKT8rs+tbgGt2g3
         oF4IPjLqS0lA5crPh7Z+d/6dSd+CC7srsOZWTcB0V6D39F3YHRVc84g5F3mEVoBV1H
         RZO8h7IpJF9nClB58IHIfOfplYhh9MF795sp/44A9nOGA2XA3GwhbINNaAvcqCa7UD
         Vp5xJ0EExTNJVE2Oy5Md8lfTcBhmxEtKn03PPBZp2F+jJRjpTIZLsMimG5S/iHmnEO
         spHxzAohmVTCc7gvdL1ZIlWSlxZREkVUN+KnRwPGVZ7VyYQ59SaMOApaNCOa1Vxner
         fNyU/zGfpUJxQ==
Date:   Fri, 17 Sep 2021 17:03:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V3 00/12] xfs: Extend per-inode extent counters
Message-ID: <20210918000333.GD10224@magnolia>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916100647.176018-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 03:36:35PM +0530, Chandan Babu R wrote:
> The commit xfs: fix inode fork extent count overflow
> (3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
> data fork extents should be possible to create. However the
> corresponding on-disk field has a signed 32-bit type. Hence this
> patchset extends the per-inode data extent counter to 64 bits out of
> which 48 bits are used to store the extent count. 
> 
> Also, XFS has an attr fork extent counter which is 16 bits wide. A
> workload which,
> 1. Creates 1 million 255-byte sized xattrs,
> 2. Deletes 50% of these xattrs in an alternating manner,
> 3. Tries to insert 400,000 new 255-byte sized xattrs
>    causes the xattr extent counter to overflow.
> 
> Dave tells me that there are instances where a single file has more
> than 100 million hardlinks. With parent pointers being stored in
> xattrs, we will overflow the signed 16-bits wide xattr extent counter
> when large number of hardlinks are created. Hence this patchset
> extends the on-disk field to 32-bits.
> 
> The following changes are made to accomplish this,
> 1. A new incompat superblock flag to prevent older kernels from mounting
>    the filesystem. This flag has to be set during mkfs time.
> 2. A new 64-bit inode field is created to hold the data extent
>    counter.
> 3. The existing 32-bit inode data extent counter will be used to hold
>    the attr fork extent counter.
> 
> The patchset has been tested by executing xfstests with the following
> mkfs.xfs options,
> 1. -m crc=0 -b size=1k
> 2. -m crc=0 -b size=4k
> 3. -m crc=0 -b size=512
> 4. -m rmapbt=1,reflink=1 -b size=1k
> 5. -m rmapbt=1,reflink=1 -b size=4k
> 
> Each of the above test scenarios were executed on the following
> combinations (For V4 FS test scenario, the last combination
> i.e. "Patched (enable extcnt64bit)", was omitted).
> |-------------------------------+-----------|
> | Xfsprogs                      | Kernel    |
> |-------------------------------+-----------|
> | Unpatched                     | Patched   |
> | Patched (disable extcnt64bit) | Unpatched |
> | Patched (disable extcnt64bit) | Patched   |
> | Patched (enable extcnt64bit)  | Patched   |
> |-------------------------------+-----------|
> 
> I have also written a test (yet to be converted into xfstests format)
> to check if the correct extent counter fields are updated with/without
> the new incompat flag. I have also fixed some of the existing fstests
> to work with the new extent counter fields.
> 
> Increasing data extent counter width also causes the maximum height of
> BMBT to increase. This requires that the macro XFS_BTREE_MAXLEVELS be
> updated with a larger value. However such a change causes the value of
> mp->m_rmap_maxlevels to increase which in turn causes log reservation
> sizes to increase and hence a modified XFS driver will fail to mount
> filesystems created by older versions of mkfs.xfs.
> 
> Hence this patchset is built on top of Darrick's btree-dynamic-depth
> branch which removes the macro XFS_BTREE_MAXLEVELS and computes
> mp->m_rmap_maxlevels based on the size of an AG.

I forward-ported /just/ that branch to a 5.16 dev branch and will send
that out, in case you wanted to add it to the head of your dev branch
and thereby escape relying on the bajillion patches in djwong-dev.

--D

> These patches can also be obtained from
> https://github.com/chandanr/linux.git at branch
> xfs-incompat-extend-extcnt-v3.
> 
> I will be posting the changes associated with xfsprogs separately.
> 
> Changelog:
> V2 -> V3:
> 1. Define maximum extent length as a function of
>    BMBT_BLOCKCOUNT_BITLEN.
> 2. Introduce xfs_iext_max_nextents() function in the patch series
>    before renaming MAXEXTNUM/MAXAEXTNUM. This is done to reduce
>    proliferation of macros indicating maximum extent count for data
>    and attribute forks.
> 3. Define xfs_dfork_nextents() as an inline function.
> 4. Use xfs_rfsblock_t as the data type for variables that hold block
>    count.
> 5. xfs_dfork_nextents() now returns -EFSCORRUPTED when an invalid fork
>    is passed as an argument.
> 6. The following changes are done to enable bulkstat ioctl to report
>    64-bit extent counters,
>    - Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
>      xfs_bulkstat->bs_pad[]. 
>    - Carve out a new 64-bit field xfs_bulk_ireq->bulkstat_flags from
>      xfs_bulk_ireq->reserved[] to hold bulkstat specific operational
>      flags. Introduce XFS_IBULK_NREXT64 flag to indicate that
>      userspace has the necessary infrastructure to receive 64-bit
>      extent counters.
>    - Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to
>      indicate that xfs_bulk_ireq->bulkstat_flags has valid flags set.
> 7. Rename the incompat flag from XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT
>    to XFS_SB_FEAT_INCOMPAT_NREXT64.
> 8. Add a new helper function xfs_inode_to_disk_iext_counters() to
>    convert from incore inode extent counters to ondisk inode extent
>    counters.
> 9. Reuse XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag to skip reporting
>    inodes with more than 10 extents when bulkstat ioctl is invoked by
>    userspace.
> 10. Introduce the new per-inode XFS_DIFLAG2_NREXT64 flag to indicate
>     that the inode uses 64-bit extent counter. This is used to allow
>     administrators to upgrade existing filesystems.
> 11. Export presence of XFS_SB_FEAT_INCOMPAT_NREXT64 feature to
>     userspace via XFS_IOC_FSGEOMETRY ioctl.
> 
> V1 -> V2:
> 1. Rebase patches on top of Darrick's btree-dynamic-depth branch.
> 2. Add new bulkstat ioctl version to support 64-bit data fork extent
>    counter field.
> 3. Introduce new error tag to verify if the old bulkstat ioctls skip
>    reporting inodes with large data fork extent counters.
> 
> Chandan Babu R (12):
>   xfs: Move extent count limits to xfs_format.h
>   xfs: Introduce xfs_iext_max_nextents() helper
>   xfs: Rename MAXEXTNUM, MAXAEXTNUM to XFS_IFORK_EXTCNT_MAXS32,
>     XFS_IFORK_EXTCNT_MAXS16
>   xfs: Use xfs_extnum_t instead of basic data types
>   xfs: Introduce xfs_dfork_nextents() helper
>   xfs: xfs_dfork_nextents: Return extent count via an out argument
>   xfs: Rename inode's extent counter fields based on their width
>   xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits
>     respectively
>   xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
>   xfs: Extend per-inode extent counter widths
>   xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to XFS_SB_FEAT_INCOMPAT_ALL
>   xfs: Define max extent length based on on-disk format definition
> 
>  fs/xfs/libxfs/xfs_bmap.c        | 80 ++++++++++++++-------------
>  fs/xfs/libxfs/xfs_format.h      | 80 +++++++++++++++++++++++----
>  fs/xfs/libxfs/xfs_fs.h          | 20 +++++--
>  fs/xfs/libxfs/xfs_ialloc.c      |  2 +
>  fs/xfs/libxfs/xfs_inode_buf.c   | 61 ++++++++++++++++-----
>  fs/xfs/libxfs/xfs_inode_fork.c  | 32 +++++++----
>  fs/xfs/libxfs/xfs_inode_fork.h  | 23 +++++++-
>  fs/xfs/libxfs/xfs_log_format.h  |  7 +--
>  fs/xfs/libxfs/xfs_rtbitmap.c    |  4 +-
>  fs/xfs/libxfs/xfs_sb.c          |  4 ++
>  fs/xfs/libxfs/xfs_swapext.c     |  6 +--
>  fs/xfs/libxfs/xfs_trans_inode.c |  6 +++
>  fs/xfs/libxfs/xfs_trans_resv.c  | 10 ++--
>  fs/xfs/libxfs/xfs_types.h       | 11 +---
>  fs/xfs/scrub/attr_repair.c      |  2 +-
>  fs/xfs/scrub/bmap.c             |  2 +-
>  fs/xfs/scrub/bmap_repair.c      |  2 +-
>  fs/xfs/scrub/inode.c            | 96 ++++++++++++++++++++-------------
>  fs/xfs/scrub/inode_repair.c     | 71 +++++++++++++++++-------
>  fs/xfs/scrub/repair.c           |  2 +-
>  fs/xfs/scrub/trace.h            | 16 +++---
>  fs/xfs/xfs_bmap_util.c          | 14 ++---
>  fs/xfs/xfs_inode.c              |  4 +-
>  fs/xfs/xfs_inode.h              |  5 ++
>  fs/xfs/xfs_inode_item.c         | 21 +++++++-
>  fs/xfs/xfs_inode_item_recover.c | 26 ++++++---
>  fs/xfs/xfs_ioctl.c              |  7 +++
>  fs/xfs/xfs_iomap.c              | 28 +++++-----
>  fs/xfs/xfs_itable.c             | 25 ++++++++-
>  fs/xfs/xfs_itable.h             |  2 +
>  fs/xfs/xfs_iwalk.h              |  7 ++-
>  fs/xfs/xfs_mount.h              |  2 +
>  fs/xfs/xfs_trace.h              |  6 +--
>  33 files changed, 478 insertions(+), 206 deletions(-)
> 
> -- 
> 2.30.2
> 
