Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8TFUX6o060596 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 10:30:33 -0500
Received: from mail-ew0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5887E14FFB3D
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 08:44:38 -0700 (PDT)
Received: from mail-ew0-f53.google.com (mail-ew0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id uC52umjyDPvEkefI
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 08:44:38 -0700 (PDT)
Received: by ewy3 with SMTP id 3so301928ewy.26
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 08:31:30 -0700 (PDT)
Date: Wed, 29 Sep 2010 10:31:22 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: Re: Latencies writing to memory mapped files
Message-ID: <20100929153122.GA6707@BohrerMBP.rgmadvisors.com>
References: <20100915152633.GA2585@BohrerMBP.rgmadvisors.com>
	<20100916001837.GF24409@dastard>
	<20100917154523.GA2739@BohrerMBP.rgmadvisors.com>
	<20100920000535.GM24409@dastard>
	<20100920221726.GA3182@BohrerMBP.rgmadvisors.com>
	<20100920224833.GB2614@dastard>
	<20100921180541.GA6877@BohrerMBP.rgmadvisors.com>
	<20100921231531.GE2614@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100921231531.GE2614@dastard>
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

On Wed, Sep 22, 2010 at 09:15:31AM +1000, Dave Chinner wrote:
> On Tue, Sep 21, 2010 at 01:05:41PM -0500, Shawn Bohrer wrote:
> > On Tue, Sep 21, 2010 at 08:48:33AM +1000, Dave Chinner wrote:
> > > On Mon, Sep 20, 2010 at 05:17:26PM -0500, Shawn Bohrer wrote:
> > > > On Mon, Sep 20, 2010 at 10:05:35AM +1000, Dave Chinner wrote:
> > > > > FWIW, if you can work out the magic necessary (perhaps systemtap) it
> > > > > woul dbe really interesting to know whether it is the same buffer
> > > > > that is causing the latency every time (i.e. get the bp->b_bn field
> > > > > from the metadata buffer). With the block number, we can use xfs_db
> > > > > to dig out what the buffer actually is....
> .....
> > > Hmmm - it would be good to know which one produced the latency,
> > > given there does not appear to be a pattern in the block numbers.
> > 
> > OK here is a little more information which may be relevant.  I've
> > currently got 12 processes that read data from a socket and each write
> > to a different memory mapped file.  The apps are only appending to the
> > file, but they don't write the data in one sequential chunk so it is
> > quite possible that it appears as random IO for a short time period.
> > 
> > This time I made some more modifications so that I would only capture
> > the bp->b_bn when one of my processes sees a delay of 300ms or greater.
> > There still is a small chance for false positives, but most of these
> > should have caused real delays.  All of the following came from the
> > same process:
> > 
> > [001] 81758.886627: _xfs_buf_find: xfs_buf_lock blocked for 871ms on bp->b_bn: 474487328
> > [001] 81920.808163: _xfs_buf_find: xfs_buf_lock blocked for 1038ms on bp->b_bn: 474487568
> > [001] 82933.428627: _xfs_buf_find: xfs_buf_lock blocked for 767ms on bp->b_bn: 542273864
> > [000] 83048.558413: _xfs_buf_find: xfs_buf_lock blocked for 363ms on bp->b_bn: 474488080
> > [001] 86717.251189: _xfs_buf_find: xfs_buf_lock blocked for 514ms on bp->b_bn: 474487560
> > [001] 88466.635802: _xfs_buf_find: xfs_buf_lock blocked for 380ms on bp->b_bn: 542274544
> > [000] 88972.122062: _xfs_buf_find: xfs_buf_lock blocked for 521ms on bp->b_bn: 474487560
> > [001] 89271.988589: _xfs_buf_find: xfs_buf_lock blocked for 496ms on bp->b_bn: 474487560
> > [001] 91046.566309: _xfs_buf_find: xfs_buf_lock blocked for 540ms on bp->b_bn: 474487560
> > [001] 91047.280042: _xfs_buf_find: xfs_buf_lock blocked for 713ms on bp->b_bn: 542274216
> > [001] 91212.458472: _xfs_buf_find: xfs_buf_lock blocked for 490ms on bp->b_bn: 542274544
> > [001] 92397.667196: _xfs_buf_find: xfs_buf_lock blocked for 549ms on bp->b_bn: 474487560
> > 
> > > > What do I need to do to convert the block numbers to a buffer?
> > > 
> > > # xfs_db -r -c "daddr 812730376" -c "print" <dev>
> > > 
> > > Will dump the sector at that address. That should be enough to tell
> > > us what is in the buffer (by the magic number).
> > 
> > So I have no idea what I'm looking at but here is the output for the
> > above numbers (duplicates removed):
> > 
> > xfs_db -r -c "daddr 474487328" -c "print" /dev/sda5
> > 000: 424d4150 0000007f 00000000 07000082 00000000 07000092 00000000 0039a000
>        ^^^^^^^^
>         B M A P
> 
> #define XFS_BMAP_MAGIC  0x424d4150      /* 'BMAP' */
> 
> So these are inode extent btree blocks your application is getting
> stuck on.  These only get written back as a result of either log
> pressure (i.e.  tail pushing) or by the xfsbufd based on age. They
> aren't actually flushed with the data because changes are logged.
> IOWs, the writeback of the bmap btree blocks is asynchronous to any
> operation that modifies them, so there's no direct connection
> between modification and writeback.
> 
> I'm not sure that there is anything that can really be done to
> prevent this. If the cause of writeback is age-based flushing on the
> metadata buffers, you could try increasing the xfsbufd writeback age
> so that only log pressure will cause them to be flushed.

So setting fs.xfs.age_buffer_centisecs to 720000 does seem to help,
but what are the consequences (if any) of doing this?

> Alternatively, you could change your application to pre-fault pages
> in an async thread so the latency of allocation during the page
> fault is not taken by the main writer...

I've considered this and some other elaborate schemes.  We'll see if I
need to go there.

Thanks,
Shawn

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
