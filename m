Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BF3137F50
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 15:48:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9148D304066
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 13:48:29 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Ym3G8AHq35F3YMiQ for <xfs@oss.sgi.com>;
	Sat, 21 Feb 2015 13:48:25 -0800 (PST)
Date: Sun, 22 Feb 2015 08:48:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150221214823.GJ12722@dastard>
References: <20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<201502201936.HBH34799.SOLFFFQtHOMOJV@I-love.SAKURA.ne.jp>
	<20150220231511.GH12722@dastard>
	<201502212012.BJJ39083.LQFOtJFSHMVOFO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201502212012.BJJ39083.LQFOtJFSHMVOFO@I-love.SAKURA.ne.jp>
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
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: hannes@cmpxchg.org, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Sat, Feb 21, 2015 at 08:12:08PM +0900, Tetsuo Handa wrote:
> My main issue is
> 
>   c) whether to oom-kill more processes when the OOM victim cannot be
>      terminated presumably due to the OOM killer deadlock.
> 
> Dave Chinner wrote:
> > On Fri, Feb 20, 2015 at 07:36:33PM +0900, Tetsuo Handa wrote:
> > > Dave Chinner wrote:
> > > > I really don't care about the OOM Killer corner cases - it's
> > > > completely the wrong way line of development to be spending time on
> > > > and you aren't going to convince me otherwise. The OOM killer a
> > > > crutch used to justify having a memory allocation subsystem that
> > > > can't provide forward progress guarantee mechanisms to callers that
> > > > need it.
> > > 
> > > I really care about the OOM Killer corner cases, for I'm
> > > 
> > >   (1) seeing trouble cases which occurred in enterprise systems
> > >       under OOM conditions
> > 
> > You reach OOM, then your SLAs are dead and buried. Reboot the
> > box - its a much more reliable way of returning to a working system
> > than playing Russian Roulette with the OOM killer.
> 
> What Service Level Agreements? Such troubles are occurring on RHEL systems
> where users are not sitting in front of the console. Unless somebody is
> sitting in front of the console in order to do SysRq-b when troubles
> occur, the down time of system will become significantly longer.
>
> What mechanisms are available for minimizing the down time of system
> when troubles under OOM condition occur? Software/hardware watchdog?
> Indeed they may help, but they may be triggered prematurely when the
> system has not entered into the OOM condition. Only the OOM killer knows.

# echo 1 > /proc/sys/vm/panic_on_oom

....

> We have memory cgroups to reduce the possibility of triggering the OOM
> killer, though there will be several bugs remaining in RHEL kernels
> which make administrators hesitate to use memory cgroups.

Fix upstream first, then worry about vendor kernels.

....

> Not only we cannot expect that the OOM killer messages being saved to
> /var/log/messages under the OOM killer deadlock condition, but also

CONFIG_PSTORE=y and configure appropriately from there.

> we do not emit the OOM killer messages if we hit

So add a warning.

> If you want to stop people from playing Russian Roulette with the OOM
> killer, please remove the OOM killer code entirely from RHEL kernels so that
> people must use their systems with hardcoded /proc/sys/vm/panic_on_oom == 1
> setting. Can you do it?

No. You need to go through vendor channels to get a vendor kernel
config change made.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
