Return-Path: <SRS0=5eVt=3I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67941C33CAF
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 21:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4420A206B7
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 21:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgASV51 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Jan 2020 16:57:27 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38671 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727556AbgASV51 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Jan 2020 16:57:27 -0500
Received: from dread.disaster.area (pa49-181-172-170.pa.nsw.optusnet.com.au [49.181.172.170])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 33F283A40FB;
        Mon, 20 Jan 2020 08:57:22 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1itIZM-0007iM-Ed; Mon, 20 Jan 2020 08:57:20 +1100
Date:   Mon, 20 Jan 2020 08:57:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/11] xfs: make xfs_buf_read return an error code
Message-ID: <20200119215720.GE9407@dread.disaster.area>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
 <157924222437.3029431.18011964422343623236.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157924222437.3029431.18011964422343623236.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=IIEU8dkfCNxGYurWsojP/w==:117 a=IIEU8dkfCNxGYurWsojP/w==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=kBlyB6xKQpS5Cqe0RHYA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 10:23:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert xfs_buf_read() to return numeric error codes like most
> everywhere else in xfs.  Hoist the callers' error logging and EFSBADCRC
> remapping code into xfs_buf_read to reduce code duplication.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c |   16 +++-------------
>  fs/xfs/xfs_buf.c                |   33 +++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_buf.h                |   14 +++-----------
>  fs/xfs/xfs_log_recover.c        |   26 +++++++-------------------
>  fs/xfs/xfs_symlink.c            |   17 ++++-------------
>  5 files changed, 50 insertions(+), 56 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index a266d05df146..46c516809086 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -418,20 +418,10 @@ xfs_attr_rmtval_get(
>  			       (map[i].br_startblock != HOLESTARTBLOCK));
>  			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
>  			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
> -			bp = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt, 0,
> -					&xfs_attr3_rmt_buf_ops);
> -			if (!bp)
> -				return -ENOMEM;
> -			error = bp->b_error;
> -			if (error) {
> -				xfs_buf_ioerror_alert(bp, __func__);
> -				xfs_buf_relse(bp);
> -
> -				/* bad CRC means corrupted metadata */
> -				if (error == -EFSBADCRC)
> -					error = -EFSCORRUPTED;
> +			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
> +					0, &bp, &xfs_attr3_rmt_buf_ops);
> +			if (error)
>  				return error;
> -			}
>  
>  			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
>  							&offset, &valuelen,
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a00e63d08a3b..8c9cd1ab870b 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -851,6 +851,39 @@ xfs_buf_read_map(
>  	return bp;
>  }
>  
> +int
> +xfs_buf_read(
> +	struct xfs_buftarg	*target,
> +	xfs_daddr_t		blkno,
> +	size_t			numblks,
> +	xfs_buf_flags_t		flags,
> +	struct xfs_buf		**bpp,
> +	const struct xfs_buf_ops *ops)
> +{
> +	struct xfs_buf		*bp;
> +	int			error;
> +	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +
> +	*bpp = NULL;
> +	bp = xfs_buf_read_map(target, &map, 1, flags, ops);
> +	if (!bp)
> +		return -ENOMEM;
> +	error = bp->b_error;
> +	if (error) {
> +		xfs_buf_ioerror_alert(bp, __func__);
> +		xfs_buf_stale(bp);
> +		xfs_buf_relse(bp);
> +
> +		/* bad CRC means corrupted metadata */
> +		if (error == -EFSBADCRC)
> +			error = -EFSCORRUPTED;
> +		return error;
> +	}
> +
> +	*bpp = bp;
> +	return 0;
> +}

I'd just put all this in xfs_buf_read_map() and leave
xfs_buf_read() as a simple wrapper around xfs_buf_read_map().

Also:

	if (!bp->b_error) {
		*bpp = bp;
		return 0;
	}
	/* handle error without extra indenting */


> -	const struct xfs_buf_ops *ops)
> -{
> -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> -	return xfs_buf_read_map(target, &map, 1, flags, ops);
> -}
> +int xfs_buf_read(struct xfs_buftarg *target, xfs_daddr_t blkno, size_t numblks,
> +		xfs_buf_flags_t flags, struct xfs_buf **bpp,
> +		const struct xfs_buf_ops *ops);
>  
>  static inline void
>  xfs_buf_readahead(
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 0d683fb96396..ac79537d3275 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2745,15 +2745,10 @@ xlog_recover_buffer_pass2(
>  	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
>  		buf_flags |= XBF_UNMAPPED;
>  
> -	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
> -			  buf_flags, NULL);
> -	if (!bp)
> -		return -ENOMEM;
> -	error = bp->b_error;
> -	if (error) {
> -		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#1)");
> -		goto out_release;
> -	}
> +	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
> +			  buf_flags, &bp, NULL);
> +	if (error)
> +		return error;

I'd argue that if we are touching every remaining xfs_buf_read() call
like this, we should get rid of it and just call xfs_buf_read_map()
instead.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
