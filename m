Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0876C7CA2
	for <xfs@oss.sgi.com>; Sun, 31 Jan 2016 23:28:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 82D99AC002
	for <xfs@oss.sgi.com>; Sun, 31 Jan 2016 21:28:05 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WgTRcBNNoVSagfJL for <xfs@oss.sgi.com>;
	Sun, 31 Jan 2016 21:28:02 -0800 (PST)
Date: Mon, 1 Feb 2016 16:27:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs and swift
Message-ID: <20160201052748.GT6033@dastard>
References: <CAC2B=ZGX2bkEhdgCrpS2X5v+SpAg0jtxZ19vk_9+O9aHME-FSA@mail.gmail.com>
	<20160106220454.GI21461@dastard> <20160106221004.GJ21461@dastard>
	<CAC2B=ZHe+crzN4vTjuNRRFgaxFHDDX2=Jn16EcwY1-ukt1=M6g@mail.gmail.com>
	<20160106234904.GL21461@dastard>
	<CAC2B=ZGktL2XnQEwmSpYxsosqZrvr_zNz_izBAqc+g5Ey4cH8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC2B=ZGktL2XnQEwmSpYxsosqZrvr_zNz_izBAqc+g5Ey4cH8Q@mail.gmail.com>
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
To: Mark Seger <mjseger@gmail.com>
Cc: Laurence Oberman <loberman@redhat.com>, Linux fs XFS <xfs@oss.sgi.com>

On Mon, Jan 25, 2016 at 11:38:07AM -0500, Mark Seger wrote:
> since getting your last reply I've been doing a lot more trying to
> understand the behavior of what I'm seeing by writing some non-swift code
> that sort of does what swift does with respect to a directory structure.
>  in my case I have 1024 top level dirs, 4096 under each.  each 1k file I'm
> creating gets it's only directory under these so there are clearly a lot of
> directories.

I'm not sure you understood what I said in my last reply: your
directory structure is the problem, and that's what needs changing.

> xfs writes out about 25M objects and then the performance goes into the
> toilet.  I'm sure what you said before about having to flush data and
> causing big delays, but would it be continuous?

Go read the previous thread on this subject. Or, alternatively, try
some of the subgestions I made, like reducing the log size, to see
how this affects such behaviour.

> each entry in the
> following table shows the time to write 10K files so the 2 blocks are 1M
> each
> 
> Sat Jan 23 12:15:09 2016
>  16.114386  14.656736  14.789760  17.418389  14.613157  15.938176
>  14.865369  14.962058  17.297193  15.953590
.....
>  62.667990  46.334603  53.546195  69.465447  65.006016  68.761229
>  70.754684  97.571669 104.811261 104.229302
> 105.605257 105.166030 105.058075 105.519703 106.573306 106.708545
> 106.114733 105.643131 106.049387 106.379378

Your test goes from operating wholly in memory to being limited by
disk speed because it no longer fits in memory.

> if I look at the disk loads at the time, I see a dramatic increase in disk
> reads that correspond to the slow writes so I'm guessing at least some
.....
> next I played back the collectl process data and sorted by disk reads and
> discovered the top process, corresponding to the long disk reads was
> xfsaild.  btw - I also see the slab xfs_inode using about 60GB.

And there's your problem. You're accumulating gigabytes of dirty
inodes in memory, then wondering why everything goes to crap when
memory fills up and we have to start cleaning inodes. TO clean those
inodes, we have to do 

RMW cycles on the inode cluster buffers, because the inode cache
memory pressure has caused the inod buffers to be reclaimed from
memory before the cached dirty inodes are written. All the
changes I recommended you make also happen address this problem,
too....

> It's also worth noting that I'm only doing 1-2MB/sec of writes and the rest
> of the data looks like it's coming from xfs journaling because when I look
> at the xfs stats I'm seeing on the order of 200-400MB/sec xfs logging
> writes - clearly they're not all going to disk.

Before delayed logging was introduced 5 years ago, it was quite
common to see XFS writing >500MB/s to the journal. The thing is,
your massive fan-out directory structure is mostly going to defeat
the relogging optimisations that make delayed logging work, so it's
entirely possible that you are seeing this much throughput through
the journal.

> Once the read waits
> increase everything slows down including xfs logging (since it's doing
> less).

Of course, because we can't journal more changes until the dirty
inodes in the journal are cleaned. That's what the xfsaild does -
clean dirty inodes, and the reads coming from that threads are for
cleaning inodes...

> I'm sure the simple answer may be that it is what it is, but I'm also
> wondering without changes to swift itself, might there be some ways to
> improve the situation by adding more memory or making any other tuning
> changes?  The system I'm currently running my tests on has 128GB.

I've already described what you need to do to both the swift
directory layout and the XFS filesystem configuration to minimise
the impact of storing millions of tiny records in a filesystem. I'll
leave the quote from my last email for you:

> > We've been through this problem several times now with different
> > swift users over the past couple of years. Please go and search the
> > list archives, because every time the solution has been the same:
> >
> >         - reduce the directory heirarchy to a single level with, at
> >           most, the number of directories matching the expected
> >           *production* concurrency level
> >         - reduce the XFS log size down to 32-128MB to limit dirty
> >           metadata object buildup in memory
> >         - reduce the number of AGs to as small as necessary to
> >           maintain /allocation/ concurrency to limit the number of
> >           different locations XFS writes to the disks (typically
> >           10-20x less than the application level concurrency)
> >         - use a 3.16+ kernel with the free inode btree on-disk
> >           format feature to keep inode allocation CPU overhead low
> >           and consistent regardless of the number of inodes already
> >           allocated in the filesystem.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
