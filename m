Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A3BC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76AD460527
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhG1V1C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:27:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231564AbhG1V1C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:27:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B0E060238;
        Wed, 28 Jul 2021 21:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627507620;
        bh=wTL9qv/i7A0H4mut5/+b5z3I+n2uNq1/RErbLYx8Wwg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YH5TcfQis0sfP/bAKBJAv0EnSLDt48LsLf8OhqvCGEWXYXcyAx2ouHAu649ejtNHU
         XdaFRiBlP5y3G0eeIexQm4cxB9hZ8aTpSsVz9ozeW1gxZwDgpb/Q7IgITH2cw/t5ft
         ABc3ygeFduuecVkaHisZfPo4N8h3gOjHZ40rYxRXvmL+e4UX/NMuHiYWmbnc7f/jMc
         uZWOamb8l1rbsZQSuDQXAsyVPe62FGnep4/BToRkTeCJx8FZIT2aNtOO8CpXrJQm/v
         FQi7oRvL6RCkAZ45gSQ7JlvbfGEvy675RADDNZAAAIBRZiWkn4VWqkV09E/Vb0tF6I
         WuwnibrkqDsLg==
Date:   Wed, 28 Jul 2021 14:27:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 00/12] xfs: Extend per-inode extent counters
Message-ID: <20210728212700.GJ3601443@magnolia>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726114541.24898-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 05:15:29PM +0530, Chandan Babu R wrote:
> The commit xfs: fix inode fork extent count overflow
> (3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
> data fork extents should be possible to create. However the
> corresponding on-disk field has a signed 32-bit type. Hence this
> patchset extends the per-inode data extent counter to 64 bits out of
> which 48 bits are used to store the extent count. 

A few other random notes that don't fit anywhere:

If you decide to enable upgrades by adding an XFS_DIFLAG2 to indicate
that a particular file has large extent counts, I think you can copy the
same mechanisms that the DIFLAG2_BIGTIME flag uses as a template.  I
think you'd need an extra bit of logic in xfs_trans_log_inode to turn on
the feature bit and move the n*extents fields around if either extent
count exceeds the old limits.

Please export the NREXT64 feature flag via an XFS_FSOP_GEOM flag so that
userspace can detect support for having a lot of extents.  This will
make it easy for libfrog to figure out that it should set the "send
large extent counts" bulkstat flag.  It'll also make it easier to
perform feature detection in fstests.

--D

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
> 
> These patches can also be obtained from
> https://github.com/chandanr/linux.git at branch
> xfs-incompat-extend-extcnt-v2.
> 
> I will be posting the changes associated with xfsprogs separately.
> 
> Changelog:
> V1 -> V2:
> 1. Rebase patches on top of Darrick's btree-dynamic-depth branch.
> 2. Add new bulkstat ioctl version to support 64-bit data fork extent
>    counter field.
> 3. Introduce new error tag to verify if the old bulkstat ioctls skip
>    reporting inodes with large data fork extent counters.
> 
> Chandan Babu R (12):
>   xfs: Move extent count limits to xfs_format.h
>   xfs: Rename MAXEXTNUM, MAXAEXTNUM to XFS_IFORK_EXTCNT_MAXS32,
>     XFS_IFORK_EXTCNT_MAXS16
>   xfs: Introduce xfs_iext_max() helper
>   xfs: Use xfs_extnum_t instead of basic data types
>   xfs: Introduce xfs_dfork_nextents() helper
>   xfs: xfs_dfork_nextents: Return extent count via an out argument
>   xfs: Rename inode's extent counter fields based on their width
>   xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits
>     respectively
>   xfs: Rename XFS_IOC_BULKSTAT to XFS_IOC_BULKSTAT_V5
>   xfs: Enable bulkstat ioctl to support 64-bit extent counters
>   xfs: Extend per-inode extent counter widths
>   xfs: Error tag to test if v5 bulkstat skips inodes with large extent
>     count
> 
>  fs/xfs/libxfs/xfs_bmap.c        | 21 +++----
>  fs/xfs/libxfs/xfs_errortag.h    |  4 +-
>  fs/xfs/libxfs/xfs_format.h      | 42 +++++++++++---
>  fs/xfs/libxfs/xfs_fs.h          |  9 ++-
>  fs/xfs/libxfs/xfs_inode_buf.c   | 82 ++++++++++++++++++++++++----
>  fs/xfs/libxfs/xfs_inode_buf.h   |  2 +
>  fs/xfs/libxfs/xfs_inode_fork.c  | 35 +++++++++---
>  fs/xfs/libxfs/xfs_inode_fork.h  | 22 +++++++-
>  fs/xfs/libxfs/xfs_log_format.h  |  7 ++-
>  fs/xfs/libxfs/xfs_types.h       | 11 +---
>  fs/xfs/scrub/attr_repair.c      |  2 +-
>  fs/xfs/scrub/inode.c            | 97 ++++++++++++++++++++-------------
>  fs/xfs/scrub/inode_repair.c     | 71 +++++++++++++++++-------
>  fs/xfs/scrub/trace.h            | 16 +++---
>  fs/xfs/xfs_error.c              |  3 +
>  fs/xfs/xfs_inode.c              |  4 +-
>  fs/xfs/xfs_inode_item.c         | 15 ++++-
>  fs/xfs/xfs_inode_item_recover.c | 25 +++++++--
>  fs/xfs/xfs_ioctl.c              | 33 +++++++++--
>  fs/xfs/xfs_ioctl32.c            |  7 +++
>  fs/xfs/xfs_itable.c             | 35 ++++++++++--
>  fs/xfs/xfs_itable.h             |  1 +
>  fs/xfs/xfs_trace.h              |  6 +-
>  23 files changed, 402 insertions(+), 148 deletions(-)
> 
> -- 
> 2.30.2
> 
