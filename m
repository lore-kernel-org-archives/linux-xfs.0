Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E6A817F5E
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 19:33:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63DD3AC002
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 17:33:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id y3qeVsHvBX67wrAL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 17:32:58 -0700 (PDT)
Date: Thu, 28 Aug 2014 17:32:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/9] xfs: kill xfs_bioerror_relse
Message-ID: <20140829003257.GF17502@infradead.org>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1408084747-4540-7-git-send-email-david@fromorbit.com>
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

> index 96c898e..758c07d 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -324,11 +324,13 @@ xfs_trans_read_buf_map(
>  			 */
>  			if (XFS_FORCED_SHUTDOWN(mp)) {
>  				trace_xfs_bdstrat_shut(bp, _RET_IP_);
> -				xfs_bioerror_relse(bp);
> -			} else {
> -				xfs_buf_iorequest(bp);
> +				bp->b_flags &= ~(XBF_READ | XBF_DONE);
> +				xfs_buf_ioerror(bp, -EIO);
> +				xfs_buf_stale(bp);
> +				return -EIO;
>  			}

This is a large change of behavior as it doesn't hit the error
path after the xfs_buf_iowait anymore.  While I don't think that
that path was entirely correct this version seems to be even less so
by not releasing the buffer reference or forcing the shutdown.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
