Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 647107CA7
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 07:35:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2E41AC001
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 05:35:35 -0700 (PDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com
	[74.125.82.67]) by cuda.sgi.com with ESMTP id lWOtffyioyeByUHu
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2016 05:35:32 -0700 (PDT)
Received: by mail-wm0-f67.google.com with SMTP id a66so8634694wme.2
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 05:35:32 -0700 (PDT)
From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 1/3] block: invalidate the page cache when issuing
	BLKZEROOUT.
References: <146612624734.12764.4316680863289411106.stgit@birch.djwong.org>
	<146612625412.12764.6647932282740152837.stgit@birch.djwong.org>
Message-ID: <7589fc01-a000-a912-f9b5-cf099cc2d27a@acm.org>
Date: Mon, 20 Jun 2016 14:35:29 +0200
MIME-Version: 1.0
In-Reply-To: <146612625412.12764.6647932282740152837.stgit@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@infradead.org" <hch@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "bfoster@redhat.com" <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On 06/17/2016 03:18 AM, Darrick J. Wong wrote:
> Invalidate the page cache (as a regular O_DIRECT write would do) to avoid
> returning stale cache contents at a later time.
>
> v5: Refactor the 4.4 refactoring of the ioctl code into separate functions.
> Split the page invalidation and the new ioctl into separate patches.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/ioctl.c |   29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
>
>
> diff --git a/block/ioctl.c b/block/ioctl.c
> index ed2397f..d001f52 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -225,7 +225,9 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
>  		unsigned long arg)
>  {
>  	uint64_t range[2];
> -	uint64_t start, len;
> +	struct address_space *mapping;
> +	uint64_t start, end, len;
> +	int ret;
>
>  	if (!(mode & FMODE_WRITE))
>  		return -EBADF;
> @@ -235,18 +237,33 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
>
>  	start = range[0];
>  	len = range[1];
> +	end = start + len - 1;
>
>  	if (start & 511)
>  		return -EINVAL;
>  	if (len & 511)
>  		return -EINVAL;
> -	start >>= 9;
> -	len >>= 9;
> -
> -	if (start + len > (i_size_read(bdev->bd_inode) >> 9))
> +	if (end >= (uint64_t)i_size_read(bdev->bd_inode))
> +		return -EINVAL;
> +	if (end < start)
>  		return -EINVAL;
>
> -	return blkdev_issue_zeroout(bdev, start, len, GFP_KERNEL, false);
> +	/* Invalidate the page cache, including dirty pages */
> +	mapping = bdev->bd_inode->i_mapping;
> +	truncate_inode_pages_range(mapping, start, end);
> +
> +	ret = blkdev_issue_zeroout(bdev, start >> 9, len >> 9, GFP_KERNEL,
> +				    false);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Invalidate again; if someone wandered in and dirtied a page,
> +	 * the caller will be given -EBUSY.
> +	 */
> +	return invalidate_inode_pages2_range(mapping,
> +					     start >> PAGE_SHIFT,
> +					     end >> PAGE_SHIFT);
>  }

Hello Darrick,

Maybe this has already been discussed, but anyway: in the POSIX spec 
(http://pubs.opengroup.org/onlinepubs/9699919799/functions/write.html) I 
found the following: "This volume of POSIX.1-2008 does not specify 
behavior of concurrent writes to a file from multiple processes. 
Applications should use some form of concurrency control."

Do we really need the invalidate_inode_pages2_range() call?

Thanks,

Bart.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
