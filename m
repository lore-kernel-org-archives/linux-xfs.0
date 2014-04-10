Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C41127FB4
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 05:40:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B7A6D8F8052
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 03:40:02 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id AuBHuHrBwVpyI2it (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 03:40:01 -0700 (PDT)
Date: Thu, 10 Apr 2014 03:40:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] xfs: zeroing space needs to punch delalloc blocks
Message-ID: <20140410104001.GG17641@infradead.org>
References: <1397106053-7489-1-git-send-email-david@fromorbit.com>
	<1397106053-7489-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397106053-7489-5-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 03:00:51PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we are zeroing space andit is covered by a delalloc range, we
> need to punch the delalloc range out before we truncate the page
> cache. Failing to do so leaves and inconsistency between the page
> cache and the extent tree, which we later trip over when doing
> direct IO over the same range.

Looks good.

Which test found this?

> @@ -1432,9 +1434,18 @@ xfs_zero_file_space(
>  	ASSERT(end_boundary <= offset + len);
>  
>  	if (start_boundary < end_boundary - 1) {
> -		/* punch out the page cache over the conversion range */
> +		/*
> +		 * punch out delayed allocation blocks and the page cache over
> +		 * the conversion range
> +		 */
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +		error = xfs_bmap_punch_delalloc_range(ip,
> +				XFS_B_TO_FSB(mp, start_boundary),

Shouldn't this be XFS_B_TO_FSBT?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
