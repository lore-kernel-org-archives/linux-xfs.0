Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8KMGeWw238776 for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 17:16:41 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C36678ADCD
	for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 15:17:33 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id FlaYSdVfc6DWvELr
	for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 15:17:33 -0700 (PDT)
Received: by vws15 with SMTP id 15so4084697vws.26
	for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 15:17:33 -0700 (PDT)
Date: Mon, 20 Sep 2010 17:17:26 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: Re: Latencies writing to memory mapped files
Message-ID: <20100920221726.GA3182@BohrerMBP.rgmadvisors.com>
References: <20100915152633.GA2585@BohrerMBP.rgmadvisors.com>
	<20100916001837.GF24409@dastard>
	<20100917154523.GA2739@BohrerMBP.rgmadvisors.com>
	<20100920000535.GM24409@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100920000535.GM24409@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Thanks Dave for your explanations.

On Mon, Sep 20, 2010 at 10:05:35AM +1000, Dave Chinner wrote:
> FWIW, if you can work out the magic necessary (perhaps systemtap) it
> woul dbe really interesting to know whether it is the same buffer
> that is causing the latency every time (i.e. get the bp->b_bn field
> from the metadata buffer). With the block number, we can use xfs_db
> to dig out what the buffer actually is....

I'm working on a dev box right now so I just added a trace_printk() to
print out the bp->b_bn field when the xfs_buf_lock blocks for more
than 300ms.  Here are some numbers (I can easily get a lot more):

_xfs_buf_find: xfs_buf_lock blocked for 1843ms on bp->b_bn: 812730376
_xfs_buf_find: xfs_buf_lock blocked for 1504ms on bp->b_bn: 406702514
_xfs_buf_find: xfs_buf_lock blocked for 307ms on bp->b_bn: 881190896
_xfs_buf_find: xfs_buf_lock blocked for 433ms on bp->b_bn: 406703400
_xfs_buf_find: xfs_buf_lock blocked for 420ms on bp->b_bn: 541595968
_xfs_buf_find: xfs_buf_lock blocked for 308ms on bp->b_bn: 44945968
_xfs_buf_find: xfs_buf_lock blocked for 702ms on bp->b_bn: 406027744
_xfs_buf_find: xfs_buf_lock blocked for 454ms on bp->b_bn: 474486504
_xfs_buf_find: xfs_buf_lock blocked for 869ms on bp->b_bn: 881195976
_xfs_buf_find: xfs_buf_lock blocked for 387ms on bp->b_bn: 1287891544
_xfs_buf_find: xfs_buf_lock blocked for 397ms on bp->b_bn: 1220116224
_xfs_buf_find: xfs_buf_lock blocked for 461ms on bp->b_bn: 2101644280
_xfs_buf_find: xfs_buf_lock blocked for 312ms on bp->b_bn: 338919728
_xfs_buf_find: xfs_buf_lock blocked for 356ms on bp->b_bn: 1016769536
_xfs_buf_find: xfs_buf_lock blocked for 593ms on bp->b_bn: 474488848
_xfs_buf_find: xfs_buf_lock blocked for 323ms on bp->b_bn: 1022248984

I should say that not every one of these results in a stall in my
application, since my app needs to generate a page fault while that
lock is held.

What do I need to do to convert the block numbers to a buffer?

Thanks,
Shawn

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
