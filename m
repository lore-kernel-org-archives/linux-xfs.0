Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2SFKUJo116131 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 10:20:30 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	WtfsqnZ097VkmuSK (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Mar 2012 08:20:29 -0700 (PDT)
Date: Wed, 28 Mar 2012 11:20:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: kill b_file_offset
Message-ID: <20120328152028.GA12205@infradead.org>
References: <1332911958-5613-1-git-send-email-david@fromorbit.com>
	<1332911958-5613-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1332911958-5613-3-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Looks good.

Reviewed-by: Christoph Hellwig <hch@lst.de>


Minor comments below:

On Wed, Mar 28, 2012 at 04:19:16PM +1100, Dave Chinner wrote:
> -	end = bp->b_file_offset + bp->b_buffer_length;
> -	page_count = xfs_buf_btoc(end) - xfs_buf_btoct(bp->b_file_offset);
> +	end = BBTOB(bp->b_bn) + bp->b_buffer_length;
> +	page_count = xfs_buf_btoc(end) - xfs_buf_btoct(BBTOB(bp->b_bn));

Btw, xfs_buf_btoc and xfs_buf_btoct are more remoal candidates,
they actually make the code harder to read compared to using the
opencoded arithmetics..

>  	numbytes = numblks << BBSHIFT;
>  
>  	/* Check for IOs smaller than the sector size / not sector aligned */
>  	ASSERT(!(numbytes < (1 << btp->bt_sshift)));
> -	ASSERT(!(offset & (xfs_off_t)btp->bt_smask));
> +	ASSERT(!(BBTOB(blkno) & (xfs_off_t)btp->bt_smask));

I don't think it makes sense to keep this assert, given that the
return value from BBTOB is aligned by defintion.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
