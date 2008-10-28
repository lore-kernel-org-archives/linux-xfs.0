Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 22:09:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S592Yx015854
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 22:09:02 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B177C10EE4A9
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 22:09:00 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Sgz4eysTs8GfOO1b for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 22:09:00 -0700 (PDT)
Date: Tue, 28 Oct 2008 16:08:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] factor out xfs_read_agi helper
Message-ID: <20081028050852.GA17077@disturbed>
References: <20081027133901.GB1109@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133901.GB1109@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:39:01AM -0400, Christoph Hellwig wrote:
> Add a helper to read the AGI header and perform basic verification.
> Based on hunks from a larger patch from Dave Chinner.
> 
> (First sent on Juli 23rd)

Couple of small things.

> @@ -1882,45 +1862,23 @@ xfs_iunlink_remove(
>  	short		bucket_index;
>  	int		offset, last_offset = 0;
>  	int		error;
> -	int		agi_ok;
>  
> -	/*
> -	 * First pull the on-disk inode from the AGI unlinked list.
> -	 */
>  	mp = tp->t_mountp;
> -
>  	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> -	agdaddr = XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp));
>  
>  	/*
>  	 * Get the agi buffer first.  It ensures lock ordering
>  	 * on the list.
>  	 */
> -	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, agdaddr,
> -				   XFS_FSS_TO_BB(mp, 1), 0, &agibp);
> +	error = xfs_read_agi(mp, tp, agno, &agibp);
>  	if (error) {
>  		cmn_err(CE_WARN,
> -			"xfs_iunlink_remove: xfs_trans_read_buf()  returned an error %d on %s.  Returning error.",
> +			"xfs_iunlink_remove: xfs_read_agi() returned an error %d on %s. Returning error.",
>  			error, mp->m_fsname);
>  		return error;
>  	}

Do we need this warning here? xfs_read_agi() will have already
issued an error, right? Also, xfs_fs_cmn_err() is probably better
to use here rather than manually encoding the fsname into the error
message....

> @@ -3295,22 +3297,18 @@ xlog_recover_process_iunlinks(
>  
>  				/*
>  				 * Reacquire the agibuffer and continue around
> -				 * the loop.
> +				 * the loop. This should never fail as we know
> +				 * the buffer was good earlier on.
>  				 */
> -				agibp = xfs_buf_read(mp->m_ddev_targp,
> -						XFS_AG_DADDR(mp, agno,
> -							XFS_AGI_DADDR(mp)),
> -						XFS_FSS_TO_BB(mp, 1), 0);
> -				if (XFS_BUF_ISERROR(agibp)) {
> -					xfs_ioerror_alert(
> -				"xlog_recover_process_iunlinks(#2)",
> -						log->l_mp, agibp,
> -						XFS_AG_DADDR(mp, agno,
> -							XFS_AGI_DADDR(mp)));
> +				error = xfs_read_agi(mp, NULL, agno, &agibp);
> +				ASSERT(error == 0);
> +				if (error) {
> +					xfs_fs_cmn_err(CE_ALERT, mp,
> +					"xlog_recover_process_iunlinks(#2)"
> +					"agi read failed agno %d error %d",
> +							agno, error);

Move the assert into the if (error) branch after the message is
logged so that it is clear the reason for the assert failure.

Otherwise seems fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
