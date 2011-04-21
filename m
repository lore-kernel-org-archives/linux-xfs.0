Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LK6CKP172883 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 15:06:12 -0500
Subject: Re: [PATCH 3/4] xfs: exact busy extent tracking
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110418070043.915023373@bombadil.infradead.org>
References: <20110418065936.355024592@bombadil.infradead.org>
	<20110418070043.915023373@bombadil.infradead.org>
Date: Thu, 21 Apr 2011 15:08:20 -0500
Message-ID: <1303416500.2581.519.camel@doink>
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

On Mon, 2011-04-18 at 02:59 -0400, Christoph Hellwig wrote:
> Update the extent tree in case we have to reuse a busy extent, so that it
> always is kept uptodate.  This is done by replacing the busy list searches
> with a new xfs_alloc_busy_reuse helper, which updates the busy extent tree
> in case of a reuse.  This allows us to allow reusing metadata extents
> unconditionally, and thus avoid log forces especially for allocation btree
> blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I think you finally got it Christoph.

I have one question--which I may have mentioned before--but
otherwise this looks good.  I think the iterations have
resulted in a better result.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

In xfs_alloc_busy_trim():
> @@ -2894,6 +2959,11 @@ fail:
>  	 * re-check if the trimmed extent satisfies the minlen requirement.
>  	 */
>  	spin_unlock(&args->pag->pagb_lock);
> +	if (fbno != bno || flen != len) {
> +		trace_xfs_alloc_busy_trim(args->mp, args->agno, bno, len,
> +					  fbno, flen);
> +	}
> +	trace_xfs_alloc_busy_trim(args->mp, args->agno, bno, len, fbno, 0);
>  	*rbno = fbno;
>  	*rlen = 0;
>  }

I don't see why you do two trace calls here, the second
with 0 for the value of flen.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
