Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GJPEkD240066 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 14:25:14 -0500
Message-ID: <4F8C7217.60802@sgi.com>
Date: Mon, 16 Apr 2012 14:25:11 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 05/10] xfs: do flush inodes from background inode reclaim
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164645.389070852@bombadil.infradead.org>
In-Reply-To: <20120327164645.389070852@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 03/27/12 11:44, Christoph Hellwig wrote:
> We already flush dirty inodes throug the AIL regularly, there is no reason
> to have second thread compete with it and disturb the I/O pattern.  We still
> do write inodes when doing a synchronous reclaim from the shrinker or during
> unmount for now.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
> ---

> -	 */
> -	return 0;
> +	xfs_iflock(ip);
>
>   reclaim:
>   	xfs_ifunlock(ip);

Is this flush lock / flush unlock cycle needed?

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
