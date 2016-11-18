Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56263 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751985AbcKRDWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2016 22:22:19 -0500
Subject: Re: [RFC PATCH 1/2] Btrfs: refactor btrfs_extent_same() slightly
References: <cover.1479427384.git.osandov@fb.com>
 <35c668f0a23e0424569f812523c76a1828219f76.1479427384.git.osandov@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <b9dd52b8-c43a-8e95-2e0d-914f6b12fe23@cn.fujitsu.com>
Date: Fri, 18 Nov 2016 11:22:07 +0800
MIME-Version: 1.0
In-Reply-To: <35c668f0a23e0424569f812523c76a1828219f76.1479427384.git.osandov@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, kernel-team@fb.com



At 11/18/2016 08:07 AM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> This just makes the following patch cleaner.
Looks good for me.

It is just a good refactoring. Making code short and easier to read.

And it doesn't affect the len = 0 behavior.
So no matter what the choice we do, it can be applied independently.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu
>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/ioctl.c | 33 ++++++++++++---------------------
>  1 file changed, 12 insertions(+), 21 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 7acbd2c..e23f945 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3124,26 +3124,27 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>  	int ret;
>  	u64 len = olen;
>  	struct cmp_pages cmp;
> -	int same_inode = 0;
> +	bool same_inode = (src == dst);
>  	u64 same_lock_start = 0;
>  	u64 same_lock_len = 0;
>
> -	if (src == dst)
> -		same_inode = 1;
> -
>  	if (len == 0)
>  		return 0;
>
> -	if (same_inode) {
> +	if (same_inode)
>  		inode_lock(src);
> +	else
> +		btrfs_double_inode_lock(src, dst);
>
> -		ret = extent_same_check_offsets(src, loff, &len, olen);
> -		if (ret)
> -			goto out_unlock;
> -		ret = extent_same_check_offsets(src, dst_loff, &len, olen);
> -		if (ret)
> -			goto out_unlock;
> +	ret = extent_same_check_offsets(src, loff, &len, olen);
> +	if (ret)
> +		goto out_unlock;
>
> +	ret = extent_same_check_offsets(dst, dst_loff, &len, olen);
> +	if (ret)
> +		goto out_unlock;
> +
> +	if (same_inode) {
>  		/*
>  		 * Single inode case wants the same checks, except we
>  		 * don't want our length pushed out past i_size as
> @@ -3171,16 +3172,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>
>  		same_lock_start = min_t(u64, loff, dst_loff);
>  		same_lock_len = max_t(u64, loff, dst_loff) + len - same_lock_start;
> -	} else {
> -		btrfs_double_inode_lock(src, dst);
> -
> -		ret = extent_same_check_offsets(src, loff, &len, olen);
> -		if (ret)
> -			goto out_unlock;
> -
> -		ret = extent_same_check_offsets(dst, dst_loff, &len, olen);
> -		if (ret)
> -			goto out_unlock;
>  	}
>
>  	/* don't make the dst file partly checksummed */
>


