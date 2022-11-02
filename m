Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF5DC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 15:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiKBPxf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 11:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiKBPxd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 11:53:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB00427159
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 08:53:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76FD061A18
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 15:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BAFC433D6;
        Wed,  2 Nov 2022 15:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667404409;
        bh=3dVMk0iNPZ6Z9jatktLzvVN5M+IvD15Pd06RJ4VEbrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b4fYEUKZKTQvxcl8cKfs5SrFw1IEKOqUGH4e/RbzFcKvHqQue2cPVJ2K+supbhAm/
         CieZe2us+TYRAHF1qkIhwkgJtTAkBRVHlzip4KKkEW8jYfLsZlvNtsIIHFKREd96m1
         Nm7UBakU6eOSS7wqyZn8AI7b4i2aHstMf/AOBHkGfbjT/4KWINst+qfVjQlP10YJCE
         q7qTffpAUDkBbRj3fU2buTFEL6OEh2uUkwWvNmWqRNdmUxdo5bt0cl2Nj8R+GpHiRN
         /LcNawR1NYmgGY3yGLIvlIDgYY+lMEZ7cq06hx0tOnKvuPu7YYBGkCWJXjwj+nfNm/
         pYVYGYhgTpoDQ==
Date:   Wed, 2 Nov 2022 08:53:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Lukas Herbolt <lukas@herbolt.com>
Subject: Re: [PATCH] xfs: Print XFS UUID on mount and umount events.
Message-ID: <Y2KSeRRpC7WAKxMa@magnolia>
References: <f23e8ec8-b4cc-79d2-95b5-df4821878f91@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f23e8ec8-b4cc-79d2-95b5-df4821878f91@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 01, 2022 at 12:19:06PM -0500, Eric Sandeen wrote:
> From: Lukas Herbolt <lukas@herbolt.com>
> 
> As of now only device names are printed out over __xfs_printk().
> The device names are not persistent across reboots which in case
> of searching for origin of corruption brings another task to properly
> identify the devices. This patch add XFS UUID upon every mount/umount
> event which will make the identification much easier.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> [sandeen: rebase onto current upstream kernel]
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> [resending this as it seems to have gotten lost, and looks to me like 
> a trivial and useful enhancement to xfs logmessages. This was requested
> (and authored!) by our support folks.]
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f02a0dd522b3..0141d9907d31 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -644,12 +644,14 @@ xfs_log_mount(
>  	int		min_logfsbs;
>  
>  	if (!xfs_has_norecovery(mp)) {
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
>  		ASSERT(xfs_is_readonly(mp));
>  	}
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f029c6702dda..0ed477df6480 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1110,7 +1110,7 @@ xfs_fs_put_super(
>  	if (!sb->s_fs_info)
>  		return;
>  
> -	xfs_notice(mp, "Unmounting Filesystem");
> +	xfs_notice(mp, "Unmounting Filesystem %pU", &mp->m_sb.sb_uuid);
>  	xfs_filestream_unmount(mp);
>  	xfs_unmountfs(mp);
>  
> 
> 
