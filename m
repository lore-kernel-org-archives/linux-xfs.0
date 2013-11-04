Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B74C57F51
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 03:16:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4A5F8AC001
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 01:16:44 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id YKLSyyx3LQeb9kiM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Nov 2013 01:16:43 -0800 (PST)
Date: Mon, 4 Nov 2013 01:16:43 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 27/30] libxfs: work around do_div() not handling 32 bit
	numerators
Message-ID: <20131104091643.GG23564@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-28-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383107481-28937-28-git-send-email-david@fromorbit.com>
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

On Wed, Oct 30, 2013 at 03:31:18PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The libxfs dquot buffer code uses do_div() with a 32 bit numerator.
> This gives incorrect results as do_div() passes the numerator by
> reference as a pointer to a 64 bit value. Hence it does the division
> using 32 bits of garbage gives the wrong result. The kernel code
> handles 32 bit numerators just fine, so this patch is a temporary
> workaround in the dquot buffer code until we fix do_div() to handle
> 32 bit numerators correctly.

The right fix is to simply stop using do_div here, both in kernel and
userspace.

> 
>  xfs_calc_dquots_per_chunk(
>  	struct xfs_mount	*mp,
>  	unsigned int		nbblks)	/* basic block units */
>  {
> -	unsigned int	ndquots;
> +	uint64_t	ndquots;
>  
>  	ASSERT(nbblks > 0);
>  	ndquots = BBTOB(nbblks);
>  	do_div(ndquots, sizeof(xfs_dqblk_t));
>  
> -	return ndquots;
> +	return (int)ndquots;

	ndquots = BBTOB(nbblks) / sizeof(xfs_dqblk_t);


Also the current xfs_calc_dquots_per_chunk doesn't use the mp argument
anyway, but all callers do.  I think in the end we'd want to take that
in from the calers end end up with a version that includes the
check from the quotainfo.  But for getting userspace up and running my
above minimal version should do it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
