Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BLkXqL244452 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 16:46:33 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	U6qgC05TpQTe3p1c (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 14:48:05 -0700 (PDT)
Date: Thu, 11 Oct 2012 17:48:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/19] xfs: verify dquot blocks as they are read from disk
Message-ID: <20121011214805.GI6346@infradead.org>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
	<1349754670-32009-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349754670-32009-11-git-send-email-david@fromorbit.com>
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

On Tue, Oct 09, 2012 at 02:51:01PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add a dquot buffer verify callback function and pass it into the
> buffer read functions. This checks all the dquots in a buffer, but
> cannot completely verify the dquot ids are correct. Also, errors
> cannot be repaired, so an additional function is added to repair bad
> dquots in the buffer if such an error is detected in a context where
> repair is allowed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

But after the first half dozen of callback I have a question:

> +		if (error) {
> +			XFS_CORRUPTION_ERROR("xfs_dquot_read_verify",
> +					     XFS_ERRLEVEL_LOW, mp, d);
> +			xfs_buf_ioerror(bp, EFSCORRUPTED);
> +			break;
> +		}
> +	}
> +	bp->b_iodone = NULL;
> +	xfs_buf_ioend(bp, 0);

It seems we always call xfs_buf_ioerror on errors, and then always
do a

	bp->b_iodone = NULL;
	xfs_buf_ioend(bp, 0);

for each callback.  What is the reason we can't take these two into the
core buffer cache code?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
