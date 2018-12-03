Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54042 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbeLCQ1m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 11:27:42 -0500
Date: Mon, 3 Dec 2018 08:27:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/2] xfs_io: copy_file_range length is a size_t
Message-ID: <20181203162732.GV8125@magnolia>
References: <20181202205343.7104-1-david@fromorbit.com>
 <20181203002036.GB6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203002036.GB6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 03, 2018 at 11:20:36AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> copy_file_range() takes a size_t as it's length, not a "long long".
> Therefore we need to be able to pass sizes larger than 8EB to it
> to be able to test the interface fully and that requires copy_range
> to accept all values except an explicit error value of "-1LL".
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  io/copy_file_range.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index f118a3bfd506..4e2969c9ca47 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -34,7 +34,7 @@ copy_range_help(void)
>   * glibc buffered copy fallback.
>   */
>  static loff_t
> -copy_file_range_cmd(int fd, long long *src, long long *dst, long long len)
> +copy_file_range_cmd(int fd, long long *src, long long *dst, size_t len)
>  {
>  	loff_t ret;
>  
> @@ -78,7 +78,7 @@ copy_range_f(int argc, char **argv)
>  {
>  	long long src = 0;
>  	long long dst = 0;
> -	long long len = 0;
> +	size_t len = 0;
>  	int opt;
>  	int ret;
>  	int fd;
> @@ -104,7 +104,7 @@ copy_range_f(int argc, char **argv)
>  			break;
>  		case 'l':
>  			len = cvtnum(fsblocksize, fssectsize, optarg);
> -			if (len < 0) {
> +			if (len == -1LL) {
>  				printf(_("invalid length -- %s\n"), optarg);
>  				return 0;
>  			}
> 
