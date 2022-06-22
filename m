Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0959CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 16:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359434AbiFVQcN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 12:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237555AbiFVQcM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 12:32:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DC93150E;
        Wed, 22 Jun 2022 09:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D239461AA0;
        Wed, 22 Jun 2022 16:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372D0C34114;
        Wed, 22 Jun 2022 16:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655915530;
        bh=oZ/HMwEEpMmlxsE2fXgdNXqxu7e4J0wswI5GmTqQnI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XKpEegHqdgwIxpcMmHEvWml4KlhLr/+RSQARZDOeTI1GkrTWYNQlsYxV+aTPQCG1M
         wviDrGXyfCLFNuYpYf8BHiXuIyvdbSJqGyqu6SKQGwbx5BNL6noorAzfufT2EdkSkk
         Rfx6tx0MRKPPLp7uohze9F4JPYm0+OHphfD0K0mcBxOBUoNzLVB9BwUmPxNB/CX7VE
         eHHYTMISEywEAXU4es6NWQa6AjlPvIZ3Knn2rJdt9x5AdI7aUm0fKCNcOQkH3mun62
         tUjUXrI+jteEGBAH4Th7wvlPJdJ2rHhacDKJ7JZVsuRFPRsMFh+RZSWxPcbUVAKniR
         RfQ7hRloBP4/g==
Date:   Wed, 22 Jun 2022 09:32:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Subject: Re: [PATCH 5.10 CANDIDATE 03/11] xfs: Fix the free logic of state in
 xfs_attr_node_hasname
Message-ID: <YrNECU28ujN2cabX@magnolia>
References: <20220617100641.1653164-1-amir73il@gmail.com>
 <20220617100641.1653164-4-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617100641.1653164-4-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 17, 2022 at 01:06:33PM +0300, Amir Goldstein wrote:
> From: Yang Xu <xuyang2018.jy@fujitsu.com>
> 
> commit a1de97fe296c52eafc6590a3506f4bbd44ecb19a upstream.
> 
> When testing xfstests xfs/126 on lastest upstream kernel, it will hang on some machine.
> Adding a getxattr operation after xattr corrupted, I can reproduce it 100%.
> 
> The deadlock as below:
> [983.923403] task:setfattr        state:D stack:    0 pid:17639 ppid: 14687 flags:0x00000080
> [  983.923405] Call Trace:
> [  983.923410]  __schedule+0x2c4/0x700
> [  983.923412]  schedule+0x37/0xa0
> [  983.923414]  schedule_timeout+0x274/0x300
> [  983.923416]  __down+0x9b/0xf0
> [  983.923451]  ? xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
> [  983.923453]  down+0x3b/0x50
> [  983.923471]  xfs_buf_lock+0x33/0xf0 [xfs]
> [  983.923490]  xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
> [  983.923508]  xfs_buf_get_map+0x4c/0x320 [xfs]
> [  983.923525]  xfs_buf_read_map+0x53/0x310 [xfs]
> [  983.923541]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
> [  983.923560]  xfs_trans_read_buf_map+0x1cf/0x360 [xfs]
> [  983.923575]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
> [  983.923590]  xfs_da_read_buf+0xcf/0x120 [xfs]
> [  983.923606]  xfs_da3_node_read+0x1f/0x40 [xfs]
> [  983.923621]  xfs_da3_node_lookup_int+0x69/0x4a0 [xfs]
> [  983.923624]  ? kmem_cache_alloc+0x12e/0x270
> [  983.923637]  xfs_attr_node_hasname+0x6e/0xa0 [xfs]
> [  983.923651]  xfs_has_attr+0x6e/0xd0 [xfs]
> [  983.923664]  xfs_attr_set+0x273/0x320 [xfs]
> [  983.923683]  xfs_xattr_set+0x87/0xd0 [xfs]
> [  983.923686]  __vfs_removexattr+0x4d/0x60
> [  983.923688]  __vfs_removexattr_locked+0xac/0x130
> [  983.923689]  vfs_removexattr+0x4e/0xf0
> [  983.923690]  removexattr+0x4d/0x80
> [  983.923693]  ? __check_object_size+0xa8/0x16b
> [  983.923695]  ? strncpy_from_user+0x47/0x1a0
> [  983.923696]  ? getname_flags+0x6a/0x1e0
> [  983.923697]  ? _cond_resched+0x15/0x30
> [  983.923699]  ? __sb_start_write+0x1e/0x70
> [  983.923700]  ? mnt_want_write+0x28/0x50
> [  983.923701]  path_removexattr+0x9b/0xb0
> [  983.923702]  __x64_sys_removexattr+0x17/0x20
> [  983.923704]  do_syscall_64+0x5b/0x1a0
> [  983.923705]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> [  983.923707] RIP: 0033:0x7f080f10ee1b
> 
> When getxattr calls xfs_attr_node_get function, xfs_da3_node_lookup_int fails with EFSCORRUPTED in
> xfs_attr_node_hasname because we have use blocktrash to random it in xfs/126. So it
> free state in internal and xfs_attr_node_get doesn't do xfs_buf_trans release job.
> 
> Then subsequent removexattr will hang because of it.
> 
> This bug was introduced by kernel commit 07120f1abdff ("xfs: Add xfs_has_attr and subroutines").
> It adds xfs_attr_node_hasname helper and said caller will be responsible for freeing the state
> in this case. But xfs_attr_node_hasname will free state itself instead of caller if
> xfs_da3_node_lookup_int fails.
> 
> Fix this bug by moving the step of free state into caller.
> 
> [amir: this text from original commit is not relevant for 5.10 backport:
> Also, use "goto error/out" instead of returning error directly in xfs_attr_node_addname_find_attr and
> xfs_attr_node_removename_setup function because we should free state ourselves.
> ]
> 
> Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
> Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 96ac7e562b87..fcca36bbd997 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -876,21 +876,18 @@ xfs_attr_node_hasname(
>  
>  	state = xfs_da_state_alloc(args);
>  	if (statep != NULL)
> -		*statep = NULL;
> +		*statep = state;
>  
>  	/*
>  	 * Search to see if name exists, and get back a pointer to it.
>  	 */
>  	error = xfs_da3_node_lookup_int(state, &retval);
> -	if (error) {
> -		xfs_da_state_free(state);
> -		return error;
> -	}
> +	if (error)
> +		retval = error;
>  
> -	if (statep != NULL)
> -		*statep = state;
> -	else
> +	if (!statep)
>  		xfs_da_state_free(state);
> +
>  	return retval;
>  }
>  
> -- 

Curious -- the conversion of the _node_hasname callers isn't in this
patch.  Looking at 5.10.124, I see that most of the callers already
clean up the passed-out statep, but do the callers of xfs_has_attr free
it too?

--D

> 2.25.1
> 
