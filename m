Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 569AE7F9E
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 08:12:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3445E8F8065
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 06:12:50 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	fAl6u5w8CiEIhFuW for <xfs@oss.sgi.com>;
	Fri, 10 Apr 2015 06:12:48 -0700 (PDT)
Date: Fri, 10 Apr 2015 23:12:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Syncd
Message-ID: <20150410131245.GK15810@dastard>
References: <CABppvi6pC4qEFZUTesbT0v5agbd67MP4dEoUbaVFwEyCv4h21g@mail.gmail.com>
	<20150410063210.GJ15810@dastard>
	<CABppvi4e_xEMY7tDHtEo6miZcN2AZ-mFMHXKaUS0hfpx6AMt0w@mail.gmail.com>
	<20150410072100.GL13731@dastard>
	<CABppvi437S9e+DEFOi6ECPu8=AnEK0V=5rRmU5Of1_XtWiQbfA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABppvi437S9e+DEFOi6ECPu8=AnEK0V=5rRmU5Of1_XtWiQbfA@mail.gmail.com>
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
To: Shrinand Javadekar <shrinand@maginatics.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 10, 2015 at 12:29:34AM -0700, Shrinand Javadekar wrote:
> On Fri, Apr 10, 2015 at 12:21 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Apr 09, 2015 at 11:51:17PM -0700, Shrinand Javadekar wrote:
> >> Thanks for the reply Dave!
> >>
> >> >
> >> > Oh, right, it's that workqueue we removed in late 2012 (in the 3.7
> >> > cycle) because it was redundant. The only remaining fragment of it
> >> > is the xfslogd. What kernel are you running?
> >>
> >> I am running 3.13.0-39-generic on Ubuntu 14.04.
> >
> > You can't be running that kernel if you are seeing a process called
> > xfssyncd in your traces.
> 
> I don't see a process called xfssyncd. I started investigating the 30
> second pauses but looking for xfs config options in sysctl. We found
> the option "fs.xfs.xfssyncd_centisecs" whose documentation[1] says it
> is the interval in which the "filesystem flushes metadata out to disk
> and runs internal cache cleanup routines".

Right, that's what it does, but even though xfssynd has been
removed, we can't remove or rename the sysctl because it's part
of the userspace ABI.

> I tweaked this setting and saw the corresponding changes in the
> performance. Bumping this value up saw pauses at longer interval,
> decreasing this interval saw pauses more frequently.

Ok, so it's not speculative preallocation that is the problem,
it's metadata writeback that is causing the stalls. I forgot the log
worker is also triggered of that sysctl, and so...

> >> >> I am seeing a behavior where the system pretty much stalls for ~5
> >> >> seconds after every 30 seconds. I see that the # of ios goes up but
> >> >> the actual write bandwidth during this 5 second period is very low
> >> >> (see attached images). After a fair bit of investigation, we've
> >> >> narrowed down the problem to XFS's syncd (fs.xfs.xfssyncd_centisecs).
> >> >> This runs at a default interval of 30 seconds.
> >> >
> >> > It's doing background inode reclaim which, under some circumstances,
> >> > involves truncating specualtive allocation beyond EOF before reclaim
> >> > occurs, which results in transactions and inode writeback. It was
> >> > highly inefficient, which is why we replaced it.
> >>
> >> Oh.. I see. So, this isn't even actual filesystem metadata. And there
> >> is no option to turn the speculative allocation on/off?
> >
> > You can turn it off, but now you're jumping to conclusions that this
> > is the cause of your problems. Perhaps you should do some
> > tracing/profiling whenthe system goes through these stalls to see
> > what is actually happening? "perf top" and trace-cmd are very useful
> > for this sort of investigation...
> 
> Let me dig deeper here using "perf top" and see what's running during
> these stalls.

... it's much more likely that filesystem metadata writeback is
being run every 30s, and that's what is causing the issue. i.e. you
should see the xfsaild issuing lots of IO very quickly.

See, fsync() doesn't cause metadata writeback; only data writeback.
The metadata is written to the log, not it's final place on disk
during fsync. So some time later it's got to me written back because
it is still dirty in memory, and that's most likely what is
happening.

My guess is you have RAID5 or RAID6 and the partial stripe writes
are causing it to do RMW cycles and hence it's really, really slow
when metadata gets written...

Probably too late now as I've now basically asked for all this info,
but:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
