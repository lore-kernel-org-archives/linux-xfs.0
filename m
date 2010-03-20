Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2KGmWqe062555 for <xfs@oss.sgi.com>; Sat, 20 Mar 2010 11:48:32 -0500
Date: Sat, 20 Mar 2010 12:50:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/7] xfs: nothing special about 1-block log sector
Message-ID: <20100320165011.GE31444@infradead.org>
References: <201003182254.o2IMsBck001887@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201003182254.o2IMsBck001887@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

> +	/*
> +	 * We do log I/O in units of log sectors (a power-of-2
> +	 * multiple of the basic block size), so we round up the
> +	 * requested size to acommodate the basic blocks required
> +	 * for complete log sectors.
> +	 *
> +	 * In addition, the buffer may be used for a non-sector-
> +	 * aligned block offset, in which case an I/O of the
> +	 * requested size could extend beyond the end of the
> +	 * buffer.  If the requested size is only 1 basic block it
> +	 * will never straddle a sector boundary, so this won't be
> +	 * an issue.  Nor will this be a problem if the log I/O is
> +	 * done in basic blocks (sector size 1).  But otherwise we
> +	 * extend the buffer by one extra log sector to ensure
> +	 * there's space to accomodate this possiblility.
> +	 */


Ah, you're adding the comment that I asked a few patches ago here,
great!

The patch looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
