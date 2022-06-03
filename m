Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 532F2C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 16:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242678AbiFCQOU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 12:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343694AbiFCQOT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 12:14:19 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D42B25132A
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 09:14:15 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3E3E750922C;
        Fri,  3 Jun 2022 11:13:56 -0500 (CDT)
Message-ID: <781bf2c0-5983-954e-49a5-570e365be515@sandeen.net>
Date:   Fri, 3 Jun 2022 11:14:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Content-Language: en-US
To:     Lukas Herbolt <lukas@herbolt.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20210519152247.1853357-1-lukas@herbolt.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH RFC v2] xfs: Print XFS UUID on mount and umount events.
In-Reply-To: <20210519152247.1853357-1-lukas@herbolt.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/19/21 10:22 AM, Lukas Herbolt wrote:
> As of now only device names are printed out over __xfs_printk().
> The device names are not persistent across reboots which in case
> of searching for origin of corruption brings another task to properly
> identify the devices. This patch add XFS UUID upon every mount/umount
> event which will make the identification much easier.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
> V2: Drop void casts and fix long lines

Can we revisit this? I think it's a nice enhancement.

The "nouuid" concern raised in the thread doesn't seem like a problem;
if someone mounts with "-o nouuid" then you'll see 2 different devices
mounted with the same uuid printed. I don't think that's an argument
against the patch. Printing the uuid still provides more info than not.

I, uh, also don't think the submitter should be required to do a tree-wide
change for an xfs printk enhancement. Sure, it'd be nice to have ext4
and btrfs and and and but we have no other requirements that mount-time
messages must be consistent across all filesystems....

Thanks,
-Eric

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
