Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2KGkPDc062360 for <xfs@oss.sgi.com>; Sat, 20 Mar 2010 11:46:25 -0500
Date: Sat, 20 Mar 2010 12:48:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] xfs: kill XLOG_SECTOR_ROUND*()
Message-ID: <20100320164804.GD31444@infradead.org>
References: <201003182254.o2IMs1jH001874@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201003182254.o2IMs1jH001874@stout.americas.sgi.com>
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

> @@ -82,8 +77,8 @@ xlog_get_bp(
>  
>  	if (log->l_sectbb_log) {
>  		if (nbblks > 1)
> -			nbblks += XLOG_SECTOR_ROUNDUP_BBCOUNT(log, 1);
> -		nbblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, nbblks);
> +			nbblks += xlog_sectbb(log);
> +		nbblks = round_up(nbblks, xlog_sectbb(log));

This arithmetics would benefit greatly from a comment why we're
adding one log block to it and then round it up.

Anyway, patch looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
