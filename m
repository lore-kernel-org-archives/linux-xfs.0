Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K6aFag249605 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 01:36:15 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zkYOTqx1on9JoySs (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Jun 2012 23:36:14 -0700 (PDT)
Date: Wed, 20 Jun 2012 02:36:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] xfs: struct xfs_buf_log_format isn't variable sized.
Message-ID: <20120620063612.GB5467@infradead.org>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1339133914-11148-6-git-send-email-david@fromorbit.com>
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

I like this patch with two minor nitpicks below.  Given that it's a mostly
unrelated cleanup I'd also propagate it to the first patch in the
series.

> +	base_size = sizeof(struct xfs_buf_log_format) -
> +		    ((XFS_BLF_DATAMAP_SIZE - bip->bli_format.blf_map_size) *
> +								sizeof(uint));

I'd really move this calculation and the comment describing it into a
macro/inline in the header, next to the defintion of struct xfs_buf_log_format.

Also I'd probably rewrite the expressions as:

	offsetoff(struct xfs_buf_log_format, blf_map) +
		(blf->blf_map_size * sizeof(blf->blf_data_map[0]));

>  /*
> + * Minimum and maximum blocksize and sectorsize.
> + * The blocksize upper limit is pretty much arbitrary.
> + * The sectorsize upper limit is due to sizeof(sb_sectsize).
> + */
> +#define XFS_MIN_BLOCKSIZE_LOG	9	/* i.e. 512 bytes */
> +#define XFS_MAX_BLOCKSIZE_LOG	16	/* i.e. 65536 bytes */
> +#define XFS_MIN_BLOCKSIZE	(1 << XFS_MIN_BLOCKSIZE_LOG)
> +#define XFS_MAX_BLOCKSIZE	(1 << XFS_MAX_BLOCKSIZE_LOG)
> +#define XFS_MIN_SECTORSIZE_LOG	9	/* i.e. 512 bytes */
> +#define XFS_MAX_SECTORSIZE_LOG	15	/* i.e. 32768 bytes */
> +#define XFS_MIN_SECTORSIZE	(1 << XFS_MIN_SECTORSIZE_LOG)
> +#define XFS_MAX_SECTORSIZE	(1 << XFS_MAX_SECTORSIZE_LOG)

While I agree with the move of these constants, what does it have to do
with this patch?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
