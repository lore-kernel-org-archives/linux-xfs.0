Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751266AbcLOL0h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Dec 2016 06:26:37 -0500
Date: Thu, 15 Dec 2016 12:26:33 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2] xfs_io: Improvements to copy_range return code
 handling
Message-ID: <20161215112633.xd2yabqxd6xch2ru@eorzea.usersys.redhat.com>
References: <20161214212846.22198-1-Anna.Schumaker@Netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214212846.22198-1-Anna.Schumaker@Netapp.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com



On Wed, Dec 14, 2016 at 04:28:46PM -0500, Anna Schumaker wrote:
> If copy_file_range() returns 0, then that means no data was copied.  We
> should break out of the loop in this case to prevent looping
> indefinitely.
>

looks good for me, you can add

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> Additionally, if an error is returned by copy_file_range() then we need
> to print out the string form to be used by error checking tests in
> xfstests.
> 
> Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
> ---
> v2:
> - Use perror() instead of fprintf()
> ---
>  io/copy_file_range.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index 88203e9..249c649 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -49,8 +49,11 @@ copy_file_range(int fd, loff_t *src, loff_t *dst, size_t len)
>  
>  	do {
>  		ret = syscall(__NR_copy_file_range, fd, src, file->fd, dst, len, 0);
> -		if (ret == -1)
> +		if (ret == -1) {
> +			perror("copy_range");
>  			return errno;
> +		} else if (ret == 0)
> +			break;
>  		len -= ret;
>  	} while (len > 0);
>  
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
