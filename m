Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:32780 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753130AbdIGJFV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2017 05:05:21 -0400
Received: by mail-lf0-f50.google.com with SMTP id c80so1001952lfh.0
        for <linux-xfs@vger.kernel.org>; Thu, 07 Sep 2017 02:05:20 -0700 (PDT)
Date: Thu, 7 Sep 2017 11:05:17 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs: kill meaningless variable 'zero'
Message-ID: <20170907090517.gdqdllxs55cwk2ep@hades.localdomain>
References: <20170907034254.7180-1-eguan@redhat.com>
 <20170907034254.7180-2-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907034254.7180-2-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 07, 2017 at 11:42:54AM +0800, Eryu Guan wrote:
> In xfs_file_aio_write_checks(), variable 'zero' is there only to
> satisfy xfs_zero_eof(), the result of it is ignored. Now, with
> iomap_zero_range() based xfs_zero_eof(), we can safely pass NULL as
> the last param of it and kill 'zero'.
> 

Looks good to me, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 812cd17b331f..e7dbeed0f0cb 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -373,8 +373,6 @@ xfs_file_aio_write_checks(
>  	 */
>  	spin_lock(&ip->i_flags_lock);
>  	if (iocb->ki_pos > i_size_read(inode)) {
> -		bool	zero = false;
> -
>  		spin_unlock(&ip->i_flags_lock);
>  		if (!drained_dio) {
>  			if (*iolock == XFS_IOLOCK_SHARED) {
> @@ -395,7 +393,7 @@ xfs_file_aio_write_checks(
>  			drained_dio = true;
>  			goto restart;
>  		}
> -		error = xfs_zero_eof(ip, iocb->ki_pos, i_size_read(inode), &zero);
> +		error = xfs_zero_eof(ip, iocb->ki_pos, i_size_read(inode), NULL);
>  		if (error)
>  			return error;
>  	} else
> -- 
> 2.13.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
