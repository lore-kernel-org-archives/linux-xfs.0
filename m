Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6K7cXtQ007414 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 02:38:33 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA37045ABEC
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 00:41:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	IAOOnC1ZkEA5eMzW for <xfs@oss.sgi.com>;
	Tue, 20 Jul 2010 00:41:32 -0700 (PDT)
Date: Tue, 20 Jul 2010 17:41:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: kill the b_strat callback in xfs_buf
Message-ID: <20100720074129.GI32635@dastard>
References: <20100718203848.927859114@bombadil.infradead.org>
	<20100718203926.427127966@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100718203926.427127966@bombadil.infradead.org>
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

On Sun, Jul 18, 2010 at 04:38:52PM -0400, Christoph Hellwig wrote:
> The b_strat callback is used by xfs_buf_iostrategy to perform additional
> checks before submitting a buffer.  It is used in xfs_bwrite and when
> writing out delayed buffers.  In xfs_bwrite it we can de-virtualize the
> call easily as b_strat is set a few lines above the call to
> xfs_buf_iostrategy.  For the delayed buffers the rationale is a bit
> more complicated:
> 
>  - there are three callers of xfs_buf_delwri_queue, which places buffers
>    on the delwri list:
>     (1) xfs_bdwrite - this sets up b_strat, so it's fine
>     (2) xfs_buf_iorequest.  None of the callers can have XBF_DELWRI set:
> 	- xlog_bdstrat is only used for log buffers, which are never delwri
> 	- _xfs_buf_read explicitly clears the delwri flag
> 	- xfs_buf_iodone_work retries log buffers only
> 	- xfsbdstrat - only used for reads, superblock writes without the
> 	  delwri flag, log I/O and file zeroing with explicitly allocated
> 	  buffers.
> 	- xfs_buf_iostrategy - only calls xfs_buf_iorequest if b_strat is
> 	  not set
>     (3) xfs_buf_unlock
> 	- only puts the buffer on the delwri list if the DELWRI flag is
> 	  already set.  The DELWRI flag is only ever set in xfs_bwrite,
> 	  xfs_buf_iodone_callbacks, or xfs_trans_log_buf.  For
> 	  xfs_buf_iodone_callbacks and xfs_trans_log_buf we require
> 	  an initialized buf item, which means b_strat was set to
> 	  xfs_bdstrat_cb in xfs_buf_item_init.
> 
> Conclusion: we can just get rid of the callback and replace it with
> explicit calls to xfs_bdstrat_cb.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

looks good.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
