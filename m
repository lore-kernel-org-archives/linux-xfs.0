Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54466 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752582AbeBERV3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Feb 2018 12:21:29 -0500
Subject: Re: [PATCH 5/4] xfs_io: fix copy_file_range symbol name collision
References: <151760738102.29371.13542858379823064383.stgit@magnolia>
 <20180205165041.GH4849@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4741071e-ea87-192f-e9b0-36fc9502aa86@sandeen.net>
Date: Mon, 5 Feb 2018 11:21:27 -0600
MIME-Version: 1.0
In-Reply-To: <20180205165041.GH4849@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, fredrik@crux.nu



On 2/5/18 10:50 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> glibc 2.27 has a copy_file_range wrapper, so we need to change our
> internal function out of the way to avoid compiler warnings.
> 
> Reported-by: fredrik@crux.nu
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, sure.  Yay namespace.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/copy_file_range.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index d1dfc5a..99fba20 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -42,13 +42,18 @@ copy_range_help(void)
>  "));
>  }
>  
> +/*
> + * Issue a raw copy_file_range syscall; for our test program we don't want the
> + * glibc buffered copy fallback.
> + */
>  static loff_t
> -copy_file_range(int fd, loff_t *src, loff_t *dst, size_t len)
> +copy_file_range_cmd(int fd, loff_t *src, loff_t *dst, size_t len)
>  {
>  	loff_t ret;
>  
>  	do {
> -		ret = syscall(__NR_copy_file_range, fd, src, file->fd, dst, len, 0);
> +		ret = syscall(__NR_copy_file_range, fd, src, file->fd, dst,
> +				len, 0);
>  		if (ret == -1) {
>  			perror("copy_range");
>  			return errno;
> @@ -130,7 +135,7 @@ copy_range_f(int argc, char **argv)
>  		copy_dst_truncate();
>  	}
>  
> -	ret = copy_file_range(fd, &src, &dst, len);
> +	ret = copy_file_range_cmd(fd, &src, &dst, len);
>  	close(fd);
>  	return ret;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
