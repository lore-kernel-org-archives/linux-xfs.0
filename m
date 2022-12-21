Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9878DC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 16:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiLUQdK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Dec 2022 11:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiLUQdI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 11:33:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9B429A
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 08:33:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4709B81B97
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 16:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1A3C433EF;
        Wed, 21 Dec 2022 16:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671640385;
        bh=TXaHgXfRkI1xQRneh3XRBHprTZLicA6ycjshL+jng9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PNJwv4XDsxf6okIJGcYmlNAszrINm3yHxHmaZ3W/6S97t0DmyTGVROvIytAN1h2DO
         +R7id1BgJu4jjFJ3fg96CvPb6vGEoPFEPy7IJadIvQU68pIkWCd7DWmq3mhGBLXuHo
         XsRSrVSnOYPQRyjMrIjk1B47EfoUfwSjHfTecutYT/hzCNxZQKu8Cj5sJWl3dZaYGQ
         irya2mSYxUU/iCSY2Y0SzK7JIm731N1eM3AHtJyjtvjFCi1Xm64KdXgsaezYCu1LNJ
         d8jHWroP6uc0GMYbZYqBU/9ubY6tzTXgChvc+SQbraFkKEQ+WOdyFfpSdjEQOvCV33
         m3xIurjkWg8sA==
Date:   Wed, 21 Dec 2022 08:33:04 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Hironori Shiina <shiina.hironori@gmail.com>
Cc:     linux-xfs@vger.kernel.org,
        Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: Re: [PATCH] xfs: get root inode correctly at bulkstat
Message-ID: <Y6M1QGuxmOD5G6vy@magnolia>
References: <20221221152221.120005-1-shiina.hironori@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221152221.120005-1-shiina.hironori@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 21, 2022 at 10:22:21AM -0500, Hironori Shiina wrote:
> The root inode number should be set to `breq->startino` for getting stat
> information of the root when XFS_BULK_IREQ_SPECIAL_ROOT is used.
> Otherwise, the inode search is started from 1
> (XFS_BULK_IREQ_SPECIAL_ROOT) and the inode with the lowest number in a
> filesystem is returned.
> 
> Fixes: bf3cb3944792 ("xfs: allow single bulkstat of special inodes")
> Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>

D'oh.  Nobody noticed this because .... the root dir is usually the
first inode in the first inode chunk, and XFS_BULK_IREQ_SPECIAL_ROOT==1,
so that usually lines us up to find the root dir.

Except in that weird case where we format with a big stripe alignment,
mount with zeroed stripe alignment, and then stuff gets allocated before
the ichunk containing the root inode, right?

> ---
>  fs/xfs/xfs_ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 13f1b2add390..020111f0f2a2 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -780,7 +780,7 @@ xfs_bulk_ireq_setup(
>  
>  		switch (hdr->ino) {

I might change @hdr to be a const pointer to prevent further accidents
here when I commit this.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  		case XFS_BULK_IREQ_SPECIAL_ROOT:
> -			hdr->ino = mp->m_sb.sb_rootino;
> +			breq->startino = mp->m_sb.sb_rootino;
>  			break;
>  		default:
>  			return -EINVAL;
> -- 
> 2.38.1
> 
