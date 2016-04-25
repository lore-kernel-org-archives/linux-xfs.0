Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D7607CA0
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 18:09:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 03D4E304039
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 16:09:25 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	3KquPuu23frOQb7N for <xfs@oss.sgi.com>;
	Mon, 25 Apr 2016 16:09:19 -0700 (PDT)
Date: Tue, 26 Apr 2016 09:08:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: idle aild if the AIL is pushed up to the target LSN
Message-ID: <20160425230833.GC18496@dastard>
References: <1461570163-4083-1-git-send-email-dev@lynxeye.de>
	<20160425142444.GC33882@bfoster.bfoster>
	<1461607897.2364.27.camel@lynxeye.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461607897.2364.27.camel@lynxeye.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Lucas Stach <dev@lynxeye.de>
Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Apr 25, 2016 at 08:11:37PM +0200, Lucas Stach wrote:
> Am Montag, den 25.04.2016, 10:24 -0400 schrieb Brian Foster:
> > On Mon, Apr 25, 2016 at 09:42:43AM +0200, Lucas Stach wrote:
> > > 
> > > The current logic only idles aild if the AIL is empty, rescheduling
> > > the worker with a timeout of 50ms otherwise. If the target LSN
> > > isn't
> > > moved forward, the worker will not make any progress as it only
> > > pushes the AIL up to the target LSN, leading to the empty AIL
> > > condition to only be met after the log worker pushed the complete
> > > AIL. As the log worker runs on the scale of minutes, this leaves
> > > aild in the "no progress, 50ms timeout" state for extended periods
> > > of
> > > time, causing many unecessary wakeups.
> > > 
> > Where do you get the "scale of minutes" from? I believe the default
> > log
> > worker interval is 30s, though it can be increased by the admin.
> > 
> Uh, right. It's 30s, which is still a very long time when we consider
> that new items can be added to the AIL right after the log worker
> forced it out.

Standard writeback timeout for data and metadata.

> > The other thing to note is that the AIL target is also driven by
> > demand
> > on log space. E.g., see xlog_grant_push_ail(), which executes when a
> > transaction attempts to reserve log space that isn't currently
> > available
> > in the log.
> > 
> And that's where I think the problem stems from: the above function
> pushes the AIL only up to a target LSN to make room for the required
> log space. Only the log worker empties the AIL completely by issuing a
> xfs_ail_push_all_sync().

xfs_ail_push_all(), actually, and the log worker runs every 30s by
default. i.e. we move the target to the end to the AIL to try to
empty it completely every 30s.

> > That said, I'm not sure whether there's a notable benefit of idling
> > for
> > 50ms over just scheduling out when we've hit the target lsn. It seems
> > like that anybody who pushes the target forward again is going to
> > wake
> > up the thread anyways. On the other hand, if the fs is idle the
> > thread
> > will eventually schedule out indefinitely. 
> 
> Is this a problem? The patch tries to do exactly that: schedule out
> aild indefinitely when there is no more work to do as nobody is pushing
> the target LSN forward.

If the filesystem is slowly being dirtied, then the aild should't
really idle at all.i

Keep in mind that the xfsaild has multiple functions, one of which
is a watchdog that catches log space stalls that would otherwise
hang the filesystem. Every time we've removed the watchdog function
(i.e.  agressively idle the aild) we've had users report random,
unreproducable hangs/stalls that have gone away when the watchdog
function (i.e. don't idle until the log is covered and completely
idle) was re-instated...

> On an idle FS this will stop aild when the target LSN is hit, will wake
> it up again as soon as the log worker requests the complete AIL to be
> pushed out, then it goes back to sleep indefinitely until the log fills
> up again.

The behaviour suggests that your filesystem is not idle. The
filesystem takes up to 90s to be marked idle (log needs to be
covered, state machine takes 3x30s cycles to transition to idle
"covered" state.

If you want the filesytsem to idle quickly, then run the log worker
more frequently to get the target updated more quickly. This will
also speed up the log covering state machine as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
