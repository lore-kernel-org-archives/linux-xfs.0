Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBV0BN9c053641 for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 18:11:24 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6B1AF92310
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 16:13:26 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	BRpcVFuDcSoAnoOK for <xfs@oss.sgi.com>;
	Thu, 30 Dec 2010 16:13:26 -0800 (PST)
Date: Fri, 31 Dec 2010 11:13:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfssyncd and disk spin down
Message-ID: <20101231001323.GD15179@dastard>
References: <20101223165532.GA23813@peter.simplex.ro>
	<20101227021904.GA24828@dastard>
	<20101227061629.GA2275@pandora.simplex.ro>
	<20101227140750.GB24828@dastard>
	<20101227171939.GA7759@pandora.simplex.ro>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101227171939.GA7759@pandora.simplex.ro>
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
To: Petre Rodan <petre.rodan@simplex.ro>
Cc: xfs@oss.sgi.com

On Mon, Dec 27, 2010 at 07:19:39PM +0200, Petre Rodan wrote:
> 
> Hello Dave,
> 
> On Tue, Dec 28, 2010 at 01:07:50AM +1100, Dave Chinner wrote:
> > Turn on the XFS tracing so we can see what is being written every
> > 36s.  When the problem shows up:
> > 
> > # echo 1 > /sys/kernel/debug/tracing/events/xfs/enable
> > # sleep 100
> > # cat /sys/kernel/debug/tracing/trace > trace.out
> > # echo 0 > /sys/kernel/debug/tracing/events/xfs/enable
> > 
> > And post the trace.out file for us to look at.
> 
> attached.
> 
> you can disregard all the lvm partitions ('dev 254:.*') since they are on a different drive, probably only 8:17 is of interest.

Ok, I can see the problem. The original patch I tested:

http://oss.sgi.com/archives/xfs/2010-08/msg00026.html

Made the log covering dummy transaction a synchronous transaction so
that the log was written and the superblock unpinned immediately to
allow the xfsbufd to write back the superblock and empty the AIL
before the next log covering check.

On review, the log covering dummy transaction got changed to an
async transaction, so the superblock buffer is not unpinned
immediately. This was the patch committed:

http://oss.sgi.com/archives/xfs/2010-08/msg00197.html

As a result, the success of log covering and idling is then
dependent on whether the log gets written to disk to unpin the
superblock buffer before the next xfssyncd run. It seems that there
is a large chance that this log write does not happen, so the
filesystem never idles correctly. I've reproduced it here, and only
in one test out of ten did the filesystem enter an idle state
correctly. I guess I was unlucky enough to hit that 1-in-10 case
when I tested the modified patch.

I'll cook up a patch to make the log covering behave like the
original patch I sent...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
