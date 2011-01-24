Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0O9ARid074197 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 03:10:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 367C428A985
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 01:12:50 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id c0NB8WMgq0F4kky4 for
	<xfs@oss.sgi.com>; Mon, 24 Jan 2011 01:12:50 -0800 (PST)
Date: Mon, 24 Jan 2011 04:12:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: handle CIl transaction commit failures correctly
Message-ID: <20110124091249.GF26744@infradead.org>
References: <1295411400-15614-1-git-send-email-david@fromorbit.com>
	<1295411400-15614-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1295411400-15614-6-git-send-email-david@fromorbit.com>
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

> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 50753d3..504a804 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1754,15 +1754,26 @@ xfs_trans_commit_cil(
>  	 */
>  	log_vector = xfs_trans_alloc_log_vecs(tp);
>  	if (!log_vector)
> -		return ENOMEM;
> +		goto out_enomem;
>  
>  	error = xfs_log_commit_cil(mp, tp, log_vector, commit_lsn, flags);
> -	if (error)
> -		return error;
> +	if (error) {
> +		/*
> +		 * We will only get an error if no modifications have been
> +		 * made to the items in the transaction. Hence treat it
> +		  the same as a memory allocation failure.
> +		 */
> +		goto out_enomem;
> +	}
>  
>  	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
>  	xfs_trans_free(tp);
>  	return 0;
> +
> +out_enomem:
> +	/* caller cleans up transaction */
> +	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
> +	return ENOMEM;

_xfs_trans_commit already restores the process flags for an ENOMEM
return, so the failure from xfs_trans_alloc_log_vecs is already
handled correctly.  If we want to handle the EIO return from
xfs_log_commit_cil the same way it just needs to be turned into an
ENOMEM.  The big questions is if there's any point in having the
shutdown check in xfs_trans_commit_cil - we already do one just before
applying the trans deltas in _xfs_trans_commit, which is handled
correctly and should be sufficient.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
