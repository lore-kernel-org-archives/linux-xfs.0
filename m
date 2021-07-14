Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F3F8C11F66
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 05:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61ABB61279
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 05:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237815AbhGNFH2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 01:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhGNFH2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 01:07:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 016B960FD8;
        Wed, 14 Jul 2021 05:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626239077;
        bh=Jc1sNtDQLolCUqZGQica4040YhI273wmJsvNWUazVMU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UWnd/YzekvcZgciRPDO2VDGc5jefYAa1w8p3Vjj4SV7C/lPk0nz0bWt6/xjz0r+LN
         /vsMehsZND0VXQBUpUt+yqOmVnh0nJnnv+5jeOHtFoErWyN5uO26GhuWQGXnZYFNtx
         rZxXFverfex9HCcHFguzDqBLrC7mc41WwHaKY51njN+ELp1nH80BNjSPGnY7xW1Wh8
         WXJ/XCZ0IShzVBu2YPhe/z0Ytdvm3PViCRMF7DWftS9pUMgBxyyzamzDc1wq5GelGt
         I8To5FlidFdvSjJH5ie48P6mPDmR8ggS4bVkzvnSXWnzw4y1TT5TD1a3/A5cRrodnt
         8Gl0faYQvuXbQ==
Date:   Tue, 13 Jul 2021 22:04:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wang Shilong <wangshilong1991@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Wang Shilong <wshilong@ddn.com>
Subject: Re: [PATCH v4] fs: forbid invalid project ID
Message-ID: <20210714050436.GH22402@magnolia>
References: <20210710143959.58077-1-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710143959.58077-1-wangshilong1991@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 10, 2021 at 10:39:59PM +0800, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> fileattr_set_prepare() should check if project ID
> is valid, otherwise dqget() will return NULL for
> such project ID quota.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
> v3->v3:
> only check project Id if caller is allowed
> to change and being changed.
> 
> v2->v3: move check before @fsx_projid is accessed
> and use make_kprojid() helper.
> 
> v1->v2: try to fix in the VFS
>  fs/ioctl.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 1e2204fa9963..d4fabb5421cd 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -817,6 +817,14 @@ static int fileattr_set_prepare(struct inode *inode,
>  		if ((old_ma->fsx_xflags ^ fa->fsx_xflags) &
>  				FS_XFLAG_PROJINHERIT)
>  			return -EINVAL;
> +	} else {
> +		/*
> +		 * Caller is allowed to change the project ID. If it is being
> +		 * changed, make sure that the new value is valid.
> +		 */
> +		if (old_ma->fsx_projid != fa->fsx_projid &&
> +		    !projid_valid(make_kprojid(&init_user_ns, fa->fsx_projid)))
> +			return -EINVAL;

Hmm, for XFS this is sort of a userspace-breaking change in the sense
that (technically) we've never rejected -1 before.  xfs_quota won't have
anything to do with that, and (assuming I read the helper/macro
gooeyness correctly) the vfs quota code won't either, so

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	}
>  
>  	/* Check extent size hints. */
> -- 
> 2.27.0
> 
