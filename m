Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9EFC77B6F
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 18:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjDKSQk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 14:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjDKSQX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 14:16:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812416EAD
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 11:15:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ECC860EA5
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 18:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DE1C433D2;
        Tue, 11 Apr 2023 18:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681236954;
        bh=JwYT7tNqOO2k+5wfNv8vu1liaPLDNr95YVqUqM2ZQdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HVyJTn3UZ3lqaP77EGBjqV5Oisp3sdqEFFtvuQDyn3q7ToN3CQuAC4rAG37ZD3LCd
         wW+PQZtqSRP1ch/kATK10wLM8f4asN7JIbCD7NJbuXh8lEmSs8R1NNauJEjD/1lwsv
         UUXDnNDHMi399j96sTr9bX62pfZFaOUjsakhudVW51h4H2gDdYV/9lYAKd4OzB8Knw
         tKxE4g1NFsaYqU4PxkaPF43FeTjbFjcumQG9kWR1bYmT0OKpzLsU2+ms+9kwaRPLO9
         J7marUrMD/lc9anAeXpz+8+FNISqnM2LXiWIq9/EMiz4SYSguF4OGT3JkizgG3HKk7
         JYXn5XWVZs8Kg==
Date:   Tue, 11 Apr 2023 11:15:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE 00/17] xfs stable candidate patches for
 5.4.y (from v5.11 & v5.12)
Message-ID: <20230411181554.GJ360889@frogsfrogsfrogs>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 09:04:57AM +0530, Chandan Babu R wrote:
> Hi Darrick,
> 
> This 5.4.y backport series contains fixes from v5.11 & v5.12 release.
> 
> This patchset has been tested by executing fstests (via kdevops) using
> the following XFS configurations,
> 
> 1. No CRC (with 512 and 4k block size).
> 2. Reflink/Rmapbt (1k and 4k block size).
> 3. Reflink without Rmapbt.
> 4. External log device.
> 
> The following is the list of commits along with corresponding
> dependent commits.
> 
> 1. xfs: fix up non-directory creation in SGID directories
>    1. xfs: show the proper user quota options
>    2. xfs: merge the projid fields in struct xfs_icdinode
>    3. xfs: ensure that the inode uid/gid match values match the icdinode ones
>    4. xfs: remove the icdinode di_uid/di_gid members
>    5. xfs: remove the kuid/kgid conversion wrappers
>    6. xfs: add a new xfs_sb_version_has_v3inode helper
>    7. xfs: only check the superblock version for dinode size calculation
>    8. xfs: simplify di_flags2 inheritance in xfs_ialloc
>    9. xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
>    10. xfs: remove the di_version field from struct icdinode
> 2. xfs: set inode size after creating symlink
> 3. xfs: shut down the filesystem if we screw up quota reservation
>    1. xfs: report corruption only as a regular error
> 4. xfs: consider shutdown in bmapbt cursor delete assert
> 5. xfs: don't reuse busy extents on extent trim
> 6. xfs: force log and push AIL to clear pinned inodes when aborting mount
> 
> Brian Foster (2):
>   xfs: consider shutdown in bmapbt cursor delete assert
>   xfs: don't reuse busy extents on extent trim
> 
> Christoph Hellwig (10):
>   xfs: merge the projid fields in struct xfs_icdinode
>   xfs: ensure that the inode uid/gid match values match the icdinode
>     ones
>   xfs: remove the icdinode di_uid/di_gid members
>   xfs: remove the kuid/kgid conversion wrappers
>   xfs: add a new xfs_sb_version_has_v3inode helper
>   xfs: only check the superblock version for dinode size calculation
>   xfs: simplify di_flags2 inheritance in xfs_ialloc
>   xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
>   xfs: remove the di_version field from struct icdinode
>   xfs: fix up non-directory creation in SGID directories
> 
> Darrick J. Wong (3):
>   xfs: report corruption only as a regular error
>   xfs: shut down the filesystem if we screw up quota reservation
>   xfs: force log and push AIL to clear pinned inodes when aborting mount
> 
> Jeffrey Mitchell (1):
>   xfs: set inode size after creating symlink
> 
> Kaixu Xia (1):
>   xfs: show the proper user quota options

Looks good to me,
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  5 +-
>  fs/xfs/libxfs/xfs_bmap.c       | 10 ++--
>  fs/xfs/libxfs/xfs_btree.c      | 30 +++++-------
>  fs/xfs/libxfs/xfs_format.h     | 33 ++++++++++---
>  fs/xfs/libxfs/xfs_ialloc.c     |  6 +--
>  fs/xfs/libxfs/xfs_inode_buf.c  | 54 +++++++-------------
>  fs/xfs/libxfs/xfs_inode_buf.h  |  8 +--
>  fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.h |  9 +---
>  fs/xfs/libxfs/xfs_log_format.h | 10 ++--
>  fs/xfs/libxfs/xfs_trans_resv.c |  2 +-
>  fs/xfs/xfs_acl.c               | 12 +++--
>  fs/xfs/xfs_bmap_util.c         | 16 +++---
>  fs/xfs/xfs_buf_item.c          |  2 +-
>  fs/xfs/xfs_dquot.c             |  6 +--
>  fs/xfs/xfs_error.c             |  2 +-
>  fs/xfs/xfs_extent_busy.c       | 14 ------
>  fs/xfs/xfs_icache.c            |  8 ++-
>  fs/xfs/xfs_inode.c             | 61 ++++++++---------------
>  fs/xfs/xfs_inode.h             | 21 +-------
>  fs/xfs/xfs_inode_item.c        | 20 ++++----
>  fs/xfs/xfs_ioctl.c             | 22 ++++-----
>  fs/xfs/xfs_iops.c              | 11 +----
>  fs/xfs/xfs_itable.c            |  8 +--
>  fs/xfs/xfs_linux.h             | 32 +++---------
>  fs/xfs/xfs_log_recover.c       |  6 +--
>  fs/xfs/xfs_mount.c             | 90 +++++++++++++++++-----------------
>  fs/xfs/xfs_qm.c                | 43 +++++++++-------
>  fs/xfs/xfs_qm_bhv.c            |  2 +-
>  fs/xfs/xfs_quota.h             |  4 +-
>  fs/xfs/xfs_super.c             | 10 ++--
>  fs/xfs/xfs_symlink.c           |  7 ++-
>  fs/xfs/xfs_trans_dquot.c       | 16 ++++--
>  33 files changed, 248 insertions(+), 334 deletions(-)
> 
> -- 
> 2.39.1
> 
