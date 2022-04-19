Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D56C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 17:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbiDSRQX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 13:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiDSRQX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 13:16:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02AB3A716
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 10:13:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D26FCE1ABC
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 17:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B9FC385A9;
        Tue, 19 Apr 2022 17:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650388416;
        bh=1UC1pDFN66+MZ9T8UvrFpFz4mWbOCoU7PAT94En4if8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uWv3o215TYtpvXck9mRN+xDRRbBk0qS91xMjhw1UppvhV7nIGXfu77/lnpENs3eK6
         qCl/1Ufj4K4zvpBLiS73ZBWfgqSriuOUUZu7DCQ4OMqrJ9w6r1w5Yw9YnPVYjDmluq
         gpC5boE+/SCkzEeuZ9qRTC51npIQ7/a42ogkecPMI3qM6CN0Xd7GWarTMlB+Sdn5gj
         zB3Xq3i+n6EuiuJ0s8rUqnNvcwzs04GpXAq0g7XKaNGXeqHi/kHbwkLacveBATJ7WD
         WLpOxAdqNqR2VJIk5UsRj0yR0d0dr034+szCj/Y/JXFRiyge6diMX4xCVTDkp03G1w
         a2Vry/TUBgVYw==
Date:   Tue, 19 Apr 2022 10:13:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: simplify the local variables assignment
Message-ID: <20220419171335.GM17025@magnolia>
References: <1650382606-22553-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1650382606-22553-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 11:36:46PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Get the struct inode pointer from iocb->ki_filp->f_mapping->host directly
> and the other variables are unnecessary, so simplify the local variables
> assignment.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Assuming this compiles on the maintainer's for-next branch, I think
you're correct that @file and @mapping are no longer needed.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5bddb1e9e0b3..691e98fe4eee 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -694,9 +694,7 @@ xfs_file_buffered_write(
>  	struct kiocb		*iocb,
>  	struct iov_iter		*from)
>  {
> -	struct file		*file = iocb->ki_filp;
> -	struct address_space	*mapping = file->f_mapping;
> -	struct inode		*inode = mapping->host;
> +	struct inode		*inode = iocb->ki_filp->f_mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	ssize_t			ret;
>  	bool			cleared_space = false;
> @@ -767,9 +765,7 @@ xfs_file_write_iter(
>  	struct kiocb		*iocb,
>  	struct iov_iter		*from)
>  {
> -	struct file		*file = iocb->ki_filp;
> -	struct address_space	*mapping = file->f_mapping;
> -	struct inode		*inode = mapping->host;
> +	struct inode		*inode = iocb->ki_filp->f_mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	ssize_t			ret;
>  	size_t			ocount = iov_iter_count(from);
> -- 
> 2.27.0
> 
