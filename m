Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38194 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752473AbeERWEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 May 2018 18:04:45 -0400
Date: Fri, 18 May 2018 15:04:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/2] vfs: dedupe should return EPERM if permission is
 not granted
Message-ID: <20180518220413.GB31250@magnolia>
References: <20180518215727.26418-1-mfasheh@suse.de>
 <20180518215727.26418-3-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518215727.26418-3-mfasheh@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>

On Fri, May 18, 2018 at 02:57:27PM -0700, Mark Fasheh wrote:
> Right now we return EINVAL if a process does not have permission to dedupe a
> file. This was an oversight on my part. EPERM gives a true description of
> the nature of our error, and EINVAL is already used for the case that the
> filesystem does not support dedupe.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

Looks ok what with all the okays after I squawked last time,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/read_write.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index cbea4ce58ad1..2238928ca819 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -2050,7 +2050,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
>  		if (info->reserved) {
>  			info->status = -EINVAL;
>  		} else if (!allow_file_dedupe(dst_file)) {
> -			info->status = -EINVAL;
> +			info->status = -EPERM;
>  		} else if (file->f_path.mnt != dst_file->f_path.mnt) {
>  			info->status = -EXDEV;
>  		} else if (S_ISDIR(dst->i_mode)) {
> -- 
> 2.15.1
> 
