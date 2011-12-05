Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB541OZ7109480 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 22:01:24 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58D8E29A10E
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 20:01:20 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	QIMmcVEGOmF20sgn for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 20:01:20 -0800 (PST)
Date: Mon, 5 Dec 2011 14:59:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/16] xfs: make sure to really flush all dquots in
	xfs_qm_quotacheck
Message-ID: <20111205035926.GI7046@dastard>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082836.509334391@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128082836.509334391@bombadil.infradead.org>
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

On Mon, Nov 28, 2011 at 03:27:24AM -0500, Christoph Hellwig wrote:
> Make sure we do not skip any dquots when flushing them out after a
> quotacheck to make sure that we will never have any dirty dquots on a life
                                                                        live
> filesystem.  At this point no dquot should be pinnable, but lets be anal
                                                                      pedantic
> about it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_qm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: xfs/fs/xfs/xfs_qm.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qm.c	2011-11-25 11:45:32.672075575 +0100
> +++ xfs/fs/xfs/xfs_qm.c	2011-11-25 11:45:35.875391556 +0100
> @@ -1661,7 +1661,7 @@ xfs_qm_quotacheck(
>  	 * successfully.
>  	 */
>  	if (!error)
> -		error = xfs_qm_dqflush_all(mp, SYNC_TRYLOCK);
> +		error = xfs_qm_dqflush_all(mp, 0);
>  
>  	/*
>  	 * We can get this error if we couldn't do a dquot allocation inside

We definitely should flush everything here, so looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
