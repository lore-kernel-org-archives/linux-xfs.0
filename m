Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A3E9C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 15:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAB8961073
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 15:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241406AbhETPZW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 May 2021 11:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232073AbhETPYo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 May 2021 11:24:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB95C6124C;
        Thu, 20 May 2021 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621524203;
        bh=uezZiIhDBwGtYE+bujGDUHlMzkESkwrqIcFOxXOV/a4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NPiDBWdWT7DdvJ7yq72yspmPT6yt+D1CI8cWNgTmjWWCAa6rjqzVCjAruaguESkM9
         a5/7/AzL+8+bkqG0cI/ZRuJlpknk1NtD5dm6DBJxxMKzXbuzRxmsoIu/RbDD914u5f
         bzweyeYxwwXtYFmX9TZ2v8ZZTopgeKASj0/xRasTm7juSMvwfHjRwx409Y137t1+Qk
         mIwMm7Au0sWZ/6Tkzo9pmJKLVnM/YFtBbXW3ZTZHiQhq9S4lifPvt878SZ8zaFXcYO
         gHmFQ1+1s3xYtVQaAHppONHIdO1HsJYctbw9QZxGFCgqSnITiG0h7mlvkanf5c9sOX
         C2T8GTo7xRuuQ==
Date:   Thu, 20 May 2021 08:23:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Lukas Herbolt <lukas@herbolt.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC v2] xfs: Print XFS UUID on mount and umount events.
Message-ID: <20210520152323.GW9675@magnolia>
References: <20210519152247.1853357-1-lukas@herbolt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519152247.1853357-1-lukas@herbolt.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 05:22:48PM +0200, Lukas Herbolt wrote:
> As of now only device names are printed out over __xfs_printk().
> The device names are not persistent across reboots which in case
> of searching for origin of corruption brings another task to properly
> identify the devices. This patch add XFS UUID upon every mount/umount
> event which will make the identification much easier.

A few questions....

Are you going to wire up fs uuid logging for the other filesystems that
support them?

What happens w.r.t. uuid disambiguation if someone uses a nouuid mount
to mount a filesystem with the same uuid as an already-mounted xfs?

The changes themselves look ok, but I'm wondering what the use case is
here.

--D

> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
> V2: Drop void casts and fix long lines
> 
>  fs/xfs/xfs_log.c   | 10 ++++++----
>  fs/xfs/xfs_super.c |  2 +-
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 06041834daa31..8f4f671fd80d5 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -570,12 +570,14 @@ xfs_log_mount(
>  	int		min_logfsbs;
>  
>  	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
> -		xfs_notice(mp, "Mounting V%d Filesystem",
> -			   XFS_SB_VERSION_NUM(&mp->m_sb));
> +		xfs_notice(mp, "Mounting V%d Filesystem %pU",
> +			   XFS_SB_VERSION_NUM(&mp->m_sb),
> +			   &mp->m_sb.sb_uuid);
>  	} else {
>  		xfs_notice(mp,
> -"Mounting V%d filesystem in no-recovery mode. Filesystem will be inconsistent.",
> -			   XFS_SB_VERSION_NUM(&mp->m_sb));
> +"Mounting V%d filesystem %pU in no-recovery mode. Filesystem will be inconsistent.",
> +			   XFS_SB_VERSION_NUM(&mp->m_sb),
> +			   &mp->m_sb.sb_uuid);
>  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
>  	}
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e5e0713bebcd8..a4b8a5ad8039f 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1043,7 +1043,7 @@ xfs_fs_put_super(
>  	if (!sb->s_fs_info)
>  		return;
>  
> -	xfs_notice(mp, "Unmounting Filesystem");
> +	xfs_notice(mp, "Unmounting Filesystem %pU", &mp->m_sb.sb_uuid);
>  	xfs_filestream_unmount(mp);
>  	xfs_unmountfs(mp);
>  
> -- 
> 2.31.1
> 
