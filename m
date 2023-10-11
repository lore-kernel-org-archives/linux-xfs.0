Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E8DCDB47A
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 19:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbjJKTCr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 15:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbjJKTCq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 15:02:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF5794
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 12:02:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418E6C433C7;
        Wed, 11 Oct 2023 19:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697050965;
        bh=oMzXkjxA3unXfKGtJD03jI+dq4ZP8nkrRSfYX2Zg/8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WbzwVOO1rZF+Rmk/7wPNIxo/1a9vz4yEBUfthqJ5lxlqWcHpA11NX42pvzA3tPVmT
         1DJPuru8mtHY+74bAxJdFcPix9HujyqTOXs7GOoAa0RkIn/N/Rn327VSILTOJs3sAH
         E5N76smjBPHvrk1dq424ad2waRQj1SFS0jfs+PuasL7V/RdB4Ym1GQIuWEwkjt8WGE
         vVsJGERlQ3lLeYnPK0Is9S9QSYR4ppQt0GFusAkn1l0cDo/ym2ogz5Deahg889Jm+z
         GbNW7FZBmY2Xw5EnpHfA9/Z162ykD7bEduIHZOvKOsfKj42t/XqzTIou5aysDr8ELg
         1FeyIxcBXhzpw==
Date:   Wed, 11 Oct 2023 12:02:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 24/28] xfs: disable direct read path for fs-verity
 sealed files
Message-ID: <20231011190244.GW21298@frogsfrogsfrogs>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-25-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006184922.252188-25-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2023 at 08:49:18PM +0200, Andrey Albershteyn wrote:
> The direct path is not supported on verity files. Attempts to use direct
> I/O path on such files should fall back to buffered I/O path.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index a92c8197c26a..7363cbdff803 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -244,7 +244,8 @@ xfs_file_dax_read(
>  	struct kiocb		*iocb,
>  	struct iov_iter		*to)
>  {
> -	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
> +	struct inode		*inode = iocb->ki_filp->f_mapping->host;
> +	struct xfs_inode	*ip = XFS_I(inode);
>  	ssize_t			ret = 0;
>  
>  	trace_xfs_file_dax_read(iocb, to);
> @@ -297,10 +298,17 @@ xfs_file_read_iter(
>  
>  	if (IS_DAX(inode))
>  		ret = xfs_file_dax_read(iocb, to);
> -	else if (iocb->ki_flags & IOCB_DIRECT)
> +	else if (iocb->ki_flags & IOCB_DIRECT && !fsverity_active(inode))
>  		ret = xfs_file_dio_read(iocb, to);
> -	else
> +	else {
> +		/*
> +		 * In case fs-verity is enabled, we also fallback to the
> +		 * buffered read from the direct read path. Therefore,
> +		 * IOCB_DIRECT is set and need to be cleared
> +		 */
> +		iocb->ki_flags &= ~IOCB_DIRECT;

We don't clear IOCB_DIRECT when directio writes fall back to buffered
writes; why is it necessary here?

--D

>  		ret = xfs_file_buffered_read(iocb, to);
> +	}
>  
>  	if (ret > 0)
>  		XFS_STATS_ADD(mp, xs_read_bytes, ret);
> -- 
> 2.40.1
> 
