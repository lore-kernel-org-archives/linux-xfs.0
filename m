Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3ILBWgx234943 for <xfs@oss.sgi.com>; Wed, 18 Apr 2012 16:11:32 -0500
Message-ID: <4F8F2E00.20000@sgi.com>
Date: Wed, 18 Apr 2012 16:11:28 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 08/10] xfs: do not add buffers to the delwri queue until
	pushed
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164646.539031348@bombadil.infradead.org>
In-Reply-To: <20120327164646.539031348@bombadil.infradead.org>
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
> Instead of adding buffers to the delwri list as soon as they are logged,
> even if they can't be written until commited because they are pinned
> defer adding them to the delwri list until xfsaild pushes them.  This
> makes the code more similar to other log items and prepares for writing
> buffers directly from xfsaild.
>
> The complication here is that we need to fail buffers that were added
> but not logged yet in xfs_buf_item_unpin, borrowing code from
> xfs_bioerror.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
