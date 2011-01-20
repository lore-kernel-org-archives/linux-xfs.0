Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0KNf07e169966 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 17:41:00 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7579627BAA9
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 15:43:18 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	cNayKVPgxyeTDpOs for <xfs@oss.sgi.com>;
	Thu, 20 Jan 2011 15:43:18 -0800 (PST)
Date: Fri, 21 Jan 2011 10:43:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfssyncd and disk spin down
Message-ID: <20110120234310.GV16267@dastard>
References: <20101223165532.GA23813@peter.simplex.ro>
	<20101227021904.GA24828@dastard>
	<20101227061629.GA2275@pandora.simplex.ro>
	<20101227140750.GB24828@dastard>
	<20101227171939.GA7759@pandora.simplex.ro>
	<20101231001323.GD15179@dastard>
	<20110120100143.GA2007@peter.simplex.ro>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110120100143.GA2007@peter.simplex.ro>
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

On Thu, Jan 20, 2011 at 12:01:43PM +0200, Petre Rodan wrote:
> On Fri, Dec 31, 2010 at 11:13:23AM +1100, Dave Chinner wrote:
> > Ok, I can see the problem. The original patch I tested:
> > 
> > http://oss.sgi.com/archives/xfs/2010-08/msg00026.html
> > 
> > Made the log covering dummy transaction a synchronous transaction so
> > that the log was written and the superblock unpinned immediately to
> > allow the xfsbufd to write back the superblock and empty the AIL
> > before the next log covering check.
> > 
> > On review, the log covering dummy transaction got changed to an
> > async transaction, so the superblock buffer is not unpinned
> > immediately. This was the patch committed:
> > 
> > http://oss.sgi.com/archives/xfs/2010-08/msg00197.html
> > 
> > As a result, the success of log covering and idling is then
> > dependent on whether the log gets written to disk to unpin the
> > superblock buffer before the next xfssyncd run. It seems that there
> > is a large chance that this log write does not happen, so the
> > filesystem never idles correctly. I've reproduced it here, and only
> > in one test out of ten did the filesystem enter an idle state
> > correctly. I guess I was unlucky enough to hit that 1-in-10 case
> > when I tested the modified patch.
> > 
> > I'll cook up a patch to make the log covering behave like the
> > original patch I sent...
> 
> I presume that the new fix should be provided by "xfs: ensure log
> covering transactions are synchronous", so I tested 2.6.37 patched
> with it and then 2.6.38_rc1 that has it included..
.....
> in other words xfsyncd and xfsbufd now alternate at 18s intervals
> keeping the drive busy with nothing constructive hours after the
> last write to the drive.

This is a different problem, and not one I've seen before. Looking
at the traces, it appears that we have not empties the AIL. At
least, that's what I'm assuming at this point because log IO
completion is not updating log tail. When we start a log IO, we set
the log header lsn to the current head:

>    xfssyncd/sdc1-1413  [000]  3356.093456: xfs_log_reserve: dev 8:33 type DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 2 grant_reserve_bytes 428523008 grant_write_cycle 2 grant_write_bytes 428523008 curr_cycle 2 curr_block 836959 tail_cycle 2 tail_block 810683

Which in this case is: curr_cycle 2 curr_block 836959

When the log IO completes, that value gets written to the
l_last_sync_lsn. When the AIL tail is removed, the tail lsn is
updated to the new tail item. If the AIL is empty, then the
l_last_sync_lsn is used. That means then next dummy transaction
made to cover the log should have the cycle/block of the above
current cycle.

Instead, what I see is that the next dummmy transaction shows:

>    xfssyncd/sdc1-1413  [000]  3392.067122: xfs_log_reserve: dev 8:33 type DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 2 grant_reserve_bytes 428524032 grant_write_cycle 2 grant_write_bytes 428524032 curr_cycle 2 curr_block 836961 tail_cycle 2 tail_block 810683

The current head has moved: curr_cycle 2 curr_block 836961

But the tail hasn't: tail_cycle 2 tail_block 810683

So effectively we've got some item on the AIL that we haven't
flushed and isn't being flushed by xfssyncd. That's the problem I
need to get to the bottom of and it also explains why it's an
intermitten problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
