Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49688 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbfE1Qjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 May 2019 12:39:33 -0400
Date: Tue, 28 May 2019 09:37:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 8/8] vfs: remove redundant checks from
 generic_remap_checks()
Message-ID: <20190528163718.GI5221@magnolia>
References: <20190526061100.21761-1-amir73il@gmail.com>
 <20190526061100.21761-9-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190526061100.21761-9-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-api@vger.kernel.org

On Sun, May 26, 2019 at 09:10:59AM +0300, Amir Goldstein wrote:
> The access limit checks on input file range in generic_remap_checks()
> are redundant because the input file size is guarantied to be within

                                    guaranteed ^^^^^^^^^^

> limits and pos+len are already checked to be within input file size.
> 
> Beyond the fact that the check cannot fail, if it would have failed,
> it could return -EFBIG for input file range error. There is no precedent
> for that. -EFBIG is returned in syscalls that would change file length.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  mm/filemap.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 1852fbf08eeb..7e1aa36d57a2 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3000,10 +3000,6 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
>  		return -EINVAL;
>  	count = min(count, size_in - (uint64_t)pos_in);
>  
> -	ret = generic_access_check_limits(file_in, pos_in, &count);

I suspect you could fold generic_access_check_limits into its only
caller, then...

--D

> -	if (ret)
> -		return ret;
> -
>  	ret = generic_write_check_limits(file_out, pos_out, &count);
>  	if (ret)
>  		return ret;
> -- 
> 2.17.1
> 
