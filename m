Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2494A7FF3
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 21:06:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 13F448F8065
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 19:06:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	AVSuV6rpZrS3CJB2 for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 19:06:12 -0700 (PDT)
Date: Thu, 4 Jun 2015 12:03:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Syncd
Message-ID: <20150604020339.GI9143@dastard>
References: <20150410063210.GJ15810@dastard>
	<CABppvi4e_xEMY7tDHtEo6miZcN2AZ-mFMHXKaUS0hfpx6AMt0w@mail.gmail.com>
	<20150410072100.GL13731@dastard>
	<CABppvi437S9e+DEFOi6ECPu8=AnEK0V=5rRmU5Of1_XtWiQbfA@mail.gmail.com>
	<20150410131245.GK15810@dastard>
	<CABppvi68E6n+pr6X8TMOBhicVB4mrJbyyvm89r56rRVqSjf1Zg@mail.gmail.com>
	<20150603035719.GO24666@dastard>
	<CABppvi4AzQyaUm25_ombXR0Om04mUcHKtFd0ug_iKRxqa+NsOg@mail.gmail.com>
	<20150604003546.GS24666@dastard> <20150604012530.GG9143@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150604012530.GG9143@dastard>
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

On Thu, Jun 04, 2015 at 11:25:30AM +1000, Dave Chinner wrote:
> On Thu, Jun 04, 2015 at 10:35:47AM +1000, Dave Chinner wrote:
> > > - Trace cmd report
> > > Too big to attach. Here's a link:
> > > https://www.dropbox.com/s/3xxe2chsv4fsrv8/trace_report.txt.zip?dl=0
> > 
> > Downloading now.
> 
> AIL pushing is occurring every 30s, yes. Across all filesystems, there
> are roughly 23-25,000 metadata objects being pushed every 30s flush.
...
> Indeed, this looks to me like the smoking gun. To allocate a block,
> you have to lock the AGF buffer that the allocation is going to take
> place in. Problem is, when the xfsaild pushes the AGF buffers to the
> writeback queue, they sit there with the buffer locked until the IO
> completes.
> 
> In the traces, the xfsailds all run at 509385s, and immediately I
> see a ~10s gap in the trace where almost no xfs_read_agf() traces
> occur. It's not until 509396s that the traces really start to appear
> at normal speed again.
> 
> Again, reducing the number of AGs will help with this problem,
> simply because the AG headers are more likely to be locked or
> pinned when the xfsaild sweep runs because they are active rather
> than sitting idle waiting for the next operation in that AG to
> require allocation....
> 
> Remember, a single AG can sustain thousands of allocations every
> second - if you are only creating a few thousand files every second,
> you don't need tens of AGs to sustain that - the default of 4 AGs
> will do that just fine...

And in looking deeper into the issue, I think there's some code
changes we need to make to minimise this issue.

Allocation requires a locked AGF buffer, but they also need to be
locked for IO. The underlying issue looks like we hold the lock for
too long durign Io submission. i.e. a list gets passed to the
delayed write submission code, which then walks the list locking the
buffers, then we sort and issue the io on the list. If the writeback
queue is long enough, submission is getting blocked on the request
queue and we wait with locked buffers and hence don't allow
modifications to take place on the buffers while we are waiting for
submission.

Fixing this requires a tweak to the algorithm in
__xfs_buf_delwri_submit() so that we don't lock an entire list of
thousands of IOs before starting submission. In the mean time,
reducing the number of AGs will reduce the impact of this because
the delayed write submission code will skip buffers that are already
locked or pinned in memory, and hence an AG under modification at
the time submission occurs will be skipped by the delwri code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
