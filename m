Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1AMGKMo159476 for <xfs@oss.sgi.com>; Thu, 10 Feb 2011 16:16:20 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D410F1AAE571
	for <xfs@oss.sgi.com>; Thu, 10 Feb 2011 14:18:54 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kGKEtZIZGDv6PyJt for <xfs@oss.sgi.com>;
	Thu, 10 Feb 2011 14:18:54 -0800 (PST)
Date: Fri, 11 Feb 2011 09:18:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfssyncd and disk spin down
Message-ID: <20110210221851.GG2559@dastard>
References: <20101223165532.GA23813@peter.simplex.ro>
	<20101227021904.GA24828@dastard>
	<20101227061629.GA2275@pandora.simplex.ro>
	<20101227140750.GB24828@dastard>
	<20101227171939.GA7759@pandora.simplex.ro>
	<20101231001323.GD15179@dastard>
	<20110120100143.GA2007@peter.simplex.ro>
	<20110120234310.GV16267@dastard>
	<20110210204254.GA10451@peter.simplex.ro>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110210204254.GA10451@peter.simplex.ro>
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

On Thu, Feb 10, 2011 at 10:42:54PM +0200, Petre Rodan wrote:
> 
> Hello Dave,
> 
> On Fri, Jan 21, 2011 at 10:43:10AM +1100, Dave Chinner wrote:
> > .....
> > > in other words xfsyncd and xfsbufd now alternate at 18s intervals
> > > keeping the drive busy with nothing constructive hours after the
> > > last write to the drive.
> > 
> > This is a different problem, and not one I've seen before. Looking
> > at the traces, it appears that we have not empties the AIL. At
> > least, that's what I'm assuming at this point because log IO
> > completion is not updating log tail. When we start a log IO, we set
> > the log header lsn to the current head:
> > 
> > >    xfssyncd/sdc1-1413  [000]  3356.093456: xfs_log_reserve: dev 8:33 type DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 2 grant_reserve_bytes 428523008 grant_write_cycle 2 grant_write_bytes 428523008 curr_cycle 2 curr_block 836959 tail_cycle 2 tail_block 810683
> > 
> > Which in this case is: curr_cycle 2 curr_block 836959
> > 
> > When the log IO completes, that value gets written to the
> > l_last_sync_lsn. When the AIL tail is removed, the tail lsn is
> > updated to the new tail item. If the AIL is empty, then the
> > l_last_sync_lsn is used. That means then next dummy transaction
> > made to cover the log should have the cycle/block of the above
> > current cycle.
> > 
> > Instead, what I see is that the next dummmy transaction shows:
> > 
> > >    xfssyncd/sdc1-1413  [000]  3392.067122: xfs_log_reserve: dev 8:33 type DUMMY1 t_ocnt 1 t_cnt 1 t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 2 grant_reserve_bytes 428524032 grant_write_cycle 2 grant_write_bytes 428524032 curr_cycle 2 curr_block 836961 tail_cycle 2 tail_block 810683
> > 
> > The current head has moved: curr_cycle 2 curr_block 836961
> > 
> > But the tail hasn't: tail_cycle 2 tail_block 810683
> > 
> > So effectively we've got some item on the AIL that we haven't
> > flushed and isn't being flushed by xfssyncd. That's the problem I
> > need to get to the bottom of and it also explains why it's an
> > intermitten problem...
> 
> I have been watching the stream of patches that go into 2.6.38,
> but I probably missed the one that might be the answer to the
> problem above. can you please tell me which one to try, or can I
> help with anything?

I know what the problem is, but I haven't had time to work out of
code a fix. Been spending my time trying to work out the cause bugs
that are triggering hangs, crashes or corruptions here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
