Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC18C433E5
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 18:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D36A561A3A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 18:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhCYSzH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 14:55:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhCYSyt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 14:54:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF89261A1E;
        Thu, 25 Mar 2021 18:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616698488;
        bh=tM8eINKnHRITG9wCAfjpIsUWMm+grOjYY8RVmsE3iZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gy4K7VpSx3Q5yIe3gceuOWLGRh46PyAaqHbk2Zb6AuGda8FG9asw5JSI00+r423vS
         iu1n/giq3Qiq9U/Jz1Sq64I4zjBGBOmHxzE5f0O2f4nfQnfBGkg/ksSle0TSMuZDuH
         kdy7He55ANIXvhoORSiGy7KzB0Mz6ZmBvhcrGfpULC4HQ7oIpqU0x4Vt4Y83oKphCx
         GlSzeT79RbpY4xfHtNcO4lt9aWq/fe+CUQCgIsWfmtnder6jnus0fj3tkM7dxAYD9a
         fDs7vaykEly+G5KKbfARaxkAzf1K6Dw2lZkC5d3CokW/mdY5V3LfEluuLZcKrcxmU4
         ll9LWguuakzOQ==
Date:   Thu, 25 Mar 2021 11:54:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: Initialize xfs_alloc_arg->total correctly when
 allocating minlen extents
Message-ID: <20210325185447.GM4090233@magnolia>
References: <20210325140339.6603-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325140339.6603-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 07:33:38PM +0530, Chandan Babu R wrote:
> xfs/538 can cause the following call trace to be printed when executing on a
> multi-block directory configuration,
> 
>  WARNING: CPU: 1 PID: 2578 at fs/xfs/libxfs/xfs_bmap.c:717 xfs_bmap_extents_to_btree+0x520/0x5d0
>  Call Trace:
>   ? xfs_buf_rele+0x4f/0x450
>   xfs_bmap_add_extent_hole_real+0x747/0x960
>   xfs_bmapi_allocate+0x39a/0x440
>   xfs_bmapi_write+0x507/0x9e0
>   xfs_da_grow_inode_int+0x1cd/0x330
>   ? up+0x12/0x60
>   xfs_dir2_grow_inode+0x62/0x110
>   ? xfs_trans_log_inode+0x234/0x2d0
>   xfs_dir2_sf_to_block+0x103/0x940
>   ? xfs_dir2_sf_check+0x8c/0x210
>   ? xfs_da_compname+0x19/0x30
>   ? xfs_dir2_sf_lookup+0xd0/0x3d0
>   xfs_dir2_sf_addname+0x10d/0x910
>   xfs_dir_createname+0x1ad/0x210
>   xfs_create+0x404/0x620
>   xfs_generic_create+0x24c/0x320
>   path_openat+0xda6/0x1030
>   do_filp_open+0x88/0x130
>   ? kmem_cache_alloc+0x50/0x210
>   ? __cond_resched+0x16/0x40
>   ? kmem_cache_alloc+0x50/0x210
>   do_sys_openat2+0x97/0x150
>   __x64_sys_creat+0x49/0x70
>   do_syscall_64+0x33/0x40
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> This occurs because xfs_bmap_exact_minlen_extent_alloc() initializes
> xfs_alloc_arg->total to xfs_bmalloca->minlen. In the context of
> xfs_bmap_exact_minlen_extent_alloc(), xfs_bmalloca->minlen has a value of 1
> and hence the space allocator could choose an AG which has less than
> xfs_bmalloca->total number of free blocks available. As the transaction
> proceeds, one of the future space allocation requests could fail due to
> non-availability of free blocks in the AG that was originally chosen.
> 
> This commit fixes the bug by assigning xfs_alloc_arg->total to the value of
> xfs_bmalloca->total.
> 
> Fixes: 301519674699 ("xfs: Introduce error injection to allocate only minlen size extents for files")
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Sounds resonable to me, I guess I'll give it a try...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index e0905ad171f0..585f7e795023 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3586,7 +3586,8 @@ xfs_bmap_exact_minlen_extent_alloc(
>  	args.fsbno = ap->blkno;
>  	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
>  	args.type = XFS_ALLOCTYPE_FIRST_AG;
> -	args.total = args.minlen = args.maxlen = ap->minlen;
> +	args.minlen = args.maxlen = ap->minlen;
> +	args.total = ap->total;
>  
>  	args.alignment = 1;
>  	args.minalignslop = 0;
> -- 
> 2.29.2
> 
