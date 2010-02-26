Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1QHukgZ199093 for <xfs@oss.sgi.com>; Fri, 26 Feb 2010 11:56:46 -0600
Subject: Re: [PATCH V2] xfs: Non-blocking inode locking in IO completion
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100225230628.GB18369@discord.disaster>
References: <1266384989-28928-1-git-send-email-david@fromorbit.com>
	<20100217192938.GA14015@infradead.org>
	<20100217211312.GQ28392@discord.disaster>
	<20100218123512.GA6016@infradead.org>
	<20100225230628.GB18369@discord.disaster>
Date: Fri, 26 Feb 2010 11:58:06 -0600
Message-ID: <1267207086.2756.7.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, 2010-02-26 at 10:06 +1100, Dave Chinner wrote:
> On Thu, Feb 18, 2010 at 07:35:13AM -0500, Christoph Hellwig wrote:
> > On Thu, Feb 18, 2010 at 08:13:12AM +1100, Dave Chinner wrote:
> > > > The patch looks good to me - while I hate introducing random delay()
> > > > calls I don't really see a way around this. 
> > > 
> > > I thought about using queue_delayed_work(), but then the change
> > > became much bigger and has other side effects like increasing the
> > > size of the ioend structure.
> > 
> > Yes, now that the normal work struct and the delayed work struct are
> > different it would be a pain, agreed.
> 
> Version with updated commit message below.

This looks good and I'll be incorporating this version.
Thanks for updating it.

					-Alex

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: Non-blocking inode locking in IO completion
> 
> The introduction of barriers to loop devices has created a new IO
> order completion dependency that XFS does not handle. The loop
> device implements barriers using fsync and so turns a log IO in the
> XFS filesystem on the loop device into a data IO in the backing
> filesystem. That is, the completion of log IOs in the loop
> filesystem are now dependent on completion of data IO in the backing
> filesystem.
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
