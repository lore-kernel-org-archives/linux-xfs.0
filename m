Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2N0HRde057286 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 19:17:33 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D56F014023C8
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 17:20:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	hEXlEsByGn1cihgR for <xfs@oss.sgi.com>;
	Tue, 22 Mar 2011 17:20:26 -0700 (PDT)
Date: Wed, 23 Mar 2011 11:20:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: allow reusing busy extents where safe
Message-ID: <20110323002024.GF15270@dastard>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.837735220@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110322200137.837735220@bombadil.infradead.org>
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

On Tue, Mar 22, 2011 at 03:55:54PM -0400, Christoph Hellwig wrote:
> Allow reusing any busy extent for metadata allocations, and reusing busy
> userdata extents for userdata allocations.  Most of the complexity is
> propagating the userdata information from the XFS_BMAPI_METADATA flag
> to xfs_bunmapi into the low-level extent freeing routines.  After that
> we can just track what type of busy extent we have and treat it accordingly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....

> @@ -2717,7 +2723,7 @@ restart:
>  
>  		overlap = xfs_alloc_busy_try_reuse(pag, busyp,
>  						   fbno, fbno + flen);
> -		if (overlap) {
> +		if (overlap == -1 || (overlap && userdata)) {
>  			spin_unlock(&pag->pagb_lock);
>  			xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
>  			goto restart;

Ok, so the only time we'll do a log force now is on an complete
overlap or a partial userdata overlap?

> @@ -2754,6 +2760,7 @@ xfs_alloc_busy_trim(
>  
>  	ASSERT(flen > 0);
>  
> +restart:
>  	spin_lock(&args->pag->pagb_lock);
>  	rbp = args->pag->pagb_tree.rb_node;
>  	while (rbp && flen >= args->minlen) {
> @@ -2771,6 +2778,31 @@ xfs_alloc_busy_trim(
>  			continue;
>  		}
>  
> +		if (!args->userdata ||
> +		    (busyp->flags & XFS_ALLOC_BUSY_USERDATA)) {
> +			int overlap;
> +
> +			overlap = xfs_alloc_busy_try_reuse(args->pag, busyp,
> +							   fbno, fbno + flen);
> +			if (unlikely(overlap == -1)) {
> +				spin_unlock(&args->pag->pagb_lock);
> +				xfs_log_force(args->mp, XFS_LOG_SYNC);
> +				goto restart;
> +			}

Hmmmm - I'm not so sure we can reuse overlapped data extents for
data allocations without a log force at all as there is no guarantee
that the data will not be overwritten before the original free
transaction is on disk.

That is, recovery may not replay the original data extent free
transaction or the new allocation transaction, but there is nothing
stopping us from having written the new data into the extent before
the crash occurred, especially as delayed allocation places the
allocation very close the data IO issue. e.g.:

	thread X		thread Y
	free data extent ABC
				allocate data extent BCD
				partial overlap, no log force
				issue data IO
				.....

		 <crash>

That leads to corruption of the data in the original file because
neither transaction is written to disk, but new data is....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
