Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p34IIISS179425 for <xfs@oss.sgi.com>; Mon, 4 Apr 2011 13:18:18 -0500
Subject: Re: [PATCH] xfs: fix variable set but not used warnings
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110404125544.GA726@infradead.org>
References: <20110404125544.GA726@infradead.org>
Date: Mon, 04 Apr 2011 13:21:20 -0500
Message-ID: <1301941280.2630.61.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, 2011-04-04 at 08:55 -0400, Christoph Hellwig wrote:
> GCC 4.6 now warnings about variables set but not used.  Fix the trivially
> fixable warnings of this sort.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.  I have an unrelated question though.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: linux-2.6/fs/xfs/quota/xfs_qm_syscalls.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/quota/xfs_qm_syscalls.c	2011-04-03 06:40:45.399789765 -0700
> +++ linux-2.6/fs/xfs/quota/xfs_qm_syscalls.c	2011-04-03 06:43:00.219782939 -0700
> @@ -313,14 +313,12 @@ xfs_qm_scall_quotaon(
>  {
>  	int		error;
>  	uint		qf;
> -	uint		accflags;
>  	__int64_t	sbflags;
>  
>  	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
>  	/*
>  	 * Switching on quota accounting must be done at mount time.
>  	 */
> -	accflags = flags & XFS_ALL_QUOTA_ACCT;
>  	flags &= ~(XFS_ALL_QUOTA_ACCT);

Unrelated, but isn't the effect of this line plus the one a few
lines up the same as this?

	flags &= XFS_ALL_QUOTA_ENFD;

>  
>  	sbflags = 0;

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
