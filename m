Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B26357F5A
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 17:03:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2B32AAC00B
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 15:03:34 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AAxHZHi0pv2NhuGL for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 15:03:31 -0800 (PST)
Date: Fri, 14 Feb 2014 10:02:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: skip verification if initial sb read is wrong
	length
Message-ID: <20140213230226.GM13997@dastard>
References: <52FD3C59.3050400@redhat.com>
 <52FD4B10.2010005@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52FD4B10.2010005@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 13, 2014 at 04:45:36PM -0600, Eric Sandeen wrote:
> @@ -334,7 +341,12 @@ reread:
>  	if (sector_size < sbp->sb_sectsize) {
>  		xfs_buf_relse(bp);
>  		sector_size = sbp->sb_sectsize;
> +		buf_ops = loud ? &xfs_sb_buf_ops : &xfs_sb_quiet_buf_ops;
>  		goto reread;
> +	} else {
> +		/* We guessed right!  Verify it. */
> +		bp->b_ops = &xfs_sb_buf_ops;
> +		bp->b_ops->verify_read(bp);
>  	}

One needs to check bp->b_error after verification ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
