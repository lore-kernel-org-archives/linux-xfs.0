Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3027C6FA82
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Sep 2022 18:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiINSwb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Sep 2022 14:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiINSwa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2022 14:52:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27F64E847
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 11:52:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7922461CE6
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 18:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C1FC433D6;
        Wed, 14 Sep 2022 18:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663181548;
        bh=D1fU3zpd27dcW3LD+zb/6Hyi2eDIW2qmLfGX0UwlQf4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gh9uyqjMcKlf8hmsqE6GTbCMz4gFQZNB0SrxByFT5YF5+XOf/j/N1G6eiaFzJ+NoP
         Tk5f+1d4nj+Fw69WcWYdRbHBV2n3AYsJ/EMEkObzDfFNNj2RrlzZAxYS18CVh9ZdVJ
         rgcC8R6FBpJgmHvJWZv4u/aFTtyzJq3jidd2bUHBrE2AGM4ANDxx7CHpjjj288u5vn
         R5XaSL6NHWHglfDXu3hoIyZew54DN5MiLqgrvcAe7Df67B7HWAHCSmo1DqG1CONWfD
         k1m84ffe/zTDKSDF8JCBBbhahJh7sqr7QSIAmXU7DBhWzjEfyTxpXSG69jev/n/+HX
         +ToFh5zlClWiw==
Date:   Wed, 14 Sep 2022 11:52:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE 00/18] xfs stable candidate patches for
 5.4.y (from v5.5)
Message-ID: <YyIi7NvA1xHylhoS@magnolia>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 12, 2022 at 06:57:24PM +0530, Chandan Babu R wrote:
> Hi Darrick,
> 
> This 5.4.y backport series contains fixes from v5.5 release.
> 
> This patchset has been tested by executing fstests (via kdevops) using
> the following XFS configurations,
> 
> 1. No CRC (with 512 and 4k block size).
> 2. Reflink/Rmapbt (1k and 4k block size).
> 3. Reflink without Rmapbt.
> 4. External log device.
> 
> The following lists patches which required other dependency patches to
> be included,
> 
> 1. 050552cbe06a3a9c3f977dcf11ff998ae1d5c2d5
>    xfs: fix some memory leaks in log recovery
>    - 895e196fb6f84402dcd0c1d3c3feb8a58049564e
>      xfs: convert EIO to EFSCORRUPTED when log contents are invalid
>    - 895e196fb6f84402dcd0c1d3c3feb8a58049564e
>      xfs: constify the buffer pointer arguments to error functions
>    - a5155b870d687de1a5f07e774b49b1e8ef0f6f50
>      xfs: always log corruption errors
> 2. 13eaec4b2adf2657b8167b67e27c97cc7314d923
>    xfs: don't commit sunit/swidth updates to disk if that would cause
>    repair failures
>    - 1cac233cfe71f21e069705a4930c18e48d897be6
>      xfs: refactor agfl length computation function
>    - 4f5b1b3a8fa07dc8ecedfaf539b3deed8931a73e
>      xfs: split the sunit parameter update into two parts

For patches 1-2, 4, 7-14, 16-18,
Acked-by: Darrick J. Wong <djwong@kernel.org>

I don't know why patches 3, 5-6, or 15 are necessary -- I don't think
they're fixing any user-visible issues; is that so that you can run QA
with CONFIG_XFS_DEBUG=y and avoid false failures due to bad asserts?

--D

> Brian Foster (2):
>   xfs: stabilize insert range start boundary to avoid COW writeback race
>   xfs: use bitops interface for buf log item AIL flag check
> 
> Chandan Babu R (1):
>   MAINTAINERS: add Chandan as xfs maintainer for 5.4.y
> 
> Christoph Hellwig (1):
>   xfs: slightly tweak an assert in xfs_fs_map_blocks
> 
> Darrick J. Wong (11):
>   xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata
>   xfs: add missing assert in xfs_fsmap_owner_from_rmap
>   xfs: range check ri_cnt when recovering log items
>   xfs: attach dquots and reserve quota blocks during unwritten
>     conversion
>   xfs: convert EIO to EFSCORRUPTED when log contents are invalid
>   xfs: constify the buffer pointer arguments to error functions
>   xfs: always log corruption errors
>   xfs: fix some memory leaks in log recovery
>   xfs: refactor agfl length computation function
>   xfs: split the sunit parameter update into two parts
>   xfs: don't commit sunit/swidth updates to disk if that would cause
>     repair failures
> 
> Dave Chinner (1):
>   iomap: iomap that extends beyond EOF should be marked dirty
> 
> kaixuxia (1):
>   xfs: Fix deadlock between AGI and AGF when target_ip exists in
>     xfs_rename()
> 
> yu kuai (1):
>   xfs: include QUOTA, FATAL ASSERT build options in XFS_BUILD_OPTIONS
> 
>  MAINTAINERS                    |   3 +-
>  fs/xfs/libxfs/xfs_alloc.c      |  27 ++++--
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  12 ++-
>  fs/xfs/libxfs/xfs_bmap.c       |  16 +++-
>  fs/xfs/libxfs/xfs_btree.c      |   5 +-
>  fs/xfs/libxfs/xfs_da_btree.c   |  24 +++--
>  fs/xfs/libxfs/xfs_dir2.c       |   4 +-
>  fs/xfs/libxfs/xfs_dir2.h       |   2 +
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |   4 +-
>  fs/xfs/libxfs/xfs_dir2_node.c  |  12 ++-
>  fs/xfs/libxfs/xfs_dir2_sf.c    |  28 +++++-
>  fs/xfs/libxfs/xfs_ialloc.c     |  64 +++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.h     |   1 +
>  fs/xfs/libxfs/xfs_inode_fork.c |   6 ++
>  fs/xfs/libxfs/xfs_refcount.c   |   4 +-
>  fs/xfs/libxfs/xfs_rtbitmap.c   |   6 +-
>  fs/xfs/xfs_acl.c               |  15 ++-
>  fs/xfs/xfs_attr_inactive.c     |  10 +-
>  fs/xfs/xfs_attr_list.c         |   5 +-
>  fs/xfs/xfs_bmap_item.c         |   7 +-
>  fs/xfs/xfs_bmap_util.c         |  12 +++
>  fs/xfs/xfs_buf_item.c          |   2 +-
>  fs/xfs/xfs_dquot.c             |   2 +-
>  fs/xfs/xfs_error.c             |  27 +++++-
>  fs/xfs/xfs_error.h             |   7 +-
>  fs/xfs/xfs_extfree_item.c      |   5 +-
>  fs/xfs/xfs_fsmap.c             |   1 +
>  fs/xfs/xfs_inode.c             |  32 ++++++-
>  fs/xfs/xfs_inode_item.c        |   5 +-
>  fs/xfs/xfs_iomap.c             |  17 ++++
>  fs/xfs/xfs_iops.c              |  10 +-
>  fs/xfs/xfs_log_recover.c       |  72 +++++++++-----
>  fs/xfs/xfs_message.c           |   2 +-
>  fs/xfs/xfs_message.h           |   2 +-
>  fs/xfs/xfs_mount.c             | 168 +++++++++++++++++++++++----------
>  fs/xfs/xfs_pnfs.c              |   4 +-
>  fs/xfs/xfs_qm.c                |  13 ++-
>  fs/xfs/xfs_refcount_item.c     |   5 +-
>  fs/xfs/xfs_rmap_item.c         |   9 +-
>  fs/xfs/xfs_super.h             |  10 ++
>  fs/xfs/xfs_trace.h             |  21 +++++
>  include/linux/iomap.h          |   2 +
>  42 files changed, 533 insertions(+), 150 deletions(-)
> 
> -- 
> 2.35.1
> 
