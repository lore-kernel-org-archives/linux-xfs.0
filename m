Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2DH5tV2037864 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 12:05:55 -0500
Date: Tue, 13 Mar 2012 12:06:02 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3/5] xfs: use per-filesystem radix trees for dquot lookup
Message-ID: <20120313170602.GH7762@sgi.com>
References: <20120313085232.134690907@bombadil.infradead.org>
	<20120313085308.824843587@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120313085308.824843587@bombadil.infradead.org>
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

On Tue, Mar 13, 2012 at 04:52:35AM -0400, Christoph Hellwig wrote:
> Replace the global hash tables for looking up in-memory dquot structures
> with per-filesystem radix trees to allow scaling to a large number of
> in-memory dquot structures.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

...

> @@ -780,51 +712,27 @@ restart:
>  		}
>  	}
>  
> -	/*
> -	 * Hashlock comes after ilock in lock order
> -	 */
> -	mutex_lock(&h->qh_lock);
> -	if (version != h->qh_version) {
> -		xfs_dquot_t *tmpdqp;
> +	mutex_lock(&qi->qi_tree_lock);
> +	error = -radix_tree_insert(tree, id, dqp);
> +	if (unlikely(error)) {
> +		WARN_ON(error != EEXIST);

Yeah, radix_tree_insert can return ENOMEM.

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
