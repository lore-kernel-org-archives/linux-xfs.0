Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C038B7F9E
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 22:57:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3BDEEAC001
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 20:57:25 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	1QT16Cfx65TC16dW for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 20:57:22 -0700 (PDT)
Date: Wed, 3 Jun 2015 13:57:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Syncd
Message-ID: <20150603035719.GO24666@dastard>
References: <CABppvi6pC4qEFZUTesbT0v5agbd67MP4dEoUbaVFwEyCv4h21g@mail.gmail.com>
	<20150410063210.GJ15810@dastard>
	<CABppvi4e_xEMY7tDHtEo6miZcN2AZ-mFMHXKaUS0hfpx6AMt0w@mail.gmail.com>
	<20150410072100.GL13731@dastard>
	<CABppvi437S9e+DEFOi6ECPu8=AnEK0V=5rRmU5Of1_XtWiQbfA@mail.gmail.com>
	<20150410131245.GK15810@dastard>
	<CABppvi68E6n+pr6X8TMOBhicVB4mrJbyyvm89r56rRVqSjf1Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABppvi68E6n+pr6X8TMOBhicVB4mrJbyyvm89r56rRVqSjf1Zg@mail.gmail.com>
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

On Tue, Jun 02, 2015 at 11:43:30AM -0700, Shrinand Javadekar wrote:
> Sorry, I dropped the ball on this one. We found some other problems
> and I was busy fixing them.
> 
> So, the xfsaild thread/s that kick in every 30 seconds are hitting us
> pretty badly. Here's a graph with the latest tests I ran. We get great
> throughput for ~18 seconds but then the world pretty much stops for
> the next ~12 seconds or so making the final numbers look pretty bad.
> This particular graph was plotted when the disk had ~150GB of data
> (total capacity of 3TB).
> 
> I am using a 3.16.0-38-generic kernel (upgraded since the time I wrote
> the first email on this thread).
> 
> I know fs.xfs.xfssyncd_centisecs controls this interval of 30 seconds.
> What other options can I tune for making this work better?
> 
> We have 8 disks. And unfortunately, all 8 disks are brought to a halt
> every 30 seconds. Does XFS have options to only work on a subset of
> disks at a time?
> 
> Also, what does XFS exactly do every 30 seconds? If I understand it
> right, metadata can be 3 locations:
> 
> 1. Memory
> 2. Log buffer on disk
> 3. Final location on disk.
> 
> Every 30 seconds, from where to where is this metadata being copied?
> Are there ways to just disable this to avoid the stop-of-the-world
> pauses (at the cost of lower but sustained performance)?

I can't use this information to help you as you haven't presented
any of the data I've asked for.  We need to restart here and base
everything on data and observation. i.e. first principles.

Can you provide all of the information here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

and most especially the iostat and vmstat outputs while the problem
is occurring. The workload description is not what is going wrong
or what you think is happening, but a description of the application
you are running that causes the problem.

This will give me a baseline of your hardware, the software, the
behaviour and the application you are running, and hence give me
something to start with.

I'd also like to see the output from perf top while the problem is
occurring, so we might be able to see what is generating the IO...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
