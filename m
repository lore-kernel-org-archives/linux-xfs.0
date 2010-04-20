Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3K6e0sR011005 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 01:40:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B13D2D6E4E
	for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 23:41:58 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	zFkER6I6Mre9BGNn for <xfs@oss.sgi.com>;
	Mon, 19 Apr 2010 23:41:58 -0700 (PDT)
Date: Tue, 20 Apr 2010 16:41:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] [PATCH] xfs: simplify buffer to transaction matching
Message-ID: <20100420064155.GH15130@dastard>
References: <20100418001041.865247520@bombadil.infradead.org>
	<20100418001058.677429475@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100418001058.677429475@bombadil.infradead.org>
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

On Sat, Apr 17, 2010 at 08:10:45PM -0400, Christoph Hellwig wrote:
> We currenly have a routine xfs_trans_buf_item_match_all which checks if any
> log item in a transaction contains a given buffer, and a second one that
> only does this check for the first, embedded chunk of log items.  We only
> use the second routine if we know we only have that log item chunk, so get
> rid of the limited routine and always use the more complete one.
> 
> Also rename the old xfs_trans_buf_item_match_all to xfs_trans_buf_item_match
> and update various surrounding comments, and move the remaining
> xfs_trans_buf_item_match on top of the file to avoid a forward prototype.

Good start, but I think that it should use xfs_trans_first_item()
and xfs_trans_next_item() rather than walking the descriptor
table directly.

i.e:

	len = BBTOB(len);
	lidp = xfs_trans_first_item(tp);
	while (lidp != NULL) {
		blip = (xfs_buf_log_item_t *)lidp->lid_item;
		lidp = xfs_trans_next_item(tp, lidp);

		if (blip->bli_item.li_type != XFS_LI_BUF)
			continue;

		if (XFS_BUF_TARGET(blip->bli_buf) == target &&
		    XFS_BUF_ADDR(blip->bli_buf) == blkno &&
		    XFS_BUF_COUNT(blip->bli_buf) == len)
			return blip->bli_buf;
	}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
