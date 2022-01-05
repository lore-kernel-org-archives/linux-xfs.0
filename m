Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF03C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 00:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbiAEArT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 19:47:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34862 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiAEArT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 19:47:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BE3261476
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 00:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CE1C36AED;
        Wed,  5 Jan 2022 00:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641343638;
        bh=A8pogjzSnyo4nbvyEu6Z3wmjiyc+IRbCQleNjM/Y6bU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p4tnetpAnwHGuAglO9nj5jgBtcudrRrOLjJ3s7X8Dd0PgFbJwSyVGS8prvj+F5PCE
         rPOWlwwPGuexHfD9kI/5k+74MFCGAyFB/rSporYIaTNvXYLhjuTzrTRXjKDziQbZr+
         larcq/gqkRNw/E7nPp7l7GG+gMkF6APOlPqhrKeAV86wG9o+ooLHxq5hLCr1JNN+VY
         t1oSotwreL0H9ypq2hf+hclmDxVOQDoSocMEAOnCvTJm/IhIZsQcoeYtqf5hYlu9MX
         Xrf/DsgbW2TviXmkLjx5ka+/pNACtc/gxtExXV7QHNZVoxPC1lB+dGLFdPTSLcXZ7L
         Jykjt6YnTAcog==
Date:   Tue, 4 Jan 2022 16:47:18 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 15/16] xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the
 list of supported flags
Message-ID: <20220105004718.GU31583@magnolia>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-16-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-16-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:15:18PM +0530, Chandan Babu R wrote:
> This commit enables XFS module to work with fs instances having 64-bit
> per-inode extent counters by adding XFS_SB_FEAT_INCOMPAT_NREXT64 flag to the
> list of supported incompat feature flags.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_format.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 2868cec1154d..3183f78fe7a3 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -378,7 +378,8 @@ xfs_sb_has_ro_compat_feature(
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
>  		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
>  		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
> -		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
> +		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
> +		 XFS_SB_FEAT_INCOMPAT_NREXT64)
>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> -- 
> 2.30.2
> 
