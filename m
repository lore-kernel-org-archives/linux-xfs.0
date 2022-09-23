Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65092C07E9D
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 21:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiIWVXD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiIWVXD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 17:23:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB8D12261A
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 14:23:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31F53B819AC
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 21:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4A6C433D6;
        Fri, 23 Sep 2022 21:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663968179;
        bh=95HQyaZFTkLNoUJMgaYRspO2VuzG5MkeM/YSoz/gGtQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XYG1IG+IR0vppSRBpVpURzuvgKmYh+oy1sSuai87doHMLMwkbgeBI/s2nvDClBDQl
         2NLdQdJZ4adIbMUKCW0787mJLq2pgGWnMV9de+rZhvXHJkTFW+/SL48SllLfsb39Uf
         gwTnBsQDQpGn+K6a8aGjUwmtl3vxHCFdkypX+Yqx4oAnsUz9/B8nDGj4/k8g0zH46c
         mv1Id+4dJEPpBAwAb3bM5ydq3RqPhZHYOTpvt41F+sUcwuv3oTCxONNm5hRSlSXVYX
         gpG4ph9a3E+5AOlCchtVUZ2Ahr548uxI91lueRixALmiv1WoyiwEPCCBQLffG8btIV
         VYWwB2+Pzb6vw==
Date:   Fri, 23 Sep 2022 14:22:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 19/26] xfs: Indent xfs_rename
Message-ID: <Yy4js4SKxNyec41j@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-20-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922054458.40826-20-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 10:44:51PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Indent variables and parameters in xfs_rename in preparation for
> parent pointer modifications.  White space only, no functional
> changes.  This will make reviewing new code easier on reviewers.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Easy enough :)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c | 39 ++++++++++++++++++++-------------------
>  1 file changed, 20 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 51724af22bf9..4a8399d35b17 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2891,26 +2891,27 @@ xfs_rename_alloc_whiteout(
>   */
>  int
>  xfs_rename(
> -	struct user_namespace	*mnt_userns,
> -	struct xfs_inode	*src_dp,
> -	struct xfs_name		*src_name,
> -	struct xfs_inode	*src_ip,
> -	struct xfs_inode	*target_dp,
> -	struct xfs_name		*target_name,
> -	struct xfs_inode	*target_ip,
> -	unsigned int		flags)
> +	struct user_namespace		*mnt_userns,
> +	struct xfs_inode		*src_dp,
> +	struct xfs_name			*src_name,
> +	struct xfs_inode		*src_ip,
> +	struct xfs_inode		*target_dp,
> +	struct xfs_name			*target_name,
> +	struct xfs_inode		*target_ip,
> +	unsigned int			flags)
>  {
> -	struct xfs_mount	*mp = src_dp->i_mount;
> -	struct xfs_trans	*tp;
> -	struct xfs_inode	*wip = NULL;		/* whiteout inode */
> -	struct xfs_inode	*inodes[__XFS_SORT_INODES];
> -	int			i;
> -	int			num_inodes = __XFS_SORT_INODES;
> -	bool			new_parent = (src_dp != target_dp);
> -	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
> -	int			spaceres;
> -	bool			retried = false;
> -	int			error, nospace_error = 0;
> +	struct xfs_mount		*mp = src_dp->i_mount;
> +	struct xfs_trans		*tp;
> +	struct xfs_inode		*wip = NULL;	/* whiteout inode */
> +	struct xfs_inode		*inodes[__XFS_SORT_INODES];
> +	int				i;
> +	int				num_inodes = __XFS_SORT_INODES;
> +	bool				new_parent = (src_dp != target_dp);
> +	bool				src_is_directory =
> +						S_ISDIR(VFS_I(src_ip)->i_mode);
> +	int				spaceres;
> +	bool				retried = false;
> +	int				error, nospace_error = 0;
>  
>  	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
>  
> -- 
> 2.25.1
> 
