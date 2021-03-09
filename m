Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 216EBC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 21:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE9F964F60
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 21:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhCIV2y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 16:28:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232041AbhCIV22 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Mar 2021 16:28:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DC646527D;
        Tue,  9 Mar 2021 21:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615325308;
        bh=OCUKSM82JcZBeg1gzLK250mJfGKd71S4zR9hy6ZQnlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MEr3BI+whHd9LtNuLzC1UYj4RGgJjq+QODoHvoGoHXQrjJEFSp5k1VKp+Z7mpjIwm
         jee4bHIoO4u77AEoAsUZVC5g5HLSRwzr/7VwKHMOKfoix/peEjdjj+x9Vj8wYmHmHB
         X0UEXBBrywkZyHjZYTTmIbvBTbyqYAkAmJucZqODX53sJdK/EpdpZ8vV0X55HZAklI
         5EMZosInFoaBRH6o6RBXdGjaAYJcIoOjl6BSVYtDnNtxbA0nXfs2Fb9pc+TiOyph3G
         sv6ms8AmhfIqy+eIXI1ETrwpM2OjYDNvNkeHp0Iv8j+fbgfeHUXLUYeHa6v/HwtKBM
         cLZKgxR1lOlzA==
Date:   Tue, 9 Mar 2021 13:28:27 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH] xfs: ensure xfs_errortag_random_default matches
 XFS_ERRTAG_MAX
Message-ID: <20210309212827.GA3419940@magnolia>
References: <20210309184205.18675-1-hsiangkao.ref@aol.com>
 <20210309184205.18675-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309184205.18675-1-hsiangkao@aol.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 02:42:05AM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> Add the BUILD_BUG_ON to xfs_errortag_add() in order to make sure that
> the length of xfs_errortag_random_default matches XFS_ERRTAG_MAX when
> building.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Yay!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_error.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 185b4915b7bf..82425c9a623d 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -299,6 +299,7 @@ xfs_errortag_add(
>  	struct xfs_mount	*mp,
>  	unsigned int		error_tag)
>  {
> +	BUILD_BUG_ON(ARRAY_SIZE(xfs_errortag_random_default) != XFS_ERRTAG_MAX);
>  	if (error_tag >= XFS_ERRTAG_MAX)
>  		return -EINVAL;
>  
> -- 
> 2.20.1
> 
