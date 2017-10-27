Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43960 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751179AbdJ0QdZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2017 12:33:25 -0400
Date: Fri, 27 Oct 2017 09:33:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] fiemap: Factor out actual fiemap call code
Message-ID: <20171027163320.GL5483@magnolia>
References: <1509107832-22286-1-git-send-email-nborisov@suse.com>
 <1509107832-22286-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1509107832-22286-2-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Oct 27, 2017 at 03:37:09PM +0300, Nikolay Borisov wrote:
> This will be needed to in a subsequent patch to avoid code duplication. No 
> functional changes
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  io/fiemap.c | 38 +++++++++++++++++++++++++++-----------
>  1 file changed, 27 insertions(+), 11 deletions(-)
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index e6fd66da753d..4a52bff974e8 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -211,6 +211,30 @@ calc_print_format(
>  	}
>  }
>  
> +static int
> +__fiemap(struct fiemap * fiemap,

Function parameter should be on a separate line.

> +	 int		 mapsize,
> +	 __u32		 flags,
> +	 __u64		 start,
> +	 __u64		 length) {
> +
> +	int ret;
> +
> +	memset(fiemap, 0, mapsize);
> +        fiemap->fm_flags = flags;

Space/tab indent problems.

> +        fiemap->fm_start = start;
> +        fiemap->fm_length = length;
> +        fiemap->fm_extent_count = EXTENT_BATCH;
> +	ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);

Do we still need the unsigned long cast?

--D

> +	if (ret < 0) {
> +	        fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAP) [\"%s\"]: "
> +	                "%s\n", progname, file->name, strerror(errno));
> +	        return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  int
>  fiemap_f(
>  	int		argc,
> @@ -266,19 +290,11 @@ fiemap_f(
>  
>  	while (!last && (cur_extent != max_extents)) {
>  
> -		memset(fiemap, 0, map_size);
> -		fiemap->fm_flags = fiemap_flags;
> -		fiemap->fm_start = last_logical;
> -		fiemap->fm_length = -1LL;
> -		fiemap->fm_extent_count = EXTENT_BATCH;
> -
> -		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
> +		ret = __fiemap(fiemap, map_size, fiemap_flags, last_logical,
> +			       len - covered_length);
>  		if (ret < 0) {
> -			fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAP) [\"%s\"]: "
> -				"%s\n", progname, file->name, strerror(errno));
> -			free(fiemap);
>  			exitcode = 1;
> -			return 0;
> +			goto out;
>  		}
>  
>  		/* No more extents to map, exit */
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
