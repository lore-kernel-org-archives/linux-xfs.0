Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1EI7VY9147346
	for <linux-xfs@oss.sgi.com>; Mon, 14 Feb 2011 12:07:33 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 868E81EAFEA7
	for <linux-xfs@oss.sgi.com>; Mon, 14 Feb 2011 10:10:08 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id UYM4JB4Q1Q84n8P3 for <linux-xfs@oss.sgi.com>;
	Mon, 14 Feb 2011 10:10:08 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Pp2s8-0002TY-TL
	for linux-xfs@oss.sgi.com; Mon, 14 Feb 2011 19:10:05 +0100
Received: from host2.kattenlaw.com ([host2.kattenlaw.com])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 14 Feb 2011 19:10:04 +0100
Received: from brianmduncan by host2.kattenlaw.com with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 14 Feb 2011 19:10:04 +0100
From: Brian Duncan <brianmduncan@gmail.com>
Subject: Re: xfssyncd and disk spin down
Date: Mon, 14 Feb 2011 18:04:23 +0000 (UTC)
Message-ID: <loom.20110214T185310-606@post.gmane.org>
References: <20101223165532.GA23813@peter.simplex.ro>
	<20101227021904.GA24828@dastard>
	<20101227061629.GA2275@pandora.simplex.ro>
	<20101227140750.GB24828@dastard>
	<20101227171939.GA7759@pandora.simplex.ro>
	<20101231001323.GD15179@dastard>
	<20110120100143.GA2007@peter.simplex.ro>
	<20110120234310.GV16267@dastard>
	<20110210204254.GA10451@peter.simplex.ro>
	<20110210221851.GG2559@dastard>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Dave Chinner <david <at> fromorbit.com> writes:

> 
> On Thu, Feb 10, 2011 at 10:42:54PM +0200, Petre Rodan wrote:
> > 
> > Hello Dave,
> > 
> > On Fri, Jan 21, 2011 at 10:43:10AM +1100, Dave Chinner wrote:
> > > .....
> > > > in other words xfsyncd and xfsbufd now alternate at 18s intervals
> > > > keeping the drive busy with nothing constructive hours after the
> > > > last write to the drive.
> > > 
> > > This is a different problem, and not one I've seen before. Looking
> > > at the traces, it appears that we have not empties the AIL. At
> > > least, that's what I'm assuming at this point because log IO
> > > completion is not updating log tail. When we start a log IO, we set
> > > the log header lsn to the current head:
> > > 
> > > >    xfssyncd/sdc1-1413  [000]  3356.093456: xfs_log_reserve: dev 8:33
type DUMMY1 t_ocnt 1 t_cnt 1
> t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_INITED reserveq empty writeq
empty
> grant_reserve_cycle 2 grant_reserve_bytes 428523008 grant_write_cycle 2
grant_write_bytes
> 428523008 curr_cycle 2 curr_block 836959 tail_cycle 2 tail_block 810683
> > > 
> > > Which in this case is: curr_cycle 2 curr_block 836959
> > > 
> > > When the log IO completes, that value gets written to the
> > > l_last_sync_lsn. When the AIL tail is removed, the tail lsn is
> > > updated to the new tail item. If the AIL is empty, then the
> > > l_last_sync_lsn is used. That means then next dummy transaction
> > > made to cover the log should have the cycle/block of the above
> > > current cycle.
> > > 
> > > Instead, what I see is that the next dummmy transaction shows:
> > > 
> > > >    xfssyncd/sdc1-1413  [000]  3392.067122: xfs_log_reserve: dev 8:33
type DUMMY1 t_ocnt 1 t_cnt 1
> t_curr_res 2740 t_unit_res 2740 t_flags XLOG_TIC_INITED reserveq empty writeq
empty
> grant_reserve_cycle 2 grant_reserve_bytes 428524032 grant_write_cycle 2
grant_write_bytes
> 428524032 curr_cycle 2 curr_block 836961 tail_cycle 2 tail_block 810683
> > > 
> > > The current head has moved: curr_cycle 2 curr_block 836961
> > > 
> > > But the tail hasn't: tail_cycle 2 tail_block 810683
> > > 
> > > So effectively we've got some item on the AIL that we haven't
> > > flushed and isn't being flushed by xfssyncd. That's the problem I
> > > need to get to the bottom of and it also explains why it's an
> > > intermitten problem...
> > 
> > I have been watching the stream of patches that go into 2.6.38,
> > but I probably missed the one that might be the answer to the
> > problem above. can you please tell me which one to try, or can I
> > help with anything?
> 
> I know what the problem is, but I haven't had time to work out of
> code a fix. Been spending my time trying to work out the cause bugs
> that are triggering hangs, crashes or corruptions here...
> 
> Cheers,
> 
> Dave.


FYI,

I found this thread after searching.. I upgraded one of my servers and
encountered this issue with XFS keeping drives from going to sleep with its
constant writing (after a copy to a volume).

I just wanted to note that I have an XFS volume that does have lazy-count set to
1 that this is occuring with, with 2.6.327. 

meta-data=/dev/sdf1              isize=256    agcount=4, agsize=122094500 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=488378000, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=238465, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

After writing any data to this drive, this would occur indefinitely:(until I
unmount and remount the drive)

[ 2839.120064] xfssyncd/sdf1(756): WRITE block 1954432155 on sdf1 (2 sectors)
[ 2869.120065] xfssyncd/sdf1(756): WRITE block 1954432157 on sdf1 (2 sectors)
[ 2899.120066] xfssyncd/sdf1(756): WRITE block 1954432159 on sdf1 (2 sectors)
[ 2929.120065] xfssyncd/sdf1(756): WRITE block 1954432161 on sdf1 (2 sectors)
[ 2959.120060] xfssyncd/sdf1(756): WRITE block 1954432163 on sdf1 (2 sectors)
[ 2989.120061] xfssyncd/sdf1(756): WRITE block 1954432165 on sdf1 (2 sectors)
[ 3019.120058] xfssyncd/sdf1(756): WRITE block 1954432167 on sdf1 (2 sectors)
[ 3049.120056] xfssyncd/sdf1(756): WRITE block 1954432169 on sdf1 (2 sectors)
[ 3079.120058] xfssyncd/sdf1(756): WRITE block 1954432171 on sdf1 (2 sectors)
[ 3109.120059] xfssyncd/sdf1(756): WRITE block 1954432173 on sdf1 (2 sectors)
[ 3139.120065] xfssyncd/sdf1(756): WRITE block 1954432175 on sdf1 (2 sectors)
[ 3169.120061] xfssyncd/sdf1(756): WRITE block 1954432177 on sdf1 (2 sectors)
[ 3199.120062] xfssyncd/sdf1(756): WRITE block 1954432179 on sdf1 (2 sectors)
[ 3229.120060] xfssyncd/sdf1(756): WRITE block 1954432181 on sdf1 (2 sectors)
[ 3259.120067] xfssyncd/sdf1(756): WRITE block 1954432183 on sdf1 (2 sectors)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
