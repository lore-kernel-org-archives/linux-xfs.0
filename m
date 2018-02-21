Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:46099 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753413AbeBULza (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Feb 2018 06:55:30 -0500
Received: by mail-wr0-f195.google.com with SMTP id 34so3678260wre.13
        for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2018 03:55:29 -0800 (PST)
Date: Wed, 21 Feb 2018 12:55:26 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: Remove dead code from inode recover function
Message-ID: <20180221115526.esa7pcusqb66eokh@odin.usersys.redhat.com>
References: <1519197744-8339-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1519197744-8339-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 21, 2018 at 09:22:24AM +0200, Nikolay Borisov wrote:
> The memcpy is guarded by a check which is performed a right before we
> call xfs_log_dinode_to_disk. At this point we are sure this check will
> always be false otherwise we would have errored out. So let's remove
> this dead weight.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---

Looks good, memcpy will never be executed here, -EFSCORRUPTED will be returned
if this condition is true right before this memcpy call.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


>  fs/xfs/xfs_log_recover.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 00240c9ee72e..cb20f2e83412 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3173,13 +3173,6 @@ xlog_recover_inode_pass2(
>  	/* recover the log dinode inode into the on disk inode */
>  	xfs_log_dinode_to_disk(ldip, dip);
>  
> -	/* the rest is in on-disk format */
> -	if (item->ri_buf[1].i_len > isize) {
> -		memcpy((char *)dip + isize,
> -			item->ri_buf[1].i_addr + isize,
> -			item->ri_buf[1].i_len - isize);
> -	}
> -
>  	fields = in_f->ilf_fields;
>  	if (fields & XFS_ILOG_DEV)
>  		xfs_dinode_put_rdev(dip, in_f->ilf_u.ilfu_rdev);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
