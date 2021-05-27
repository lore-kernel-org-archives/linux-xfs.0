Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81FD2C4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 06:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DCA3613DA
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 06:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhE0GRb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 02:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhE0GRa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 02:17:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42539613DA;
        Thu, 27 May 2021 06:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622096158;
        bh=NmUFLBFhasp92q3NnvSA8qDKEy7uMP/xWBi+2IVW81g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GGr0XaCh0eGwdyq3BVES9ZgOhdmWpoSvzKzXYRDVLZiXGLL1fshuZXxkhtvaSVxkv
         eW+mZugYV4tZyYaL61wrNgxwq71SLhg1bg4zjZvbbznBUmxeZnZlNFKL1jv1fmx7Jf
         cF0GBF7FgMM5DQaDvahF8m8yqVQUUiT513eMHOaKvA7VQ0P9kxAdRpxMV1MuXPXWMe
         FHp47gspem78e1SjMzPmrPVSmuWao3WVcOu1RjJA0AMCS5S4XB+9XZpeUUVADVdQhl
         btq1FZqi0fbD+NUPbDjVKvDnaqqkpo5PvlGPHFyo98mm8+VosngBRsAM0rhu+sKWi1
         xclrfFiACpaLQ==
Date:   Wed, 26 May 2021 23:15:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: btree format inode forks can have zero extents
Message-ID: <20210527061557.GC202121@locust>
References: <20210527045202.1155628-1-david@fromorbit.com>
 <20210527045202.1155628-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527045202.1155628-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 02:51:57PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs/538 is assert failing with this trace when testing with
> directory block sizes of 64kB:
> 
> XFS: Assertion failed: !xfs_need_iread_extents(ifp), file: fs/xfs/libxfs/xfs_bmap.c, line: 608
> ....
> Call Trace:
>  xfs_bmap_btree_to_extents+0x2a9/0x470
>  ? kmem_cache_alloc+0xe7/0x220
>  __xfs_bunmapi+0x4ca/0xdf0
>  xfs_bunmapi+0x1a/0x30
>  xfs_dir2_shrink_inode+0x71/0x210
>  xfs_dir2_block_to_sf+0x2ae/0x410
>  xfs_dir2_block_removename+0x21a/0x280
>  xfs_dir_removename+0x195/0x1d0
>  xfs_remove+0x244/0x460
>  xfs_vn_unlink+0x53/0xa0
>  ? selinux_inode_unlink+0x13/0x20
>  vfs_unlink+0x117/0x220
>  do_unlinkat+0x1a2/0x2d0
>  __x64_sys_unlink+0x42/0x60
>  do_syscall_64+0x3a/0x70
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> This is a check to ensure that the extents have been read into
> memory before we are doing a ifork btree manipulation. This assert
> is bogus in the above case.
> 
> We have a fragmented directory block that has more extents in it
> than can fit in extent format, so the inode data fork is in btree
> format. xfs_dir2_shrink_inode() asks to remove all remaining 16
> filesystem blocks from the inode so it can convert to short form,
> and __xfs_bunmapi() removes all the extents. We now have a data fork
> in btree format but have zero extents in the fork. This incorrectly
> trips the xfs_need_iread_extents() assert because it assumes that an
> empty extent btree means the extent tree has not been read into
> memory yet. This is clearly not the case with xfs_bunmapi(), as it
> has an explicit call to xfs_iread_extents() in it to pull the
> extents into memory before it starts unmapping.
> 
> Also, the assert directly after this bogus one is:
> 
> 	ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
> 
> Which covers the context in which it is legal to call
> xfs_bmap_btree_to_extents just fine. Hence we should just remove the
> bogus assert as it is clearly wrong and causes a regression.
> 
> The returns the test behaviour to the pre-existing assert failure in
> xfs_dir2_shrink_inode() that indicates xfs_bunmapi() has failed to
> remove all the extents in the range it was asked to unmap.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Makes sense to me.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7e3b9b01431e..3f8b6da09261 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -605,7 +605,6 @@ xfs_bmap_btree_to_extents(
>  
>  	ASSERT(cur);
>  	ASSERT(whichfork != XFS_COW_FORK);
> -	ASSERT(!xfs_need_iread_extents(ifp));
>  	ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
>  	ASSERT(be16_to_cpu(rblock->bb_level) == 1);
>  	ASSERT(be16_to_cpu(rblock->bb_numrecs) == 1);
> -- 
> 2.31.1
> 
