Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2B3527FE6
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 20:39:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1978D304032
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 18:39:02 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	djJHWRgsv41xNvuJ for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 18:39:00 -0700 (PDT)
Date: Thu, 4 Jun 2015 11:25:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Syncd
Message-ID: <20150604012530.GG9143@dastard>
References: <CABppvi6pC4qEFZUTesbT0v5agbd67MP4dEoUbaVFwEyCv4h21g@mail.gmail.com>
	<20150410063210.GJ15810@dastard>
	<CABppvi4e_xEMY7tDHtEo6miZcN2AZ-mFMHXKaUS0hfpx6AMt0w@mail.gmail.com>
	<20150410072100.GL13731@dastard>
	<CABppvi437S9e+DEFOi6ECPu8=AnEK0V=5rRmU5Of1_XtWiQbfA@mail.gmail.com>
	<20150410131245.GK15810@dastard>
	<CABppvi68E6n+pr6X8TMOBhicVB4mrJbyyvm89r56rRVqSjf1Zg@mail.gmail.com>
	<20150603035719.GO24666@dastard>
	<CABppvi4AzQyaUm25_ombXR0Om04mUcHKtFd0ug_iKRxqa+NsOg@mail.gmail.com>
	<20150604003546.GS24666@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150604003546.GS24666@dastard>
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

On Thu, Jun 04, 2015 at 10:35:47AM +1000, Dave Chinner wrote:
> > - Trace cmd report
> > Too big to attach. Here's a link:
> > https://www.dropbox.com/s/3xxe2chsv4fsrv8/trace_report.txt.zip?dl=0
> 
> Downloading now.

AIL pushing is occurring every 30s, yes. Across all filesystems, there
are roughly 23-25,000 metadata objects being pushed every 30s flush.

Think about that for a moment.

You have a write once workload, so inode metadata is journalled and
written only once. Hence if you are creating 1000 files/s, then you
have at least 30,000 inodes to push every 30s.

but that's not actually the big problem. Of the two ail push events
in the trace, there are this many objects that we attempt to push:

$ wc -l t.t
45149 t.t

And this many inodes:

$ grep INODE t.t | wc -l
11512

Now, XFS has inode clustering on writeback and that is active; it is
reducing the number of inode IOs by a factor of roughly 10. So that
means that every 30s, we've only got ~600 IOs across 8 disks
to write back dirty inodes. i.e. less than a second worth of random
IO. That's not the problem we are looking for.

Buffers, OTOH:

$ grep BUF t.t | wc -l
33637

So call it 17,000 every 30 seconds. That requires 17,000 4k IOs.
Across 8 disks at 170 IOPS, that is *exactly* 12.5 seconds worth of
IO.

Looks to me like the buffers are mostly inode btree. free space
btree and directory buffers.

Directory buffers, well, that's where increasing the directory block
size might help (e.g. to 8k). That may well reduce the number of
directory buffers by more than a factor of 2 due to the structure of
the directories. Depends on how many files you have in each
directory....

The number of inode and alloc btree buffers can be reduced by
reducing the number of AGs - probably by a factor of 10 by bringing
the AG count down to 4. And, because the active inode and freespace
btree buffers will be hotter, they are more likely just to be
relogged than written back, further reducing IOs.

Indeed, this looks to me like the smoking gun. To allocate a block,
you have to lock the AGF buffer that the allocation is going to take
place in. Problem is, when the xfsaild pushes the AGF buffers to the
writeback queue, they sit there with the buffer locked until the IO
completes.

In the traces, the xfsailds all run at 509385s, and immediately I
see a ~10s gap in the trace where almost no xfs_read_agf() traces
occur. It's not until 509396s that the traces really start to appear
at normal speed again.

Again, reducing the number of AGs will help with this problem,
simply because the AG headers are more likely to be locked or
pinned when the xfsaild sweep runs because they are active rather
than sitting idle waiting for the next operation in that AG to
require allocation....

Remember, a single AG can sustain thousands of allocations every
second - if you are only creating a few thousand files every second,
you don't need tens of AGs to sustain that - the default of 4 AGs
will do that just fine...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
