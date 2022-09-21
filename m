Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28296C6FA8E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Sep 2022 00:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiIUAiV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 20:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiIUAiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 20:38:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66723211
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 17:38:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E7EFB81178
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 00:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CEEC433B5;
        Wed, 21 Sep 2022 00:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663720688;
        bh=waD+v5PUpmztJpngkmASY9Wce4K82TLv9zfPdaCF7Ow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pO2PgDZfNiBGR6t9mAM299FkDtGvqPDPA2M/fTtMClQiXVoxr2AO1VNEQ1PFYRV3f
         p1vz0/GgWorhEPOgioODcN05grtn/UJ6xHiLjCZZ3tzLdOyg/0tKjSoU+vc86c/45z
         8Ei4kbGGLtwrz1zJkOMTYPd3SliQQpHQ6gNppek84vIPYdVds31Pk80tf73xe6Q+tV
         r8Lkd42JWDuPXuUaWIDOvq0pVd2CJJI2xg3bDeHNLqjnIhx9F+x+HGTB+J80fR/poF
         ibAlrLwr/mSPFEcriyh8uH5KPBkY0STXpFPm0287rB5LEmZoSbn9JCe2fEYnWM4UUq
         fVU1VxAvln+rg==
Date:   Tue, 20 Sep 2022 17:38:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE V2 00/17] xfs stable candidate patches for
 5.4.y (from v5.5)
Message-ID: <Yypc8E7m0aySJW3f@magnolia>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 20, 2022 at 06:18:19PM +0530, Chandan Babu R wrote:
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
> 
> Changelog:
> V1 -> V2:
>   1. Drop "xfs: include QUOTA, FATAL ASSERT build options in
>      XFS_BUILD_OPTIONS" commit since it does not fix a real bug.

For patches 4, 5, and 14:
Acked-by: Darrick J. Wong <djwong@kernel.org>

Since I suppose we /do/ want LTS maintainers to be able to run fstests
without so much ASSERT noise. :)

--D

> 
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
>  fs/xfs/xfs_trace.h             |  21 +++++
>  include/linux/iomap.h          |   2 +
>  41 files changed, 523 insertions(+), 150 deletions(-)
> 
> -- 
> 2.35.1
> 
