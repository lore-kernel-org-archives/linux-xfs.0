Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C92C77B71
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 15:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbjDUPfX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 11:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbjDUPfW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 11:35:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBB17DA3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 08:35:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D95446188A
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 15:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44921C433D2;
        Fri, 21 Apr 2023 15:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682091317;
        bh=JrdtzbUnhsxx2/nvCIAED443EvNI0LUXSxQaqOTYW/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f1BuDfVjBDccoYCQzdhbT2ZuVYo6Tu8gIVy4dJrQ6RgJvbRsoWb8g5TaMnY21+mVA
         VLLi40dbkeGX+3C3+zhTRW7sQcoh+b60upGitZrch9nSHSKPtU1M42AGUy9Ho00y7E
         136dIRNoU4L32zJ5V27o78V/DnEOnMhHXiB5wXe7JfPwOaPOudWY9GNY82jo+3WRBq
         O6Ivj8M+4on+MJsDkXaYh8JrRpVEqqDS+esR7nJL65M2JcTNXUNXzCYg8X75OatJZk
         SzM+HPA9jzlt04NDfOTmMfxUbkkU1tkHVSLVHCa0/cU4OXfak9H+THhu57N+SZsGt2
         qwUJ2xgkdjiaw==
Date:   Fri, 21 Apr 2023 08:35:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE] xfs: fix forkoff miscalculation related to
 XFS_LITINO(mp)
Message-ID: <20230421153516.GJ360889@frogsfrogsfrogs>
References: <20230421030619.62047-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421030619.62047-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2023 at 08:36:19AM +0530, Chandan Babu R wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> commit ada49d64fb3538144192181db05de17e2ffc3551 upstream.
> 
> Currently, commit e9e2eae89ddb dropped a (int) decoration from
> XFS_LITINO(mp), and since sizeof() expression is also involved,
> the result of XFS_LITINO(mp) is simply as the size_t type
> (commonly unsigned long).
> 
> Considering the expression in xfs_attr_shortform_bytesfit():
>   offset = (XFS_LITINO(mp) - bytes) >> 3;
> let "bytes" be (int)340, and
>     "XFS_LITINO(mp)" be (unsigned long)336.
> 
> on 64-bit platform, the expression is
>   offset = ((unsigned long)336 - (int)340) >> 3 =
>            (int)(0xfffffffffffffffcUL >> 3) = -1
> 
> but on 32-bit platform, the expression is
>   offset = ((unsigned long)336 - (int)340) >> 3 =
>            (int)(0xfffffffcUL >> 3) = 0x1fffffff
> instead.
> 
> so offset becomes a large positive number on 32-bit platform, and
> cause xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0.
> 
> Therefore, one result is
>   "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"
> 
> assertion failure in xfs_idata_realloc(), which was also the root
> cause of the original bugreport from Dennis, see:
>    https://bugzilla.redhat.com/show_bug.cgi?id=1894177
> 
> And it can also be manually triggered with the following commands:
>   $ touch a;
>   $ setfattr -n user.0 -v "`seq 0 80`" a;
>   $ setfattr -n user.1 -v "`seq 0 80`" a
> 
> on 32-bit platform.
> 
> Fix the case in xfs_attr_shortform_bytesfit() by bailing out
> "XFS_LITINO(mp) < bytes" in advance suggested by Eric and a misleading
> comment together with this bugfix suggested by Darrick. It seems the
> other users of XFS_LITINO(mp) are not impacted.
> 
> Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
> Cc: <stable@vger.kernel.org> # 5.7+
> Reported-and-tested-by: Dennis Gilmore <dgilmore@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks good to me,
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> Hi Darrick,
> 
> I had missed this commit when backporting fixes from 5.11 and 5.12. I
> have executed 10 iterations of fstests via kdevops and did not notice
> any new regressions.
> 
> Please ack this patch.
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index f5b16120c64d..2b74b6e9a354 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -435,7 +435,7 @@ xfs_attr_copy_value(
>   *========================================================================*/
>  
>  /*
> - * Query whether the requested number of additional bytes of extended
> + * Query whether the total requested number of attr fork bytes of extended
>   * attribute space will be able to fit inline.
>   *
>   * Returns zero if not, else the di_forkoff fork offset to be used in the
> @@ -455,6 +455,12 @@ xfs_attr_shortform_bytesfit(
>  	int			maxforkoff;
>  	int			offset;
>  
> +	/*
> +	 * Check if the new size could fit at all first:
> +	 */
> +	if (bytes > XFS_LITINO(mp))
> +		return 0;
> +
>  	/* rounded down */
>  	offset = (XFS_LITINO(mp) - bytes) >> 3;
>  
> -- 
> 2.39.1
> 
