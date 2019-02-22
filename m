Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:52183 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfBVUBb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Feb 2019 15:01:31 -0500
Received: by mail-it1-f195.google.com with SMTP id e24so4751544itl.1
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 12:01:30 -0800 (PST)
Message-ID: <a17b847e93bcfc1aecb208c61e356fd7bffd561a.camel@gmail.com>
Subject: Re: [PATCH v2] xfs_io: actually check copy file range helper return
 values
From: Anna Schumaker <schumaker.anna@gmail.com>
Date: Fri, 22 Feb 2019 15:01:27 -0500
In-Reply-To: <20190220171615.GM32253@magnolia>
References: <c4b7eff6-8395-3d01-eaaf-736e32e6e1dc@redhat.com>
         <b48c8b5d-9ed3-c4b6-c7fc-2c13df211dd3@redhat.com>
         <20190220171615.GM32253@magnolia>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, 2019-02-20 at 09:16 -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We need to check the return value of copy_src_filesize and
> copy_dst_truncate because either could return -1 due to fstat/ftruncate
> failure.

Makes sense.

Reviewed-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

> 
> Fixes: 628e112afdd98c5 ("xfs_io: implement 'copy_range' command")
> Cc: schumaker.anna@gmail.com
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: fix return values and overflow problems
> ---
>  io/copy_file_range.c |   17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index 4e2969c9..d069e5bb 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -120,11 +120,24 @@ copy_range_f(int argc, char **argv)
>  		return 0;
>  
>  	if (src == 0 && dst == 0 && len == 0) {
> -		len = copy_src_filesize(fd);
> -		copy_dst_truncate();
> +		off64_t	sz;
> +
> +		sz = copy_src_filesize(fd);
> +		if (sz < 0 || (unsigned long long)sz > SIZE_MAX) {
> +			ret = 1;
> +			goto out;
> +		}
> +		len = sz;
> +
> +		ret = copy_dst_truncate();
> +		if (ret < 0) {
> +			ret = 1;
> +			goto out;
> +		}
>  	}
>  
>  	ret = copy_file_range_cmd(fd, &src, &dst, len);
> +out:
>  	close(fd);
>  	return ret;
>  }
