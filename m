Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51000 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbeEKX6a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 19:58:30 -0400
Date: Fri, 11 May 2018 16:58:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] vfs: allow dedupe of user owned read-only files
Message-ID: <20180511235822.GF9510@magnolia>
References: <20180511192651.21324-1-mfasheh@suse.de>
 <20180511192651.21324-2-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511192651.21324-2-mfasheh@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 12:26:50PM -0700, Mark Fasheh wrote:
> The permission check in vfs_dedupe_file_range() is too coarse - We
> only allow dedupe of the destination file if the user is root, or
> they have the file open for write.
> 
> This effectively limits a non-root user from deduping their own
> read-only files. As file data during a dedupe does not change,
> this is unexpected behavior and this has caused a number of issue
> reports. For an example, see:
> 
> https://github.com/markfasheh/duperemove/issues/129
> 
> So change the check so we allow dedupe on the target if:
> 
> - the root or admin is asking for it
> - the owner of the file is asking for the dedupe
> - the process has write access
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

Sounds fine I guess....
Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/read_write.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index c4eabbfc90df..77986a2e2a3b 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -2036,7 +2036,8 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
>  
>  		if (info->reserved) {
>  			info->status = -EINVAL;
> -		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE))) {
> +		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE) ||
> +			     uid_eq(current_fsuid(), dst->i_uid))) {
>  			info->status = -EINVAL;
>  		} else if (file->f_path.mnt != dst_file->f_path.mnt) {
>  			info->status = -EXDEV;
> -- 
> 2.15.1
> 
