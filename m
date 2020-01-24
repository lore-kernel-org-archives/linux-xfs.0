Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06526C35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 01:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDF8821835
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 01:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgAXBbz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 20:31:55 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55363 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728799AbgAXBbz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 20:31:55 -0500
Received: from dread.disaster.area (pa49-195-162-125.pa.nsw.optusnet.com.au [49.195.162.125])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 49E483A1CAE;
        Fri, 24 Jan 2020 12:31:53 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iunpA-0000LJ-9t; Fri, 24 Jan 2020 12:31:52 +1100
Date:   Fri, 24 Jan 2020 12:31:52 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 05/12] xfs: make xfs_buf_read_map return an error code
Message-ID: <20200124013152.GF7090@dread.disaster.area>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
 <157976534245.2388944.13378396804109422541.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157976534245.2388944.13378396804109422541.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=eqEhQ2W7mF93FbYHClaXRw==:117 a=eqEhQ2W7mF93FbYHClaXRw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=OOWA6nE7O7ehtneT30MA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 22, 2020 at 11:42:22PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert xfs_buf_read_map() to return numeric error codes like most
> everywhere else in xfs.  This involves moving the open-coded logic that
> reports metadata IO read / corruption errors and stales the buffer into
> xfs_buf_read_map so that the logic is all in one place.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....

> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index b5b3a78ef31c..56e7f8126cd7 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -298,36 +298,17 @@ xfs_trans_read_buf_map(
>  		return 0;
>  	}
>  
> -	bp = xfs_buf_read_map(target, map, nmaps, flags, ops);
> -	if (!bp) {
> -		if (!(flags & XBF_TRYLOCK))
> -			return -ENOMEM;
> -		return tp ? 0 : -EAGAIN;
> -	}
> -
> -	/*
> -	 * If we've had a read error, then the contents of the buffer are
> -	 * invalid and should not be used. To ensure that a followup read tries
> -	 * to pull the buffer from disk again, we clear the XBF_DONE flag and
> -	 * mark the buffer stale. This ensures that anyone who has a current
> -	 * reference to the buffer will interpret it's contents correctly and
> -	 * future cache lookups will also treat it as an empty, uninitialised
> -	 * buffer.
> -	 */
> -	if (bp->b_error) {
> -		error = bp->b_error;
> -		if (!XFS_FORCED_SHUTDOWN(mp))
> -			xfs_buf_ioerror_alert(bp, __func__);
> -		bp->b_flags &= ~XBF_DONE;
> -		xfs_buf_stale(bp);
> -
> +	error = xfs_buf_read_map(target, map, nmaps, flags, &bp, ops);
> +	switch (error) {
> +	case 0:
> +		break;
> +	case -EFSCORRUPTED:
> +	case -EIO:
>  		if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
> -			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
> -		xfs_buf_relse(bp);
> -
> -		/* bad CRC means corrupted metadata */
> -		if (error == -EFSBADCRC)
> -			error = -EFSCORRUPTED;
> +			xfs_force_shutdown(tp->t_mountp,
> +					SHUTDOWN_META_IO_ERROR);
> +		/* fall through */
> +	default:
>  		return error;
>  	}

Same question as Christoph - we're only trying to avoid ENOMEM and
EAGAIN errors from shutting down the filesystem here, right?
Every other type of IO error that could end up on bp->b_error would
result in a shutdown, so perhaps this should be the other way
around:

	switch (error) {
	case 0:
		break;
	default:
		/* shutdown stuff */
		/* fall through */
	case -ENOMEM:
	case -EAGAIN:
		return error;
	}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
