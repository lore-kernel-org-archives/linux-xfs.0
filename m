Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q72AdNqK161291 for <xfs@oss.sgi.com>; Thu, 2 Aug 2012 05:39:23 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id WAmYiBMCU4pTb4R1
	for <xfs@oss.sgi.com>; Thu, 02 Aug 2012 03:39:22 -0700 (PDT)
Message-ID: <501A58DB.7070801@hardwarefreak.com>
Date: Thu, 02 Aug 2012 05:39:23 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: realtime section bugs still around
References: <CAGou9MgezsS=2+SngGWBJv5Npsuqacx1VPJwvMuf0FS+XnXt8A@mail.gmail.com>
	<20120730030333.GE2877@dastard>
	<CAGou9MheeBWxajd65szNfDB2L+VVoZ7SypEdUKj7np3L0H8fHA@mail.gmail.com>
	<CAGou9MgMHbTPebFUDXdyLvrUr4T9wo-geNtaPUft9uUmOaju6Q@mail.gmail.com>
	<50186E51.1020107@hardwarefreak.com>
	<CAGou9MhneejOuhX4c8G06c3Zh7dxF-OtZ+=mT-7fho_u1Q3zWw@mail.gmail.com>
	<5018A8C7.8050406@hardwarefreak.com>
	<CAGou9Mj=8xcF4YwaSQYp0_BbJW_Ms1sasDDRNxL1oh0oR7zupw@mail.gmail.com>
	<5019CC34.5050003@hardwarefreak.com>
	<CAGou9Mg4teJU3VHWxDK3-y1MMxN_FQ-Dpk3E1KzX0pNdLEHNOQ@mail.gmail.com>
In-Reply-To: <CAGou9Mg4teJU3VHWxDK3-y1MMxN_FQ-Dpk3E1KzX0pNdLEHNOQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: Jason Newton <nevion@gmail.com>
Cc: xfs@oss.sgi.com

On 8/1/2012 9:38 PM, Jason Newton wrote:

> The system has a single slot of SODIMM. We have an 8GB DDR3 stick in it.
> I've added a circular buffer for each frame and limit it to some number of
> frames (so far 2 seconds, I haven't had time to experiment with it yet).
> The serialization thread is now separate and consumes the circular buffer
> so we're effectively talking about the same thing sans files.  This solves
> the problem but as I mentioned before... 

Same idea, but your solution is far more elegant I think.

> I do have a desire to seek out the
> sources of the latency and cpu usage... I'm not really sure of how to go
> about it though.

We already gave you the biggest cause of your latency, which is garbage
collection/wear leveling.  You can't see inside the SSDs, but you can
see the latency jump with either top (%wa) or iostat (await,
milliseconds).  Run

iostat -x -d 1 20

and you get 20 reports 1 second apart.  1s is minimum granularity.  This
should clearly show the latency spikes caused by the SSDs.  Maybe even
execute it for 60 seconds and pipe to a file.

Regarding CPU burn, the quickest, and probably least exact, way to see
this is with top.  On Linux sorting top by CPU usage should be the
default.  If not just hit Shift+P to toggle to that sort method.  This
should be sufficient to find out who is eating the cycles.  I'd think
running top and iostat while pushing 3 streams should do the trick.  But
I'm sure you've already looked at top.  Which makes me wonder why you
were unable to see what's burning the cycles.

> Agreed that it's the easiest and cheapest solution. Average performance
> probably won't change but burst of cpu will as it compensates for the high
> latency writes in future cycles... this is undesirable but I think OK (the
> important stuff is at high priority on SCHED_RR, these serialization
> threads are high priority SCHED_OTHER).  Again, I haven't had time to test
> it as I've been putting out other fires.

Keep us posted.  BTW, do you mind sharing the make/model of that mobo,
and exactly which model that i7 is?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
