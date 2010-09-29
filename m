Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8TNIDnC097997 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 18:18:14 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2FF07B3FD6
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 16:19:11 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	Umxv9ywdFAWL9y7s for <xfs@oss.sgi.com>;
	Wed, 29 Sep 2010 16:19:11 -0700 (PDT)
Date: Thu, 30 Sep 2010 09:19:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Latencies writing to memory mapped files
Message-ID: <20100929231908.GQ5665@dastard>
References: <20100915152633.GA2585@BohrerMBP.rgmadvisors.com>
	<20100916001837.GF24409@dastard>
	<20100917154523.GA2739@BohrerMBP.rgmadvisors.com>
	<20100920000535.GM24409@dastard>
	<20100920221726.GA3182@BohrerMBP.rgmadvisors.com>
	<20100920224833.GB2614@dastard>
	<20100921180541.GA6877@BohrerMBP.rgmadvisors.com>
	<20100921231531.GE2614@dastard>
	<20100929153122.GA6707@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100929153122.GA6707@BohrerMBP.rgmadvisors.com>
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
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 29, 2010 at 10:31:22AM -0500, Shawn Bohrer wrote:
> On Wed, Sep 22, 2010 at 09:15:31AM +1000, Dave Chinner wrote:
> > On Tue, Sep 21, 2010 at 01:05:41PM -0500, Shawn Bohrer wrote:
> > > So I have no idea what I'm looking at but here is the output for the
> > > above numbers (duplicates removed):
> > > 
> > > xfs_db -r -c "daddr 474487328" -c "print" /dev/sda5
> > > 000: 424d4150 0000007f 00000000 07000082 00000000 07000092 00000000 0039a000
> >        ^^^^^^^^
> >         B M A P
> > 
> > #define XFS_BMAP_MAGIC  0x424d4150      /* 'BMAP' */
> > 
> > So these are inode extent btree blocks your application is getting
> > stuck on.  These only get written back as a result of either log
> > pressure (i.e.  tail pushing) or by the xfsbufd based on age. They
> > aren't actually flushed with the data because changes are logged.
> > IOWs, the writeback of the bmap btree blocks is asynchronous to any
> > operation that modifies them, so there's no direct connection
> > between modification and writeback.
> > 
> > I'm not sure that there is anything that can really be done to
> > prevent this. If the cause of writeback is age-based flushing on the
> > metadata buffers, you could try increasing the xfsbufd writeback age
> > so that only log pressure will cause them to be flushed.
> 
> So setting fs.xfs.age_buffer_centisecs to 720000 does seem to help,
> but what are the consequences (if any) of doing this?

It means that metadata will stay active in the log for longer. That
means it is likely that recovery will take longer if your system
crashes. It also means that there may be more latency on transaction
reservation as tail-pushing the log is much more likely to occur
because metadata is not being pushed out by background flushing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
